library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bus_decoder is
  generic (
    C_ADDR_WIDTH  : integer;
    C_BASE_ADDR   : std_logic_vector;
    C_HIGH_ADDR   : std_logic_vector);
  port (
    bus_addr  : in  std_logic_vector(C_ADDR_WIDTH-1 downto 0);
    bus_sel   : in  std_logic;
    dev_sel   : out std_logic);
end bus_decoder;

architecture rtl of bus_decoder is
  function bits_to_decode (
    low_addr  : std_logic_vector(0 to C_ADDR_WIDTH-1);
    high_addr : std_logic_vector(0 to C_ADDR_WIDTH-1)
  ) return integer is
    variable cmp_addr : std_logic_vector(0 to C_ADDR_WIDTH-1);
  begin
    cmp_addr := low_addr xor high_addr;
    for i in 0 to C_ADDR_WIDTH-1 loop
      if cmp_addr(i) = '1' then 
        return i;
      end if;
    end loop;
    return C_ADDR_WIDTH;
  end bits_to_decode;

  constant HIGH_ADDR : std_logic_vector(0 to C_ADDR_WIDTH-1) := C_HIGH_ADDR;
  constant BASE_ADDR : std_logic_vector(0 to C_ADDR_WIDTH-1) := C_BASE_ADDR;

  constant N_dec    : integer := bits_to_decode(HIGH_ADDR, BASE_ADDR);

  
  signal bus_addr_up  : std_logic_vector(0 to C_ADDR_WIDTH-1);
  -- Alias para utilizar ordenamiento ascendente:
  --alias bus_addr_up : std_logic_vector (0 to C_ADDR_WIDTH-1) is bus_addr;
    
begin

  bus_addr_up <= bus_addr;

  dev_sel  <= bus_sel when (bus_addr_up(0 to N_dec-1) = BASE_ADDR(0 to N_dec-1) )
                      else '0';
end rtl;
