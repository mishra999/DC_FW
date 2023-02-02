library IEEE;
use IEEE.std_logic_1164.ALL;  
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_UNSIGNED.ALL; 
Library work; 
use work.klm_scint_pkg.all;   

entity SingleBusProcessing_tb is   
end SingleBusProcessing_tb;

architecture behavior of SingleBusProcessing_tb is 

constant clk_period       :  time := 7.87 ns;         
signal clk                : std_logic := '0';
signal rst                : std_logic := '0';
signal mode               : std_logic_vector(2 downto 0) := (others => '0');
signal ena                : std_logic := '0';
signal asic_mask          : std_logic := '1';
signal first_dig_win      : std_logic_vector(8 downto 0);
signal last_dig_win       : std_logic_vector(8 downto 0);

signal  force_test_pattern    :std_logic := '0';
signal  t_samp_addr_settle    :std_logic_vector(3 downto 0) := "0110";-- 6
signal  t_setup_ss_any        : std_logic_vector(3 downto 0) := "0110";-- 6
signal  t_strobe_settle       :std_logic_vector(3 downto 0) := "0100";-- 4
signal   t_sr_clk_high         : std_logic_vector(3 downto 0) := "0010";-- 2
signal  t_sr_clk_low          : std_logic_vector(3 downto 0) := "0010";-- 2
signal   t_sr_clk_strobe       : std_logic_vector(3 downto 0) := "0110";-- 6
        -- status registers
signal  debug_we              : std_logic := '0';
signal  debug_wave            : std_logic_vector(11 downto 0) := (others => '0');
signal  debug_pfull           :  std_logic := '0';
        -- DigStoreProcBusy      : out std_logic := '0';
signal  DigNShiftBusy         : std_logic := '0';
        -- DigBusy               : out std_logic := '0';
signal  ShiftOutWinBusy       : std_logic := '0';
signal  ShiftOutSampBusy      : std_logic := '0';
        -- FeatExtBusy           : out std_logic := '0';
        -- PedFetchQueueBusy     : out std_logic := '0';

        -- qblink
signal  right2left            : std_logic := '0';
signal  left2right            : std_logic := '0';

signal win_start          : std_logic_vector(8 downto 0) := (others => '0');
signal samp_start         : std_logic_vector(4 downto 0) := (others => '0');
signal trig_bits          : slv5(4 downto 0) := (others=> "00000");
signal ped_fetch_asic_no  : std_logic_vector(2 downto 0) := (others => '0');
signal ped_fetch_chan     : std_logic_vector(3 downto 0) := (others => '0');
signal ped_fetch_ena      : std_logic := '0';
signal ped_fetch_ack      : std_logic := '0';
signal ped_fifo_wr_asic   : std_logic_vector(4 downto 0) := (others => '0');
signal ped_fifo_wr_chan   : std_logic_vector(3 downto 0) := (others => '0');
signal ped_fifo_wr_ena    : std_logic := '0';
signal ped_fifo_din       : std_logic_vector(11 downto 0) := (others => '0');
signal BUS_RD_ENA         : std_logic := '0';
signal BUS_RAMP           : std_logic := '0';
signal BUS_CLR            : std_logic := '0';
signal BUS_DO             : std_logic_vector(14 downto 0) := (others => '0');
signal SR_CLR             : std_logic := '0';
signal SR_CLK             : std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');
signal SR_SEL             : std_logic := '0';
signal BUS_RD_WINSEL      : std_logic_vector(8 downto 0) := (others => '0');
signal SAMPLESEL          : std_logic_vector(4 downto 0) := (others => '0');
signal SAMPLESEL_ANY      : std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');
signal busy_status        : std_logic_vector(4 downto 0) := (others => '0');
signal rx_features_ack    : std_logic := '0';
signal rx_features_ena    : std_logic := '0';
signal last_hit           : std_logic := '0';
signal charge             : std_logic_vector(11 downto 0) := (others => '0');
signal le_time            : std_logic_vector(13 downto 0) := (others => '0');
signal daq_chan           : std_logic_vector(6 downto 0) := (others => '0');
signal ramp_length        : std_logic_vector(11 downto 6) := (others => '0');
-- signal force_test_pattern : std_logic := '0';
signal N_readout_samples  : std_logic_vector(8 downto 0) := "010000000";
signal LE_time_thresh     : std_logic_vector(11 downto 0) := "110100010110";
signal N_bits_avg         : std_logic_vector(3 downto 0) := (others=>'0');
signal prime_fifos        : std_logic := '0';
signal summing_ena        : std_logic := '0';
signal avg_peds_ena       : std_logic := '0';
signal avg_peds_busy      : std_logic := '0';
signal wr_peds2sram_ena   : std_logic := '0';
signal wr_peds2sram_ack   : std_logic := '0';
signal even_ped           : std_logic_vector(11 downto 0) := (others => '0');
signal odd_ped            : std_logic_vector(11 downto 0) := (others => '0');
signal sram_asic_addr     : std_logic_vector(2 downto 0);
signal sram_chan_addr     : std_logic_vector(3 downto 0);

signal  baseline_g             : std_logic_vector(11 downto 0) := "110000000000";  -- 3072
signal  SLOW_CTRL_BUFF         : integer := 5;
signal  USE_PULSE_HEIGHT_HIST  : std_logic := '0';
signal  USE_DBG_WAVE_FIFO      : std_logic := '0';
signal  N_BITS_AVG_g           : integer;

