library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity acquisition_fsm is
  port (
    clk              : IN std_logic;
    reset            : IN std_logic;
    complete_receive : IN std_logic;
    complete_save    : IN std_logic;
    START            : IN std_logic;
    update           : OUT std_logic;
    enable   : OUT std_logic
  ) ;
end acquisition_fsm;

architecture arch of acquisition_fsm is
  type state_type is (IDLE, RECEIVE, SAVE);
  signal present_state, next_state: state_type;

begin
  state_process : process( clk, reset )
  begin
    if reset = '1' then
      present_state <= IDLE;
    elsif rising_edge(clk) then
      present_state <= next_state;
    end if ;
  end process ; -- p0

  fsm : process( present_state, START, complete_receive, complete_save )
  begin
    -- next_state <= present_state;
    case( present_state ) is
      when IDLE =>
        update <= '0';
        enable <= '0';
        if START = '1' then
          next_state <= RECEIVE;
        else
          next_state <= IDLE;
        end if ;
      when RECEIVE => 
        update <= '0';
        enable <= '1';
        if complete_receive = '1' then
          next_state <= SAVE;
        else
          next_state <= LOAD;
        end if ;
      when SAVE =>
        update <= '1';
        enable <= '0';
        if complete_save = '1' then
          next_state <= IDLE;
        else
          next_state <= SAVE;
        end if ;
      when others =>
        next_state <= present_state;
    end case ;
  end process ; -- fsm

end arch ; -- arch