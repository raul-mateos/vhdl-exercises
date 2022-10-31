library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_module_v3 is
  port (
    rst           : in  std_logic;
    clk           : in  std_logic;
    ---    
    rxd           : in  std_logic;
    rx_frame      : in  std_logic;
    rx_clk        : in  std_logic;
    dout          : out std_logic_vector(7 downto 0);
    dout_vld      : out std_logic);
end entity;

architecture rtl of rx_module_v3 is
  signal rx_clk_r   : std_logic;
  signal neg_edge   : std_logic;


  signal shift_en   : std_logic;
  signal shift_reg  : std_logic_vector(7 downto 0);
    
  signal bit_clr  : std_logic;
  signal bit_cnt  : unsigned(2 downto 0);
  signal bit_ceo  : std_logic;
  
begin

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst = '1') then
        rx_clk_r <= '0';
      else
        rx_clk_r <= rx_clk;
      end if;
    end if;
  end process;
  
  neg_edge <= not(rx_clk) and rx_clk_r;

  ---

  shift_en <= rx_frame and neg_edge;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst = '1') then
        shift_reg <= (others => '0');
      elsif(shift_en = '1') then
        shift_reg <= rxd & shift_reg(7 downto 1);
      end if;
    end if;
  end process;
  
  bit_clr <= not(rx_frame);

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst = '1' or bit_clr = '1') then
        bit_cnt <= (others => '0');
      elsif(shift_en = '1') then 
        bit_cnt <= bit_cnt + 1;
      end if;
    end if;
  end process;
  
  bit_ceo <= shift_en when (bit_cnt = 7) else '0';

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst = '1') then
        dout <= (others => '0');
      elsif(bit_ceo = '1') then
        dout <= rxd & shift_reg(7 downto 1);
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst = '1') then
        dout_vld <= '0';
      else
        dout_vld <= bit_ceo;
      end if;
    end if;
  end process;
    
end rtl;

