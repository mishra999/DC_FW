

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.UtilityPkg.all;

entity Encode8b10b_test is 

end Encode8b10b_test;

architecture rtl of Encode8b10b_test is 
   -- signal clk : sl;
   signal clkEn : sl := '1';
   signal rst     : sl := '0';
   signal dataIn     : slv(7 downto 0):= (others => '0');
   signal dataKIn : sl := '0';
   -- signal dispIn  : sl;
   signal dataOut : slv(9 downto 0);
   -- signal dispOut : sl;
   signal DATA_CLK :sl;
   signal txDisp     : sl := '0';
   signal txDisp1     : sl := '0';

   constant DATA_CLK_period : time := 40 ns;
begin
   -- txDisp1 <=txDisp;
	-- Instantiate the Unit Under Test (UUT)
   uut1: entity work.Encode8b10b PORT MAP (

      clk => DATA_CLK,
      clkEn => clkEn,
      rst => rst,
      dataIn => dataIn,
      dataKIn => dataKIn,
      dispIn => txDisp,
      dataOut => dataOut,
      dispOut => txDisp
   );

   -- Clock process definitions
   DATA_CLK_process :process
   begin
		DATA_CLK <= '0';
		wait for DATA_CLK_period/2;
		DATA_CLK <= '1';
		wait for DATA_CLK_period/2;
   end process;

   stim_proc: process
   begin		

      -- wait for 100 ns;
      -- txDisp<= '0';
      wait for DATA_CLK_period*10;
		dataIn <= x"BC";
      dataKIn <='1';
      -- txDisp1<= '0';
      -- txDisp1 <=txDisp;
      wait for DATA_CLK_period*1;
		dataIn <= x"BC";
      dataKIn <='1';
      -- txDisp1 <=txDisp;
      wait for DATA_CLK_period*1;      
		dataIn <= x"BC";
      dataKIn <='1';
      wait for DATA_CLK_period*1;
		dataIn <= x"BC";
      dataKIn <='1';
      wait for DATA_CLK_period*1;
		dataIn <= x"BC";
      dataKIn <='1';
      wait for DATA_CLK_period*1;
		dataIn <= x"00";
      dataKIn <='0';
      wait for DATA_CLK_period*1;
		dataIn <= x"00";
      dataKIn <='0';
      wait for DATA_CLK_period*1;
		dataIn <= x"00";
      dataKIn <='0';
      wait for DATA_CLK_period*1;
		dataIn <= x"03";
      dataKIn <='0';
      wait for DATA_CLK_period*1;
		dataIn <= x"BC";
      dataKIn <='1';
      wait for DATA_CLK_period*1;
   end process;
   
end rtl;

