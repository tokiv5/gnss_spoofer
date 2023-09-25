LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_signed.all;
entity cordic_tb is
end cordic_tb;

architecture arch of cordic_tb is

  signal a : std_logic_vector(15 downto 0) := "0110010010000110";
  signal areset, clk : std_logic := '0';
  signal s, c : std_logic_vector(12 downto 0);
begin
  dut: entity work.altera_cordic
    port map(
      a => a,
      areset => areset,
      c => c,
      clk => clk,
      s => s,
      en => "1"
    );

    clk <= not clk after 5 ns;
    areset <= '1' after 2 ns, '0' after 6 ns;
    incr : process( clk )
    begin
      if rising_edge(clk) then
      	if a < "1001101101111010" then
      	  a <= "0110010010000110";
      	else
          a <= a - 256;
        end if;
      end if ;
    end process ; -- incr
end arch ; -- arch
