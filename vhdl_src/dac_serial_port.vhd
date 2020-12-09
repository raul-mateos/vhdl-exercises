library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dac_serial_port is
  generic (
    C_CLK_PERIOD_PS   : integer;
    C_SCLK_PERIOD_PS  : integer);
  port (
    rst         : in  std_logic;
    clk         : in  std_logic;

    data_in     : in  std_logic_vector(11 downto 0);
    tx_rqt      : in  std_logic;
    tx_ack      : out std_logic;
    
    dac_sclk    : out std_logic;
    dac_din     : out std_logic;
    dac_sync_n  : out std_logic);
end entity;

architecture rtl of dac_serial_port is

  function div_round_up(t : integer; Tclk : integer) return integer is
  begin
    return (t + Tclk-1) / Tclk;
  end function div_round_up;


  signal din    : std_logic;
  signal sclk   : std_logic;
  signal sync_n : std_logic;

  constant HALF_BIT_FACTOR  : integer := div_round_up(C_SCLK_PERIOD_PS/2, C_CLK_PERIOD_PS);
--  constant HALF_BIT_CNT_WIDTH : integer := log2(HALF_BIT_FACTOR);

  signal half_bit_cnt : integer range 0 to HALF_BIT_FACTOR-1;
  signal half_bit_end : std_logic;

  signal bit_cnt      : unsigned(4 downto 0);
  signal last_bit     : std_logic;
  
  type state_type is (
    idle, 
    transmit);
  signal state : state_type;

  signal cnt_clr    : std_logic;
  signal shift_load : std_logic;
  signal shift_en   : std_logic;
  signal shift_reg  : std_logic_vector(15 downto 0);
  
begin

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(cnt_clr = '1' or half_bit_end = '1') then
        half_bit_cnt <= HALF_BIT_FACTOR-1;
        half_bit_end <= '0';
      else  
        half_bit_cnt <= half_bit_cnt - 1;
        if(half_bit_cnt = 1) then
          half_bit_end <= '1';
        else
          half_bit_end <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(cnt_clr = '1') then
        bit_cnt <= (others => '1');
        last_bit <= '0';
      elsif(half_bit_end = '1') then
        bit_cnt <= bit_cnt - 1;
        if(bit_cnt = 1) then
          last_bit <= '1';
        else
          last_bit <= '0';
        end if;
      end if;
    end if;
  end process;
  
  process(clk, rst)
  begin
    if(rst = '1') then
      state <= idle;
    elsif(clk'event and clk = '1') then
      case state is
        when idle =>
          if(tx_rqt = '1') then
            state <= transmit;
          end if;
        when transmit =>
          if(half_bit_end = '1' and last_bit = '1') then
            state <= idle;
          end if;
        when others =>
      end case; 
    end if;
  end process;

  process(state, tx_rqt, bit_cnt, half_bit_end)
  begin
    cnt_clr <= '0';
    sync_n <= '1';
    sclk <= '0';
    
    shift_en <= '0';
    shift_load <= '0';
    
    tx_ack <= '0';
    case state is
      when idle =>
        cnt_clr <= '1';
        shift_load <= tx_rqt;
      when transmit =>
        sync_n <= '0';
        sclk <= bit_cnt(0);
        shift_en <= half_bit_end and not(bit_cnt(0));
        
        tx_ack <= half_bit_end and last_bit;
      when others =>
    end case; 
  end process;

  process(clk, rst)
  begin
    if(rst = '1') then
      shift_reg <= (others => '0');
    elsif(clk'event and clk = '1') then
      if(shift_load = '1') then
        shift_reg <= "0000" & data_in;
      elsif(shift_en = '1') then
        shift_reg <= shift_reg(14 downto 0) & '0';
      end if;
    end if;
  end process;
  
  din <= shift_reg(15);

  process(clk, rst)
  begin
    if(rst = '1') then
      dac_sclk <= '0';
      dac_din <= '0';
      dac_sync_n <= '1';
    elsif(clk'event and clk = '1') then
      dac_sclk <= sclk;
      dac_din <= din;
      dac_sync_n <= sync_n;
    end if;
  end process;
  
end rtl;

