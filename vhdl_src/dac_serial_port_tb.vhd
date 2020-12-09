library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dac_serial_port_tb is
end entity;

architecture rtl of dac_serial_port_tb is
  constant T_CLK : time := 20 ns;

  constant C_CLK_PERIOD_PS   : integer := 20_000;
  constant C_SCLK_PERIOD_PS  : integer := 120_000;
  
  signal rst        : std_logic;
  signal clk        : std_logic := '0';

  signal data_in    : std_logic_vector(11 downto 0);
  signal tx_rqt     : std_logic;
  signal tx_ack     : std_logic;
    
  signal dac_sclk   : std_logic;
  signal dac_din    : std_logic;
  signal dac_sync_n : std_logic;
    
begin

  DUT : entity work.dac_serial_port
    generic map (
      C_CLK_PERIOD_PS   => C_CLK_PERIOD_PS,
      C_SCLK_PERIOD_PS  => C_SCLK_PERIOD_PS)
    port map (
      rst         => rst,
      clk         => clk,
  
      data_in     => data_in,
      tx_rqt      => tx_rqt,
      tx_ack      => tx_ack,
  
      dac_sclk    => dac_sclk,
      dac_din     => dac_din,
      dac_sync_n  => dac_sync_n);
      
  clk <= not(clk) after T_CLK/2; 
      
      
  main: process
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;

    procedure send_data (
      value : in integer) is
    begin
        data_in <= std_logic_vector(to_unsigned(value, data_in'length));
        tx_rqt <= '1';
        wait until (clk'event and clk = '1');

        while (tx_ack /= '1') loop
          wait until (clk'event and clk = '1');
        end loop;        
        data_in <= (others => 'X');
        tx_rqt <= '0';
    end send_data;
  begin
    -- Fijo valores iniciales en las señales de entrada:
    rst <= '1';
    data_in <= (others => 'X');
    tx_rqt <= '0';
    
    gap(4);
    rst <= '0';
    gap(1);
    
    send_data(16#355#);
    report "End of simulation";
    wait;      
  end process;      

end rtl;
