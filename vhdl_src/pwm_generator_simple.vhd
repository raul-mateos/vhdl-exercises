library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_generator_simple is
  port (
    rst         : in  std_logic;
    clk         : in  std_logic;
    period      : in  std_logic_vector(15 downto 0);
    duty_cycle  : in  std_logic_vector(15 downto 0);
    pwm_out     : out std_logic);
end entity;

architecture rtl of pwm_generator_simple is
  signal carrier      : unsigned(15 downto 0);
  signal period_end   : std_logic;
  signal duty_cycle_reg : std_logic_vector(15 downto 0);
  
  signal match        : std_logic;
begin

  process(clk, rst)
  begin
    if(rst = '1') then
      duty_cycle_reg <= (others => '0');
    elsif(clk'event and clk = '1') then
      if(period_end = '1') then
        duty_cycle_reg <= duty_cycle;
      end if;
    end if;
  end process;

  -------------------------------------

  process(clk, rst)
  begin
    if(rst = '1') then
      carrier <= (others => '0');
    elsif(clk'event and clk = '1') then
      if(period_end = '1') then
        carrier <= (others => '0');
      else 
        carrier <= carrier + 1;
      end if;
    end if;
  end process;
  
  period_end <= '1' when (carrier = unsigned(period)) else '0';


  process(clk, rst)
  begin
    if(rst = '1') then
      pwm_out <= '0';
    elsif(clk'event and clk = '1') then
      if(carrier < unsigned(duty_cycle_reg)) then
        pwm_out <= '1';
      else
        pwm_out <= '0';
      end if;
    end if;
  end process;

  match <= '1' when (carrier = unsigned(duty_cycle_reg)) else '0';
    
end rtl;

