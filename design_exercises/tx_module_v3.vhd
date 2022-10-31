library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_module_v3 is
  port (
    rst           : in  std_logic;
    clk           : in  std_logic;
    
    usr_din       : in  std_logic_vector(7 downto 0);
    usr_rqt       : in  std_logic;
    usr_ack       : out std_logic;
    txd           : out std_logic;
    tx_frame      : out std_logic;
    tx_clk        : out std_logic);
end entity;

architecture rtl of tx_module_v3 is

  signal shift_reg  : std_logic_vector(7 downto 0);
  signal shift_ld   : std_logic;
  signal shift_en   : std_logic;

  type state_type is (
    idle,
    txing);

  signal state : state_type;
    
  signal cnt_clr  : std_logic;
  signal bit_cnt  : unsigned(2 downto 0);
  signal bit_tc   : std_logic;
  signal bit_ceo  : std_logic;

  
  constant L : integer := 3;  
  signal len_cnt  : unsigned(9 downto 0);
  signal len_tc   : std_logic;

  signal hb_cnt   : std_logic;
  signal hb_ceo   : std_logic;
      
begin

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (shift_ld = '1') then
        shift_reg <= usr_din;
      elsif(shift_en = '1') then
        shift_reg <= '0' & shift_reg(7 downto 1);
      end if;
    end if;
  end process;
  
  txd <= shift_reg(0);

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (cnt_clr = '1' or len_tc = '1') then
        len_cnt <= to_unsigned(L-1, len_cnt'length);
      else
        len_cnt <= len_cnt - 1;
      end if;
    end if;
  end process;
  
  len_tc <= '1' when (len_cnt = 0) else '0';
  
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (cnt_clr = '1') then
        hb_cnt <= '0';
      elsif(len_tc = '1') then
        hb_cnt <= not(hb_cnt);
      end if;
    end if;
  end process;
  
  hb_ceo <= len_tc and hb_cnt;
  
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (cnt_clr = '1') then
        bit_cnt <= (others => '0');
      elsif(hb_ceo = '1') then
        bit_cnt <= bit_cnt + 1;
      end if;
    end if;
  end process;
  
  --bit_tc <= '1' when (bit_cnt = 7) else '0';
  --bit_ceo <= hb_ceo and bit_tc;
  bit_ceo <= hb_ceo when (bit_cnt = 7) else '0';
  
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst = '1') then
        state <= idle;
      else
        case state is
          when idle =>
            if (usr_rqt = '1') then
              state <= txing;
            end if;
          when txing =>
            if (bit_ceo = '1') then
              state <= idle;
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process(state, usr_rqt, hb_ceo, bit_ceo, hb_cnt)
  begin
    shift_ld <= '0';
    shift_en <= '0';
    cnt_clr <= '0';
    usr_ack <= '0';
    tx_frame <= '0';
    tx_clk <= '0';
    
    case state is
      when idle =>
        shift_ld <= usr_rqt;
        cnt_clr <= '1';
      when txing =>
        shift_en <= hb_ceo;
        usr_ack <= bit_ceo;
        tx_frame <= '1';
        tx_clk <= not(hb_cnt);
      when others => null;
    end case;
  end process;
  

end rtl;

