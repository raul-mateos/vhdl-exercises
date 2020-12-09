library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_generator is
  port (
    rst         : in  std_logic;
    clk         : in  std_logic;
    period      : in  std_logic_vector(15 downto 0);
    duty_cycle  : in  std_logic_vector(15 downto 0);
    pwm_out     : out std_logic);
end entity;

architecture rtl of pwm_generator is
  type state_type is (
    going_up, 
    going_down);
  signal state : state_type;
  signal up_down      : std_logic;

  signal carrier      : unsigned(15 downto 0);
  signal carrier_max  : std_logic;
  signal carrier_min  : std_logic;
  signal period_end   : std_logic;
  signal duty_cycle_reg : std_logic_vector(15 downto 0);
begin

  process(clk, rst)
  begin
    if(rst = '1') then
      duty_cycle_reg <= (others => '0');
    elsif(clk'event and clk = '1') then
      if(period_end = '1') then
        duty_cycle_reg <= duty_cycle;
      end if;
    end if;
  end process;

  -------------------------------------

  process(clk, rst)
  begin
    if(rst = '1') then
      carrier <= (others => '0');
    elsif(clk'event and clk = '1') then
      if(up_down = '1') then
        carrier <= carrier + 1;
      else  
        carrier <= carrier - 1;
      end if;
    end if;
  end process;
  
  carrier_max <= '1' when (carrier = unsigned(period)) else '0';
  carrier_min <= '1' when (carrier = 0) else '0';


  process(clk, rst)
  begin
    if(rst = '1') then
      state <= going_up;
    elsif(clk'event and clk = '1') then
      case state is
        when going_up =>
          if(carrier_max = '1') then
            state <= going_down;
          end if;
        when going_down =>
          if(carrier_min = '1') then
            state <= going_up;
          end if;
        when others =>
      end case; 
    end if;
  end process;

  process(state, carrier_max, carrier_min)
  begin
    up_down <= '0';
    period_end <= '0';
  
    case state is
      when going_up =>
        up_down <= '1';
        if (carrier_max = '1') then
          up_down <= '0';
        end if;
              
      when going_down =>
        up_down <= '0';
        if (carrier_min = '1') then
          up_down <= '1';
        end if;
        period_end <= carrier_min;
        
      when others =>
    end case; 
  end process;

  process(clk, rst)
  begin
    if(rst = '1') then
      pwm_out <= '0';
    elsif(clk'event and clk = '1') then
      if(carrier >= unsigned(duty_cycle_reg)) then
        pwm_out <= '0';
      else
        pwm_out <= '1';
      end if;
    end if;
  end process;
  
end rtl;

