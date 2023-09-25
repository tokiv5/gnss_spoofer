library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity transmitter_ibit_predictor is
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
end transmitter_ibit_predictor;

architecture arch of transmitter_ibit_predictor is

  component altera_mult32
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (42 DOWNTO 0)
	);
  end component;

  component divider
	PORT
	(
		denom		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		numer		: IN STD_LOGIC_VECTOR (39 DOWNTO 0);
		quotient		: OUT STD_LOGIC_VECTOR (39 DOWNTO 0);
		remain		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
  end component;

  signal present_channel_counter, next_channel_counter : integer range 0 to 4;
  -- MULT1 : PR * 1000 (Change to ms unit)
  -- DIV1  : PR * 1000 / c = ms ... remainer
  -- MULT2 : remainer * 1023 (Change to code chip unit) //// bit = ms / 20 = q ... remainer -> output bit / ca count
  -- DIV2  : remainer * 1023 / c = codephase ... remainer2 -> output code_phase
  -- COMPARE : compare remainer2 with 1/8 c to determine local_timer step (0~7)
  type process_step is (IDLE, MULT1, DIV1, MULT2, DIV2, COMPARE);
  signal present_state, next_state : process_step;
  signal mult_result        : std_logic_vector(42 downto 0);
  signal dataa_in           : std_logic_vector(31 downto 0);
  signal datab_in           : std_logic_vector(10 downto 0);

  signal denom              : std_logic_vector(31 downto 0);
  signal numer              : std_logic_vector(39 downto 0);
  signal quotient           : std_logic_vector(39 downto 0);
  signal remain             : std_logic_vector(31 downto 0);
  signal compare_result     : integer range 0 to 7;


begin
  channel_counter : process( clk, reset )
  begin
    if reset = '1' then
      next_channel_counter <= 0;
      present_channel_counter <= 0;
    elsif rising_edge(clk) then
      if present_state = MULT1 then
        -- increment channel counter to next
        -- get next pr with next counter
        -- output result with present counter
        present_channel_counter <= next_channel_counter;
        if next_channel_counter = 4 then
          next_channel_counter <= 0;
        else
          next_channel_counter <= next_channel_counter + 1;
        end if ;
      end if ;
    end if ;
  end process ; -- channel_counter

  state_process : process( clk, reset )
  begin
    if reset = '1' then
      present_state <= IDLE;
    elsif rising_edge(clk) then
      present_state <= next_state;
    end if ;
  end process ; -- p0

  fsm : process( present_state, enable, update_pr )
  begin
    case( present_state ) is
    
      when IDLE =>
        if update_pr = '1' or enable = '1' then
          next_state <= MULT1;
        else
          next_state <= IDLE;
        end if ;

      when MULT1 => 
        next_state <= DIV1;
      
      when DIV1 => 
        next_state <= MULT2;

      when MULT2 => 
        next_state <= DIV2;

      when DIV2 => 
        next_state <= COMPARE;

      when COMPARE =>
        if update_pr = '1' or enable = '1' then
          next_state <= MULT1;
        else
          next_state <= IDLE;
        end if ;
    
      when others =>
        next_state <= IDLE;
        
    end case ;
  end process ; -- fsm

  m0: altera_mult32
  port map (
    dataa => dataa_in,
    datab => datab_in,
    result => mult_result
  );

  d0: divider
  port map (
    denom => denom,
    numer => numer,
    quotient => quotient,
    remain   => remain
  );

  mult_parameter_up : process( clk, reset )
  begin
    if reset = '1' then
      dataa_in <= (others => '0');
      datab_in <= (others => '0');
    elsif rising_edge(clk) then
      if present_state = MULT1 then
        dataa_in <= PR_channels(next_channel_counter);
        datab_in <= conv_std_logic_vector(1000, 11);
      elsif present_state = MULT2 then
        dataa_in <= remain;
        datab_in <= conv_std_logic_vector(1023, 11);
      else
        dataa_in <= dataa_in;
        datab_in <= datab_in;  
      end if ;
    end if ;
  end process ; -- identifier

  div_parameter_up : process( clk, reset )
  begin
    if reset = '1' then
      denom <= (others => '0');
      numer <= (others => '0');
    elsif rising_edge(clk) then
      if present_state = DIV1 then
        numer <= mult_result(numer'length - 1 downto 0);
        denom <= SPEED_OF_LIGHT;
      elsif present_state = MULT2 then
        if conv_std_logic_vector(tms, quotient'length) < quotient + 1 then
          numer <= (others => '0');
        else
          numer <= conv_std_logic_vector(tms, quotient'length) - quotient - 1;
        end if ;
        
        denom <= BIT_PERIOD;
      elsif present_state = DIV2 then
        numer <= mult_result(numer'length - 1 downto 0);
        denom <= SPEED_OF_LIGHT;
      else
        numer <= numer;
        denom <= denom;
      end if ;
    end if ;
  end process ; -- div_parameter_up

  local_time_up : process( clk, reset )
  begin
    if reset = '1' then
      -- local_timer_next_channels <= (others => 0);
      compare_result <= 0;
    elsif rising_edge(clk) then
      if present_state = COMPARE then
        if remain < c1_DIV_8_LIGHT then
          compare_result <= 7;
        elsif remain < c2_DIV_8_LIGHT then
          compare_result <= 6;
        elsif remain < c3_DIV_8_LIGHT then
          compare_result <= 5;
        elsif remain < c4_DIV_8_LIGHT then
          compare_result <= 4;
        elsif remain < c5_DIV_8_LIGHT then
          compare_result <= 3;
        elsif remain < c6_DIV_8_LIGHT then
          compare_result <= 2;
        elsif remain < c7_DIV_8_LIGHT then
          compare_result <= 1;
        else
          compare_result <= 0;
        end if ;
      end if ;
    end if ;
    
  end process ; -- local_time_up

  results_update : process( clk, reset )
  begin
    if reset = '1' then
      code_phase_next_channels <= (others => (others => '0'));
      data_addr_next_channels <= (others => (others => '0'));
      local_timer_next_channels <= (others => 0);
    elsif rising_edge(clk) then
      if present_state = DIV2 then -- bit index calculated
        data_addr_next_channels(present_channel_counter) <= quotient(data_addr_next_channels(0)'length - 1 downto 0);
        epoch_next_channels(present_channel_counter) <= conv_integer(remain);
      elsif present_state = COMPARE then -- Code phase calculated
        code_phase_next_channels(present_channel_counter) <= 1022 - quotient(code_phase_next_channels(0)'length - 1 downto 0);
      elsif present_state = MULT1 then
        local_timer_next_channels(present_channel_counter) <= compare_result;
      end if ;
    end if ;
  end process ; -- result_update

end arch ; -- arch


-- Suppose all remainer > 0
-- tau_transmission = PR / c = q + remainer / c
-- t_satellite_start_transmission = t_receiver_time_now - tau_transmission = tms - q - remainer / c
-- t_integer_satellite_start_transmission = tms - q - 1
-- bit...ca = (tms - q - 1) / 20
-- code_phase = (t - t_int) * 1023 = (1 - remainer / c) * 1023 = 1023 - 1023 * remainer / c = 1023 - q' - remainer' / c
-- code_phase_int = 1023 - q' - 1

