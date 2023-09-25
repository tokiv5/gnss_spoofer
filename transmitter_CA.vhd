library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity transmitter_CA is
  generic (
    TIMER_ADVANCE : integer range 0 to 7 := 0;
    COUNT_ADVANCE : std_logic_vector := conv_std_logic_vector(0, 10)
  );
  port (
    clk                : IN std_logic;
    reset              : IN std_logic;
    PRN                : OUT std_logic_vector(31 downto 0);
    enable             : IN std_logic;
    code_phase         : IN CODE_PHASE_T;
    CA_incr_step       : IN std_logic_vector(31 downto 0);
    epoch              : OUT std_logic; -- 1023 chips
    epoch_1023         : OUT std_logic; -- will be high at the slack 1023 to 0 
    local_timer_next   : IN integer range 0 to 7;
    flag_6s            : IN std_logic;
    code_count_out     : OUT std_logic_vector(15 downto 0);
    flag_spoofing      : IN std_logic;
    spoofing_mode      : IN std_logic
  ) ;
end transmitter_CA;

architecture arch of transmitter_CA is

  signal code_addr, code_addr_reg   : CODE_PHASE_T;
  signal code_count  : CODE_PHASE_T;
  signal local_timer : integer range 0 to 7;
  signal code_sum    : std_logic_vector(10 downto 0);
  signal code_diff   : std_logic_vector(10 downto 0);
  signal CA_incr_counter : std_logic_vector(31 downto 0);
  signal test_flag   : std_logic;
  signal js_flag     : std_logic;
  component CAtable
    PORT
    (
      address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
      clock		: IN STD_LOGIC  := '1';
      q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  end component;
begin
  code_count_out(11 downto 0) <= "00" & code_count;
  code_count_out(15 downto 12) <= conv_std_logic_vector(local_timer, 4);
  r0: CAtable
  port map(
    -- address => code_addr,
    address => code_count,
    clock   => clk,
    q       => PRN
  );
  -- code_sum  <= ('0' & code_count) + ('0' & code_phase); 
  -- code_diff <= code_sum - conv_std_logic_vector(1023, 11);
  -- code_addr <= code_sum(9 downto 0) when unsigned(code_sum) < 1023 else code_diff(9 downto 0);

  epoch_p : process( reset, clk )
  begin
    if (reset = '1') then
      code_addr_reg <= (others => '0');
      epoch_1023 <= '0';
    elsif rising_edge(clk) then
      if enable = '1' then
        -- code_addr_reg <= code_addr;
        -- if code_addr_reg = conv_std_logic_vector(1022, 10) and code_addr = conv_std_logic_vector(0, 10) then
        code_addr_reg <= code_count;
        if code_addr_reg = conv_std_logic_vector(1022, 10) and code_count = conv_std_logic_vector(0, 10) then
          epoch_1023 <= '1';
        else
          epoch_1023 <= '0';
        end if ;
      end if ;
    end if ;
    
  end process ; -- epoch_p

  --epoch <= '1' when code_count = '0' else '0';
  --phase_period_epoch <= '1' when local_timer

  timer : process( reset, clk )
  begin
    if (reset = '1') then
      local_timer <= TIMER_ADVANCE; -- 32 cycles save to ram and 5 cycles read from ram so start from 5 and code count + 4
      code_count <= COUNT_ADVANCE;
      CA_incr_counter <= (others => '0');
      test_flag <= '0';

    elsif rising_edge(clk) then
      if flag_6s = '1' and spoofing_mode = '0' then
        code_count <= code_phase;
        local_timer <= local_timer_next;
        CA_incr_counter <= (others => '0');
        js_flag <= '0';
      -- elsif flag_spoofing = '1' then
        -- if code_count = conv_std_logic_vector(1022, 10) then
        --  code_count <= (others => '0');
        --  epoch <= '1';
        --  
        -- else
        --   code_count <= code_count + 1;
        --   epoch <= '0';
        -- end if ;
      -- if (local_timer = 7) or (local_timer = 6) then
      --      local_timer <= local_timer - 6;
      --      if code_count = conv_std_logic_vector(1022, 10) then
      --        code_count <= (others => '0');
      --        epoch <= '1';
      --      else
      --        code_count <= code_count + 1;
      --        epoch <= '0';
      --      end if ;
      --    else
      --      local_timer <= local_timer + 2;
      --      epoch <= '0';
      --    end if ;
      elsif enable = '1' then

        if CA_incr_counter > CA_JUMP then
          js_flag <= '1';
          CA_incr_counter <= CA_incr_counter + CA_incr_step - CA_JUMP;
          test_flag <= '1';
          if (local_timer = 7) or (local_timer = 6) then
            local_timer <= local_timer - 6;
            if code_count = conv_std_logic_vector(1022, 10) then
              code_count <= (others => '0');
              epoch <= '1';
            else
              code_count <= code_count + 1;
              epoch <= '0';
            end if ;
          else
            local_timer <= local_timer + 2;
            epoch <= '0';
          end if ;  
        elsif CA_incr_counter < CA_STAY then
          js_flag <= '1';
          CA_incr_counter <= CA_incr_counter + CA_incr_step + CA_JUMP;
          local_timer <= local_timer;
          code_count  <= code_count;
          epoch <= '0';
        else
          js_flag <= '0';
          CA_incr_counter <= CA_incr_counter + CA_incr_step;
          if (local_timer = 7) then
            local_timer <= 0;
            if code_count = conv_std_logic_vector(1022, 10) then
              code_count <= (others => '0');
              epoch <= '1';
              
            else
              code_count <= code_count + 1;
              epoch <= '0';
            end if ;
          else
            local_timer <= local_timer + 1;
            epoch <= '0';
          end if ;     
        end if ;
  
      else
        local_timer <= TIMER_ADVANCE;
        code_count  <= (others => '0');     
      end if ;
    end if ;
  end process ; -- timer
end arch ; -- arch
