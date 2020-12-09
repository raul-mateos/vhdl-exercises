library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mono_stable is
  port (
    rst           : in  std_logic;
    clk           : in  std_logic;
    trigger       : in  std_logic;
    pulse_length  : in  std_logic_vector(9 downto 0);
    pulse         : out std_logic);
end entity;

architecture rtl of mono_stable is

  signal trigger_r  : std_logic;
  signal pos_edge   : std_logic;
  signal pulse_i    : std_logic;

  signal pulse_cnt  : unsigned(9 downto 0);
  signal pulse_end  : std_logic;
  signal pulse_init : std_logic;
  
begin

  -- Detección de flanco ascendente:
  process(clk, rst)
  begin
    if(rst = '1') then
      trigger_r <= '0';
    elsif(clk'event and clk = '1') then
      trigger_r <= trigger;
    end if;
  end process;
  pos_edge <= trigger and not(trigger_r);

  -- Control del estado de salida:
  process(clk, rst)
  begin
    if(rst = '1') then
      pulse_i <= '0';
    elsif(clk'event and clk = '1') then
      if (pulse_i = '0') then
        if (pos_edge = '1') then
          pulse_i <= '1';
        end if;
      else
        if (pulse_end = '1') then
          pulse_i <= '0';
        end if;
      end if;
    end if;
  end process;
  
  pulse <= pulse_i;

  -- Control duración estado activo:
  -- Recargamos el contador mientras el monoestable no esté activo, o 
  -- cuando alcancemos el fin de cuenta (fin del estado estable).
    
  pulse_init <= not(pulse_i) or pulse_end;
  
  process(clk)
  begin
    if(clk'event and clk = '1') then
      if (pulse_init = '1') then
        pulse_cnt <= unsigned(pulse_length);
      else
        pulse_cnt <= pulse_cnt - 1;
      end if;
    end if;
  end process;
  
  pulse_end <= '1' when (pulse_cnt = 0) else '0';
  
end rtl;  
  