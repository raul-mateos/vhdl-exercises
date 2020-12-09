library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flash_mem is
  port (
    addr  : in    std_logic_vector(23 downto 0);
    data  : inout std_logic_vector(7 downto 0);
    cs_n  : in    std_logic;
    we_n  : in    std_logic;
    oe_n  : in    std_logic);
end entity;

architecture sim of flash_mem is

  constant T_ACC  : time := 45 ns;
  constant T_HZ   : time := 6 ns;

  
  constant AWIDTH : integer := 16;
  constant DWIDTH : integer := 8;
  
  
  type mem_type is array (2**AWIDTH-1 downto 0) of std_logic_vector (DWIDTH-1 downto 0);
  signal mem : mem_type;
  
  
  signal wr_n   : std_logic;
  signal rd_n   : std_logic;
  signal addr_i : std_logic_vector(AWIDTH-1 downto 0);

begin
  
  process(wr_n)
  begin
    addr_i <= (others => '0');
    addr_i <= addr(AWIDTH-1 downto 0);
  end process;

  wr_n <= not (not(cs_n) and not(we_n));

  process(wr_n)
  begin
    if(wr_n'event and wr_n = '1') then
      mem( to_integer(unsigned(addr_i(AWIDTH-1 downto 0))) ) <= data;    
    end if;
  end process;

  rd_n <= not (not(cs_n) and we_n and not(oe_n));
  
  process(rd_n)
  begin
    if(rd_n'event) then
      if(rd_n = '0') then
        -- Comienzo del ciclo de acceso:
        data <= transport mem( to_integer(unsigned(addr_i(AWIDTH-1 downto 0))) ) after T_ACC;
      else
        -- Fin del ciclo de acceso:
        data <= transport (others => 'Z') after T_HZ;
      end if;
    else
      data <= transport mem( to_integer(unsigned(addr_i(AWIDTH-1 downto 0))) ) after T_ACC;
    end if;
    
  end process;

end sim;

