library ieee;
   use ieee.std_logic_1164.all;
   use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
   use work.conc_intfc_pkg.all;
   use work.klm_scrod_pkg.all;

package klm_scint_pkg is

    constant TargetRegWidth  : integer := 19;
    constant N_ASICS         : integer := 10;
    constant ROI_VEC_WIDTH   : integer := 11;
    -- constant N_READOUT_SAMPLES        : std_logic_vector(7 downto 0) := "01000000"; -- 1 ns resolution
    -- constant N_readout_samples_0based : std_logic_vector(7 downto 0) := (N_READOUT_SAMPLES - "00000001");

    subtype st_i5 is integer range 0 to 4;
    type i5 is array (natural range <>) of st_i5;
    subtype st_slv2 is std_logic_vector(1 downto 0);
    type slv2 is array (natural range <>) of st_slv2;
    subtype st_slv3 is std_logic_vector(2 downto 0);
    type slv3 is array (natural range <>) of st_slv3;
    subtype st_slv4 is std_logic_vector(3 downto 0);
    type slv4 is array (natural range <>) of st_slv4;
    subtype st_slv5 is std_logic_vector(4 downto 0);
    type slv5 is array (natural range <>) of st_slv5;
    subtype st_slv7 is std_logic_vector(6 downto 0);
    type slv7 is array (natural range <>) of st_slv7;
    subtype st_slv8 is std_logic_vector(7 downto 0);
    type slv8 is array (natural range <>) of st_slv8;
    subtype st_slv9 is std_logic_vector(8 downto 0);
    type slv9 is array (natural range <>) of st_slv9;
    subtype st_slv10 is std_logic_vector(9 downto 0);
    type slv10 is array (natural range <>) of st_slv10;
    subtype st_slv11 is std_logic_vector(10 downto 0);
    type slv11 is array (natural range <>) of st_slv11;
    subtype st_slv12 is std_logic_vector(11 downto 0);
    type slv12 is array (natural range <>) of st_slv12;
    subtype st_slv14 is std_logic_vector(13 downto 0);
    type slv14 is array (natural range <>) of st_slv14;
    subtype st_slv15 is std_logic_vector(14 downto 0);
    type slv15 is array (natural range <>) of st_slv15;
    subtype st_slv16 is std_logic_vector(15 downto 0);
    type slv16 is array (natural range <>) of st_slv16;
    subtype st_slv22 is std_logic_vector(21 downto 0);
    type slv22 is array (natural range <>) of st_slv22;
    subtype st_slv24 is std_logic_vector(23 downto 0);
    type slv24 is array (natural range <>) of st_slv24;
    subtype st_slv32 is std_logic_vector(31 downto 0);
    type slv32 is array (natural range <>) of st_slv32;
    subtype st_slv31 is std_logic_vector(30 downto 0);
    type slv31 is array (natural range <>) of st_slv31;
    subtype st_slv41 is std_logic_vector(40 downto 0);
    type slv41 is array (natural range <>) of st_slv41;

    type waveform_stat_t is record
        ped_meas_busy : std_logic;
        ped_dbg : std_logic_vector(1 downto 0);
        fe_dbg_a : std_logic_vector(1 downto 0);
        fe_dbg_b : std_logic_vector(1 downto 0);
        wave_proc_busy : std_logic;
    end record;
    constant wave_stat_0 : waveform_stat_t := (
        ped_meas_busy => '0',
        ped_dbg => "00",
        fe_dbg_a => "00",
        fe_dbg_b => "00",
        wave_proc_busy => '0'
    );
    type wave_stat_vec is array (natural range <>) of waveform_stat_t;

   -- type scalers_type   is array(0 to 9) of std_logic_vector(15 downto 0);
   -- type scalers32_type is array(0 to 9) of std_logic_vector(31 downto 0);
   -- type scalers32_asic_type is array (0 to 15) of std_logic_vector(31 downto 0);
   type scalers32_all_type is array(0 to 9) of slv32(15 downto 0);
   -- type scalers16_asic_type is array (0 to 15) of std_logic_vector(15 downto 0);

   -- type trgbit_data_type is array(0 to 9) of std_logic_vector(9+5+27-1 downto 0); -- win, trig bits, ctime

   type ReadOutModesType is (ROMODE_DUMMY, ROMODE_SIMPLE, ROMODE_TEST, ROMODE_SCALERS, ROMODE_FULL);

   type KlmScrodHitDataType is record
      first_hit    : std_logic;
      last_hit     : std_logic;
      null_hit     : std_logic;

      word1        : std_logic_vector(15 downto 0);
      word2        : std_logic_vector(15 downto 0);
      word3        : std_logic_vector(15 downto 0);
      word4        : std_logic_vector(15 downto 0);

   end record;

   constant KlmScrodHitDataNull : KlmScrodHitDataType := (
      first_hit  => '0',
      last_hit   => '0',
      null_hit   => '0',

      word1      => (others=>'0'),
      word2      => (others=>'0'),
      word3      => (others=>'0'),
      word4      => (others=>'0')
   );

   -- STATUS TYPE
   type KlmScrodStatusType is record
     Version        : std_logic_vector(15 downto 0);
     -- AliveCnt       : std_logic_vector(15 downto 0);
     -- TxRegBusy      : std_logic;
     -- TxRegError     : std_logic;

     -- BClkCnt        : std_logic_vector(15 downto 0);
     -- FakeStat       : std_logic_vector(15 downto 0);

     -- TxScalersArr   : slv32(15 downto 0);
     TbScalersChnArr: slv32(9 downto 0);

     TrgCnt         : std_logic_vector(15 downto 0);
     FullProcCnt     : std_logic_vector(15 downto 0);
     SimpProcCnt     : std_logic_vector(15 downto 0);
     NullProcCnt     : std_logic_vector(15 downto 0);

     -- HitsOverflowCnt : std_logic_vector(15 downto 0);

     -- debug1          : std_logic_vector(15 downto 0);
     -- debug2          : std_logic_vector(15 downto 0);
     -- debug3          : std_logic_vector(15 downto 0);
     -- CTimeMax        : std_logic_vector(26 downto 0);

     TbScalersBusy  : std_logic;
     -- TbFifoCnt      : slv16(9 downto 0);
     TbFifoFullCnt  : slv16(9 downto 0);
     QtFifoFullCnt  : std_logic_vector(15 downto 0);
     -- TrgFifoFullCnt : std_logic_vector(15 downto 0);
     -- RclWordsCnt    : std_logic_vector(15 downto 0);

     -- MppcDacBusy    : std_logic;
     -- MppcAdcBusy    : std_logic;

     -- MppcAdcData    : std_logic_vector(11 downto 0);

     B2ttUp         : std_logic;
     B2ClkUp        : std_logic;
     -- B2ttStaIddr    : std_logic_vector(1 downto 0);
     -- B2ttCntIdelay  : std_logic_vector(6 downto 0);
     StartUtime     : std_logic_vector(31 downto 0);
     B2ttUpUTime    : std_logic_vector(31 downto 0);
     CurUTime       : std_logic_vector(31 downto 0);
     Shout          : std_logic_vector(9  downto 0);
     -- runrstdbg      : std_logic_vector(3 downto 0);
     -- feerstdbg      : std_logic_vector(3 downto 0);
     -- b2lrstdbg      : std_logic_vector(3 downto 0);
     -- gtprstdbg      : std_logic_vector(3 downto 0);
     WaveStat       : waveform_stat_t;
     debug_wave_we   : std_logic_vector(1 downto 0);
     debug_wave_din : slv12(1 downto 0);
     SPS_hist_rd_data : slv16(1 downto 0);
     sfp_stat         : SFP_Status_t;
     aurora_stat      : Aurora_Status_t;
   end record;
   constant KlmScrodStatusType0 : KlmScrodStatusType := (
     Version         => (others=>'0'),
     -- AliveCnt       => (others=>'0'),
     -- TxRegBusy       => '0',
     -- TxRegError     => '0',
     -- BClkCnt        => (others=>'0'),
     -- FakeStat       => (others=>'0'),
     -- TxScalersArr   : slv32(15 downto 0),
     TbScalersChnArr => (others=>(others=>'0')),
     TrgCnt          => (others=>'0'),
     FullProcCnt     => (others=>'0'),
     SimpProcCnt     => (others=>'0'),
     NullProcCnt     => (others=>'0'),
     -- HitsOverflowCnt => (others=>'0'),
     -- debug1          => (others=>'0'),
     -- debug2          => (others=>'0'),
     -- debug3          => (others=>'0'),
     -- CTimeMax        => (others=>'0'),
     TbScalersBusy   => '0',
     -- TbFifoCnt      => (others=>(others=>'0')),
     TbFifoFullCnt  => (others=>(others=>'0')),
     QtFifoFullCnt  => (others=>'0'),
     -- TrgFifoFullCnt => (others=>'0'),
     -- RclWordsCnt    => (others=>'0'),
     -- MppcDacBusy    => '0',
     -- MppcAdcBusy    => '0',
     -- MppcAdcData    => (others=>'0'),
     B2ttUp         => '0',
     B2ClkUp        => '0',
     -- B2ttStaIddr    => (others=>'0'),
     -- B2ttCntIdelay  => (others=>'0'),
     StartUtime     => (others=>'0'),
     B2ttUpUTime    => (others=>'0'),
     CurUTime       => (others=>'0'),
     Shout          => (others=>'0'),
     -- runrstdbg      => (others=>'0'),
     -- feerstdbg      => (others=>'0'),
     -- b2lrstdbg      => (others=>'0'),
     -- gtprstdbg      => (others=>'0'),
     WaveStat       => wave_stat_0,
     debug_wave_we   => (others=>'0'),
     debug_wave_din => (others=>(others=>'0')),
     SPS_hist_rd_data => (others=>(others=>'0')),
     sfp_stat         => (others=>'0'),
     aurora_stat      => (others=>'0')
   );

    type wave_config_t is record
        measure_peds          : std_logic;
        simple_pkt_mode       : std_logic;
        use_ftsw_trig         : std_logic;
        ped_sub_ena           : std_logic;
        ROILookBack           : std_logic_vector(5 downto 0);
        N_readout_samples     : std_logic_vector(8 downto 0);
        ramp_length           : std_logic_vector(11 downto 6);
        use_force_trig        : std_logic;
        t_samp_addr_settle    : std_logic_vector(3 downto 0);
        t_setup_ss_any        : std_logic_vector(3 downto 0);
        t_strobe_settle       : std_logic_vector(3 downto 0);
        t_sr_clk_high         : std_logic_vector(3 downto 0);
        t_sr_clk_low          : std_logic_vector(3 downto 0);
        t_sr_clk_strobe       : std_logic_vector(3 downto 0);
        LE_time_thresh        : std_logic_vector(11 downto 0);
        force_trig_asic       : i5(1 downto 0);
        -- force_trig_win        : std_logic_vector(8 downto 0);
        force_trig_bits       : std_logic_vector(4 downto 0);
        -- SPS_count_max         : std_logic_vector(4 downto 0);
        SPS_hist_rd_addr      : slv10(1 downto 0);
        stream_peds           : std_logic;
        debug_wave_pfull      : std_logic_vector(1 downto 0);
    end record;

    constant default_wave_config : wave_config_t := (
        measure_peds          => '0',
        simple_pkt_mode       => '1',
        use_ftsw_trig         => '0',
        ped_sub_ena           => '1',
        ROILookBack           => "000000",
        N_readout_samples     => "000011111",
        ramp_length           => "010111", -- 1472
        use_force_trig        => '0',
        t_samp_addr_settle    => "0000",-- 0
        t_setup_ss_any        => "0010",-- 2
        t_strobe_settle       => "0000",-- 0
        t_sr_clk_high         => "0011",-- 3
        t_sr_clk_low          => "0010",-- 2
        t_sr_clk_strobe       => "0001",-- 1
        LE_time_thresh        => "000000110010", -- 50
        force_trig_asic       => (others=> 0),
        -- force_trig_win        => (others=>'0'),
        force_trig_bits       => "00000",
        -- SPS_count_max         => "10000",
        SPS_hist_rd_addr      => (others=> (others=>'0')),
        stream_peds           => '0',
        debug_wave_pfull      => (others=>'0')
    );


   -- CONFIGURATION
   type KlmScrodConfigType is record
      TBLookBack      : std_logic_vector(15 downto 0);
      TBLookBackWidth : std_logic_vector(9 downto 0);
      TBScalersPeriod : std_logic_vector(7 downto 0);
      TxLatchPeriod   : std_logic_vector(3 downto 0);
      TxLoadPeriod    : std_logic_vector(3 downto 0);
      TxProcMask      : std_logic_vector(9 downto 0);
      TBScalerChannel : std_logic_vector(3 downto 0);
      -- AlwaysUpdStat   : std_logic;
      wave_config     : wave_config_t;
      
   end record;--KlmScrodConfigType

   constant KlmScrodConfigZero : KlmScrodConfigType := (
      TBLookBack         => "0000000111110100",
      TBLookBackWidth    => "0001000000",
      TBScalersPeriod    => x"08",
      TxLatchPeriod      => x"4",
      TxLoadPeriod       => x"8",
      TxProcMask         => "1111111111",
      TBScalerChannel    => "0000",
      -- AlwaysUpdStat      => '1',
      wave_config        => default_wave_config
   );


   -- CONTROL
   type KlmScrodControlType is record

      TBScalersReset : std_logic;
      -- ADCReset        : std_logic;
      -- RunADC          : std_logic;
      KlmStatusUpdate : std_logic;
      -- dgb_rd_ena
      -- force trig
      force_trig : std_logic;
      sps_reset : std_logic;

      -- TxRegUpdate     : std_logic; -- these two not tied to registers
      -- MppcDacUpdate   : std_logic; -- these two not tied to registers

      B2ttDbg         : std_logic_vector(5 downto 0);


   end record;


   type trig_info_type_0 is record
      ana_addr : slv11(9 downto 0);
      bits   : slv5(9 downto 0);
      L0_ctime : slv16(9 downto 0); -- win[8:0] = [11:3]
      L1_ctime  : std_logic_vector(15 downto 0);
      mask   : std_logic_vector(9 downto 0); -- valid flags
      -- ready  : std_logic_vector(9 downto 0);
   end record;
   constant null_trig_info_t0 : trig_info_type_0 := (
      ana_addr  => (others => (others => '0')),
      bits   => (others => (others => '0')),
      L0_ctime => (others => (others => '0')),
      L1_ctime  => (others => '0'),
      mask   => (others => '0')
      -- ready  => (others => '0')
   );


   type trig_info_type_1 is record
      ana_addr       : slv11(9 downto 0);
      bits           : slv5(9 downto 0);
      L0_ctime      : slv16(9 downto 0); -- win[8:0] = [11:3]
      L1_ctime      : std_logic_vector(15 downto 0);
      mask           : std_logic_vector(9 downto 0); -- valid flags
      is_hit          : std_logic;
      roi_start_addr  : std_logic_vector(ROI_VEC_WIDTH - 1 downto 0);
      roi_stop_addr   : std_logic_vector(ROI_VEC_WIDTH - 1 downto 0);
      roi_width       : std_logic_vector(ROI_VEC_WIDTH - 3 downto 0);
   end record;
   constant null_trig_info_t1 : trig_info_type_1 := (
      ana_addr       => (others => (others => '0')),
      bits           => (others => (others => '0')),
      L0_ctime      => (others => (others => '0')),
      L1_ctime      => (others => '0'),
      mask           => (others => '0'),
      is_hit          => '0',
      roi_start_addr  => (others => '0'),
      roi_stop_addr   => (others => '0'),
      roi_width       => (others => '0')
   );

   type trig_queue_type is array (natural range <>) of trig_info_type_1;

   type TARGETX_analong_wr_ena_mask_t is record
      ena        : std_logic;
      mask_bit   : std_logic;
      win_start  : std_logic_vector(8 downto 0);
      n_win      : std_logic_vector(8 downto 0);
   end record;
   constant null_TX_ana_wr_ena_mask : TARGETX_analong_wr_ena_mask_t := ('0','0',"000000000","000000000");

   type state_type is (
      RESETTING,
      SAMPLING
  ); --by mudit

   type masking_state_machine is (
      IDLE,
      MODIFY_MASK
   );--by mudit
   type ASIC_sr_ctrl_fsm is (
      IDLE,                                       -- Idling until command start bit and store size
      WAIT_FOR_SAMPLE_ADDRESSING_TO_FINISH,
      WAIT_SETUP_SR_CLK_STROBE,                   -- Wait for address to settle, need docs to finilize
      WAIT_T_SR_CLK_STROBE_HIGH,                  -- Wait for load cmd to settle relatively to clk, need docs to finilize
      WAIT_T_SR_CLK_STROBE_LOW,
      HOLD_EVERYTHING_LOW_BEFORE_SHIFTING_OUT,
      WAIT_SAMPLESEL_ANY_AND_FIRST_BIT,
      WAIT_T_SR_CLK_HIGH,
      WAIT_T_SR_CLK_LOW
  ); --mudit
  type ASIC_rx_bits_fsm is (IDLE, WAITING, SHIFTING); --mudit
  type shift_out_window_data is (
   IDLE,             -- shift_win_state = (ASIC_LOOP) or (IDLE)
   SAMP_RANGE,        -- shift_win_state = (WAIT_SR_BUSY_TO_COME_UP) or (IDLE)
   WAIT_SR_BUSY_TO_COME_UP, -- shift_win_state = (WAIT_SHIFT_OUT_SAMPLE)
   WAIT_SHIFT_OUT_SAMPLE   -- shift_win_state = (WAIT_SR_BUSY_TO_COME_UP) or (ASIC_LOOP)
   ); --mudit

   type digitize_and_shift_out_window_data is (
      IDLE,
      WAIT_DIG_BUSY_TO_COME_UP,      -- next_state = (WAIT_DIG_BUSY_TO_COME_UP) or (IDLE)
      WAIT_DIG_WINDOW,
      WAIT_SHIFT_BUSY_TO_COME_UP,
      WAIT_SHIFT_OUT  ---- next_state = WAIT_DIG_BUSY_TO_COME_UP
   );
end package klm_scint_pkg;

package body klm_scint_pkg is


end package body klm_scint_pkg;
