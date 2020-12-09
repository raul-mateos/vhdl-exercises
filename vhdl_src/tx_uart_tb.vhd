library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_uart_tb is
end entity;

architecture rtl of tx_uart_tb is
  constant T_clk  : time := 20 ns;
  signal rst      : std_logic;
  signal clk      : std_logic := '0';
  ---    
  signal enable     : std_logic;
  signal baud_rate  : std_logic_vector(15 downto 0);
  signal tx_byte    : std_logic_vector(7 downto 0);
  signal tx_rqt     : std_logic;
  signal tx_ack     : std_logic;
  signal txd        : std_logic;
  
begin

  DUT : entity work.tx_uart
    port map (
      rst         => rst,
      clk         => clk,
      enable      => enable,
      baud_rate   => baud_rate,
      tx_byte     => tx_byte,
      tx_rqt      => tx_rqt,
      tx_ack      => tx_ack,
      txd         => txd);
  
  clk <= not(clk) after (T_clk/2);
              
  main : process
    procedure gap (n : in integer := 1) is
    begin
      for i in 1 to n loop
        wait until (clk'event and clk = '1');
      end loop;
    end procedure;    
  
    procedure set_baud_rate (br : in integer; clk_freq : in integer) is
      variable prescaler_factor : integer;
    begin
      prescaler_factor := clk_freq/br - 1;
      baud_rate <= std_logic_vector(to_unsigned(prescaler_factor, 16));
    end procedure;
        
    procedure send_byte(byte : in integer) is
    begin
      tx_byte <= std_logic_vector(to_unsigned(byte, 8));
      tx_rqt <= '1';
      wait until (clk'event and clk = '1');
      while (tx_ack /= '1') loop
        wait until (clk'event and clk = '1');
      end loop;
      tx_rqt <= '0';
      tx_byte <= (others => 'X');
    end procedure;    
  begin
    -- Valor inicial de señales de entrada:
    enable <= '1';
    baud_rate <= x"FFFF";
    tx_byte <= x"00";
    tx_rqt <= '0';    
    -- Activo el reset durante unos ciclos:
    rst <= '1'; 
    gap(5);
    -- Lo desactivo y espero unos ciclos antes de comenzar la simulación:    
    rst <= '0';
    gap(5);
    
    set_baud_rate(2*11520, 50_000_000); 
    gap(5);
    send_byte(16#CA#); 
    gap(5);
    
    
    wait;
  end process;

end rtl;
