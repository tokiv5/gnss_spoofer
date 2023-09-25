library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity transmitter_gen is
  port (
    clk         : IN std_logic;
    reset       : IN std_logic;
    enable      : IN std_logic;
    update      : IN std_logic;
    update_pr   : IN std_logic;
    update_pr_6 : IN std_logic;
    update_cnt  : IN integer range 0 to 4;
    address     : OUT RAM_DEPTH_T;
    incr        : IN  RAM_WIDTH_T;
    prn_phase   : IN  RAM_WIDTH_T;
    signal_sca_i: OUT BLADERF_T; -- rescale after adding up
    signal_sca_q: OUT BLADERF_T;
    incr_channel0 : OUT RAM_WIDTH_T;
    data_addr   : OUT DATA_RAM_ADDR_T;
    data_bits   : IN std_logic_vector(31 downto 0);
    PR_addr     : OUT PR_ADDR_T;
    PR          : IN PR_T;
    rx_out      : OUT std_logic_vector(63 downto 0);
    write_out   : OUT std_logic_vector(15 downto 0)
  ) ;
end transmitter_gen;

architecture arch of transmitter_gen is

  signal incr_channels         : INCR_OUTPUT_T; -- Increment values from ram
  signal incr_channels_next    : INCR_OUTPUT_T;
  signal phase_channels        : PHASE_OUTPUT_T; -- 7 + 1 + 5 + 10 saved in ram
  signal code_phase_next_channels : PHASE_OUTPUT_T;
  signal prn_channels          : SAT_OUTPUT_T;
  signal dop_channels          : DOP_OUTPUT_T;
  signal CA_freq_step_channels      : CA_STEP_OUTPUT_T;
  signal CA_freq_step_channels_next : CA_STEP_OUTPUT_T;
  signal valid_channels        : std_logic_vector(4 downto 0);
  signal local_timer_next_channels : TIMER_OUTPUT_T;
  
  -- attribute ramstyle : string;
  -- attribute ramstyle of incr_channels : signal is "logic";
  -- attribute ramstyle of phase_channels : signal is "logic";
  -- attribute ramstyle of dop_channels : signal is "logic";
  -- attribute ramstyle of CA_freq_step_channels : signal is "logic";
  


  signal sin_out         : BLADERF_OUTPUT_T;
  signal cos_out         : BLADERF_OUTPUT_T;
  signal cnt_reg         : integer range 0 to 4;
  signal update_reg      : std_logic;
  signal enable_reg      : std_logic;
  signal nco_en          : std_logic;

  signal sin_out_12      : BLADERF_AD_OUTPUT_T;
  signal sin_out_reg     : std_logic_vector(11 downto 0);
  signal rx_counter      : std_logic_vector(3 downto 0);
  signal cos_out_12      : BLADERF_AD_OUTPUT_T;

  signal rst_n : std_logic;
  signal addressa_inner  : RAM_DEPTH_T;

  signal CA_channels     : CA_OUTPUT_T;

  signal signal_out_i    : BLADERF_OUTPUT_T;
  signal signal_out_q    : BLADERF_OUTPUT_T;

  subtype SIGNAL_ADD_T   is std_logic_vector(18 downto 0);
  type SIGNAL_EXTEND_T   is array(4 downto 0) of SIGNAL_ADD_T;
  
  signal i_extend, q_extend : SIGNAL_EXTEND_T;
  signal i_add, q_add       : SIGNAL_ADD_T;

  signal mult_out           : std_logic_vector(31 downto 0);
  signal dop_extend         : std_logic_vector(15 downto 0);

  signal epoch_CA           : std_logic_vector(4 downto 0);

  
  signal epoch_count        : EPOCH_COUNT_T;
  signal epoch_next_channels : EPOCH_COUNT_T;
  
  signal data_addr_channels : DATA_RAM_OUTPUT_T;
  signal data_addr_next_channels :  DATA_RAM_OUTPUT_T;
  signal data_in_counter    : integer range 0 to 4; -- Control ram to which channels' address
  signal data_in_reg, data_in_reg2        : integer range 0 to 4; -- Change at the same time with ram data
  signal databits_channels  : std_logic_vector(4 downto 0);
  signal PR_channels        : PR_OUTPUT_T;
  signal PR_change_channels : PR_OUTPUT_T;

  signal counter_in_ms : integer range 0 to 8183;
  signal gms           : integer range 0 to 999;
  signal gs            : integer range 0 to 299;
  signal tms           : integer range 0 to 299999;

  --signal PR_old, PR      : PR_OUTPUT_T;
  signal PR_addr_base    : PR_ADDR_T; -- Change every 6 seconds
  signal PR_addr_sat     : PR_ADDR_T; -- Change every cycle
  signal PR_addr_sat_reg : PR_ADDR_T;
  signal PR_addr_sat_reg2 : PR_ADDR_T;

  signal sec_counter     : integer range 0 to 5;
  signal dynamic_update_counter : integer range 0 to 4;

  signal dop_update_pr_diff   : std_logic_vector(15 downto 0);
  signal dop_update_incr      : std_logic_vector(31 downto 0);
  signal code_correction_incr : std_logic_vector(31 downto 0);

  signal flag_6s, flag_spoofing, spoofing_mode              : std_logic;
  type CODE_OUT_T is array(4 downto 0) of std_logic_vector(15 downto 0);
  signal code_count_out : CODE_OUT_T;
  
  signal PR_spoofing : PR_T;
  signal PR_spoofing_diff : PR_T;
  -- PR ram address = PR_addr_base + PR_addr_sat

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

  component transmitter_CA is
    generic (
      TIMER_ADVANCE : integer := 0
    );
    port (
      clk                : IN std_logic;
      reset              : IN std_logic;
      PRN                : OUT std_logic_vector(31 downto 0);
      enable             : IN std_logic;
      code_phase         : IN CODE_PHASE_T;
      CA_incr_step       : IN std_logic_vector(31 downto 0);
      epoch              : OUT std_logic;
      epoch_1023         : OUT std_logic;
      local_timer_next   : IN integer range 0 to 7;
      flag_6s            : IN std_logic;
      code_count_out     : OUT std_logic_vector(15 downto 0);
      flag_spoofing      : IN std_logic;
      spoofing_mode      : IN std_logic
    ) ;
  end component transmitter_CA;

  component altera_mult
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
  end component;

  component transmitter_timer 
    port (
      clk : IN std_logic;
      reset : IN std_logic;
      enable : IN std_logic;
      counter_in_ms : OUT integer range 0 to 8183;
      gms : OUT integer range 0 to 999;
      gs : OUT integer range 0 to 299 
    ) ;
  end component;

  component transmitter_ibit_predictor
    port (
      clk : IN std_logic;
      reset : IN std_logic;
      PR_channels : IN PR_OUTPUT_T;
      tms   : IN integer range 0 to 299999; -- Next updating time
      update_pr : IN std_logic;
      enable : IN std_logic;
      code_phase_next_channels : OUT PHASE_OUTPUT_T;
      data_addr_next_channels : OUT DATA_RAM_OUTPUT_T;
      local_timer_next_channels : OUT TIMER_OUTPUT_T;
      epoch_next_channels : OUT EPOCH_COUNT_T -- How many code cycles have past
    ) ;
  end component;
