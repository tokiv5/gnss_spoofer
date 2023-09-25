library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity transmitter_fsm is
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
end transmitter_fsm;

architecture arch of transmitter_fsm is
  -- TRIG : wait for write_in to be start to write flag
  type state_type is (IDLE, TRIG, DATARAM, PRRAM, LOAD, PR, PR6, TRANSMIT);
  signal present_state, next_state: state_type;
  signal write_in_reg: std_logic_vector(31 downto 0);
  signal clk_div_2 : std_logic;
  signal cnt : integer range 0 to 4;
  signal pr_cnt : integer range 0 to 61;
  signal is_flag : std_logic;
  signal data_ram_counter : integer range 0 to 14999;
  signal pr_ram_counter   : integer range 0 to 1599;
begin
  data_ram_counter_out <= data_ram_counter;
  pr_ram_counter_out <= pr_ram_counter;
  update_cnt <= cnt;
  state_process : process( clk, reset )
  begin
    if reset = '1' then
      present_state <= IDLE;
    elsif rising_edge(clk) then
      present_state <= next_state;
    end if ;
  end process ; -- p0

  is_flag <= '1' when write_in = X"AAAAAAAA" and clk_div_2 = '1' else '0';
  -- is_flag <= '1' when clk_div_2 = '1' else '0';
  fsm : process( present_state, cnt, pr_cnt, START, ENDING, is_flag, clk_div_2, data_ram_counter, pr_ram_counter )
  begin
    -- next_state <= present_state;
    case( present_state ) is
      when IDLE =>
        update <= '0';
        update_pr <= '0';
        update_pr_6 <= '0';
        enable <= '0';
        data_write <= '0';
        pr_write <= '0';
        if START = '1' then
          next_state <= TRIG;
        else
          next_state <= IDLE;
        end if ;
      when TRIG => 
        update <= '0';
        update_pr <= '0';
        update_pr_6 <= '0';
        enable <= '0';
        data_write <= '0';
        pr_write <= '0';
        if is_flag = '1' then
          next_state <= DATARAM;
        else
          next_state <= TRIG;
        end if ;
      when DATARAM =>
        update <= '0';
        update_pr <= '0';
        update_pr_6 <= '0';
        enable <= '0';
        pr_write <= '0';
        if clk_div_2 = '1' then
          data_write <= '1';
        else
          data_write <= '0';
        end if ;
        if data_ram_counter = 14999 and clk_div_2 = '1' then
          next_state <= PRRAM;
        else
          next_state <= DATARAM;
        end if ;
      when PRRAM =>
        update <= '0';
        update_pr <= '0';
        update_pr_6 <= '0';
        enable <= '0';
        data_write <= '0';
        if clk_div_2 = '1' then
          pr_write <= '1';
        else
          pr_write <= '0';
        end if ;
        if pr_ram_counter = 1599 and clk_div_2 = '1' then
          next_state <= LOAD;
        else
          next_state <= PRRAM;
        end if ;
      when LOAD => 
        update <= '1';
        update_pr <= '0';
        update_pr_6 <= '0';
        enable <= '0';
        data_write <= '0';
        pr_write <= '0';
        if cnt = 4 then
          next_state <= PR;
        else
          next_state <= LOAD;
        end if ;
      when PR =>
        update <= '0';
        update_pr <= '1';
        update_pr_6 <= '0';
        enable <= '0';
        data_write <= '0';
        pr_write <= '0';
        if pr_cnt = 61 then
          next_state <= PR6;
        else
          next_state <= PR;
        end if ;
      when PR6 =>
        update <= '0';
        update_pr <= '1';
        update_pr_6 <= '1';
        enable <= '0';
        data_write <= '0';
        pr_write <= '0';
        if pr_cnt = 61 then
          next_state <= TRANSMIT;
        else
          next_state <= PR6;
        end if ;
      when TRANSMIT =>
        update <= '0';
        update_pr <= '0';
        update_pr_6 <= '0';
        enable <= '1';
        data_write <= '0';
        pr_write <= '0';
        if ENDING = '1' then
          next_state <= IDLE;
        else
          next_state <= TRANSMIT;
        end if ;
      when others =>
        next_state <= present_state;
    end case ;
  end process ; -- fsm

  counter : process( clk, reset )
  begin
    if reset = '1' then
      cnt <= 0;
    elsif rising_edge(clk) then
      if present_state = LOAD then
        if cnt < 4 then
          cnt <= cnt + 1;
        else
          cnt <= 0;              
        end if ;
      else
        cnt <= 0;
      end if ;
    end if ;
  end process ; -- counter

  pr_counter : process( clk, reset )
  begin
    if reset = '1' then
      pr_cnt <= 0;
    elsif rising_edge(clk) then
      if present_state = PR or present_state = PR6 then
        if pr_cnt < 61 then
          pr_cnt <= pr_cnt + 1;
        else
          pr_cnt <= 0;              
        end if ;
      else
        pr_cnt <= 0;
      end if ;
    end if ;
  end process ; -- counter

  dram_counter : process( clk, reset )
  begin
    if reset = '1' then
      data_ram_counter <= 0;
    elsif rising_edge(clk) then
      if present_state = DATARAM then
        if clk_div_2 = '1' then
          if data_ram_counter < 14999 then
            data_ram_counter <= data_ram_counter + 1;
          else
            data_ram_counter <= 0;              
          end if ;
        end if ;
      else
        data_ram_counter <= 0;
      end if ;
    end if ;
  end process ; -- counter

  pram_counter : process( clk, reset )
  begin
    if reset = '1' then
      pr_ram_counter <= 0;
    elsif rising_edge(clk) then
      if present_state = PRRAM then
        if clk_div_2 = '1' then
          if pr_ram_counter < 1599 then
            pr_ram_counter <= pr_ram_counter + 1;
          else
            pr_ram_counter <= 0;              
          end if ;
        end if ;
      else
        pr_ram_counter <= 0;
      end if ;
    end if ;
  end process ; -- counter

  clk2 : process( clk, reset )
  begin
    if reset = '1' then
      clk_div_2 <= '0';
    elsif rising_edge(clk) then
      clk_div_2 <= not clk_div_2;
    end if ;

  end process ; -- clk2


end arch ; -- arch
