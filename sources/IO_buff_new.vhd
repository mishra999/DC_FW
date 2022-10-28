----------------------------------------------------------------------------------
-- Company: University of Hawaii Instrumentation Development Lab
-- Engineer: Mudit Mishra
-- 
-- Create Date:    06:33:03 09/02/2022 
-- Design Name: 
-- Module Name:    IO_Buffers - Behavioral 
-- Project Name:  Hawaii Muon Beamline
-- Target Devices: Spartan6 xc6slx150
-- Tool versions: ISE 14.7
-- Description: Buffers for differential IO signals. For 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity IO_Buffers_new is
	generic (
		num_DC : integer := 0 --highest index in DC signal vectors: (# of DCs) - 1  
		);
    Port ( RX_P : in  STD_LOGIC_VECTOR (num_DC downto 0);
           RX_N : in  STD_LOGIC_VECTOR (num_DC downto 0);
           TX : in  STD_LOGIC_VECTOR (num_DC downto 0);

		--    DATA_CLK_P : in STD_LOGIC_VECTOR (num_DC downto 0);
		--    DATA_CLK_N : in STD_LOGIC_VECTOR (num_DC downto 0);
		--    DATA_CLK : out STD_LOGIC; --by me

			--   GLOB_EVNT : in STD_LOGIC_VECTOR(3 downto 0);
        --    SYNC : in  STD_LOGIC_VECTOR (num_DC downto 0); --Universal sync signal
           TX_P : out  STD_LOGIC_VECTOR (num_DC downto 0);
           TX_N : out  STD_LOGIC_VECTOR (num_DC downto 0);
		-- 	  DC_CLK_P : out  STD_LOGIC_VECTOR (num_DC downto 0); --by me
        --    DC_CLK_N : out  STD_LOGIC_VECTOR (num_DC downto 0); --by me
           RX : out  STD_LOGIC_VECTOR (num_DC downto 0);
           SYNC_P : in  STD_LOGIC_VECTOR (num_DC downto 0);
           SYNC_N : in  STD_LOGIC_VECTOR (num_DC downto 0);
		   SYNC : out  STD_LOGIC_VECTOR (num_DC downto 0));
			--   GLOB_EVNT_P : out STD_LOGIC_VECTOR(3 downto 0);
			--   GLOB_EVNT_N : out STD_LOGIC_VECTOR(3 downto 0));
end IO_Buffers_new;
 
architecture Behavioral of IO_Buffers_new is
-- signal dc_clk : STD_LOGIC_VECTOR(num_DC downto 0);
begin
Gen_buffers : for I in num_DC downto 0 generate 
	RX_IBUF_inst : IBUFDS -- input buffer: serial data from scrod
	generic map (
	    --  DIFF_TERM    => TRUE, -- Differential Termination is not available on board
	     IOSTANDARD => "LVDS_25" 
	     )
	port map (
		O => RX(I),
		I => RX_P(I),
		IB => RX_N(I));

			
	TX_OBUFDS_inst : OBUFDS --output buffer: serial data to scrod
	generic map (IOSTANDARD => "LVDS_25")
	port map (
		O  => TX_P(I),    
		OB => TX_N(I),  
		I  => TX(I)); 


	SYNC2_IBUFDS_inst : IBUFDS -- input buffer: serial data from scrod
	generic map (
	    --  DIFF_TERM    => TRUE, -- Differential Termination is not available on board
	     IOSTANDARD => "LVDS_25" 
	     )
	port map (
		O => SYNC(I),
		I => SYNC_P(I),
		IB => SYNC_N(I));

	-- SYNC1_OBUFDS_inst : OBUFDS -- sync to DC 1
	-- generic map ( IOSTANDARD => "LVDS_25")
	-- port map (
	-- 	O => SYNC_P(I),
	-- 	OB => SYNC_N(I),
	-- 	I => SYNC(I));

	-- DATA_CLK_IBUFDS : IBUFDS -- input buffer: sys clock for qblink , from meeeeeeeeeeeee
	-- generic map (
	--     --  DIFF_TERM    => TRUE, -- Differential Termination is not available on board
	--      IOSTANDARD => "LVDS_25" 
	--      )
	-- port map (
	-- 	O => DATA_CLK,
	-- 	I => DATA_CLK_P(I),
	-- 	IB => DATA_CLK_N(I));


-- DC_CLK_ODDR2 : ODDR2  --use ODDR2 with internal data clk to generate dc_clk
--    generic map(
--       DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1" 
--       INIT => '0', -- Sets initial state of the Q output to '0' or '1'
--       SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
--    port map (
--       Q => dc_clk(I), -- 1-bit output data
--       C0 => DATA_CLK, -- 1-bit clock input
--       C1 => not DATA_CLK, -- 1-bit clock input
--       CE => '1',  -- 1-bit clock enable input
--       D0 => '1',   -- 1-bit data input (associated with C0)
--       D1 => '0',   -- 1-bit data input (associated with C1)
--       R => '0',    -- 1-bit reset input
--       S => '0'     -- 1-bit set input
--    ); --by me


-- DC_CLK_OBUFDS : OBUFDS --ODDR2 generated dc_clk buffered OBUFDS to drive output Clocks to DCs.
-- generic map (IOSTANDARD => "LVDS_25")
-- port map (
-- 		O => DC_CLK_P(I),
-- 		OB => DC_CLK_N(I),
-- 		I => dc_clk(I)); --by me
	
end generate Gen_buffers;

--HODOSCOPE Specific (verify) --me
-- Gen_PMT_trig_buf : for L in 3 downto 0 generate
-- 		PMT_trig_OBUFDS : OBUFDS 
-- 		generic map (IOSTANDARD => "LVDS_25")
-- 		port map (
-- 			O  => GLOB_EVNT_P(L),    
-- 			OB => GLOB_EVNT_N(L),  
-- 			I  => GLOB_EVNT(L));
-- end generate Gen_PMT_trig_buf;
end Behavioral;

