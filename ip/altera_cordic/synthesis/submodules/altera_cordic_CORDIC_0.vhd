-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 17.1 (Release Build #590)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2017 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from altera_cordic_CORDIC_0
-- VHDL created on Sun Feb 26 12:53:34 2023


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity altera_cordic_CORDIC_0 is
    port (
        a : in std_logic_vector(15 downto 0);  -- sfix16_en13
        en : in std_logic_vector(0 downto 0);  -- ufix1
        c : out std_logic_vector(12 downto 0);  -- sfix13_en11
        s : out std_logic_vector(12 downto 0);  -- sfix13_en11
        clk : in std_logic;
        areset : in std_logic
    );
end altera_cordic_CORDIC_0;

architecture normal of altera_cordic_CORDIC_0 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal constantZero_uid6_sincosTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal signA_uid7_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal invSignA_uid8_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal absAE_uid9_sincosTest_a : STD_LOGIC_VECTOR (17 downto 0);
    signal absAE_uid9_sincosTest_b : STD_LOGIC_VECTOR (17 downto 0);
    signal absAE_uid9_sincosTest_o : STD_LOGIC_VECTOR (17 downto 0);
    signal absAE_uid9_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal absAE_uid9_sincosTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal absAR_uid10_sincosTest_in : STD_LOGIC_VECTOR (14 downto 0);
    signal absAR_uid10_sincosTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal cstPiO2_uid11_sincosTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal padACst_uid12_sincosTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal aPostPad_uid13_sincosTest_q : STD_LOGIC_VECTOR (17 downto 0);
    signal argMPiO2_uid14_sincosTest_a : STD_LOGIC_VECTOR (18 downto 0);
    signal argMPiO2_uid14_sincosTest_b : STD_LOGIC_VECTOR (18 downto 0);
    signal argMPiO2_uid14_sincosTest_o : STD_LOGIC_VECTOR (18 downto 0);
    signal argMPiO2_uid14_sincosTest_q : STD_LOGIC_VECTOR (18 downto 0);
    signal firstQuadrant_uid15_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal absARE_bottomRange_uid17_sincosTest_in : STD_LOGIC_VECTOR (13 downto 0);
    signal absARE_bottomRange_uid17_sincosTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal absARE_mergedSignalTM_uid18_sincosTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal argMPiO2_uid20_sincosTest_in : STD_LOGIC_VECTOR (16 downto 0);
    signal argMPiO2_uid20_sincosTest_b : STD_LOGIC_VECTOR (16 downto 0);
    signal absA_uid21_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal absA_uid21_sincosTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal cstOneOverK_uid22_sincosTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal cstArcTan2Mi_0_uid26_sincosTest_q : STD_LOGIC_VECTOR (21 downto 0);
    signal xip1E_1_uid32_sincosTest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1E_1CostZeroPaddingA_uid33_sincosTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal yip1E_1NA_uid34_sincosTest_q : STD_LOGIC_VECTOR (28 downto 0);
    signal yip1E_1sumAHighB_uid35_sincosTest_a : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1E_1sumAHighB_uid35_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1E_1sumAHighB_uid35_sincosTest_o : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1E_1sumAHighB_uid35_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_1sumAHighB_uid35_sincosTest_q : STD_LOGIC_VECTOR (29 downto 0);
    signal invSignOfSelectionSignal_uid36_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_1CostZeroPaddingA_uid37_sincosTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal aip1E_1NA_uid38_sincosTest_q : STD_LOGIC_VECTOR (21 downto 0);
    signal aip1E_1sumAHighB_uid39_sincosTest_a : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_1sumAHighB_uid39_sincosTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_1sumAHighB_uid39_sincosTest_o : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_1sumAHighB_uid39_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_1sumAHighB_uid39_sincosTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal xip1_1_topRange_uid41_sincosTest_in : STD_LOGIC_VECTOR (29 downto 0);
    signal xip1_1_topRange_uid41_sincosTest_b : STD_LOGIC_VECTOR (29 downto 0);
    signal xip1_1_mergedSignalTM_uid42_sincosTest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal xMSB_uid44_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1_1_mergedSignalTM_uid48_sincosTest_q : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid50_sincosTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal aip1E_uid50_sincosTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal xMSB_uid51_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid53_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid56_sincosTest_b : STD_LOGIC_VECTOR (29 downto 0);
    signal twoToMiSiYip_uid57_sincosTest_b : STD_LOGIC_VECTOR (29 downto 0);
    signal cstArcTan2Mi_1_uid58_sincosTest_q : STD_LOGIC_VECTOR (20 downto 0);
    signal xip1E_2_uid60_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_2_uid60_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_2_uid60_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_2_uid60_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_2_uid60_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_2_uid61_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_2_uid61_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_2_uid61_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_2_uid61_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_2_uid61_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal aip1E_2_uid63_sincosTest_a : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_2_uid63_sincosTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_2_uid63_sincosTest_o : STD_LOGIC_VECTOR (24 downto 0);
    signal aip1E_2_uid63_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_2_uid63_sincosTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal xip1_2_uid64_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_2_uid64_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_2_uid65_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_2_uid65_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid66_sincosTest_in : STD_LOGIC_VECTOR (21 downto 0);
    signal aip1E_uid66_sincosTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal xMSB_uid67_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid69_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid72_sincosTest_b : STD_LOGIC_VECTOR (28 downto 0);
    signal twoToMiSiYip_uid73_sincosTest_b : STD_LOGIC_VECTOR (28 downto 0);
    signal cstArcTan2Mi_2_uid74_sincosTest_q : STD_LOGIC_VECTOR (19 downto 0);
    signal xip1E_3_uid76_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_3_uid76_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_3_uid76_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_3_uid76_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_3_uid76_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_3_uid77_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_3_uid77_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_3_uid77_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_3_uid77_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_3_uid77_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal aip1E_3_uid79_sincosTest_a : STD_LOGIC_VECTOR (23 downto 0);
    signal aip1E_3_uid79_sincosTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal aip1E_3_uid79_sincosTest_o : STD_LOGIC_VECTOR (23 downto 0);
    signal aip1E_3_uid79_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_3_uid79_sincosTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal xip1_3_uid80_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_3_uid80_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_3_uid81_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_3_uid81_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid82_sincosTest_in : STD_LOGIC_VECTOR (20 downto 0);
    signal aip1E_uid82_sincosTest_b : STD_LOGIC_VECTOR (20 downto 0);
    signal xMSB_uid83_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid85_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid88_sincosTest_b : STD_LOGIC_VECTOR (27 downto 0);
    signal twoToMiSiYip_uid89_sincosTest_b : STD_LOGIC_VECTOR (27 downto 0);
    signal cstArcTan2Mi_3_uid90_sincosTest_q : STD_LOGIC_VECTOR (18 downto 0);
    signal xip1E_4_uid92_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_4_uid92_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_4_uid92_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_4_uid92_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_4_uid92_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_4_uid93_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_4_uid93_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_4_uid93_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_4_uid93_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_4_uid93_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal aip1E_4_uid95_sincosTest_a : STD_LOGIC_VECTOR (22 downto 0);
    signal aip1E_4_uid95_sincosTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal aip1E_4_uid95_sincosTest_o : STD_LOGIC_VECTOR (22 downto 0);
    signal aip1E_4_uid95_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_4_uid95_sincosTest_q : STD_LOGIC_VECTOR (21 downto 0);
    signal xip1_4_uid96_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_4_uid96_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_4_uid97_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_4_uid97_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid98_sincosTest_in : STD_LOGIC_VECTOR (19 downto 0);
    signal aip1E_uid98_sincosTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal xMSB_uid99_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid101_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid104_sincosTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal twoToMiSiYip_uid105_sincosTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal cstArcTan2Mi_4_uid106_sincosTest_q : STD_LOGIC_VECTOR (17 downto 0);
    signal xip1E_5_uid108_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_5_uid108_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_5_uid108_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_5_uid108_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_5_uid108_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_5_uid109_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_5_uid109_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_5_uid109_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_5_uid109_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_5_uid109_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal aip1E_5_uid111_sincosTest_a : STD_LOGIC_VECTOR (21 downto 0);
    signal aip1E_5_uid111_sincosTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal aip1E_5_uid111_sincosTest_o : STD_LOGIC_VECTOR (21 downto 0);
    signal aip1E_5_uid111_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_5_uid111_sincosTest_q : STD_LOGIC_VECTOR (20 downto 0);
    signal xip1_5_uid112_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_5_uid112_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_5_uid113_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_5_uid113_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid114_sincosTest_in : STD_LOGIC_VECTOR (18 downto 0);
    signal aip1E_uid114_sincosTest_b : STD_LOGIC_VECTOR (18 downto 0);
    signal xMSB_uid115_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid117_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid120_sincosTest_b : STD_LOGIC_VECTOR (25 downto 0);
    signal twoToMiSiYip_uid121_sincosTest_b : STD_LOGIC_VECTOR (25 downto 0);
    signal cstArcTan2Mi_5_uid122_sincosTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal xip1E_6_uid124_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_6_uid124_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_6_uid124_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_6_uid124_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_6_uid124_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_6_uid125_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_6_uid125_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_6_uid125_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_6_uid125_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_6_uid125_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal aip1E_6_uid127_sincosTest_a : STD_LOGIC_VECTOR (20 downto 0);
    signal aip1E_6_uid127_sincosTest_b : STD_LOGIC_VECTOR (20 downto 0);
    signal aip1E_6_uid127_sincosTest_o : STD_LOGIC_VECTOR (20 downto 0);
    signal aip1E_6_uid127_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_6_uid127_sincosTest_q : STD_LOGIC_VECTOR (19 downto 0);
    signal xip1_6_uid128_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_6_uid128_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_6_uid129_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_6_uid129_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid130_sincosTest_in : STD_LOGIC_VECTOR (17 downto 0);
    signal aip1E_uid130_sincosTest_b : STD_LOGIC_VECTOR (17 downto 0);
    signal xMSB_uid131_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid133_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid136_sincosTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal twoToMiSiYip_uid137_sincosTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal cstArcTan2Mi_6_uid138_sincosTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal xip1E_7_uid140_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_7_uid140_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_7_uid140_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_7_uid140_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_7_uid140_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_7_uid141_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_7_uid141_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_7_uid141_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_7_uid141_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_7_uid141_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal aip1E_7_uid143_sincosTest_a : STD_LOGIC_VECTOR (19 downto 0);
    signal aip1E_7_uid143_sincosTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal aip1E_7_uid143_sincosTest_o : STD_LOGIC_VECTOR (19 downto 0);
    signal aip1E_7_uid143_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_7_uid143_sincosTest_q : STD_LOGIC_VECTOR (18 downto 0);
    signal xip1_7_uid144_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_7_uid144_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_7_uid145_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_7_uid145_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid146_sincosTest_in : STD_LOGIC_VECTOR (16 downto 0);
    signal aip1E_uid146_sincosTest_b : STD_LOGIC_VECTOR (16 downto 0);
    signal xMSB_uid147_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid149_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid152_sincosTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal twoToMiSiYip_uid153_sincosTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal cstArcTan2Mi_7_uid154_sincosTest_q : STD_LOGIC_VECTOR (14 downto 0);
    signal xip1E_8_uid156_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_8_uid156_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_8_uid156_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_8_uid156_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_8_uid156_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_8_uid157_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_8_uid157_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_8_uid157_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_8_uid157_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_8_uid157_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal lowRangeA_uid159_sincosTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeA_uid159_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highABits_uid160_sincosTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal aip1E_8high_uid161_sincosTest_a : STD_LOGIC_VECTOR (17 downto 0);
    signal aip1E_8high_uid161_sincosTest_b : STD_LOGIC_VECTOR (17 downto 0);
    signal aip1E_8high_uid161_sincosTest_o : STD_LOGIC_VECTOR (17 downto 0);
    signal aip1E_8high_uid161_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_8high_uid161_sincosTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal aip1E_8_uid162_sincosTest_q : STD_LOGIC_VECTOR (17 downto 0);
    signal xip1_8_uid163_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_8_uid163_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_8_uid164_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_8_uid164_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid165_sincosTest_in : STD_LOGIC_VECTOR (15 downto 0);
    signal aip1E_uid165_sincosTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal xMSB_uid166_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid168_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid171_sincosTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal twoToMiSiYip_uid172_sincosTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal cstArcTan2Mi_8_uid173_sincosTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal xip1E_9_uid175_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_9_uid175_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_9_uid175_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_9_uid175_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_9_uid175_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_9_uid176_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_9_uid176_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_9_uid176_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_9_uid176_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_9_uid176_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal lowRangeA_uid178_sincosTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeA_uid178_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highABits_uid179_sincosTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal aip1E_9high_uid180_sincosTest_a : STD_LOGIC_VECTOR (16 downto 0);
    signal aip1E_9high_uid180_sincosTest_b : STD_LOGIC_VECTOR (16 downto 0);
    signal aip1E_9high_uid180_sincosTest_o : STD_LOGIC_VECTOR (16 downto 0);
    signal aip1E_9high_uid180_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_9high_uid180_sincosTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal aip1E_9_uid181_sincosTest_q : STD_LOGIC_VECTOR (16 downto 0);
    signal xip1_9_uid182_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_9_uid182_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_9_uid183_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_9_uid183_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid184_sincosTest_in : STD_LOGIC_VECTOR (14 downto 0);
    signal aip1E_uid184_sincosTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal xMSB_uid185_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid187_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid190_sincosTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal twoToMiSiYip_uid191_sincosTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal cstArcTan2Mi_9_uid192_sincosTest_q : STD_LOGIC_VECTOR (12 downto 0);
    signal xip1E_10_uid194_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_10_uid194_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_10_uid194_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_10_uid194_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_10_uid194_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_10_uid195_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_10_uid195_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_10_uid195_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_10_uid195_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_10_uid195_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal lowRangeA_uid197_sincosTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeA_uid197_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highABits_uid198_sincosTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal aip1E_10high_uid199_sincosTest_a : STD_LOGIC_VECTOR (15 downto 0);
    signal aip1E_10high_uid199_sincosTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal aip1E_10high_uid199_sincosTest_o : STD_LOGIC_VECTOR (15 downto 0);
    signal aip1E_10high_uid199_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_10high_uid199_sincosTest_q : STD_LOGIC_VECTOR (14 downto 0);
    signal aip1E_10_uid200_sincosTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal xip1_10_uid201_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_10_uid201_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_10_uid202_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_10_uid202_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid203_sincosTest_in : STD_LOGIC_VECTOR (13 downto 0);
    signal aip1E_uid203_sincosTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal xMSB_uid204_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid206_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid209_sincosTest_b : STD_LOGIC_VECTOR (20 downto 0);
    signal twoToMiSiYip_uid210_sincosTest_b : STD_LOGIC_VECTOR (20 downto 0);
    signal cstArcTan2Mi_10_uid211_sincosTest_q : STD_LOGIC_VECTOR (11 downto 0);
    signal xip1E_11_uid213_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_11_uid213_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_11_uid213_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_11_uid213_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_11_uid213_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_11_uid214_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_11_uid214_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_11_uid214_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_11_uid214_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_11_uid214_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal lowRangeA_uid216_sincosTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeA_uid216_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highABits_uid217_sincosTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal aip1E_11high_uid218_sincosTest_a : STD_LOGIC_VECTOR (14 downto 0);
    signal aip1E_11high_uid218_sincosTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal aip1E_11high_uid218_sincosTest_o : STD_LOGIC_VECTOR (14 downto 0);
    signal aip1E_11high_uid218_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_11high_uid218_sincosTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal aip1E_11_uid219_sincosTest_q : STD_LOGIC_VECTOR (14 downto 0);
    signal xip1_11_uid220_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_11_uid220_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_11_uid221_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_11_uid221_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid222_sincosTest_in : STD_LOGIC_VECTOR (12 downto 0);
    signal aip1E_uid222_sincosTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal xMSB_uid223_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid225_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid228_sincosTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal twoToMiSiYip_uid229_sincosTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal cstArcTan2Mi_11_uid230_sincosTest_q : STD_LOGIC_VECTOR (10 downto 0);
    signal xip1E_12_uid232_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_12_uid232_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_12_uid232_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_12_uid232_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_12_uid232_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_12_uid233_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_12_uid233_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_12_uid233_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_12_uid233_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_12_uid233_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal lowRangeA_uid235_sincosTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal lowRangeA_uid235_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal highABits_uid236_sincosTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal aip1E_12high_uid237_sincosTest_a : STD_LOGIC_VECTOR (13 downto 0);
    signal aip1E_12high_uid237_sincosTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal aip1E_12high_uid237_sincosTest_o : STD_LOGIC_VECTOR (13 downto 0);
    signal aip1E_12high_uid237_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aip1E_12high_uid237_sincosTest_q : STD_LOGIC_VECTOR (12 downto 0);
    signal aip1E_12_uid238_sincosTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal xip1_12_uid239_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_12_uid239_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_12_uid240_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_12_uid240_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal aip1E_uid241_sincosTest_in : STD_LOGIC_VECTOR (11 downto 0);
    signal aip1E_uid241_sincosTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal xMSB_uid242_sincosTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal signOfSelectionSignal_uid244_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal twoToMiSiXip_uid247_sincosTest_b : STD_LOGIC_VECTOR (18 downto 0);
    signal twoToMiSiYip_uid248_sincosTest_b : STD_LOGIC_VECTOR (18 downto 0);
    signal xip1E_13_uid251_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_13_uid251_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_13_uid251_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xip1E_13_uid251_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xip1E_13_uid251_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal yip1E_13_uid252_sincosTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_13_uid252_sincosTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_13_uid252_sincosTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal yip1E_13_uid252_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal yip1E_13_uid252_sincosTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal xip1_13_uid258_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal xip1_13_uid258_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_13_uid259_sincosTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal yip1_13_uid259_sincosTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal xSumPreRnd_uid261_sincosTest_in : STD_LOGIC_VECTOR (29 downto 0);
    signal xSumPreRnd_uid261_sincosTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal xSumPostRnd_uid264_sincosTest_a : STD_LOGIC_VECTOR (14 downto 0);
    signal xSumPostRnd_uid264_sincosTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal xSumPostRnd_uid264_sincosTest_o : STD_LOGIC_VECTOR (14 downto 0);
    signal xSumPostRnd_uid264_sincosTest_q : STD_LOGIC_VECTOR (14 downto 0);
    signal ySumPreRnd_uid265_sincosTest_in : STD_LOGIC_VECTOR (29 downto 0);
    signal ySumPreRnd_uid265_sincosTest_b : STD_LOGIC_VECTOR (13 downto 0);
    signal ySumPostRnd_uid268_sincosTest_a : STD_LOGIC_VECTOR (14 downto 0);
    signal ySumPostRnd_uid268_sincosTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal ySumPostRnd_uid268_sincosTest_o : STD_LOGIC_VECTOR (14 downto 0);
    signal ySumPostRnd_uid268_sincosTest_q : STD_LOGIC_VECTOR (14 downto 0);
    signal xPostExc_uid269_sincosTest_in : STD_LOGIC_VECTOR (13 downto 0);
    signal xPostExc_uid269_sincosTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal yPostExc_uid270_sincosTest_in : STD_LOGIC_VECTOR (13 downto 0);
    signal yPostExc_uid270_sincosTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal invFirstQuadrant_uid271_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sinNegCond2_uid272_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sinNegCond1_uid273_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sinNegCond0_uid275_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sinNegCond_uid276_sincosTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal sinNegCond_uid276_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cstZeroForAddSub_uid278_sincosTest_q : STD_LOGIC_VECTOR (12 downto 0);
    signal invSinNegCond_uid279_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sinPostNeg_uid280_sincosTest_a : STD_LOGIC_VECTOR (14 downto 0);
    signal sinPostNeg_uid280_sincosTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal sinPostNeg_uid280_sincosTest_o : STD_LOGIC_VECTOR (14 downto 0);
    signal sinPostNeg_uid280_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal sinPostNeg_uid280_sincosTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal invCosNegCond_uid281_sincosTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal invCosNegCond_uid281_sincosTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cosPostNeg_uid282_sincosTest_a : STD_LOGIC_VECTOR (14 downto 0);
    signal cosPostNeg_uid282_sincosTest_b : STD_LOGIC_VECTOR (14 downto 0);
    signal cosPostNeg_uid282_sincosTest_o : STD_LOGIC_VECTOR (14 downto 0);
    signal cosPostNeg_uid282_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal cosPostNeg_uid282_sincosTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal xPostRR_uid283_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xPostRR_uid283_sincosTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal xPostRR_uid284_sincosTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal xPostRR_uid284_sincosTest_q : STD_LOGIC_VECTOR (13 downto 0);
    signal cos_uid285_sincosTest_in : STD_LOGIC_VECTOR (12 downto 0);
    signal cos_uid285_sincosTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal sin_uid286_sincosTest_in : STD_LOGIC_VECTOR (12 downto 0);
    signal sin_uid286_sincosTest_b : STD_LOGIC_VECTOR (12 downto 0);
    signal redist0_invCosNegCond_uid281_sincosTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist1_sinNegCond_uid276_sincosTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist2_xMSB_uid242_sincosTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_xMSB_uid223_sincosTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist4_xMSB_uid204_sincosTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_xMSB_uid185_sincosTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist6_xMSB_uid166_sincosTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist7_yip1_8_uid164_sincosTest_b_1_q : STD_LOGIC_VECTOR (30 downto 0);
    signal redist8_xip1_8_uid163_sincosTest_b_1_q : STD_LOGIC_VECTOR (30 downto 0);
    signal redist9_aip1E_uid114_sincosTest_b_1_q : STD_LOGIC_VECTOR (18 downto 0);
    signal redist10_xMSB_uid99_sincosTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist11_xMSB_uid83_sincosTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist12_xMSB_uid67_sincosTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist13_xMSB_uid51_sincosTest_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist14_firstQuadrant_uid15_sincosTest_b_2_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- cstPiO2_uid11_sincosTest(CONSTANT,10)
    cstPiO2_uid11_sincosTest_q <= "11001001000100000";

    -- invSignA_uid8_sincosTest(LOGICAL,7)@0
    invSignA_uid8_sincosTest_q <= not (signA_uid7_sincosTest_b);

    -- constantZero_uid6_sincosTest(CONSTANT,5)
    constantZero_uid6_sincosTest_q <= "0000000000000000";

    -- absAE_uid9_sincosTest(ADDSUB,8)@0
    absAE_uid9_sincosTest_s <= invSignA_uid8_sincosTest_q;
    absAE_uid9_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 16 => constantZero_uid6_sincosTest_q(15)) & constantZero_uid6_sincosTest_q));
    absAE_uid9_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 16 => a(15)) & a));
    absAE_uid9_sincosTest_combproc: PROCESS (absAE_uid9_sincosTest_a, absAE_uid9_sincosTest_b, absAE_uid9_sincosTest_s)
    BEGIN
        IF (absAE_uid9_sincosTest_s = "1") THEN
            absAE_uid9_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(absAE_uid9_sincosTest_a) + SIGNED(absAE_uid9_sincosTest_b));
        ELSE
            absAE_uid9_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(absAE_uid9_sincosTest_a) - SIGNED(absAE_uid9_sincosTest_b));
        END IF;
    END PROCESS;
    absAE_uid9_sincosTest_q <= absAE_uid9_sincosTest_o(16 downto 0);

    -- absAR_uid10_sincosTest(BITSELECT,9)@0
    absAR_uid10_sincosTest_in <= absAE_uid9_sincosTest_q(14 downto 0);
    absAR_uid10_sincosTest_b <= absAR_uid10_sincosTest_in(14 downto 0);

    -- padACst_uid12_sincosTest(CONSTANT,11)
    padACst_uid12_sincosTest_q <= "000";

    -- aPostPad_uid13_sincosTest(BITJOIN,12)@0
    aPostPad_uid13_sincosTest_q <= absAR_uid10_sincosTest_b & padACst_uid12_sincosTest_q;

    -- argMPiO2_uid14_sincosTest(SUB,13)@0
    argMPiO2_uid14_sincosTest_a <= STD_LOGIC_VECTOR("0" & aPostPad_uid13_sincosTest_q);
    argMPiO2_uid14_sincosTest_b <= STD_LOGIC_VECTOR("00" & cstPiO2_uid11_sincosTest_q);
    argMPiO2_uid14_sincosTest_o <= STD_LOGIC_VECTOR(UNSIGNED(argMPiO2_uid14_sincosTest_a) - UNSIGNED(argMPiO2_uid14_sincosTest_b));
    argMPiO2_uid14_sincosTest_q <= argMPiO2_uid14_sincosTest_o(18 downto 0);

    -- firstQuadrant_uid15_sincosTest(BITSELECT,14)@0
    firstQuadrant_uid15_sincosTest_b <= STD_LOGIC_VECTOR(argMPiO2_uid14_sincosTest_q(18 downto 18));

    -- invFirstQuadrant_uid271_sincosTest(LOGICAL,270)@0
    invFirstQuadrant_uid271_sincosTest_q <= not (firstQuadrant_uid15_sincosTest_b);

    -- signA_uid7_sincosTest(BITSELECT,6)@0
    signA_uid7_sincosTest_b <= STD_LOGIC_VECTOR(a(15 downto 15));

    -- sinNegCond2_uid272_sincosTest(LOGICAL,271)@0
    sinNegCond2_uid272_sincosTest_q <= signA_uid7_sincosTest_b and invFirstQuadrant_uid271_sincosTest_q;

    -- sinNegCond1_uid273_sincosTest(LOGICAL,272)@0
    sinNegCond1_uid273_sincosTest_q <= signA_uid7_sincosTest_b and firstQuadrant_uid15_sincosTest_b;

    -- sinNegCond0_uid275_sincosTest(LOGICAL,274)@0
    sinNegCond0_uid275_sincosTest_q <= invSignA_uid8_sincosTest_q and invFirstQuadrant_uid271_sincosTest_q;

    -- sinNegCond_uid276_sincosTest(LOGICAL,275)@0 + 1
    sinNegCond_uid276_sincosTest_qi <= sinNegCond0_uid275_sincosTest_q or sinNegCond1_uid273_sincosTest_q or sinNegCond2_uid272_sincosTest_q;
    sinNegCond_uid276_sincosTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => sinNegCond_uid276_sincosTest_qi, xout => sinNegCond_uid276_sincosTest_q, ena => en(0), clk => clk, aclr => areset );

    -- redist1_sinNegCond_uid276_sincosTest_q_2(DELAY,287)
    redist1_sinNegCond_uid276_sincosTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => sinNegCond_uid276_sincosTest_q, xout => redist1_sinNegCond_uid276_sincosTest_q_2_q, ena => en(0), clk => clk, aclr => areset );

    -- invSinNegCond_uid279_sincosTest(LOGICAL,278)@2
    invSinNegCond_uid279_sincosTest_q <= not (redist1_sinNegCond_uid276_sincosTest_q_2_q);

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- xMSB_uid131_sincosTest(BITSELECT,130)@1
    xMSB_uid131_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid130_sincosTest_b(17 downto 17));

    -- cstArcTan2Mi_6_uid138_sincosTest(CONSTANT,137)
    cstArcTan2Mi_6_uid138_sincosTest_q <= "0111111111111101";

    -- xMSB_uid115_sincosTest(BITSELECT,114)@1
    xMSB_uid115_sincosTest_b <= STD_LOGIC_VECTOR(redist9_aip1E_uid114_sincosTest_b_1_q(18 downto 18));

    -- cstArcTan2Mi_5_uid122_sincosTest(CONSTANT,121)
    cstArcTan2Mi_5_uid122_sincosTest_q <= "01111111111101011";

    -- xMSB_uid99_sincosTest(BITSELECT,98)@0
    xMSB_uid99_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid98_sincosTest_b(19 downto 19));

    -- cstArcTan2Mi_4_uid106_sincosTest(CONSTANT,105)
    cstArcTan2Mi_4_uid106_sincosTest_q <= "011111111101010110";

    -- xMSB_uid83_sincosTest(BITSELECT,82)@0
    xMSB_uid83_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid82_sincosTest_b(20 downto 20));

    -- cstArcTan2Mi_3_uid90_sincosTest(CONSTANT,89)
    cstArcTan2Mi_3_uid90_sincosTest_q <= "0111111101010110111";

    -- xMSB_uid67_sincosTest(BITSELECT,66)@0
    xMSB_uid67_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid66_sincosTest_b(21 downto 21));

    -- cstArcTan2Mi_2_uid74_sincosTest(CONSTANT,73)
    cstArcTan2Mi_2_uid74_sincosTest_q <= "01111101011011011101";

    -- xMSB_uid51_sincosTest(BITSELECT,50)@0
    xMSB_uid51_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid50_sincosTest_b(22 downto 22));

    -- cstArcTan2Mi_1_uid58_sincosTest(CONSTANT,57)
    cstArcTan2Mi_1_uid58_sincosTest_q <= "011101101011000110100";

    -- invSignOfSelectionSignal_uid36_sincosTest(LOGICAL,35)@0
    invSignOfSelectionSignal_uid36_sincosTest_q <= not (VCC_q);

    -- cstArcTan2Mi_0_uid26_sincosTest(CONSTANT,25)
    cstArcTan2Mi_0_uid26_sincosTest_q <= "0110010010000111111011";

    -- absARE_bottomRange_uid17_sincosTest(BITSELECT,16)@0
    absARE_bottomRange_uid17_sincosTest_in <= absAR_uid10_sincosTest_b(13 downto 0);
    absARE_bottomRange_uid17_sincosTest_b <= absARE_bottomRange_uid17_sincosTest_in(13 downto 0);

    -- absARE_mergedSignalTM_uid18_sincosTest(BITJOIN,17)@0
    absARE_mergedSignalTM_uid18_sincosTest_q <= absARE_bottomRange_uid17_sincosTest_b & padACst_uid12_sincosTest_q;

    -- argMPiO2_uid20_sincosTest(BITSELECT,19)@0
    argMPiO2_uid20_sincosTest_in <= argMPiO2_uid14_sincosTest_q(16 downto 0);
    argMPiO2_uid20_sincosTest_b <= argMPiO2_uid20_sincosTest_in(16 downto 0);

    -- absA_uid21_sincosTest(MUX,20)@0
    absA_uid21_sincosTest_s <= firstQuadrant_uid15_sincosTest_b;
    absA_uid21_sincosTest_combproc: PROCESS (absA_uid21_sincosTest_s, en, argMPiO2_uid20_sincosTest_b, absARE_mergedSignalTM_uid18_sincosTest_q)
    BEGIN
        CASE (absA_uid21_sincosTest_s) IS
            WHEN "0" => absA_uid21_sincosTest_q <= argMPiO2_uid20_sincosTest_b;
            WHEN "1" => absA_uid21_sincosTest_q <= absARE_mergedSignalTM_uid18_sincosTest_q;
            WHEN OTHERS => absA_uid21_sincosTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- aip1E_1CostZeroPaddingA_uid37_sincosTest(CONSTANT,36)
    aip1E_1CostZeroPaddingA_uid37_sincosTest_q <= "00000";

    -- aip1E_1NA_uid38_sincosTest(BITJOIN,37)@0
    aip1E_1NA_uid38_sincosTest_q <= absA_uid21_sincosTest_q & aip1E_1CostZeroPaddingA_uid37_sincosTest_q;

    -- aip1E_1sumAHighB_uid39_sincosTest(ADDSUB,38)@0
    aip1E_1sumAHighB_uid39_sincosTest_s <= invSignOfSelectionSignal_uid36_sincosTest_q;
    aip1E_1sumAHighB_uid39_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("000" & aip1E_1NA_uid38_sincosTest_q));
    aip1E_1sumAHighB_uid39_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 22 => cstArcTan2Mi_0_uid26_sincosTest_q(21)) & cstArcTan2Mi_0_uid26_sincosTest_q));
    aip1E_1sumAHighB_uid39_sincosTest_combproc: PROCESS (aip1E_1sumAHighB_uid39_sincosTest_a, aip1E_1sumAHighB_uid39_sincosTest_b, aip1E_1sumAHighB_uid39_sincosTest_s)
    BEGIN
        IF (aip1E_1sumAHighB_uid39_sincosTest_s = "1") THEN
            aip1E_1sumAHighB_uid39_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_1sumAHighB_uid39_sincosTest_a) + SIGNED(aip1E_1sumAHighB_uid39_sincosTest_b));
        ELSE
            aip1E_1sumAHighB_uid39_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_1sumAHighB_uid39_sincosTest_a) - SIGNED(aip1E_1sumAHighB_uid39_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_1sumAHighB_uid39_sincosTest_q <= aip1E_1sumAHighB_uid39_sincosTest_o(23 downto 0);

    -- aip1E_uid50_sincosTest(BITSELECT,49)@0
    aip1E_uid50_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_1sumAHighB_uid39_sincosTest_q(22 downto 0));
    aip1E_uid50_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid50_sincosTest_in(22 downto 0));

    -- aip1E_2_uid63_sincosTest(ADDSUB,62)@0
    aip1E_2_uid63_sincosTest_s <= xMSB_uid51_sincosTest_b;
    aip1E_2_uid63_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 23 => aip1E_uid50_sincosTest_b(22)) & aip1E_uid50_sincosTest_b));
    aip1E_2_uid63_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 21 => cstArcTan2Mi_1_uid58_sincosTest_q(20)) & cstArcTan2Mi_1_uid58_sincosTest_q));
    aip1E_2_uid63_sincosTest_combproc: PROCESS (aip1E_2_uid63_sincosTest_a, aip1E_2_uid63_sincosTest_b, aip1E_2_uid63_sincosTest_s)
    BEGIN
        IF (aip1E_2_uid63_sincosTest_s = "1") THEN
            aip1E_2_uid63_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_2_uid63_sincosTest_a) + SIGNED(aip1E_2_uid63_sincosTest_b));
        ELSE
            aip1E_2_uid63_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_2_uid63_sincosTest_a) - SIGNED(aip1E_2_uid63_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_2_uid63_sincosTest_q <= aip1E_2_uid63_sincosTest_o(23 downto 0);

    -- aip1E_uid66_sincosTest(BITSELECT,65)@0
    aip1E_uid66_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_2_uid63_sincosTest_q(21 downto 0));
    aip1E_uid66_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid66_sincosTest_in(21 downto 0));

    -- aip1E_3_uid79_sincosTest(ADDSUB,78)@0
    aip1E_3_uid79_sincosTest_s <= xMSB_uid67_sincosTest_b;
    aip1E_3_uid79_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 22 => aip1E_uid66_sincosTest_b(21)) & aip1E_uid66_sincosTest_b));
    aip1E_3_uid79_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 20 => cstArcTan2Mi_2_uid74_sincosTest_q(19)) & cstArcTan2Mi_2_uid74_sincosTest_q));
    aip1E_3_uid79_sincosTest_combproc: PROCESS (aip1E_3_uid79_sincosTest_a, aip1E_3_uid79_sincosTest_b, aip1E_3_uid79_sincosTest_s)
    BEGIN
        IF (aip1E_3_uid79_sincosTest_s = "1") THEN
            aip1E_3_uid79_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_3_uid79_sincosTest_a) + SIGNED(aip1E_3_uid79_sincosTest_b));
        ELSE
            aip1E_3_uid79_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_3_uid79_sincosTest_a) - SIGNED(aip1E_3_uid79_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_3_uid79_sincosTest_q <= aip1E_3_uid79_sincosTest_o(22 downto 0);

    -- aip1E_uid82_sincosTest(BITSELECT,81)@0
    aip1E_uid82_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_3_uid79_sincosTest_q(20 downto 0));
    aip1E_uid82_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid82_sincosTest_in(20 downto 0));

    -- aip1E_4_uid95_sincosTest(ADDSUB,94)@0
    aip1E_4_uid95_sincosTest_s <= xMSB_uid83_sincosTest_b;
    aip1E_4_uid95_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 21 => aip1E_uid82_sincosTest_b(20)) & aip1E_uid82_sincosTest_b));
    aip1E_4_uid95_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 19 => cstArcTan2Mi_3_uid90_sincosTest_q(18)) & cstArcTan2Mi_3_uid90_sincosTest_q));
    aip1E_4_uid95_sincosTest_combproc: PROCESS (aip1E_4_uid95_sincosTest_a, aip1E_4_uid95_sincosTest_b, aip1E_4_uid95_sincosTest_s)
    BEGIN
        IF (aip1E_4_uid95_sincosTest_s = "1") THEN
            aip1E_4_uid95_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_4_uid95_sincosTest_a) + SIGNED(aip1E_4_uid95_sincosTest_b));
        ELSE
            aip1E_4_uid95_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_4_uid95_sincosTest_a) - SIGNED(aip1E_4_uid95_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_4_uid95_sincosTest_q <= aip1E_4_uid95_sincosTest_o(21 downto 0);

    -- aip1E_uid98_sincosTest(BITSELECT,97)@0
    aip1E_uid98_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_4_uid95_sincosTest_q(19 downto 0));
    aip1E_uid98_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid98_sincosTest_in(19 downto 0));

    -- aip1E_5_uid111_sincosTest(ADDSUB,110)@0
    aip1E_5_uid111_sincosTest_s <= xMSB_uid99_sincosTest_b;
    aip1E_5_uid111_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 20 => aip1E_uid98_sincosTest_b(19)) & aip1E_uid98_sincosTest_b));
    aip1E_5_uid111_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((21 downto 18 => cstArcTan2Mi_4_uid106_sincosTest_q(17)) & cstArcTan2Mi_4_uid106_sincosTest_q));
    aip1E_5_uid111_sincosTest_combproc: PROCESS (aip1E_5_uid111_sincosTest_a, aip1E_5_uid111_sincosTest_b, aip1E_5_uid111_sincosTest_s)
    BEGIN
        IF (aip1E_5_uid111_sincosTest_s = "1") THEN
            aip1E_5_uid111_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_5_uid111_sincosTest_a) + SIGNED(aip1E_5_uid111_sincosTest_b));
        ELSE
            aip1E_5_uid111_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_5_uid111_sincosTest_a) - SIGNED(aip1E_5_uid111_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_5_uid111_sincosTest_q <= aip1E_5_uid111_sincosTest_o(20 downto 0);

    -- aip1E_uid114_sincosTest(BITSELECT,113)@0
    aip1E_uid114_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_5_uid111_sincosTest_q(18 downto 0));
    aip1E_uid114_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid114_sincosTest_in(18 downto 0));

    -- redist9_aip1E_uid114_sincosTest_b_1(DELAY,295)
    redist9_aip1E_uid114_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 19, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aip1E_uid114_sincosTest_b, xout => redist9_aip1E_uid114_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- aip1E_6_uid127_sincosTest(ADDSUB,126)@1
    aip1E_6_uid127_sincosTest_s <= xMSB_uid115_sincosTest_b;
    aip1E_6_uid127_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 19 => redist9_aip1E_uid114_sincosTest_b_1_q(18)) & redist9_aip1E_uid114_sincosTest_b_1_q));
    aip1E_6_uid127_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 17 => cstArcTan2Mi_5_uid122_sincosTest_q(16)) & cstArcTan2Mi_5_uid122_sincosTest_q));
    aip1E_6_uid127_sincosTest_combproc: PROCESS (aip1E_6_uid127_sincosTest_a, aip1E_6_uid127_sincosTest_b, aip1E_6_uid127_sincosTest_s)
    BEGIN
        IF (aip1E_6_uid127_sincosTest_s = "1") THEN
            aip1E_6_uid127_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_6_uid127_sincosTest_a) + SIGNED(aip1E_6_uid127_sincosTest_b));
        ELSE
            aip1E_6_uid127_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_6_uid127_sincosTest_a) - SIGNED(aip1E_6_uid127_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_6_uid127_sincosTest_q <= aip1E_6_uid127_sincosTest_o(19 downto 0);

    -- aip1E_uid130_sincosTest(BITSELECT,129)@1
    aip1E_uid130_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_6_uid127_sincosTest_q(17 downto 0));
    aip1E_uid130_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid130_sincosTest_in(17 downto 0));

    -- aip1E_7_uid143_sincosTest(ADDSUB,142)@1
    aip1E_7_uid143_sincosTest_s <= xMSB_uid131_sincosTest_b;
    aip1E_7_uid143_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 18 => aip1E_uid130_sincosTest_b(17)) & aip1E_uid130_sincosTest_b));
    aip1E_7_uid143_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 16 => cstArcTan2Mi_6_uid138_sincosTest_q(15)) & cstArcTan2Mi_6_uid138_sincosTest_q));
    aip1E_7_uid143_sincosTest_combproc: PROCESS (aip1E_7_uid143_sincosTest_a, aip1E_7_uid143_sincosTest_b, aip1E_7_uid143_sincosTest_s)
    BEGIN
        IF (aip1E_7_uid143_sincosTest_s = "1") THEN
            aip1E_7_uid143_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_7_uid143_sincosTest_a) + SIGNED(aip1E_7_uid143_sincosTest_b));
        ELSE
            aip1E_7_uid143_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_7_uid143_sincosTest_a) - SIGNED(aip1E_7_uid143_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_7_uid143_sincosTest_q <= aip1E_7_uid143_sincosTest_o(18 downto 0);

    -- aip1E_uid146_sincosTest(BITSELECT,145)@1
    aip1E_uid146_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_7_uid143_sincosTest_q(16 downto 0));
    aip1E_uid146_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid146_sincosTest_in(16 downto 0));

    -- xMSB_uid147_sincosTest(BITSELECT,146)@1
    xMSB_uid147_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid146_sincosTest_b(16 downto 16));

    -- cstArcTan2Mi_7_uid154_sincosTest(CONSTANT,153)
    cstArcTan2Mi_7_uid154_sincosTest_q <= "010000000000000";

    -- highABits_uid160_sincosTest(BITSELECT,159)@1
    highABits_uid160_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid146_sincosTest_b(16 downto 1));

    -- aip1E_8high_uid161_sincosTest(ADDSUB,160)@1
    aip1E_8high_uid161_sincosTest_s <= xMSB_uid147_sincosTest_b;
    aip1E_8high_uid161_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 16 => highABits_uid160_sincosTest_b(15)) & highABits_uid160_sincosTest_b));
    aip1E_8high_uid161_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 15 => cstArcTan2Mi_7_uid154_sincosTest_q(14)) & cstArcTan2Mi_7_uid154_sincosTest_q));
    aip1E_8high_uid161_sincosTest_combproc: PROCESS (aip1E_8high_uid161_sincosTest_a, aip1E_8high_uid161_sincosTest_b, aip1E_8high_uid161_sincosTest_s)
    BEGIN
        IF (aip1E_8high_uid161_sincosTest_s = "1") THEN
            aip1E_8high_uid161_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_8high_uid161_sincosTest_a) + SIGNED(aip1E_8high_uid161_sincosTest_b));
        ELSE
            aip1E_8high_uid161_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_8high_uid161_sincosTest_a) - SIGNED(aip1E_8high_uid161_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_8high_uid161_sincosTest_q <= aip1E_8high_uid161_sincosTest_o(16 downto 0);

    -- lowRangeA_uid159_sincosTest(BITSELECT,158)@1
    lowRangeA_uid159_sincosTest_in <= aip1E_uid146_sincosTest_b(0 downto 0);
    lowRangeA_uid159_sincosTest_b <= lowRangeA_uid159_sincosTest_in(0 downto 0);

    -- aip1E_8_uid162_sincosTest(BITJOIN,161)@1
    aip1E_8_uid162_sincosTest_q <= aip1E_8high_uid161_sincosTest_q & lowRangeA_uid159_sincosTest_b;

    -- aip1E_uid165_sincosTest(BITSELECT,164)@1
    aip1E_uid165_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_8_uid162_sincosTest_q(15 downto 0));
    aip1E_uid165_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid165_sincosTest_in(15 downto 0));

    -- xMSB_uid166_sincosTest(BITSELECT,165)@1
    xMSB_uid166_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid165_sincosTest_b(15 downto 15));

    -- cstArcTan2Mi_8_uid173_sincosTest(CONSTANT,172)
    cstArcTan2Mi_8_uid173_sincosTest_q <= "01000000000000";

    -- highABits_uid179_sincosTest(BITSELECT,178)@1
    highABits_uid179_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid165_sincosTest_b(15 downto 1));

    -- aip1E_9high_uid180_sincosTest(ADDSUB,179)@1
    aip1E_9high_uid180_sincosTest_s <= xMSB_uid166_sincosTest_b;
    aip1E_9high_uid180_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 15 => highABits_uid179_sincosTest_b(14)) & highABits_uid179_sincosTest_b));
    aip1E_9high_uid180_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => cstArcTan2Mi_8_uid173_sincosTest_q(13)) & cstArcTan2Mi_8_uid173_sincosTest_q));
    aip1E_9high_uid180_sincosTest_combproc: PROCESS (aip1E_9high_uid180_sincosTest_a, aip1E_9high_uid180_sincosTest_b, aip1E_9high_uid180_sincosTest_s)
    BEGIN
        IF (aip1E_9high_uid180_sincosTest_s = "1") THEN
            aip1E_9high_uid180_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_9high_uid180_sincosTest_a) + SIGNED(aip1E_9high_uid180_sincosTest_b));
        ELSE
            aip1E_9high_uid180_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_9high_uid180_sincosTest_a) - SIGNED(aip1E_9high_uid180_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_9high_uid180_sincosTest_q <= aip1E_9high_uid180_sincosTest_o(15 downto 0);

    -- lowRangeA_uid178_sincosTest(BITSELECT,177)@1
    lowRangeA_uid178_sincosTest_in <= aip1E_uid165_sincosTest_b(0 downto 0);
    lowRangeA_uid178_sincosTest_b <= lowRangeA_uid178_sincosTest_in(0 downto 0);

    -- aip1E_9_uid181_sincosTest(BITJOIN,180)@1
    aip1E_9_uid181_sincosTest_q <= aip1E_9high_uid180_sincosTest_q & lowRangeA_uid178_sincosTest_b;

    -- aip1E_uid184_sincosTest(BITSELECT,183)@1
    aip1E_uid184_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_9_uid181_sincosTest_q(14 downto 0));
    aip1E_uid184_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid184_sincosTest_in(14 downto 0));

    -- xMSB_uid185_sincosTest(BITSELECT,184)@1
    xMSB_uid185_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid184_sincosTest_b(14 downto 14));

    -- cstArcTan2Mi_9_uid192_sincosTest(CONSTANT,191)
    cstArcTan2Mi_9_uid192_sincosTest_q <= "0100000000000";

    -- highABits_uid198_sincosTest(BITSELECT,197)@1
    highABits_uid198_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid184_sincosTest_b(14 downto 1));

    -- aip1E_10high_uid199_sincosTest(ADDSUB,198)@1
    aip1E_10high_uid199_sincosTest_s <= xMSB_uid185_sincosTest_b;
    aip1E_10high_uid199_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 14 => highABits_uid198_sincosTest_b(13)) & highABits_uid198_sincosTest_b));
    aip1E_10high_uid199_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 13 => cstArcTan2Mi_9_uid192_sincosTest_q(12)) & cstArcTan2Mi_9_uid192_sincosTest_q));
    aip1E_10high_uid199_sincosTest_combproc: PROCESS (aip1E_10high_uid199_sincosTest_a, aip1E_10high_uid199_sincosTest_b, aip1E_10high_uid199_sincosTest_s)
    BEGIN
        IF (aip1E_10high_uid199_sincosTest_s = "1") THEN
            aip1E_10high_uid199_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_10high_uid199_sincosTest_a) + SIGNED(aip1E_10high_uid199_sincosTest_b));
        ELSE
            aip1E_10high_uid199_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_10high_uid199_sincosTest_a) - SIGNED(aip1E_10high_uid199_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_10high_uid199_sincosTest_q <= aip1E_10high_uid199_sincosTest_o(14 downto 0);

    -- lowRangeA_uid197_sincosTest(BITSELECT,196)@1
    lowRangeA_uid197_sincosTest_in <= aip1E_uid184_sincosTest_b(0 downto 0);
    lowRangeA_uid197_sincosTest_b <= lowRangeA_uid197_sincosTest_in(0 downto 0);

    -- aip1E_10_uid200_sincosTest(BITJOIN,199)@1
    aip1E_10_uid200_sincosTest_q <= aip1E_10high_uid199_sincosTest_q & lowRangeA_uid197_sincosTest_b;

    -- aip1E_uid203_sincosTest(BITSELECT,202)@1
    aip1E_uid203_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_10_uid200_sincosTest_q(13 downto 0));
    aip1E_uid203_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid203_sincosTest_in(13 downto 0));

    -- xMSB_uid204_sincosTest(BITSELECT,203)@1
    xMSB_uid204_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid203_sincosTest_b(13 downto 13));

    -- cstArcTan2Mi_10_uid211_sincosTest(CONSTANT,210)
    cstArcTan2Mi_10_uid211_sincosTest_q <= "010000000000";

    -- highABits_uid217_sincosTest(BITSELECT,216)@1
    highABits_uid217_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid203_sincosTest_b(13 downto 1));

    -- aip1E_11high_uid218_sincosTest(ADDSUB,217)@1
    aip1E_11high_uid218_sincosTest_s <= xMSB_uid204_sincosTest_b;
    aip1E_11high_uid218_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((14 downto 13 => highABits_uid217_sincosTest_b(12)) & highABits_uid217_sincosTest_b));
    aip1E_11high_uid218_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((14 downto 12 => cstArcTan2Mi_10_uid211_sincosTest_q(11)) & cstArcTan2Mi_10_uid211_sincosTest_q));
    aip1E_11high_uid218_sincosTest_combproc: PROCESS (aip1E_11high_uid218_sincosTest_a, aip1E_11high_uid218_sincosTest_b, aip1E_11high_uid218_sincosTest_s)
    BEGIN
        IF (aip1E_11high_uid218_sincosTest_s = "1") THEN
            aip1E_11high_uid218_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_11high_uid218_sincosTest_a) + SIGNED(aip1E_11high_uid218_sincosTest_b));
        ELSE
            aip1E_11high_uid218_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_11high_uid218_sincosTest_a) - SIGNED(aip1E_11high_uid218_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_11high_uid218_sincosTest_q <= aip1E_11high_uid218_sincosTest_o(13 downto 0);

    -- lowRangeA_uid216_sincosTest(BITSELECT,215)@1
    lowRangeA_uid216_sincosTest_in <= aip1E_uid203_sincosTest_b(0 downto 0);
    lowRangeA_uid216_sincosTest_b <= lowRangeA_uid216_sincosTest_in(0 downto 0);

    -- aip1E_11_uid219_sincosTest(BITJOIN,218)@1
    aip1E_11_uid219_sincosTest_q <= aip1E_11high_uid218_sincosTest_q & lowRangeA_uid216_sincosTest_b;

    -- aip1E_uid222_sincosTest(BITSELECT,221)@1
    aip1E_uid222_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_11_uid219_sincosTest_q(12 downto 0));
    aip1E_uid222_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid222_sincosTest_in(12 downto 0));

    -- xMSB_uid223_sincosTest(BITSELECT,222)@1
    xMSB_uid223_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid222_sincosTest_b(12 downto 12));

    -- cstArcTan2Mi_11_uid230_sincosTest(CONSTANT,229)
    cstArcTan2Mi_11_uid230_sincosTest_q <= "01000000000";

    -- highABits_uid236_sincosTest(BITSELECT,235)@1
    highABits_uid236_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid222_sincosTest_b(12 downto 1));

    -- aip1E_12high_uid237_sincosTest(ADDSUB,236)@1
    aip1E_12high_uid237_sincosTest_s <= xMSB_uid223_sincosTest_b;
    aip1E_12high_uid237_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 12 => highABits_uid236_sincosTest_b(11)) & highABits_uid236_sincosTest_b));
    aip1E_12high_uid237_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((13 downto 11 => cstArcTan2Mi_11_uid230_sincosTest_q(10)) & cstArcTan2Mi_11_uid230_sincosTest_q));
    aip1E_12high_uid237_sincosTest_combproc: PROCESS (aip1E_12high_uid237_sincosTest_a, aip1E_12high_uid237_sincosTest_b, aip1E_12high_uid237_sincosTest_s)
    BEGIN
        IF (aip1E_12high_uid237_sincosTest_s = "1") THEN
            aip1E_12high_uid237_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_12high_uid237_sincosTest_a) + SIGNED(aip1E_12high_uid237_sincosTest_b));
        ELSE
            aip1E_12high_uid237_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(aip1E_12high_uid237_sincosTest_a) - SIGNED(aip1E_12high_uid237_sincosTest_b));
        END IF;
    END PROCESS;
    aip1E_12high_uid237_sincosTest_q <= aip1E_12high_uid237_sincosTest_o(12 downto 0);

    -- lowRangeA_uid235_sincosTest(BITSELECT,234)@1
    lowRangeA_uid235_sincosTest_in <= aip1E_uid222_sincosTest_b(0 downto 0);
    lowRangeA_uid235_sincosTest_b <= lowRangeA_uid235_sincosTest_in(0 downto 0);

    -- aip1E_12_uid238_sincosTest(BITJOIN,237)@1
    aip1E_12_uid238_sincosTest_q <= aip1E_12high_uid237_sincosTest_q & lowRangeA_uid235_sincosTest_b;

    -- aip1E_uid241_sincosTest(BITSELECT,240)@1
    aip1E_uid241_sincosTest_in <= STD_LOGIC_VECTOR(aip1E_12_uid238_sincosTest_q(11 downto 0));
    aip1E_uid241_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid241_sincosTest_in(11 downto 0));

    -- xMSB_uid242_sincosTest(BITSELECT,241)@1
    xMSB_uid242_sincosTest_b <= STD_LOGIC_VECTOR(aip1E_uid241_sincosTest_b(11 downto 11));

    -- redist2_xMSB_uid242_sincosTest_b_1(DELAY,288)
    redist2_xMSB_uid242_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid242_sincosTest_b, xout => redist2_xMSB_uid242_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- signOfSelectionSignal_uid244_sincosTest(LOGICAL,243)@2
    signOfSelectionSignal_uid244_sincosTest_q <= not (redist2_xMSB_uid242_sincosTest_b_1_q);

    -- redist3_xMSB_uid223_sincosTest_b_1(DELAY,289)
    redist3_xMSB_uid223_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid223_sincosTest_b, xout => redist3_xMSB_uid223_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- redist4_xMSB_uid204_sincosTest_b_1(DELAY,290)
    redist4_xMSB_uid204_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid204_sincosTest_b, xout => redist4_xMSB_uid204_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- signOfSelectionSignal_uid206_sincosTest(LOGICAL,205)@2
    signOfSelectionSignal_uid206_sincosTest_q <= not (redist4_xMSB_uid204_sincosTest_b_1_q);

    -- redist5_xMSB_uid185_sincosTest_b_1(DELAY,291)
    redist5_xMSB_uid185_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid185_sincosTest_b, xout => redist5_xMSB_uid185_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- redist6_xMSB_uid166_sincosTest_b_1(DELAY,292)
    redist6_xMSB_uid166_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid166_sincosTest_b, xout => redist6_xMSB_uid166_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- signOfSelectionSignal_uid168_sincosTest(LOGICAL,167)@2
    signOfSelectionSignal_uid168_sincosTest_q <= not (redist6_xMSB_uid166_sincosTest_b_1_q);

    -- signOfSelectionSignal_uid133_sincosTest(LOGICAL,132)@1
    signOfSelectionSignal_uid133_sincosTest_q <= not (xMSB_uid131_sincosTest_b);

    -- redist10_xMSB_uid99_sincosTest_b_1(DELAY,296)
    redist10_xMSB_uid99_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid99_sincosTest_b, xout => redist10_xMSB_uid99_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- signOfSelectionSignal_uid101_sincosTest(LOGICAL,100)@1
    signOfSelectionSignal_uid101_sincosTest_q <= not (redist10_xMSB_uid99_sincosTest_b_1_q);

    -- redist11_xMSB_uid83_sincosTest_b_1(DELAY,297)
    redist11_xMSB_uid83_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid83_sincosTest_b, xout => redist11_xMSB_uid83_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- redist12_xMSB_uid67_sincosTest_b_1(DELAY,298)
    redist12_xMSB_uid67_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid67_sincosTest_b, xout => redist12_xMSB_uid67_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- signOfSelectionSignal_uid69_sincosTest(LOGICAL,68)@1
    signOfSelectionSignal_uid69_sincosTest_q <= not (redist12_xMSB_uid67_sincosTest_b_1_q);

    -- redist13_xMSB_uid51_sincosTest_b_1(DELAY,299)
    redist13_xMSB_uid51_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xMSB_uid51_sincosTest_b, xout => redist13_xMSB_uid51_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- xMSB_uid44_sincosTest(BITSELECT,43)@1
    xMSB_uid44_sincosTest_b <= STD_LOGIC_VECTOR(yip1E_1sumAHighB_uid35_sincosTest_q(29 downto 29));

    -- cstOneOverK_uid22_sincosTest(CONSTANT,21)
    cstOneOverK_uid22_sincosTest_q <= "1001101101110100111011011011";

    -- yip1E_1CostZeroPaddingA_uid33_sincosTest(CONSTANT,32)
    yip1E_1CostZeroPaddingA_uid33_sincosTest_q <= "0000000000000000000000000000";

    -- yip1E_1NA_uid34_sincosTest(BITJOIN,33)@0
    yip1E_1NA_uid34_sincosTest_q <= GND_q & yip1E_1CostZeroPaddingA_uid33_sincosTest_q;

    -- yip1E_1sumAHighB_uid35_sincosTest(ADDSUB,34)@0 + 1
    yip1E_1sumAHighB_uid35_sincosTest_s <= VCC_q;
    yip1E_1sumAHighB_uid35_sincosTest_a <= STD_LOGIC_VECTOR("00" & yip1E_1NA_uid34_sincosTest_q);
    yip1E_1sumAHighB_uid35_sincosTest_b <= STD_LOGIC_VECTOR("000" & cstOneOverK_uid22_sincosTest_q);
    yip1E_1sumAHighB_uid35_sincosTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            yip1E_1sumAHighB_uid35_sincosTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (en = "1") THEN
                IF (yip1E_1sumAHighB_uid35_sincosTest_s = "1") THEN
                    yip1E_1sumAHighB_uid35_sincosTest_o <= STD_LOGIC_VECTOR(UNSIGNED(yip1E_1sumAHighB_uid35_sincosTest_a) + UNSIGNED(yip1E_1sumAHighB_uid35_sincosTest_b));
                ELSE
                    yip1E_1sumAHighB_uid35_sincosTest_o <= STD_LOGIC_VECTOR(UNSIGNED(yip1E_1sumAHighB_uid35_sincosTest_a) - UNSIGNED(yip1E_1sumAHighB_uid35_sincosTest_b));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    yip1E_1sumAHighB_uid35_sincosTest_q <= yip1E_1sumAHighB_uid35_sincosTest_o(29 downto 0);

    -- yip1_1_mergedSignalTM_uid48_sincosTest(BITJOIN,47)@1
    yip1_1_mergedSignalTM_uid48_sincosTest_q <= xMSB_uid44_sincosTest_b & yip1E_1sumAHighB_uid35_sincosTest_q;

    -- twoToMiSiYip_uid57_sincosTest(BITSELECT,56)@1
    twoToMiSiYip_uid57_sincosTest_b <= STD_LOGIC_VECTOR(yip1_1_mergedSignalTM_uid48_sincosTest_q(30 downto 1));

    -- xip1E_1_uid32_sincosTest(BITJOIN,31)@1
    xip1E_1_uid32_sincosTest_q <= STD_LOGIC_VECTOR((2 downto 1 => GND_q(0)) & GND_q) & cstOneOverK_uid22_sincosTest_q;

    -- xip1_1_topRange_uid41_sincosTest(BITSELECT,40)@1
    xip1_1_topRange_uid41_sincosTest_in <= xip1E_1_uid32_sincosTest_q(29 downto 0);
    xip1_1_topRange_uid41_sincosTest_b <= xip1_1_topRange_uid41_sincosTest_in(29 downto 0);

    -- xip1_1_mergedSignalTM_uid42_sincosTest(BITJOIN,41)@1
    xip1_1_mergedSignalTM_uid42_sincosTest_q <= GND_q & xip1_1_topRange_uid41_sincosTest_b;

    -- xip1E_2_uid60_sincosTest(ADDSUB,59)@1
    xip1E_2_uid60_sincosTest_s <= redist13_xMSB_uid51_sincosTest_b_1_q;
    xip1E_2_uid60_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_1_mergedSignalTM_uid42_sincosTest_q(30)) & xip1_1_mergedSignalTM_uid42_sincosTest_q));
    xip1E_2_uid60_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 30 => twoToMiSiYip_uid57_sincosTest_b(29)) & twoToMiSiYip_uid57_sincosTest_b));
    xip1E_2_uid60_sincosTest_combproc: PROCESS (xip1E_2_uid60_sincosTest_a, xip1E_2_uid60_sincosTest_b, xip1E_2_uid60_sincosTest_s)
    BEGIN
        IF (xip1E_2_uid60_sincosTest_s = "1") THEN
            xip1E_2_uid60_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_2_uid60_sincosTest_a) + SIGNED(xip1E_2_uid60_sincosTest_b));
        ELSE
            xip1E_2_uid60_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_2_uid60_sincosTest_a) - SIGNED(xip1E_2_uid60_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_2_uid60_sincosTest_q <= xip1E_2_uid60_sincosTest_o(31 downto 0);

    -- xip1_2_uid64_sincosTest(BITSELECT,63)@1
    xip1_2_uid64_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_2_uid60_sincosTest_q(30 downto 0));
    xip1_2_uid64_sincosTest_b <= STD_LOGIC_VECTOR(xip1_2_uid64_sincosTest_in(30 downto 0));

    -- twoToMiSiXip_uid72_sincosTest(BITSELECT,71)@1
    twoToMiSiXip_uid72_sincosTest_b <= STD_LOGIC_VECTOR(xip1_2_uid64_sincosTest_b(30 downto 2));

    -- signOfSelectionSignal_uid53_sincosTest(LOGICAL,52)@1
    signOfSelectionSignal_uid53_sincosTest_q <= not (redist13_xMSB_uid51_sincosTest_b_1_q);

    -- twoToMiSiXip_uid56_sincosTest(BITSELECT,55)@1
    twoToMiSiXip_uid56_sincosTest_b <= STD_LOGIC_VECTOR(xip1_1_mergedSignalTM_uid42_sincosTest_q(30 downto 1));

    -- yip1E_2_uid61_sincosTest(ADDSUB,60)@1
    yip1E_2_uid61_sincosTest_s <= signOfSelectionSignal_uid53_sincosTest_q;
    yip1E_2_uid61_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_1_mergedSignalTM_uid48_sincosTest_q(30)) & yip1_1_mergedSignalTM_uid48_sincosTest_q));
    yip1E_2_uid61_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 30 => twoToMiSiXip_uid56_sincosTest_b(29)) & twoToMiSiXip_uid56_sincosTest_b));
    yip1E_2_uid61_sincosTest_combproc: PROCESS (yip1E_2_uid61_sincosTest_a, yip1E_2_uid61_sincosTest_b, yip1E_2_uid61_sincosTest_s)
    BEGIN
        IF (yip1E_2_uid61_sincosTest_s = "1") THEN
            yip1E_2_uid61_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_2_uid61_sincosTest_a) + SIGNED(yip1E_2_uid61_sincosTest_b));
        ELSE
            yip1E_2_uid61_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_2_uid61_sincosTest_a) - SIGNED(yip1E_2_uid61_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_2_uid61_sincosTest_q <= yip1E_2_uid61_sincosTest_o(31 downto 0);

    -- yip1_2_uid65_sincosTest(BITSELECT,64)@1
    yip1_2_uid65_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_2_uid61_sincosTest_q(30 downto 0));
    yip1_2_uid65_sincosTest_b <= STD_LOGIC_VECTOR(yip1_2_uid65_sincosTest_in(30 downto 0));

    -- yip1E_3_uid77_sincosTest(ADDSUB,76)@1
    yip1E_3_uid77_sincosTest_s <= signOfSelectionSignal_uid69_sincosTest_q;
    yip1E_3_uid77_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_2_uid65_sincosTest_b(30)) & yip1_2_uid65_sincosTest_b));
    yip1E_3_uid77_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 29 => twoToMiSiXip_uid72_sincosTest_b(28)) & twoToMiSiXip_uid72_sincosTest_b));
    yip1E_3_uid77_sincosTest_combproc: PROCESS (yip1E_3_uid77_sincosTest_a, yip1E_3_uid77_sincosTest_b, yip1E_3_uid77_sincosTest_s)
    BEGIN
        IF (yip1E_3_uid77_sincosTest_s = "1") THEN
            yip1E_3_uid77_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_3_uid77_sincosTest_a) + SIGNED(yip1E_3_uid77_sincosTest_b));
        ELSE
            yip1E_3_uid77_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_3_uid77_sincosTest_a) - SIGNED(yip1E_3_uid77_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_3_uid77_sincosTest_q <= yip1E_3_uid77_sincosTest_o(31 downto 0);

    -- yip1_3_uid81_sincosTest(BITSELECT,80)@1
    yip1_3_uid81_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_3_uid77_sincosTest_q(30 downto 0));
    yip1_3_uid81_sincosTest_b <= STD_LOGIC_VECTOR(yip1_3_uid81_sincosTest_in(30 downto 0));

    -- twoToMiSiYip_uid89_sincosTest(BITSELECT,88)@1
    twoToMiSiYip_uid89_sincosTest_b <= STD_LOGIC_VECTOR(yip1_3_uid81_sincosTest_b(30 downto 3));

    -- twoToMiSiYip_uid73_sincosTest(BITSELECT,72)@1
    twoToMiSiYip_uid73_sincosTest_b <= STD_LOGIC_VECTOR(yip1_2_uid65_sincosTest_b(30 downto 2));

    -- xip1E_3_uid76_sincosTest(ADDSUB,75)@1
    xip1E_3_uid76_sincosTest_s <= redist12_xMSB_uid67_sincosTest_b_1_q;
    xip1E_3_uid76_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_2_uid64_sincosTest_b(30)) & xip1_2_uid64_sincosTest_b));
    xip1E_3_uid76_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 29 => twoToMiSiYip_uid73_sincosTest_b(28)) & twoToMiSiYip_uid73_sincosTest_b));
    xip1E_3_uid76_sincosTest_combproc: PROCESS (xip1E_3_uid76_sincosTest_a, xip1E_3_uid76_sincosTest_b, xip1E_3_uid76_sincosTest_s)
    BEGIN
        IF (xip1E_3_uid76_sincosTest_s = "1") THEN
            xip1E_3_uid76_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_3_uid76_sincosTest_a) + SIGNED(xip1E_3_uid76_sincosTest_b));
        ELSE
            xip1E_3_uid76_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_3_uid76_sincosTest_a) - SIGNED(xip1E_3_uid76_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_3_uid76_sincosTest_q <= xip1E_3_uid76_sincosTest_o(31 downto 0);

    -- xip1_3_uid80_sincosTest(BITSELECT,79)@1
    xip1_3_uid80_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_3_uid76_sincosTest_q(30 downto 0));
    xip1_3_uid80_sincosTest_b <= STD_LOGIC_VECTOR(xip1_3_uid80_sincosTest_in(30 downto 0));

    -- xip1E_4_uid92_sincosTest(ADDSUB,91)@1
    xip1E_4_uid92_sincosTest_s <= redist11_xMSB_uid83_sincosTest_b_1_q;
    xip1E_4_uid92_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_3_uid80_sincosTest_b(30)) & xip1_3_uid80_sincosTest_b));
    xip1E_4_uid92_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 28 => twoToMiSiYip_uid89_sincosTest_b(27)) & twoToMiSiYip_uid89_sincosTest_b));
    xip1E_4_uid92_sincosTest_combproc: PROCESS (xip1E_4_uid92_sincosTest_a, xip1E_4_uid92_sincosTest_b, xip1E_4_uid92_sincosTest_s)
    BEGIN
        IF (xip1E_4_uid92_sincosTest_s = "1") THEN
            xip1E_4_uid92_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_4_uid92_sincosTest_a) + SIGNED(xip1E_4_uid92_sincosTest_b));
        ELSE
            xip1E_4_uid92_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_4_uid92_sincosTest_a) - SIGNED(xip1E_4_uid92_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_4_uid92_sincosTest_q <= xip1E_4_uid92_sincosTest_o(31 downto 0);

    -- xip1_4_uid96_sincosTest(BITSELECT,95)@1
    xip1_4_uid96_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_4_uid92_sincosTest_q(30 downto 0));
    xip1_4_uid96_sincosTest_b <= STD_LOGIC_VECTOR(xip1_4_uid96_sincosTest_in(30 downto 0));

    -- twoToMiSiXip_uid104_sincosTest(BITSELECT,103)@1
    twoToMiSiXip_uid104_sincosTest_b <= STD_LOGIC_VECTOR(xip1_4_uid96_sincosTest_b(30 downto 4));

    -- signOfSelectionSignal_uid85_sincosTest(LOGICAL,84)@1
    signOfSelectionSignal_uid85_sincosTest_q <= not (redist11_xMSB_uid83_sincosTest_b_1_q);

    -- twoToMiSiXip_uid88_sincosTest(BITSELECT,87)@1
    twoToMiSiXip_uid88_sincosTest_b <= STD_LOGIC_VECTOR(xip1_3_uid80_sincosTest_b(30 downto 3));

    -- yip1E_4_uid93_sincosTest(ADDSUB,92)@1
    yip1E_4_uid93_sincosTest_s <= signOfSelectionSignal_uid85_sincosTest_q;
    yip1E_4_uid93_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_3_uid81_sincosTest_b(30)) & yip1_3_uid81_sincosTest_b));
    yip1E_4_uid93_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 28 => twoToMiSiXip_uid88_sincosTest_b(27)) & twoToMiSiXip_uid88_sincosTest_b));
    yip1E_4_uid93_sincosTest_combproc: PROCESS (yip1E_4_uid93_sincosTest_a, yip1E_4_uid93_sincosTest_b, yip1E_4_uid93_sincosTest_s)
    BEGIN
        IF (yip1E_4_uid93_sincosTest_s = "1") THEN
            yip1E_4_uid93_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_4_uid93_sincosTest_a) + SIGNED(yip1E_4_uid93_sincosTest_b));
        ELSE
            yip1E_4_uid93_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_4_uid93_sincosTest_a) - SIGNED(yip1E_4_uid93_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_4_uid93_sincosTest_q <= yip1E_4_uid93_sincosTest_o(31 downto 0);

    -- yip1_4_uid97_sincosTest(BITSELECT,96)@1
    yip1_4_uid97_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_4_uid93_sincosTest_q(30 downto 0));
    yip1_4_uid97_sincosTest_b <= STD_LOGIC_VECTOR(yip1_4_uid97_sincosTest_in(30 downto 0));

    -- yip1E_5_uid109_sincosTest(ADDSUB,108)@1
    yip1E_5_uid109_sincosTest_s <= signOfSelectionSignal_uid101_sincosTest_q;
    yip1E_5_uid109_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_4_uid97_sincosTest_b(30)) & yip1_4_uid97_sincosTest_b));
    yip1E_5_uid109_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 27 => twoToMiSiXip_uid104_sincosTest_b(26)) & twoToMiSiXip_uid104_sincosTest_b));
    yip1E_5_uid109_sincosTest_combproc: PROCESS (yip1E_5_uid109_sincosTest_a, yip1E_5_uid109_sincosTest_b, yip1E_5_uid109_sincosTest_s)
    BEGIN
        IF (yip1E_5_uid109_sincosTest_s = "1") THEN
            yip1E_5_uid109_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_5_uid109_sincosTest_a) + SIGNED(yip1E_5_uid109_sincosTest_b));
        ELSE
            yip1E_5_uid109_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_5_uid109_sincosTest_a) - SIGNED(yip1E_5_uid109_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_5_uid109_sincosTest_q <= yip1E_5_uid109_sincosTest_o(31 downto 0);

    -- yip1_5_uid113_sincosTest(BITSELECT,112)@1
    yip1_5_uid113_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_5_uid109_sincosTest_q(30 downto 0));
    yip1_5_uid113_sincosTest_b <= STD_LOGIC_VECTOR(yip1_5_uid113_sincosTest_in(30 downto 0));

    -- twoToMiSiYip_uid121_sincosTest(BITSELECT,120)@1
    twoToMiSiYip_uid121_sincosTest_b <= STD_LOGIC_VECTOR(yip1_5_uid113_sincosTest_b(30 downto 5));

    -- twoToMiSiYip_uid105_sincosTest(BITSELECT,104)@1
    twoToMiSiYip_uid105_sincosTest_b <= STD_LOGIC_VECTOR(yip1_4_uid97_sincosTest_b(30 downto 4));

    -- xip1E_5_uid108_sincosTest(ADDSUB,107)@1
    xip1E_5_uid108_sincosTest_s <= redist10_xMSB_uid99_sincosTest_b_1_q;
    xip1E_5_uid108_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_4_uid96_sincosTest_b(30)) & xip1_4_uid96_sincosTest_b));
    xip1E_5_uid108_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 27 => twoToMiSiYip_uid105_sincosTest_b(26)) & twoToMiSiYip_uid105_sincosTest_b));
    xip1E_5_uid108_sincosTest_combproc: PROCESS (xip1E_5_uid108_sincosTest_a, xip1E_5_uid108_sincosTest_b, xip1E_5_uid108_sincosTest_s)
    BEGIN
        IF (xip1E_5_uid108_sincosTest_s = "1") THEN
            xip1E_5_uid108_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_5_uid108_sincosTest_a) + SIGNED(xip1E_5_uid108_sincosTest_b));
        ELSE
            xip1E_5_uid108_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_5_uid108_sincosTest_a) - SIGNED(xip1E_5_uid108_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_5_uid108_sincosTest_q <= xip1E_5_uid108_sincosTest_o(31 downto 0);

    -- xip1_5_uid112_sincosTest(BITSELECT,111)@1
    xip1_5_uid112_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_5_uid108_sincosTest_q(30 downto 0));
    xip1_5_uid112_sincosTest_b <= STD_LOGIC_VECTOR(xip1_5_uid112_sincosTest_in(30 downto 0));

    -- xip1E_6_uid124_sincosTest(ADDSUB,123)@1
    xip1E_6_uid124_sincosTest_s <= xMSB_uid115_sincosTest_b;
    xip1E_6_uid124_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_5_uid112_sincosTest_b(30)) & xip1_5_uid112_sincosTest_b));
    xip1E_6_uid124_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 26 => twoToMiSiYip_uid121_sincosTest_b(25)) & twoToMiSiYip_uid121_sincosTest_b));
    xip1E_6_uid124_sincosTest_combproc: PROCESS (xip1E_6_uid124_sincosTest_a, xip1E_6_uid124_sincosTest_b, xip1E_6_uid124_sincosTest_s)
    BEGIN
        IF (xip1E_6_uid124_sincosTest_s = "1") THEN
            xip1E_6_uid124_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_6_uid124_sincosTest_a) + SIGNED(xip1E_6_uid124_sincosTest_b));
        ELSE
            xip1E_6_uid124_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_6_uid124_sincosTest_a) - SIGNED(xip1E_6_uid124_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_6_uid124_sincosTest_q <= xip1E_6_uid124_sincosTest_o(31 downto 0);

    -- xip1_6_uid128_sincosTest(BITSELECT,127)@1
    xip1_6_uid128_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_6_uid124_sincosTest_q(30 downto 0));
    xip1_6_uid128_sincosTest_b <= STD_LOGIC_VECTOR(xip1_6_uid128_sincosTest_in(30 downto 0));

    -- twoToMiSiXip_uid136_sincosTest(BITSELECT,135)@1
    twoToMiSiXip_uid136_sincosTest_b <= STD_LOGIC_VECTOR(xip1_6_uid128_sincosTest_b(30 downto 6));

    -- signOfSelectionSignal_uid117_sincosTest(LOGICAL,116)@1
    signOfSelectionSignal_uid117_sincosTest_q <= not (xMSB_uid115_sincosTest_b);

    -- twoToMiSiXip_uid120_sincosTest(BITSELECT,119)@1
    twoToMiSiXip_uid120_sincosTest_b <= STD_LOGIC_VECTOR(xip1_5_uid112_sincosTest_b(30 downto 5));

    -- yip1E_6_uid125_sincosTest(ADDSUB,124)@1
    yip1E_6_uid125_sincosTest_s <= signOfSelectionSignal_uid117_sincosTest_q;
    yip1E_6_uid125_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_5_uid113_sincosTest_b(30)) & yip1_5_uid113_sincosTest_b));
    yip1E_6_uid125_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 26 => twoToMiSiXip_uid120_sincosTest_b(25)) & twoToMiSiXip_uid120_sincosTest_b));
    yip1E_6_uid125_sincosTest_combproc: PROCESS (yip1E_6_uid125_sincosTest_a, yip1E_6_uid125_sincosTest_b, yip1E_6_uid125_sincosTest_s)
    BEGIN
        IF (yip1E_6_uid125_sincosTest_s = "1") THEN
            yip1E_6_uid125_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_6_uid125_sincosTest_a) + SIGNED(yip1E_6_uid125_sincosTest_b));
        ELSE
            yip1E_6_uid125_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_6_uid125_sincosTest_a) - SIGNED(yip1E_6_uid125_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_6_uid125_sincosTest_q <= yip1E_6_uid125_sincosTest_o(31 downto 0);

    -- yip1_6_uid129_sincosTest(BITSELECT,128)@1
    yip1_6_uid129_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_6_uid125_sincosTest_q(30 downto 0));
    yip1_6_uid129_sincosTest_b <= STD_LOGIC_VECTOR(yip1_6_uid129_sincosTest_in(30 downto 0));

    -- yip1E_7_uid141_sincosTest(ADDSUB,140)@1
    yip1E_7_uid141_sincosTest_s <= signOfSelectionSignal_uid133_sincosTest_q;
    yip1E_7_uid141_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_6_uid129_sincosTest_b(30)) & yip1_6_uid129_sincosTest_b));
    yip1E_7_uid141_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 25 => twoToMiSiXip_uid136_sincosTest_b(24)) & twoToMiSiXip_uid136_sincosTest_b));
    yip1E_7_uid141_sincosTest_combproc: PROCESS (yip1E_7_uid141_sincosTest_a, yip1E_7_uid141_sincosTest_b, yip1E_7_uid141_sincosTest_s)
    BEGIN
        IF (yip1E_7_uid141_sincosTest_s = "1") THEN
            yip1E_7_uid141_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_7_uid141_sincosTest_a) + SIGNED(yip1E_7_uid141_sincosTest_b));
        ELSE
            yip1E_7_uid141_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_7_uid141_sincosTest_a) - SIGNED(yip1E_7_uid141_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_7_uid141_sincosTest_q <= yip1E_7_uid141_sincosTest_o(31 downto 0);

    -- yip1_7_uid145_sincosTest(BITSELECT,144)@1
    yip1_7_uid145_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_7_uid141_sincosTest_q(30 downto 0));
    yip1_7_uid145_sincosTest_b <= STD_LOGIC_VECTOR(yip1_7_uid145_sincosTest_in(30 downto 0));

    -- twoToMiSiYip_uid153_sincosTest(BITSELECT,152)@1
    twoToMiSiYip_uid153_sincosTest_b <= STD_LOGIC_VECTOR(yip1_7_uid145_sincosTest_b(30 downto 7));

    -- twoToMiSiYip_uid137_sincosTest(BITSELECT,136)@1
    twoToMiSiYip_uid137_sincosTest_b <= STD_LOGIC_VECTOR(yip1_6_uid129_sincosTest_b(30 downto 6));

    -- xip1E_7_uid140_sincosTest(ADDSUB,139)@1
    xip1E_7_uid140_sincosTest_s <= xMSB_uid131_sincosTest_b;
    xip1E_7_uid140_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_6_uid128_sincosTest_b(30)) & xip1_6_uid128_sincosTest_b));
    xip1E_7_uid140_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 25 => twoToMiSiYip_uid137_sincosTest_b(24)) & twoToMiSiYip_uid137_sincosTest_b));
    xip1E_7_uid140_sincosTest_combproc: PROCESS (xip1E_7_uid140_sincosTest_a, xip1E_7_uid140_sincosTest_b, xip1E_7_uid140_sincosTest_s)
    BEGIN
        IF (xip1E_7_uid140_sincosTest_s = "1") THEN
            xip1E_7_uid140_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_7_uid140_sincosTest_a) + SIGNED(xip1E_7_uid140_sincosTest_b));
        ELSE
            xip1E_7_uid140_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_7_uid140_sincosTest_a) - SIGNED(xip1E_7_uid140_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_7_uid140_sincosTest_q <= xip1E_7_uid140_sincosTest_o(31 downto 0);

    -- xip1_7_uid144_sincosTest(BITSELECT,143)@1
    xip1_7_uid144_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_7_uid140_sincosTest_q(30 downto 0));
    xip1_7_uid144_sincosTest_b <= STD_LOGIC_VECTOR(xip1_7_uid144_sincosTest_in(30 downto 0));

    -- xip1E_8_uid156_sincosTest(ADDSUB,155)@1
    xip1E_8_uid156_sincosTest_s <= xMSB_uid147_sincosTest_b;
    xip1E_8_uid156_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_7_uid144_sincosTest_b(30)) & xip1_7_uid144_sincosTest_b));
    xip1E_8_uid156_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 24 => twoToMiSiYip_uid153_sincosTest_b(23)) & twoToMiSiYip_uid153_sincosTest_b));
    xip1E_8_uid156_sincosTest_combproc: PROCESS (xip1E_8_uid156_sincosTest_a, xip1E_8_uid156_sincosTest_b, xip1E_8_uid156_sincosTest_s)
    BEGIN
        IF (xip1E_8_uid156_sincosTest_s = "1") THEN
            xip1E_8_uid156_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_8_uid156_sincosTest_a) + SIGNED(xip1E_8_uid156_sincosTest_b));
        ELSE
            xip1E_8_uid156_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_8_uid156_sincosTest_a) - SIGNED(xip1E_8_uid156_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_8_uid156_sincosTest_q <= xip1E_8_uid156_sincosTest_o(31 downto 0);

    -- xip1_8_uid163_sincosTest(BITSELECT,162)@1
    xip1_8_uid163_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_8_uid156_sincosTest_q(30 downto 0));
    xip1_8_uid163_sincosTest_b <= STD_LOGIC_VECTOR(xip1_8_uid163_sincosTest_in(30 downto 0));

    -- redist8_xip1_8_uid163_sincosTest_b_1(DELAY,294)
    redist8_xip1_8_uid163_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 31, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xip1_8_uid163_sincosTest_b, xout => redist8_xip1_8_uid163_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- twoToMiSiXip_uid171_sincosTest(BITSELECT,170)@2
    twoToMiSiXip_uid171_sincosTest_b <= STD_LOGIC_VECTOR(redist8_xip1_8_uid163_sincosTest_b_1_q(30 downto 8));

    -- signOfSelectionSignal_uid149_sincosTest(LOGICAL,148)@1
    signOfSelectionSignal_uid149_sincosTest_q <= not (xMSB_uid147_sincosTest_b);

    -- twoToMiSiXip_uid152_sincosTest(BITSELECT,151)@1
    twoToMiSiXip_uid152_sincosTest_b <= STD_LOGIC_VECTOR(xip1_7_uid144_sincosTest_b(30 downto 7));

    -- yip1E_8_uid157_sincosTest(ADDSUB,156)@1
    yip1E_8_uid157_sincosTest_s <= signOfSelectionSignal_uid149_sincosTest_q;
    yip1E_8_uid157_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_7_uid145_sincosTest_b(30)) & yip1_7_uid145_sincosTest_b));
    yip1E_8_uid157_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 24 => twoToMiSiXip_uid152_sincosTest_b(23)) & twoToMiSiXip_uid152_sincosTest_b));
    yip1E_8_uid157_sincosTest_combproc: PROCESS (yip1E_8_uid157_sincosTest_a, yip1E_8_uid157_sincosTest_b, yip1E_8_uid157_sincosTest_s)
    BEGIN
        IF (yip1E_8_uid157_sincosTest_s = "1") THEN
            yip1E_8_uid157_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_8_uid157_sincosTest_a) + SIGNED(yip1E_8_uid157_sincosTest_b));
        ELSE
            yip1E_8_uid157_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_8_uid157_sincosTest_a) - SIGNED(yip1E_8_uid157_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_8_uid157_sincosTest_q <= yip1E_8_uid157_sincosTest_o(31 downto 0);

    -- yip1_8_uid164_sincosTest(BITSELECT,163)@1
    yip1_8_uid164_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_8_uid157_sincosTest_q(30 downto 0));
    yip1_8_uid164_sincosTest_b <= STD_LOGIC_VECTOR(yip1_8_uid164_sincosTest_in(30 downto 0));

    -- redist7_yip1_8_uid164_sincosTest_b_1(DELAY,293)
    redist7_yip1_8_uid164_sincosTest_b_1 : dspba_delay
    GENERIC MAP ( width => 31, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yip1_8_uid164_sincosTest_b, xout => redist7_yip1_8_uid164_sincosTest_b_1_q, ena => en(0), clk => clk, aclr => areset );

    -- yip1E_9_uid176_sincosTest(ADDSUB,175)@2
    yip1E_9_uid176_sincosTest_s <= signOfSelectionSignal_uid168_sincosTest_q;
    yip1E_9_uid176_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => redist7_yip1_8_uid164_sincosTest_b_1_q(30)) & redist7_yip1_8_uid164_sincosTest_b_1_q));
    yip1E_9_uid176_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 23 => twoToMiSiXip_uid171_sincosTest_b(22)) & twoToMiSiXip_uid171_sincosTest_b));
    yip1E_9_uid176_sincosTest_combproc: PROCESS (yip1E_9_uid176_sincosTest_a, yip1E_9_uid176_sincosTest_b, yip1E_9_uid176_sincosTest_s)
    BEGIN
        IF (yip1E_9_uid176_sincosTest_s = "1") THEN
            yip1E_9_uid176_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_9_uid176_sincosTest_a) + SIGNED(yip1E_9_uid176_sincosTest_b));
        ELSE
            yip1E_9_uid176_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_9_uid176_sincosTest_a) - SIGNED(yip1E_9_uid176_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_9_uid176_sincosTest_q <= yip1E_9_uid176_sincosTest_o(31 downto 0);

    -- yip1_9_uid183_sincosTest(BITSELECT,182)@2
    yip1_9_uid183_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_9_uid176_sincosTest_q(30 downto 0));
    yip1_9_uid183_sincosTest_b <= STD_LOGIC_VECTOR(yip1_9_uid183_sincosTest_in(30 downto 0));

    -- twoToMiSiYip_uid191_sincosTest(BITSELECT,190)@2
    twoToMiSiYip_uid191_sincosTest_b <= STD_LOGIC_VECTOR(yip1_9_uid183_sincosTest_b(30 downto 9));

    -- twoToMiSiYip_uid172_sincosTest(BITSELECT,171)@2
    twoToMiSiYip_uid172_sincosTest_b <= STD_LOGIC_VECTOR(redist7_yip1_8_uid164_sincosTest_b_1_q(30 downto 8));

    -- xip1E_9_uid175_sincosTest(ADDSUB,174)@2
    xip1E_9_uid175_sincosTest_s <= redist6_xMSB_uid166_sincosTest_b_1_q;
    xip1E_9_uid175_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => redist8_xip1_8_uid163_sincosTest_b_1_q(30)) & redist8_xip1_8_uid163_sincosTest_b_1_q));
    xip1E_9_uid175_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 23 => twoToMiSiYip_uid172_sincosTest_b(22)) & twoToMiSiYip_uid172_sincosTest_b));
    xip1E_9_uid175_sincosTest_combproc: PROCESS (xip1E_9_uid175_sincosTest_a, xip1E_9_uid175_sincosTest_b, xip1E_9_uid175_sincosTest_s)
    BEGIN
        IF (xip1E_9_uid175_sincosTest_s = "1") THEN
            xip1E_9_uid175_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_9_uid175_sincosTest_a) + SIGNED(xip1E_9_uid175_sincosTest_b));
        ELSE
            xip1E_9_uid175_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_9_uid175_sincosTest_a) - SIGNED(xip1E_9_uid175_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_9_uid175_sincosTest_q <= xip1E_9_uid175_sincosTest_o(31 downto 0);

    -- xip1_9_uid182_sincosTest(BITSELECT,181)@2
    xip1_9_uid182_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_9_uid175_sincosTest_q(30 downto 0));
    xip1_9_uid182_sincosTest_b <= STD_LOGIC_VECTOR(xip1_9_uid182_sincosTest_in(30 downto 0));

    -- xip1E_10_uid194_sincosTest(ADDSUB,193)@2
    xip1E_10_uid194_sincosTest_s <= redist5_xMSB_uid185_sincosTest_b_1_q;
    xip1E_10_uid194_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_9_uid182_sincosTest_b(30)) & xip1_9_uid182_sincosTest_b));
    xip1E_10_uid194_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 22 => twoToMiSiYip_uid191_sincosTest_b(21)) & twoToMiSiYip_uid191_sincosTest_b));
    xip1E_10_uid194_sincosTest_combproc: PROCESS (xip1E_10_uid194_sincosTest_a, xip1E_10_uid194_sincosTest_b, xip1E_10_uid194_sincosTest_s)
    BEGIN
        IF (xip1E_10_uid194_sincosTest_s = "1") THEN
            xip1E_10_uid194_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_10_uid194_sincosTest_a) + SIGNED(xip1E_10_uid194_sincosTest_b));
        ELSE
            xip1E_10_uid194_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_10_uid194_sincosTest_a) - SIGNED(xip1E_10_uid194_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_10_uid194_sincosTest_q <= xip1E_10_uid194_sincosTest_o(31 downto 0);

    -- xip1_10_uid201_sincosTest(BITSELECT,200)@2
    xip1_10_uid201_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_10_uid194_sincosTest_q(30 downto 0));
    xip1_10_uid201_sincosTest_b <= STD_LOGIC_VECTOR(xip1_10_uid201_sincosTest_in(30 downto 0));

    -- twoToMiSiXip_uid209_sincosTest(BITSELECT,208)@2
    twoToMiSiXip_uid209_sincosTest_b <= STD_LOGIC_VECTOR(xip1_10_uid201_sincosTest_b(30 downto 10));

    -- signOfSelectionSignal_uid187_sincosTest(LOGICAL,186)@2
    signOfSelectionSignal_uid187_sincosTest_q <= not (redist5_xMSB_uid185_sincosTest_b_1_q);

    -- twoToMiSiXip_uid190_sincosTest(BITSELECT,189)@2
    twoToMiSiXip_uid190_sincosTest_b <= STD_LOGIC_VECTOR(xip1_9_uid182_sincosTest_b(30 downto 9));

    -- yip1E_10_uid195_sincosTest(ADDSUB,194)@2
    yip1E_10_uid195_sincosTest_s <= signOfSelectionSignal_uid187_sincosTest_q;
    yip1E_10_uid195_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_9_uid183_sincosTest_b(30)) & yip1_9_uid183_sincosTest_b));
    yip1E_10_uid195_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 22 => twoToMiSiXip_uid190_sincosTest_b(21)) & twoToMiSiXip_uid190_sincosTest_b));
    yip1E_10_uid195_sincosTest_combproc: PROCESS (yip1E_10_uid195_sincosTest_a, yip1E_10_uid195_sincosTest_b, yip1E_10_uid195_sincosTest_s)
    BEGIN
        IF (yip1E_10_uid195_sincosTest_s = "1") THEN
            yip1E_10_uid195_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_10_uid195_sincosTest_a) + SIGNED(yip1E_10_uid195_sincosTest_b));
        ELSE
            yip1E_10_uid195_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_10_uid195_sincosTest_a) - SIGNED(yip1E_10_uid195_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_10_uid195_sincosTest_q <= yip1E_10_uid195_sincosTest_o(31 downto 0);

    -- yip1_10_uid202_sincosTest(BITSELECT,201)@2
    yip1_10_uid202_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_10_uid195_sincosTest_q(30 downto 0));
    yip1_10_uid202_sincosTest_b <= STD_LOGIC_VECTOR(yip1_10_uid202_sincosTest_in(30 downto 0));

    -- yip1E_11_uid214_sincosTest(ADDSUB,213)@2
    yip1E_11_uid214_sincosTest_s <= signOfSelectionSignal_uid206_sincosTest_q;
    yip1E_11_uid214_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_10_uid202_sincosTest_b(30)) & yip1_10_uid202_sincosTest_b));
    yip1E_11_uid214_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 21 => twoToMiSiXip_uid209_sincosTest_b(20)) & twoToMiSiXip_uid209_sincosTest_b));
    yip1E_11_uid214_sincosTest_combproc: PROCESS (yip1E_11_uid214_sincosTest_a, yip1E_11_uid214_sincosTest_b, yip1E_11_uid214_sincosTest_s)
    BEGIN
        IF (yip1E_11_uid214_sincosTest_s = "1") THEN
            yip1E_11_uid214_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_11_uid214_sincosTest_a) + SIGNED(yip1E_11_uid214_sincosTest_b));
        ELSE
            yip1E_11_uid214_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_11_uid214_sincosTest_a) - SIGNED(yip1E_11_uid214_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_11_uid214_sincosTest_q <= yip1E_11_uid214_sincosTest_o(31 downto 0);

    -- yip1_11_uid221_sincosTest(BITSELECT,220)@2
    yip1_11_uid221_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_11_uid214_sincosTest_q(30 downto 0));
    yip1_11_uid221_sincosTest_b <= STD_LOGIC_VECTOR(yip1_11_uid221_sincosTest_in(30 downto 0));

    -- twoToMiSiYip_uid229_sincosTest(BITSELECT,228)@2
    twoToMiSiYip_uid229_sincosTest_b <= STD_LOGIC_VECTOR(yip1_11_uid221_sincosTest_b(30 downto 11));

    -- twoToMiSiYip_uid210_sincosTest(BITSELECT,209)@2
    twoToMiSiYip_uid210_sincosTest_b <= STD_LOGIC_VECTOR(yip1_10_uid202_sincosTest_b(30 downto 10));

    -- xip1E_11_uid213_sincosTest(ADDSUB,212)@2
    xip1E_11_uid213_sincosTest_s <= redist4_xMSB_uid204_sincosTest_b_1_q;
    xip1E_11_uid213_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_10_uid201_sincosTest_b(30)) & xip1_10_uid201_sincosTest_b));
    xip1E_11_uid213_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 21 => twoToMiSiYip_uid210_sincosTest_b(20)) & twoToMiSiYip_uid210_sincosTest_b));
    xip1E_11_uid213_sincosTest_combproc: PROCESS (xip1E_11_uid213_sincosTest_a, xip1E_11_uid213_sincosTest_b, xip1E_11_uid213_sincosTest_s)
    BEGIN
        IF (xip1E_11_uid213_sincosTest_s = "1") THEN
            xip1E_11_uid213_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_11_uid213_sincosTest_a) + SIGNED(xip1E_11_uid213_sincosTest_b));
        ELSE
            xip1E_11_uid213_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_11_uid213_sincosTest_a) - SIGNED(xip1E_11_uid213_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_11_uid213_sincosTest_q <= xip1E_11_uid213_sincosTest_o(31 downto 0);

    -- xip1_11_uid220_sincosTest(BITSELECT,219)@2
    xip1_11_uid220_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_11_uid213_sincosTest_q(30 downto 0));
    xip1_11_uid220_sincosTest_b <= STD_LOGIC_VECTOR(xip1_11_uid220_sincosTest_in(30 downto 0));

    -- xip1E_12_uid232_sincosTest(ADDSUB,231)@2
    xip1E_12_uid232_sincosTest_s <= redist3_xMSB_uid223_sincosTest_b_1_q;
    xip1E_12_uid232_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_11_uid220_sincosTest_b(30)) & xip1_11_uid220_sincosTest_b));
    xip1E_12_uid232_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 20 => twoToMiSiYip_uid229_sincosTest_b(19)) & twoToMiSiYip_uid229_sincosTest_b));
    xip1E_12_uid232_sincosTest_combproc: PROCESS (xip1E_12_uid232_sincosTest_a, xip1E_12_uid232_sincosTest_b, xip1E_12_uid232_sincosTest_s)
    BEGIN
        IF (xip1E_12_uid232_sincosTest_s = "1") THEN
            xip1E_12_uid232_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_12_uid232_sincosTest_a) + SIGNED(xip1E_12_uid232_sincosTest_b));
        ELSE
            xip1E_12_uid232_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_12_uid232_sincosTest_a) - SIGNED(xip1E_12_uid232_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_12_uid232_sincosTest_q <= xip1E_12_uid232_sincosTest_o(31 downto 0);

    -- xip1_12_uid239_sincosTest(BITSELECT,238)@2
    xip1_12_uid239_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_12_uid232_sincosTest_q(30 downto 0));
    xip1_12_uid239_sincosTest_b <= STD_LOGIC_VECTOR(xip1_12_uid239_sincosTest_in(30 downto 0));

    -- twoToMiSiXip_uid247_sincosTest(BITSELECT,246)@2
    twoToMiSiXip_uid247_sincosTest_b <= STD_LOGIC_VECTOR(xip1_12_uid239_sincosTest_b(30 downto 12));

    -- signOfSelectionSignal_uid225_sincosTest(LOGICAL,224)@2
    signOfSelectionSignal_uid225_sincosTest_q <= not (redist3_xMSB_uid223_sincosTest_b_1_q);

    -- twoToMiSiXip_uid228_sincosTest(BITSELECT,227)@2
    twoToMiSiXip_uid228_sincosTest_b <= STD_LOGIC_VECTOR(xip1_11_uid220_sincosTest_b(30 downto 11));

    -- yip1E_12_uid233_sincosTest(ADDSUB,232)@2
    yip1E_12_uid233_sincosTest_s <= signOfSelectionSignal_uid225_sincosTest_q;
    yip1E_12_uid233_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_11_uid221_sincosTest_b(30)) & yip1_11_uid221_sincosTest_b));
    yip1E_12_uid233_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 20 => twoToMiSiXip_uid228_sincosTest_b(19)) & twoToMiSiXip_uid228_sincosTest_b));
    yip1E_12_uid233_sincosTest_combproc: PROCESS (yip1E_12_uid233_sincosTest_a, yip1E_12_uid233_sincosTest_b, yip1E_12_uid233_sincosTest_s)
    BEGIN
        IF (yip1E_12_uid233_sincosTest_s = "1") THEN
            yip1E_12_uid233_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_12_uid233_sincosTest_a) + SIGNED(yip1E_12_uid233_sincosTest_b));
        ELSE
            yip1E_12_uid233_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_12_uid233_sincosTest_a) - SIGNED(yip1E_12_uid233_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_12_uid233_sincosTest_q <= yip1E_12_uid233_sincosTest_o(31 downto 0);

    -- yip1_12_uid240_sincosTest(BITSELECT,239)@2
    yip1_12_uid240_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_12_uid233_sincosTest_q(30 downto 0));
    yip1_12_uid240_sincosTest_b <= STD_LOGIC_VECTOR(yip1_12_uid240_sincosTest_in(30 downto 0));

    -- yip1E_13_uid252_sincosTest(ADDSUB,251)@2
    yip1E_13_uid252_sincosTest_s <= signOfSelectionSignal_uid244_sincosTest_q;
    yip1E_13_uid252_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => yip1_12_uid240_sincosTest_b(30)) & yip1_12_uid240_sincosTest_b));
    yip1E_13_uid252_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 19 => twoToMiSiXip_uid247_sincosTest_b(18)) & twoToMiSiXip_uid247_sincosTest_b));
    yip1E_13_uid252_sincosTest_combproc: PROCESS (yip1E_13_uid252_sincosTest_a, yip1E_13_uid252_sincosTest_b, yip1E_13_uid252_sincosTest_s)
    BEGIN
        IF (yip1E_13_uid252_sincosTest_s = "1") THEN
            yip1E_13_uid252_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_13_uid252_sincosTest_a) + SIGNED(yip1E_13_uid252_sincosTest_b));
        ELSE
            yip1E_13_uid252_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(yip1E_13_uid252_sincosTest_a) - SIGNED(yip1E_13_uid252_sincosTest_b));
        END IF;
    END PROCESS;
    yip1E_13_uid252_sincosTest_q <= yip1E_13_uid252_sincosTest_o(31 downto 0);

    -- yip1_13_uid259_sincosTest(BITSELECT,258)@2
    yip1_13_uid259_sincosTest_in <= STD_LOGIC_VECTOR(yip1E_13_uid252_sincosTest_q(30 downto 0));
    yip1_13_uid259_sincosTest_b <= STD_LOGIC_VECTOR(yip1_13_uid259_sincosTest_in(30 downto 0));

    -- ySumPreRnd_uid265_sincosTest(BITSELECT,264)@2
    ySumPreRnd_uid265_sincosTest_in <= yip1_13_uid259_sincosTest_b(29 downto 0);
    ySumPreRnd_uid265_sincosTest_b <= ySumPreRnd_uid265_sincosTest_in(29 downto 16);

    -- ySumPostRnd_uid268_sincosTest(ADD,267)@2
    ySumPostRnd_uid268_sincosTest_a <= STD_LOGIC_VECTOR("0" & ySumPreRnd_uid265_sincosTest_b);
    ySumPostRnd_uid268_sincosTest_b <= STD_LOGIC_VECTOR("00000000000000" & VCC_q);
    ySumPostRnd_uid268_sincosTest_o <= STD_LOGIC_VECTOR(UNSIGNED(ySumPostRnd_uid268_sincosTest_a) + UNSIGNED(ySumPostRnd_uid268_sincosTest_b));
    ySumPostRnd_uid268_sincosTest_q <= ySumPostRnd_uid268_sincosTest_o(14 downto 0);

    -- yPostExc_uid270_sincosTest(BITSELECT,269)@2
    yPostExc_uid270_sincosTest_in <= STD_LOGIC_VECTOR(ySumPostRnd_uid268_sincosTest_q(13 downto 0));
    yPostExc_uid270_sincosTest_b <= STD_LOGIC_VECTOR(yPostExc_uid270_sincosTest_in(13 downto 1));

    -- cstZeroForAddSub_uid278_sincosTest(CONSTANT,277)
    cstZeroForAddSub_uid278_sincosTest_q <= "0000000000000";

    -- sinPostNeg_uid280_sincosTest(ADDSUB,279)@2
    sinPostNeg_uid280_sincosTest_s <= invSinNegCond_uid279_sincosTest_q;
    sinPostNeg_uid280_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((14 downto 13 => cstZeroForAddSub_uid278_sincosTest_q(12)) & cstZeroForAddSub_uid278_sincosTest_q));
    sinPostNeg_uid280_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((14 downto 13 => yPostExc_uid270_sincosTest_b(12)) & yPostExc_uid270_sincosTest_b));
    sinPostNeg_uid280_sincosTest_combproc: PROCESS (sinPostNeg_uid280_sincosTest_a, sinPostNeg_uid280_sincosTest_b, sinPostNeg_uid280_sincosTest_s)
    BEGIN
        IF (sinPostNeg_uid280_sincosTest_s = "1") THEN
            sinPostNeg_uid280_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(sinPostNeg_uid280_sincosTest_a) + SIGNED(sinPostNeg_uid280_sincosTest_b));
        ELSE
            sinPostNeg_uid280_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(sinPostNeg_uid280_sincosTest_a) - SIGNED(sinPostNeg_uid280_sincosTest_b));
        END IF;
    END PROCESS;
    sinPostNeg_uid280_sincosTest_q <= sinPostNeg_uid280_sincosTest_o(13 downto 0);

    -- invCosNegCond_uid281_sincosTest(LOGICAL,280)@0 + 1
    invCosNegCond_uid281_sincosTest_qi <= not (sinNegCond2_uid272_sincosTest_q);
    invCosNegCond_uid281_sincosTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => invCosNegCond_uid281_sincosTest_qi, xout => invCosNegCond_uid281_sincosTest_q, ena => en(0), clk => clk, aclr => areset );

    -- redist0_invCosNegCond_uid281_sincosTest_q_2(DELAY,286)
    redist0_invCosNegCond_uid281_sincosTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => invCosNegCond_uid281_sincosTest_q, xout => redist0_invCosNegCond_uid281_sincosTest_q_2_q, ena => en(0), clk => clk, aclr => areset );

    -- twoToMiSiYip_uid248_sincosTest(BITSELECT,247)@2
    twoToMiSiYip_uid248_sincosTest_b <= STD_LOGIC_VECTOR(yip1_12_uid240_sincosTest_b(30 downto 12));

    -- xip1E_13_uid251_sincosTest(ADDSUB,250)@2
    xip1E_13_uid251_sincosTest_s <= redist2_xMSB_uid242_sincosTest_b_1_q;
    xip1E_13_uid251_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 31 => xip1_12_uid239_sincosTest_b(30)) & xip1_12_uid239_sincosTest_b));
    xip1E_13_uid251_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 19 => twoToMiSiYip_uid248_sincosTest_b(18)) & twoToMiSiYip_uid248_sincosTest_b));
    xip1E_13_uid251_sincosTest_combproc: PROCESS (xip1E_13_uid251_sincosTest_a, xip1E_13_uid251_sincosTest_b, xip1E_13_uid251_sincosTest_s)
    BEGIN
        IF (xip1E_13_uid251_sincosTest_s = "1") THEN
            xip1E_13_uid251_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_13_uid251_sincosTest_a) + SIGNED(xip1E_13_uid251_sincosTest_b));
        ELSE
            xip1E_13_uid251_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(xip1E_13_uid251_sincosTest_a) - SIGNED(xip1E_13_uid251_sincosTest_b));
        END IF;
    END PROCESS;
    xip1E_13_uid251_sincosTest_q <= xip1E_13_uid251_sincosTest_o(31 downto 0);

    -- xip1_13_uid258_sincosTest(BITSELECT,257)@2
    xip1_13_uid258_sincosTest_in <= STD_LOGIC_VECTOR(xip1E_13_uid251_sincosTest_q(30 downto 0));
    xip1_13_uid258_sincosTest_b <= STD_LOGIC_VECTOR(xip1_13_uid258_sincosTest_in(30 downto 0));

    -- xSumPreRnd_uid261_sincosTest(BITSELECT,260)@2
    xSumPreRnd_uid261_sincosTest_in <= xip1_13_uid258_sincosTest_b(29 downto 0);
    xSumPreRnd_uid261_sincosTest_b <= xSumPreRnd_uid261_sincosTest_in(29 downto 16);

    -- xSumPostRnd_uid264_sincosTest(ADD,263)@2
    xSumPostRnd_uid264_sincosTest_a <= STD_LOGIC_VECTOR("0" & xSumPreRnd_uid261_sincosTest_b);
    xSumPostRnd_uid264_sincosTest_b <= STD_LOGIC_VECTOR("00000000000000" & VCC_q);
    xSumPostRnd_uid264_sincosTest_o <= STD_LOGIC_VECTOR(UNSIGNED(xSumPostRnd_uid264_sincosTest_a) + UNSIGNED(xSumPostRnd_uid264_sincosTest_b));
    xSumPostRnd_uid264_sincosTest_q <= xSumPostRnd_uid264_sincosTest_o(14 downto 0);

    -- xPostExc_uid269_sincosTest(BITSELECT,268)@2
    xPostExc_uid269_sincosTest_in <= STD_LOGIC_VECTOR(xSumPostRnd_uid264_sincosTest_q(13 downto 0));
    xPostExc_uid269_sincosTest_b <= STD_LOGIC_VECTOR(xPostExc_uid269_sincosTest_in(13 downto 1));

    -- cosPostNeg_uid282_sincosTest(ADDSUB,281)@2
    cosPostNeg_uid282_sincosTest_s <= redist0_invCosNegCond_uid281_sincosTest_q_2_q;
    cosPostNeg_uid282_sincosTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((14 downto 13 => cstZeroForAddSub_uid278_sincosTest_q(12)) & cstZeroForAddSub_uid278_sincosTest_q));
    cosPostNeg_uid282_sincosTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((14 downto 13 => xPostExc_uid269_sincosTest_b(12)) & xPostExc_uid269_sincosTest_b));
    cosPostNeg_uid282_sincosTest_combproc: PROCESS (cosPostNeg_uid282_sincosTest_a, cosPostNeg_uid282_sincosTest_b, cosPostNeg_uid282_sincosTest_s)
    BEGIN
        IF (cosPostNeg_uid282_sincosTest_s = "1") THEN
            cosPostNeg_uid282_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(cosPostNeg_uid282_sincosTest_a) + SIGNED(cosPostNeg_uid282_sincosTest_b));
        ELSE
            cosPostNeg_uid282_sincosTest_o <= STD_LOGIC_VECTOR(SIGNED(cosPostNeg_uid282_sincosTest_a) - SIGNED(cosPostNeg_uid282_sincosTest_b));
        END IF;
    END PROCESS;
    cosPostNeg_uid282_sincosTest_q <= cosPostNeg_uid282_sincosTest_o(13 downto 0);

    -- redist14_firstQuadrant_uid15_sincosTest_b_2(DELAY,300)
    redist14_firstQuadrant_uid15_sincosTest_b_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => firstQuadrant_uid15_sincosTest_b, xout => redist14_firstQuadrant_uid15_sincosTest_b_2_q, ena => en(0), clk => clk, aclr => areset );

    -- xPostRR_uid284_sincosTest(MUX,283)@2
    xPostRR_uid284_sincosTest_s <= redist14_firstQuadrant_uid15_sincosTest_b_2_q;
    xPostRR_uid284_sincosTest_combproc: PROCESS (xPostRR_uid284_sincosTest_s, en, cosPostNeg_uid282_sincosTest_q, sinPostNeg_uid280_sincosTest_q)
    BEGIN
        CASE (xPostRR_uid284_sincosTest_s) IS
            WHEN "0" => xPostRR_uid284_sincosTest_q <= cosPostNeg_uid282_sincosTest_q;
            WHEN "1" => xPostRR_uid284_sincosTest_q <= sinPostNeg_uid280_sincosTest_q;
            WHEN OTHERS => xPostRR_uid284_sincosTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sin_uid286_sincosTest(BITSELECT,285)@2
    sin_uid286_sincosTest_in <= STD_LOGIC_VECTOR(xPostRR_uid284_sincosTest_q(12 downto 0));
    sin_uid286_sincosTest_b <= STD_LOGIC_VECTOR(sin_uid286_sincosTest_in(12 downto 0));

    -- xPostRR_uid283_sincosTest(MUX,282)@2
    xPostRR_uid283_sincosTest_s <= redist14_firstQuadrant_uid15_sincosTest_b_2_q;
    xPostRR_uid283_sincosTest_combproc: PROCESS (xPostRR_uid283_sincosTest_s, en, sinPostNeg_uid280_sincosTest_q, cosPostNeg_uid282_sincosTest_q)
    BEGIN
        CASE (xPostRR_uid283_sincosTest_s) IS
            WHEN "0" => xPostRR_uid283_sincosTest_q <= sinPostNeg_uid280_sincosTest_q;
            WHEN "1" => xPostRR_uid283_sincosTest_q <= cosPostNeg_uid282_sincosTest_q;
            WHEN OTHERS => xPostRR_uid283_sincosTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- cos_uid285_sincosTest(BITSELECT,284)@2
    cos_uid285_sincosTest_in <= STD_LOGIC_VECTOR(xPostRR_uid283_sincosTest_q(12 downto 0));
    cos_uid285_sincosTest_b <= STD_LOGIC_VECTOR(cos_uid285_sincosTest_in(12 downto 0));

    -- xOut(GPOUT,4)@2
    c <= cos_uid285_sincosTest_b;
    s <= sin_uid286_sincosTest_b;

END normal;
