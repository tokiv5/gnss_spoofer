library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity acq_fsm_tb is
end acq_fsm_tb;

architecture arch of acq_fsm_tb is
  type RAM_TYPE is array(4 downto 0) of std_logic_vector(31 downto 0);
  signal ram_f, ram_p : RAM_TYPE;
  signal clk, reset : std_logic := '0';
  signal complete_receive, complete_save, START, update: std_logic;
  signal address : RAM_DEPTH_T;
  signal data_a, data_b: RAM_WIDTH_T;
  signal INCR_SAT : INCR_SAT_T := (others => (others => '1'));
  signal phaseSAT : CODE_SAT_T := (others => (others => '1'));
  signal detectedSAT: std_logic_vector(31 downto 0) := "01001011001101010000110100101001";
  signal wren     : std_logic;

  component acquisition_fsm
    port (
      clk              : IN std_logic;
      reset            : IN std_logic;
      complete_receive : IN std_logic;
      complete_save    : IN std_logic;
      START            : IN std_logic;
      update           : OUT std_logic;
      enable   : OUT std_logic
    ) ;
  end component;

  component acquisition_save
    port (
      clk         : IN std_logic;
      reset       : IN std_logic;
      address     : OUT RAM_DEPTH_T;
      wren        : OUT std_logic;
      --address_b   : OUT RAM_DEPTH_T;
      data_a      : OUT RAM_WIDTH_T;
      data_b      : OUT RAM_WIDTH_T;
      update      : IN std_logic;
      complete    : OUT std_logic;
      INCR_SAT    : IN INCR_SAT_T;
      phaseSAT    : IN CODE_SAT_T;
      --max_acc_out : IN ACQ_RESULT;
      detectedSAT : IN std_logic_vector(31 downto 0)
    ) ;
  end component;
begin
  ram0 : process( clk, reset )
  begin
    if reset = '1' then
      ram_f <= (others => (others => '0'));
      ram_p <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if wren = '1' then
        ram_f(conv_integer(unsigned(address))) <= data_a;
        ram_p(conv_integer(unsigned(address))) <= data_b;
      end if ;
    end if ;
  end process ; -- ram0

  clk <= not clk after 5 ns;
  reset <= '1' after 1 ns, '0' after 2 ns;
  START <= '1' after 6 ns, '0' after 16 ns, '1' after 550 ns;
  complete_receive <= '1' after 26 ns, '0' after 36 ns, '1' after 580 ns;

  f0: acquisition_fsm
  port map(
    clk  => clk,
    reset => reset,
    complete_receive => complete_receive,
    complete_save    => complete_save,
    START            => START,
    update           => update,
    enable           => open
  );

  s0: acquisition_save
  port map(
    clk => clk,
    reset => reset,
    address => address,
    wren => wren,
    data_a => data_a,
    data_b => data_b,
    update => update,
    complete => complete_save,
    INCR_SAT => INCR_SAT,
    phaseSAT => phaseSAT,
    detectedSAT => detectedSAT
  );
end arch ; -- arch

