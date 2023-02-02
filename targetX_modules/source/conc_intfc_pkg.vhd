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
-- Package for Belle-II KLM SCROD Data Concentrator interface.
--
--*********************************************************************************
library ieee;
    use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
--	use ieee.std_logic_arith.all;
--	use ieee.std_logic_unsigned.all;
	use ieee.math_real.all;


package conc_intfc_pkg is

    --------------------------------------------------------------------------
	-- Constant declarations.
    --------------------------------------------------------------------------
    -- define number of TARGET channels used for TDC/trigger processing
    constant ASIC_NUM_CHAN              : integer range 1 to 15             := 15;    
    -- define number of config + status registers
    constant NUM_SCROD_REGS             : integer                           := 72;
    -- define number of control registers
    constant NUM_CTRL_REGS              : integer                           := 2;    
    -- default axis bit value - defines the axis to be used by coincidence find
    constant AXIS_BIT_VAL               : std_logic                         := '0';        
    -- packet type counter width - sets time spent writing trigger data
    constant PKTTP_CTRW                 : integer                           := 7;        
    constant TGPKT_CTRW                 : integer                           := 6;
    constant STSPKT_CTRW                : integer                           := INTEGER(CEIL(LOG2(REAL(NUM_SCROD_REGS))));
    
    constant TRG_SOF_VAL                : std_logic_vector(15 downto 0)   := X"FE11";
    constant TRG_EOF_VAL                : std_logic_vector(15 downto 0)   := X"EFAA";
    constant DAQ_SOF_VAL                : std_logic_vector(15 downto 0)   := X"FE88";
    constant DAQ_EOF_VAL                : std_logic_vector(15 downto 0)   := X"EF55";        
    constant STS_SOF_VAL                : std_logic_vector(15 downto 0)   := X"FE66";
    constant STS_EOF_VAL                : std_logic_vector(15 downto 0)   := X"EF99";    
            
--	constant intc				    : integer 	:= INTEGER(CEIL(LOG2(REAL(SC_NUM_SCR))));
--	constant intc				    : integer 	:= (2**(SC_SCR_BITS+1));

    --------------------------------------------------------------------------
	-- Type declarations.
    --------------------------------------------------------------------------
    type stat_reg_type is array (0 to NUM_SCROD_REGS-1) of std_logic_vector(15 downto 0);
    type ctrl_reg_type is array (0 to NUM_CTRL_REGS-1) of std_logic_vector(15 downto 0);

	   type trigasic_bram_wr_data_type is array (1 to 10) of std_logic_vector(4 downto 0); -- trigger bits from 

    type trigasic_bram_asic_rd_data_type is array (3 downto 0) of std_logic_vector(4 downto 0);
    type trigasic_bram_rd_data_type is array (1 to 10) of trigasic_bram_asic_rd_data_type;

    --------------------------------------------------------------------------
	-- Function declarations.
    --------------------------------------------------------------------------


end conc_intfc_pkg;

--------------------------------------------------------------------------
-- Package body
--------------------------------------------------------------------------
package body conc_intfc_pkg is


end conc_intfc_pkg;


