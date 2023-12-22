library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity dna_protect_v2 is
  generic (
    C_CLK_PERIOD_PS   : integer;
    C_TIMEOUT_SEC     : integer;
    C_DEV_DNA         : std_logic_vector);
  port (
    init_rst    : in  std_logic;
    init_clk    : in  std_logic;
    usr_rst     : in  std_logic;
    usr_clk     : in  std_logic;
    dna_match   : out std_logic;
    dna_timeout : out std_logic);
end entity;

architecture rtl of dna_protect_v2 is
  constant DNA_LEN  : integer := 96;

  constant SIM_DNA  : std_logic_vector(DNA_LEN-1 downto 0) := x"800000000000000000000005";
--  constant SIM_DNA  : std_logic_vector(DNA_LEN-1 downto 0) := C_DEV_DNA;

  signal dna_dout : std_logic;

  type state_type is (
    idle,
    init_dna,
    check_dna,
    check_done);

  signal state      : state_type;

  signal bit_cnt  : unsigned(6 downto 0);
  signal bit_clr  : std_logic;
  signal bit_inc  : std_logic;
  signal bit_end  : std_logic;

  signal shift_reg  : std_logic_vector(DNA_LEN-1 downto 0);
  signal shift_ld   : std_logic;
  signal shift_ce   : std_logic;
  signal shift_dout : std_logic;

  signal bit_err    : std_logic;
  signal dna_err_i  : std_logic;
  signal dna_ok     : std_logic := '0';

  signal dna_err_vld  : std_logic;

  constant TIMEOUT_ms     : integer := C_TIMEOUT_SEC*1000;
  
  function calc_prescaler_factor return integer is
    variable factor : integer;
  begin
    factor := 1000*(1_000_000_000/C_CLK_PERIOD_PS);
-- pragma translate_off
    factor := 3;
-- pragma translate_on
    return factor;
  end function calc_prescaler_factor;
  
  constant PRESCALER_FACTOR : integer := calc_prescaler_factor;
  signal prescaler_cnt  : integer range 0 to PRESCALER_FACTOR-1;
  signal prescaler_end  : std_logic;

  signal timeout_clr  : std_logic;
  signal timeout_run  : std_logic;
  signal timeout_end  : std_logic;
  signal usr_dna_ok   : std_logic;
  
  signal sec_cnt      : integer range 0 to C_TIMEOUT_SEC-1;
  signal sec_cnt_clr  : std_logic;
  signal sec_cnt_inc  : std_logic;
  signal sec_cnt_end  : std_logic;

  signal dna_timeout_i  : std_logic;
  
