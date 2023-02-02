library IEEE;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library work;
use work.klm_scint_pkg.all;
  
-- c.ketter. 2021/10/12: Tested sync of SSTIN_P with release of BUSA_WR_ADDRCLR,
-- Made sure behavior is consistent by first delaying reset by one clock,
-- and second by delaying ctime by one clock.
  
  
ENTITY SamplingMask_tb IS
END SamplingMask_tb;

ARCHITECTURE behavior OF SamplingMask_tb IS  

constant clk_period       :  time := 7.87 ns;         
signal clk             : std_logic;
signal reset           : std_logic := '0';
-- signal sync_bit        : std_logic := '0';
-- signal ctime64ns_bit   : std_logic := '0';
signal ana_wr_ena_mask : TARGETX_analong_wr_ena_mask_t := null_TX_ana_wr_ena_mask;
signal BUSA_WR_ADDRCLR : std_logic := '0';
signal BUSB_WR_ADDRCLR : std_logic := '0';
signal WR1_ENA         : std_logic_vector(9 downto 0) := (others=>'1');
signal WR2_ENA         : std_logic_vector(9 downto 0) := (others=>'1');
signal SSTIN_N         : std_logic_vector(9 downto 0) := (others=>'0');
signal SSTIN_p         : std_logic_vector(9 downto 0) := (others=>'1');
signal i_ctime : std_logic_vector(5 downto 0) ;  --added by me
signal ctime : std_logic_vector(26 downto 0) := "000000000000000011111100111"; --2023
signal cur_win          : std_logic_vector(8 downto 0) := "000000000";
signal cur_win_ii       :  std_logic_vector(8 downto 0) := "000000000";
 
BEGIN

UUT : entity work.SamplingLgc
port map (
        clk             => clk,
        reset           => reset,
        sync_bit        => ctime(11), --it goes 1 at ctime=2048
        ctime64ns_bit   => ctime(2),  
        ana_wr_ena_mask => ana_wr_ena_mask,
        cur_win         => cur_win,
        BUSA_WR_ADDRCLR => BUSA_WR_ADDRCLR,
        BUSB_WR_ADDRCLR => BUSB_WR_ADDRCLR,
        WR1_ENA         => WR1_ENA,
        WR2_ENA         => WR2_ENA,
        SSTIN_N         => SSTIN_N,
        SSTIN_p         => SSTIN_p,
        i_ctime         => i_ctime, -- this is one clk period behind, just for checking, no worries!
        cur_win_ii    => cur_win_ii
);



  --!  Test Bench Statements
    clk_process : process 
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process clk_process;

    ctime_gen : process(clk, ctime)
    begin
        if rising_edge(clk) then
            ctime <= ctime + "1";
        end if;
    end process ctime_gen;

    stimProcess : PROCESS
    BEGIN
        wait for 120 ns; --! wait until global set/reset completes
        wait until clk = '1';
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period*10;
        -- to see that mask is working, 
        -- have to read ctime 11:0 from ISIM,
        -- then choose a window that is in the next 100 clocks.
        ana_wr_ena_mask <= ('1','0',"000000011","000000001");
        wait for clk_period;
        ana_wr_ena_mask <= ('0','0',"000000000","000000000");
        wait for clk_period*22;
        ana_wr_ena_mask <= ('1','1',"000000011","000000001");
        wait for clk_period;
        ana_wr_ena_mask <= ('0','0',"000000000","000000000");

        wait for clk_period*10;
        
        wait;

    END PROCESS stimProcess;
  --!  End Test Bench 

  END;
