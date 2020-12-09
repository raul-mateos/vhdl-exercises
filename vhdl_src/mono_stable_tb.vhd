library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mono_stable_tb is
end entity;

architecture rtl of mono_stable_tb is
  constant T_CLK : time := 20 ns;
  
  signal rst          : std_logic;
  signal clk          : std_logic := '0';
  signal trigger      : std_logic;
  signal pulse_length : std_logic_vector(9 downto 0);
  signal pulse        : std_logic;
  
begin

  DUT : entity work.mono_stable
    port map (
      rst           => rst,
      clk           => clk,  
      trigger       => trigger,
      pulse_length  => pulse_length,  
      pulse         => pulse);
            
  clk <= not(clk) after T_CLK/2;       

  main: process
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;

    procedure gen_cycle(n_on : in integer := 0; n_off : in integer := 0) is
    begin
      trigger <= '1';
      for i in 1 to n_on loop
        wait until (clk'event and clk = '1');
      end loop;
      trigger <= '0';
      for i in 1 to n_off loop
        wait until (clk'event and clk = '1');
      end loop;
    end gen_cycle;
        
  begin
    -- Fijo valores iniciales en las señales de entrada:
    trigger <= '0';
    pulse_length <= (others => '0');
    
    rst <= '1';
    gap(4);
    rst <= '0';
    gap(1);

    pulse_length <= std_logic_vector(to_unsigned(5, 10));
    gap(4);
    
    for i in 1 to 10 loop
      gen_cycle(i, 15-i);
    end loop;

    report "Testing non-retriggerable condition:";
    gen_cycle(1, 1);
    gen_cycle(1, 1);
        
    report "End of simulation";
    wait;      
  
  end process;  
end rtl;
