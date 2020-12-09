library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_one_hot is
  generic (
    C_N_CHANNELS    : integer := 4;
    C_CHANNEL_WIDTH : integer := 32
  );
  port (
    data_in   : in  std_logic_vector(C_N_CHANNELS*C_CHANNEL_WIDTH-1 downto 0);
    sel       : in  std_logic_vector(C_N_CHANNELS-1 downto 0);
    data_out  : out std_logic_vector(C_CHANNEL_WIDTH-1 downto 0));
end mux_one_hot;

architecture rtl of mux_one_hot is
begin
  
  process(data_in, sel)
  begin 
    data_out <= (others => '0');
    for i in 0 to C_N_CHANNELS-1 loop
      if(sel(i) = '1') then
        data_out <= data_in(C_CHANNEL_WIDTH*(i+1)-1 downto C_CHANNEL_WIDTH*i);
      end if;
    end loop;  
  end process;

end rtl;

