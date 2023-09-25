library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity acquisition_cal is
  port (
    clk : IN std_logic;
    reset       : IN std_logic;
    i_in        : IN BLADERF_T;
    q_in        : IN BLADERF_T;
    detectedSAT : OUT std_logic_vector(31 downto 0);
    complete    : OUT std_logic;
    enable      : IN std_logic;
    INCR_SAT    : OUT INCR_SAT_T;
    phaseSAT    : OUT CODE_SAT_T;
    doppler_out : OUT DOPPLER_T;
    code_phase_out : OUT CODE_PHASE_T;
    max16       : OUT std_logic_vector(16 downto 0);
    timer       : OUT std_logic_vector(4 downto 0);
    PRN_out     : OUT std_logic_vector(31 downto 0);
    acc_out     : OUT std_logic_vector(31 downto 0);
    write_flag  : OUT std_logic -- A flag write to host PC each frequency
    --max_acc_out : OUT ACQ_RESULT
  ) ;
end acquisition_cal;

architecture arch of acquisition_cal is
  signal DOPPLER, DOPPLER_reg : DOPPLER_T;
  signal doppler_extend       : BLADERF_T;
  signal clk_div_2            : std_logic; -- half the frequency, to do calculation synchro with sample
  signal local_input   : std_logic_vector(15 downto 0); -- 3 integer bits + 13 fraction bits
  signal local_incr    : std_logic_vector(31 downto 0);
  signal max_freq_incr : INCR_SAT_T;

  signal sin_in             : BLADERF_AD_T; -- 2 integer bits + 11 fraction bits
  signal cos_in             : BLADERF_AD_T;
  signal mult_iq_in         : BLADERF_T;
  signal i_out_16, q_out_16, mult_local_in    : BLADERF_SAT_T; --  local replica signals
  
  signal mult_i, mult_q, mult_res             : MULT_RESULT; -- i_local 5+11(2+11) i_in 5+11(1+11) mult 10+22(3+22) -- i-square = i_acc_16*i_acc_16
  signal i_square, q_square, iq_square        : BLADERF_SAT_T;
  signal i_accum, q_accum                     : ACCUM_RESULT;
  signal i_accum_16, q_accum_16               : BLADERF_SAT_T;
  signal mult_i_8, mult_q_8                   : SIMP_SAT_T;
  signal i_accum_8, q_accum_8, iq_accum_8     : SIMP_SAT_T;
  signal max_accum, iq_accum, second_max      : ACQ_RESULT;

  signal epoch, epoch_accum, epoch_abs           : std_logic;
  signal phase_period_epoch                      : std_logic;
  signal code_phase                              : CODE_PHASE_T;  

  -- signal dopplers, dopplerSAT  : DOPPLER_SAT_T;
  signal phases     : CODE_SAT_T;
  signal reset_n : std_logic;

  signal PRN     : std_logic_vector(31 downto 0);
  signal double_second : ACQ_RESULT;
  signal acc_out_counter : std_logic_vector(1 downto 0);
  signal acc_out_index   : std_logic_vector(4 downto 0);

  component ROM_CA_generator is
    generic(
      START_PHASE : integer range 0 to 1022 := 0
    );
    port (
      clk                : IN std_logic;
      reset              : IN std_logic;
      PRN                : OUT std_logic_vector(31 downto 0);
      enable             : IN std_logic;
      code_phase_out     : OUT CODE_PHASE_T;
      epoch              : OUT std_logic;
      phase_period_epoch : OUT std_logic;
      timer              : OUT std_logic_vector(4 downto 0)
    ) ;
  end component;

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

  -- component nco is
	-- 	port (
	-- 		clk       : in  std_logic                     := 'X';             -- clk
	-- 		reset_n   : in  std_logic                     := 'X';             -- reset_n
	-- 		clken     : in  std_logic                     := 'X';             -- clken
	-- 		phi_inc_i : in  std_logic_vector(31 downto 0) := (others => 'X'); -- phi_inc_i
	-- 		fsin_o    : out std_logic_vector(11 downto 0);                    -- fsin_o
	-- 		fcos_o    : out std_logic_vector(11 downto 0);                    -- fcos_o
	-- 		out_valid : out std_logic                                         -- out_valid
	-- 	);
	-- end component nco;

  component waveform_gen is
    port (

      -- system signals
      clk         : in  std_logic;
      reset       : in  std_logic;
      
      -- clock-enable
      en          : in  std_logic;
      
      -- NCO frequency control
      phase_inc   : in  std_logic_vector(31 downto 0);
      
      -- Output waveforms
      sin_out     : out std_logic_vector(11 downto 0);
      cos_out     : out std_logic_vector(11 downto 0);
      squ_out     : out std_logic_vector(11 downto 0);
      saw_out     : out std_logic_vector(11 downto 0) 
    );
  end component;
