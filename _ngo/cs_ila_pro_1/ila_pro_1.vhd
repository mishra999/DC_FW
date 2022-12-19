-------------------------------------------------------------------------------
-- Copyright (c) 2022 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : ila_pro_1.vhd
-- /___/   /\     Timestamp  : Tue Nov 29 01:19:51 UTC 2022
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY ila_pro_1 IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    TRIG0: in std_logic_vector(0 to 0);
    TRIG1: in std_logic_vector(0 to 0));
END ila_pro_1;

ARCHITECTURE ila_pro_1_a OF ila_pro_1 IS
BEGIN

END ila_pro_1_a;
