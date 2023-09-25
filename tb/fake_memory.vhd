library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity fake_memory is
  port (
    clk : IN std_logic;
    reset : IN std_logic;
    address : IN RAM_DEPTH_T;
    qa, qb :  OUT RAM_WIDTH_T
  ) ;
end fake_memory;

architecture arch of fake_memory is
  type RAM_T is array(4 downto 0) of std_logic_vector(31 downto 0);
  signal ram_i, ram_p: RAM_T := (others => (others => '0'));

begin
  PRO : process( clk, reset )
  begin
    if reset = '1' then
      ram_i(0) <= conv_std_logic_vector(1049601, 32); -- 2KHz
      ram_i(1) <= conv_std_logic_vector(2099202, 32); -- 4KHz
      ram_i(2) <= conv_std_logic_vector(528400, 32);  -- 1KHz
      --ram_i(2) <= conv_std_logic_vector(0, 32);  -- 1KHz
      ram_i(3) <= conv_std_logic_vector(4198400, 32);  -- 8KHz
      ram_i(4) <= conv_std_logic_vector(1889280, 32);  -- 3.6Khz

      ram_p(0)(9 downto 0)   <= conv_std_logic_vector(114, 10);
      ram_p(0)(14 downto 10) <= conv_std_logic_vector(10, 5);
      ram_p(0)(15)           <= '1';
      ram_p(0)(22 downto 16) <= conv_std_logic_vector(10, 7);
      ram_p(0)(31 downto 23) <= (others => '0');

      ram_p(1)(9 downto 0)   <= conv_std_logic_vector(514, 10);
      ram_p(1)(14 downto 10) <= conv_std_logic_vector(21, 5);
      ram_p(1)(15)           <= '1';
      ram_p(1)(22 downto 16) <= conv_std_logic_vector(20, 7);
      ram_p(1)(31 downto 23) <= (others => '0');

      ram_p(2)(9 downto 0)   <= conv_std_logic_vector(810, 10);
      ram_p(2)(14 downto 10) <= conv_std_logic_vector(24, 5);
      ram_p(2)(15)           <= '1'; -- valid
      ram_p(2)(22 downto 16) <= conv_std_logic_vector(5, 7);
      ram_p(2)(31 downto 23) <= (others => '0');

      ram_p(3)(9 downto 0)   <= conv_std_logic_vector(0, 10);
      ram_p(3)(14 downto 10) <= conv_std_logic_vector(27, 5);
      ram_p(3)(15)           <= '1';
      ram_p(3)(22 downto 16) <= conv_std_logic_vector(40, 7);
      ram_p(3)(31 downto 23) <= (others => '0');

      ram_p(4)(9 downto 0)   <= conv_std_logic_vector(1022, 10);
      ram_p(4)(14 downto 10) <= conv_std_logic_vector(31, 5);
      ram_p(4)(15)           <= '1';
      ram_p(4)(22 downto 16) <= conv_std_logic_vector(18, 7);
      ram_p(4)(31 downto 23) <= (others => '0');

      qa <= (others => '0');
      qb <= (others => '0');
      
    elsif rising_edge(clk) then
      qa <= ram_i(conv_integer(address));
      qb <= ram_p(conv_integer(address));
    end if ;
  end process ; -- PRO
end arch ; -- arch
