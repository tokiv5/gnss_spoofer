library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity transmitter_gen is
  port (
    clk         : IN std_logic;
    reset       : IN std_logic;
    enable      : IN std_logic;
    update      : IN std_logic;
    update_cnt  : IN integer range 0 to 4;
    addressa    : OUT RAM_DEPTH_T;
    addressb    : OUT RAM_DEPTH_T;
    incr        : IN  RAM_WIDTH_T;
    prn_phase   : IN  RAM_WIDTH_T;
    signal_out_i: OUT BLADERF_OUTPUT_T;
    signal_out_q: OUT BLADERF_OUTPUT_T
  ) ;
end transmitter_gen;

architecture arch of transmitter_gen is

  signal incr_channels   : INCR_OUTPUT_T; -- Increment values from ram
  signal phase_channels_1: PHASE_OUTPUT_T; -- 5 + 10 + 10 saved in ram
  signal phase_channels_2: PHASE_OUTPUT_T;
  signal prn_channels    : SAT_OUTPUT_T;
  signal sin_out         : BLADERF_OUTPUT_T;
  signal cos_out         : BLADERF_OUTPUT_T;
  signal cnt_reg         : integer range 0 to 4;

  signal sin_out_12      : BLADERF_AD_OUTPUT_T;
  signal cos_out_12      : BLADERF_AD_OUTPUT_T;

  signal rst_n : std_logic;
  signal addressa_inner  : RAM_DEPTH_T;
  component nco is
		port (
			clk       : in  std_logic                     := 'X';             -- clk
			reset_n   : in  std_logic                     := 'X';             -- reset_n
			clken     : in  std_logic                     := 'X';             -- clken
			phi_inc_i : in  std_logic_vector(31 downto 0) := (others => 'X'); -- phi_inc_i
			fsin_o    : out std_logic_vector(11 downto 0);                    -- fsin_o
			fcos_o    : out std_logic_vector(11 downto 0);                    -- fcos_o
			out_valid : out std_logic                                         -- out_valid
		);
	end component nco;
begin
  signal_out_i <= sin_out;
  signal_out_q <= cos_out;
  rst_n        <= not reset;
  NCO_GEN: for i in 0 to 4 generate
    n0 : nco 
    port map(
      clk       => clk,
      reset_n   => rst_n,
      clken     => enable,
      phi_inc_i => incr_channels(i),
      fsin_o    => sin_out_12(i),
      fcos_o    => cos_out_12(i),
      out_valid => open
    );
    sin_out(i)(11 downto 0)  <= sin_out_12(i);
    cos_out(i)(11 downto 0)  <= cos_out_12(i);
    sin_out(i)(15 downto 12) <= (others => sin_out_12(i)(11));
    cos_out(i)(15 downto 12) <= (others => cos_out_12(i)(11));
  end generate;

  addressa_inner <= conv_std_logic_vector(update_cnt, 4) when update = '1' else
    (others => '0');
  addressa       <= addressa_inner;
  addressb       <= addressa_inner + 5;
  UPDATE_PRO : process( clk, reset )
  begin
    if reset = '1' then
      incr_channels    <= (others => (others => '0'));
      phase_channels_1 <= (others => (others => '0'));
      phase_channels_2 <= (others => (others => '0'));
      prn_channels     <= (others => 0);
      cnt_reg          <= 0;
      -- addressa_inner   <= conv_std_logic_vector(0, 4);
      -- addressb         <= 
    elsif rising_edge(clk) then
      cnt_reg <= update_cnt;
      if update = '1' then
        -- addressa_inner            <= conv_std_logic_vector(update_cnt, 4);
        -- addressb <= conv_std_logic_vector(update_cnt + 5, 4);

        incr_channels(cnt_reg)    <= incr;
        phase_channels_1(cnt_reg) <= prn_phase(9 downto 0);
        phase_channels_2(cnt_reg) <= prn_phase(19 downto 10);
        prn_channels(cnt_reg)     <= conv_integer(prn_phase(24 downto 20));
      else
        -- addressa_inner            <= conv_std_logic_vector(0, 4);
      end if ;
    end if ;
    
  end process ; -- UPDATE_PRO

end arch ; -- arch