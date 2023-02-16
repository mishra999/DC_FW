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
 
entity DC_FPGA_TOP is	
    generic (
        NUM_DCs : integer := 0 ;
        chls : integer :=1;
        counter_win_max : integer := 120000
    );  
  port (
 
        -- SYSCLK_P       	 :  IN sl;
        -- SYSCLK_N       	 :  IN sl;
        DATA_CLK_P        : IN slv(NUM_DCs downto 0);
        DATA_CLK_N        : IN slv(NUM_DCs downto 0);
        RX_DC_P			 : IN slv(NUM_DCs downto 0);  --SERIAL INPUT FROM DC
        RX_DC_N			 : IN slv(NUM_DCs  downto 0);  --SERIAL INPUT FROM DC
        TX_DC_N         : OUT slv(NUM_DCs downto 0);  --Serial output to DC
        TX_DC_P			 : OUT slv(NUM_DCs downto 0);--Serial output to DC 
        SYNC_P			 : IN slv(NUM_DCs downto 0); -- when '0' DC listens only, '1' DC reads back command
        SYNC_N			 : IN slv(NUM_DCs downto 0);
        --! ASIC DAC Update Signals
        SCLK             : OUT std_logic;
        -- REG_CLR: std_logic;
        SIN              : OUT std_logic;
        PCLK             : OUT std_logic;
--Bus Specific Signals
        BUS_WR_ADDRCLR          : out std_logic;
        BUS_RD_ENA              : out std_logic;
        BUS_RD_ROWSEL           : out std_logic_vector(2 downto 0);
        BUS_RD_COLSEL           : out std_logic_vector(5 downto 0);
        BUS_CLR                 : out std_logic;
        BUS_RAMP                : out std_logic;
        SAMPLESEL           : out std_logic_vector(4 downto 0);
        SR_CLR            : out std_logic;
        SR_SEL              : out std_logic;
        TX_DATA                  : in  std_logic_vector(chls-1 downto 0); --14 used to be
        -- DC_RESET        : in slv(NUM_DCs DOWNTO 0)		-- Commented by Shivang on Oct 8, 2020

        --! Digitization and sampling signals
        WL_CLK_N                 : out std_logic_vector(NUM_DCs downto 0);
        WL_CLK_P                 : out std_logic_vector(NUM_DCs downto 0);
        WR1_ENA                  : out std_logic_vector(NUM_DCs downto 0);
        WR2_ENA                  : out std_logic_vector(NUM_DCs downto 0);

        SSTIN_N                  : out std_logic_vector(NUM_DCs downto 0);
        SSTIN_P                  : out std_logic_vector(NUM_DCs downto 0);

        --! Serial Readout Signals
        SR_CLK                 : out std_logic := '0';
        SAMPLESEL_ANY            : out std_logic := '0'
  );
end entity;    
 
  
architecture rtl of DC_FPGA_TOP is
    -- signal i_clk              : std_logic;
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
    signal write_dac    : sl:= '0';
    signal DC_RESPONSE : slv (31 downto 0) := (others => '0'); 
    signal RES_VALID : slv( NUM_DCs downto 0):= (others => '0'); 
    signal DC_RESPONSE_reg : slv (31 downto 0) := (others => '0'); 
    signal RES_VALID_reg : slv( NUM_DCs downto 0):= (others => '0'); 
	-- signal  GLOB_EVNT_P :  STD_LOGIC_VECTOR(3 downto 0);
    -- signal GLOB_EVNT_N :  STD_LOGIC_VECTOR(3 downto 0);
    -- signal  GLOB_EVNT :  STD_LOGIC_VECTOR(3 downto 0);
    constant N_GPR : integer := 5;--127;
    signal counter_send_win : slv (31 downto 0) := (others => '0');
    type GPR is array(N_GPR-1 downto 0) of std_logic_vector(15 downto 0);   
    signal CtrlRegister : GPR:= (others => x"0000");
    signal LOCKED : sl:='0';
    signal RESET : sl:='0';
    signal RESET1 : sl:='0';
    signal sync1 : slv(NUM_DCs downto 0) := (others =>'0');
    signal Clk_to_QBLink : sl;
    constant ZERO : std_logic_vector(15 downto 0) := x"0000";
    constant ZERO1 : std_logic_vector(19 downto 0) := x"00000";
-- mppc dac
--    signal regg      : registerT := registerT_null;
--    signal TX_DAC_control1 : TX_DAC_control := TX_DAC_control_null; 
-- dsp_FSM:
    type FIFO_ch_window_readout_machine is (IDLE, SEND_HEADER, SEND_WINDOWS_FOR_EACH_CHANNEL);
    signal DATA_TRANSFER_STATE : FIFO_ch_window_readout_machine := IDLE;
