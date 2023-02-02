library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all;
--! Shift Out TargetX Window Data.
--! Chris Ketter. 09/18/2019.
--!
--! <p>Loops over all ASICs declared in asic_mask.
--! Enables ShiftOutSample.vhd once for each sample in
--! the range from samp_start[asic] to samp_stop[asic].</p>
--!
--! #### Input requirements:
--! 
--!<pre>
--!samp_start[asic] <  samp_stop[asic],
--!samp_start[asic] >= 0,
--!samp_stop[asic]  <  32</pre>
--!

entity ShiftOutWindow is
    generic (
        chls : integer :=1
    );
    port (
        clk                : in  std_logic := '0';
        rst                : in  std_logic := '0';
        ena                : in  std_logic := '0';
        busy               : out std_logic := '0';

        -- control registers
        force_test_pattern : in  std_logic := '0';
        t_samp_addr_settle : in std_logic_vector(3 downto 0) := "0110";-- 6
        t_setup_ss_any     : in std_logic_vector(3 downto 0) := "0110";-- 6
        t_strobe_settle    : in std_logic_vector(3 downto 0) := "0100";-- 4
        t_sr_clk_high      : in std_logic_vector(3 downto 0) := "0010";-- 2
        t_sr_clk_low       : in std_logic_vector(3 downto 0) := "0010";-- 2
        t_sr_clk_strobe    : in std_logic_vector(3 downto 0) := "0110";-- 6

        -- status registers
        ShiftOutSampBusy   : out std_logic := '0';

        -- state machine input parameters
        asic_mask          : in std_logic := '0'; --std_logic_vector(4 downto 0) := (others=>'0');
        samp_start_asic    : in std_logic_vector(4 downto 0) := (others => '0'); --slv5(4 downto 0) := (others=>(others=>'0'));
        samp_stop_asic     : in std_logic_vector(4 downto 0) := (others => '1'); --slv5(4 downto 0) := (others=>(others=>'1'));

        -- wires to ThresholdCheck
        samples_valid      : out std_logic := '0';
        -- samples_sel        : out std_logic_vector(4 downto 0) := (others=>'0');
        sample_data        : out slv12(chls-1 downto 0) := (others=>"000000000000"); -- slv12(14 downto 0) := (others=>"000000000000");
        -- current_asic       : out std_logic_vector(4 downto 0) := "00001"; by me

        -- pins to TargetX
        BUS_DO             : in  std_logic_vector(chls-1 downto 0) := (others=>'0');
        SR_CLR             : out std_logic := '0';
        SR_CLK             : out std_logic := '0'; --std_logic_vector(4 downto 0) := (others=>'0');
        SR_SEL             : out std_logic := '0';
        SAMPLESEL          : out std_logic_vector(4 downto 0) := (others=>'0');
        SAMPLESEL_ANY      : out std_logic := '0' -- std_logic_vector(4 downto 0) := (others=>'0');
        -- shift_win_state1 : out shift_out_window_data
        -- sample_data_32        : out slv12(14 downto 0) := (others=>"000000000000") --by me
    );
end ShiftOutWindow;


architecture Behavioral of ShiftOutWindow is

    -- type shift_out_window_data is (
    --     IDLE,             -- shift_win_state = (ASIC_LOOP) or (IDLE)
    --     ASIC_LOOP,        -- shift_win_state = (WAIT_SR_BUSY_TO_COME_UP) or (IDLE)
    --     WAIT_SR_BUSY_TO_COME_UP, -- shift_win_state = (WAIT_SHIFT_OUT_SAMPLE)
    --     WAIT_SHIFT_OUT_SAMPLE   -- shift_win_state = (WAIT_SR_BUSY_TO_COME_UP) or (ASIC_LOOP)
    -- );

    signal shift_win_state : shift_out_window_data := IDLE;


    signal ena_i                : std_logic_vector(1 downto 0) := (others => '0');
    -- signal samplesel_any_i      : std_logic := '0';
    signal samplesel_i          : std_logic_vector(4 downto 0) := (others => '0');
    signal shift_out_samp_ena   : std_logic := '0';
    signal shift_out_samp_busy  : std_logic := '0';
    signal samp_stop_asic_i     : std_logic_vector(4 downto 0) := (others => '1');
    signal asic_checklist       : std_logic := '0'; -- std_logic_vector(4 downto 0) := (others => '0');
    -- signal force_test_pattern_i : std_logic_vector(1 downto 0) := (others => '0');
    -- signal force_test_pattern_sample : std_logic := '0'; 
    -- signal sr_asic_sel          : std_logic_vector(4 downto 0) := "00000";
