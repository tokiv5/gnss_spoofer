library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity fake_memory is
  port (
    clk : IN std_logic;
    reset : IN std_logic;
    addressa, addressb : IN RAM_DEPTH_T;
    qa, qb :  OUT RAM_WIDTH_T
  ) ;
end fake_memory;

architecture arch of fake_memory is
  type RAM_T is array(9 downto 0) of std_logic_vector(31 downto 0);
  signal ram: RAM_T := (others => (others => '0'));

begin
  PRO : process( clk, reset )
  begin
    if reset = '1' then
      ram(0) <= conv_std_logic_vector(1049601, 32); -- 5KHz
      ram(1) <= conv_std_logic_vector(2099202, 32); -- 10KHz
      ram(2) <= conv_std_logic_vector(209920, 32);  -- 1KHz
      ram(3) <= conv_std_logic_vector(419840, 32);  -- 2KHz
      ram(4) <= conv_std_logic_vector(0, 32);
    elsif rising_edge(clk) then
      qa <= ram(conv_integer(addressa));
      qb <= ram(conv_integer(addressb));
    end if ;
  end process ; -- PRO
end arch ; -- arch