-- sm_data_out
    signal ch_number : std_logic_vector(3 downto 0):= "0000";
    -- signal  total_wins : std_logic_vector(3 downto 0):= "0000";
    signal sample_counter : std_logic_vector(5 downto 0):= "000000";
    signal window_counter : slv (8 downto 0) := (others => '0');
    constant total_ch : std_logic_vector(3 downto 0):= "0001";
    constant window_samples : std_logic_vector(5 downto 0):= "100000";
    constant HEADER_WORD :std_logic_vector(23 downto 0) := x"DA6AC9";
    signal DC_RESPONSE_data : slv (31 downto 0) := (others => '0'); 
    signal RES_VALID_data : slv( NUM_DCs downto 0):= (others => '0'); 
    -- signal DC_RESPONSE_data_i

    --QBlink connections to data fifos, used to be 14 lines, now 2
    signal  qblink_tvalid_i : slv (chls-1 downto 0) := (others => '0');
    signal qblink_tready_i  : slv (chls-1 downto 0) := (others => '0');
    signal qblink_tdata_i :slv32(chls-1 downto 0) := (others=>(others => '0')); 
    --fifo slave side, always receiving data from targetX
    signal fifo_s_tready : slv (chls-1 downto 0) := (others => '1');

    --single bus processing
    -- constant clk_period       :  time := 7.87 ns;         
    signal sys_clk                : std_logic := '0';
    -- signal rst                : std_logic := '0';
    -- signal mode               : std_logic_vector(2 downto 0) := (others => '0');
    signal ena                : std_logic := '0';
    signal asic_mask          : std_logic := '1';
    signal first_dig_win      : std_logic_vector(8 downto 0);
    signal last_dig_win       : std_logic_vector(8 downto 0);
    signal twin       : std_logic_vector(8 downto 0);
    -- SCROD config registers
    signal ramp_length        : std_logic_vector(11 downto 6) := "010000"; --16
    signal  force_test_pattern    :std_logic := '0';
    signal  t_samp_addr_settle    :std_logic_vector(3 downto 0) := "0000";-- 0
    signal  t_setup_ss_any        : std_logic_vector(3 downto 0) := "0010";-- 2
    signal  t_strobe_settle       :std_logic_vector(3 downto 0) := "0000";-- 0
    signal   t_sr_clk_high         : std_logic_vector(3 downto 0) := "0011";-- 3
    signal  t_sr_clk_low          : std_logic_vector(3 downto 0) := "0010";-- 2
    signal   t_sr_clk_strobe       : std_logic_vector(3 downto 0) := "0001";-- 1
            -- status registers
    -- signal  debug_we              : std_logic := '0';
    -- signal  debug_wave            : std_logic_vector(11 downto 0) := (others => '0');
    -- signal  debug_pfull           :  std_logic := '0';
    --         -- DigStoreProcBusy      : out std_logic := '0';
    signal  DigNShiftBusy         : std_logic := '0';
    --         -- DigBusy               : out std_logic := '0';
    signal  ShiftOutWinBusy       : std_logic := '0';
    signal  ShiftOutSampBusy      : std_logic := '0';
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
    -- signal BUS_RD_ENA         : std_logic := '0';
    -- signal BUS_RAMP           : std_logic := '0';
    -- signal BUS_CLR            : std_logic := '0';
    -- signal BUS_DO             : std_logic_vector(14 downto 0) := (others => '0');
    -- signal SR_CLR             : std_logic := '0';
    -- signal SR_CLK             : std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');
    -- signal SR_SEL             : std_logic := '0';
    signal BUS_RD_WINSEL      : std_logic_vector(8 downto 0) := (others => '0');
    -- signal SAMPLESEL          : std_logic_vector(4 downto 0) := (others => '0');
    -- signal SAMPLESEL_ANY      : std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');
    signal sample_data           : slv12(chls-1 downto 0) := (others=>"000000000000"); --used to be 14 lines
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
    -- signal N_readout_samples  : std_logic_vector(8 downto 0) := "010000000";
    -- signal LE_time_thresh     : std_logic_vector(11 downto 0) := "110100010110";
    -- signal BUS_WINSEL         : std_logic_vector(8 downto 0) := (others => '0');
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
    --!  targetx_dac_control_i (targetx_dac_control):
    signal asic_sin               : std_logic := '0';
    signal asic_pclk              : std_logic := '0';
    signal asic_sclk              : std_logic := '0';
    signal tx_dac_load_period  : std_logic_vector(15 downto 0) := (others => '0');
    signal tx_dac_latch_period  : std_logic_vector(15 downto 0) := (others => '0');
    signal tx_dac_update : std_logic := '0';
    signal tx_dac_reg_data : std_logic_vector(18 downto 0) := (others => '0');
    signal tx_dac_busy : std_logic := '0';


    signal BUSB_WR_ADDRCLR : std_logic := '0';
    signal cur_win_ii : std_logic_vector(8 downto 0) := "000000000";
    signal cur_win : std_logic_vector(8 downto 0) := "000000000";
    -- constant null_TX_ana_wr_ena_mask : TARGETX_analong_wr_ena_mask_t := ('0','0',"000000000","000000000");
    -- signal ana_wr_ena_mask : TARGETX_analong_wr_ena_mask_t := null_TX_ana_wr_ena_mask;
    signal ctime : std_logic_vector(26 downto 0) := "000000000000000000000000000"; --2023
    -- wilkinson clock
    signal wilk_clk : std_logic_vector(0 downto 0);
    signal stateNum_dtransfer : slv(1 downto 0);
    signal data_flag: sl := '0';
    attribute mark_debug : string;
    attribute mark_debug of stateNum_dtransfer : signal is "true";
    -- attribute mark_debug1 : string;
    attribute mark_debug of window_counter : signal is "true";
    


