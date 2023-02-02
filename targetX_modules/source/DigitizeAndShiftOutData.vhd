library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all;
--! Digitize and Shift out all samples in ROI
--! 
--! Chris Ketter. 09/18/2019.
--!     
--! <p>
--! One window at a time, this module will digitize
--! the window if it overlaps with the ROI,
--! then, one sample at a time,
--! it will shift out the sample if it's contained in the ROI.
--! All ASICs and channels are digitized in parallel.
--! Channels are shifted out in parallel, but asics are
--! shifted out serially.
--! Only ASICs specified in i_asic_mask are shifted out.
--! Each time a single sample has been shifted out,
--! samples_valid goes high so that the sample
--! can be received by ThresholdCheck.vhd and
--! written into the appropriate processing FIFO
--! <\p>
  
entity DigitizeAndShiftOutData is
    generic (
        chls : integer :=1
    );
    port (
        clk                 : in  std_logic := '0';
        rst                 : in  std_logic := '0';
        ena                 : in  std_logic := '0';
        busy                : out std_logic := '0';

        -- state machine input parameters
        -- win_samp_start_asic : in  std_logic_vector(13 downto 0) := (others=>'0'); -- slv14(4 downto 0) := (others => (others=>'0'));
        -- samp_start            : in  slv5(4 downto 0) := (others => "00000");
        asic_mask           : in std_logic := '1'; -- std_logic_vector(4 downto 0) := (others=>'0');
        first_dig_win       : in std_logic_vector(8 downto 0) := (others=>'0');
        last_dig_win        : in std_logic_vector(8 downto 0) := (others=>'0');

        -- wires to ThresholdCheck
        sample_data         : out slv12(chls-1 downto 0) := (others=>"000000000000");
        samples_valid       : out std_logic := '0'; -- samplesel & valid flag
        -- samples_sel         : out std_logic_vector(4 downto 0) := (others=>'0');
        -- current_asic        : out std_logic_vector(4 downto 0) := "00001"; --by me

        -- control registers
        ramp_length         : in std_logic_vector (5 downto 0); -- std_logic_vector (11 downto 6);
        force_test_pattern  : in std_logic := '0';
        t_samp_addr_settle  : in std_logic_vector(3 downto 0) := "0110";-- 6
        t_setup_ss_any      : in std_logic_vector(3 downto 0) := "0110";-- 6
        t_strobe_settle     : in std_logic_vector(3 downto 0) := "0100";-- 4
        t_sr_clk_high       : in std_logic_vector(3 downto 0) := "0010";-- 2
        t_sr_clk_low        : in std_logic_vector(3 downto 0) := "0010";-- 2
        t_sr_clk_strobe     : in std_logic_vector(3 downto 0) := "0110";-- 6
        -- N_readout_samples   : in std_logic_vector(8 downto 0) := (others=>'0');
        -- status registers
        -- DigBusy             : out std_logic := '0';
        ShiftOutWinBusy     : out std_logic := '0';
        ShiftOutSampBusy    : out std_logic := '0';

        -- pins to TargetX
        ---- digitization control
        BUS_RD_ENA          : out std_logic := '0';
        BUS_CLR             : out std_logic := '0';
        BUS_RAMP            : out std_logic := '0';
        BUS_RD_WINSEL       : out std_logic_vector(8 downto 0) := (others=>'0');

        ---- shift register data and control
        BUS_DO              : in  std_logic_vector(chls-1 downto 0) := (others=>'0');
        SR_CLR              : out std_logic := '0';
        SR_CLK              : out std_logic := '0'; -- std_logic_vector(4 downto 0) := (others=>'0');
        SR_SEL              : out std_logic := '0';
        SAMPLESEL           : out std_logic_vector(4 downto 0) := (others=>'0');
        SAMPLESEL_ANY       : out std_logic := '0' -- std_logic_vector(4 downto 0) := (others=>'0')
        -- digNshift_state1 : out digitize_and_shift_out_window_data := IDLE

    );
end DigitizeAndShiftOutData;


