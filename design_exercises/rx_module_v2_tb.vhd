library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_module_v2_tb is
end entity;

architecture rtl of rx_module_v2_tb is
  constant T_CLK : time := 20 ns;

  signal rst           : std_logic;
  signal clk           : std_logic := '0';

  signal rxd           : std_logic;
  signal rx_frame      : std_logic;
--  signal rx_clk        : std_logic;
  signal dout          : std_logic_vector(7 downto 0);
  signal dout_vld      : std_logic;

begin

  DUT : entity work.rx_module_v2
    port map (
      rst           => rst,
      clk           => clk,
      rxd           => rxd,
      rx_frame      => rx_frame,
--      rx_clk        => rx_clk,
      dout          => dout,
      dout_vld      => dout_vld);

  clk <= not(clk) after T_CLK/2;

  main : process
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;

    procedure send(x : in integer) is
      variable vx : std_logic_vector(7 downto 0);
    begin
      vx := std_logic_vector(to_unsigned(x, 8));
      rx_frame <= '1';
      for i in 0 to 7 loop
        rxd <= vx(i);
        wait until (clk = '1');
      end loop;
      rx_frame <= '0';
      rxd <= 'X';
    end send;

  begin
    -- Fijo valores iniciales en las señales de entrada:
    rxd <= 'X';
    rx_frame <= '0';
    
    rst <= '1';
    gap(4);
    rst <= '0';
    send(16#55#);
    gap(15);
    
    for i in 0 to 5 loop
      send(i+1);
      gap(5);
    end loop;

    report "End of simulation";
    wait;
  end process;

end rtl;

