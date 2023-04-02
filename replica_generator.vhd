library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use work.gnss_p.all;

entity replica_generator is
  port (
    clk                : IN  std_logic;
    reset              : IN  std_logic;
    enable             : IN  std_logic;
    SAT                : IN  SAT_T;
    DOPPLER            : IN  DOPPLER_T;
    i_out              : OUT BLADERF_AD_T;
    q_out              : OUT BLADERF_AD_T;
    valid              : OUT std_logic;
    phase_period_epoch : out std_logic; -- 1023 phase high level loop completion flag
    code_phase         : OUT CODE_PHASE_T;
    sin_in             : IN  BLADERF_AD_T;
    cos_in             : IN  BLADERF_AD_T;
    epoch              : OUT std_logic -- show that 1023 chips go over
  ) ;
end replica_generator;

architecture arch of replica_generator is

  signal PRN_out       : std_logic;


  component L1_CA_generator
    port(
      clk                : IN  std_logic;
      rst                : IN  std_logic;
      PRN                : OUT std_logic;
      ENABLE             : IN  std_logic;
      valid_out          : out std_logic;
      epoch_out          : out STD_LOGIC;
      SAT                : in  SAT_T;
      phase_period_epoch : out std_logic;
      code_phase_out     : out CODE_PHASE_T
    );
  end component;

begin
  -- Change this for signed value


  i_out <= sin_in when PRN_out = '1' else ((not sin_in) + 1);
  --i_out(15 downto 13) <= (others => sin_out(12));
  q_out <= cos_in when PRN_out = '1' else ((not cos_in) + 1);
  --q_out(15 downto 13) <= (others => cos_out(12));



  L0 : L1_CA_generator
  port map(
    clk                => clk,
    rst                => reset,
    PRN                => PRN_out,
    ENABLE             => enable,
    valid_out          => valid,
    epoch_out          => epoch,
    SAT                => SAT,
    phase_period_epoch => phase_period_epoch,
    code_phase_out     => code_phase
  );

end arch ; -- arch