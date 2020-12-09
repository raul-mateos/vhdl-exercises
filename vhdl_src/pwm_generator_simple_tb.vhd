library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;


entity pwm_generator_simple_tb is
end entity;

architecture rtl of pwm_generator_simple_tb is
  constant T_CLK : time := 100 ns;
  
  signal rst        : std_logic;
  signal clk        : std_logic := '0';
  signal period     : std_logic_vector(15 downto 0);
  signal duty_cycle : std_logic_vector(15 downto 0);
  signal pwm_out    : std_logic;
begin

  DUT : entity work.pwm_generator_simple
    port map (
      rst         => rst,
      clk         => clk,  
      period      => period,
      duty_cycle  => duty_cycle,  
      pwm_out     => pwm_out);
            
  clk <= not(clk) after T_CLK/2;       

  main: process
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;
    
    -- N: Valor a fijar en entrada 'period'
    -- T_pwm = Tclk*(N+1)
    -- N = T_pwm/Tclk-1
    
    procedure set_period (T_pwm_us : in integer) is
      variable N : integer;
    begin
      N := ((T_pwm_us*1000)/100)-1;
      period <= std_logic_vector(to_unsigned(N, 16));
    end set_period;

    -- D: Valor a fijar en entrada 'duty_cycle'
    -- t_on = Tclk*D
    -- d = t_on / T_pwm = (Tclk*D)/(Tclk*(N+1)) = D/(N+1)
    -- D = d*(N+1) = (duty_cycle_pc/100)*(N+1) = (duty_cycle_pc*(N+1))/100
    
    procedure set_duty_cycle (
      T_pwm_us      : in integer;
      duty_cycle_pc : in integer range 0 to 100) 
    is
      variable N : integer;
      variable D : integer;
    begin
      N := ((T_pwm_us*1000)/100)-1;
      D := (duty_cycle_pc*(N+1))/100;
      
      duty_cycle <= std_logic_vector(to_unsigned(D, 16));
    end set_duty_cycle;
        
    variable T_pwm_us : integer;
    variable duty_cycle_pc : integer;
    
  begin
    -- Fijo valores iniciales en las señales de entrada:
    rst <= '1';
    gap(4);
    rst <= '0';
    gap(1);
    
    T_pwm_us := 100;
    duty_cycle_pc := 25;
    
    set_period(T_pwm_us);
    set_duty_cycle(T_pwm_us, duty_cycle_pc);
    
    -- Espera hasta la mitad de un periodo de Tpwm para
    -- empezar a barrer el duty cycle.
    wait until rising_edge(pwm_out);
    wait for (T_pwm_us * 1 us)/2;
    
    for i in 0 to 10 loop
      set_duty_cycle(T_pwm_us, i*10);    
      wait for (T_pwm_us * 1 us);
    end loop;
    	
    report "End of simulation";
    wait;      
  
  end process;  
end rtl;
