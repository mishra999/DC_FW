-- https://www.phys.hawaii.edu/~idlab/taskAndSchedule/PCBs/IDL_18_014_mRICH_hodo/BMD_RevB.pdf (check ucf)
Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  
use ieee.std_logic_unsigned.all;   
--use ieee.std_logic_arith.all;
  use work.roling_register_p.all; 
  use work.xgen_axistream_32.all;
  use work.TX_DAC_control_pack.all;   

use work.all; 
use work.BMD_definitions.all; --need to include BMD_definitions in addition to work.all
use work.UtilityPkg.all;   
use work.klm_scint_pkg.all;
library UNISIM;  
use UNISIM.VComponents.all;     
  
entity TargetX_data_tb is	 
    generic (
        NUM_DCs : integer := 0 ;
        chls : integer :=1
    ); 
end entity;      
   
   
architecture rtl of TargetX_data_tb is
    -- signal i_clk              : std_logic;
    --constant NUM_DCs :integer := 0;
    signal usrClk :sl;
    signal sstX5Clk : std_logic;     
  	signal tx_dc		 : slv(NUM_DCs downto 0):= (others => '0'); --transmitted serial data bit 
	signal rx_dc		 : slv(NUM_DCs downto 0):= (others => '0'); --recieved serial data bit
    signal QB_RST :  slv(NUM_DCs downto 0) := (others => '0');
    signal DATA_CLK        : sl;
    signal SERIAL_CLK_LCK :  slv(NUM_DCs downto 0):= (others => '0');
    signal TRIG_LINK_SYNC :  slv(NUM_DCs downto 0):= (others => '0');

    signal SYNC :  STD_LOGIC_VECTOR (NUM_DCs downto 0):= (others => '0'); --Universal sync signal
    signal regAddr : std_logic_vector(15 downto 0) := (others => '0');
    signal regWrData : std_logic_vector(15 downto 0) := (others => '0');
    signal regReq    : sl:= '0';
    signal regOp     : slv(1 downto 0):= "00";
    signal dataReq    : sl:= '0';
    signal DC_RESPONSE : slv (31 downto 0) := (others => '0'); 
    signal RES_VALID : slv( NUM_DCs downto 0):= (others => '0'); 
    signal DC_RESPONSE_reg : slv (31 downto 0) := (others => '0'); 
    signal RES_VALID_reg : slv( NUM_DCs downto 0):= (others => '0'); 
	-- signal  GLOB_EVNT_P :  STD_LOGIC_VECTOR(3 downto 0);
    -- signal GLOB_EVNT_N :  STD_LOGIC_VECTOR(3 downto 0);
    -- signal  GLOB_EVNT :  STD_LOGIC_VECTOR(3 downto 0);
    constant N_GPR : integer := 20;--127;
    type GPR is array(N_GPR-1 downto 0) of std_logic_vector(15 downto 0);   
    signal CtrlRegister : GPR:= (others => x"00D0");
    signal LOCKED : sl:='0';
    signal RESET : sl:='0';
    signal sync1 : slv(NUM_DCs downto 0) := (others =>'0');
    signal Clk_to_QBLink : sl;
    constant ZERO : std_logic_vector(15 downto 0) := x"0000";
    constant ZERO1 : std_logic_vector(19 downto 0) := x"00000";
-- mppc dac
   signal regg      : registerT := registerT_null;
   signal TX_DAC_control1 : TX_DAC_control := TX_DAC_control_null; 
-- dsp_FSM:
    type FIFO_ch_window_readout_machine is (IDLE, SEND_HEADER, SEND_WINDOWS_FOR_EACH_CHANNEL);
    signal DATA_TRANSFER_STATE : FIFO_ch_window_readout_machine := IDLE;