architecture Behavioral of DigitizeAndShiftOutData is


    -- type digitize_and_shift_out_window_data is (
    --     IDLE,
    --     WAIT_DIG_BUSY_TO_COME_UP,      -- next_state = (WAIT_DIG_BUSY_TO_COME_UP) or (IDLE)
    --     WAIT_DIG_WINDOW,
    --     WAIT_SHIFT_BUSY_TO_COME_UP,
    --     WAIT_SHIFT_OUT  ---- next_state = WAIT_DIG_BUSY_TO_COME_UP
    -- ); 

    signal digNshift_state : digitize_and_shift_out_window_data := IDLE;

    -- internal state machine signals
    signal i_asic_mask          : std_logic := '1'; -- std_logic_vector(4 downto 0);
    signal ena_i                : std_logic := '0';
    -- signal count                : std_logic_vector(7 downto 0) := "00000000";
    -- signal earliest_win_samp            : std_logic_vector(8 downto 0) := (others=>'0');
    signal first_dig_win_i          : std_logic_vector(8 downto 0) := (others=>'0');
    signal BUS_RD_WINSEL_i      : std_logic_vector(8 downto 0) := (others=>'0');
    -- signal i_win_samp_start_asic : std_logic_vector(13 downto 0) := (others=>'0'); -- slv14(4 downto 0) := (others => (others=>'0'));

    -- ShiftOutWindow signals
    signal shift_ena       : std_logic := '0';
    signal shift_asic_mask   : std_logic := '0'; -- std_logic_vector(4 downto 0);
    signal shift_samp_start : std_logic_vector(4 downto 0) := (others=>'0'); -- slv5(4 downto 0) := (others=>(others=>'0'));
    signal shift_samp_stop  : std_logic_vector(4 downto 0) := (others=>'1'); -- slv5(4 downto 0) := (others=>(others=>'1'));
    signal shift_busy      : std_logic := '0';


    -- DigitizingLgcTX signals
    signal dig_ena         : std_logic := '0';
    signal dig_busy        : std_logic := '0';


