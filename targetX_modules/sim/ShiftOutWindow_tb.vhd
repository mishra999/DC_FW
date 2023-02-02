library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all;

ENTITY ShiftOutWindow_tb IS 
END ShiftOutWindow_tb;
 
ARCHITECTURE behavior OF ShiftOutWindow_tb IS 

constant clk_period       :  time := 7.87 ns;         
  
signal clk                : std_logic := '0';
signal ena                : std_logic := '0';
signal busy               : std_logic := '0';
signal force_test_pattern : std_logic := '0';
signal t_samp_addr_settle : std_logic_vector(3 downto 0) := "0110";
signal t_setup_ss_any     : std_logic_vector(3 downto 0) := "0110";
signal t_strobe_settle    : std_logic_vector(3 downto 0) := "0100";
signal t_sr_clk_high      : std_logic_vector(3 downto 0) := "0010";
signal t_sr_clk_low       : std_logic_vector(3 downto 0) := "0010";
signal t_sr_clk_strobe    : std_logic_vector(3 downto 0) := "0110";
signal asic_mask          : std_logic := '1'; --std_logic_vector(4 downto 0) := (others=>'0');
-- signal initial_sample     : std_logic_vector(4 downto 0) := (others=>'0');
-- signal final_sample       : std_logic_vector(4 downto 0) := (others=>'0');
signal samp_start_asic    : std_logic_vector(4 downto 0) := (others=>'0'); --slv5(4 downto 0) := (others=>(others=>'0'));
signal samp_stop_asic     : std_logic_vector(4 downto 0) := (others=>'1'); --slv5(4 downto 0) := (others=>(others=>'1'));
signal samples_valid       : std_logic := '0';
-- signal samples_sel        : std_logic_vector(4 downto 0) := (others=>'0');
signal sample_data        : slv12(14 downto 0) := (others=>"000000000000");
signal current_asic       : std_logic_vector(4 downto 0) := (others=>'0');
signal BUS_DO             : std_logic_vector(14 downto 0) := "101010101010101";
signal SR_CLR             : std_logic := '0';
signal SR_CLK             : std_logic := '0'; -- std_logic_vector(4 downto 0) := (others=>'0');
signal SR_SEL             : std_logic := '0';
signal SAMPLESEL          : std_logic_vector(4 downto 0) := (others=>'0');
signal SAMPLESEL_ANY      : std_logic := '0'; -- std_logic_vector(4 downto 0) := (others=>'0');
-- signal shift_win_state1 : shift_out_window_data := IDLE;
 
BEGIN

UUT : entity work.ShiftOutWindow
port map (
        clk                => clk,
        ena                => ena,
        busy               => busy,
        force_test_pattern => force_test_pattern,
        t_samp_addr_settle => t_samp_addr_settle,
        t_setup_ss_any     => t_setup_ss_any,
        t_strobe_settle    => t_strobe_settle,
        t_sr_clk_high      => t_sr_clk_high,
        t_sr_clk_low       => t_sr_clk_low,
        t_sr_clk_strobe    => t_sr_clk_strobe,
        asic_mask          => asic_mask,
        -- initial_sample     => initial_sample,
        -- final_sample       => final_sample,
        samp_start_asic => samp_start_asic,
        samp_stop_asic => samp_stop_asic,
        samples_valid      => samples_valid,
        -- sample_sel         => samplesel,
        sample_data        => sample_data,
        -- current_asic       => current_asic,
        BUS_DO             => BUS_DO,
        SR_CLR             => SR_CLR,
        SR_CLK             => SR_CLK,
        SR_SEL             => SR_SEL,
        SAMPLESEL          => SAMPLESEL,
        SAMPLESEL_ANY      => SAMPLESEL_ANY
        -- shift_win_state1  => shift_win_state1
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
        force_test_pattern <= '1';
        -- asic_mask      <= "10001";
        samp_start_asic <= "00000"; -- slv5(4 downto 0) := (others=>(others=>"01100"));
        samp_stop_asic <= "11111";
        -- initial_sample <= "01100";
        -- final_sample   <= "11111";
        wait for clk_period;
        ena <= '0';
        wait for clk_period;

        wait for clk_period*10000;
        ena <= '1';
        -- asic_mask      <= "01000";
        samp_start_asic <= "00000";
        samp_stop_asic   <= "01011";
        wait for clk_period;
        ena <= '0';
        wait for clk_period;



        wait; --! will wait forever
    END PROCESS stimProcess;

  END;
