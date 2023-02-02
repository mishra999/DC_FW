library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_misc.all;
library work;
    use work.klm_scrod_pkg.all;
    use work.klm_scint_pkg.all;
    use work.conc_intfc_pkg.all;

--! Module to control KLM SCROD registers
--! 2018/12/24 refactored version of ethernet_readout_interface.vhd from Isar
--!
--! 32-bit run-ctrl word is (IC & ADDR & VALUE)
--! | Description                          | IC | Addr | Val  |
--! |--------------------------------------|----|------|------|
--! | set SCROD reg=XX to val=YYYY         | AF | XX   | YYYY |
--! | set ASIC=X reg=YY to val=ZZZ         | BX | YY   | 0ZZZ |
--! | set HV DAC for ASIC=X ch=Y to val=ZZ | C0 | XY   | 00ZZ |
--! | pause rcl fsm for XXXX00 clocks      | AE | 00   | XXXX |
        

entity KLMScrodRegCtrl is
   port(
      clk                     : in  std_logic;
      -- rst                     : in  std_logic; -- reset logic is not implemented yet TODO
    
      -- local link interface ports
      -- rcl_dst_rdy_n           : out std_logic;
      -- rcl_sof_n               : in  std_logic;
      -- rcl_eof_n               : in  std_logic;
      rcl_src_rdy_n           : in  std_logic;
      rcl_data                : in  std_logic_vector(15 downto 0);
      -- receive busy signals from peripheral devices here
      targetx_dac_ctrl_busy   : in std_logic; 
      targetx_reg_ctrl_mask   : out std_logic_vector(9 downto 0) := (others => '0');
      targetx_reg_data        : out std_logic_vector(18 downto 0) := (others => '0');
      targetx_reg_upd         : out std_logic := '0';

      mppc_trim_dac_fsm_busy  : in std_logic;
      mppc_dac_num            : out std_logic_vector(3 downto 0) := (others => '0');
      mppc_dac_addr           : out std_logic_vector(3 downto 0) := (others => '0');
      mppc_dac_val            : out std_logic_vector(7 downto 0) := (others => '0');
      mppc_dac_upd            : out std_logic := '0';      

      ScrodStatus             : in  KlmScrodStatusType;
    
      -- output configuration
      ScrodConfig             : out KlmScrodConfigType := KlmScrodConfigZero;
      -- control signals such us strobes to update DAC registers
      ScrodControl            : out KlmScrodControlType;
      -- output reg data for klm_scrod interface
      klm_status_regs         : out stat_reg_type; -- 256
      status_done : in std_logic
  );
end KLMScrodRegCtrl;

