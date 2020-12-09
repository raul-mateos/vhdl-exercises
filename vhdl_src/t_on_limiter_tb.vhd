library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity t_on_limiter_tb is
end entity;

architecture rtl of t_on_limiter_tb is
  constant T_CLK : time := 20 ns;

  signal rst      : std_logic;
  signal clk      : std_logic := '0';
  signal max_t_on : std_logic_vector(15 downto 0);
  signal din      : std_logic;
  signal dout     : std_logic;
    
begin

  DUT : entity work.t_on_limiter
    port map (
      rst       => rst,
      clk       => clk,
      max_t_on  => max_t_on,
      din       => din,
      dout      => dout);
            
  clk <= not(clk) after T_CLK/2; 
      
      
  main: process
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;

    procedure gen_cycle (
      N_high  : in integer;
      N_low   : in integer) is
    begin
      din <= '1';
      for i in 0 to N_high-1 loop
        wait until (clk'event and clk = '1');
      end loop;
      
      din <= '0';
      for i in 0 to N_low-1 loop
        wait until (clk'event and clk = '1');
      end loop;
    end gen_cycle;
    
  begin
    -- Fijo valores iniciales en las señales de entrada:
    rst <= '1';
    din <= '0';
    max_t_on <= std_logic_vector(to_unsigned(5, max_t_on'length));
    
    gap(4);
    rst <= '0';
    gap(1);

--    gen_cycle(1, 1);
--    gen_cycle(1, 1);
--    report "End of simulation";
--    wait;      
    
    for i in 1 to 10 loop
      gen_cycle(i, 15-i);
    end loop;
        
--    gen_cycle(20, 10);
--    gen_cycle(5, 10);
    
    report "End of simulation";
    wait;      
  end process;      

end rtl;
