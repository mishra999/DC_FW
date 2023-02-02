library IEEE;
use IEEE.std_logic_1164.ALL;  
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_UNSIGNED.ALL; 
Library work; 
use work.klm_scint_pkg.all;   

entity Waveform_reg_readout is   
    generic (
        nominal_LE_sample_number_g: std_logic_vector(13 downto 0) := "00000000001000";
        FORCE_TRIG_BUF_DEPTH_g    : integer := 6;
        TRG_BUFF_DEPTH_g          : integer := 4;
        TRIG_QUEUE_DEPTH_g        : integer := 15;
        -- TQ_PROG_FULL_THRESH_g     : integer := 3;
        CALC_ROI_LAG_g            : integer := 2;
        T_WAIT_2C_IF_QUEUE_FULL_g : integer := 31; -- tried 6 and got all zeros from TARGETX, yet fine in sim -- maybe try as register
        reset_buff_depth_g        : integer := 10;
        SLC_STAT_BUFF_DEPTH_g     : integer := 4;
        packet_type_g             : std_logic_vector(7 downto 0):= X"80"; -- marks scintillators hits for DataConcentrator
        LAST_WINDOW_ADDRESS       : std_logic_vector(8 downto 0) := "111111111";
        N_BITS_AVG_g              : integer := 7;
        T_wait_busy_to_come_up_g  : integer := 31;
        -- FINE_LOOKBACK_g           : std_logic_vector(10 downto 0) := "00000000000"; -- 1 clk period resolution
        USE_PULSE_HEIGHT_HIST     : std_logic := '0';
        USE_DBG_WAVE_FIFO         : std_logic := '0';
        max_proc_time_g           : std_logic_vector(15 downto 0) := "0011000110011100" -- 100us
    );
    port (
        -- main inputs
        clk                   : in  std_logic := '0';
        busy                  : out std_logic;
        -- b2tt_runreset         : in  std_logic := '0';
        -- trig                  : in  trig_info_type_0 := null_trig_info_t0;

        -- signals with SamplingLgc
        ana_wr_ena_mask       : out TARGETX_analong_wr_ena_mask_t;
        first_dig_win         : in std_logic_vector(8 downto 0) := (others => '0'); 
        last_dig_win          : in std_logic_vector(8 downto 0) := (others => '0');       
        -- -- signals with HitDataSerializer
        -- localtrg              : in  std_logic := '0';
        -- ped_meas_start        : in  std_logic := '0';
        -- sps_reset             : in  std_logic := '0';
        -- cur_win               : in  std_logic_vector(8 downto 0);
        
        -- nxt                   : in  std_logic := '0';
        -- tbfifo_rden           : out  std_logic_vector(9 downto 0);
      --! daq data ports
       qblink_tvalid       : out std_logic := '0';
       qblink_tready       : in std_logic := '0';
       qblink_tdata       : out std_logic_vector(31 downto 0) := (others => '0'); 
       dataReq        : in std_logic := '0'; --from DC_comm_back
        -- qt_fifo_rd_en         : in  std_logic := '0';
        -- qt_fifo_dout          : out std_logic_vector (17 downto 0);
        -- qt_fifo_valid         : out std_logic;
        -- qt_fifo_empty         : out std_logic;
        -- qt_fifo_err_cnt       : out std_logic_vector(15 downto 0); -- counter for daq data fifo overflows
        -- qt_fifo_evt_rdy       : out std_logic;
        -- full_proc_cnt         : out std_logic_vector(15 downto 0);
        -- simp_proc_cnt         : out std_logic_vector(15 downto 0);
        -- null_proc_cnt         : out std_logic_vector(15 downto 0);

        -- -- pedestal RAM access
        -- RAM_IO                : inout std_logic_vector(7 downto 0) := (others => '0');
        -- RAM_WEb               : out std_logic;
        -- RAM_OEb               : out std_logic;
        -- RAM_ADDR              : out std_logic_vector(21 downto 0);

        -- BusA signals
        BUSA_DO               : in  std_logic_vector(14 downto 0) := (others => '0');
        BUSA_RAMP             : out std_logic;
        BUSA_CLR              : out std_logic;
        BUSA_RD_COLSEL        : out std_logic_vector(5 downto 0);
        BUSA_RD_ENA           : out std_logic;
        BUSA_RD_ROWSEL        : out std_logic_vector(2 downto 0);
        BUSA_SAMPLESEL        : out std_logic_vector(4 downto 0);
        BUSA_SR_CLEAR         : out std_logic;
        BUSA_SR_SEL           : out std_logic;

        -- -- BusB signals
        -- BUSB_DO               : in  std_logic_vector(14 downto 0) := (others => '0');
        -- BUSB_RAMP             : out std_logic;
        -- BUSB_CLR              : out std_logic;
        -- BUSB_RD_COLSEL        : out std_logic_vector(5 downto 0);
        -- BUSB_RD_ENA           : out std_logic;
        -- BUSB_RD_ROWSEL        : out std_logic_vector(2 downto 0);
        -- BUSB_SAMPLESEL        : out std_logic_vector(4 downto 0);
        -- BUSB_SR_CLEAR         : out std_logic;
        -- BUSB_SR_SEL           : out std_logic;

        -- TargetX DC signals
        SAMPLESEL_ANY         : out std_logic_vector(9 downto 0);
        SR_CLOCK              : out std_logic_vector(9 downto 0));

        -- -- SCROD config registers
        -- wave_config           : in wave_config_t := default_wave_config;

        -- -- status registers
        -- wave_stat             : out waveform_stat_t := wave_stat_0;
        -- debug_wave_we         : out std_logic_vector(1 downto 0);
        -- debug_wave_din        : out slv12(1 downto 0);
        -- SPS_hist_rd_data      : out slv16(1 downto 0));