architecture reg_ctrl_arch of KLMScrodRegCtrl is

    signal i_ScrodControl  : KlmScrodControlType;
   signal i_ScrodConfig   : KlmScrodConfigType := KlmScrodConfigZero;
   -- initialization of ScrodConfig only affects mppc dac startup,
   -- others must be initialized in reg_data initialization below.
   signal i_ScrodStatus   : KlmScrodStatusType;

   -- RCL FIFO signals
   signal rcl_fifo_rd_en  : std_logic;
   signal rcl_fifo_data   : std_logic_vector(31 downto 0);
   signal rcl_fifo_empty  : std_logic := '1';

   -- split RCL data into two 16-bit words
   signal rcl_wd1         : std_logic_vector(15 downto 0);
   signal rcl_wd2         : std_logic_vector(15 downto 0);

   -- RCL state machine signals
   type proc_rcl_st is (
      CHECK_EMPTY,
      DECODE_IC,
      ASIC_WAIT_IDLE,
      ASIC_WAIT_STARTED,
      DAC_WAIT_IDLE,
      DAC_WAIT_STARTED
   );

   signal rcl_state       : proc_rcl_st := CHECK_EMPTY;
   -- signal rcl_wait_cnt    : integer     := 0;

   -- number of ASIC to program
   signal i_asic_num      : integer range 0 to 9 := 0;

   -- some values to bring up FW with config registers already set.
   -- this was initially a workaround to get full sim working.
   constant AlwaysUpdStat      : std_logic_vector(0 downto 0) := "1";
   constant TxLoadPeriod       : std_logic_vector(3 downto 0) := x"4";
   constant TxLatchPeriod      : std_logic_vector(7 downto 4) := x"8";
   constant TBScalersPeriod    : std_logic_vector(15 downto 8) := x"01";
   constant TBLookBack         : std_logic_vector(15 downto 0) := x"0003";
   constant TBLookBackWidth    : std_logic_vector(9 downto 0) := "0000000100";
   constant ROILookBack        : std_logic_vector(5 downto 0) := "000001";
   constant TxProcMask         : std_logic_vector(9 downto 0) := "1111111111";
   constant RampLength         : std_logic_vector(11 downto 6) := "000110";
   constant ped_sub_ena        : std_logic_vector(12 downto 12) := "1";
   constant use_ftsw_trig      : std_logic_vector(13 downto 13) := "1";
   constant simple_pkt         : std_logic_vector(14 downto 14) := "0";
   constant measure_peds       : std_logic_vector(15 downto 15) := "0";
   constant t_sr_clk_low       : std_logic_vector(15 downto 12) := x"2";
   constant N_readout_samples  : std_logic_vector(8 downto 0) := "000011111"; --"000010111";
   constant LE_time_thresh     : std_logic_vector(11 downto 0) := x"032";
   constant t_sr_clk_strobe    : std_logic_vector(15 downto 12) := x"1";
   constant force_trig_asic_A  : std_logic_vector(2 downto 0) := "000";
   constant force_trig_asic_B  : std_logic_vector(5 downto 3) := "000";
   constant use_force_trig     : std_logic_vector(15 downto 15) := "0";
   constant force_trig_bits    : std_logic_vector(4 downto 0) := "00000";
   constant stream_peds        : std_logic_vector(10 downto 10) := "0";
   constant SPS_hist_rd_addr_A : std_logic_vector(13 downto 0) := "00000000000001";
   constant SPS_hist_rd_addr_B : std_logic_vector(13 downto 0) := "00000000000001";
   constant t_samp_addr_settle : std_logic_vector(3 downto 0) := x"0";
   constant t_setup_ss_any     : std_logic_vector(7 downto 4) := x"2";
   constant t_strobe_settle     : std_logic_vector(3 downto 0) := x"0";
   constant t_sr_clk_high     : std_logic_vector(3 downto 0) := x"3";   
   
   constant stat_reg_t0 : stat_reg_type := (
      1 => "000000000000000" & AlwaysUpdStat,
      2 => TBScalersPeriod & TxLatchPeriod & TxLoadPeriod,
      3 => TBLookBack,
      4 => ROILookBack & TBLookBackWidth,
      5 => "000000" & TxProcMask,
      6 => measure_peds & simple_pkt & use_ftsw_trig & ped_sub_ena & RampLength & "000000",
      7 => t_sr_clk_low & "000" & N_readout_samples,
      9 => t_sr_clk_strobe & LE_time_thresh,
      10 => use_force_trig & "000000000" & force_trig_asic_B & force_trig_asic_A,
      11 => "00000" & stream_peds & "00000" & force_trig_bits,
      12 => "00" & SPS_hist_rd_addr_A,
      13 => "00" & SPS_hist_rd_addr_B,
      14 => t_sr_clk_high & t_strobe_settle & t_setup_ss_any & t_samp_addr_settle,
      others => x"0000"
   );
   signal reg_data        : stat_reg_type := stat_reg_t0;
   signal reg_data_r      : stat_reg_type := stat_reg_t0;

   -- count how many rcl commands were executed
   signal rcl_cmd_cnt     : std_logic_vector(15 downto 0) := (others => '0');

   -- debug signals
   signal i_rcl_src_rdy_n_r : std_logic;
   signal i_acc_cnt         : std_logic_vector(15 downto 0) := (others => '0');
   signal i_clk_cnt         : std_logic_vector(31 downto 0) := (others => '0');
   signal i_dbg_1           : std_logic_vector(2 downto 0);

   signal i_status_upd      : std_logic := '0';
   signal i_status_upd_cmd  : std_logic := '0';
   signal always_upd_stat   : std_logic := '1';

   signal reg_update        : std_logic := '0';
   signal reg_data_upd      : std_logic_vector(15 downto 0);
   signal scrod_reg_num     : integer range 0 to 255 := 0;
   signal i_reg_update      : std_logic := '0';
   signal i_reg_data_upd    : std_logic_vector(15 downto 0);
   signal i_scrod_reg_num   : integer range 0 to 255 := 0;

   signal i_targetx_reg_ctrl_mask : std_logic_vector(9 downto 0) := (others => '0');
   signal i_targetx_reg_data      : std_logic_vector(18 downto 0) := (others => '0');
   signal i_targetx_reg_upd       : std_logic := '0';

   signal i_mppc_dac_num    : std_logic_vector(3 downto 0);
   signal i_mppc_dac_addr   : std_logic_vector(3 downto 0);
   signal i_mppc_dac_val    : std_logic_vector(7 downto 0);
   signal i_mppc_dac_upd    : std_logic := '0';

   -- for debug wave fifo
   signal debug_wave_rd_ena : std_logic := '0';
   signal i_DebugWaveforms : slv12(1 downto 0);
   signal i_DebugWordCount : slv11(1 downto 0);
   -- signal prog_full_thresh : std_logic_vector(10 downto 0) := "11101111001";

   -- counter for update stat. Software can check that this increments as verification of update. 
   signal last_stat_reg     : std_logic_vector(15 downto 0) := (others => '0');

