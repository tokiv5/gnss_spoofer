LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_signed.all;
use work.gnss_p.all;

entity replica_tb is
end replica_tb;

architecture arch of replica_tb is

  signal reset, clk : std_logic := '0';
  signal i, q       : std_logic_vector(12 downto 0);
  signal valid      : std_logic;
  signal code_phase : std_logic_vector(9 downto 0);
begin
  r0: entity work.replica_generator
  port map(
    clk     => clk,
    reset   => reset,
    enable  => '1',
    SAT     => 31,
    DOPPLER => "010100",
    i_out   => i,
    q_out   => q,
    valid   => valid,
    code_phase => code_phase
  );

  clk <= not clk after 25 ns;
  reset <= '1' after 2 ns, '0' after 6 ns;
end arch ; -- arch