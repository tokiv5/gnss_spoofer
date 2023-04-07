library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.gnss_p.all;

entity acquisition_save is
  port (
    clk         : IN std_logic;
    reset       : IN std_logic;
    address     : OUT RAM_DEPTH_T;
    --address_b   : OUT RAM_DEPTH_T;
    data_a      : OUT RAM_WIDTH_T;
    data_b      : OUT RAM_WIDTH_T;
    update      : IN std_logic;
    complete    : OUT std_logic;
    INCR_SAT    : IN INCR_SAT_T;
    phaseSAT    : IN CODE_SAT_T;
    max_acc_out : IN ACQ_RESULT
  ) ;
end acquisition_save;

architecture arch of acquisition_save is

  signal cnt : integer range 0 to 4;

begin
  
end arch ; -- arch