begin

   process(clk)
   begin
      if rising_edge(clk) then
         i_ScrodStatus <= ScrodStatus;
      end if;
   end process;

   process(clk)
   begin
      if rising_edge(clk) then
         ScrodControl  <= i_ScrodControl;
         ScrodConfig   <= i_ScrodConfig;
      end if;
   end process;

   ------------------------------------------------------
   -- Run control (receives RC data and put it into FIFO)
   ------------------------------------------------------
   run_ctrl_ins : entity work.run_ctrl
   port map(
      clk                     => clk,
      -- rx_dst_rdy_n            => rcl_dst_rdy_n,
      -- rx_sof_n                => rcl_sof_n,
      -- rx_eof_n                => rcl_eof_n,
      rx_src_rdy_n            => rcl_src_rdy_n,
      rx_data                 => rcl_data,

      -- rcl_fifo_rd_clk         => clk,
      rcl_fifo_rd_en          => rcl_fifo_rd_en,
      rcl_fifo_data           => rcl_fifo_data,  -- 32 bits
      rcl_fifo_empty          => rcl_fifo_empty
   );
   ------------------------------------------------------

   ------------------------------------------------------
   -- Debug waveform readout via register interface
   ------------------------------------------------------
   -- prog_full_thresh <= "11111111111" - i_ScrodConfig.wave_config.N_readout_samples - "110";
    WaveDebugFifo : for i in 0 to 1 generate
        wave_i : entity work.wave_debug_FIFO
        PORT MAP (
            CLK              => clk,
            SRST             => '0',
            WR_EN            => i_ScrodStatus.debug_wave_we(i),
            RD_EN            => debug_wave_rd_ena,
            -- prog_full_thresh => prog_full_thresh,
            DIN              => i_ScrodStatus.debug_wave_din(i),
            DOUT             => i_DebugWaveforms(i),
            FULL             => open,
            EMPTY            => open,
            DATA_COUNT       => i_DebugWordCount(i),
            prog_full        => i_ScrodConfig.wave_config.debug_wave_pfull(i)
        );
    end generate;



   ------------------------------------------------------
   ALIVE_CNT_PROC: process(clk)
   begin
      if (rising_edge(clk)) then
         i_clk_cnt <= i_clk_cnt + '1';
      end if;
   end process ALIVE_CNT_PROC;
   ------------------------------------------------------

   ------------------------------------------------------
   -- Decode RCL command and perform action
   ------------------------------------------------------
   RUNCTRL_PROC : process(clk)
   begin

      if rising_edge(clk) then
         case rcl_state is

            when CHECK_EMPTY =>
               i_dbg_1 <= "000";
               if (rcl_fifo_empty='1') then
                  rcl_fifo_rd_en <= '0';
                  rcl_state      <= CHECK_EMPTY;
               else
                  rcl_fifo_rd_en <= '1';
                  rcl_wd1        <= rcl_fifo_data(31 downto 16);
                  rcl_wd2        <= rcl_fifo_data(15 downto 0 );
                  rcl_cmd_cnt    <= rcl_cmd_cnt + '1';
                  rcl_state      <= DECODE_IC;
               end if;
               i_reg_update <= '0';
               i_targetx_reg_ctrl_mask <= (others => '0');
               i_mppc_dac_upd <= '0';
               i_targetx_reg_upd  <= '0';

           
            when DECODE_IC => -- decode which device is addressed
               rcl_fifo_rd_en <= '0';
               -- if (  = x"AE00") then -- WAIT command 
               --    rcl_wait_cnt <= to_integer(unsigned(rcl_wd2))*256;
               --    rcl_state  <= WAIT_CMD;
               if (rcl_wd1(15 downto 8)  = x"AF") then -- program internal SCROD regs
                  i_scrod_reg_num  <=  to_integer(unsigned(rcl_wd1(7 downto 0)));
                  i_reg_update     <= '1';
                  i_reg_data_upd   <= rcl_wd2;
                  rcl_state      <= CHECK_EMPTY;
               elsif (rcl_wd1(15 downto 12) = x"B") then -- program TargetX registers
                  i_asic_num <= to_integer(unsigned(rcl_wd1(11 downto 8)));
                  rcl_state  <= ASIC_WAIT_IDLE;
               elsif (rcl_wd1(15 downto 8) = x"C0") then -- program MPPC DAC
                  rcl_state <= DAC_WAIT_IDLE;
               else
                  rcl_state <= CHECK_EMPTY;
               end if;

                      
            when ASIC_WAIT_IDLE =>
               i_dbg_1 <= "001";
               if targetx_dac_ctrl_busy = '1' then -- check if ASIC is busy from previous commands
                  rcl_state <= ASIC_WAIT_IDLE;
               else -- when not, initiate new ASIC transaction
                  i_acc_cnt <= i_acc_cnt + 1;
                  i_targetx_reg_data <= rcl_wd1(6 downto 0) & rcl_wd2(11 downto 0);
                  i_targetx_reg_ctrl_mask(i_asic_num) <= '1';
                  i_targetx_reg_upd  <= '1';
                  rcl_state <= ASIC_WAIT_STARTED;
               end if;

           
            when ASIC_WAIT_STARTED =>
               i_dbg_1 <= "010";
               i_targetx_reg_upd  <= '0';
               if targetx_dac_ctrl_busy = '1' then -- wait until transaction is started
                  rcl_state <= CHECK_EMPTY;
               else
                  rcl_state <= ASIC_WAIT_STARTED;
               end if;


            when DAC_WAIT_IDLE =>
               i_dbg_1 <= "011";
               if mppc_trim_dac_fsm_busy = '1' then
                  rcl_state <= DAC_WAIT_IDLE;
               else
                   i_mppc_dac_num <= rcl_wd1(7 downto 4);
                   i_mppc_dac_addr <= rcl_wd1(3 downto 0);
                   i_mppc_dac_val <= rcl_wd2(7 downto 0);
                   i_mppc_dac_upd <= '1';
                   rcl_state <= DAC_WAIT_STARTED;
               end if;


            when DAC_WAIT_STARTED =>
               i_dbg_1 <= "100";
               if mppc_trim_dac_fsm_busy = '0' then
                  rcl_state <= DAC_WAIT_STARTED;
               else
                  i_mppc_dac_upd <= '0';
                  rcl_state <= CHECK_EMPTY;
               end if;

            when others =>
                rcl_state <= CHECK_EMPTY;

         end case;
      end if;
   end process RUNCTRL_PROC;

   process(clk)
   begin
       if rising_edge(clk) then
           reg_update <= i_reg_update;
           reg_data_upd <= i_reg_data_upd;
           scrod_reg_num <= i_scrod_reg_num;
       end if;
   end process;
   
   process(clk)
   begin
       if rising_edge(clk) then
           targetx_reg_ctrl_mask <= i_targetx_reg_ctrl_mask;
           targetx_reg_data <= i_targetx_reg_data;
           targetx_reg_upd <= i_targetx_reg_upd;
       end if;
   end process;
   
   process(clk)
   begin
       if rising_edge(clk) then
           mppc_dac_num <= i_mppc_dac_num;
           mppc_dac_addr <= i_mppc_dac_addr;
           mppc_dac_val <= i_mppc_dac_val;
           mppc_dac_upd <= i_mppc_dac_upd;
       end if;
   end process;
   
   ------------------------------------------------------
   -- STATUS REGISTERS
   ------------------------------------------------------
   REGUPD_PROC : process(clk)
   begin
      if rising_edge(clk) then

         -- 0 register is used for control signals
         -- its value is set only for one clock cycle, then it's set back to zero
         reg_data(0) <= (others => '0');

         if reg_update = '1' then
            reg_data(scrod_reg_num) <= reg_data_upd;
         end if;

         -- read-only registers below

         -- alive counter
         reg_data(15) <= i_clk_cnt(31 downto 16);

         -- b2tt status
         reg_data(16)(0) <= i_ScrodStatus.B2ttUp; -- b2tt status
         reg_data(16)(1) <= i_ScrodStatus.B2ClkUp; -- clk counter for b2ttup

         -- sfp status
         reg_data(16)(5) <= i_ScrodStatus.sfp_stat.fault_flag;
         reg_data(16)(6) <= i_ScrodStatus.sfp_stat.mod_flag;
         reg_data(16)(7) <= i_ScrodStatus.sfp_stat.los_flag;
         
         -- Aurora Status
         reg_data(16)(8)  <= i_ScrodStatus.aurora_stat.gtlock;
         reg_data(16)(9)  <= i_ScrodStatus.aurora_stat.hard_err;
         reg_data(16)(10) <= i_ScrodStatus.aurora_stat.soft_err;
         reg_data(16)(11) <= i_ScrodStatus.aurora_stat.frame_err;
         reg_data(16)(12) <= i_ScrodStatus.aurora_stat.channel_up;
         reg_data(16)(13) <= i_ScrodStatus.aurora_stat.lane_up;
         reg_data(16)(14) <= i_ScrodStatus.aurora_stat.warn_cc;
         reg_data(16)(15) <= i_ScrodStatus.aurora_stat.do_cc;
         

         -- firmware version
         reg_data(17) <= i_ScrodStatus.Version;


         -- status bits
         reg_data(18)(0) <= targetx_dac_ctrl_busy;
         -- reg_data(18)(1) <= i_ScrodStatus.TxRegError;
         reg_data(18)(2) <= mppc_trim_dac_fsm_busy;
         reg_data(18)(3) <= i_ScrodStatus.TbScalersBusy;
         reg_data(18)(4) <= not rcl_fifo_empty;
         reg_data(18)(5) <= i_ScrodStatus.WaveStat.ped_meas_busy;
         reg_data(18)(7 downto 6) <= i_ScrodStatus.WaveStat.ped_dbg;
         reg_data(18)(9 downto 8) <= i_ScrodStatus.WaveStat.fe_dbg_a;
         reg_data(18)(11 downto 10) <= i_ScrodStatus.WaveStat.fe_dbg_b;
         reg_data(18)(12) <= i_ScrodStatus.WaveStat.wave_proc_busy;

        
         reg_data(19) <= rcl_cmd_cnt; -- number of received run control registers
        
         reg_data(20)    <= i_ScrodStatus.TrgCnt; -- trigger counts
        
         reg_data(21)    <= i_ScrodStatus.FullProcCnt; -- processed triggers (31 downto 24) & (7 downto 0)

         reg_data(22)(2 downto 0)  <= i_dbg_1; -- debug for rcl_state

         reg_data(23)  <= i_ScrodStatus.StartUtime(15 downto 0); -- utime of fpga start operation

         reg_data(24)  <= i_ScrodStatus.StartUtime(31 downto 16); -- utime of fpga start operation
        
         reg_data(25) <= i_ScrodStatus.B2ttUpUtime(15 downto 0); -- b2tt up time

         reg_data(26) <= i_ScrodStatus.B2ttUpUtime(31 downto 16); -- b2tt up time
        
         reg_data(27) <= i_ScrodStatus.CurUtime(15 downto 0); -- current utime

         reg_data(28) <= i_ScrodStatus.CurUtime(31 downto 16); -- current utime

         reg_data(29)(9 downto 0) <= i_ScrodStatus.Shout;

         -- maximum value of ctime. We use this since it is not very clear when ctime actually resets
         -- reg_data(30) <= B"00000" & i_ScrodStatus.CTimeMax(26 downto 16); -- msb
         reg_data(30) <= i_ScrodStatus.SimpProcCnt;
         
         -- reg_data(31) <= i_ScrodStatus.CTimeMax(15 downto 0);             -- lsb
         reg_data(31) <= i_ScrodStatus.NullProcCnt;

         -- reg_data(32)(1 downto 0) <= i_ScrodStatus.B2ttStaIddr;
         -- reg_data(32)(8 downto 2) <= i_ScrodStatus.B2ttCntIdelay;

         reg_data(33)(11 downto 0)  <= i_DebugWaveforms(0);
         -- reg_data(39)(15 downto 12) <= i_ScrodStatus.runrstdbg;

         reg_data(34)(11 downto 0)  <= i_DebugWaveforms(1);
         -- reg_data(40)(15 downto 12) <= i_ScrodStatus.feerstdbg;

         reg_data(35)(10 downto 0)  <= i_DebugWordCount(0);
         -- reg_data(41)(15 downto 12) <= i_ScrodStatus.b2lrstdbg;

         reg_data(36)(10 downto 0)  <= i_DebugWordCount(1);
         -- reg_data(42)(15 downto 12) <= i_ScrodStatus.gtprstdbg;

         reg_data(37)(15 downto 0)  <= i_ScrodStatus.SPS_hist_rd_data(0);

         reg_data(38)(15 downto 0)  <= i_ScrodStatus.SPS_hist_rd_data(1);
        
         -- reg_data(45)   <= B"0000" & i_ScrodStatus.MppcADCData; -- mppc current measurement

         -- how many times hits are truncated in the daq package
         -- reg_data(39)   <= i_ScrodStatus.HitsOverflowCnt;

         -- scalers for fifo errors
         -- GEN_FIFOSCA : for ich in 0 to 9 loop
         --    reg_data(47 + ich) <= i_ScrodStatus.TbFifoCnt(ich);
         -- end loop GEN_FIFOSCA;

         -- scalers for fifo errors
         GEN_FIFOERRSCA : for ich in 0 to 9 loop
            reg_data(40 + ich) <= i_ScrodStatus.TbFifoFullCnt(ich);
         end loop GEN_FIFOERRSCA;

         -- reg_data(58) <= i_ScrodStatus.TrgFifoFullCnt; -- how many times trigger fifo gets full
        
         reg_data(50) <= i_ScrodStatus.QtFifoFullCnt; -- how many times daq packets fifo gets full

         -- targetx trigger bits scalers
         GEN_CH_SCA_L : for iasic in 0 to 9 loop
            reg_data(51 + iasic) <= i_ScrodStatus.TbScalersChnArr(iasic)(15 downto 0);
         end loop GEN_CH_SCA_L;

         -- targetx trigger bits scalers
         GEN_CH_SCA_H : for iasic in 0 to 9 loop
            reg_data(61 + iasic) <= i_ScrodStatus.TbScalersChnArr(iasic)(31 downto 16);
         end loop GEN_CH_SCA_H;

         reg_data(NUM_SCROD_REGS - 1) <= last_stat_reg;
      end if;

   end process REGUPD_PROC;
   ------------------------------------------------------

   ------------------------------------------------------
   -- CONFIGURATION REGISTERS
   ------------------------------------------------------
   process(clk)
   begin
      if rising_edge(clk) then

         -- control signals
         i_ScrodControl.TBScalersReset                   <= reg_data(0)(0); -- reset trigger bits scalers
         -- i_ScrodControl.ADCReset                         <= reg_data(0)(1); -- reset ADC for mppc current measurements
         -- i_ScrodControl.RunADC                           <= reg_data(0)(2); -- run mppc ADC
         i_status_upd_cmd                                <= reg_data(0)(3); -- send status regs to the data concentrator
         debug_wave_rd_ena                               <= reg_data(0)(4); -- read one sample from debug wave fifo
         i_ScrodControl.force_trig                       <= reg_data(0)(5); -- initiate processes like ped calc, SPS measurement,
                                                                -- or user specified asic-window-trigbits
                                                                -- Use WaveProcMode to select behavior of force_trig
         i_ScrodControl.sps_reset                        <= reg_data(0)(6);
         -- <3 bits free>                                   <= reg_data(0)(9 downto 5);
         i_ScrodControl.B2ttDbg                          <= reg_data(0)(15 downto 10); -- connected to b2tt debug port
                                                                      -- 10: reg_imanual 
                                                                      -- 12: set_idelay  
                                                                      -- 13: clr_idelay  
                                                                      -- 14: sig_caldelay

         -- CONTROL REGISTERS MAPPING BELOW
         always_upd_stat                                 <= reg_data(1)(0); 
         -- < more mode bits here >                         <= reg_data(1)(15 downto 1);
         
         i_ScrodConfig.TxLoadPeriod                      <= reg_data(2)(3 downto 0);
         i_ScrodConfig.TxLatchPeriod                     <= reg_data(2)(7 downto 4);
         i_ScrodConfig.TBScalersPeriod                   <= reg_data(2)(15 downto 8); -- period of the trig bit scalers measurement

         i_ScrodConfig.TBLookBack                        <= reg_data(3); -- look back window parameters

         i_ScrodConfig.TBLookBackWidth                   <= reg_data(4)(9 downto 0); -- look back window parameters
         i_ScrodConfig.wave_config.ROILookBack           <= reg_data(4)(15 downto 10); -- time between analog storage and TB latching
         
         i_ScrodConfig.TxProcMask                        <= reg_data(5)(9 downto 0); -- ASICs mask to process trigger bits
         i_ScrodConfig.TBScalerChannel                   <= reg_data(5)(13 downto 10);
         -- < more mode bits here >                      <= reg_data(5)(15 downto 14);

         i_ScrodConfig.wave_config.ramp_length           <= reg_data(6)(11 downto 6);
         i_ScrodConfig.wave_config.ped_sub_ena           <= reg_data(6)(12);
         i_ScrodConfig.wave_config.use_ftsw_trig         <= reg_data(6)(13);
         i_ScrodConfig.wave_config.simple_pkt_mode       <= reg_data(6)(14);
         i_ScrodConfig.wave_config.measure_peds          <= reg_data(6)(15);

         i_ScrodConfig.wave_config.N_readout_samples    <= reg_data(7)(8 downto 0);
         -- < more mode bits here >                         <= reg_data(7)(11 downto 9);
         i_ScrodConfig.wave_config.t_sr_clk_low          <= reg_data(7)(15 downto 12);

         -- < more mode bits here >                         <= reg_data(8);

         i_ScrodConfig.wave_config.LE_time_thresh        <= reg_data(9)(11 downto 0);
         i_ScrodConfig.wave_config.t_sr_clk_strobe       <= reg_data(9)(15 downto 12);

         i_ScrodConfig.wave_config.force_trig_asic(0)    <= to_integer(unsigned(reg_data(10)(2 downto 0)));
         i_ScrodConfig.wave_config.force_trig_asic(1)    <= to_integer(unsigned(reg_data(10)(5 downto 3)));
         -- i_ScrodConfig.wave_config.force_trig_win        <= reg_data(10)(14 downto 6);
         i_ScrodConfig.wave_config.use_force_trig        <= reg_data(10)(15);

         i_ScrodConfig.wave_config.force_trig_bits       <= reg_data(11)(4 downto 0);
         -- i_ScrodConfig.wave_config.SPS_count_max         <= reg_data(11)(9 downto 5);
         i_ScrodConfig.wave_config.stream_peds           <= reg_data(11)(10);

         i_ScrodConfig.wave_config.SPS_hist_rd_addr(0)   <= reg_data(12)(9 downto 0);

         i_ScrodConfig.wave_config.SPS_hist_rd_addr(1)   <= reg_data(13)(9 downto 0);

         i_ScrodConfig.wave_config.t_samp_addr_settle    <= reg_data(14)(3 downto 0);
         i_ScrodConfig.wave_config.t_setup_ss_any        <= reg_data(14)(7 downto 4);
         i_ScrodConfig.wave_config.t_strobe_settle       <= reg_data(14)(11 downto 8);
         i_ScrodConfig.wave_config.t_sr_clk_high         <= reg_data(14)(15 downto 12);

         -- i_ScrodConfig.MppcAdcAsicN                      <= reg_data(16)(3 downto 0); -- asic number for mppc current measurement
         -- i_ScrodConfig.MppcAdcChanN                      <= reg_data(16)(7 downto 4); -- number of channel in the asic

      end if;
   end process;

   process(clk)
   begin
      if rising_edge(clk) then
         reg_data_r <= reg_data;
         klm_status_regs <= reg_data_r;
      end if;
   end process;

   last_reg_increment: process(clk)
   begin
      if rising_edge(clk) then
          if i_status_upd_cmd = '1' then
              last_stat_reg <= last_stat_reg + '1';
          end if;
      end if;
   end process;   
      
   process(clk, i_status_upd_cmd, status_done)
   begin
      if rising_edge(clk) then
         if i_status_upd_cmd = '1' then
            i_status_upd <= '1';
         elsif status_done = '1' then -- KlmStatusDone is misleading name. It actually means that status update is in progress FIXME: change name
            i_status_upd <= '0';
         end if;
      end if;
   end process;

   process(clk, status_done, i_status_upd, always_upd_stat)
   begin
      if rising_edge(clk) then
        if (not status_done and (i_status_upd or always_upd_stat)) = '1' then
           i_ScrodControl.KlmStatusUpdate <= '1';
        else
           i_ScrodControl.KlmStatusUpdate <= '0';
        end if;
      end if;
   end process;

end reg_ctrl_arch;
