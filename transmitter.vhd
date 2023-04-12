library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity transmitter is
  port (
    clk         : IN std_logic;
    reset       : IN std_logic;
    START       : IN  std_logic; -- start to load
    ENDING      : IN  std_logic; -- end to transmit
    address     : OUT RAM_DEPTH_T;
    incr        : IN  RAM_WIDTH_T;
    prn_phase   : IN  RAM_WIDTH_T;
    signal_sca_i: OUT BLADERF_T; -- rescale after adding up
    signal_sca_q: OUT BLADERF_T
  ) ;
end transmitter;

architecture arch of transmitter is

  signal update     : std_logic;
  signal update_cnt : integer range 0 to 4;
  signal enable     : std_logic;
  component transmitter_fsm is
    port (
      clk         : IN  std_logic;
      reset       : IN  std_logic;
      START       : IN  std_logic; -- start to load
      ENDING      : IN  std_logic; -- end to transmit
      update      : OUT std_logic; -- enable signal for updating nco frequency code offset
      enable      : OUT std_logic; -- NCO enable to transmit
      update_cnt  : OUT integer range 0 to 4
    ) ;
  end component;

  component transmitter_gen is
    port (
      clk         : IN std_logic;
      reset       : IN std_logic;
      enable      : IN std_logic;
      update      : IN std_logic;
      update_cnt  : IN integer range 0 to 4;
      address     : OUT RAM_DEPTH_T;
      incr        : IN  RAM_WIDTH_T;
      prn_phase   : IN  RAM_WIDTH_T;
      signal_sca_i: OUT BLADERF_T; -- rescale after adding up
      signal_sca_q: OUT BLADERF_T
    ) ;
  end component;
begin
  f0: transmitter_fsm
  port map(
    clk        => clk,
    reset      => reset,
    START      => START,
    ENDING     => ENDING,
    update     => update,
    enable     => enable,
    update_cnt => update_cnt
  );

  g0: transmitter_gen
  port map(
    clk          => clk,
    reset        => reset,
    enable       => enable,
    update       => update, 
    update_cnt   => update_cnt,
    address      => address,
    incr         => incr,
    prn_phase    => prn_phase,
    signal_sca_i => signal_sca_i,
    signal_sca_q => signal_sca_q
  );
end arch ; -- arch