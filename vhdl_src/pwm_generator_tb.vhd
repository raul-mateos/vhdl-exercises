library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;


entity pwm_generator_tb is
end entity;

architecture rtl of pwm_generator_tb is
  constant T_CLK : time := 100 ns;
  
  signal rst        : std_logic;
  signal clk        : std_logic := '0';
  signal period     : std_logic_vector(15 downto 0);
  signal duty_cycle : std_logic_vector(15 downto 0);
  signal pwm_out    : std_logic;
begin

  DUT : entity work.pwm_generator
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
    
    -- T_pwm = Tclk*2*N
    -- N = T_pwm/(2*TCLK)
    
    procedure set_period (T_pwm_us : in integer) is
      variable N : integer;
    begin
      N := ((T_pwm_us*1000)/100)/2;
      period <= std_logic_vector(to_unsigned(N, 16));
    end set_period;

    -- t_on = 2*D*Tclk
    -- dc = t_on / T_pwm = (2*D*Tclk)/(Tclk*2*N)=D/N
    -- D = dc*N
    -- D = (dc_pc*N)/100
    
    
    procedure set_duty_cycle (
      T_pwm_us      : in integer;
      duty_cycle_pc : in integer range 0 to 100) 
    is
      variable N : integer;
      variable D : integer;
    begin
      N := ((T_pwm_us*1000)/100)/2;
      D := (duty_cycle_pc*N)/100;
      
      duty_cycle <= std_logic_vector(to_unsigned(D, 16));
    end set_duty_cycle;
        
  begin
    -- Fijo valores iniciales en las señales de entrada:
    rst <= '1';
    gap(4);
    rst <= '0';
    gap(1);
    
    set_period(100);
    set_duty_cycle(100, 50);
	
    report "End of simulation";
    wait;      
  
  end process;  
end rtl;