-- sm_data_out
    signal ch_number : std_logic_vector(3 downto 0):= "0000";
    signal  total_wins : std_logic_vector(3 downto 0):= "0000";
    signal sample_counter : std_logic_vector(5 downto 0):= "000000";
    signal window_counter : slv (3 downto 0) := (others => '0');
    constant total_ch : std_logic_vector(3 downto 0):= "0000";
    constant window_samples : std_logic_vector(5 downto 0):= "100000";
    constant HEADER_WORD :std_logic_vector(23 downto 0) := x"DA6AC9";
    signal DC_RESPONSE_data : slv (31 downto 0) := (others => '0'); 
    signal RES_VALID_data : slv( NUM_DCs downto 0):= (others => '0'); 

    --QBlink connections to data fifos
    signal  qblink_tvalid_i : slv (chls-1 downto 0) := (others => '0');
    signal qblink_tready_i  : slv (chls-1 downto 0) := (others => '0');
    signal qblink_tdata_i :slv32(chls-1 downto 0) := (others=>(others => '0')); 
    --fifo slave side, always receiving data from targetX
    signal fifo_s_tready :  slv (chls-1 downto 0) := (others => '1');

    --single bus processing
    constant sys_clk_period       :  time := 7.87 ns;         
    signal sys_clk                : std_logic := '0';
    signal rst                : std_logic := '0';
    -- signal mode               : std_logic_vector(2 downto 0) := (others => '0');
    signal ena                : std_logic := '0';
    signal asic_mask          : std_logic := '1';
    signal first_dig_win      : std_logic_vector(8 downto 0);
    signal last_dig_win       : std_logic_vector(8 downto 0);
    -- SCROD config registers
    signal ramp_length        : std_logic_vector(11 downto 6) := (others => '0');
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
    --         -- DigStoreProcBusy      : out std_logic := '0';
    signal  DigNShiftBusy         : std_logic := '0';
    --         -- DigBusy               : out std_logic := '0';
    signal  ShiftOutWinBusy       : std_logic := '0';
    signal  ShiftOutSampBusy      : std_logic := '0';
       -- Clock period definitions
   constant DATA_CLK_period : time := 80 ns;
   constant usrClk_period : time := 8 ns;
   constant WORD_READ_DATA      : slv(31 downto 0) := x"72652124";
    --         -- FeatExtBusy           : out std_logic := '0';
    --         -- PedFetchQueueBusy     : out std_logic := '0';

    --         -- qblink
    -- signal  right2left            : std_logic := '0';
    -- signal  left2right            : std_logic := '0';

    -- signal win_start          : std_logic_vector(8 downto 0) := (others => '0');
    -- signal samp_start         : std_logic_vector(4 downto 0) := (others => '0');
    -- signal trig_bits          : slv5(4 downto 0) := (others=> "00000");
    -- signal ped_fetch_asic_no  : std_logic_vector(2 downto 0) := (others => '0');
    -- signal ped_fetch_chan     : std_logic_vector(3 downto 0) := (others => '0');
    -- signal ped_fetch_ena      : std_logic := '0';
    -- signal ped_fetch_ack      : std_logic := '0';
    -- signal ped_fifo_wr_asic   : std_logic_vector(4 downto 0) := (others => '0');
    -- signal ped_fifo_wr_chan   : std_logic_vector(3 downto 0) := (others => '0');
    -- signal ped_fifo_wr_ena    : std_logic := '0';
    -- signal ped_fifo_din       : std_logic_vector(11 downto 0) := (others => '0');
    signal BUS_RD_ENA         : std_logic := '0';
    signal BUS_RAMP           : std_logic := '0';
    signal BUS_CLR            : std_logic := '0';
    signal BUS_DO             : std_logic_vector(chls-1 downto 0) := (others => '0');
    signal SR_CLR             : std_logic := '0';
    signal SR_CLK             : std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');
    signal SR_SEL             : std_logic := '0';
    signal BUS_RD_WINSEL      : std_logic_vector(8 downto 0) := (others => '0');
    signal SAMPLESEL          : std_logic_vector(4 downto 0) := (others => '0');
    signal SAMPLESEL_ANY      : std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');
    signal sample_data           : slv12(chls-1 downto 0) := (others=>"000000000000");
    signal samples_valid         : std_logic := '0';
    -- signal busy_status        : std_logic_vector(4 downto 0) := (others => '0');
    -- signal rx_features_ack    : std_logic := '0';
    -- signal rx_features_ena    : std_logic := '0';
    -- signal last_hit           : std_logic := '0';
    -- signal charge             : std_logic_vector(11 downto 0) := (others => '0');
    -- signal le_time            : std_logic_vector(13 downto 0) := (others => '0');
    -- signal daq_chan           : std_logic_vector(6 downto 0) := (others => '0');
    -- signal ramp_length        : std_logic_vector(11 downto 6) := (others => '0');
    -- -- signal force_test_pattern : std_logic := '0';
    signal N_readout_samples  : std_logic_vector(8 downto 0) := "010000000";
    signal LE_time_thresh     : std_logic_vector(11 downto 0) := "110100010110";
    -- signal N_bits_avg         : std_logic_vector(3 downto 0) := (others=>'0');
    -- signal prime_fifos        : std_logic := '0';
    -- signal summing_ena        : std_logic := '0';
    -- signal avg_peds_ena       : std_logic := '0';
    -- signal avg_peds_busy      : std_logic := '0';
    -- signal wr_peds2sram_ena   : std_logic := '0';
    -- signal wr_peds2sram_ack   : std_logic := '0';
    -- signal even_ped           : std_logic_vector(11 downto 0) := (others => '0');
    -- signal odd_ped            : std_logic_vector(11 downto 0) := (others => '0');
    -- signal sram_asic_addr     : std_logic_vector(2 downto 0);
    -- signal sram_chan_addr     : std_logic_vector(3 downto 0);

    -- signal  baseline_g             : std_logic_vector(11 downto 0) := "110000000000";  -- 3072
    -- signal  SLOW_CTRL_BUFF         : integer := 5;
    -- signal  USE_PULSE_HEIGHT_HIST  : std_logic := '0';
    -- signal  USE_DBG_WAVE_FIFO      : std_logic := '0';
    -- signal  N_BITS_AVG_g           : integer;
