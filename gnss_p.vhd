library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;

package gnss_p is
  subtype BLADERF_T      is std_logic_vector(15 downto 0);
  subtype DOPPLER_T      is std_logic_vector(6 downto 0); -- -50 to 50
  subtype CODE_PHASE_T   is std_logic_vector(9 downto 0);
  type BLADERF_SAT_T  is array(31 downto 0) of BLADERF_T;
  type DOPPLER_SAT_T  is array(31 downto 0) of DOPPLER_T;
  type CODE_SAT_T     is array(31 downto 0) of CODE_PHASE_T;
  subtype SAT_T          is integer range 0 to 31;

  type MULT_RESULT  is array(31 downto 0) of std_logic_vector(31 downto 0);
  type ACCUM_RESULT is array(31 downto 0) of std_logic_vector(35 downto 0);
  type ACQ_RESULT   is array(31 downto 0) of std_logic_vector(32 downto 0); -- Sum of iq accumulation(absolute value)

  constant F_SAMPLE : natural := 10230000; -- 10.23 MHz


  -- fixed point value, unsigned from 0 to 1 in format 0.xxxx. Show how many code chips pass in a cycle. = 0.05115
  -- Should be changed if changed fsample. = 1.023e6 / (2 * fs)
  -- Actual value is 0.0511474609375 
  -- !!! Too low precision, should be changed to 32 bits !!! 0.11 chips offset in a 20 second acqusition
  constant CA_INC_PER_CYCLE : std_logic_vector(15 downto 0) := "0000011010001100"; -- not used now
  constant FIXED_POINT_PI   : std_logic_vector(15 downto 0) := "0110010010000110"; -- PI in fixed point format with 13 fraction bits
  constant FIXED_NEG_PI     : std_logic_vector(15 downto 0) := "1001101101111010";
  constant FIXED_POINT_2PI  : std_logic_vector(16 downto 0) := "01100100100001100";
  constant ACQ_THRESHOLD    : std_logic_vector(48 downto 0) := (others => '0');

  -- step = 2*pi*f_d_step*(1/2fs) = pi*200/10.23M = 6.1419e-5, Actual value is 0.00006103515625 => actual fd_step is 198.7494 hz
  constant DOP_FREQ_STEP    : std_logic_vector(15 downto 0) := "0000000000000010"; -- 1 int bits + 15 fraction bits
end package ;