library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all; 

ENTITY DigitizeAndShiftOutData_tb IS
END DigitizeAndShiftOutData_tb;

ARCHITECTURE behavior OF DigitizeAndShiftOutData_tb IS 
 
constant clk_period       :  time := 7.87 ns;         
   
signal clk                : std_logic := '0';
signal ena                : std_logic := '0';
signal busy               : std_logic := '0';
--by me 
signal win_samp_start_asic :  std_logic_vector(13 downto 0) := (others=>'0'); -- slv14(4 downto 0) := (others => (others=>'0'));
-- samp_start            : in  slv5(4 downto 0) := (others => "00000");
signal asic_mask           : std_logic := '1'; -- std_logic_vector(4 downto 0) := (others=>'0');
signal first_dig_win       : std_logic_vector(8 downto 0) := (others=>'0');
signal last_dig_win        : std_logic_vector(8 downto 0) := (others=>'0');

-- signal win_start          : std_logic_vector(8 downto 0) := (others=>'0'); --by me
-- signal samp_start         : std_logic_vector(4 downto 0) := (others=>'0'); --by me
-- signal asic_mask          : std_logic_vector(4 downto 0) := (others=>'0'); -- by me
signal sample_data        : slv12(14 downto 0) := (others=>"000000000000");
signal samples_valid      : std_logic := '0';
signal ramp_length        : std_logic_vector (5 downto 0) := "000111"; -- std_logic_vector (11 downto 0) := x"f00";
-- signal force_test_pattern : std_logic := '0';
signal t_samp_addr_settle : std_logic_vector(3 downto 0) := "0110";
signal t_setup_ss_any     : std_logic_vector(3 downto 0) := "0110";
signal t_strobe_settle    : std_logic_vector(3 downto 0) := "0100";
signal t_sr_clk_high      : std_logic_vector(3 downto 0) := "0010";
signal t_sr_clk_low       : std_logic_vector(3 downto 0) := "0010";
signal t_sr_clk_strobe    : std_logic_vector(3 downto 0) := "0110";
signal N_readout_samples  : std_logic_vector(7 downto 0) := "01100000";
signal BUS_RD_ENA         : std_logic := '0';
signal BUS_CLR            : std_logic := '0';
signal BUS_RAMP           : std_logic := '0';
signal BUS_RD_WINSEL      : std_logic_vector(8 downto 0) := (others=>'0');
signal BUS_DO             : std_logic_vector(14 downto 0) := (others=>'0');
signal SR_CLR             : std_logic := '0';
signal SR_CLK             : std_logic := '0'; -- std_logic_vector(4 downto 0) := (others=>'0');
signal SR_SEL             : std_logic := '0';
signal SAMPLESEL          : std_logic_vector(4 downto 0) := (others=>'0');
signal SAMPLESEL_ANY      : std_logic := '0'; -- std_logic_vector(4 downto 0) := (others=>'0');
signal ShiftOutWinBusy   : std_logic := '0';
signal ShiftOutSampBusy    : std_logic := '0';
signal digNshift_state1 : digitize_and_shift_out_window_data := IDLE;

BEGIN

UUT : entity work.DigitizeAndShiftOutData 
port map (
        clk                => clk,
        ena                => ena,
        busy               => busy,
        first_dig_win   => first_dig_win ,
        last_dig_win   => last_dig_win,
        win_samp_start_asic   => win_samp_start_asic,
        -- win_start          => win_start,
        -- samp_start         => samp_start, --by me
        asic_mask          => asic_mask,
        sample_data        => sample_data,
        samples_valid      => samples_valid,
        ramp_length        => ramp_length,
        ShiftOutWinBusy    => ShiftOutWinBusy,
        ShiftOutSampBusy   => ShiftOutSampBusy,
        -- force_test_pattern => force_test_pattern,
        t_samp_addr_settle => t_samp_addr_settle,
        t_setup_ss_any     => t_setup_ss_any,
        t_strobe_settle    => t_strobe_settle,
        t_sr_clk_high      => t_sr_clk_high,
        t_sr_clk_low       => t_sr_clk_low,
        t_sr_clk_strobe    => t_sr_clk_strobe,
        N_readout_samples  => N_readout_samples,
        BUS_RD_ENA         => BUS_RD_ENA,
        BUS_CLR            => BUS_CLR,
        BUS_RAMP           => BUS_RAMP,
        BUS_RD_WINSEL      => BUS_RD_WINSEL,
        BUS_DO             => BUS_DO,
        SR_CLR             => SR_CLR,
        SR_CLK             => SR_CLK,
        SR_SEL             => SR_SEL,
        SAMPLESEL          => SAMPLESEL,
        SAMPLESEL_ANY      => SAMPLESEL_ANY
        -- digNshift_state1   => digNshift_state1

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

        -- N_readout_samples <= "10000000"; -- 128
        asic_mask <= '1';
        first_dig_win <= "111111110";
        last_dig_win <= "000000001";
          
        -- samp_start <= "01100";
        -- win_start <= "111111110";
        -- win_samp_start_asic <= "11111111001100";
        wait for clk_period;
        ena <= '1'; 
        wait for clk_period;
        ena <= '0';
        wait for clk_period;
        
        wait for clk_period*39400;

        -- N_readout_samples <= "01100000"; -- 96
        asic_mask <= '1';
        first_dig_win <= "000000000";
        last_dig_win <= "000000001";
        -- samp_start <= "00000";
        -- win_start <= "000000000";
        ena <= '1'; 
        wait for clk_period;
        ena <= '0';
        wait for clk_period;
        

        wait; --! will wait forever
    END PROCESS stimProcess;

  END;