--scrod, Commmand interpreter
   signal DC_RESP : std_logic_vector(31 downto 0) := (others => '0');
   signal DC_RESP_VALID : std_logic_vector(0 downto 0) := (others => '0');
   signal EVNT_FLAG : std_logic := '0';
   signal RX : std_logic_vector(0 downto 0) := (others => '0');
   signal TX : std_logic_vector(0 downto 0) := (others => '0');
   signal DC_CMD : std_logic_vector(31 downto 0) := (others => '0');
   signal CMD_VALID : std_logic_vector(0 downto 0) := (others => '0');
   signal RESP_REQ : std_logic_vector(0 downto 0) := (others => '0');
   signal DC_RESPONSE_scrod : std_logic_vector(31 downto 0);
   signal RESP_VALID_scrod : std_logic_vector(0 downto 0) := (others => '0');
   signal regAddr1 : std_logic_vector(15 downto 0);
   signal regWrData1 : std_logic_vector(15 downto 0);
   signal regReq1 : std_logic;
   signal regOp1 : std_logic;
	signal ldqblink : std_logic;
   signal regRdData1 : std_logic_vector(15 downto 0) := (others => '0');
   signal regAck : std_logic := '0';
 	--Outputs
   signal rxDataReady : std_logic;
   signal txData : std_logic_vector(31 downto 0);
   signal txDataValid : std_logic;
   signal txDataLast : std_logic;
   signal usrRst : std_logic := '0';
   signal rxData : std_logic_vector(31 downto 0) := (others => '0');
   signal rxDataValid : std_logic := '0';
   signal rxDataLast : std_logic := '0';
   signal txDataReady : std_logic := '0';
   signal cmd_int_state : std_logic_vector(4 downto 0);

	signal trgLinkSync1 : std_logic_vector(0 downto 0) := (others => '0');
	signal serialClkLck1 : std_logic_vector(0 downto 0) := (others => '0');
    signal QB_RST1 : std_logic_vector(0 downto 0) := (others => '0');
   constant sst5x_CLK_period : time := 16 ns;
	constant WORD_HEADER_C    : std_logic_vector(31 downto 0) := x"00BE11E2";
   constant WORD_COMMAND_C   : std_logic_vector(31 downto 0) := x"646F6974";
   constant WORD_PING_C      : std_logic_vector(31 downto 0) := x"70696E67";
	constant WORD_READ_C      : std_logic_vector(31 downto 0) := x"72656164";
   constant WORD_WRITE_C     : std_logic_vector(31 downto 0) := x"72697465";
   constant WORD_WRITE_DAC	: std_logic_vector(31 downto 0) := x"72697445"; 

	constant wordDC				: std_logic_vector(23 downto 0) := x"0000DC"; --command target is one or more DC
	constant broadcastDC       : std_logic_vector(7 downto 0)  := x"0A";

	constant WORD_PACKET_SIZE_C : std_logic_vector(31 downto 0) := x"00000006"; -- 6 words
	constant wordDC_01				: std_logic_vector(31 downto 0) := x"0000DC01"; --command target is one or more DC 
	constant WORD_COMMAND_ID_C  : std_logic_vector(31 downto 0) := x"00000012";

