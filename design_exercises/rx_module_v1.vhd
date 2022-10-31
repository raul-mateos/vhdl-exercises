library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_module_v1 is
  port (
    rst           : in  std_logic;
    clk           : in  std_logic;
    ---    
    rxd           : in  std_logic;
    dout          : out std_logic_vector(7 downto 0);
    dout_vld      : out std_logic);
end entity;

architecture rtl of rx_module_v1 is

  signal shift_reg  : std_logic_vector(7 downto 0);
    
  signal bit_cnt  : unsigned(2 downto 0);
  signal bit_tc   : std_logic;
  
begin


  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst = '1') then
        shift_reg <= (others => '0');
      else
        shift_reg <= rxd & shift_reg(7 downto 1);
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst = '1') then
        bit_cnt <= (others => '0');
      else
        bit_cnt <= bit_cnt + 1;
      end if;
    end if;
  end process;
  
  bit_tc <= '1' when (bit_cnt = 7) else '0';

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst = '1') then
        dout <= (others => '0');
      elsif(bit_tc = '1') then
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
        dout_vld <= bit_tc;
      end if;
    end if;
  end process;
    
end rtl;

