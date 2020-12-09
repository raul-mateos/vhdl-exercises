library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_uart is
  port (
    clk             : in  std_logic;
    rst             : in  std_logic;
    enable          : in  std_logic;
    baud_rate       : in  std_logic_vector(15 downto 0);
    tx_byte         : in  std_logic_vector(7 downto 0);
    tx_rqt          : in  std_logic;
    tx_ack          : out std_logic;
    txd             : out std_logic);
end entity;

architecture rtl of tx_uart is
  type state_type is (
  -- pragma translate_off
    stop,
  -- pragma translate_on
    idle,
    send_start,
    send_data,
    send_parity,
    send_stop);
  signal state  : state_type;

  signal prescaler_cnt : unsigned(15 downto 0);
  signal prescaler_end : std_logic;

  signal cnt_clr  : std_logic;
  
  signal bit_cnt    : unsigned(2 downto 0);
  signal bit_inc    : std_logic;
  signal bit_end    : std_logic;
  signal bit_clr    : std_logic;

  signal shift_reg  : std_logic_vector(7 downto 0);
  signal shift_ld   : std_logic;
  signal shift_en   : std_logic;

  signal parity     : std_logic;

  constant EVEN_PARITY  : std_logic := '1';
  
begin
  -- Contador para control duración de un bit:
  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(cnt_clr = '1' or prescaler_end = '1') then
        prescaler_cnt <= unsigned(baud_rate);
      else
        prescaler_cnt <= prescaler_cnt - 1;
      end if; 
    end if;
  end process;

  prescaler_end <= '1' when (prescaler_cnt = 0) else '0';

  -- Contador de bits:
  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(cnt_clr = '1' or (bit_inc and bit_end) = '1') then
        bit_cnt <= (others => '0');
      elsif(bit_inc = '1') then
        bit_cnt <= bit_cnt + 1;
      end if; 
    end if;
  end process;

  bit_end <= '1' when (bit_cnt = 7) else '0';

  -- FSM: Control de transiciones:
  process(clk, rst)
  begin
    if(rst = '1') then
      state <= idle;
    elsif(clk'event and clk = '1') then
      case state is
        when idle =>
          if(tx_rqt = '1' and enable = '1') then
            state <= send_start;
          end if;
        when send_start =>
          if(prescaler_end = '1') then
            state <= send_data;
          end if;
        when send_data =>
          if(prescaler_end = '1' and bit_end = '1') then
            state <= send_parity;
          end if;
        when send_parity =>
          if(prescaler_end = '1') then
            state <= send_stop;
          end if;
        when send_stop =>
          if(prescaler_end = '1') then
            state <= idle;
          end if;
        when others =>
      end case; 
    end if;
  end process;

  -- FSM: Control de salidas:
  process(state, tx_rqt, enable, prescaler_end, shift_reg, parity)
  begin
    cnt_clr <= '0';
    bit_inc <= '0';    
    shift_ld <= '0';
    shift_en <= '0';
    tx_ack <= '0';
    txd <= '1';
    case state is
      when idle =>
        cnt_clr <= '1';
        shift_ld <= tx_rqt and enable;
      when send_start =>
        txd <= '0';
      when send_data =>
        shift_en <= prescaler_end;
        bit_inc <= prescaler_end;
        txd <= shift_reg(0);
      when send_parity =>
        txd <= parity;
      when send_stop =>
        txd <= '0';
        tx_ack <= prescaler_end;

      when others =>
    end case; 

  end process;

  -- Registro de desplazamiento:
  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(shift_ld = '1') then
        shift_reg <= tx_byte;
      elsif(shift_en = '1') then
        shift_reg <= '0' & shift_reg(7 downto 1);
      end if; 
    end if;
  end process;

--  -- Bloque combinacional para cálculo de paridad:
--  process(tx_byte)
--    variable aux : std_logic;
--  begin
--    aux := '0';  
--    for i in 0 to 7 loop
--      aux := aux xor tx_byte(i);
--    end loop;
--    -- Paridad par:
--    parity <= not(aux);
--  end process;

  -- Cálculo de la paridad: solución secuencial
  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(shift_ld = '1') then
        parity <= EVEN_PARITY;
      elsif(shift_en = '1') then
        parity <= parity xor shift_reg(0);
      end if; 
    end if;
  end process;
  
  
end rtl;

