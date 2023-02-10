library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all;

--! Digitize and process event on common motherboard bus (5 ASICs per bus)
--!
--! |Engineer|Create Date|
--! |-|-|
--! |Chris Ketter| 07/18/2019|
--!
--!### Operation of SingleBusProcessing module:
--! <p>The SingleBusProcessing module is a container for all of the modules
--! needed to digitize and process waveforms for 5 asics which are all on a
--! common bus</p>
--! <p>A simple state machine below initiates the digitization process and
--! waits for it to finish.</p>

entity SingleBusProcessing is

    generic (
        baseline_g             : std_logic_vector(11 downto 0) := "110000000000";  -- 3072
        SLOW_CTRL_BUFF         : integer := 5;
        USE_PULSE_HEIGHT_HIST  : std_logic := '0';
        USE_DBG_WAVE_FIFO      : std_logic := '0';
        chls                    : integer :=1;
        N_BITS_AVG_g           : integer := 7
    );
    port (
        clk                   : in  std_logic := '0';
        rst                   : in  std_logic := '0';
        -- ped_sub_ena           : in std_logic;
        -- disambig_tb5          : in std_logic;
        -- measure_peds          : in std_logic;
        -- stream_peds           : in std_logic;
        ena                   : in  std_logic := '0';
        -- win_samp_start        : in  slv14(4 downto 0) := (others => (others=>'0')); --by me
        -- trig_bits             : in  slv5(4 downto 0) := (others=> "00000");
        asic_mask             : in  std_logic := '1'; -- std_logic_vector(4 downto 0) := (others => '0');
        first_dig_win         : in std_logic_vector(8 downto 0);
        last_dig_win          : in std_logic_vector(8 downto 0);
        -- -- pedestal data
        -- ped_fetch_asic_no     : out std_logic_vector(2 downto 0) := (others => '0');
        -- ped_fetch_chan        : out std_logic_vector(3 downto 0) := (others => '0');
        -- ped_win_samp_start    : out std_logic_vector(13 downto 0) := (others => '0');
        -- ped_fetch_ena         : out std_logic := '0';
        -- ped_fetch_ack         : in  std_logic := '0';
        -- ped_fifo_wr_asic      : in  std_logic_vector(4 downto 0) := (others => '0');
        -- ped_fifo_wr_chan      : in  std_logic_vector(3 downto 0) := (others => '0');
        -- ped_fifo_wr_ena       : in  std_logic := '0';
        -- ped_fifo_din          : in  std_logic_vector(11 downto 0) := (others => '0');

        -- wires for/to/from TargetX
        -- bus_mask              : out std_logic_vector(13 downto 0) := (others => '0');
        BUS_RD_ENA            : out std_logic := '0';
        BUS_RAMP              : out std_logic := '0';
        BUS_CLR               : out std_logic := '0';
        BUS_DO                : in  std_logic_vector(chls-1 downto 0) := (others => '0');
        SR_CLR                : out std_logic := '0';
        SR_CLK                : out std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');
        SR_SEL                : out std_logic := '0'; -- set high & pulse sr_clk once to load test pattern
        BUS_RD_WINSEL         : out std_logic_vector(8 downto 0) := (others => '0');
        SAMPLESEL             : out std_logic_vector(4 downto 0) := (others => '0');
        SAMPLESEL_ANY         : out std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');


        -- -- wires to HitDataSerializer
        -- rx_features_ack       : in  std_logic := '0';
        -- rx_features_ena       : out std_logic := '0';
        -- last_hit              : out std_logic := '0';
        -- -- null_hit              : out std_logic := '0';
        -- peak                : out std_logic_vector(11 downto 0) := (others => '0');
        -- le_time               : out std_logic_vector(8 downto 0) := (others => '0');
        -- daq_chan              : out std_logic_vector(6 downto 0) := (others => '0');
        -- daq_asic              : out integer range 0 to 4 := 0;

        -- SCROD config registers
        ramp_length           : in  std_logic_vector(11 downto 6) := "011110";-- 6
        force_test_pattern    : in  std_logic := '0';
        t_samp_addr_settle    : in std_logic_vector(3 downto 0) := "0110";-- 6
        t_setup_ss_any        : in std_logic_vector(3 downto 0) := "0110";-- 6
        t_strobe_settle       : in std_logic_vector(3 downto 0) := "0100";-- 4
        t_sr_clk_high         : in std_logic_vector(3 downto 0) := "0010";-- 2
        t_sr_clk_low          : in std_logic_vector(3 downto 0) := "0010";-- 2
        t_sr_clk_strobe       : in std_logic_vector(3 downto 0) := "0110";-- 6
        -- N_readout_samples     : in  std_logic_vector(8 downto 0);
        -- LE_time_thresh        : in  std_logic_vector(11 downto 0) := "110100010110"; -- 3350

        -- status registers
        -- debug_we              : out std_logic := '0';
        -- debug_wave            : out std_logic_vector(11 downto 0) := (others => '0');
        -- debug_pfull           : in  std_logic := '0';
        -- DigStoreProcBusy      : out std_logic := '0';
        DigNShiftBusy         : out std_logic := '0';
        -- DigBusy               : out std_logic := '0';
        ShiftOutWinBusy       : out std_logic := '0';
        ShiftOutSampBusy      : out std_logic := '0';
        --data out
        sample_data           : out slv12(chls-1 downto 0) := (others=>"000000000000");
        samples_valid         : out std_logic := '0'

        -- FeatExtBusy           : out std_logic := '0';
        -- PedFetchQueueBusy     : out std_logic := '0';

        -- -- qblink
        -- right2left            : out std_logic := '0';
        -- left2right            : out std_logic := '0'

        -- Ped calc mode
        -- prime_fifos           : in  std_logic := '0';
        -- summing_ena           : in  std_logic := '0';
        -- avg_peds_ena          : in  std_logic := '0';
        -- avg_peds_busy         : out std_logic := '0';
        -- wr_peds2sram_ena      : out std_logic := '0';
        -- wr_peds2sram_ack      : in  std_logic := '0';
        -- even_ped              : out std_logic_vector(11 downto 0) := (others => '0');
        -- odd_ped               : out std_logic_vector(11 downto 0) := (others => '0');
        -- sram_asic_addr        : out std_logic_vector(2 downto 0) := (others => '0');
        -- sram_chan_addr        : out std_logic_vector(3 downto 0) := (others => '0');
        -- sram_samp_addr        : out std_logic_vector(4 downto 1) := (others => '0');
        -- avg_peds_debug        : out std_logic_vector(2 downto 0) := "000";
        -- fe_dbg                   : out std_logic_vector(1 downto 0) := "00";
        -- ped_dbg                   : out std_logic_vector(1 downto 0) := "00";


        -- signals for measuring single-photon spectra
        -- SPS_hist_rd_ena       : in std_logic := '0';
        -- sps_reset             : in  std_logic := '0';
        -- SPS_hist_rd_addr      : in std_logic_vector(9 downto 0) := (others => '0');
        -- SPS_hist_rd_data      : out std_logic_vector(15 downto 0) := (others => '0')
    );
