library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all;

ENTITY DigitizingLgcTX_tb IS
END DigitizingLgcTX_tb;
 
ARCHITECTURE behavior OF DigitizingLgcTX_tb IS 

constant clk_period       :  time := 7.87 ns;         

signal clk         : std_logic := '0';
signal rst         : std_logic := '0';
signal ena         : std_logic := '0';
signal busy        : std_logic := '0';
signal ramp_length : std_logic_vector (11 downto 6) := "000111";
signal BUS_RD_ENA  : std_logic := '0';
signal BUS_CLR     : std_logic := '0';
signal BUS_RAMP    : std_logic := '0';
 

BEGIN

UUT : entity work.DigitizingLgcTX
port map (
        clk         => clk,
        ena         => ena,
        ramp_length => ramp_length,
        busy        => busy,
        BUS_RD_ENA  => BUS_RD_ENA,
        BUS_CLR     => BUS_CLR,
        BUS_RAMP    => BUS_RAMP
);



    clk_process : process 
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process clk_process;

    stimProcess : PROCESS
    BEGIN
        wait for 100 ns; --! wait until global set/reset completes

        ena <= '1';
 
        wait for clk_period;
        ena <= '0';
        wait for clk_period;

        wait; --! will wait forever
    END PROCESS stimProcess;

  END;
