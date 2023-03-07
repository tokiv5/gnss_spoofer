	component altera_cordic is
		port (
			clk    : in  std_logic                     := 'X';             -- clk
			areset : in  std_logic                     := 'X';             -- reset
			a      : in  std_logic_vector(15 downto 0) := (others => 'X'); -- a
			c      : out std_logic_vector(12 downto 0);                    -- c
			s      : out std_logic_vector(12 downto 0);                    -- s
			en     : in  std_logic_vector(0 downto 0)  := (others => 'X')  -- en
		);
	end component altera_cordic;

	u0 : component altera_cordic
		port map (
			clk    => CONNECTED_TO_clk,    --    clk.clk
			areset => CONNECTED_TO_areset, -- areset.reset
			a      => CONNECTED_TO_a,      --      a.a
			c      => CONNECTED_TO_c,      --      c.c
			s      => CONNECTED_TO_s,      --      s.s
			en     => CONNECTED_TO_en      --     en.en
		);

