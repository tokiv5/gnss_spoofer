library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity acquisition is
  port (
    clk     : IN std_logic;
    reset   : IN std_logic;
    i_in    : IN BLADERF_T;
    q_in    : IN BLADERF_T;
    data_a  : OUT RAM_WIDTH_T;
    data_b  : OUT RAM_WIDTH_T;
    address : OUT RAM_DEPTH_T;
    START   : IN std_logic;
    TRA_START : OUT std_logic;
    wren    : OUT std_logic;
    SAT_out : OUT std_logic_vector(31 downto 0);
    doppler_out : OUT DOPPLER_T;
    code_phase_out : OUT CODE_PHASE_T;
    max16   : OUT std_logic_vector(16 downto 0);
    timer   : OUT std_logic_vector(4 downto 0);
    state_out : OUT std_logic_vector(1 downto 0);
    write_flag  : OUT std_logic -- A flag write to host PC each frequency
  ) ;
end acquisition;

architecture arch of acquisition is

  signal complete_receive, complete_save, update, enable: std_logic;
  signal INCR_SAT : INCR_SAT_T;
  signal phaseSAT : CODE_SAT_T;
  signal detectedSAT, PRN_out, acc_out: std_logic_vector(31 downto 0);
  

  component acquisition_fsm
  port (
    clk              : IN std_logic;
    reset            : IN std_logic;
    complete_receive : IN std_logic;
    complete_save    : IN std_logic;
    START            : IN std_logic;
    update           : OUT std_logic;
    enable           : OUT std_logic
  ) ;
end component;

  component acquisition_save
  port (
    clk         : IN std_logic;
    reset       : IN std_logic;
    address     : OUT RAM_DEPTH_T;
    wren        : OUT std_logic;
    --address_b   : OUT RAM_DEPTH_T;
    data_a      : OUT RAM_WIDTH_T;
    data_b      : OUT RAM_WIDTH_T;
    update      : IN std_logic;
    complete    : OUT std_logic;
    INCR_SAT    : IN INCR_SAT_T;
    phaseSAT    : IN CODE_SAT_T;
    --max_acc_out : IN ACQ_RESULT;
    detectedSAT : IN std_logic_vector(31 downto 0)
  ) ;
  end component;

  component acquisition_cal
    port (
      clk         : IN std_logic;
      reset       : IN std_logic;
      i_in        : IN BLADERF_T;
      q_in        : IN BLADERF_T;
      detectedSAT : OUT std_logic_vector(31 downto 0);
      complete    : OUT std_logic;
      enable      : IN std_logic;
      INCR_SAT    : OUT INCR_SAT_T;
      phaseSAT    : OUT CODE_SAT_T;
      doppler_out : OUT DOPPLER_T;
      code_phase_out : OUT CODE_PHASE_T;
      max16       : OUT std_logic_vector(16 downto 0);
      timer       : OUT std_logic_vector(4 downto 0);
      PRN_out     : OUT std_logic_vector(31 downto 0);
      acc_out     : OUT std_logic_vector(31 downto 0);
      write_flag  : OUT std_logic -- A flag write to host PC each frequency
      --max_acc_out : OUT ACQ_RESULT
    ) ;
  end component;

begin
  --SAT_out <= PRN_out;
  --SAT_out <= detectedSAT;
  state_out(0) <= enable;
  state_out(1) <= update;
  SAT_out <= acc_out;
  TRA_START <= complete_save;
  f0: acquisition_fsm
  port map(
    clk => clk,
    reset => reset,
    complete_receive => complete_receive,
    complete_save    => complete_save,
    START            => START,
    update           => update,
    enable           => enable
  );

  s0: acquisition_save
  port map(
    clk         => clk,
    reset       => reset,
    address     => address,
    wren        => wren,
    data_a      => data_a, -- incr
    data_b      => data_b, -- prn + phase
    update      => update,
    complete    => complete_save,
    INCR_SAT    => INCR_SAT,
    phaseSAT    => phaseSAT,
    detectedSAT => detectedSAT
  );

  c0: acquisition_cal
  port map(
    clk         => clk,
    reset       => reset,
    i_in        => i_in,
    q_in        => q_in,
    detectedSAT => detectedSAT,
    complete    => complete_receive,
    enable      => enable,
    INCR_SAT    => INCR_SAT,
    phaseSAT    => phaseSAT,
    doppler_out => doppler_out,
    code_phase_out => code_phase_out,
    max16       => max16,
    timer       => timer,
    PRN_out     => PRN_out,
    acc_out     => acc_out,
    write_flag  => write_flag
  );
end arch ; -- arch
