
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dna_protect_v1_tb is
end entity;

architecture rtl of dna_protect_v1_tb is
  constant T_USR_CLK : time := 10 ns;
  constant CLK_PERIOD_PS  : integer := integer((1000.0*T_USR_CLK)/1 ns);
  constant TIMEOUT_SEC    : integer := 60*60;
  constant DEV_DNA        : std_logic_vector(95 downto 0) := x"4002000101512D022410A345";  -- right DNA
  

  signal usr_rst    : std_logic;
  signal usr_clk    : std_logic := '0';

  signal dna_match    : std_logic;
  signal dna_timeout  : std_logic;

begin

  DUT : entity work.dna_protect_v1
    generic map (
      C_CLK_PERIOD_PS   => CLK_PERIOD_PS,
      C_TIMEOUT_SEC     => TIMEOUT_SEC,
      C_DEV_DNA         => DEV_DNA)
    port map (
      usr_rst     => usr_rst,
      usr_clk     => usr_clk,
      dna_match   => dna_match,
      dna_timeout => dna_timeout);

  usr_clk <= not(usr_clk) after T_USR_CLK/2;

  main : process
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (usr_clk'event and usr_clk = '1');
      end loop;
    end gap;

  begin
    -- Fijo valores iniciales en las señales de entrada:
    usr_rst <= '1';
    gap(4);
    usr_rst <= '0';

    report "End of simulation";
    wait;
  end process;

end rtl;

