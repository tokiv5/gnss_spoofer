library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity acquisition is
  port (
    clk : IN std_logic;
    reset       : IN std_logic;
    i_in        : IN BLADERF_T;
    q_in        : IN BLADERF_T;
    detectedSAT : OUT std_logic_vector(31 downto 0);
    complete    : OUT std_logic;
    enable      : IN std_logic
    --dopplerSAT  : OUT DOPPLER_SAT_T;
    --phaseSAT    : OUT CODE_SAT_T
  ) ;
end acquisition;

architecture arch of acquisition is
  signal DOPPLER, DOPPLER_reg : DOPPLER_T;
  signal doppler_extend       : BLADERF_T;
  signal clk_div_2            : std_logic; -- half the frequency, to do calculation synchro with sample
  signal local_input   : std_logic_vector(15 downto 0); -- 3 integer bits + 13 fraction bits
  signal local_incr    : std_logic_vector(31 downto 0);
  signal local_incr_16 : std_logic_vector(15 downto 0);

  signal sin_in             : BLADERF_AD_T; -- 2 integer bits + 11 fraction bits
  signal cos_in             : BLADERF_AD_T;
  signal mult_iq_in         : BLADERF_T;
  signal i_out_16, q_out_16, mult_local_in    : BLADERF_SAT_T; --  local replica signals
  
  signal mult_i, mult_q, mult_res             : MULT_RESULT; -- i_local 5+11(2+11) i_in 5+11(1+11) mult 10+22(3+22) -- i-square = i_acc_16*i_acc_16
  signal i_square, q_square                   : BLADERF_SAT_T;
  signal i_accum, q_accum                     : ACCUM_RESULT;
  signal i_accum_16, q_accum_16               : BLADERF_SAT_T;
  signal mult_i_8, mult_q_8                   : SIMP_SAT_T;
  signal i_accum_8, q_accum_8                 : SIMP_SAT_T;
  signal max_accum, iq_accum, second_max      : ACQ_RESULT;

  signal epoch, epoch_accum, epoch_abs           : std_logic;
  signal phase_period_epoch                      : std_logic;
  signal code_phase                              : CODE_PHASE_T;  

  signal dopplers, dopplerSAT  : DOPPLER_SAT_T;
  signal phases, phaseSAT      : CODE_SAT_T;
  signal reset_n : std_logic;

  component replica_generator
    port (
      clk                : IN  std_logic;
      reset              : IN  std_logic;
      enable             : IN  std_logic;
      SAT                : IN  integer range 0 to 31;
      DOPPLER            : IN  DOPPLER_T;
      i_out              : OUT BLADERF_AD_T;
      q_out              : OUT BLADERF_AD_T;
      valid              : OUT std_logic;
      phase_period_epoch : out std_logic; -- 1023 phase big loop completion flag
      code_phase         : OUT CODE_PHASE_T;
      sin_in             : IN BLADERF_AD_T;
      cos_in             : IN BLADERF_AD_T;
      epoch              : OUT std_logic -- show that 1023 chips go over
    ) ;
  end component;

  -- component altera_cordic is
	-- 	port (
	-- 		clk    : in  std_logic                     := 'X';             -- clk
	-- 		areset : in  std_logic                     := 'X';             -- reset
	-- 		a      : in  std_logic_vector(15 downto 0) := (others => 'X'); -- a
	-- 		c      : out std_logic_vector(12 downto 0);                    -- c
	-- 		s      : out std_logic_vector(12 downto 0);                    -- s
	-- 		en     : in  std_logic_vector(0 downto 0)  := (others => 'X')  -- en
	-- 	);
	-- end component altera_cordic;

  component altera_mult
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
  end component;

  component altera_square
  PORT
  (
		dataa		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
  );
  end component;

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
  -------------------- Common for all channels ------------------------------
  dopplerSAT  <=  dopplers;
  phaseSAT    <=  phases;

  doppler_extend(7 downto 0) <= DOPPLER & '0';
  doppler_extend(15 downto 8) <= (others => DOPPLER(6));

  m0: altera_mult
  port map (
    dataa  => doppler_extend,
    datab  => DOP_FREQ_STEP,
    result => local_incr
  );

  reset_n <= not reset;
  n0: nco
  port map(
    clk => clk,
    reset_n => reset_n,
    clken   => enable,
    phi_inc_i => local_incr,
    fsin_o => sin_in,
    fcos_o => cos_in,
    out_valid => open
  );

  -- local_incr <= ("000000000" & DOPPLER) * DOP_FREQ_STEP; -- 17 bits integer + 15 bits fraction
  -- local_incr_16 <= local_incr(17 downto 2); -- 3 + 13

  -- INCR : process( clk, reset )
  -- begin
  --   if (reset = '1') then
  --     local_input <= (others => '0');
  --   elsif rising_edge(clk) then
  --     if (local_input + local_incr_16) > FIXED_POINT_PI then
  --       local_input <= local_input + local_incr_16 - FIXED_POINT_PI + FIXED_NEG_PI ;
  --     else
  --       local_input <= local_input + local_incr_16;
  --     end if ;

  --   end if ;
  -- end process ; -- INCR


  -- c0: altera_cordic
  -- port map (
  --   clk     => clk,
  --   areset  => reset,
  --   a       => local_input,
  --   s       => sin_in,
  --   c       => cos_in,
  --   en      => "1"
  -- );

  -- should modify to set boundry conditions
  dop_incr : process( clk, reset )
  begin
    if reset = '1' then
      DOPPLER <= conv_std_logic_vector(10,7);
      DOPPLER_reg <= conv_std_logic_vector(10,7);
    elsif rising_edge(clk) then
      if phase_period_epoch = '1' then
        DOPPLER <= DOPPLER_reg;
        DOPPLER_reg <= DOPPLER + 1;
      end if ;
    end if ;
  end process ; -- doppler frequency incrementer
  
  clk_div : process( clk, reset )
  begin
    if reset = '1' then
      clk_div_2 <= '0';
    elsif rising_edge(clk) then
      clk_div_2 <= not clk_div_2;
    end if ;
  end process ; -- clk_div

  epoch_flags : process( clk )
  begin
    if rising_edge(clk) then
      if clk_div_2 = '0' then
        epoch_accum <= epoch;
        epoch_abs   <= epoch_accum;        
      end if ;

    end if ;
  end process ; -- epoch_flags

  end_flag : process( clk )
  begin
    if rising_edge(clk) then
      if DOPPLER = 51 and epoch_abs = '1' then
        complete <= '1';
      else
        complete <= '0';
      end if ;
    end if ;
  end process ; -- end_flag


  -------------------- Different for each channel ------------------------------

  -- Sign extend
  SIGN_EXTEND: for i in 0 to 31 generate
    i_out_16(i)(15 downto 12) <= (others => i_out_16(i)(11));
    q_out_16(i)(15 downto 12) <= (others => q_out_16(i)(11));
  end generate;

  RP_GEN: for i in 0 to 31 generate
    i0: if i = 0 generate
      r0: replica_generator
      port map (
        clk     => clk,
        reset   => reset,
        enable  => '1',
        SAT     => i,
        DOPPLER => DOPPLER,
        i_out   => i_out_16(i)(11 downto 0),
        q_out   => q_out_16(i)(11 downto 0),
        valid   => open,
        phase_period_epoch => phase_period_epoch,
        code_phase => code_phase,
        sin_in  => sin_in,
        cos_in  => cos_in,
        epoch   => epoch
      );
    end generate;

    ie: if i > 0 generate
      r0: replica_generator
      port map (
        clk     => clk,
        reset   => reset,
        enable  => '1',
        SAT     => i,
        DOPPLER => DOPPLER,
        i_out   => i_out_16(i)(11 downto 0),
        q_out   => q_out_16(i)(11 downto 0),
        valid   => open,
        phase_period_epoch => open,
        code_phase => open,
        sin_in  => sin_in,
        cos_in  => cos_in,
        epoch   => open
      );
    end generate;
  end generate;

  --mult_iq_in <= i_in when clk_div_2 = '1' else q_in;
  
  INPUT_MULT_I: for i in 0 to 31 generate
    mi0: altera_mult
    port map (
      dataa => i_in,
      datab => i_out_16(i),
      result => mult_i(i)
    );
  end generate;

  INPUT_MULT_Q: for i in 0 to 31 generate
    mq0: altera_mult
    port map (
      dataa => q_in,
      datab => q_out_16(i),
      result => mult_q(i)
    );
  end generate;

  MULT_SIMP: for i in 0 to 31 generate
    mult_i_8(i) <= mult_i(i)(23 downto 16);
    mult_q_8(i) <= mult_q(i)(23 downto 16);
  end generate;
  
  -- can be optimized with 1 multiplier
  ACCUM_PRO: for i in 0 to 31 generate
    iq_accumulation : process( clk, reset )
    begin
      if reset = '1' then
        --mult_i(i) <= (others => '0');
        --mult_q(i) <= (others => '0');
        i_accum(i) <= (others => '0');
        q_accum(i) <= (others => '0');
      elsif rising_edge(clk) then
        if clk_div_2 = '0' then
          --mult_i(i) <= i_in * i_out_16(i);
          --mult_q(i) <= q_in * q_out_16(i);
          if epoch_accum = '1' then
            i_accum(i)(7 downto 0)   <= mult_i_8(i);
            i_accum(i)(17 downto 8)  <= (others => mult_i_8(i)(7));
            q_accum(i)(7 downto 0)   <= mult_q_8(i);
            q_accum(i)(17 downto 8)  <= (others => mult_q_8(i)(7));
          else
            i_accum(i) <= i_accum(i) + mult_i_8(i);
            q_accum(i) <= q_accum(i) + mult_q_8(i);
          end if ;
        else
          --mult_i(i) <= mult_i(i);
          --mult_q(i) <= mult_q(i);
          i_accum(i) <= i_accum(i);
          q_accum(i) <= q_accum(i);
        end if ;
      end if ;
    end process ; -- iq_accumulation
  end generate;

  ACCUM_SIMP: for i in 0 to 31 generate
    i_accum_8(i) <= i_accum(i)(14 downto 7); 
    q_accum_8(i) <= q_accum(i)(14 downto 7);
    --i_square(i)(15 downto 0)   <= i_accum_8(i) * i_accum_8(i);
    --q_square(i)(15 downto 0)   <= q_accum_8(i) * q_accum_8(i);
    --i_square(i)(31 downto 16)  <= (others => i_square(i)(15));
    --q_square(i)(31 downto 16)  <= (others => q_square(i)(15));
  end generate;

  SQUARE_I: for i in 0 to 31 generate
    s0: altera_square
    port map(
      dataa => i_accum_8(i),
      result => i_square(i)
    );
  end generate;

  SQUARE_Q: for i in 0 to 31 generate
    s1: altera_square
    port map(
      dataa => q_accum_8(i),
      result => q_square(i)
    );
  end generate;


  -- ACCUM_SIMP: for i in 0 to 31 generate
  --   i_accum_16(i) <= i_accum(i)(33 downto 18); 
  --   q_accum_16(i) <= q_accum(i)(33 downto 18);
  --   i_square(i)   <= i_accum_16(i) * i_accum_16(i);
  --   q_square(i)   <= q_accum_16(i) * q_accum_16(i);
  -- end generate;

  IQ_SUM: for i in 0 to 31 generate
    iq_add : process( clk, reset )
    begin
      if reset = '1' then
        iq_accum(i)  <= (others => '0');
        max_accum(i) <= (others => '0');
        second_max(i) <= (others => '0');
      elsif rising_edge(clk) then
        if clk_div_2 = '0' then
          iq_accum(i) <= ("0" & i_square(i)) + ("0" & q_square(i)); -- Square result must be positive
        else
          iq_accum(i) <= iq_accum(i);
        end if ;
        if epoch_abs = '1' and iq_accum(i) > max_accum(i) then
          max_accum(i) <= iq_accum(i);
          second_max(i)<= max_accum(i);
          -- Actual recorded doppler is last doppler but not the one now
          -- Actual recorded code phase is always the last
          if code_phase = 0 then
            dopplers(i) <= DOPPLER - 1;
            phases(i)   <= conv_std_logic_vector(1022, 10);
          else
            dopplers(i)  <= DOPPLER;
            phases(i)    <= code_phase - 1;
          end if ;

        else
          max_accum(i) <= max_accum(i);
          second_max(i)<= second_max(i);
          dopplers(i)  <= dopplers(i);
          phases(i)    <= phases(i);
        end if ;
        
      end if ;
    end process ; -- iq_max
  end generate;

  IsDeteced: for i in 0 to 31 generate
    detectedSAT(i) <= '1' when max_accum(i) > ACQ_THRESHOLD else '0';
  end generate;
end arch ; -- arch