end SingleBusProcessing;


architecture Behavioral of SingleBusProcessing is

-- SYNCHRONOUS SIGNALS BY PROCESS WHICH DRIVES THEM

    -- -- SC_buffering:
    -- signal all_fifos_empty : std_logic_vector(SLOW_CTRL_BUFF downto 0);

    -- -- fifo_rst_fan5:
    -- signal fifo_rst_r1 : std_logic_vector(4 downto 0) := (others=>'0');

    -- -- fifo_rst_fan3:
    -- signal fifo_rst_r2 : std_logic_vector(14 downto 0) := (others=>'0');

    -- rst_buff:
    signal proc_reset  : std_logic := '0';
    signal asic_mask_i             :  std_logic := '1'; 

    -- -- ped_fifo_ch_mux:
    -- signal ped_fifo_wr_ena_q1  : std_logic_vector(14 downto 0) := (others=>'0');
    -- signal ped_fifo_wr_ena_q2  : std_logic_vector(14 downto 0) := (others=>'0');
    -- signal ped_fifo_din_q1     : std_logic_vector(11 downto 0) := (others=>'0');
    -- signal ped_fifo_din_q2     : std_logic_vector(11 downto 0) := (others=>'0');

    -- -- wave_fifo_ch_wr:
    -- type wave_fifo_din_t is record wr_ena : std_logic_vector(14 downto 0); din : slv12(14 downto 0); end record;
    -- constant WAVE_DIN_BUFF_DEPTH : integer := 3;
    -- type buff_wave_fifo_din_t is array (WAVE_DIN_BUFF_DEPTH - 1 downto 0) of wave_fifo_din_t;
    -- constant wave_fifo_din_t0 : wave_fifo_din_t := (wr_ena => (others=>'0'), din => (others=>(others=>'0')));
    -- signal wave_fifo : buff_wave_fifo_din_t := (others => wave_fifo_din_t0);

    -- -- ch_mask_proc:
    -- signal new_mask_q1  : slv15(4 downto 0) := (others => "000000000000000");

    -- -- fifo_dout_buff:
    -- signal fifo_dout_q1        : slv24(14 downto 0) := (others=>(others=>'0'));
    -- signal fifos_valid_q1      : std_logic := '0';

    -- -- fifo_rd_mux:
    -- signal fifo_rd_ena_q1      : std_logic_vector(14 downto 0) := (others=>'0');
    -- signal fifos_valid_q2      : std_logic := '0';
    -- signal fifo_dout_q2        : std_logic_vector(23 downto 0) := (others=>'0');

    -- -- dsp_ena_buff:
    signal dig_store_proc_ena  : std_logic_vector(1 downto 0) := (others => '0');
    signal force_test_pattern_ena  : std_logic_vector(1 downto 0) := (others => '0');
    signal force_test_pattern_i    :  std_logic := '0';

    -- dsp_FSM:
    type SingleBusProcessing_machine is (IDLE, WAIT_DIG_N_SHIFT);
    signal single_bus_state : SingleBusProcessing_machine := IDLE;
    signal digNshift_ena    : std_logic := '0';
    signal digNshift_done   : std_logic := '0';
    -- signal r_digNshift_done : std_logic_vector(3 downto 0) := (others=>'0');
    -- signal proc_ena         : std_logic := '0';
    -- signal r_proc_ena       : std_logic_vector(3 downto 0) := (others=>'0');
    -- signal thr_chk_ena      : std_logic := '0';
    -- signal ped_queue_ena    : std_logic := '0';

