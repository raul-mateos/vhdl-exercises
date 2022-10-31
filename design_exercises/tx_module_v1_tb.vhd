library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_module_v1_tb is
end entity;

architecture rtl of tx_module_v1_tb is
  constant T_CLK : time := 20 ns;
  
  signal rst           : std_logic;
  signal clk           : std_logic := '0';

  signal usr_din       : std_logic_vector(7 downto 0);
  signal usr_rqt       : std_logic;
  signal usr_ack       : std_logic;
  signal txd           : std_logic;
  
begin

  DUT : entity work.tx_module_v1
    port map (
      rst           => rst,
      clk           => clk,
      usr_din       => usr_din,
      usr_rqt       => usr_rqt,
      usr_ack       => usr_ack,
      txd           => txd);
      
  clk <= not(clk) after T_CLK/2;       
      
  main : process
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;

    procedure send(x : in integer) is
    begin
      usr_din <= std_logic_vector(to_unsigned(x, 8));
      usr_rqt <= '1';
      wait until (clk = '1');      
      
      usr_din <= (others => 'X');
      usr_rqt <= '0';
      wait until (clk = '1');      
      
      while (usr_ack /= '1') loop
        wait until (clk = '1');
      end loop;
    end send;

  begin
    -- Fijo valores iniciales en las señales de entrada:
    usr_din <= (others => 'X');
    usr_rqt <= '0';
  
    rst <= '1';
    gap(4);
    rst <= '0';
    gap(1);

    send(16#55#);
    gap(20);
    
    for i in 0 to 5 loop
      send(i+1);
      gap(1);
    end loop;
  
    report "End of simulation";
    wait;
  end process;

end rtl;

