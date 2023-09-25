library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity transmitter_timer is
  port (
    clk : IN std_logic;
    reset : IN std_logic;
    enable : IN std_logic;
    counter_in_ms : OUT integer range 0 to 8183;
    gms : OUT integer range 0 to 999;
    gs : OUT integer range 0 to 299
    -- tms : OUT integer range 0 to 299999
    -- epoch_6s: OUT std_logic 
  ) ;
end transmitter_timer;

architecture arch of transmitter_timer is

  signal counter_in_ms_reg : integer range 0 to 8183;
  signal gms_reg           : integer range 0 to 999;
  signal gs_reg            : integer range 0 to 299;
  signal sec_counter       : integer range 0 to 5;
  signal tms_reg           : integer range 0 to 299999;

begin
  counter_in_ms <= counter_in_ms_reg;
  gms           <= gms_reg;
  gs            <= gs_reg;

  timer_p : process( clk, reset )
  begin
    if reset = '1' then
      counter_in_ms_reg <= 0;
      gms_reg           <= 0;
      gs_reg            <= 0;
    elsif rising_edge(clk) then
      if enable = '1' then
        if counter_in_ms_reg = 8183 then
          counter_in_ms_reg <= 0;
          if gms_reg = 999 then
            gms_reg <= 0;
            if gs_reg = 299 then
              gs_reg <= 0;
            else
              gs_reg <= gs_reg + 1;
            end if ;

          else
            gms_reg <= gms_reg + 1;
          end if ;



        else
          counter_in_ms_reg <= counter_in_ms_reg + 1;
        end if ;
      else
        counter_in_ms_reg <= 0;
        gms_reg           <= 0;
        gs_reg            <= 0;
      end if ;
    end if ;
  end process ; -- timer_p
end arch ; -- arch
