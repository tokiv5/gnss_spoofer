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
    enable      : OUT std_logic; -- NCO enable to transmit
    update_cnt  : OUT integer range 0 to 4
  ) ;
end transmitter_fsm;

architecture arch of transmitter_fsm is
  type state_type is (IDLE, LOAD, TRANSMIT);
  signal present_state, next_state: state_type;
  signal cnt : integer range 0 to 4;
begin
  update_cnt <= cnt;
  state_process : process( clk, reset )
  begin
    if reset = '1' then
      present_state <= IDLE;
    elsif rising_edge(clk) then
      present_state <= next_state;
    end if ;
  end process ; -- p0

  fsm : process( present_state, cnt, START, ENDING )
  begin
    -- next_state <= present_state;
    case( present_state ) is
      when IDLE =>
        update <= '0';
        enable <= '0';
        if START = '1' then
          next_state <= LOAD;
        else
          next_state <= IDLE;
        end if ;
      when LOAD => 
        update <= '1';
        enable <= '0';
        if cnt = 4 then
          next_state <= TRANSMIT;
        else
          next_state <= LOAD;
        end if ;
      when TRANSMIT =>
        update <= '0';
        enable <= '1';
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
end arch ; -- arch