library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;


entity moving_average_tb is
end entity;

architecture rtl of moving_average_tb is
  constant T_CLK : time := 10 ns;
  constant OUTPUT_FILE_NAME : string := "data_out.txt";
  
  signal rst      : std_logic;
  signal clk      : std_logic := '0';
  
  signal din      : std_logic_vector(15 downto 0);
  signal din_vld  : std_logic;

  signal dout     : std_logic_vector(15 downto 0);
  signal dout_vld : std_logic;    
begin

  DUT : entity work.moving_average
    port map (
      rst       => rst,
      clk       => clk,
  
      din       => din,
      din_vld   => din_vld,
  
      dout      => dout,
      dout_vld  => dout_vld);
      
  clk <= not(clk) after T_CLK/2;       
      
  main: process
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;

    procedure send_file (
      file_name : in string;
      data_gap  : in integer := 0)
    is      
      file     input_file   : text open READ_MODE is file_name;
      variable input_buffer : line;
      variable data : integer;      
    begin    
      while not endfile(input_file) loop
        -- Leo el fichero de entrada sobre la variable data ...
        readline(input_file, input_buffer);
        read(input_buffer, data);

        din <= std_logic_vector(to_signed(data, din'length));
        din_vld <= '1';
        wait until (clk'event and clk = '1');
        --din <= (others => 'X');
        din_vld <= '0';
        
        gap(data_gap);
      end loop;
    end send_file;    
    
    procedure send_frame (
      N_data    : in integer;
      data_gap  : in integer := 0) is
    begin
      for i in 0 to N_data-1 loop
        din <= std_logic_vector(to_unsigned(i, din'length));
        din_vld <= '1';
        wait until (clk'event and clk = '1');
        din <= (others => 'X');
        din_vld <= '0';
        
        gap(data_gap);
      end loop;      
    end send_frame;

    variable N_din : integer := 0;    
  begin
    -- Fijo valores iniciales en las señales de entrada:
    rst <= '1';
    
    din <= (others => 'X');
    din_vld <= '0';
    
    gap(4);
    rst <= '0';
    gap(1);
    
    --send_frame(10, 1);
    N_din := 100;
    send_frame(N_din, 1);
    --send_file("data_in.txt", 2);
    
    --send_file("sample_in.txt");
    
    report "End of simulation";
    wait;      
  end process;      
  
  
  logging: process(clk)
    file     output_file   : text open WRITE_MODE is OUTPUT_FILE_NAME;
    variable output_buffer : line;
    variable data : integer;      
  begin
    if(clk'event and clk = '1') then
      if(dout_vld = '1') then
        data := to_integer(signed(dout));
        write(output_buffer, data);
        writeline(output_file, output_buffer);    
      end if;    
    end if;    
  end process;
  

end rtl;
