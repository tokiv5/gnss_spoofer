library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity transmitter is
  port (
    clk         : IN std_logic;
    reset       : IN std_logic;
    START       : IN  std_logic; -- start to load
    ENDING      : IN  std_logic; -- end to transmit
    address     : OUT RAM_DEPTH_T;
    incr        : IN  RAM_WIDTH_T;
    prn_phase   : IN  RAM_WIDTH_T;
    signal_sca_i: OUT BLADERF_T; -- rescale after adding up
    signal_sca_q: OUT BLADERF_T;
    incr_channel0 : OUT RAM_WIDTH_T;
    rx_out      : OUT std_logic_vector(63 downto 0);
    -- write_out   : OUT std_logic_vector(15 downto 0);
    -- enable_out  : OUT std_logic
    write_in    : IN std_logic_vector(31 downto 0)
  ) ;
end transmitter;

architecture arch of transmitter is

  signal update     : std_logic;
  signal update_cnt : integer range 0 to 4;
  signal enable     : std_logic;
  signal data_addr  : DATA_RAM_ADDR_T;
  signal data_bits  : std_logic_vector(31 downto 0);
  signal pr_addr    : PR_ADDR_T;
  signal PR         : std_logic_vector(31 downto 0);
  signal update_pr  : std_logic;
  signal update_pr_6: std_logic;
  signal data_ram_counter : integer range 0 to 14999;
  signal pr_ram_counter : integer range 0 to 1599;
  signal data_write, pr_write : std_logic;
  signal data_wraddress : std_logic_vector(13 downto 0);
  signal pr_wraddress   : std_logic_vector(10 downto 0);
  signal write_in_reg   : std_logic_vector(31 downto 0);
  signal clk_div_2      : std_logic;
  component transmitter_fsm is
    port (
      clk         : IN  std_logic;
      reset       : IN  std_logic;
      START       : IN  std_logic; -- start to load
      ENDING      : IN  std_logic; -- end to transmit
      update      : OUT std_logic; -- enable signal for updating nco frequency code offset
      update_pr   : OUT std_logic;
      update_pr_6 : OUT std_logic;
      enable      : OUT std_logic; -- NCO enable to transmit
      update_cnt  : OUT integer range 0 to 4;
      write_in    : IN  std_logic_vector(31 downto 0);
      data_ram_counter_out : OUT integer range 0 to 14999;
      pr_ram_counter_out   : OUT integer range 0 to 1599;
      data_write  : OUT std_logic;
      pr_write    : OUT std_logic
    ) ;
  end component;

  component transmitter_gen is
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
      PR          : IN std_logic_vector(31 downto 0);
      rx_out      : OUT std_logic_vector(63 downto 0)
      -- write_out   : OUT std_logic_vector(15 downto 0)
    ) ;
  end component;

component ram_5min
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

component pr_ram
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;
begin
  -- enable_out <= enable;
  f0: transmitter_fsm
  port map(
    clk        => clk,
    reset      => reset,
    START      => START,
    ENDING     => ENDING,
    update     => update,
    update_pr  => update_pr,
    update_pr_6 => update_pr_6,
    enable     => enable,
    update_cnt => update_cnt,
    write_in   => write_in_reg,
    data_ram_counter_out => data_ram_counter,
    pr_ram_counter_out   => pr_ram_counter,
    data_write => data_write,
    pr_write   => pr_write 
  );

  g0: transmitter_gen
  port map(
    clk          => clk,
    reset        => reset,
    enable       => enable,
    update       => update, 
    update_pr    => update_pr,
    update_pr_6 => update_pr_6,
    update_cnt   => update_cnt,
    address      => address,
    incr         => incr,
    prn_phase    => prn_phase,
    signal_sca_i => signal_sca_i,
    signal_sca_q => signal_sca_q,
    incr_channel0 => incr_channel0,
    data_addr    => data_addr,
    data_bits    => data_bits,
    PR_addr      => pr_addr,
    PR           => PR,
    rx_out       => rx_out
    -- write_out    => write_out
  );
  data_wraddress <= conv_std_logic_vector(data_ram_counter, 14);
  d0: ram_5min
  port map(
    clock => clk,
    data  => write_in_reg,
    rdaddress => data_addr,
    wraddress => data_wraddress,
    wren      => data_write,
    q         => data_bits
  );

  pr_wraddress <= conv_std_logic_vector(pr_ram_counter, 11);
  p0: pr_ram
  port map(
    clock => clk,
    data  => write_in_reg,
    rdaddress => pr_addr,
    wraddress => pr_wraddress,
    wren      => pr_write,
    q         => PR
  );

  write_Reg : process( clk, reset )
  begin
    if reset = '1' then
      write_in_reg <= (others => '0');
    elsif rising_edge(clk) then
      if clk_div_2 = '1' then
        write_in_reg <= write_in;
      end if ;
    end if ;
  end process ; -- write_Reg

  clk2 : process( clk, reset )
  begin
    if reset = '1' then
      clk_div_2 <= '0';
    elsif rising_edge(clk) then
      clk_div_2 <= not clk_div_2;
    end if ;

  end process ; -- clk2
end arch ; -- arch

