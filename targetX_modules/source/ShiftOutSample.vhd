library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all;
-- Shift Out TargetX Sample Data.
-- Chris Ketter. 09/18/2019.

--! <p>Asserts shift-register signals with tunable wait times
--! for each step of the shift-out process.</p>
--! <p>After shifting out all 12 bits, a samples_ready flag
--! is asserted and the samples are picked up by ThresholdCheck.vhd</p>
--! <p>Addressing of the sample via SAMPELSEL is taken care of one
--! level up in ShiftOutWindow.vhd</p>
--!
--! ### TargetX Shifter Register Operation*
--!
--! <pre>
--! SR_SEL        __/‾‾‾\\_________________________________________________________________
--! samplesel_any __/‾‾‾\\_/1‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\\______
--! sr_clock      ___/‾\\_____/2‾\\_/3‾\\_/4‾\\_/5‾\\_/6‾\\_/7‾\\_/8‾\\_/9‾\\_/10\\_/11\\_/12\\_______
--! BUS_DO        ============1====2====3====4====5====6====7====8====9====10===11===12===
--! </pre>
--! <p>*For loading the test pattern, samplesel_any is held low while SR_SEL is high.</p>
--!

entity ShiftOutSample is
    generic (
        num_bits_wilk_adc : integer := 12;
        chls : integer :=1
    );
    port (
        clk                : in  std_logic := '0';
        ena                : in  std_logic := '0';
        busy               : out std_logic := '0';

        -- control registers
        force_test_pattern : in  std_logic := '0';
        t_samp_addr_settle : in std_logic_vector(3 downto 0) := "0100";
        t_sr_clk_strobe    : in std_logic_vector(3 downto 0) := "0000";
        t_strobe_settle    : in std_logic_vector(3 downto 0) := "0000";
        t_setup_ss_any     : in std_logic_vector(3 downto 0) := "0001";
        t_sr_clk_high      : in std_logic_vector(3 downto 0) := "0010";
        t_sr_clk_low       : in std_logic_vector(3 downto 0) := "0001";

        -- state machine input parameters
        -- sr_asic_sel        : in  std_logic_vector(4 downto 0) := (others=>'0');

        -- wires to ThresholdCheck
        samples_valid      : out std_logic := '0';
        sample_data        : out slv12(chls-1 downto 0) := (others=>"000000000000");

        -- pins to TargetX
        BUS_DO             : in  std_logic_vector(chls-1 downto 0) := (others=>'0');
        SR_CLR             : out std_logic := '0';
        SR_CLK             : out std_logic := '0'; --std_logic_vector(4 downto 0) := (others=>'0');
        SR_SEL             : out std_logic := '0';
        SAMPLESEL_ANY      : out std_logic := '0' --std_logic_vector(4 downto 0) := (others=>'0');
        -- sr_ctrl_state1     : out  ASIC_sr_ctrl_fsm;
        -- sr_ctrl_fsm_ctr1 : out std_logic_vector(3 downto 0);
        -- rx_bits_state1   : out ASIC_rx_bits_fsm
    );
end ShiftOutSample;

 


architecture Behavioral of ShiftOutSample is

    -- type ASIC_sr_ctrl_fsm is (
    --     IDLE,                                       -- Idling until command start bit and store size
    --     WAIT_FOR_SAMPLE_ADDRESSING_TO_FINISH,
    --     WAIT_SETUP_SR_CLK_STROBE,                   -- Wait for address to settle, need docs to finilize
    --     WAIT_T_SR_CLK_STROBE_HIGH,                  -- Wait for load cmd to settle relatively to clk, need docs to finilize
    --     WAIT_T_SR_CLK_STROBE_LOW,
    --     HOLD_EVERYTHING_LOW_BEFORE_SHIFTING_OUT,
    --     WAIT_SAMPLESEL_ANY_AND_FIRST_BIT,
    --     WAIT_T_SR_CLK_HIGH,
    --     WAIT_T_SR_CLK_LOW
    -- );


    signal sr_ctrl_state             : ASIC_sr_ctrl_fsm := IDLE;
    signal sr_ctrl_fsm_ctr : std_logic_vector(3 downto 0) := (others => '0');
    signal sr_ctrl_bit_count : integer range 0 to 15 := 0;
    
    -- type ASIC_rx_bits_fsm is (IDLE, WAITING, SHIFTING);
    signal rx_bit_count    : integer range 0 to 15 := 0;
    signal rx_fsm_ctr      : std_logic_vector(3 downto 0) := (others=>'0'); 
    signal rx_bits_state   : ASIC_rx_bits_fsm := IDLE;
    signal rx_bits_fsm_ena : std_logic := '0'; 
 
    -- outputs
    signal sample_data_i        : slv11(chls-1 downto 0) := (others=>"00000000000"); -- slv11(14 downto 0) := (others => "00000000000");
    signal samplesel_any_i      : std_logic := '0';
    signal sr_clk_i             : std_logic := '0';

    -- inputs
    signal ena_i                : std_logic_vector(1 downto 0) := (others => '0');
    signal asic_sel_i           : std_logic := '0'; --std_logic_vector(4 downto 0) := (others => '0');
    signal force_test_pattern_i : std_logic := '0';
    -- signal force_test_pattern_ii : std_logic := '0';