----------------------------------------
begin

    BUS_RD_WINSEL <= BUS_RD_WINSEL_i; 
    ShiftOutWinBusy <= shift_busy;
    -- digNshift_state1 <= digNshift_state;
    -- DigBusy <= dig_busy;    
    DigLgc_i : entity work.DigitizingLgcTX
        port map (
        clk                 => clk,
        rst                 => rst,
        ena                 => dig_ena,
        busy                => dig_busy,

        -- control registers
        -- force_test_pattern  => force_test_pattern,
        ramp_length         => ramp_length,

        -- pins to TargetX
        BUS_RD_ENA          => BUS_RD_ENA,
        BUS_CLR             => BUS_CLR,
        BUS_RAMP            => BUS_RAMP
    );


    ShftWin_i : entity work.ShiftOutWindow
    port map (
        clk                => clk,
        rst                => rst,
        ena                => shift_ena,
        busy               => shift_busy,
        force_test_pattern => force_test_pattern,
        t_samp_addr_settle => t_samp_addr_settle, 
        t_setup_ss_any     => t_setup_ss_any,
        t_strobe_settle    => t_strobe_settle,
        t_sr_clk_high      => t_sr_clk_high  ,
        t_sr_clk_low       => t_sr_clk_low   ,
        t_sr_clk_strobe    => t_sr_clk_strobe ,
        ShiftOutSampBusy   => ShiftOutSampBusy,
        asic_mask          => shift_asic_mask,
        samp_start_asic    => shift_samp_start,
        samp_stop_asic     => shift_samp_stop,
        samples_valid      => samples_valid,
        -- sample_sel         => sample_sel,
        sample_data        => sample_data,
        -- current_asic       => current_asic, --by me
        BUS_DO             => BUS_DO,
        SR_CLR             => SR_CLR,
        SR_CLK             => SR_CLK,
        SR_SEL             => SR_SEL,
        SAMPLESEL          => SAMPLESEL,
        SAMPLESEL_ANY      => SAMPLESEL_ANY
    );


    --detect start rising edge
    process (clk, ena)
    begin
        if rising_edge(clk) then
            ena_i <= ena;
        end if;
    end process;


    process (clk, first_dig_win)
    begin
        if rising_edge(clk) then
            first_dig_win_i <= first_dig_win;
        end if;
    end process;



    process(clk, rst, ena_i, ena, first_dig_win_i, asic_mask,
            dig_busy, BUS_RD_WINSEL_i, shift_busy, last_dig_win)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                digNshift_state <= IDLE;
            else
                Case digNshift_state is
                    
                    When IDLE =>
                        shift_asic_mask <= '0'; -- (others=>'0');
                        shift_samp_stop <= "11111"; -- (others=>"11111");
                        if ( ena_i = '0' and ena = '1' ) then
                            busy <= '1';
                            BUS_RD_WINSEL_i <= first_dig_win_i; -- set initial window address , same as 'win_start' in tb
                            -- count <= "00100000" - ("000" & samp_start); -- num samps shifted out in first win
                            -- i_win_samp_start_asic <= win_samp_start_asic; -- by me
                            -- samp_start_asic <= samp_start;
                            dig_ena <= '1';
                            i_asic_mask <= asic_mask;
                            digNshift_state <= WAIT_DIG_BUSY_TO_COME_UP;
                        else
                            -- count <= (others=>'0');
                            -- i_win_samp_start_asic <= (others=>'0'); -- (others=>(others=>'0'));
                            BUS_RD_WINSEL_i <= (others=>'0');
                            shift_ena <= '0';
                            dig_ena <= '0';
                            busy <= '0';
                            digNshift_state <= IDLE;
                        end if;
                    
                    When WAIT_DIG_BUSY_TO_COME_UP =>
                        dig_ena <= '1';
                        if dig_busy = '1' then
                            digNshift_state <= WAIT_DIG_WINDOW;
                        else
                            digNshift_state <= WAIT_DIG_BUSY_TO_COME_UP;
                        end if;
                    
                    When WAIT_DIG_WINDOW =>
                        dig_ena <= '0';
                        if dig_busy = '1' then
                            digNshift_state <= WAIT_DIG_WINDOW;
                        else
                            digNshift_state <= WAIT_SHIFT_BUSY_TO_COME_UP;
                            shift_ena <= '1';
                            -- for i in 0 to 4 loop
                            if i_asic_mask = '1' then -- (i) 
                                -- determine whether current dig win should be shifted out for this asic, i_win_samp_start_asic= 9b(w_start) & 5b(s_start), if 31 - s_number < readout_s + 32
                                -- if (BUS_RD_WINSEL_i & "11111") - i_win_samp_start_asic < ("00000" & N_readout_samples) + "100000" then --(i)
                                shift_asic_mask <= '1'; --(i)
                                -- end if;
                                shift_samp_start <= "00000";
                                shift_samp_stop <= "11111";
                            else
                                shift_asic_mask <= '0'; --(i)
                            end if; 
                            --     -- determine if sample to shift out for this asic
                            -- if BUS_RD_WINSEL_i = i_win_samp_start_asic(13 downto 5) then --(i)
                            --     shift_samp_start <= i_win_samp_start_asic(4 downto 0); --(i) --(i)
                            -- else
                            --     shift_samp_start <= "00000"; --(i)
                            -- end if;
                            -- -- determine last sample to shift out for this asic
                            -- if unsigned(BUS_RD_WINSEL_i) = shift_right(unsigned(i_win_samp_start_asic + ("00000" & N_readout_samples)), 5) then -- (i)
                            --     shift_samp_stop<= i_win_samp_start_asic + N_readout_samples; -- (i) -- (i) 
                            -- else
                            --     shift_samp_stop <= "11111"; -- (i)
                            -- end if;
                                
                            -- end if;
                            -- end loop;
                        end if;

                    
                    When WAIT_SHIFT_BUSY_TO_COME_UP =>
                        shift_ena <= '1';
                        if shift_busy = '1' then
                            digNshift_state <= WAIT_SHIFT_OUT;
                        else
                            digNshift_state <= WAIT_SHIFT_BUSY_TO_COME_UP;
                        end if;
                    
                    When WAIT_SHIFT_OUT =>
                        shift_ena <= '0';
                        if shift_busy = '1' then
                            digNshift_state <= WAIT_SHIFT_OUT;
                        else
                            -- shift_samp_start <= "00000";
                            if BUS_RD_WINSEL_i /= last_dig_win then
                                BUS_RD_WINSEL_i <= BUS_RD_WINSEL_i + "000000001"; -- automatically rolls over at window 512
                                dig_ena <= '1';
                                digNshift_state <= WAIT_DIG_BUSY_TO_COME_UP;
                            else
                                dig_ena <= '0';
                                busy <= '0';
                                digNshift_state <= IDLE;
                            end if;
                            
                        end if;
                    
                    When OTHERS =>
                        digNshift_state <= IDLE;
                    
                end case;
            end if;
        end if;
    end process;


end Behavioral;
