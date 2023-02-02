library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all;

--!## Overview
--!<p>Asserts signals required for TARGETX digitization.
--!</p>
--!
--!### TARGETX Wilkinson ramp control
--!
--!<pre>
--!  ADDR_SETTLE_TIME      RAMP_DELAY
--!<------------------> <-------------->
--!___/‾‾‾BUS‾CLR‾‾‾\\__
--!_____________________/‾‾‾BUS‾RD‾ENA‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\\_
--!_____________________________________/‾‾‾RAMP‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\\_
--!</pre>

entity DigitizingLgcTX is
    generic (
        t_delay_ramp_ena   : std_logic_vector (4 downto 0) := "00011";
        t_wilk_clear_high  : std_logic_vector (6 downto 0) := "0011110"
    );
    port (
        clk                : in  std_logic := '0';
        rst                : in  std_logic := '0';
        ena                : in  std_logic := '0';
        busy               : out std_logic := '0';
        -- control registers
        -- force_test_pattern : in std_logic := '0';
        ramp_length        : in  std_logic_vector (11 downto 6) := "000111"; -- std_logic_vector (11 downto 6) := "000111";
        -- pins to TargetX
        BUS_RD_ENA         : out std_logic := '0';
        BUS_CLR            : out std_logic := '0';
        BUS_RAMP           : out std_logic := '0'	--ramp enable signal
    );
end DigitizingLgcTX;

architecture Behavioral of DigitizingLgcTX is

    type digitization_state_machine is
        (
        IDLE,
        WAIT_ADDR_SETTLE_TIME,
        WAIT_XFER_TO_WILK_ADC,
        WAIT_RAMP_LENGTH
        -- wait_for_start_dig_in_to_go_low
        );
    signal digitization_state : digitization_state_machine := IDLE;
    signal dig_st_fms_ctr : std_logic_vector(11 downto 0) := (others => '0');

    signal ena_i           : std_logic_vector(1 downto 0) := (others => '0');
    signal start_dig_IN    : std_logic := '0';


begin

    detect_start_rising_edge: process (clk, ena, ena_i)
    begin
        if rising_edge(clk) then
            ena_i(1) <= ena_i(0);
            ena_i(0) <= ena;
        end if;
    end process;


    digitization_process: process(clk, dig_st_fms_ctr, ena_i, ramp_length) -- , force_test_pattern)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                digitization_state <= IDLE;
            else

                case digitization_state is

                    When IDLE =>
                        if ( ena_i(1 downto 0) = "01" ) then
                            BUS_CLR <= '1';
                            busy <= '1';
                            digitization_state <= WAIT_ADDR_SETTLE_TIME;
                        else
                            BUS_CLR <= '0';
                            BUS_RD_ENA <= '0';
                            BUS_RAMP <= '0';
                            dig_st_fms_ctr <= (others=>'0');
                            busy <= '0';
                            digitization_state <= IDLE;
                        end if;

                    When WAIT_ADDR_SETTLE_TIME =>
                        if (dig_st_fms_ctr < t_wilk_clear_high) then  -- to delay ramp
                            dig_st_fms_ctr <= dig_st_fms_ctr + '1';
                            digitization_state <= WAIT_ADDR_SETTLE_TIME;
                        else
                            BUS_CLR <= '0';
                            BUS_RD_ENA <= '1';  -- latches column , row read address?
                            dig_st_fms_ctr <= (others => '0');
                            digitization_state <= WAIT_XFER_TO_WILK_ADC;
                        end if;

                    When WAIT_XFER_TO_WILK_ADC =>
                        if (dig_st_fms_ctr < t_delay_ramp_ena) then
                            dig_st_fms_ctr <= dig_st_fms_ctr + '1';
                            digitization_state <= WAIT_XFER_TO_WILK_ADC;
                        else
                            BUS_RAMP <= '1';
                            dig_st_fms_ctr <= (others => '0');
                            digitization_state <= WAIT_RAMP_LENGTH;
                        end if;

                    When WAIT_RAMP_LENGTH =>
                        if (dig_st_fms_ctr(11 downto 6) < ramp_length) then  -- to generate ramp
                            dig_st_fms_ctr <= dig_st_fms_ctr + '1';
                            digitization_state <= WAIT_RAMP_LENGTH;
                        else
                            busy <= '0';
                            BUS_RD_ENA <= '0';
                            BUS_RAMP <= '0';
                            dig_st_fms_ctr <= (others => '0');
                            digitization_state <= IDLE;
                            -- digitization_state <= wait_for_start_dig_in_to_go_low;
                        end if;

                    -- When wait_for_start_dig_in_to_go_low =>
                    --     if(start_dig_IN = '0') then  -- wait for acknowledge before returning to IDLE
                    --         digitization_state <= IDLE;
                    --     else
                    --         digitization_state <= wait_for_start_dig_in_to_go_low;
                    --     end if;

                    -- When OTHERS =>
                    --     digitization_state <= IDLE;

                end case;
            end if;
        end if;
    end process;

end Behavioral;
