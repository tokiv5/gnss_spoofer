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
    dopplerSAT  : OUT DOPPLER_SAT_T;
    phaseSAT    : OUT CODE_SAT_T
  ) ;
end acquisition;

architecture arch of acquisition is
  signal DOPPLER, DOPPLER_reg : DOPPLER_T;
  signal clk_div_2            : std_logic; -- half the frequency, to do calculation synchoro with sample
  signal local_input   : std_logic_vector(15 downto 0);
  signal local_incr    : std_logic_vector(31 downto 0);
  signal local_incr_16 : std_logic_vector(15 downto 0);

  signal sin_in             : std_logic_vector(12 downto 0);
  signal cos_in             : std_logic_vector(12 downto 0);

  signal i_out_16, q_out_16   : BLADERF_SAT_T;
  
  signal mult_i, mult_q                       : MULT_RESULT; -- i_local 5+11(2+11) i_in 5+11(1+11) mult 10+22(3+22)
  signal i_accum, q_accum                     : ACCUM_RESULT;
  signal i_accum_abs, q_accum_abs             : ACCUM_RESULT;
  signal max_accum, iq_accum, second_max      : ACQ_RESULT;

  signal epoch, epoch_accum, epoch_abs           : std_logic;
  signal phase_period_epoch                      : std_logic;
  signal code_phase                              : CODE_PHASE_T;  

  signal dopplers  : DOPPLER_SAT_T;
  signal phases    : CODE_SAT_T;

  component replica_generator
    port (
      clk                : IN  std_logic;
      reset              : IN  std_logic;
      enable             : IN  std_logic;
      SAT                : IN  integer range 0 to 31;
      DOPPLER            : IN  std_logic_vector(5 downto 0);
      i_out              : OUT std_logic_vector(12 downto 0);
      q_out              : OUT std_logic_vector(12 downto 0);
      valid              : OUT std_logic;
      phase_period_epoch : out std_logic; -- 1023 phase big loop completion flag
      code_phase         : OUT CODE_PHASE_T;
      sin_in             : IN std_logic_vector(12 downto 0);
      cos_in             : IN std_logic_vector(12 downto 0);
      epoch              : OUT std_logic -- show that 1023 chips go over
    ) ;
  end component;

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
begin
  -------------------- Common for all channels ------------------------------
  dopplerSAT  <=  dopplers;
  phaseSAT    <=  phases;

  local_incr <= ("0000000000" & DOPPLER) * DOP_FREQ_STEP; -- 17 bits integer + 15 bits fraction
  local_incr_16 <= local_incr(17 downto 2);

  INCR : process( clk, reset )
  begin
    if (reset = '1') then
      local_input <= (others => '0');
    elsif rising_edge(clk) then
      if (local_input + local_incr_16) > FIXED_POINT_PI then
        local_input <= local_input + local_incr_16 - FIXED_POINT_PI + FIXED_NEG_PI ;
      else
        local_input <= local_input + local_incr_16;
      end if ;

    end if ;
  end process ; -- INCR


  c0: altera_cordic
  port map (
    clk     => clk,
    areset  => reset,
    a       => local_input,
    s       => sin_in,
    c       => cos_in,
    en      => "1"
  );

  -- should modify to set boundry conditions
  dop_incr : process( clk, reset )
  begin
    if reset = '1' then
      DOPPLER <= conv_std_logic_vector(20,6);
      DOPPLER_reg <= conv_std_logic_vector(20,6);
    elsif rising_edge(clk) then
      if phase_period_epoch = '1' then
        DOPPLER <= DOPPLER_reg;
        DOPPLER_reg <= DOPPLER - 1;
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
      epoch_accum <= epoch;
      epoch_abs   <= epoch_accum;
    end if ;
  end process ; -- epoch_flags


  -------------------- Different for each channel ------------------------------

  -- Sign extend
  SIGN_EXTEND: for i in 0 to 31 generate
    i_out_16(i)(15 downto 13) <= (others => i_out_16(i)(12));
    q_out_16(i)(15 downto 13) <= (others => q_out_16(i)(12));
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
        i_out   => i_out_16(i)(12 downto 0),
        q_out   => q_out_16(i)(12 downto 0),
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
        i_out   => i_out_16(i)(12 downto 0),
        q_out   => q_out_16(i)(12 downto 0),
        valid   => open,
        phase_period_epoch => open,
        code_phase => open,
        sin_in  => sin_in,
        cos_in  => cos_in,
        epoch   => open
      );
    end generate;
  end generate;
  
  
  -- can be optimized with 1 multiplier
  ACCUM_PRO: for i in 0 to 31 generate
    iq_accumulation : process( clk, reset )
    begin
      if reset = '1' then
        mult_i(i) <= (others => '0');
        mult_q(i) <= (others => '0');
        i_accum(i) <= (others => '0');
        q_accum(i) <= (others => '0');
      elsif rising_edge(clk) then
        if clk_div_2 = '0' then
          mult_i(i) <= i_in * i_out_16(i);
          mult_q(i) <= q_in * q_out_16(i);
          if epoch_accum = '1' then
            i_accum(i)(31 downto 0)   <= mult_i(i);
            i_accum(i)(47 downto 32)  <= (others => mult_i(i)(31));
            q_accum(i)(31 downto 0)   <= mult_q(i);
            q_accum(i)(47 downto 32)  <= (others => mult_q(i)(31));
          else
            i_accum(i) <= i_accum(i) + mult_i(i);
            q_accum(i) <= q_accum(i) + mult_q(i);
          end if ;
        else
          mult_i(i) <= mult_i(i);
          mult_q(i) <= mult_q(i);
          i_accum(i) <= i_accum(i);
          q_accum(i) <= q_accum(i);
        end if ;
      end if ;
    end process ; -- iq_accumulation
  end generate;

  ACCUM_ABS: for i in 0 to 31 generate
    i_accum_abs(i) <= i_accum(i) when i_accum(i)(47) = '0' else ((not i_accum(i)) + 1); 
    q_accum_abs(i) <= q_accum(i) when q_accum(i)(47) = '0' else ((not q_accum(i)) + 1);
  end generate;

  IQ_SUM: for i in 0 to 31 generate
    iq_add : process( clk, reset )
    begin
      if reset = '1' then
        iq_accum(i)  <= (others => '0');
        max_accum(i) <= (others => '0');
        second_max(i) <= (others => '0');
      elsif rising_edge(clk) then
        if clk_div_2 = '0' then
          iq_accum(i) <= ("0" & i_accum_abs(i)) + ("0" & q_accum_abs(i));
        else
          iq_accum(i) <= iq_accum(i);
        end if ;
        if epoch_abs = '1' and iq_accum(i) > max_accum(i) then
          max_accum(i) <= iq_accum(i);
          second_max(i)<= max_accum(i);
          dopplers(i)  <= DOPPLER - 1;
          phases(i)    <= code_phase - 1;
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