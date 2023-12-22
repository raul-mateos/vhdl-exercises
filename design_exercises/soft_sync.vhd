library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soft_sync is
  generic (
    INIT            : bit := '0';
    IS_CLK_INVERTED : bit := '0';
    LATENCY         : integer range 1 to 3);
  port (
    din   : in  std_logic;
    clk   : in  std_logic;
    dout  : out std_logic);
end entity;

architecture rtl of soft_sync is
  attribute ASYNC_REG     : string;
  attribute shreg_extract : string;
  
  signal sync_taps : std_logic_vector(LATENCY-1 downto 0) := (others => TO_X01(INIT));

  attribute ASYNC_REG of sync_taps : signal is "TRUE";
  attribute shreg_extract of sync_taps : signal is "no";
begin

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if (LATENCY > 1) then
        sync_taps <= sync_taps(LATENCY-2 downto 0) & din;
      else
        sync_taps(0) <= din;
      end if;
    end if;
  end process;

  dout <= sync_taps(LATENCY-1);
end rtl;