begin
    --mux to select data line or read/write registers
    DC_RESPONSE <= DC_RESPONSE_data when RES_VALID_reg ="0" else 
                   DC_RESPONSE_reg when RES_VALID_reg ="1";
    RES_VALID <= RES_VALID_data when RES_VALID_reg ="0"  else RES_VALID_reg;
    sync1 <= SYNC;



    -- clk_sync_output : process(DATA_CLK)
    -- begin
    --     if rising_edge(DATA_CLK) then
    --         SCLK <= TX_DAC_control1.SCLK;
    --         PCLK <= TX_DAC_control1.PCLK;
    --         SIN <= TX_DAC_control1.SIN; 
    --     end if; 
    -- end process;

 
    u_dc_receiver : entity work.DC_Comm_back port map(
        DATA_CLK => DATA_CLK,
        sstX5Clk  => sstX5Clk,
        RX => TX,
        TX =>RX,
        QB_RST => QB_RST1,
        DC_RESPONSE => DC_RESPONSE,
        RES_VALID => RES_VALID,            
        SERIAL_CLK_LCK => SERIAL_CLK_LCK,
        TRIG_LINK_SYNC => TRIG_LINK_SYNC,
        regAddr =>regAddr,
        regWrData => regWrData,
        regReq  => regReq,
        regOp => regOp,       
        sync => QB_RST1, --QB_RST --sync1
        dataReq => dataReq
        --start_win  => first_dig_win,
        --stop_win  => last_dig_win       
    );

    -- DC_reset_process : process(DATA_CLK) --unused for now 10/01
    -- ----variable counter : integer range 0 to 2 := 0;
    -- begin 
    --     IF rising_edge(DATA_CLK) THEN
    --     sync <= CtrlRegister(2)(NUM_DCs downto 0);
    --     QB_RST <= CtrlRegister(2)(NUM_DCs downto 0);
    --     --    DC_RESET <= CtrlRegister(2)(NUM_DCs downto 0); --by me
    --     END IF;
    -- end process;
	-- Instantiate the Unit Under Test (UUT)
   uut_dccomm: entity work.DC_Comm PORT MAP ( 
          DATA_CLK => DATA_CLK,
          sstX5Clk => sstX5Clk, 
          RX => RX,
          TX => TX,
          SYNC => QB_RST,
          DC_CMD => DC_CMD,
          CMD_VALID => CMD_VALID,
          RESP_REQ => RESP_REQ,
          DC_RESPONSE => DC_RESPONSE_scrod,
          RESP_VALID => RESP_VALID_scrod,
          QB_RST => QB_RST,
			--  TrigLogicRst => TrigLogicRst,
          SERIAL_CLK_LCK => serialClkLck1,
          TRIG_LINK_SYNC => trgLinkSync1
        );


   uut1: entity work.CommandInterpreter PORT MAP ( 
          usrClk => usrClk,
          dataClk => DATA_CLK,
          usrRst => usrRst,
          rxData => rxData,
          rxDataValid => rxDataValid,
          rxDataLast => rxDataLast,
          rxDataReady => rxDataReady,
          txData => txData,
          txDataValid => txDataValid,
          txDataLast => txDataLast,
          txDataReady => txDataReady,
          serialClkLck => serialClkLck1,
          trigLinkSync => trgLinkSync1,
          DC_CMD => DC_CMD,
          QB_WrEn => CMD_VALID,
          QB_RdEn => RESP_REQ,
          DC_RESP => DC_RESPONSE_scrod,
          DC_RESP_VALID => RESP_VALID_scrod,
          EVNT_FLAG => EVNT_FLAG,
          regAddr => regAddr1,
          regWrData => regWrData1,
          regRdData => regRdData1,
          regReq => regReq1,
          regOp => regOp1,
          regAck => regAck,
	      ldqblink => ldqblink,
          cmd_int_state => cmd_int_state
        ); 


    seqnn : process (DATA_CLK) is
    begin
        if (rising_edge(DATA_CLK)) then
            RES_VALID_reg(0) <= '0';
            regg <= registerT_null;
            DC_RESPONSE_reg  <= (others => '0');
            if QB_RST = "1" then
                DC_RESPONSE_reg  <= (others => '0');
                -- regAddr  <= (others => '0');
                -- regWrData  <= (others => '0');
            
            elsif regReq = '1' then
                if regOp = "00" then
                    DC_RESPONSE_reg <=  ZERO & CtrlRegister(to_integer(unsigned(regAddr)));
                    RES_VALID_reg(0) <= '1';
                elsif regOp = "01" then
                    CtrlRegister(to_integer(unsigned(regAddr))) <= regWrData; 
                    DC_RESPONSE_reg <=  ZERO & regAddr;
                    RES_VALID_reg(0) <= '1';  
                elsif regOp = "10" then
                    regg.address <= regAddr; 
                    regg.value <= regWrData; 
                    DC_RESPONSE_reg <=  ZERO & regAddr;
                    RES_VALID_reg(0) <= '1';               
                end if;
            end if;
        end if;
    end process;

