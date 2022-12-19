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


entity mppc_dacs_wrapper_dac088s085 is
	Port (
		------------CLOCK-----------------
	   clk			 : IN  STD_LOGIC;
		------------DAC PARAMETERS--------
		DAC_NUMBER   : IN  STD_LOGIC_VECTOR(3 downto 0);
		DAC_ADDR     : IN  STD_LOGIC_VECTOR(3 downto 0);
		DAC_VALUE    : IN  STD_LOGIC_VECTOR(7 downto 0);
		WRITE_STROBE : IN  STD_LOGIC;
		BUSY	     : out std_logic;
		------------HW INTERFACE----------
		SCK_DAC		 : OUT STD_LOGIC;
		DIN_DAC		 : OUT STD_LOGIC;
		CS_DAC       : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
end mppc_dacs_wrapper_dac088s085;

architecture Behavioral of mppc_dacs_wrapper_dac088s085 is

--	signal i_write      : std_logic;
	signal i_write_I    : std_logic;
	signal i_dac_number : std_logic_vector(3 downto 0);
	signal i_dac_addr   : std_logic_vector(3 downto 0);
	signal i_dac_value  : std_logic_vector(7 downto 0);
	signal i_dac_mask   : std_logic_vector(9 downto 0);
	signal i_sck_dac    : std_logic;
	signal i_din_dac    : std_logic;
	signal i_cs_dac     : std_logic;	

   signal clock          : std_logic;
   signal i_write_strobe : std_logic;
   signal i_hb           : std_logic;

	
begin

   clkk_divv_i : entity work.clkk_divv 
   generic map (
      RATIO => 32
   )
   port map (
      clk       => clk,
      rst       => '0',
      strb      => write_strobe,
      clkdiv    => clock,
      hb        => i_hb,
      sync_strb => i_write_strobe
   );


	process(clk)
	begin
		if rising_edge(clk) then
         i_dac_number <= DAC_NUMBER;
         i_dac_addr   <= DAC_ADDR;
         i_dac_value  <= DAC_VALUE;
		end if;
	end process;

i_mppc_bias_dac088s085: entity work.mppc_bias_dac088s085 
port map(
   clk     => clk,
   clken   => i_hb,
   addr    => i_dac_addr,
   val     => i_dac_value,
   update  => i_write_strobe,
   busy    => busy,
   sclk    => i_sck_dac,
   sync_n  => i_cs_dac,
   din     => i_din_dac
);


	i_dac_mask <= "1111111110" when i_dac_number = x"0" else
	              "1111111101" when i_dac_number = x"1" else
	              "1111111011" when i_dac_number = x"2" else
	              "1111110111" when i_dac_number = x"3" else
	              "1111101111" when i_dac_number = x"4" else
	              "1111011111" when i_dac_number = x"5" else
	              "1110111111" when i_dac_number = x"6" else
	              "1101111111" when i_dac_number = x"7" else
	              "1011111111" when i_dac_number = x"8" else
	              "0111111111" when i_dac_number = x"9" else
				  "1111111111";

	-- outputs
	SCK_DAC <= i_sck_dac;
	DIN_DAC <= i_din_dac;
	cs_bits: for i in 0 to 9 generate
	begin	
		CS_DAC(i) <= i_dac_mask(i) or i_cs_dac;
	end generate;

end Behavioral;
