LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
library altera_mf_ver;
library lpm_ver;

entity nco_tb is
end nco_tb;

architecture arch of nco_tb is

  signal clk : std_logic := '0';
  signal phi_inc_i : std_logic_vector(31 downto 0) := conv_std_logic_vector(1049601, 32);
  signal s, c : std_logic_vector(11 downto 0);
  signal valid : std_logic;
  signal rst_n : std_logic;
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
  rst_n <= '0' after 2 ns, '1' after 6 ns;
  clk <= not clk after 24437 ps;
  n0 : nco
  port map(
    clk     => clk,
    reset_n => rst_n,
    clken   => '1',
    phi_inc_i => phi_inc_i,
    fsin_o => s,
    fcos_o => c,
    out_valid => valid
  );
end arch ; -- arch