Udc_data : entity work.SingleBusProcessing
    port map (
        clk        => sys_clk,
        rst         => sync1(0),

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
       -- N_readout_samples  => N_readout_samples,
        --LE_time_thresh      => LE_time_thresh,

        -- status registers
        --debug_we            => debug_we,
        --debug_wave          => debug_wave,
        --debug_pfull          => debug_pfull,
        -- DigStoreProcBusy      : out std_logic := '0';
        DigNShiftBusy       => DigNShiftBusy,
        -- DigBusy               : out std_logic := '0';
        ShiftOutWinBusy      => ShiftOutWinBusy,
        ShiftOutSampBusy     => ShiftOutSampBusy,
        -- FeatExtBusy           : out std_logic := '0';
        -- PedFetchQueueBusy     : out std_logic := '0';
        --data out
        sample_data           => sample_data,
        samples_valid         => samples_valid
        -- -- qblink
        -- right2left       => right2left,
        -- left2right       => left2right
    );

   data_fifos_generation : for i in 0 to chls-1 generate
      data_fifos: entity work.serial_data_window_fifo_w32d1024
  PORT MAP (
    m_aclk => DATA_CLK,
    s_aclk => sys_clk,
    s_aresetn => not sync1(0),
    s_axis_tvalid => samples_valid,
    s_axis_tready => fifo_s_tready(i),
    s_axis_tdata => ZERO1 & sample_data(i),
    m_axis_tvalid => qblink_tvalid_i(i),
    m_axis_tready => qblink_tready_i(i),
    m_axis_tdata => qblink_tdata_i(i)
  );
   end generate;


    transfer_data: process(DATA_CLK, sync1) --, asic_mask, asic_checklist, sr_asic_sel
    variable send_header1  :sl := '0';
    begin
        if rising_edge(DATA_CLK) then
            if sync1(0) = '1' then
                DATA_TRANSFER_STATE <= IDLE;
            else
                Case DATA_TRANSFER_STATE is
                    When IDLE =>
                        ch_number <= "0000";
                        --total_wins <= "0000";
                        send_header1 := '0';
                        for i in 0 to chls-1 loop  --earlier 14
                            qblink_tready_i(i) <= '0';
                        end loop;
                        if ( dataReq ='1' ) then   -- start (readout initiated)
                            ch_number <= "0000";
                            sample_counter <= "000000";
                            window_counter <="0000";
                            first_dig_win <= regAddr(8 downto 0);
                            last_dig_win <= regWrData(8 downto 0);
                            ena <= '1';
                            force_test_pattern <= regWrData(15);
                            -- total_wins <= std_logic_vector(unsigned(last_dig_win) - unsigned(first_dig_win)) + '1';
                            DATA_TRANSFER_STATE <= SEND_HEADER;
                            send_header1 := '1';
                        else
                            DATA_TRANSFER_STATE <= IDLE;
                        end if;


                    When SEND_HEADER =>
                        -- qblink_tready_i(to_integer(unsigned(ch_number)))<= '0';
                        if send_header1 = '1' then
                            DC_RESPONSE_data <= HEADER_WORD & ch_number & window_counter;
                            RES_VALID_data(0) <= '1';
                            send_header1 := '0';
                        else
                            DATA_TRANSFER_STATE <= SEND_WINDOWS_FOR_EACH_CHANNEL;
                            RES_VALID_data(0) <= '0';
                        end if;


                    When SEND_WINDOWS_FOR_EACH_CHANNEL =>
                        RES_VALID_data(0) <= '0';
                        for i in 0 to chls-1 loop  --earlier 14
                            qblink_tready_i(i) <= '0';
                        end loop;
                        if window_counter < (std_logic_vector(unsigned(last_dig_win) - unsigned(first_dig_win)) + '1') then
                            if sample_counter < window_samples then
                                qblink_tready_i(to_integer(unsigned(ch_number))) <= '1';
                                if qblink_tvalid_i(to_integer(unsigned(ch_number))) = '1' then
                                    DC_RESPONSE_data <=  qblink_tdata_i(to_integer(unsigned(ch_number)));
                                    RES_VALID_data(0) <= '1';
                                    sample_counter <= sample_counter + '1';
                                    DATA_TRANSFER_STATE <= SEND_WINDOWS_FOR_EACH_CHANNEL;
                                end if;
                            elsif sample_counter = window_samples then
                                sample_counter <= "000000";
                                DATA_TRANSFER_STATE <= SEND_HEADER;
                                send_header1 := '1';
                                if ch_number < total_ch then
                                    ch_number <= ch_number + '1';
                                elsif ch_number = total_ch then   
                                    window_counter <= window_counter + '1'; 
                                    ch_number <= "0000";
                                end if;
                            end if;     
                        else
                            DATA_TRANSFER_STATE <= IDLE;
                            ena <= '0';
                        end if;
                end case;
            end if;    
        end if;
    end process;



   -- Clock process definitions
   DATA_CLK_process :process
   begin
		DATA_CLK <= '0';
		wait for DATA_CLK_period/2;
		DATA_CLK <= '1';
		wait for DATA_CLK_period/2;
   end process;

   sst5x_CLK_process :process
   begin
		sstX5Clk <= '0';
		wait for sst5x_CLK_period/2;
		sstX5Clk <= '1';
		wait for sst5x_CLK_period/2;
   end process;

   USR_CLK_process :process
   begin
		usrClk <= '0';
		wait for usrClk_period/2;
		usrClk <= '1';
		wait for usrClk_period/2;
   end process;

   SYS_CLK_process :process
   begin
		sys_clk <= '0';
		wait for usrClk_period/2;
		sys_clk <= '1';
		wait for usrClk_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin		

        wait for 100 ns;
        wait for DATA_CLK_period*10;
		QB_RST <= "1"; -- "1111";
        QB_RST1 <= "1";

      -- hold reset state for 100 ns.
      --wait for 100 ns;	
      wait for DATA_CLK_period*10;
		QB_RST <= "0"; -- "0000";
        QB_RST1 <= "0";



    wait until TRIG_LINK_SYNC(0) = '1';
    -- wait until serialClkLck1(0) = '1' and trgLinkSync1(0) = '1';
	wait for DATA_CLK_period*2;


    wait for usrClk_period*10;
	
		rxDataValid <= '1';
		rxDataLast <= '0';
		rxData <= WORD_HEADER_C;  
		
		
      wait until rxDataReady = '1';
		wait for usrClk_period;

		rxData <= WORD_PACKET_SIZE_C;

		wait for usrClk_period;

		rxData <= WORD_COMMAND_C;
		wait for usrClk_period;

		rxData <= wordDC_01;     --wordDC_01;          --wordScrodRevC;
		
		wait for usrClk_period;
		
		rxData <= WORD_COMMAND_ID_C;
		wait for usrClk_period;
		--WORD_PING_C | WORD_WRITE_C | WORD_READ_C depending upon type of command
		rxData <= WORD_WRITE_DAC;  --WORD_WRITE_C;  --WORD_PING_C