begin
  -------------------- Common for all channels ------------------------------
  --dopplerSAT  <=  dopplers;
  phaseSAT    <=  phases;
  INCR_SAT    <=  max_freq_incr;
  max16 <= max_accum(15);
  --max_acc_out <=  max_accum;
  PRN_out     <= PRN;
  doppler_out <= doppler;
  doppler_extend(8 downto 0) <= DOPPLER & "00"; -- STEP is not enough in 16 bits if use 200 hz so half step and double doppler instead 
  doppler_extend(15 downto 9) <= (others => DOPPLER(6));
  code_phase_out <= code_phase;
  m0: altera_mult
  port map (
    dataa  => doppler_extend,
    datab  => DOP_FREQ_STEP,
    result => local_incr
  );

  reset_n <= not reset;
  n0: waveform_gen
  port map(
    clk => clk,
    reset => reset_n,
    en   => enable,
    phase_inc => local_incr,
    sin_out => sin_in,
    cos_out => cos_in,
    squ_out => open,
    saw_out => open
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
  write_flag <= phase_period_epoch;
  dop_incr : process( clk, reset )
  begin
    if reset = '1' then
      DOPPLER <= conv_std_logic_vector(1,7);
      DOPPLER_reg <= conv_std_logic_vector(1,7);
    elsif rising_edge(clk) then
      if phase_period_epoch = '1' and enable = '1'then
        DOPPLER <= DOPPLER_reg;
        if DOPPLER_reg = 50 then
          DOPPLER_reg <= conv_std_logic_vector(1,7);
        else
          DOPPLER_reg <= DOPPLER_reg + 1;
        end if ;
      end if ;
    end if ;
  end process ; -- doppler frequency incrementer
  
  clk_div : process( clk, reset )
  begin
    if reset = '1' then
      clk_div_2 <= '0';
    elsif rising_edge(clk) then
      if enable = '1' then
        clk_div_2 <= not clk_div_2;
      end if ;
    end if ;
  end process ; -- clk_div

  epoch_flags : process( clk )
  begin
    if rising_edge(clk) then
      if clk_div_2 = '0' and enable = '1' then
        epoch_accum <= epoch;
        epoch_abs   <= epoch_accum;        
      end if ;

    end if ;
  end process ; -- epoch_flags

  end_flag : process( clk )
  begin
    if rising_edge(clk) then
      if DOPPLER = 50 and phase_period_epoch = '1' and enable = '1' then
        complete <= '1';
      else
        complete <= '0';
      end if ;
    end if ;
  end process ; -- end_flag

  CA_GEN: ROM_CA_generator
  generic map(
    START_PHASE       => 0
  )
  port map(
    clk                => clk,
    reset              => reset,
    PRN                => PRN,
    enable             => enable,
    code_phase_out     => code_phase,
    epoch              => epoch,
    phase_period_epoch => phase_period_epoch,
    timer              => timer
  );


  -------------------- Different for each channel ------------------------------

  -- Sign extend
  SIGN_EXTEND: for i in 0 to 31 generate
    i_out_16(i)(11 downto 0)  <= sin_in when PRN(i) = '1' else ((not sin_in) + 1);
    q_out_16(i)(11 downto 0)  <= cos_in when PRN(i) = '1' else ((not cos_in) + 1);
    i_out_16(i)(15 downto 12) <= (others => i_out_16(i)(11));
    q_out_16(i)(15 downto 12) <= (others => q_out_16(i)(11));
  end generate;

  -- RP_GEN: for i in 0 to 31 generate
  --   i0: if i = 0 generate
  --     r0: replica_generator
  --     port map (
  --       clk     => clk,
  --       reset   => reset,
  --       enable  => enable,
  --       SAT     => i,
  --       DOPPLER => DOPPLER,
  --       i_out   => i_out_16(i)(11 downto 0),
  --       q_out   => q_out_16(i)(11 downto 0),
  --       valid   => open,
  --       phase_period_epoch => phase_period_epoch,
  --       code_phase => code_phase,
  --       sin_in  => sin_in,
  --       cos_in  => cos_in,
  --       epoch   => epoch
  --     );
  --   end generate;

  --   ie: if i > 0 generate
  --     r0: replica_generator
  --     port map (
  --       clk     => clk,
  --       reset   => reset,
  --       enable  => enable,
  --       SAT     => i,
  --       DOPPLER => DOPPLER,
  --       i_out   => i_out_16(i)(11 downto 0),
  --       q_out   => q_out_16(i)(11 downto 0),
  --       valid   => open,
  --       phase_period_epoch => open,
  --       code_phase => open,
  --       sin_in  => sin_in,
  --       cos_in  => cos_in,
  --       epoch   => open
  --     );
  --   end generate;
  -- end generate;

  mult_iq_in    <= i_in     when clk_div_2 = '1' else q_in;
  mult_local_in <= i_out_16 when clk_div_2 = '1' else q_out_16;
  mult_update : process( clk, reset )
  begin
    if reset = '1' then
      mult_i <= (others => (others => '0'));
      mult_q <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if enable  = '1' then
        if clk_div_2 = '1' then
          mult_i <= mult_res;
        else
          mult_q <= mult_res;
        end if ;
      end if ;
    end if ;
  end process ; -- mult_update
  --mult_i        <= mult_res when clk_div_2 = '1' else mult_i;
  --mult_q        <= mult_res when clk_div_2 = '0' else mult_q;

  INPUT_MULT: for i in 0 to 31 generate
    mi0: altera_mult
    port map (
      dataa => mult_iq_in,
      datab => mult_local_in(i),
      result => mult_res(i)
    );
  end generate;

  -- INPUT_MULT_Q: for i in 0 to 31 generate
  --   mq0: altera_mult
  --   port map (
  --     dataa => q_in,
  --     datab => q_out_16(i),
  --     result => mult_q(i)
  --   );
  -- end generate;

  -- MULT_SIMP: for i in 0 to 31 generate
  --   mult_i_8(i) <= mult_i(i)(22 downto 15);
  --   mult_q_8(i) <= mult_q(i)(22 downto 15);
  -- end generate;
  
  -- -- can be optimized with 1 multiplier
  -- ACCUM_PRO: for i in 0 to 31 generate
  --   iq_accumulation : process( clk, reset )
  --   begin
  --     if reset = '1' then
  --       --mult_i(i) <= (others => '0');
  --       --mult_q(i) <= (others => '0');
  --       i_accum(i) <= (others => '0');
  --       q_accum(i) <= (others => '0');
  --     elsif rising_edge(clk) then
  --       if clk_div_2 = '0' and enable = '1' then
  --         --mult_i(i) <= i_in * i_out_16(i);
  --         --mult_q(i) <= q_in * q_out_16(i);
  --         if epoch_abs = '1' then
  --           i_accum(i)(7 downto 0)   <= mult_i_8(i);
  --           i_accum(i)(17 downto 8)  <= (others => mult_i_8(i)(7));
  --           q_accum(i)(7 downto 0)   <= mult_q_8(i);
  --           q_accum(i)(17 downto 8)  <= (others => mult_q_8(i)(7));
  --         else
  --           i_accum(i) <= i_accum(i) + mult_i_8(i);
  --           q_accum(i) <= q_accum(i) + mult_q_8(i);
  --         end if ;
  --       --else
  --         --mult_i(i) <= mult_i(i);
  --         --mult_q(i) <= mult_q(i);
  --         --i_accum(i) <= i_accum(i);
  --         --q_accum(i) <= q_accum(i);
  --       end if ;
  --     end if ;
  --   end process ; -- iq_accumulation
  -- end generate;


  ACCUM_PRO: for i in 0 to 31 generate
  iq_accumulation : process( clk, reset )
  begin
    if reset = '1' then
      --mult_i(i) <= (others => '0');
      --mult_q(i) <= (others => '0');
      i_accum(i) <= (others => '0');
      q_accum(i) <= (others => '0');
    elsif rising_edge(clk) then
      if clk_div_2 = '0' and enable = '1' then
        --mult_i(i) <= i_in * i_out_16(i);
        --mult_q(i) <= q_in * q_out_16(i);
        if epoch_abs = '1' then
          i_accum(i)   <= mult_i(i);
          q_accum(i)   <= mult_q(i);
        else
          i_accum(i) <= i_accum(i) + mult_i(i);
          q_accum(i) <= q_accum(i) + mult_q(i);
        end if ;
      --else
        --mult_i(i) <= mult_i(i);
        --mult_q(i) <= mult_q(i);
        --i_accum(i) <= i_accum(i);
        --q_accum(i) <= q_accum(i);
      end if ;
    end if ;
  end process ; -- iq_accumulation
end generate;

  ACCUM_SIMP: for i in 0 to 31 generate
    i_accum_8(i) <= i_accum(i)(27 downto 20); 
    q_accum_8(i) <= q_accum(i)(27 downto 20);
    --i_square(i)(15 downto 0)   <= i_accum_8(i) * i_accum_8(i);
    --q_square(i)(15 downto 0)   <= q_accum_8(i) * q_accum_8(i);
    --i_square(i)(31 downto 16)  <= (others => i_square(i)(15));
    --q_square(i)(31 downto 16)  <= (others => q_square(i)(15));
  end generate;

  iq_accum_8 <= i_accum_8 when clk_div_2 = '1' else q_accum_8;
  SQ_update : process( clk, reset )
  begin
    if reset = '1' then
      i_square <= (others => (others => '0'));
      q_square <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if enable  = '1' then
        if clk_div_2 = '1' then
          i_square <= iq_square;
        else
          q_square <= iq_square;
        end if ;
      end if ;
    end if ;
  end process ; -- SQ_update
  --i_square   <= iq_square when clk_div_2 = '1' else i_square;
  --q_square   <= iq_square when clk_div_2 = '0' else q_square;

  SQUARE_I: for i in 0 to 31 generate
    s0: altera_square
    port map(
      dataa => iq_accum_8(i),
      result => iq_square(i)
    );
  end generate;

  -- SQUARE_Q: for i in 0 to 31 generate
  --   s1: altera_square
  --   port map(
  --     dataa => q_accum_8(i),
  --     result => q_square(i)
  --   );
  -- end generate;


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
        if clk_div_2 = '0' and enable = '1' then
          iq_accum(i) <= ("0" & i_square(i)) + ("0" & q_square(i)); -- Square result must be positive
        else
          iq_accum(i) <= iq_accum(i);
        end if ;
        if epoch_abs = '1' and iq_accum(i) > max_accum(i) and enable = '1' then
          max_accum(i) <= iq_accum(i);
          second_max(i)<= max_accum(i);
          -- Actual recorded doppler is last doppler but not the one now
          -- Actual recorded code phase is always the last
          if code_phase = 0 then
            -- dopplers(i) <= DOPPLER - 1;
            max_freq_incr(i) <= local_incr - DOP_FREQ_STEP - DOP_FREQ_STEP - DOP_FREQ_STEP - DOP_FREQ_STEP;
            phases(i)        <= conv_std_logic_vector(1022, 10);
          else
            -- dopplers(i)  <= DOPPLER;
            max_freq_incr(i) <= local_incr;
            phases(i)        <= code_phase - 1;
          end if ;

        -- else
        --   max_accum(i) <= max_accum(i);
        --   second_max(i)<= second_max(i);
        --   dopplers(i)  <= dopplers(i);
        --   phases(i)    <= phases(i);
        end if ;
        
      end if ;
    end process ; -- iq_max
  end generate;

  IsDeteced: for i in 0 to 31 generate
    double_second(i) <= (second_max(i)(15 downto 0) & '0');
    --detectedSAT(i) <= '1' when max_accum(i) > double_second(i) else '0';
    detectedSAT(i) <= '1' when max_accum(i) > ACQ_THRESHOLD else '0';
  end generate;
  
  acc_out(16 downto 0) <= max_accum(conv_integer(unsigned(acc_out_index)));
  acc_out(31 downto 24) <= "000" & acc_out_index;
  acc_out(23 downto 17) <= (others => '0');
  acc_out_p : process( clk, reset )
  begin
    if reset = '1' then
      acc_out_counter <= (others => '0');
      acc_out_index <= (others => '0');
    elsif rising_edge(clk) then
      acc_out_counter <= acc_out_counter+1;
      if acc_out_counter = 3 then
        acc_out_index <= acc_out_index+1;
      end if ;
    end if ;
  end process ; -- acc_out
end arch ; -- arch