-- ASYNCHRONOUSLY DRIVEN SIGNALS
    -- signal tb5arr      : std_logic_vector(4 downto 0);

-- SIGNALS DRIVEN BY INSTANTIATED ENTITIES

    -- -- TrigBit2Mask_i:
    -- signal chan_mask : slv15(4 downto 0) := (others => "000000000000000");

    -- DigitizeAndShiftOutData_i:
    signal digNshift_busy      : std_logic := '0';
    signal main_samp_in_0 : slv12(chls-1 downto 0) := (others=>"000000000000"); -- slv12(14 downto 0) := (others=>"000000000000"); -- to threshold check
    signal samples_valid1 : std_logic := '0';

    -- 15 channel fifis
    -- signal i_s_axis_tready :std_logic;
    -- signal wave_fifo_wr_asic_q0 : std_logic_vector(4 downto 0) := "00001"; -- DigitizeAndShiftOutData to ThresholdCheck

    -- -- ThresholdCheck_i:
    -- signal thr_chk_busy      : std_logic := '0';
    -- signal wave_fifo_wr_asic_q1 : std_logic_vector(4 downto 0) := "00001"; -- ThresholdCheck to WaveAndPedStaging
    -- signal new_mask_q0  : slv15(4 downto 0) := (others => "000000000000000");

    -- -- WaveAndPedStaging_i:
    -- signal fifo_dout_q0        : slv24(14 downto 0) := (others=>(others=>'0'));
    -- signal fifos_valid_q0      : std_logic_vector(14 downto 0) := (others => '0');
    -- signal fifos_empty : std_logic_vector(14 downto 0) := (others=>'0');

    -- -- ProcWaveform_i:
    -- signal fifo_rst : std_logic := '0';
    -- signal fifo_asic_sel       : std_logic_vector(4 downto 0) := "00001";
    -- signal fifo_chan_sel       : std_logic_vector(3 downto 0) := (others=>'0');
    -- signal fifo_rd_ena_q0      : std_logic := '0';

    -- -- PedFetchQueue_i:
    -- signal ped_queue_busy : std_logic := '0';
    -- signal ped_fetch_int_asic : integer range 0 to 4 := 0;


    -- attribute keep : string;
    -- attribute keep of fifo_rst : signal is "true";
    -- attribute keep of all_fifos_empty : signal is "true";

