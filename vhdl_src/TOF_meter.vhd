library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TOF_meter is
  port (
    rst         : in  std_logic;
    clk         : in  std_logic;
    start       : in  std_logic;
    echo        : in  std_logic;
    data        : out std_logic_vector(15 downto 0);
    overrange   : out std_logic);
end entity;

architecture rtl of TOF_meter is
  signal echo_r     : std_logic;
  signal echo_start : std_logic;

  signal tof_cnt  : unsigned(15 downto 0);
  constant TOF_CNT_MAX  : unsigned(15 downto 0) := (others => '1');
  signal tof_max  : std_logic;
  signal tof_clr  : std_logic;
  signal tof_inc  : std_logic;

  type state_type is (
    idle, 
    running);
  signal state : state_type;

  signal tof_vld  : std_logic;  
begin

  process(clk, rst)
  begin
    if(rst = '1') then
      echo_r <= '0';
    elsif(clk'event and clk = '1') then
      echo_r <= echo;
    end if;
  end process;

  echo_start <= echo and not(echo_r);

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(tof_clr = '1') then
        tof_cnt <= (others => '0');
      elsif(tof_inc = '1') then
        tof_cnt <= tof_cnt + 1;
      end if;
    end if;
  end process;
  
  tof_max <= '1' when (tof_cnt = TOF_CNT_MAX) else '0';  

  process(clk, rst)
  begin
    if(rst = '1') then
      state <= idle;
    elsif(clk'event and clk = '1') then
      case state is
        when idle =>
          if(start = '1') then
            state <= running;
          end if;
        when running =>
          if(echo_start = '1' or tof_max = '1') then
            state <= idle;
          end if;
        when others =>
      end case; 
    end if;
  end process;
  
  process(state, echo_start, tof_max)
  begin
    tof_clr <= '0';
    tof_inc <= '0';
    tof_vld <= '0';
    case state is
      when idle =>
        tof_clr <= '1';
      when running =>
        tof_inc <= '1';
        tof_vld <= echo_start or tof_max;        
      when others =>
    end case; 
  end process;
  
  process(clk, rst)
  begin
    if(rst = '1') then
      data <= (others => '0');
      overrange <= '0';
    elsif(clk'event and clk = '1') then
      if(tof_vld = '1') then
        data <= std_logic_vector(tof_cnt);
        overrange <= tof_max;
      end if;
    end if;
  end process;

end rtl;

