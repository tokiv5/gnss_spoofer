library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity transmitter_tb is
end transmitter_tb;

architecture arch of transmitter_tb is

  signal clk, reset, START, ENDING : std_logic := '0';
  signal address : RAM_DEPTH_T;
  signal qa, qb : RAM_WIDTH_T;
  signal out_i, out_q : BLADERF_OUTPUT_T;
  component transmitter is
    port (
      clk         : IN std_logic;
      reset       : IN std_logic;
      START       : IN  std_logic; -- start to load
      ENDING      : IN  std_logic; -- end to transmit
      address     : OUT RAM_DEPTH_T;
      incr        : IN  RAM_WIDTH_T;
      prn_phase   : IN  RAM_WIDTH_T;
      signal_out_i: OUT BLADERF_OUTPUT_T;
      signal_out_q: OUT BLADERF_OUTPUT_T
    ) ;
  end component;
  
  component fake_memory is
    port (
      clk : IN std_logic;
      reset : IN std_logic;
      address : IN RAM_DEPTH_T;
      qa, qb :  OUT RAM_WIDTH_T
    ) ;
  end component;
begin
  reset <= '1' after 2 ns, '0' after 6 ns;
  clk <= not clk after 24437 ps;
  START <= '1' after 10 ns;
  t0: transmitter
  port map(
    clk          => clk,
    reset        => reset,
    START        => START,
    ENDING       => ENDING,
    address      => address,
    incr         => qa,
    prn_phase    => qb,
    signal_out_i => out_i,
    signal_out_q => out_q
  );

  m0: fake_memory
  port map(
    clk      => clk,
    reset    => reset,
    address  => address,
    qa       => qa,
    qb       => qb
  );


end arch ; -- arch