begin

--------------------- ASYNCHRONOUS LOGIC ---------------------------------------------

    -- ped_win_samp_start <= first_dig_win & "00000";  --#TODO change to first_dig_win_samp in calc ROI
    -- ped_win_samp_start <= win_samp_start(ped_fetch_int_asic);
    -- PedFetchQueueBusy <= ped_queue_busy;
    DigNShiftBusy <= digNshift_busy;
    sample_data <= main_samp_in_0;
    samples_valid <= samples_valid1;
    asic_mask_i <= asic_mask;
    -- tb5arr <= trig_bits(4)(4) & trig_bits(3)(4) & trig_bits(2)(4) & trig_bits(1)(4) & trig_bits(0)(4);

--------------------- SYNCHRONOUS LOGIC ---------------------------------------------

    -- SC_buffering: process(clk, fifos_empty, all_fifos_empty)
    -- begin
    --     if rising_edge(clk) then
    --         all_fifos_empty(0) <= and_reduce(fifos_empty);
    --         all_fifos_empty(all_fifos_empty'left downto 1) <= all_fifos_empty(all_fifos_empty'left-1 downto 0);
    --     end if;
    -- end process;

    -- fifo_rst_fan5: process(clk, fifo_rst)
    -- begin
    --     if rising_edge(clk) then
    --         for i in 0 to 4 loop
    --             fifo_rst_r1(i) <= fifo_rst;
    --         end loop;
    --     end if;
    -- end process;

    -- fifo_rst_fan3: process(clk, fifo_rst_r1)
    -- begin
    --     if rising_edge(clk) then
    --         for i in 0 to 4 loop
    --             for j in 0 to 2 loop
    --                 fifo_rst_r2(3*i + j) <= fifo_rst_r1(i);
    --             end loop;
    --         end loop;
    --     end if;
    -- end process;

    rst_buff: process(clk, rst)
    begin
        if rising_edge(clk) then
            proc_reset <= rst;
        end if;
    end process;

    -- ped_fifo_ch_mux: process(clk, ped_fifo_wr_ena, ped_fifo_wr_chan, ped_fifo_din)
    -- begin
    --     if rising_edge(clk) then
    --         ped_fifo_wr_ena_q1 <= (others => '0');
    --         ped_fifo_wr_ena_q1(to_integer(unsigned(ped_fifo_wr_chan))) <= ped_fifo_wr_ena;
    --         ped_fifo_wr_ena_q2 <= ped_fifo_wr_ena_q1;
    --         ped_fifo_din_q1 <= ped_fifo_din;
    --         ped_fifo_din_q2 <= ped_fifo_din_q1;
    --     end if;
    -- end process ped_fifo_ch_mux;

    -- wave_fifo_ch_wr: process(clk, wave_fifo)
    -- begin
    --     if rising_edge(clk) then
    --         wave_fifo(wave_fifo'left downto 1) <= wave_fifo(wave_fifo'left - 1 downto 0);
    --     end if;
    -- end process wave_fifo_ch_wr;

    -- ch_mask_proc: process(clk, new_mask_q0, use_ftsw_trig, chan_mask)
    -- begin
    --     if rising_edge(clk) then
    --         if use_ftsw_trig = '1' then
    --             new_mask_q1 <= new_mask_q0; 
    --         else
    --             new_mask_q1 <= chan_mask;
    --         end if;
    --     end if;
    -- end process;    
    
    -- ch_mask_proc: process(clk, new_mask_q0, disambig_tb5, chan_mask, tb5arr)
    -- begin
    --     if rising_edge(clk) then
    --         if disambig_tb5 = '1' then
    --             for i in 0 to 4 loop
    --                 if tb5arr(i) = '1' then
    --                     new_mask_q1(i) <= new_mask_q0(i); 
    --                 else
    --                     new_mask_q1(i) <= chan_mask(i);
    --                 end if;
    --             end loop;
    --         else
    --             new_mask_q1 <= chan_mask;
    --         end if;
    --     end if;
    -- end process;    
    
    -- fifo_dout_buff: process(clk, fifo_dout_q0, fifos_valid_q0)
    -- begin
    --     if rising_edge(clk) then
    --         fifo_dout_q1 <= fifo_dout_q0;
    --         fifos_valid_q1  <= or_reduce(fifos_valid_q0);
    --     end if;
    -- end process;

    -- fifo_rd_mux : process(clk, fifo_chan_sel, fifo_dout_q1, fifos_valid_q1)
    -- begin
    --     if rising_edge(clk) then
    --         fifo_rd_ena_q1 <= (others => '0');
    --         fifos_valid_q2 <= fifos_valid_q1;
    --         case fifo_chan_sel is
    --             when "0000" =>
    --                 fifo_rd_ena_q1(0) <= fifo_rd_ena_q0; 
    --                 fifo_dout_q2 <= fifo_dout_q1(0);
    --             when "0001" =>
    --                 fifo_rd_ena_q1(1) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(1);
    --             when "0010" =>
    --                 fifo_rd_ena_q1(2) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(2);
    --             when "0011" =>
    --                 fifo_rd_ena_q1(3) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(3);
    --             when "0100" =>
    --                 fifo_rd_ena_q1(4) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(4);
    --             when "0101" =>
    --                 fifo_rd_ena_q1(5) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(5);
    --             when "0110" =>
    --                 fifo_rd_ena_q1(6) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(6);
    --             when "0111" =>
    --                 fifo_rd_ena_q1(7) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(7);
    --             when "1000" =>
    --                 fifo_rd_ena_q1(8) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(8);
    --             when "1001" =>
    --                 fifo_rd_ena_q1(9) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(9);
    --             when "1010" =>
    --                 fifo_rd_ena_q1(10) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(10);
    --             when "1011" =>
    --                 fifo_rd_ena_q1(11) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(11);
    --             when "1100" =>
    --                 fifo_rd_ena_q1(12) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(12);
    --             when "1101" =>
    --                 fifo_rd_ena_q1(13) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(13);
    --             when "1110" =>
    --                 fifo_rd_ena_q1(14) <= fifo_rd_ena_q0;
    --                 fifo_dout_q2 <= fifo_dout_q1(14);
    --             when Others =>
    --                 fifos_valid_q2 <= '0';
    --         end case;
    --     end if;
    -- end process fifo_rd_mux;

    --detect start rising edge
    dsp_ena_buff: process (clk, ena, dig_store_proc_ena)
    begin
        if rising_edge(clk) then
            dig_store_proc_ena <= dig_store_proc_ena(0) & ena;
            force_test_pattern_ena <= force_test_pattern_ena(0) & force_test_pattern; -- make force_test_pattern=1 with ena
        end if;
    end process;

    -- Digitize_Store_And_Process_Event 
    dsp_FSM: process(clk, asic_mask, dig_store_proc_ena,
            digNshift_ena, digNshift_busy) 
    begin
        if rising_edge(clk) then
            if rst = '1' then
                single_bus_state <= IDLE;
                -- DigStoreProcBusy <= '0';
                digNshift_ena <= '0';
                -- thr_chk_ena <= '0';
                -- ped_queue_ena <= '0';
            else

                Case single_bus_state is

                    When IDLE =>
                        digNshift_ena <= '0';
                        force_test_pattern_i <= '0';
                        -- ped_queue_ena <= '0';
                        -- digNshift_done <= '0';
                        -- proc_ena <= '0';
                        if dig_store_proc_ena = "01" and asic_mask = '1' then -- dig_store_proc_ena = "01" and or_reduce(asic_mask) = '1' then
                            -- ped_queue_ena <= (ped_sub_ena or stream_peds) and not measure_peds;
                            single_bus_state <= WAIT_DIG_N_SHIFT;
                            -- thr_chk_ena <= '1';
                            digNshift_ena <= '1';
                            if force_test_pattern_ena = "01" then
                                force_test_pattern_i <= '1';
                            else
                                force_test_pattern_i <= '0';
                            end if;
                        else
                            single_bus_state <= IDLE;
                        end if;

                    
                    When WAIT_DIG_N_SHIFT =>
                        digNshift_ena <= '0';
                        -- thr_chk_ena <= '0';
                        -- ped_queue_ena <= '0';
                        if (digNshift_ena or digNshift_busy) = '0' then
                            digNshift_done <= '1';
                        end if;
                        if (digNshift_ena or digNshift_busy ) = '1' then -- or ped_queue_busy
                            single_bus_state <= WAIT_DIG_N_SHIFT;
                        else
                            -- proc_ena <= '1';
                            single_bus_state <= IDLE;
                        end if;

                 end case;
            end if;
        end if;
    end process;

    -- digNshift_done_ppln: process(clk, digNshift_done)
    -- begin
    --     if rising_edge(clk) then
    --         r_digNshift_done <= r_digNshift_done(r_digNshift_done'left - 1 downto 0) & digNshift_done;
    --     end if;
    -- end process;

    -- proc_ena_ppln: process(clk, proc_ena)
    -- begin
    --     if rising_edge(clk) then
    --         r_proc_ena <= r_proc_ena(r_proc_ena'left - 1 downto 0) & proc_ena;
    --     end if;
    -- end process;


---------------------BEGIN MODULES ---------------------------------------------
    -- TrigBit2Mask_i: for i in 0 to 4 generate
    --     U0_i : entity work.TrigBit2Mask
    --     port map (
    --         clk       => clk,
    --         bits      => trig_bits(i),-- input(i) = 5bit "trigger bits" for ASIC i
    --         ch_mask   => chan_mask(i)
    --     );
    -- end generate;

    DigitizeAndShiftOutData_i: entity work.DigitizeAndShiftOutData
    port map (
        clk                => clk,
        rst                => proc_reset,
        ena                => digNshift_ena,
        busy               => digNshift_busy,

        -- event information (state machine input parameters)
        -- win_samp_start_asic => win_samp_start,
        asic_mask          => asic_mask_i,
        first_dig_win      => first_dig_win,
        last_dig_win       => last_dig_win,

        -- wires to ThresholdCheck
        sample_data        => main_samp_in_0,
        samples_valid     => samples_valid1,
        -- current_asic       => wave_fifo_wr_asic_q0, by me

        -- control registers
        ramp_length        => ramp_length,
        force_test_pattern => force_test_pattern_i,
        t_samp_addr_settle => t_samp_addr_settle,
        t_setup_ss_any     => t_setup_ss_any,
        t_strobe_settle    => t_strobe_settle,
        t_sr_clk_high      => t_sr_clk_high,
        t_sr_clk_low       => t_sr_clk_low,
        t_sr_clk_strobe    => t_sr_clk_strobe,
        -- N_readout_samples  => N_readout_samples,

        -- status registers
        -- DigBusy            => DigBusy,
        ShiftOutWinBusy    => ShiftOutWinBusy,
        ShiftOutSampBusy   => ShiftOutSampBusy,

        -- pins to TargetX
        ---- digitization control
        BUS_RD_ENA         => BUS_RD_ENA,
        BUS_CLR            => BUS_CLR,
        BUS_RAMP           => BUS_RAMP,
        BUS_RD_WINSEL      => BUS_RD_WINSEL,

        ---- shift register data and control
        BUS_DO             => BUS_DO,
        SR_CLR             => SR_CLR,
        SR_CLK             => SR_CLK,
        SR_SEL             => SR_SEL,
        SAMPLESEL          => SAMPLESEL,
        SAMPLESEL_ANY      => SAMPLESEL_ANY
    );


--    -- Instantiate DC QBlink
--     DC_QBlink : entity work.QBlink 
--     PORT MAP(
--         sstClk => sst5xClk,
--         rst => rst,
--         rawSerialOut => right2left,
--         rawSerialIn => left2right,
--         localWordIn => main_samp_in_0,
--         localWordInValid => samples_valid,
--         localWordOut => dc_data,
--         localWordOutValid => dc_dataValid,
--         localWordOutReq => rd_req,
--         trgLinkSynced => trgLinkSync,
--         serialClkLocked => serialClkLck
--     );
--    --FIFOs for data of 15 channels
--    data_fifos_generation : for i in 0 to 14 generate
--       data_buff:  wrapped_serial_data_window_fifo_w32d1024
--   PORT MAP (
--     s_aclk => s_aclk,
--     s_aresetn => not rst,
--     s_axis_tvalid => samples_valid,
--     s_axis_tready => fifo_tready,
--     s_axis_tdata => main_samp_in_0(i),
--     m_axis_tvalid => data_tvalid,
--     m_axis_tready => m_axis_tready,
--     m_axis_tdata => m_axis_tdata,
--     axis_overflow => axis_overflow,
--     axis_underflow => axis_underflow
--   );
--    end generate;


--     ThresholdCheck_i : entity work.ThresholdCheck
--     -- generic map (
--         -- tb5_disambig_thr_g  => tb5_disambig_thr_g,
--         -- PED_AVG_g           => PED_AVG_g
--     -- )
--     port map (
--         clk               => clk,
--         rst               => proc_reset,
--         ena               => thr_chk_ena,
--         busy              => thr_chk_busy,

--         -- wires from ShiftOutSample
--         sample_data       => main_samp_in_0,
--         samples_valid     => samples_valid,
--         digNshift_done    => r_digNshift_done,

--         -- input parameters
--         chan_mask         => chan_mask,
--         asic              => wave_fifo_wr_asic_q0,

--         -- wires to WaveAndPedStaging
--         wave_fifo_wr_ena  => wave_fifo(wave_fifo'right).wr_ena,
--         wave_fifo_din     => wave_fifo(wave_fifo'right).din,
--         wave_fifo_wr_asic => wave_fifo_wr_asic_q1,

--         -- threshold results for downstream processing
--         new_mask          => new_mask_q0
--     );

--     WaveAndPedStaging_i : for i in 0 to 14 generate
--         WaveAndPedStaging_ii : entity work.WaveAndPedStaging
--         port map (
--             clk               => clk,
--             reset             => fifo_rst_r2(i),
--             prime_fifos       => prime_fifos,
--             summing_ena       => summing_ena,

--             wave_fifo_wr_asic => wave_fifo_wr_asic_q1,
--             wave_fifo_wr_ena  => wave_fifo(wave_fifo'left).wr_ena(i),
--             main_samp_in      => wave_fifo(wave_fifo'left).din(i),
--             ped_fifo_wr_asic  => ped_fifo_wr_asic,
--             ped_fifo_wr_ena   => ped_fifo_wr_ena_q2(i),
--             ped_fifo_din      => ped_fifo_din_q2,
--             fifo_rd_asic      => fifo_asic_sel,
--             fifo_rd_ena       => fifo_rd_ena_q1(i),
--             fifo_dout         => fifo_dout_q0(i),
--             fifo_drdy         => fifos_valid_q0(i),
--             fifos_empty       => fifos_empty(i)
--         );
--     end generate;

--     ProcWaveform_i : entity work.ProcWaveform
-- generic map (
--         baseline_g               => baseline_g,
--         USE_PULSE_HEIGHT_HIST    => USE_PULSE_HEIGHT_HIST,
--         USE_DBG_WAVE_FIFO        => USE_DBG_WAVE_FIFO,
--         N_BITS_AVG_g             => N_BITS_AVG_g
-- )
--     port map (
--         clk                 => clk,
--         rst                 => proc_reset,
--         ena                 => r_proc_ena(r_proc_ena'left),

--         -- control registers
--         ped_sub_ena         => ped_sub_ena,
--         -- use_ftsw_trig       => use_ftsw_trig,
--         -- use_loop_trig       => use_loop_trig,
--         measure_peds        => measure_peds,
--         stream_peds         => stream_peds,
--         N_readout_samples   => N_readout_samples,
--         LE_time_thresh      => LE_time_thresh,

--         -- status registers
--         -- busy                => FeatExtBusy,
--         debug_we            => debug_we,
--         debug_wave          => debug_wave,
--         debug_pfull         => debug_pfull,

--         -- event info
--         win_samp_start      => win_samp_start,
--         ch_mask             => new_mask_q1,

--         -- fifo access
--         fifo_rst            => fifo_rst,
--         fifo_asic_sel       => fifo_asic_sel,
--         fifo_chan_sel       => fifo_chan_sel,
--         fifo_rd_ena         => fifo_rd_ena_q0,
--         fifo_dout           => fifo_dout_q2,
--         fifo_drdy           => fifos_valid_q2,
--         fifos_empty         => all_fifos_empty(all_fifos_empty'left),

--         -- wires to HitDataSerializer
--         rx_features_ack     => rx_features_ack,
--         rx_features_ena     => rx_features_ena,
--         last_hit            => last_hit,
--         -- null_hit            => null_hit,
--         peak              => peak,
--         le_time             => le_time,
--         daq_chan            => daq_chan,
--         daq_asic            => daq_asic,

--         -- wires needed for pedestal measurement
--         avg_peds_ena        => avg_peds_ena,
--         avg_peds_busy       => avg_peds_busy,
--         wr_peds2sram_ena    => wr_peds2sram_ena,
--         wr_peds2sram_ack    => wr_peds2sram_ack,
--         even_ped            => even_ped,
--         odd_ped             => odd_ped,
--         sram_asic_addr      => sram_asic_addr,
--         sram_chan_addr      => sram_chan_addr,
--         sram_samp_addr      => sram_samp_addr,
--         -- fe_dbg              => fe_dbg,
--         sps_reset           => sps_reset,
--         SPS_hist_rd_addr    => SPS_hist_rd_addr,
--         SPS_hist_rd_data    => SPS_hist_rd_data
--     );

--     PedFetchQueue_i : entity work.PedFetchQueue
--     port map (
--         clk                => clk,
--         rst                => proc_reset,
--         ena                => ped_queue_ena,
--         busy               => ped_queue_busy,
    
--         -- event info
--         ch_mask            => chan_mask,
--         new_mask           => new_mask_q1,
--         thr_chk_busy       => thr_chk_busy,
    
--         -- wires to PedestalFetcher
--         fetch_ena          => ped_fetch_ena,
--         fetch_ack          => ped_fetch_ack,
--         asic_addr          => ped_fetch_asic_no,
--         int_asic           => ped_fetch_int_asic,
--         chan_addr          => ped_fetch_chan
--     );

end Behavioral;
