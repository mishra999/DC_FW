library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all;

--! <p>This module receives samples from 15 channels on one asic. It passes
--! the samples which make it through the channel mask onto their designated
--! FIFOs in WaveAndPedStaging.</p>
--! <p>If trigger-bit 5 is high (multihit), then a threshold check is performed
--! on each channel; any channel which crosses threshold is flagged so that we only
--! have to fetch pedestals for actual signals.</p>

entity ThresholdCheck is
    Generic (
        -- CoarsePedAdj                : std_logic_vector(11 downto 0);
        tb5_disambig_thr_g          : std_logic_vector(11 downto 0) := "000001000000"; -- 64
        PED_AVG_g                   : std_logic_vector(11 downto 0) := "110000000000" -- 3072
    );
    Port (
        clk                         : in STD_LOGIC := '0';
        rst                         : in STD_LOGIC := '0';
        ena                         : in std_logic := '0';
        busy                        : out std_logic := '0';

        -- control registers
        -- N_readout_samples           : in  std_logic_vector(7 downto 0) := "01100000"; -- 96

        -- wires from ShiftOutSample
        sample_data                 : in slv12(14 downto 0) := (others=>"000000000000");
        samples_valid               : in std_logic := '0';
        -- sample_sel                  : in std_logic_vector(4 downto 0) := (others=>'0');
        digNshift_done              : in std_logic_vector(3 downto 0) := "0000";

        -- input parameters
        chan_mask                   : in  slv15(4 downto 0) := (others => "000000000000000"); -- enables storage fifos
        asic                        : in std_logic_vector(4 downto 0) := (others=>'0');

        -- wires to WaveAndPedStaging
        wave_fifo_wr_ena            : out std_logic_vector(14 downto 0) := (others=>'0');
        wave_fifo_din               : out slv12(14 downto 0) := (others=>"000000000000");
        wave_fifo_wr_asic           : out std_logic_vector(4 downto 0) := "00001";

        -- threshold results for downstream processing
        new_mask                    : out  slv15(4 downto 0) := (others => "000000000000000")
    );
end ThresholdCheck;

architecture Behavioral of ThresholdCheck is

    -- constant BASELINE  : slv12(31 downto 0) := ("100111000100", "100111000100", "100111000100", "100111000100",
    --                                             "100111000100", "100111000100", "100111000100", "100111000100",
    --                                             "100111000100", "100111000100", "100111000100", "100111000100",
    --                                             "100111000100", "100111000100", "100111000100", "100111000100",
    --                                             "100111000100", "100111000100", "100111000100", "100111000100",
    --                                             "100111000100", "100111000100", "100111000100", "100111000100",
    --                                             "100111000100", "100111000100", "100111000100", "100111000100",
    --                                             "100111000100", "100111000100", "100111000100", "100111000100");
    signal ena_i        : std_logic_vector(1 downto 0) := (others => '0');
    signal asic_i       : integer range 0 to 4 := 0;

    type threshold_check_state_machine is
        (
            IDLE,
            WAITING_FOR_SAMPLES,
            FILLING_FIFOS
        );
    signal threshold_check_state : threshold_check_state_machine := IDLE;


begin

    
    --detect start rising edge
    process (clk, ena, ena_i)
    begin
        if rising_edge(clk) then
            ena_i(1) <= ena_i(0);
            ena_i(0) <= ena;
        end if;
    end process;

    process(clk, asic)
    begin
        if rising_edge(clk) then
            for i in 0 to 4 loop
                if asic(i) = '1' then
                    asic_i <= i;
                    exit;
                end if;
            end loop;
        end if;
    end process;


    process(clk, rst, ena_i, samples_valid, sample_data,
            chan_mask, digNshift_done)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                new_mask <= (others => "000000000000000");
                threshold_check_state <= IDLE;
            else
                
                Case threshold_check_state is

                    When IDLE =>
                        wave_fifo_wr_ena <= (others => '0');
                        if ( ena_i(1 downto 0) = "01" ) then
                            busy <= '1';
                            new_mask <= (others => "000000000000000");
                            threshold_check_state <= WAITING_FOR_SAMPLES;
                        else
                            -- wave_fifo_din <= (others => "000000000000");
                            busy <= '0';
                            threshold_check_state <= IDLE;
                        end if;

                    -- Bounce back and forth between next two states while samples are coming in
                    when WAITING_FOR_SAMPLES =>
                        wave_fifo_wr_ena <= (others => '0');
                        if samples_valid = '1' then
                            for i in 0 to 14 loop
                                -- wave_fifo_din(i) <= "111111111111" - CoarsePedAdj - sample_data(i); -- inverter, baseline offset
                                wave_fifo_din(i) <= sample_data(i); -- passthrough
                                -- if sample_data(i) < (BASELINE(to_integer(unsigned(sample_sel))) - tb5_disambig_thr_g)
                                -- if sample_data(i) > (BASELINE(to_integer(unsigned(sample_sel))) + tb5_disambig_thr_g)
                                -- if sample_data(i) > (PED_AVG_g + tb5_disambig_thr_g)
                                if sample_data(i) < (PED_AVG_g - tb5_disambig_thr_g)
                                and chan_mask(asic_i)(i) = '1' then
                                    new_mask(asic_i)(i) <= '1';
                                end if;
                            end loop;
                            threshold_check_state <= FILLING_FIFOS;
                        elsif or_reduce(digNshift_done) = '1' then
                            -- wave_fifo_din <= (others => "000000000000");
                            busy <= '0';
                            threshold_check_state <= IDLE;
                        else
                            threshold_check_state <= WAITING_FOR_SAMPLES;
                        end if;

                    when FILLING_FIFOS =>
                        wave_fifo_wr_ena <= chan_mask(asic_i);
                        wave_fifo_wr_asic <= (others => '0');
                        wave_fifo_wr_asic(asic_i) <= '1';
                        threshold_check_state <= WAITING_FOR_SAMPLES;

                    When OTHERS =>
                        threshold_check_state <= IDLE;

                end case;
            end if;
        end if;
    end process;

end Behavioral;
