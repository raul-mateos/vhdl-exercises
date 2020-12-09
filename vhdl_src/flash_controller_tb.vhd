library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flash_controller_tb is
end entity;

architecture sim of flash_controller_tb is

  component flash_controller is
    port (
      rst           : in    std_logic;
      clk           : in    std_logic;
      usr_rqt       : in    std_logic;
      usr_done      : out   std_logic;
      usr_addr      : in    std_logic_vector(23 downto 0);
      usr_rnw       : in    std_logic;
      usr_wr_data   : in    std_logic_vector(7 downto 0);
      usr_rd_data   : out   std_logic_vector(7 downto 0);
      ---
      flash_addr    : out   std_logic_vector(23 downto 0);
      flash_data    : inout std_logic_vector(7 downto 0);
      flash_cs_n    : out   std_logic;
      flash_we_n    : out   std_logic;
      flash_oe_n    : out   std_logic);
  end component;
  
  component flash_mem is
    port (
      addr  : in    std_logic_vector(23 downto 0);
      data  : inout std_logic_vector(7 downto 0);
      cs_n  : in    std_logic;
      we_n  : in    std_logic;
      oe_n  : in    std_logic);
  end component;

  signal rst          : std_logic;
  signal clk          : std_logic := '0';
  signal usr_rqt      : std_logic;
  signal usr_done     : std_logic;
  signal usr_addr     : std_logic_vector(23 downto 0);
  signal usr_rnw      : std_logic;
  signal usr_wr_data  : std_logic_vector(7 downto 0);
  signal usr_rd_data  : std_logic_vector(7 downto 0);

  signal flash_addr : std_logic_vector(23 downto 0);
  signal flash_data : std_logic_vector(7 downto 0);
  signal flash_cs_n : std_logic;
  signal flash_we_n : std_logic;
  signal flash_oe_n : std_logic;

  signal dbg_rd_data  : integer;
    
begin

  DUT : flash_controller
    port map (
      rst           => rst,
      clk           => clk,
      usr_rqt       => usr_rqt,
      usr_done      => usr_done,
      usr_addr      => usr_addr,
      usr_rnw       => usr_rnw,
      usr_wr_data   => usr_wr_data,
      usr_rd_data   => usr_rd_data,
      flash_addr    => flash_addr,
      flash_data    => flash_data,
      flash_cs_n    => flash_cs_n,
      flash_we_n    => flash_we_n,
      flash_oe_n    => flash_oe_n);

  MEM_I : flash_mem
    port map (
      addr    => flash_addr,
      data    => flash_data,
      cs_n    => flash_cs_n,
      we_n    => flash_we_n,
      oe_n    => flash_oe_n);

  clk <= not (clk) after (10 ns/2);
  
  main: process
  
    procedure gap(N_cycles : in integer := 0) is
    begin
      for i in 1 to N_cycles loop
        wait until (clk'event and clk = '1');
      end loop;
    end gap;

    procedure flash_wr(addr : in integer; data : in integer);
    procedure flash_rd(addr : in integer; data : out integer);
    
      
    procedure flash_wr(addr : in integer; data : in integer) is
    begin
      usr_rqt  <= '1';
      usr_addr <= std_logic_vector(to_unsigned(addr, 24));
      usr_rnw  <= '0';
      usr_wr_data  <= std_logic_vector(to_unsigned(data, 8));
      wait until (clk'event and clk = '1');
      
      while (usr_done /= '1') loop
        wait until (clk'event and clk = '1');
      end loop;
      
      usr_rqt  <= '0';
      usr_addr <= (others => 'X');
      usr_rnw  <= '0';
      usr_wr_data  <= (others => 'X');    
    end flash_wr;

    procedure flash_rd(addr : in integer; data : out integer) is
    begin
      usr_rqt  <= '1';
      usr_addr <= std_logic_vector(to_unsigned(addr, 24));
      usr_rnw  <= '1';
      wait until (clk'event and clk = '1');
      while (usr_done /= '1') loop
        wait until (clk'event and clk = '1');
      end loop;
      data := to_integer(unsigned(usr_rd_data));
      usr_rqt  <= '0';
      usr_addr <= (others => 'X');
      usr_rnw  <= '0';
    end flash_rd;
    
    variable addr     : integer;
    variable wr_data  : integer;
    variable rd_data  : integer;
      
  begin
    usr_rqt  <= '0';
    usr_addr <= (others => 'X');
    usr_rnw  <= '0';
    usr_wr_data  <= (others => 'X');    
  
    rst <= '1';
    gap(5);
    rst <= '0';
    gap(5);

    addr    := 16#1000#;
    wr_data := 16#AB#;
    flash_wr(addr, wr_data);
    gap(5);
        
    addr    := 16#1000#;
    flash_rd(addr, rd_data);
    dbg_rd_data <= rd_data;

  
    wait;
  end process; 
  

  
end sim;

