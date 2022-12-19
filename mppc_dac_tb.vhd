----------------------------------------------------------------------------------
-- Company: University of Hawaii at Manoa
-- Engineer: Bostjan Macek
-- Updated: Isar Morstafanezhad for DAC in RHIC RevC- 5/28/2015
--          Added simple clock divider inside module 2018/12/24 -- Vasily
-- Create Date:    14:22:21 02/18/2014 
----------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
use work.all; 


entity mppc_dacs_wrapper_dac088s085_tb is

end mppc_dacs_wrapper_dac088s085_tb;

architecture Behavioral of mppc_dacs_wrapper_dac088s085_tb is

--	signal i_write      : std_logic;
	-- signal i_write_I    : std_logic;
	signal dac_number : std_logic_vector(3 downto 0);
	signal dac_addr   : std_logic_vector(3 downto 0);
	signal dac_value  : std_logic_vector(7 downto 0);
	-- signal i_dac_mask   : std_logic_vector(9 downto 0);
	signal sck_dac    : std_logic;
	signal din_dac    : std_logic;
	signal cs_dac     : std_logic_vector(9 downto 0);

   signal DATA_CLK : std_logic := '0';
   signal write_strobe : std_logic;
   signal busy           : std_logic;

   constant DATA_CLK_period : time := 40 ns;
	
begin

   mppc_wrapper_i : entity work.mppc_dacs_wrapper_dac088s085
   port map (
		------------CLOCK-----------------
	   clk	   => DATA_CLK,
		------------DAC PARAMETERS--------
		DAC_NUMBER    => dac_number,
		DAC_ADDR  => dac_addr,
		DAC_VALUE => dac_value,
		WRITE_STROBE => write_strobe,
		BUSY	=> busy,
		------------HW INTERFACE----------
		SCK_DAC	=> sck_dac,
		DIN_DAC	=> din_dac,
		CS_DAC  => cs_dac 
	);

   -- Clock process definitions
   DATA_CLK_process :process
   begin
		DATA_CLK <= '0';
		wait for DATA_CLK_period/2;
		DATA_CLK <= '1';
		wait for DATA_CLK_period/2;
   end process;



   -- Stimulus process
   stim_proc: process
   begin		

      wait for 100 ns;	
      wait for DATA_CLK_period*10;
	  dac_number <= x"0";
      dac_addr <= "1010";
      dac_value <= x"AC";
      write_strobe <= '1';
      wait for DATA_CLK_period*1;
      write_strobe <= '0';
      wait for DATA_CLK_period*10;
      wait;
    end process;

end Behavioral;
