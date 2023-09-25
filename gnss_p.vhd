library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;

package gnss_p is
  subtype BLADERF_T      is std_logic_vector(15 downto 0);
  subtype BLADERF_AD_T   is std_logic_vector(11 downto 0); -- ADC use 12 bits input so number of meaningful bits in bladerf are 12
  subtype DOPPLER_T      is std_logic_vector(6 downto 0); -- -50 to 50
  subtype CODE_PHASE_T   is std_logic_vector(9 downto 0); -- 0 to 1023
  subtype SIMP_T         is std_logic_vector(7 downto 0); -- Half of Bladerf 16 bits to save resource
  subtype RAM_WIDTH_T    is std_logic_vector(31 downto 0);
  subtype RAM_DEPTH_T    is std_logic_vector(3 downto 0);
  subtype PRN_T          is std_logic_vector(31 downto 0);
  subtype SAT_T         is integer range 0 to 31;
  type SIMP_SAT_T       is array(31 downto 0) of SIMP_T;
  type BLADERF_SAT_T    is array(31 downto 0) of BLADERF_T; -- Used in acquisition channels, 5 channels in total
  type INCR_SAT_T       is array(31 downto 0) of RAM_WIDTH_T;
  type BLADERF_OUTPUT_T is array(4 downto 0) of BLADERF_T; -- Used in output channels, 5 channels in total
  type BLADERF_AD_OUTPUT_T is array(4 downto 0) of BLADERF_AD_T;
  type INCR_OUTPUT_T    is array(4 downto 0) of RAM_WIDTH_T ;
  type CA_OUTPUT_T      is array(4 downto 0) of PRN_T;
  type PHASE_OUTPUT_T   is array(4 downto 0) of CODE_PHASE_T;
  type SAT_OUTPUT_T     is array(4 downto 0) of SAT_T;
  type DOP_OUTPUT_T     is array(4 downto 0) of DOPPLER_T;
  type CA_STEP_OUTPUT_T is array(4 downto 0) of std_logic_vector(31 downto 0);
  type DOPPLER_SAT_T    is array(31 downto 0) of DOPPLER_T;
  type CODE_SAT_T       is array(31 downto 0) of CODE_PHASE_T;

  subtype PR_T          is std_logic_vector(31 downto 0);
  type PR_OUTPUT_T      is array(4 downto 0) of PR_T;
  subtype PR_ADDR_T     is std_logic_vector(10 downto 0);
  -- type PR_ADDR_OUTPUT_T is array(4 downto 0) of PR_ADDR_T;

  type MULT_RESULT  is array(31 downto 0) of std_logic_vector(31 downto 0);
  type ACCUM_RESULT is array(31 downto 0) of std_logic_vector(31 downto 0);
  type ACQ_RESULT   is array(31 downto 0) of std_logic_vector(16 downto 0); -- Sum of iq accumulation(absolute value)

  subtype DATA_RAM_ADDR_T is std_logic_vector(13 downto 0);
  type DATA_RAM_OUTPUT_T is array(4 downto 0) of DATA_RAM_ADDR_T;

  type EPOCH_COUNT_T     is array(4 downto 0) of integer range 0 to 19;
  type TIMER_OUTPUT_T    is array(4 downto 0) of integer range 0 to 7;


  constant F_SAMPLE : natural := 4092000; -- 10.23 MHz


  -- fixed point value, unsigned from 0 to 1 in format 0.xxxx. Show how many code chips pass in a cycle. = 0.05115
  -- Should be changed if changed fsample. = 1.023e6 / (2 * fs)
  -- Actual value is 0.0511474609375 
  -- !!! Too low precision, should be changed to 32 bits !!! 0.11 chips offset in a 20 second acqusition
  constant CA_INC_PER_CYCLE : std_logic_vector(15 downto 0) := "0000011010001100"; -- not used now
  constant FIXED_POINT_PI   : std_logic_vector(15 downto 0) := "0110010010000110"; -- PI in fixed point format with 13 fraction bits
  constant FIXED_NEG_PI     : std_logic_vector(15 downto 0) := "1001101101111010";
  constant FIXED_POINT_2PI  : std_logic_vector(16 downto 0) := "01100100100001100";
  --constant ACQ_THRESHOLD    : std_logic_vector(16 downto 0) := "00000000101000000";
  constant ACQ_THRESHOLD    : std_logic_vector(16 downto 0) := conv_std_logic_vector(592, 17);

  -- step = 2*pi*f_d_step*(1/2fs) = pi*200/10.23M = 6.1419e-5, Actual value is 0.00006103515625 => actual fd_step is 198.7494 hz
  -- constant DOP_FREQ_STEP    : std_logic_vector(15 downto 0) := "0000000000000010"; -- 1 int bits + 15 fraction bits
  --constant DOP_FREQ_STEP    : std_logic_vector(15 downto 0) := conv_std_logic_vector(20992, 16);
  constant DOP_FREQ_STEP    : std_logic_vector(15 downto 0) := conv_std_logic_vector(26240, 16);
  
  -- CA frequency will influenced by doppler frequency as f_ca=1.023e6+f_dop/1540
  -- Introduce a step to reflect this diff, CA_CORRECTION_STEP=1/2fs*dop_step/1540*2^33=1/8.184e6*200/1540*2^33=136
  constant CA_CORRECTION_STEP : std_logic_vector(15 downto 0) := conv_std_logic_vector(136, 16);
  constant CA_JUMP            : std_logic_vector(31 downto 0) := "01000000000000000000000000000000"; -- 1/8 code chip
  constant CA_STAY            : std_logic_vector(31 downto 0) := "11000000000000000000000000000000";

  -- Doppler frequency is calculated based on change of pseudo range
  -- f_d = PR_CHANGE / d_t / LAMDA_L1  nco_step = f_d * 2^32 / (2*f_s)
  -- d_t = 6  LAMDA_L1 = 0.19  2*f_s(clock frequency) = 8.184e6
  -- nco_step = PR_CHANGE * 460
  -- constant DOP_PR_DIFF_COEFFICIENT : std_logic_vector(15 downto 0) := conv_std_logic_vector(460, 16);
  constant DOP_PR_DIFF_COEFFICIENT : std_logic_vector(15 downto 0) := conv_std_logic_vector(3677, 16);

  -- CA frequency will influenced by doppler frequency as f_ca=1.023e6+f_dop/1540
  -- f_d = PR_CHANGE / d_t / LAMDA_L1
  -- To make the number big enough to calculate, we move it left 33 bits
  -- ca_correction_step = f_d / 1540 / (2*f_s) * 2^33 (Because CA_JUMP is 1/8 * 2^33)
  -- To keep more information and precision, we use ca_correction_step = PR_CHANGE / d_t / LAMDA_L1 / 1540 / (2*f_s) * 2^43 >> 10
  constant CODE_CORRECTION_COEFFICIENT : std_logic_vector(15 downto 0) := conv_std_logic_vector(611, 16);

  constant SPEED_OF_LIGHT : std_logic_vector(31 downto 0) := conv_std_logic_vector(299792458, 32);
  constant c1_div_8_LIGHT  : std_logic_vector(31 downto 0) := conv_std_logic_vector(37474057, 32);
  constant c2_div_8_LIGHT  : std_logic_vector(31 downto 0) := conv_std_logic_vector(74948114, 32);
  constant c3_div_8_LIGHT  : std_logic_vector(31 downto 0) := conv_std_logic_vector(112422172, 32);
  constant c4_div_8_LIGHT  : std_logic_vector(31 downto 0) := conv_std_logic_vector(149896229, 32);
  constant c5_div_8_LIGHT  : std_logic_vector(31 downto 0) := conv_std_logic_vector(187370286, 32);
  constant c6_div_8_LIGHT  : std_logic_vector(31 downto 0) := conv_std_logic_vector(224844343, 32);
  constant c7_div_8_LIGHT  : std_logic_vector(31 downto 0) := conv_std_logic_vector(262318401, 32);

  constant BIT_PERIOD     : std_logic_vector(31 downto 0) := conv_std_logic_vector(20, 32);

end package ;
