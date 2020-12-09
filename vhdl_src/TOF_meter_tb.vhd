library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TOF_meter_tb is
end entity;

architecture rtl of TOF_meter_tb is
  constant T_CLK : time := 20 ns;

  signal rst      : std_logic;
  signal clk      : std_logic := '0';
  
  signal start      : std_logic;
  signal echo       : std_logic;
  signal data       : std_logic_vector(15 downto 0);
  signal overrange  : std_logic;
    
begin

  DUT : entity work.TOF_meter
    port map (
      rst       => rst,
      clk       => clk,
      start     => start,
      echo      => echo,
      data      => data,
      overrange => overrange);

                  
  clk <= not(clk) after T_CLK/2; 
      
      
  main: process
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;

    procedure gen_pulse (
      delay     : in integer;
      echo_len  : in integer) is
    begin
      start <= '1';
      wait until (clk'event and clk = '1');
      start <= '0';
      
      for i in 1 to delay loop
        wait until (clk'event and clk = '1');
      end loop;
      
      echo <= '1';
      for i in 1 to echo_len loop
        wait until (clk'event and clk = '1');
      end loop;
      echo <= '0';
      
    end gen_pulse;
    
  begin
    -- Fijo valores iniciales en las señales de entrada:
    rst <= '1';
    start <= '0';
    echo <= '0';
    
    gap(4);
    rst <= '0';
    gap(1);

    report "Test normal behaviour:";
    gen_pulse(100, 8);
    gap(20);
    report "Test overrange condition:";
    gen_pulse(65536+4, 8);
    
    report "End of simulation";
    wait;      
  end process;      

end rtl;
