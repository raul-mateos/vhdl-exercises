library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_one_hot is
  port (
    A_din   : in  std_logic_vector(7 downto 0);
    B_din   : in  std_logic_vector(7 downto 0);
    C_din   : in  std_logic_vector(7 downto 0);
    D_din   : in  std_logic_vector(7 downto 0);
    sel     : in  std_logic_vector(3 downto 0);
    dout    : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of mux_one_hot is
  signal mux_din  : std_logic_vector(8*4-1 downto 0);

  constant C_N_CHANNELS     : integer := sel'length;
  constant C_CHANNEL_WIDTH  : integer := A_din'length;

begin

  mux_din <= D_din & C_din & B_din & A_din;
  
  process(mux_din, sel)
  begin 
    dout <= (others => '0');
    for i in 0 to C_N_CHANNELS-1 loop
      if(sel(i) = '1') then
        dout <= mux_din(C_CHANNEL_WIDTH*(i+1)-1 downto C_CHANNEL_WIDTH*i);
      end if;
    end loop;  
  end process;

end rtl;