--- only for Reg Wr/Rd command--	
-- first 4 MSBs are Reg Value, last 4 [LSBs] are Reg Addr
-- For Reg Read command, Reg Value [4 MSBs] = 0000 by default, give address in last 4.
      wait for usrClk_period;
      rxData <= x"0006000A";  -- x"0006000A";         
-----------------------------		
	  wait for usrClk_period;
 
	-- Command Checksum: for ping x"70696e79" -- for write (Reg 2 value 1: 00010002)=>x"726A7479"	
	-- for Read (Reg 2: 00000002) => x"72656178"
		rxData <= x"726f7461";  --x"726f7481";  x"726f7461";
        -- rxDataLast <= '1';       
		txDataReady <= '1';

        -- rxDataValid <= '0';
		

		wait for usrClk_period;

		-- rxData <= PACKET_CHECKSUM;
        -- wait for usrClk_period;
        rxDataLast <= '1';
        wait for usrClk_period;
        rxDataLast <= '0';
        rxDataValid <= '0';
        -- txDataReady <= '0';
      wait for usrClk_period*10;
    --   txDataReady <= '0';
      wait for usrClk_period*10;
      wait until txdatalast='1';
      txDataReady <= '0';



-- read
    wait for usrClk_period*100;
    -- wait for 1600 ns;
	
		rxDataValid <= '1';
		rxDataLast <= '0';
		rxData <= WORD_HEADER_C;  
		
		
      wait until rxDataReady = '1';
		wait for usrClk_period;

		rxData <= WORD_PACKET_SIZE_C;

		wait for usrClk_period;

		rxData <= WORD_COMMAND_C;
		wait for usrClk_period;

		rxData <= wordDC_01;     --wordDC_01;          --wordScrodRevC;
		
		wait for usrClk_period;
		
		rxData <= WORD_COMMAND_ID_C;
		wait for usrClk_period;
		--WORD_PING_C | WORD_WRITE_C | WORD_READ_C depending upon type of command
		rxData <= WORD_READ_C;  --WORD_PING_C