begin
    --mux to select data line or read/write registers
    DC_RESPONSE <= DC_RESPONSE_data when data_flag ='1' else 
                   DC_RESPONSE_reg when data_flag ='0';
    RES_VALID <= RES_VALID_data when data_flag ='1'  else RES_VALID_reg;
    sync1 <= SYNC;

    stateNum_dtransfer <= 	"00" when DATA_TRANSFER_STATE = IDLE else
                            "01" when DATA_TRANSFER_STATE = SEND_HEADER else
                            "10" when DATA_TRANSFER_STATE = SEND_WINDOWS_FOR_EACH_CHANNEL;

    SCLK <= asic_sclk;
    PCLK <= asic_pclk;
    SIN <= asic_sin; 

    BUS_RD_ROWSEL <= BUS_RD_WINSEL(2 downto 0);
    BUS_RD_COLSEL <= BUS_RD_WINSEL(8 downto 3);
    -- clk_sync_output : process(DATA_CLK)
    -- begin
    --     if rising_edge(DATA_CLK) then
    --         SCLK <= TX_DAC_control1.SCLK;
    --         PCLK <= TX_DAC_control1.PCLK;
    --         SIN <= TX_DAC_control1.SIN; 
    --     end if; 
    -- end process;


    clk_buffer : entity work.clk_gen1  
    port map
    (-- Clock in ports
        CLK_IN1_P => DATA_CLK_P(0), 
        CLK_IN1_N => DATA_CLK_N(0),
        -- Clock out ports
        CLK_OUT1 => DATA_CLK,
        CLK_OUT2 => Clk_to_QBLink,  
        CLK_OUT3 => sys_clk,
        -- Status and control signals
        RESET  => RESET, 
        LOCKED => LOCKED);
	 
    DC_IO_BUFF : entity work.IO_Buffers_new
    generic map (num_DC => NUM_DCs)
    PORT MAP(
        RX_P => RX_DC_P, 
        RX_N => RX_DC_N,
        TX => tx_dc,
        -- DATA_CLK_P => DATA_CLK_P,
        -- DATA_CLK_N => DATA_CLK_N,
        -- DATA_CLK => DATA_CLK, --by me 

        -- GLOB_EVNT => GLOB_EVNT,
        -- SYNC => sync,   
        TX_P => TX_DC_P,
        TX_N => TX_DC_N,
        -- GLOB_EVNT_P => GLOB_EVNT_P,
        -- GLOB_EVNT_N => GLOB_EVNT_N,
        RX => rx_dc,
        SYNC_P => SYNC_P,
        SYNC_N => SYNC_N,
        SYNC => SYNC 
        );
 
    u_dc_receiver : entity work.DC_Comm_back port map(
        DATA_CLK => DATA_CLK,
        sstX5Clk  => Clk_to_QBLink,
        RX => rx_dc,
        TX =>tx_dc,
        QB_RST => QB_RST,
        DC_RESPONSE => DC_RESPONSE,
        RES_VALID => RES_VALID,            
        SERIAL_CLK_LCK => SERIAL_CLK_LCK,
        TRIG_LINK_SYNC => TRIG_LINK_SYNC,
        regAddr =>regAddr,
        regWrData => regWrData,
        regReq  => regReq,
        regOp => regOp,       
        sync => sync1, --QB_RST --sync1
        dataReq => dataReq,
        write_dac => write_dac
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




--    mppc_wrapper_i : entity work.TX_DAC_control_w_regInterface
--    port map (
--     clk    => DATA_CLK,
--     rst    => sync1(0),


--     reg      => regg,


--     TX_DAC_control_out =>  TX_DAC_control1
    
--   );

tx_dac_reg_data     <= CtrlRegister(1)(6 downto 0) & CtrlRegister(2)(11 downto 0);
tx_dac_load_period  <= CtrlRegister(3);
tx_dac_latch_period <= CtrlRegister(4);
tx_dac_update <= write_dac; 

TARGETX_control: entity work.TARGETX_DAC_CONTROL
PORT MAP(
	--------------INPUTS-----------------------------
	CLK 				=> DATA_CLK,
	LOAD_PERIOD 	=> tx_dac_load_period, --comes from ctrl register 3
	LATCH_PERIOD 	=> tx_dac_latch_period,--comes from ctrl register 4
	UPDATE 			=> tx_dac_update,      --comes from DC_COMM_PARSER
	REG_DATA 		=> tx_dac_reg_data,    --comes from ctrl register 1 bit 6-0 and 2 bit 11-0
	--------------OUTPUTS----------------------------
	busy				=>	tx_dac_busy,    	  --unconnected
	SIN 				=> asic_sin, 					  --hardware signals to targetx
	SCLK 				=> asic_sclk,					  --hardware signals to targetx
	PCLK 				=> asic_pclk);				  --hardware signals to targetx




    seqnn : process (DATA_CLK) is
    begin
        if (rising_edge(DATA_CLK)) then
            RES_VALID_reg(0) <= '0';
            -- regg <= registerT_null;
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
                    CtrlRegister(1) <= regAddr; 
                    CtrlRegister(2) <= regWrData; 
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
        BUS_DO              => TX_DATA,
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
    s_aresetn => not RESET1,
    s_axis_tvalid => samples_valid,
    s_axis_tready => fifo_s_tready(i),
    s_axis_tdata => ZERO1 & sample_data(i),
    m_axis_tvalid => qblink_tvalid_i(i),
    m_axis_tready => qblink_tready_i(i),
    m_axis_tdata => qblink_tdata_i(i)
  );
   end generate;


    transfer_data: process(DATA_CLK) --, asic_mask, asic_checklist, sr_asic_sel
    begin
        if rising_edge(DATA_CLK) then
            ena <= '0';
            RES_VALID_data(0) <= '0';
            for i in 0 to chls-1 loop  --earlier 14
                qblink_tready_i(i) <= '0';
            end loop;
            -- send_header1 := '0';
            -- if RESET = '1' then
            --     DATA_TRANSFER_STATE <= IDLE;
            -- else
            Case DATA_TRANSFER_STATE is
                When IDLE =>
                    ch_number <= "0000";
                    --total_wins <= "0000";
                    -- send_header1 := '0';
                    RESET1 <= '1';
                    data_flag <='0';
                    first_dig_win <= regAddr(8 downto 0);
                    last_dig_win <= regWrData(8 downto 0);
                    -- for i in 0 to chls-1 loop  --earlier 14
                    --     qblink_tready_i(i) <= '0';
                    -- end loop;
                    if ( dataReq ='1' ) then   -- start (readout initiated)
                        ch_number <= "0000";
                        sample_counter <= "000000";
                        window_counter <="000000000";
                        counter_send_win <= (others =>'0');
                        -- twin <= (std_logic_vector(unsigned(last_dig_win) - unsigned(first_dig_win))) + '1';
                        ena <= '1';
                        force_test_pattern <= regWrData(15);
                        -- total_wins <= std_logic_vector(unsigned(last_dig_win) - unsigned(first_dig_win)) + '1';
                        DATA_TRANSFER_STATE <= SEND_HEADER; --SEND_HEADER
                        -- send_header1 := '1';
                        data_flag <='1';
                        RESET1 <= '0';
                    else
                        DATA_TRANSFER_STATE <= IDLE;
                    end if;


                When SEND_HEADER =>
                    -- qblink_tready_i(to_integer(unsigned(ch_number)))<= '0';
                    data_flag <='1';
                    twin <= (std_logic_vector(unsigned(last_dig_win) - unsigned(first_dig_win)));
                    if data_flag = '1' then
                        DC_RESPONSE_data(31 downto 8) <= HEADER_WORD;
                        DC_RESPONSE_data(7 downto 4) <= ch_number;
                        DC_RESPONSE_data(3 downto 0) <= window_counter(3 downto 0);
                        RES_VALID_data(0) <= '1';
                        -- send_header1 := '0';
                        DATA_TRANSFER_STATE <= SEND_WINDOWS_FOR_EACH_CHANNEL;
                        qblink_tready_i(to_integer(unsigned(ch_number))) <= '1';
                    else
                        DATA_TRANSFER_STATE <= IDLE;
                        -- DATA_TRANSFER_STATE <= SEND_WINDOWS_FOR_EACH_CHANNEL;
                        -- RES_VALID_data(0) <= '0';
                        -- qblink_tready_i(to_integer(unsigned(ch_number))) <= '1';
                    end if;


                When SEND_WINDOWS_FOR_EACH_CHANNEL =>
                    -- RES_VALID_data(0) <= '0';
                    data_flag <='1';
                    counter_send_win <= counter_send_win + '1';
                    qblink_tready_i(to_integer(unsigned(ch_number))) <= '1';                    
                    if sample_counter < window_samples then
                        if qblink_tvalid_i(to_integer(unsigned(ch_number))) = '1' and qblink_tready_i(to_integer(unsigned(ch_number))) = '1' then
                            -- qblink_tready_i(to_integer(unsigned(ch_number))) <= '1';
                            DC_RESPONSE_data <=  qblink_tdata_i(to_integer(unsigned(ch_number)));
                            RES_VALID_data(0) <= '1';
                            sample_counter <= sample_counter + '1';
                            counter_send_win <= (others =>'0');
                        else
                            DATA_TRANSFER_STATE <= SEND_WINDOWS_FOR_EACH_CHANNEL;
                        end if;
                    elsif sample_counter = window_samples then
                        -- for i in 0 to chls-1 loop  --earlier 14
                        --     qblink_tready_i(i) <= '0';
                        -- end loop;
                        if ch_number = (total_ch - '1') then 
                            if window_counter < twin then
                                window_counter <= window_counter + '1'; 
                                ch_number <= "0000"; 
                                sample_counter <= "000000";
                                DATA_TRANSFER_STATE <= SEND_HEADER;
                                -- send_header1 := '1';
                                qblink_tready_i(to_integer(unsigned(ch_number))) <= '0';
                            else
                                DATA_TRANSFER_STATE <= IDLE;                                        
                            end if;  
                        else
                            ch_number <= ch_number + '1';                            
                        end if;
                    end if; 
                    -- end if;
                    if counter_send_win = counter_win_max then
                        DATA_TRANSFER_STATE <= IDLE;   
                    end if; 

            end case;   
        end if;
    end process;


