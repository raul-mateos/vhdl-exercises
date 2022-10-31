library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity moving_average_lite is
  port (
    rst         : in  std_logic;
    clk         : in  std_logic;

    din         : in  std_logic_vector(15 downto 0);
    din_vld     : in  std_logic;

    dout        : out std_logic_vector(15 downto 0);
    dout_vld    : out std_logic);
end entity;

architecture rtl of moving_average_lite is
  constant DWIDTH : integer := din'length;
  constant AWIDTH : integer := 5;
  constant N_TAPS : integer := 2**AWIDTH;
  
  constant ZERO_16: std_logic_vector (DWIDTH-1 downto 0) := (others => '0');
    
  type data_array_t is array (N_TAPS-1 downto 0) of std_logic_vector (DWIDTH-1 downto 0);
  signal shift_reg : data_array_t := (others => ZERO_16);

  signal mem_dout : std_logic_vector(DWIDTH-1 downto 0);

  signal data_dif : signed(DWIDTH downto 0);
  signal data_dif_vld : std_logic;
    
  constant GUARD_BITS : integer := AWIDTH;
  constant ACC_WIDTH  : integer := (DWIDTH+1)+GUARD_BITS;
  
  signal acc : signed(ACC_WIDTH-1 downto 0);
  
--  attribute shreg_extract : string;
--  attribute shreg_extract of shift_reg : signal is "true";
  
begin

  SHIFT_REG_GEN: for i in 0 to DWIDTH-1 generate
  begin
    SRL_I : SRLC32E
      generic map (
        INIT => x"00000000")
      port map (
        D   => din(i),      -- SRL data input
        A   => "11111",     -- 5-bit shift depth select input
        CE  => din_vld,     -- Clock enable input
        CLK => clk,         -- Clock input
        Q   => mem_dout(i), -- SRL data output
        Q31 => open);       -- SRL cascade output pin
  end generate SHIFT_REG_GEN;

--  -- Modelado del registro de desplazamiento:
--  process(clk)
--  begin
--    if(clk'event and clk = '1') then
--      if(din_vld = '1') then
--        shift_reg <= shift_reg(N_TAPS-2 downto 0) & din;
--      end if;
--    end if;
--  end process;

--  mem_dout <= shift_reg(N_TAPS-1);
  
  -- Diferencia entre dato más antiguo y nuevo dato:
  data_dif <= signed(din(DWIDTH-1) & din) - signed(mem_dout(DWIDTH-1) & mem_dout);
  data_dif_vld <= din_vld;
  
  -- Acumulador:
  process(clk, rst)
  begin
    if(rst = '1') then
      acc <= (others => '0');
    elsif(clk'event and clk = '1') then
      if(data_dif_vld = '1') then
        acc <= acc + data_dif;
      end if;
    end if;
  end process;

  -- Datos de salida:
  dout <= std_logic_vector(acc(DWIDTH-1+AWIDTH downto AWIDTH));
    
  -- Señal de datos válidos de salida:
  process(clk, rst)
  begin
    if(rst = '1') then
      dout_vld <= '0';
    elsif(clk'event and clk = '1') then
      dout_vld <= data_dif_vld;
    end if;
  end process;
  
end rtl;