--- only for Reg Wr/Rd command--	
-- first 4 MSBs are Reg Value, last 4 [LSBs] are Reg Addr
-- For Reg Read command, Reg Value [4 MSBs] = 0000 by default, give address in last 4.
      wait for usrClk_period;
      rxData <= x"0000000A";         
-----------------------------		
		wait for usrClk_period;

	-- Command Checksum: for ping x"70696e79" -- for write (Reg 2 value 1: 00010002)=>x"726A7479"	
	-- for Read (Reg 2: 00000002) => x"72656178"
		rxData <= x"72656180";        
		txDataReady <= '1';

        -- rxDataValid <= '0';
		

		wait for usrClk_period;

		-- rxData <= PACKET_CHECKSUM;
        wait for usrClk_period;
        rxDataLast <= '1';
        wait for usrClk_period;
        rxDataLast <= '0';
        rxDataValid <= '0';
        -- txDataReady <= '0';
      wait for usrClk_period*10;
    --   txDataReady <= '0';
      wait for usrClk_period*10;
      wait until txdatalast='1';
      txDataReady <= '0';
    --   wait;

    -- READ OUT DATA

    wait for usrClk_period*100;
    -- wait for 1600 ns;
	
		rxDataValid <= '1';
		rxDataLast <= '0';
		rxData <= WORD_HEADER_C;  
		
		
      wait until rxDataReady = '1';
		wait for usrClk_period;

		rxData <= WORD_PACKET_SIZE_C;

		wait for usrClk_period;

		rxData <= WORD_COMMAND_C;
		wait for usrClk_period;

		rxData <= wordDC_01;     --wordDC_01;          --wordScrodRevC;
		
		wait for usrClk_period;
		
		rxData <= WORD_COMMAND_ID_C;
		wait for usrClk_period;
		--WORD_PING_C | WORD_WRITE_C | WORD_READ_C depending upon type of command
		rxData <= WORD_READ_DATA;  --WORD_PING_C
--- only for Reg Wr/Rd command--	
-- first 4 MSBs are Reg Value, last 4 [LSBs] are Reg Addr
-- For Reg Read command, Reg Value [4 MSBs] = 0000 by default, give address in last 4.
      wait for usrClk_period;
      rxData <= x"01030100";  --       
-----------------------------		
		wait for usrClk_period;

	-- Command Checksum: for ping x"70696e79" -- for write (Reg 2 value 1: 00010002)=>x"726A7479"	
	-- for Read (Reg 2: 00000002) => x"72656178"
		rxData <= x"73682236";        
		txDataReady <= '1';

        -- rxDataValid <= '0';
		
        BUS_DO   <= "1";
		wait for usrClk_period;

		-- rxData <= PACKET_CHECKSUM;
        wait for usrClk_period;
        rxDataLast <= '1';
        wait for usrClk_period;
        rxDataLast <= '0';
        rxDataValid <= '0';
        -- txDataReady <= '0';
      wait for usrClk_period*10;
    --   txDataReady <= '0';
      wait for usrClk_period*10;
      wait until txdatalast='1';
      txDataReady <= '0';
      wait;

    end process;


end architecture;