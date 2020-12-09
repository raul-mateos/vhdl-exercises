library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stream_upsizer_tb is
end entity;

architecture rtl of stream_upsizer_tb is
  constant T_CLK : time := 10 ns;

  signal rst        : std_logic;
  signal clk        : std_logic := '0';
  
  signal din        : std_logic_vector(7 downto 0);
  signal din_start  : std_logic;
  signal din_end    : std_logic;
  signal din_vld    : std_logic;

  signal dout       : std_logic_vector(31 downto 0);
  signal dout_strb  : std_logic_vector(3 downto 0);
  signal dout_start : std_logic;
  signal dout_end   : std_logic;
  signal dout_vld   : std_logic;
  
    
begin

  DUT : entity work.stream_upsizer
    port map (
      rst         => rst,
      clk         => clk,
  
      din         => din,
      din_start   => din_start,
      din_end     => din_end,
      din_vld     => din_vld,
  
      dout        => dout,
      dout_strb   => dout_strb,
      dout_start  => dout_start,
      dout_end    => dout_end,
      dout_vld    => dout_vld);
      
  clk <= not(clk) after T_CLK/2; 
      
      
  main: process
    variable N_din : integer := 0;

    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;

    procedure send_frame (
      N_data    : in integer;
      data_gap  : in integer := 0) is
    begin
      for i in 0 to N_data-1 loop
        din <= std_logic_vector(to_unsigned(i, din'length));
        if(i = 0) then
          din_start <= '1';
        end if;
        if(i = N_data-1) then
          din_end <= '1';
        end if;
        din_vld <= '1';
        wait until (clk'event and clk = '1');
        din <= (others => 'X');
        din_start <= '0';
        din_end <= '0';
        din_vld <= '0';
        
        gap(data_gap);
      end loop;      

    end send_frame;
    
  begin
    -- Fijo valores iniciales en las señales de entrada:
    rst <= '1';
    
    din <= (others => 'X');
    din_start <= '0';
    din_end <= '0';
    din_vld <= '0';
    
    gap(4);
    rst <= '0';
    gap(1);
    
    N_din := 10;
    send_frame(10, 1);
    gap(8);
    send_frame(5);
    report "End of simulation";
    wait;      
  end process;      

end rtl;
