library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity t_on_limiter is
  port (
    rst         : in  std_logic;
    clk         : in  std_logic;

    max_t_on    : in  std_logic_vector(15 downto 0);
    din         : in  std_logic;
    dout        : out std_logic);
end entity;

architecture rtl of t_on_limiter is

  signal din_r  : std_logic;
  signal din_pos_edge : std_logic;

  signal enable : std_logic;
  
  
  signal time_cnt     : unsigned(15 downto 0);
  signal time_cnt_clr : std_logic;
  signal time_cnt_end : std_logic;

begin

  process(clk, rst)
  begin
    if(rst = '1') then
      din_r <= '0';
    elsif(clk'event and clk = '1') then
      din_r <= din;
    end if;
  end process;
  
  din_pos_edge <= din and not(din_r);

  process(clk, rst)
  begin
    if(rst = '1') then
      enable <= '0';
    elsif(clk'event and clk = '1') then
      if(enable = '0') then
        if(din_pos_edge = '1') then
          enable <= '1';
        end if;
      else
        if(din = '0' or time_cnt_end = '1') then
          enable <= '0';
        end if;
      end if;
    end if;
  end process;
  
  ---
      
  time_cnt_clr <= not(enable);
  
  process(clk)
  begin
    if(clk'event and clk = '1') then
      if((time_cnt_clr or time_cnt_end)= '1') then
        time_cnt <= unsigned(max_t_on);
      else
        time_cnt <= time_cnt - 1;
      end if;
    end if;
  end process;
  
  time_cnt_end <= '1' when (time_cnt = 1) else '0';
 
  ---
  
  dout <= enable and din_r; 
  
end rtl;

