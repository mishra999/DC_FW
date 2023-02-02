library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library work;
use work.klm_scint_pkg.all; 

ENTITY ShiftOutSample_tb IS
END ShiftOutSample_tb;     
 
ARCHITECTURE behavior OF ShiftOutSample_tb IS 
 
constant clk_period       :  time := 7.87 ns;         

signal clk                : std_logic := '0';
signal ena                : std_logic := '0';
signal busy               : std_logic := '0';
signal force_test_pattern : std_logic := '0';
signal t_samp_addr_settle : std_logic_vector(3 downto 0) := "0110";-- 6
signal t_sr_clk_strobe    : std_logic_vector(3 downto 0) := "0110";-- 6
signal t_strobe_settle    : std_logic_vector(3 downto 0) := "0100";-- 4
signal t_setup_ss_any     : std_logic_vector(3 downto 0) := "0010";-- 2
signal t_sr_clk_high      : std_logic_vector(3 downto 0) := "0010";-- 2
signal t_sr_clk_low       : std_logic_vector(3 downto 0) := "0110";-- 6

-- signal sr_asic_sel        : std_logic_vector(4 downto 0) := (others=>'0');
signal samples_valid      : std_logic := '0';
signal sample_data        : slv12(14 downto 0) := (others=>"000000000000");
signal BUS_DO             : std_logic_vector(14 downto 0) := "101010101010101";
signal SR_CLR             : std_logic := '0';
signal SR_CLK             : std_logic := '0'; -- std_logic_vector(4 downto 0) := (others=>'0');
signal SR_SEL             : std_logic := '0';
signal SAMPLESEL_ANY      : std_logic := '0'; -- std_logic_vector(4 downto 0) := (others=>'0');
-- signal sr_ctrl_state1 :   ASIC_sr_ctrl_fsm;
-- signal sr_ctrl_fsm_ctr1 : std_logic_vector(3 downto 0);
-- signal rx_bits_state1   : ASIC_rx_bits_fsm; 


BEGIN

UUT : entity work.ShiftOutSample
generic map (
  num_bits_wilk_adc => 12
)
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
  -- sr_asic_sel        => sr_asic_sel,
  samples_valid      => samples_valid,
  sample_data        => sample_data,
  BUS_DO             => BUS_DO,
  SR_CLR             => SR_CLR,
  SR_CLK             => SR_CLK,
  SR_SEL             => SR_SEL,
  SAMPLESEL_ANY      => SAMPLESEL_ANY
  -- sr_ctrl_state1  => sr_ctrl_state1,
  -- sr_ctrl_fsm_ctr1  => sr_ctrl_fsm_ctr1, 
  -- rx_bits_state1  => rx_bits_state1
);


  --!  Test Bench Statements
    clk_process : process 
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process clk_process;

    stimProcess : PROCESS
    BEGIN
        wait for 400 ns; --! wait until global set/reset completes

        -- force_test_pattern <= '0';
        -- sr_asic_sel <= "00001";  
        ena <= '1';
        force_test_pattern <= '1';
        wait for clk_period;
        ena <= '0';
        force_test_pattern <= '0';
        wait for clk_period;

        wait; --! will wait forever
    END PROCESS stimProcess;
  --!  End Test Bench 

  END;