----------------------------------------
begin

    SAMPLESEL <= samplesel_i;
    ShiftOutSampBusy <= shift_out_samp_busy;
    -- shift_win_state1  <= shift_win_state;

    U0 : entity work.ShiftOutSample
        port map (
            clk                => clk,
            ena                => shift_out_samp_ena,
            busy               => shift_out_samp_busy,
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
        );


    --detect start rising edge
    process (clk)
    begin
        if rising_edge(clk) then
            ena_i(1) <= ena_i(0);
            ena_i(0) <= ena;
            -- force_test_pattern_i <= force_test_pattern_i(0) & force_test_pattern; --by me
        end if;
    end process;

    process(clk, rst, ena_i, samp_start_asic,
            samp_stop_asic, shift_out_samp_busy, asic_mask, samplesel_i) --, asic_mask, asic_checklist, sr_asic_sel
    begin
        if rising_edge(clk) then
            if rst = '1' then
                shift_win_state <= IDLE;
            else
                Case shift_win_state is

                    When IDLE =>
                        if ( ena_i(1 downto 0) = "01" ) then   -- start (readout initiated)
                            busy <= '1';
                            -- samplesel_i <= samp_start_asic;
                            -- samp_stop_asic_i <= samp_stop_asic;
                            asic_checklist <= asic_mask;
                            -- shift_out_samp_ena <= '1';
                            shift_win_state <= SAMP_RANGE;
                            -- shift_win_state <= ASIC_LOOP;
                        else
                            busy <= '0';
                            samplesel_i <= "00000";
                            shift_win_state <= IDLE;
                        end if;

                    When SAMP_RANGE =>
                    -- if (or_reduce(asic_checklist) = '1') then
                        if asic_checklist = '1' then
                            -- sr_asic_sel <= "00000";
                            -- sr_asic_sel(i) <= '1'; --(i=>'1', others=>'0');
                            asic_checklist <= '0';
                            shift_out_samp_ena <= '1';
                            shift_win_state <= WAIT_SR_BUSY_TO_COME_UP;
                            samplesel_i <= samp_start_asic;
                            samp_stop_asic_i <= samp_stop_asic;
                        -- end if;
                        else
                            samplesel_i <= "00000";
                            -- sr_asic_sel <= "00000";
                            busy <= '0';
                            shift_win_state <= IDLE;
                        end if;

                    -- When ASIC_LOOP =>
                    --     if (or_reduce(asic_checklist) = '1') then
                    --         for i in 0 to 4 loop
                    --             if asic_checklist(i) = '1' then
                    --                 sr_asic_sel <= "00000";
                    --                 sr_asic_sel(i) <= '1'; --(i=>'1', others=>'0');
                    --                 asic_checklist(i) <= '0';
                    --                 samplesel_i <= samp_start_asic(i);
                    --                 samp_stop_asic_i <= samp_stop_asic(i);
                    --                 exit;
                    --             end if;
                    --         end loop;
                    --         shift_out_samp_ena <= '1';
                    --         shift_win_state <= WAIT_SR_BUSY_TO_COME_UP;
                    --     else
                    --         samplesel_i <= "00000";
                    --         sr_asic_sel <= "00000";
                    --         busy <= '0';
                    --         shift_win_state <= IDLE;
                    --     end if;

                    When WAIT_SR_BUSY_TO_COME_UP =>
                        -- current_asic <= sr_asic_sel;
                        shift_out_samp_ena <= '1';
                        if shift_out_samp_busy = '0' then
                            shift_win_state <= WAIT_SR_BUSY_TO_COME_UP;
                        else
                            shift_win_state <= WAIT_SHIFT_OUT_SAMPLE;
                        end if;

                    When WAIT_SHIFT_OUT_SAMPLE =>
                        shift_out_samp_ena <= '0';
                        if ( shift_out_samp_busy = '1' ) then
                            shift_win_state <= WAIT_SHIFT_OUT_SAMPLE;
                        else
                            -- samples_sel <= samplesel_i;
                            if samplesel_i = samp_stop_asic_i then
                                -- samplesel_i <= initial_sample;
                                shift_win_state <= SAMP_RANGE; --ASIC_LOOP;
                            else
                                samplesel_i <= samplesel_i + "00001";
                                shift_win_state <= WAIT_SR_BUSY_TO_COME_UP;
                            end if;
                        end if;

                    -- When OTHERS =>
                    --     shift_win_state <= IDLE;

                end case;
            end if;
        end if;
    end process;


end Behavioral;
