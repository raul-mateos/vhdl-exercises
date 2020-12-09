library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

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
  constant N_LUTs   : integer := (N_dec + 3) /4;
  signal   lut_out  : std_logic_vector(0 to N_LUTs-1);
  signal   carry    : std_logic_vector(0 to N_LUTs);

  signal bus_addr_up  : std_logic_vector(0 to C_ADDR_WIDTH-1);
  
begin

  bus_addr_up <= bus_addr;

  DECODE_I : for i in 0 to N_LUTs-1 generate
  begin
    FULL_LUT: if (4*i+3 <= (N_dec-1)) generate
      lut_out(i) <= '1' when ( bus_addr_up(4*i to (4*i+3)) = BASE_ADDR(4*i to (4*i+3)) ) else '0';
    end generate;
    NOT_FULL_LUT: if (4*i+3 > (N_dec-1)) generate
      lut_out(i) <= '1' when ( bus_addr_up(4*i to (N_dec-1)) = BASE_ADDR(4*i to (N_dec-1)) ) else '0';
    end generate;
    MUXCY_I : MUXCY
      port map (
        DI => '0',         -- in(0)
        CI => carry(i),    -- in(1)
        S  => lut_out(i),  -- select.
        O  => carry(i+1)); -- local output.
  end generate;

  carry(0) <= bus_sel;      
  dev_sel  <= carry(N_LUTs);      
end rtl;