----------------------------------------
begin

    SR_CLK <= asic_sel_i when sr_clk_i = '1' else '0'; -- (others=>'0');
    SAMPLESEL_ANY <= asic_sel_i when samplesel_any_i = '1' else '0'; -- (others=>'0');
    -- sr_ctrl_state1 <= sr_ctrl_state;
    -- sr_ctrl_fsm_ctr1 <= sr_ctrl_fsm_ctr;
    -- rx_bits_state1 <= rx_bits_state;
    force_test_pattern_i <= force_test_pattern; --by me
    
    --detect start rising edge, checked if a signal was on for one cycle previously
    process(clk, ena, ena_i)
    begin
        if rising_edge(clk) then
            ena_i <= ena_i(0) & ena;
            
        end if;
    end process;


    --process asserts actual signals needed for serial readout
    ASIC_sr_ctrl : process(clk, ena_i, force_test_pattern_i) --, sr_asic_sel, force_test_pattern)
    begin

        if rising_edge(clk) then

            Case sr_ctrl_state is

                When IDLE =>
                    sr_clk_i <= '0';
                    SR_CLR <= '1';
                    SR_SEL <= '0';
                    sr_ctrl_fsm_ctr <= (others=>'0');
                    sr_ctrl_bit_count <= 0;
                    samplesel_any_i <= '0';
                    if ( ena_i(1 downto 0) = "01" ) then --checked if ena was on for one cycle previously
                        asic_sel_i <= '1'; --sr_asic_sel
                        busy <= '1';
                        sr_ctrl_state <= WAIT_FOR_SAMPLE_ADDRESSING_TO_FINISH;
                        -- if (force_test_pattern_i = "01") then  --by me
                        --     force_test_pattern_ii <= '1';
                        -- else
                        --     force_test_pattern_ii <= '0';
                        -- end if;
                    else
                        busy <= '0';
                        sr_ctrl_state <= IDLE;
                    end if;


                When WAIT_FOR_SAMPLE_ADDRESSING_TO_FINISH =>
                    SR_CLR <= '0';
                    if (sr_ctrl_fsm_ctr < t_samp_addr_settle) then
                        sr_ctrl_fsm_ctr <= sr_ctrl_fsm_ctr + '1';
                        sr_ctrl_state <= WAIT_FOR_SAMPLE_ADDRESSING_TO_FINISH;
                    else
                        sr_ctrl_fsm_ctr <= (others=>'0');
                        sr_ctrl_state <= WAIT_SETUP_SR_CLK_STROBE;
                    end if;


                When WAIT_SETUP_SR_CLK_STROBE =>
                    sr_clk_i <= '0';
                    SR_SEL <= '1';
                    if (force_test_pattern_i = '1') then --by me
                        samplesel_any_i <= '0';
                    else
                        samplesel_any_i <= '1';   -- <= '0' inorder to force test pattern;
                    end if;                                      
                    if (sr_ctrl_fsm_ctr < t_sr_clk_strobe) then
                        sr_ctrl_fsm_ctr <= sr_ctrl_fsm_ctr + '1';
                        sr_ctrl_state <= WAIT_SETUP_SR_CLK_STROBE;
                    else
                        sr_ctrl_fsm_ctr <= (others=>'0');
                        sr_ctrl_state <= WAIT_T_SR_CLK_STROBE_HIGH;
                    end if;


                When WAIT_T_SR_CLK_STROBE_HIGH =>
                    if (force_test_pattern_i = '1') then --by me
                        samplesel_any_i <= '0';
                    else
                        samplesel_any_i <= '1';   -- <= '0' inorder to force test pattern;
                    end if; 
                    SR_SEL <= '1';
                    sr_clk_i <= '1';
                    if (sr_ctrl_fsm_ctr < t_strobe_settle) then
                        sr_ctrl_fsm_ctr <= sr_ctrl_fsm_ctr + '1';
                        sr_ctrl_state <= WAIT_T_SR_CLK_STROBE_HIGH;
                    else
                        sr_ctrl_fsm_ctr <= (others=>'0');
                        sr_ctrl_state <= WAIT_T_SR_CLK_STROBE_LOW;
                    end if;


                When WAIT_T_SR_CLK_STROBE_LOW =>
                    if (force_test_pattern_i = '1') then --by me
                        samplesel_any_i <= '0';
                    else
                        samplesel_any_i <= '1';   -- <= '0' inorder to force test pattern;
                    end if; 
                    SR_SEL <= '1';
                    sr_clk_i <= '0';
                    if (sr_ctrl_fsm_ctr < t_strobe_settle) then
                        sr_ctrl_fsm_ctr <= sr_ctrl_fsm_ctr + '1';
                        sr_ctrl_state <= WAIT_T_SR_CLK_STROBE_LOW;
                    else
                        sr_ctrl_fsm_ctr <= (others=>'0');
                        sr_ctrl_state <= HOLD_EVERYTHING_LOW_BEFORE_SHIFTING_OUT;
                    end if;


                When HOLD_EVERYTHING_LOW_BEFORE_SHIFTING_OUT =>
                    samplesel_any_i <= '0';
                    SR_SEL <= '0';
                    sr_clk_i <= '0';
                    -- force_test_pattern_ii <= '0'; --by me
                    if (sr_ctrl_fsm_ctr < t_setup_ss_any) then
                        sr_ctrl_fsm_ctr <= sr_ctrl_fsm_ctr + '1';
                        sr_ctrl_state <= HOLD_EVERYTHING_LOW_BEFORE_SHIFTING_OUT;
                    else
                        sr_ctrl_fsm_ctr <= "0001";
                        samplesel_any_i <= '1'; -- 1st bit shows up 3 clocks after this signal is asserted
                        rx_bits_fsm_ena <= '1';
                        sr_ctrl_bit_count <= 1;
                        sr_ctrl_state <= WAIT_SAMPLESEL_ANY_AND_FIRST_BIT;
                        -- sr_ctrl_state <= WAIT_T_SR_CLK_HIGH;
                    end if;


                When WAIT_SAMPLESEL_ANY_AND_FIRST_BIT =>
                    rx_bits_fsm_ena <= '0';
                    sr_clk_i <= '0';
                    if sr_ctrl_fsm_ctr < (t_sr_clk_low + t_sr_clk_high - '1') then
                        sr_ctrl_fsm_ctr <= sr_ctrl_fsm_ctr + '1';
                        sr_ctrl_state <= WAIT_SAMPLESEL_ANY_AND_FIRST_BIT;
                    else
                        sr_ctrl_fsm_ctr <= "0001";
                        sr_ctrl_state <= WAIT_T_SR_CLK_HIGH;
                    end if;
                    
                    
                When WAIT_T_SR_CLK_HIGH =>
                    sr_clk_i <= '1';
                    if sr_ctrl_fsm_ctr < t_sr_clk_high then
                        sr_ctrl_fsm_ctr <= sr_ctrl_fsm_ctr + '1';
                        sr_ctrl_state <= WAIT_T_SR_CLK_HIGH;
                    else
                        sr_ctrl_fsm_ctr <= (others=>'0');
                        sr_ctrl_state <= WAIT_T_SR_CLK_LOW;
                    end if;


                When WAIT_T_SR_CLK_LOW =>
                    sr_clk_i <= '0';
                    if sr_ctrl_fsm_ctr < (t_sr_clk_low - 1) then
                        sr_ctrl_fsm_ctr <= sr_ctrl_fsm_ctr + '1';
                        sr_ctrl_state <= WAIT_T_SR_CLK_LOW;
                    else
                        sr_ctrl_fsm_ctr <= "0001";
                        if sr_ctrl_bit_count < (num_bits_wilk_adc - 1) then
                            sr_ctrl_bit_count <= sr_ctrl_bit_count + 1;
                            sr_ctrl_state <= WAIT_T_SR_CLK_HIGH;
                        else
                            busy <= '0';
                            sr_ctrl_state <= IDLE;
                        end if;
                    end if;


            end case;
        end if;
    end process;


    ASIC_rx_bits : process(clk, rx_bits_fsm_ena, sample_data_i, BUS_DO)
    begin
        if rising_edge(clk) then
            
            case rx_bits_state is
                
                
                when IDLE =>
                    sample_data_i <= (others=>(others=>'0'));
                    samples_valid <= '0';
                    rx_fsm_ctr <= "0001";
                    rx_bit_count <= 1;
                    if rx_bits_fsm_ena = '1' then
                        rx_fsm_ctr <= "0001"; -- SAMPLESEL_ANY WENT HIGH LAST CLOCK
                        rx_bits_state <= WAITING; 
                    else
                        rx_bits_state <= IDLE;
                    end if;
                
                
                when WAITING =>
                    if rx_fsm_ctr < (t_sr_clk_low + t_sr_clk_high - '1') then
                        rx_fsm_ctr <= rx_fsm_ctr + "0001";
                        rx_bits_state <= WAITING;
                    else
                        rx_bits_state <= SHIFTING;
                        -- if rx_bit_count = 12 then
                        --     samples_valid <= '1'; -- tells ThresholdCheck.vhd that samples are ready
                        -- end if;
                    end if;
                
                
                when SHIFTING =>
                    if rx_bit_count < num_bits_wilk_adc then
                        rx_bit_count <= rx_bit_count + 1;
                        for i in 0 to chls-1 loop
                            sample_data_i(i)  <= sample_data_i(i)(9 downto 0) & BUS_DO(i); -- MSB shifted out first
                        end loop;
                        rx_fsm_ctr <= "0001";
                        rx_bits_state <= WAITING;
                    else 
                        for i in 0 to chls-1 loop
                            sample_data(i) <= sample_data_i(i)(10 downto 0) & BUS_DO(i);
                        end loop;
                        samples_valid <= '1'; -- tells ThresholdCheck.vhd that samples are ready
                        rx_bits_state <= IDLE;
                    end if;


            end case;
        end if;
    end process;    

end Behavioral;