begin

-- UUT : entity work.SingleBusProcessing
-- port map (
--         clk                => clk,
--         rst                => rst,
--         -- mode               => mode,
--         ena                => ena,
--         win_start          => win_start,
--         samp_start         => samp_start,
--         trig_bits          => trig_bits,
--         ped_fetch_asic_no  => ped_fetch_asic_no,
--         ped_fetch_chan     => ped_fetch_chan,
--         ped_fetch_ena      => ped_fetch_ena,
--         ped_fetch_ack      => ped_fetch_ack,
--         ped_fifo_wr_asic   => ped_fifo_wr_asic,
--         ped_fifo_wr_chan   => ped_fifo_wr_chan,
--         ped_fifo_wr_ena    => ped_fifo_wr_ena,
--         ped_fifo_din       => ped_fifo_din,
--         BUS_RD_ENA         => BUS_RD_ENA,
--         BUS_RAMP           => BUS_RAMP,
--         BUS_CLR            => BUS_CLR,
--         BUS_DO             => BUS_DO,
--         SR_CLR             => SR_CLR,
--         SR_CLK             => SR_CLK,
--         SR_SEL             => SR_SEL,
--         BUS_RD_WINSEL      => BUS_RD_WINSEL,
--         SAMPLESEL          => SAMPLESEL,
--         SAMPLESEL_ANY      => SAMPLESEL_ANY,
--         busy_status        => busy_status,
--         rx_features_ack    => rx_features_ack,
--         rx_features_ena    => rx_features_ena,
--         last_hit           => last_hit,
--         charge             => charge,
--         le_time            => le_time,
--         daq_chan           => daq_chan,
--         ramp_length        => ramp_length,
--         -- force_test_pattern => force_test_pattern,
--         N_readout_samples  => N_readout_samples,
--         LE_time_thresh     => LE_time_thresh,
--         N_bits_avg         => N_bits_avg,
--         prime_fifos        => prime_fifos,
--         summing_ena        => summing_ena,
--         avg_peds_ena       => avg_peds_ena,
--         avg_peds_busy      => avg_peds_busy,
--         wr_peds2sram_ena   => wr_peds2sram_ena,
--         wr_peds2sram_ack   => wr_peds2sram_ack,
--         even_ped           => even_ped,
--         odd_ped            => odd_ped,
--         sram_asic_addr     => sram_asic_addr,
--         sram_chan_addr     => sram_chan_addr
-- );

UUT1 : entity work.SingleBusProcessing
    port map (
        clk        => clk,
        rst         => rst,

        ena        => ena,

        asic_mask          => asic_mask,
        first_dig_win         => first_dig_win,
        last_dig_win           => last_dig_win,

        -- wires for/to/from TargetX
        BUS_RD_ENA          => BUS_RD_ENA,
        BUS_RAMP            => BUS_RAMP,
        BUS_CLR             => BUS_CLR ,
        BUS_DO              => BUS_DO,
        SR_CLR              => SR_CLR,
        SR_CLK              => SR_CLK,
        SR_SEL              => SR_SEL, -- set high & pulse sr_clk once to load test pattern
        BUS_RD_WINSEL       => BUS_RD_WINSEL,
        SAMPLESEL           => SAMPLESEL,
        SAMPLESEL_ANY       => SAMPLESEL_ANY,


        -- SCROD config registers
        ramp_length         => ramp_length,
        force_test_pattern  => force_test_pattern,
        t_samp_addr_settle  => t_samp_addr_settle,
        t_setup_ss_any      => t_setup_ss_any ,
        t_strobe_settle     => t_strobe_settle,
        t_sr_clk_high       => t_sr_clk_high,
        t_sr_clk_low        => t_sr_clk_low ,
        t_sr_clk_strobe     => t_sr_clk_strobe,
        N_readout_samples  => N_readout_samples,
        LE_time_thresh      => LE_time_thresh,

        -- status registers
        debug_we            => debug_we,
        debug_wave          => debug_wave,
        debug_pfull          => debug_pfull,
        -- DigStoreProcBusy      : out std_logic := '0';
        DigNShiftBusy       => DigNShiftBusy,
        -- DigBusy               : out std_logic := '0';
        ShiftOutWinBusy      => ShiftOutWinBusy,
        ShiftOutSampBusy     => ShiftOutSampBusy
        -- FeatExtBusy           : out std_logic := '0';
        -- PedFetchQueueBusy     : out std_logic := '0';

        -- -- qblink
        -- right2left       => right2left,
        -- left2right       => left2right
    );


    clk_process : process 
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process clk_process;


    stimprocess : process
    begin
        wait for 100 ns; --! wait until global set/reset completes
  
        wait for clk_period;
        -- mode <= "001";
        -- wait for clk_period;
        -- win_start  <= "111111110";
        first_dig_win  <= "000000000";
        -- wait for clk_period;
        last_dig_win <= "000000111";
        -- wait for clk_period;
        -- trig_bits  <= (2 => "01111", others=>(others=>'0'));
        -- trig_bits  <= (2 => "11000", others=>(others=>'0'));
        wait for clk_period;
        
        ena <= '1';
        wait for clk_period*5;
        ena <= '0';
  
        wait for clk_period*100;
        BUS_DO <= (others=>'1');
        wait; --! will wait forever
    end process stimprocess;
  
end;
