--*********************************************************************************
-- Indiana University
-- Center for Exploration of Energy and Matter (CEEM)
--
-- Project: Belle-II
--
-- Author:  Brandon Kunkler
--
-- Date:    06/04/2014
--
--*********************************************************************************
-- Description:
--
-- Package for KLM SCROD high level constants and functions.
--
--*********************************************************************************
library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.b2tt_symbols.all;    

package klm_scrod_pkg is
    --------------------------------------------------------------------------
    -- Constant declarations.
    --------------------------------------------------------------------------
    constant B2TT_SUBSYSTEM                 : std_logic_vector (3 downto 0)     := TTFEE_KLM;
    constant B2TT_FWTYPE                    : integer                           := 15;
    constant B2TT_VERSION                   : integer                           := 9;
    constant B2TT_B2TT_VER                  : integer                           := 52;
    constant B2TT_PROTOCOL                  : integer                           := 30;
    constant B2TT_COMPAT                    : integer                           := 29; -- for transition to new protocol    
    constant B2TT_DEFADDR                   : std_logic_vector (19 downto 0)    := x"00000";
    constant B2TT_FLIPCLK                   : std_logic                         := '0';  -- no more used
    constant B2TT_FLIPTRG                   : std_logic                         := '0';
    constant B2TT_FLIPACK                   : std_logic                         := '0';
    constant B2TT_USEFIFO                   : std_logic                         := '1';
    constant B2TT_CLKDIV1                   : integer range 1 to 72             := 2;
    constant B2TT_CLKDIV2                   : integer range 1 to 72             := 4;
    constant B2TT_USEPLL                    : std_logic                         := '1';
    constant B2TT_USEICTRL                  : std_logic                         := '1';
    constant B2TT_NBITTIM                   : integer range 1 to 32             := 32;
    constant B2TT_NBITTAG                   : integer range 4 to 32             := 32;
    constant B2TT_NBITID                    : integer range 4 to 32             := 16;
    constant B2TT_B2LRATE                   : integer                           := 4;  -- 127 Mbyte / s
    constant B2TT_USEEXTCLK                 : std_logic                         := '0';
    constant B2TT_USE254IN                  : std_logic                         := '0'; -- 254 MHz clock in for DHH    
    
    type Aurora_Status_t is record
        gtlock               : std_logic;
        hard_err             : std_logic;
        soft_err             : std_logic;
        frame_err            : std_logic;
        channel_up           : std_logic;
        lane_up              : std_logic;
        warn_cc              : std_logic;
        do_cc                : std_logic;
    end record;
    
    type SFP_Status_t is record
        fault_flag           : std_logic;
        los_flag             : std_logic;
        mod_flag             : std_logic;
    end record;
    
end klm_scrod_pkg;

package body klm_scrod_pkg is

end klm_scrod_pkg;