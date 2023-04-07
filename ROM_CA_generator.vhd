library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity ROM_CA_generator is
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
    phase_period_epoch : OUT std_logic
  ) ;
end ROM_CA_generator;

architecture arch of ROM_CA_generator is

  signal code_phase  : CODE_PHASE_T;
  signal code_addr   : CODE_PHASE_T;
  signal code_count  : CODE_PHASE_T;
  signal local_timer : integer range 0 to 19;
  signal code_sum    : std_logic_vector(10 downto 0);
  signal code_diff   : std_logic_vector(10 downto 0);
  component CAtable
    PORT
    (
      address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
      clock		: IN STD_LOGIC  := '1';
      q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  end component;
begin
  code_phase_out <= code_phase;
  r0: CAtable
  port map(
    address => code_addr,
    clock   => clk,
    q       => PRN
  );
  code_sum  <= ('0' & code_count) + ('0' & code_phase); 
  code_diff <= code_sum - conv_std_logic_vector(1023, 11);
  code_addr <= code_sum(9 downto 0) when unsigned(code_sum) < 1023 else code_diff(9 downto 0);

  --epoch <= '1' when code_count = '0' else '0';
  --phase_period_epoch <= '1' when local_timer

  timer : process( reset, clk )
  begin
    if (reset = '1') then
      local_timer <= 0;
      code_count <= (others => '0');
      code_phase <= conv_std_logic_vector(START_PHASE, 10);

    elsif rising_edge(clk) then
      if enable = '1' then
        if (local_timer = 19) then
          local_timer <= 0;
          if code_count = conv_std_logic_vector(1022, 10) then
            code_count <= (others => '0');
            epoch <= '1';
            if code_phase = conv_std_logic_vector(1022, 10) then
              code_phase <= (others => '0');
              phase_period_epoch <= '1';
            else
              code_phase <= code_phase + 1;
              phase_period_epoch <= '0';
            end if ;
          else
            code_count <= code_count + 1;
            epoch <= '0';
            phase_period_epoch <= '0';
          end if ;
        else
          local_timer <= local_timer + 1;
          phase_period_epoch <= '0';
          epoch <= '0';
        end if ;  
      else
        local_timer <= 0;
        code_count <= (others => '0');
        code_phase <= conv_std_logic_vector(START_PHASE, 10);     
      end if ;
    end if ;
  end process ; -- timer
end arch ; -- arch