begin

  DNA_PORT_I : DNA_PORTE2
    generic map (
      SIM_DNA_VALUE => SIM_DNA) -- Specifies a sample 96-bit DNA value for simulation.
    port map (
      DIN   => '0',         -- 1-bit input: User data input pin.
      READ  => shift_ld,    -- 1-bit input: Active-High load DNA, active-Low read input.
      SHIFT => shift_ce,    -- 1-bit input: Active-High shift enable input.
      CLK   => init_clk,    -- 1-bit input: Clock input.
      DOUT  => dna_dout);   -- 1-bit output: DNA output data.

  process(init_clk)
  begin
    if (init_clk'event and init_clk = '1') then
      if (bit_clr = '1' or (bit_end and bit_inc) = '1') then
        bit_cnt <= (others => '0');
      elsif (bit_inc = '1') then
        bit_cnt <= bit_cnt + 1;
      end if;
    end if;
  end process;

  bit_end <= '1' when (bit_cnt = DNA_LEN-1) else '0';

  process(init_clk)
  begin
    if (init_clk'event and init_clk = '1') then
      if (shift_ld = '1') then
        shift_reg <= C_DEV_DNA;
      elsif (shift_ce = '1') then
        shift_reg <= '0' & shift_reg(DNA_LEN-1 downto 1);
      end if;
    end if;
  end process;

  shift_dout <= shift_reg(0);


  process(init_clk)
  begin
    if (init_clk'event and init_clk = '1') then
      if (init_rst = '1') then
        state <= idle;
        dna_err_vld <= '0';
      else
        dna_err_vld <= '0';
        case state is
          when idle =>
            state <= init_dna;
          when init_dna =>
            state <= check_dna;
          when check_dna =>
            if (bit_end = '1') then
              state <= check_done;
              dna_err_vld <= '1';
            end if;
          when check_done =>

          when others => null;
        end case;
      end if;
    end if;
  end process;

  process(state, dna_err_i)
  begin
    bit_clr <= '1';
    bit_inc <= '0';

    shift_ld <= '0';
    shift_ce <= '0';

    case state is
      when idle =>
      when init_dna =>
        shift_ld <= '1';
      when check_dna =>
        bit_clr <= '0';
        bit_inc <= '1';

        shift_ce <= '1';
      when check_done =>

      when others => null;
    end case;
  end process;


  bit_err <= shift_dout xor dna_dout;

  process(init_clk)
  begin
    if (init_clk'event and init_clk = '1') then
      if (shift_ld = '1' or init_rst = '1') then
        dna_err_i <= '0';
      elsif (shift_ce = '1') then
        dna_err_i <= dna_err_i or bit_err;
      end if;
    end if;
  end process;


  -----
  
  process(init_clk)
  begin
    if (init_clk'event and init_clk = '1') then
      if (init_rst = '1') then
        dna_ok <= '0';
      elsif ((bit_inc and bit_end) = '1') then
        dna_ok <= not(dna_err_i or bit_err);
      end if;
    end if;
  end process;
    
  -----------------------------
  
  ID_ERR_SYNCER: entity work.soft_sync
    generic map (
      INIT    => '0',
      LATENCY => 3)
    port map (
      din   => dna_ok,
      clk   => usr_clk,
      dout  => usr_dna_ok);

  dna_match <= usr_dna_ok;
  
  timeout_end <= (sec_cnt_inc and sec_cnt_end);

  timeout_clr <= timeout_end or usr_dna_ok;
    
  -- Cuando se activa 'dna_err_vld' en 'dna_err_i' tenemos el estado de la comprobación

  process(usr_clk)
  begin
    if (usr_clk'event and usr_clk = '1') then
      if (usr_rst = '1') then
        timeout_run <= '1';
      else
        if (timeout_clr = '1') then
          timeout_run <= '0';
        end if;
      end if;
    end if;
  end process;

  sec_cnt_clr <= usr_rst or not(timeout_run);

  process(usr_clk)
  begin
    if (usr_clk'event and usr_clk = '1') then
      if (sec_cnt_clr = '1' or prescaler_end = '1') then
        prescaler_cnt <= PRESCALER_FACTOR-1;
        prescaler_end <= '0';
      else
        prescaler_cnt <= prescaler_cnt - 1;
        if (prescaler_cnt = 1) then
          prescaler_end <= '1';
        else
          prescaler_end <= '0';
        end if;
      end if;
    end if;
  end process;

  sec_cnt_inc <= prescaler_end;

  process(usr_clk)
  begin
    if (usr_clk'event and usr_clk = '1') then
      if (sec_cnt_clr = '1' or (sec_cnt_inc and sec_cnt_end) = '1') then
        sec_cnt <= 0;
      elsif (sec_cnt_inc = '1') then
        sec_cnt <= sec_cnt + 1;
      end if;
    end if;
  end process;

  sec_cnt_end <= '1' when (sec_cnt = C_TIMEOUT_SEC-1) else '0';

  
  ---

  process(usr_clk)
  begin
    if (usr_clk'event and usr_clk = '1') then
      if (usr_rst = '1') then
        dna_timeout_i <= '0';
      else
        if (dna_timeout_i = '0') then
          dna_timeout_i <= timeout_run and timeout_end;
        end if;
      end if;
    end if;
  end process;

  dna_timeout <= dna_timeout_i;

end rtl;
    