end Waveform_reg_readout;

architecture behavior of Waveform_reg_readout is 

constant clk_period       :  time := 7.87 ns;         
-- signal clk                : std_logic := '0';
signal rst                : std_logic := '0';
signal mode               : std_logic_vector(2 downto 0) := (others => '0');
signal ena                : std_logic := '0';
signal asic_mask          : std_logic := '1';
-- signal first_dig_win      : std_logic_vector(8 downto 0);
-- signal last_dig_win       : std_logic_vector(8 downto 0);

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
-- signal SAMPLESEL_ANY      : std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');
signal busy_status        : std_logic_vector(4 downto 0) := (others => '0');
signal rx_features_ack    : std_logic := '0';
signal rx_features_ena    : std_logic := '0';
signal last_hit           : std_logic := '0';
signal charge             : std_logic_vector(11 downto 0) := (others => '0');
signal le_time            : std_logic_vector(13 downto 0) := (others => '0');
signal daq_chan           : std_logic_vector(6 downto 0) := (others => '0');
signal ramp_length        : std_logic_vector(11 downto 6) := (others => '0');
--data out
signal samples_valid      : std_logic := '0';
signal sample_data : slv12(14 downto 0) := (others=>"000000000000"); 
--data in
-- signal fifo_s_tready : std_logic := '1';
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
-- signal  USE_PULSE_HEIGHT_HIST  : std_logic := '0';
-- signal  USE_DBG_WAVE_FIFO      : std_logic := '0';
-- signal  N_BITS_AVG_g           : integer;
constant ZERO : std_logic_vector(19 downto 0) := x"00000";
--data fifo out
signal  qblink_tvalid_i :std_logic := '0';
signal qblink_tready_i  :std_logic := '0';
signal qblink_tdata_i :std_logic_vector(31 downto 0) := (others => '0'); 
signal  ch_number :std_logic := '0';
signal   total_wins :std_logic := '0';
--fifo in
signal fifo_s_tready :std_logic := '1'; --always data read enabled from the chip


begin

qblink_tvalid <= qblink_tvalid_i;
qblink_tready_i <= qblink_tready;
qblink_tdata <= qblink_tdata_i; 
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
        ShiftOutSampBusy     => ShiftOutSampBusy,
        --data out
        sample_data          => sample_data,
        samples_valid        => samples_valid
        -- FeatExtBusy           : out std_logic := '0';
        -- PedFetchQueueBusy     : out std_logic := '0';

        -- -- qblink
        -- right2left       => right2left,
        -- left2right       => left2right
    );




 
end;
