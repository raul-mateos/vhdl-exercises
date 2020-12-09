library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flash_controller is
  port (
    rst           : in  std_logic;
    clk           : in  std_logic;
    usr_rqt       : in  std_logic;
    usr_done      : out  std_logic;
    usr_addr      : in  std_logic_vector(23 downto 0);
    usr_rnw       : in  std_logic;
    usr_wr_data   : in  std_logic_vector(7 downto 0);
    usr_rd_data   : out  std_logic_vector(7 downto 0);
    ---
    flash_addr    : out  std_logic_vector(23 downto 0);
    flash_data    : inout std_logic_vector(7 downto 0);
    flash_cs_n    : out  std_logic;
    flash_we_n    : out  std_logic;
    flash_oe_n    : out  std_logic);
end entity;

architecture rtl of flash_controller is
  type state_type is (
    idle,
    wr_setup,
    wr_strb,
    wr_hold,
    
    rd_setup,
    rd_strb,
    rd_hold);
  
  signal state : state_type;
  
  signal phase_len_cnt  : unsigned(7 downto 0);
  signal next_phase_len : unsigned(7 downto 0);
  signal phase_end      : std_logic;
  signal phase_init     : std_logic;
  
  signal access_start : std_logic;
  
  constant N_WR_SETUP : integer := 4;
  constant N_WR_STRB  : integer := 6;
  constant N_WR_HOLD  : integer := 2;
  
  constant N_RD_SETUP : integer := 4;
  constant N_RD_STRB  : integer := 6;
  constant N_RD_HOLD  : integer := 2;
  
  signal flash_dout     : std_logic_vector(7 downto 0);
  signal flash_dout_ce  : std_logic;
  signal flash_dout_oe  : std_logic;
  signal flash_din      : std_logic_vector(7 downto 0);
  signal flash_din_ce   : std_logic;
    
begin
 
  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (access_start = '1') then
        flash_addr <= usr_addr;
      end if;
    end if;
  end process;
  
  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (access_start = '1' and usr_rnw = '0') then
        flash_dout <= usr_wr_data;
      end if;
    end if;
  end process;
  
  flash_data <= flash_dout when (flash_dout_oe = '1') else (others => 'Z');
  
  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (flash_din_ce = '1') then
        flash_din <= flash_data;
      end if;
    end if;
  end process;
  
  usr_rd_data <= flash_din; 
  
  process(clk)
  begin
    if (clk = '1' and clk'event) then
      if (phase_init = '1' or phase_end = '1') then
        phase_len_cnt <= next_phase_len;
      else
        phase_len_cnt <= phase_len_cnt - 1;
      end if;
    end if;
  end process;
  
  phase_end <= '1' when (phase_len_cnt = 0) else '0';
  
  process(clk, rst)
  begin
    if (rst = '1') then
      state <= idle;
    elsif (clk = '1' and clk'event) then
      case state is
        when idle =>
          if(usr_rqt = '1') then
            if(usr_rnw = '1') then
              state <= rd_setup;
            else
              state <= wr_setup;
            end if;
          end if;    
        when wr_setup =>
          if(phase_end = '1') then
            state <= wr_strb;
          end if;
        when wr_strb =>
          if(phase_end = '1') then
            state <= wr_hold;
          end if;
        when wr_hold =>
          if(phase_end = '1') then
            state <= idle;      
          end if;
        
        when rd_setup =>
          if(phase_end = '1') then
            state <= rd_strb;
          end if;
        when rd_strb =>
          if(phase_end = '1') then
            state <= rd_hold;
          end if;
        when rd_hold =>
          if(phase_end = '1') then
            state <= idle;      
          end if;
        when others =>
      end case;
    end if;
  end process; 
  
  process(state, usr_rqt, usr_rnw, phase_end) -- rnw, 
  begin
    next_phase_len <= (others => '1');
    phase_init <= '0';
    usr_done <= '0';
    
    flash_cs_n <= '1';
    flash_we_n <= '1';
    flash_oe_n <= '1';
    
    access_start <= '0';
    flash_dout_ce <= '0';
    flash_dout_oe <= '0';
    flash_din_ce <= '0';
  
    case state is
      when idle =>
        phase_init <= '1';
        access_start <= usr_rqt;
        flash_dout_ce <= usr_rqt and not(usr_rnw); 
        if(usr_rnw = '1') then
          next_phase_len <= to_unsigned(N_RD_SETUP-1, 8);
        else
          next_phase_len <= to_unsigned(N_WR_SETUP-1, 8);
        end if;
      
      when wr_setup =>
        next_phase_len <= to_unsigned(N_WR_STRB-1, 8);
        flash_cs_n <= '0';
        flash_we_n <= '1';
        flash_dout_oe <= '1';
        
      when wr_strb =>
        next_phase_len <= to_unsigned(N_WR_HOLD-1, 8);
        flash_cs_n <= '0';
        flash_we_n <= '0';
        flash_dout_oe <= '1';
      
      when wr_hold =>
        usr_done <= phase_end;
        flash_cs_n <= '0';
        flash_we_n <= '1';
        flash_dout_oe <= '1';
      
        --next_phase_len <= to_unsigned(N_WR_SETUP-1, 8);        
      when rd_setup =>
        next_phase_len <= to_unsigned(N_RD_STRB-1, 8);
        flash_cs_n <= '0';
        flash_oe_n <= '0';
      
      when rd_strb =>
        next_phase_len <= to_unsigned(N_RD_HOLD-1, 8);
        flash_cs_n <= '0';
        flash_oe_n <= '0';
        flash_din_ce <= phase_end;
      
      when rd_hold =>
        usr_done <= phase_end;
        flash_cs_n <= '0';
        flash_oe_n <= '0';

        --next_phase_len <= to_unsigned(N_RD_SETUP-1, 8);        
      when others =>
    end case;
  end process; 
 
 
end rtl;

