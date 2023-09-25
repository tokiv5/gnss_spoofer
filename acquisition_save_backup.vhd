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
end acquisition_save;

architecture arch of acquisition_save is

  signal choose_cnt : integer range 0 to 31;
  signal save_cnt   : integer range 0 to 4;
  signal complete_in: std_logic;
  -- type   chosenSAT  is array(4 downto 0) of integer range 0 to 31;

begin
  -- data_b(31 downto 15) <= (others => '0');
  complete <= complete_in;
  chooseSAT : process( clk, reset )
  begin
    if reset = '1' then
      choose_cnt <= 0;
      save_cnt   <= 0;
      data_a     <= (others => '0');
      data_b     <= (others => '0');
      wren       <= '0';
      complete_in<= '0';
      address    <= (others => '0');
    elsif rising_edge(clk) then
      if update = '1' and complete_in = '0' then
        if choose_cnt = 31 then
          choose_cnt <= 0;
          complete_in<= '1';
        else
          choose_cnt <= choose_cnt + 1;
          complete_in<= '0';
        end if ;
        
        if detectedSAT(choose_cnt) = '1' then
          if save_cnt = 4 then
            save_cnt <= 0;
          else
            save_cnt <= save_cnt + 1;
          end if ;
          address <= conv_std_logic_vector(save_cnt, address'length);
          wren    <= '1';
          data_a  <= INCR_SAT(choose_cnt);

          data_b(9 downto 0)   <= phaseSAT(choose_cnt); -- Phase
          data_b(14 downto 10) <= conv_std_logic_vector(choose_cnt, 5); -- PRN
          data_b(15)           <= '1'; -- Valid
        else
          wren    <= '0';
        end if ;
      else
        choose_cnt <= 0;
        save_cnt   <= 0;
        data_a     <= (others => '0');
        data_b     <= (others => '0');
        wren       <= '0';
        complete_in<= '0';
      end if ;
    end if ;
  end process ; 
  
end arch ; -- arch