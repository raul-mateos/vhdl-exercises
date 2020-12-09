library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity moving_average is
  port (
    rst         : in  std_logic;
    clk         : in  std_logic;

    din         : in  std_logic_vector(15 downto 0);
    din_vld     : in  std_logic;

    dout        : out std_logic_vector(15 downto 0);
    dout_vld    : out std_logic);
end entity;

architecture rtl of moving_average is
  constant DWIDTH : integer := din'length;
  constant AWIDTH : integer := 5;
--  constant AWIDTH : integer := 3;

  constant zero_16: std_logic_vector (DWIDTH-1 downto 0) := (others => '0');
    
  type mem_type is array (2**AWIDTH-1 downto 0) of std_logic_vector (DWIDTH-1 downto 0);
  signal mem : mem_type := (others => zero_16);

  signal din_cnt : unsigned(AWIDTH-1 downto 0);

  signal mem_dout : std_logic_vector(DWIDTH-1 downto 0);

  signal data_dif : signed(DWIDTH downto 0);
  signal data_dif_vld : std_logic;
    
  constant GUARD_BITS : integer := AWIDTH;
  constant ACC_WIDTH  : integer := (DWIDTH+1)+GUARD_BITS;
  
  signal acc : signed(ACC_WIDTH-1 downto 0);
  
    
begin


  process(clk, rst)
  begin
    if(rst = '1') then
      din_cnt <= (others => '0');
    elsif(clk'event and clk = '1') then
      if(din_vld = '1') then
        din_cnt <= din_cnt + 1;
      end if;
    end if;
  end process;

  -- Proceso de escritura:
  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(din_vld = '1') then
        mem(to_integer(din_cnt)) <= din;
      end if;
    end if;
  end process;

  -- Proceso de lectura:
  mem_dout <= mem(to_integer(din_cnt));
  
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

