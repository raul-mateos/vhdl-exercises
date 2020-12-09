--------------------------------------------------------------------------------
-- Title       : <Title Block>
-- Project     : Default Project Name
--------------------------------------------------------------------------------
-- File        : bus_decoder_tb.vhd
-- Author      : Raúl Mateos <raul.mateos@uah.es>
-- Company     : University of Alcala
-- Created     : Sun Dec  6 11:28:27 2020
-- Last update : Sun Dec  6 11:29:16 2020
-- Platform    : Default Part Number
-- Standard    : VHDL-1993
--------------------------------------------------------------------------------
-- Copyright (c) 2020 Raúl Mateos. University of Alcala
-------------------------------------------------------------------------------
-- Description: 
--------------------------------------------------------------------------------
-- Revisions:  Revisions and documentation are controlled by
-- the revision control system (RCS).  The RCS should be consulted
-- on revision history.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

-----------------------------------------------------------

entity bus_decoder_tb is
end entity;

-----------------------------------------------------------

architecture testbench of bus_decoder_tb is

	-- Testbench DUT generics
	constant C_ADDR_WIDTH : integer := 16;
	constant C_BASE_ADDR  : std_logic_vector(C_ADDR_WIDTH-1 downto 0) := x"2100";
	constant C_HIGH_ADDR  : std_logic_vector(C_ADDR_WIDTH-1 downto 0) := x"213F";

	-- Testbench DUT ports
	signal bus_addr : std_logic_vector(C_ADDR_WIDTH-1 downto 0);
	signal bus_sel  : std_logic;
	signal dev_sel  : std_logic;

	-- Other constants
	constant T_CLK : time := 10.0 ns;

begin

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.bus_decoder
		generic map (
			C_ADDR_WIDTH => C_ADDR_WIDTH,
			C_BASE_ADDR  => C_BASE_ADDR,
			C_HIGH_ADDR  => C_HIGH_ADDR)
		port map (
			bus_addr => bus_addr,
			bus_sel  => bus_sel,
			dev_sel  => dev_sel);

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	
	main: process
	begin
    bus_sel  <= '0';
    bus_addr <= (others => 'X');
    wait for 10*T_CLK;
    
    for i in 0 to 2**C_ADDR_WIDTH-1 loop
      bus_sel  <= '1';
      bus_addr <= std_logic_vector(to_unsigned(i, C_ADDR_WIDTH));
      wait for T_CLK;
    end loop;
    bus_sel  <= '0';
    bus_addr <= (others => 'X');
	
    report "End of simulation";	
	  wait;
	end process;
		
end architecture testbench;