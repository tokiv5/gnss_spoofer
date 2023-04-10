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
    address     : OUT RAM_DEPTH_T;
    incr        : IN  RAM_WIDTH_T;
    prn_phase   : IN  RAM_WIDTH_T;
    signal_out_i: OUT BLADERF_OUTPUT_T;
    signal_out_q: OUT BLADERF_OUTPUT_T
  ) ;
end transmitter_gen;

architecture arch of transmitter_gen is

  signal incr_channels   : INCR_OUTPUT_T; -- Increment values from ram
  signal phase_channels  : PHASE_OUTPUT_T; -- 1 + 5 + 10 saved in ram
  signal prn_channels    : SAT_OUTPUT_T;
  signal sin_out         : BLADERF_OUTPUT_T;
  signal cos_out         : BLADERF_OUTPUT_T;
  signal cnt_reg         : integer range 0 to 4;

  signal sin_out_12      : BLADERF_AD_OUTPUT_T;
  signal cos_out_12      : BLADERF_AD_OUTPUT_T;

  signal rst_n : std_logic;
  signal addressa_inner  : RAM_DEPTH_T;

  signal CA_channels     : CA_OUTPUT_T;
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

  component transmitter_CA is
    generic (
      PHASE_ADVANCE : integer := 1; -- Code phase advance caused by time spent for ram r/w
      TIMER_ADVANCE : integer := 16
    );
    port (
      clk                : IN std_logic;
      reset              : IN std_logic;
      PRN                : OUT std_logic_vector(31 downto 0);
      enable             : IN std_logic;
      code_phase         : IN CODE_PHASE_T;
      epoch              : OUT std_logic
    ) ;
  end component transmitter_CA;
begin
  --signal_out_i <= sin_out when ;
  --signal_out_q <= cos_out;
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

    c0: transmitter_CA
    port map(
      clk        => clk,
      reset      => reset,
      PRN        => CA_channels(i),
      enable     => enable,
      code_phase => phase_channels(i),
      epoch      => open
    );

    signal_out_i(i) <= sin_out(i) when CA_channels(i)(prn_channels(i)) = '1' else
      (not sin_out(i)) + 1;
    signal_out_q(i) <= cos_out(i) when CA_channels(i)(prn_channels(i)) = '1' else
      (not cos_out(i)) + 1;
  end generate;



  address <= conv_std_logic_vector(update_cnt, 4) when update = '1' else
    (others => '0');
  UPDATE_PRO : process( clk, reset )
  begin
    if reset = '1' then
      incr_channels    <= (others => (others => '0'));
      phase_channels   <= (others => (others => '0'));
      prn_channels     <= (others => 0);
      cnt_reg          <= 0;
      -- addressa_inner   <= conv_std_logic_vector(0, 4);
      -- addressb         <= 
    elsif rising_edge(clk) then
      cnt_reg <= update_cnt;
      if update = '1' then
        -- addressa_inner            <= conv_std_logic_vector(update_cnt, 4);
        -- addressb <= conv_std_logic_vector(update_cnt + 5, 4);
        if prn_phase(15) = '1' then
          incr_channels(cnt_reg)    <= incr;
          phase_channels(cnt_reg)   <= prn_phase(9 downto 0);
          prn_channels(cnt_reg)     <= conv_integer(unsigned(prn_phase(14 downto 10)));
        end if ;

      else
        -- addressa_inner            <= conv_std_logic_vector(0, 4);
      end if ;
    end if ;
    
  end process ; -- UPDATE_PRO

end arch ; -- arch