begin
  write_out <= sin_out(2);
  flag_6s <= '1' when gms = 0 and counter_in_ms = 0 and sec_counter = 5 else '0';
  flag_spoofing <= '1' when gs > 60 and counter_in_ms = 0 and gms=0 else '0';
  spoofing_mode <= '1' when gs > 60 else '0';
  tm0: transmitter_timer
  port map(
    clk => clk,
    reset => reset,
    enable => enable_reg,
    counter_in_ms => counter_in_ms,
    gms => gms,
    gs => gs
  );

  incr_channel0 <= incr_channels(0);
  nco_en <= '1' when (gs >= 6 and enable_reg = '1') else '0'; 
  --signal_out_i <= sin_out when ;
  --signal_out_q <= cos_out;
  rst_n        <= not reset;
  NCO_GEN: for i in 0 to 4 generate
    n0 : waveform_gen 
    port map(
      clk       => clk,
      reset   => rst_n,
      en     => enable_reg,
      phase_inc => incr_channels(i),
      sin_out    => sin_out_12(i),
      cos_out    => cos_out_12(i),
      squ_out => open,
      saw_out => open
    );
    sin_out(i)(11 downto 0)  <= sin_out_12(i) when valid_channels(i) = '1' else (others => '0');
    cos_out(i)(11 downto 0)  <= cos_out_12(i) when valid_channels(i) = '1' else (others => '0');
    sin_out(i)(15 downto 12) <= (others => sin_out_12(i)(11));
    cos_out(i)(15 downto 12) <= (others => cos_out_12(i)(11));

    c0: transmitter_CA
    port map(
      clk        => clk,
      reset      => reset,
      PRN        => CA_channels(i),
      enable     => enable_reg,
      -- code_phase => phase_channels(i),
      code_phase => code_phase_next_channels(i),
      CA_incr_step => CA_freq_step_channels(i),
      epoch      => open,
      epoch_1023 => epoch_CA(i),
      local_timer_next => local_timer_next_channels(i),
      flag_6s => flag_6s,
      code_count_out => code_count_out(i),
      flag_spoofing => flag_spoofing,
      spoofing_mode => spoofing_mode
    );

    signal_out_q(i) <= sin_out(i) when CA_channels(i)(prn_channels(i)) = databits_channels(i) else
      (not sin_out(i)) + 1;
    signal_out_i(i) <= cos_out(i) when CA_channels(i)(prn_channels(i)) = databits_channels(i) else
      (not cos_out(i)) + 1;
    -- signal_out_q(i) <= cos_out(i);

    i_extend(i)(18 downto 16) <= (others => signal_out_i(i)(15));
    i_extend(i)(15 downto 0)  <= signal_out_i(i);
    q_extend(i)(18 downto 16) <= (others => signal_out_q(i)(15));
    q_extend(i)(15 downto 0)  <= signal_out_q(i);

    CA_count : process( reset, clk )
    begin
      if reset = '1' then
        epoch_count(i) <= 0;
        data_addr_channels(i) <= (others => '0');
      elsif rising_edge(clk) then
        if flag_6s = '1' then
          epoch_count(i) <= epoch_next_channels(i);
        elsif epoch_CA(i) = '1' then
          if epoch_count(i) = 19 then
            epoch_count(i) <= 0;
            -- if data_addr_channels(i) = conv_std_logic_vector(14999, data_addr_channels(i)'length) then
            --   data_addr_channels(i) <= (others => '0');
            -- else
            --   data_addr_channels(i) <= data_addr_channels(i) + 1;
            -- end if ;
          else
            epoch_count(i) <= epoch_count(i) + 1;
          end if ;  
        end if;
        

        if flag_6s = '1' then -- End of each 6s cycle
          data_addr_channels(i) <= data_addr_next_channels(i);
        elsif epoch_CA(i) = '1' and epoch_count(i) = 19 then
          if data_addr_channels(i) = conv_std_logic_vector(14999, data_addr_channels(i)'length) then
            data_addr_channels(i) <= (others => '0');
          else
            data_addr_channels(i) <= data_addr_channels(i) + 1;
          end if ;
        end if ;
        
      end if ;
    end process ; -- CA_count
  end generate;

  -- This module is used to correct data bits and code phase every 6 seconds
  p0: transmitter_ibit_predictor
  port map(
    clk => clk,
    reset => reset,
    PR_channels => PR_channels,
    tms   => tms, -- Next updating time
    update_pr => update_pr,
    enable => enable,
    code_phase_next_channels => code_phase_next_channels,
    data_addr_next_channels => data_addr_next_channels,
    local_timer_next_channels => local_timer_next_channels,
    epoch_next_channels => epoch_next_channels
  );

  data_addr <= data_addr_channels(data_in_counter);
  data_ram_p : process( clk, reset )
  begin
    if reset = '1' then
      data_in_counter <= 0;
      data_in_reg <= 0;
      data_in_reg2 <= 0;
      databits_channels <= (others => '0');
    elsif rising_edge(clk) then
      if enable = '1' then
        data_in_reg <= data_in_counter;
        data_in_reg2 <= data_in_reg;
        databits_channels(data_in_reg2) <= data_bits(prn_channels(data_in_reg2)); 
        if data_in_counter = 4 then
          data_in_counter <= 0;
        else
          data_in_counter <= data_in_counter + 1;
        end if ;
      else
        data_in_counter <= 0;
        --databits_channels <= (others => '0');
      end if ;
    end if ;
  end process ; -- data_ram_p

  PR_addr <= PR_addr_base + PR_addr_sat;

  -- PR stores next 6s values, abandon first 6 secs

  pr_ram_p : process( clk, reset )
  begin
    if reset = '1' then
      PR_addr_base     <= (others => '0');
      PR_addr_sat      <= (others => '0');
      PR_addr_sat_reg  <= (others => '0');
      PR_addr_sat_reg2 <= (others => '0');
      sec_counter      <= 0;
      incr_channels    <= (others => (others => '0'));
      CA_freq_step_channels <= (others => (others => '0'));
      tms <= 0;
    elsif rising_edge(clk) then
      -- RAM synchrounous read and PR reg load, need 2 cycles delay
      PR_addr_sat_reg <= PR_addr_sat;
      PR_addr_sat_reg2 <= PR_addr_sat_reg;

      if update_pr = '1' and update_pr_6 = '0' then
        PR_addr_base <= (others => '0');
        sec_counter <= 5;
        -- if PR_addr_sat = conv_std_logic_vector(31, PR_addr_sat'length) then
        --   PR_addr_sat <= (others => '0');
        -- else
        --   PR_addr_sat <= PR_addr_sat + 1;  
        -- end if ;
      -- end if ;
        tms <= 0;
      elsif update_pr_6 = '1' and update_pr_6 = '1' then
        PR_addr_base <= conv_std_logic_vector(32, PR_addr_base'length);
        sec_counter <= 5;
        tms <= 6000;
      elsif enable = '1' then
        if gms = 0 and counter_in_ms = 0 then
          

          if gs = 0 then -- The first s
            PR_addr_base <= conv_std_logic_vector(64, PR_addr_base'length);
            sec_counter <= 0;
            tms <= 12000;
          else -- Other ms, increase counter by 1
            if sec_counter = 5 then -- Every 6 s, move addr base
              sec_counter <= 0;
              -- First cycle of every 6 seconds, update every thing
              PR_addr_base <= PR_addr_base + conv_std_logic_vector(32, PR_addr_base'length);
              tms <= tms + 6000;

            else
              sec_counter <= sec_counter + 1;
            end if ;
          end if ;
        end if ;



        -- if PR_addr_sat = conv_std_logic_vector(31, PR_addr_sat'length) then
        --   PR_addr_sat <= (others => '0');
        -- else
        --   PR_addr_sat <= PR_addr_sat + 1;  
        -- end if ;

        
      end if ;
      -- Update state should use 32 cycles to prepare everything, then in transmission part, things are prepared for next 6 seconds

      if flag_6s = '1' then
        incr_channels <= incr_channels_next;
        CA_freq_step_channels <= CA_freq_step_channels_next;
      end if ;

      if update_pr = '1' or enable = '1' then
        if PR_addr_sat = conv_std_logic_vector(31, PR_addr_sat'length) then
          PR_addr_sat <= (others => '0');
        else
          PR_addr_sat <= PR_addr_sat + 1;  
        end if ;
      end if ;
    end if ;
    
  end process ; -- pr_ram_p
  PR_spoofing_diff <= conv_std_logic_vector(gs, PR_channels(0)'length) - conv_std_logic_vector(60, PR_channels(0)'length);
  PR_spoofing(PR_channels(0)'length-4 downto 0) <= PR_spoofing_diff(PR_channels(0)'length-1 downto 3);
  PR_spoofing(PR_channels(0)'length-1 downto PR_channels(0)'length-3) <= (others => '0');

  PR_update : for i in 0 to 4 generate
    pr_up : process( clk, reset )
    begin
      if reset = '1' then
        PR_channels(i) <= conv_std_logic_vector(20000000, PR_channels(i)'length);
        PR_change_channels(i) <= (others => '0');
      elsif rising_edge(clk) then
        if enable = '1' or update_pr = '1' then
          if conv_integer(PR_addr_sat_reg2) = prn_channels(i) and PR_channels(i) /= PR and valid_channels(i) = '1' then -- Happens every 6 seconds, the first 6 seconds not work
            PR_channels(i)        <= PR;
            if spoofing_mode = '0' then
              PR_change_channels(i) <= PR_channels(i) - PR;
            else
              PR_change_channels(i) <= PR_channels(i) - PR - PR_spoofing;
            end if;
          end if ;
        end if ;
      end if ;
    end process ; -- pr_up
  end generate ; -- identifier

  
  dynamic_counter : process( clk, reset )
  begin
    if reset = '1' then
      dynamic_update_counter <= 0;
      incr_channels_next    <= (others => (others => '0'));
      CA_freq_step_channels_next <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if enable = '1' or update_pr='1' then
        if dynamic_update_counter = 4 then
          dynamic_update_counter <= 0;
        else
          dynamic_update_counter <= dynamic_update_counter + 1;
        end if ;

        -- incr_channels_next(dynamic_update_counter) <= dop_update_incr;
        incr_channels_next(dynamic_update_counter)(dop_update_incr'length-1 downto dop_update_incr'length-3) <= (others => dop_update_incr(dop_update_incr'length-1));
        incr_channels_next(dynamic_update_counter)(dop_update_incr'length-4 downto 0) <= dop_update_incr(dop_update_incr'length-1 downto 3);
        -- Shift right 9 bits
        CA_freq_step_channels_next(dynamic_update_counter)(code_correction_incr'length - 1 - 10 downto 0) <= code_correction_incr(code_correction_incr'length - 1 downto 10);
        CA_freq_step_channels_next(dynamic_update_counter)(code_correction_incr'length - 1 downto code_correction_incr'length - 10) <= (others => code_correction_incr(code_correction_incr'length - 1));
      end if ;
    end if ;
  end process ; -- dynamic_counter
  -- Update doppler frequency
  dop_update_pr_diff <= PR_change_channels(dynamic_update_counter)(dop_update_pr_diff'length - 1 downto 0);

  m1: altera_mult
  port map(
    dataa => dop_update_pr_diff,
    datab => DOP_PR_DIFF_COEFFICIENT,
    result => dop_update_incr
  );

  -- Update CA correction step (f_ca = 1.023e6 + f_d / 1540)

  m2: altera_mult
  port map(
    dataa => dop_update_pr_diff,
    datab => CODE_CORRECTION_COEFFICIENT,
    result => code_correction_incr
  );
  
  
  
  -- i_add <= i_extend(0) + i_extend(1) + i_extend(2) + i_extend(3) + i_extend(4);
  -- q_add <= q_extend(0) + q_extend(1) + q_extend(2) + q_extend(3) + q_extend(4);
  i_add <= i_extend(1) + i_extend(2) + i_extend(3) + i_extend(4);
  q_add <= q_extend(1) + q_extend(2) + q_extend(3) + q_extend(4);
  -- i_add <= i_extend(2);
  -- q_add <= q_extend(2);
  signal_sca_i <= i_add(18 downto 3);
  signal_sca_q <= q_add(18 downto 3);




  -- INITIAL UPDATE

  address <= conv_std_logic_vector(update_cnt, address'length) when update = '1' else
    (others => '0');


  -- dop_extend(6 downto 0) <= prn_phase(22 downto 16);
  -- dop_extend(15 downto 7) <= (others => prn_phase(22));
  -- m0: altera_mult
  -- port map(
  --   dataa => dop_extend,
  --   datab => CA_CORRECTION_STEP,
  --   result => mult_out
  -- );

  STATE : process( clk, reset )
  begin
    if reset = '1' then
      update_reg <= '0';
      enable_reg <= '0';
    elsif rising_edge(clk) then
      update_reg <= update;
      enable_reg <= enable;
    end if ;
  end process ; -- STATE

  UPDATE_PRO : process( clk, reset )
  begin
    if reset = '1' then
      -- incr_channels    <= (others => (others => '0'));
      phase_channels   <= (others => (others => '0'));
      -- dop_channels     <= (others => (others => '0'));
      -- CA_freq_step_channels <= (others => (others => '0'));
      prn_channels     <= (others => 0);
      valid_channels   <= (others => '0');
      cnt_reg          <= 0;
      -- addressa_inner   <= conv_std_logic_vector(0, 4);
      -- addressb         <= 
    elsif rising_edge(clk) then
      cnt_reg <= update_cnt;
      if update_reg = '1' then
        -- addressa_inner            <= conv_std_logic_vector(update_cnt, 4);
        -- addressb <= conv_std_logic_vector(update_cnt + 5, 4);
        if prn_phase(15) = '1' then
          -- incr_channels(cnt_reg)    <= incr;
          phase_channels(cnt_reg)   <= prn_phase(9 downto 0);
          prn_channels(cnt_reg)     <= conv_integer(unsigned(prn_phase(14 downto 10)));
          -- dop_channels(cnt_reg)     <= prn_phase(22 downto 16);
          -- CA_freq_step_channels(cnt_reg) <= mult_out;
        else
          -- incr_channels(cnt_reg)    <= (others => '0');
          phase_channels(cnt_reg)   <= (others => '0');
          prn_channels(cnt_reg)     <= 0;
          -- dop_channels(cnt_reg)     <= (others => '0');
          -- CA_freq_step_channels(cnt_reg) <= (others => '0');
        end if ;
        valid_channels(cnt_reg) <= prn_phase(15);
      else
        -- addressa_inner            <= conv_std_logic_vector(0, 4);
      end if ;
    end if ;
    
  end process ; -- UPDATE_PRO

  rx_out_p : process( clk, reset )
  begin
    if reset = '1' then
      rx_out <= (others => '0');
      rx_counter <= (others => '0');
    elsif rising_edge(clk) then
      sin_out_reg <= sin_out_12(2);
      rx_counter(3) <= rx_counter(2);
      rx_counter(2) <= rx_counter(1);
      rx_counter(1) <= rx_counter(0);
      --if (counter_in_ms >= 8180 and gms = 999) or (counter_in_ms <= 7 and gms = 0) then
       -- if counter_in_ms = 8180 or counter_in_ms = 0 or counter_in_ms = 4 then
       --   rx_out(63 downto 48) <= conv_std_logic_vector(gs, 16);
       --   rx_out(47 downto 32) <= code_count_out(2);
       --   --rx_out(31 downto 0) <= incr_channels(2);
       --   if counter_in_ms = 8180 then
       --     rx_out(31 downto 24) <= conv_std_logic_vector(1, 8);
       --   elsif counter_in_ms = 0 then
       --     rx_out(31 downto 24) <= conv_std_logic_vector(2, 8);
       --   elsif counter_in_ms = 4 then
       --     rx_out(31 downto 24) <= conv_std_logic_vector(3, 8);
       --   end if;
       --   rx_out(23 downto 16) <= conv_std_logic_vector(epoch_count(2), 8);
       --   rx_out(data_addr_channels(0)'length-1 downto 0)  <= data_addr_channels(2);
       -- end if;
      -- else
      --  rx_out <= (others => '0');
      -- end if ;
      -- if sin_out_12(2) = conv_std_logic_vector(0, 12) then
      --  rx_out <= (others => '1');
      -- else 
      --   rx_out <= (others => '0');
      -- end if;
      if signed(sin_out_12(2)) - signed(sin_out_reg) > signed(conv_std_logic_vector(25, 12)) or signed(sin_out_12(2)) - signed(sin_out_reg) < signed(conv_std_logic_vector(-25, 12)) then
        --rx_out <= (others => '1');
        rx_counter(0) <= '1';
      else
        rx_counter(0) <= '0';
      end if;
      
      if(rx_counter /= conv_std_logic_vector(0, 4)) then
        rx_out <= (others => '1');
      else
        rx_out <= (others => '0');
      end if;
    end if ;
  end process ; -- rx_out

end arch ; -- arch

