library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stream_upsizer is
  port (
    rst         : in  std_logic;
    clk         : in  std_logic;

    din         : in  std_logic_vector(7 downto 0);
    din_start   : in  std_logic;
    din_end     : in  std_logic;
    din_vld     : in  std_logic;

    dout        : out std_logic_vector(31 downto 0);
    dout_strb   : out std_logic_vector(3 downto 0);
    dout_start  : out std_logic;
    dout_end    : out std_logic;
    dout_vld    : out std_logic);
end entity;

architecture rtl of stream_upsizer is
  constant DIN_WIDTH  : integer := din'length;
  constant DOUT_WIDTH : integer := dout'length;
  constant DWIDTH_RATIO : integer := DOUT_WIDTH/DIN_WIDTH;
  
  signal byte_sel   : std_logic_vector(DWIDTH_RATIO-1 downto 0);
  signal last_byte  : std_logic;
    
  signal first_word : std_logic;
  
  signal dout_strb_i : std_logic_vector(DWIDTH_RATIO-1 downto 0);
  
begin

  process(clk, rst)
  begin
    if(rst = '1') then
      byte_sel <= (others => '0');
      byte_sel(0) <= '1';
    elsif(clk'event and clk = '1') then
      if(din_vld = '1') then
        if(din_end = '1') then
          byte_sel <= (others => '0');
          byte_sel(0) <= '1';
        else
          byte_sel <= byte_sel(DWIDTH_RATIO-2 downto 0) & byte_sel(DWIDTH_RATIO-1);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(din_vld = '1') then
        for i in 0 to DWIDTH_RATIO-1 loop
          if(byte_sel(i) = '1') then
            dout(DIN_WIDTH*(i+1)-1 downto DIN_WIDTH*i) <= din;
          end if;
        end loop;
      end if;
    end if;
  end process;
  
  last_byte <= byte_sel(DWIDTH_RATIO-1) or din_end;
  
  process(clk, rst)
  begin
    if(rst = '1') then
      dout_vld <= '0';
      dout_end <= '0';
    elsif(clk'event and clk = '1') then
      dout_vld <= din_vld and last_byte;
      dout_end <= din_vld and din_end;
    end if;
  end process;
  

  process(clk, rst)
  begin
    if(rst = '1') then
      first_word <= '1';
    elsif(clk'event and clk = '1') then
      if(din_vld = '1') then
        if(din_end = '1') then
          first_word <= '1';
        elsif(last_byte = '1') then
          first_word <= '0';
        end if;
      end if;
    end if;
  end process;
  
  process(clk, rst)
  begin
    if(rst = '1') then
      dout_start <= '0';
    elsif(clk'event and clk = '1') then
      dout_start <= first_word and last_byte and din_vld;
    end if;
  end process;
  
  
  process(clk, rst)
  begin
    if(rst = '1') then
      dout_strb_i <= (others => '0');
    elsif(clk'event and clk = '1') then
      if(din_vld = '1') then
        if(byte_sel(0) = '1') then
          dout_strb_i <= (others => '0');
          dout_strb_i(0) <= '1';
        else
          dout_strb_i <= dout_strb_i or byte_sel;
        end if;
      end if;
    end if;
  end process;
  
  dout_strb <= dout_strb_i;
  
end rtl;