UUT_sampling : entity work.SamplingLgc
port map (
        clk             => sys_clk,
        reset           => sync1(0),
        sync_bit        => ctime(11), --it goes 1 at ctime=2048
        ctime64ns_bit   => ctime(2),  
        -- ana_wr_ena_mask => ana_wr_ena_mask,
        cur_win         => cur_win, 
        BUSA_WR_ADDRCLR => BUS_WR_ADDRCLR,
        BUSB_WR_ADDRCLR => BUSB_WR_ADDRCLR,
        WR1_ENA         => WR1_ENA,
        WR2_ENA         => WR2_ENA,
        SSTIN_N         => SSTIN_N,
        SSTIN_p         => SSTIN_p,
        -- i_ctime         => i_ctime, -- this is one clk period behind, just for checking, no worries!
        cur_win_ii    => cur_win_ii,
        digitize_busy   => DigNShiftBusy
        -- analog_store_state1  => analog_store_state1,
        -- masking_state1 => masking_state1, 
        -- mask_win_ctr1 => mask_win_ctr1
);

    ctime_gen : process(sys_clk)
    begin
        if rising_edge(sys_clk) then
            ctime <= ctime + "1";
        end if;
    end process ctime_gen;


    -- #CK had warning HDLCompiler:946 b/c "c1 => not clk" in previous ODDR2 inst." 
    -- Decided to bring out inverted clock directly from pll_base located in b2tt_clk_s6.
    wilkinson_clock_generation : for i in 0 to 0 generate
       -- make 2x clk using OLOGIC2 resources
       clock_frequency_doubling : ODDR2 port map (
          Q => wilk_clk(i),
          C0 => sys_clk,
          C1 => not(sys_clk),
          CE => '1',
          D0 => '0',
          D1 => '1',
          R => '0',
          S => '0'
       );
       -- make differential output
       differential_output_buffer : OBUFDS port map (i => wilk_clk(i), o => WL_CLK_P(i), ob => WL_CLK_N(i));
    end generate; 


end architecture;