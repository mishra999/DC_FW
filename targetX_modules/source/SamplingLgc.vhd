library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;
library work;
use work.klm_scint_pkg.all; 
--!-----------------------------------------------------------------------------
--! 2018/12/23 Original module (from Isar, and not sure who before that)
--! 2018/12/24 Minor refactoring (vshebalin?)
--! 2019/10/08 Remove unused signals, made simpler (cketter)
--! 2021/10/11 Aligned with ctime. (cketter)
--! 
--! <p> Generates timing strobes for the switched capacitor array on TARGETX.
--! Prevents overwriting of samples that are earmarked for digitization.
--! On reset, sends clear signal to TARGETX, then waits for synchronization
--! with ctime and restarts sampling at TARGETX window 0. Sampling speed is
--! 64 samples / 1 SSTIN clock period. 
--! <\p>
--! 
--!
--! 
--! 
--!-----------------------------------------------------------------------------

 
entity SamplingLgc is
    generic (
        NUM_DCs : integer := 0 
    ); 
    port (
        clk              : in  std_logic;
        reset            : in  std_logic := '0';
        sync_bit         : in  std_logic := '0';
        ctime64ns_bit    : in  std_logic ; -- goes high every 64 ns.
        -- ana_wr_ena_mask  : in TARGETX_analong_wr_ena_mask_t := null_TX_ana_wr_ena_mask; -- ena & sel & win_start(8:0) & N_win(2:0)

        cur_win          : out std_logic_vector(8 downto 0) := "000000000";
        samp_mod8        : out std_logic_vector(1 downto 0) := "00";

        BUSA_WR_ADDRCLR  : out std_logic := '0';  -- write address clear -- when asserted, it will reset the row and col on the TX chip
        BUSB_WR_ADDRCLR  : out std_logic := '0';  -- write address clear -- when asserted, it will reset the row and col on the TX chip
        WR1_ENA          : out std_logic_vector(NUM_DCs downto 0) := (others=>'1');  -- Enable Write 1 procedure
        WR2_ENA          : out std_logic_vector(NUM_DCs downto 0) := (others=>'1');  -- Enable Write 2 procedure

        SSTIN_N          : out std_logic_vector(NUM_DCs downto 0) := (others=>'0'); --Sampling Capacitor Array control signals
        SSTIN_p          : out std_logic_vector(NUM_DCs downto 0) := (others=>'1'); --Sampling Capacitor Array control signals
        cur_win_ii       : out std_logic_vector(8 downto 0) := "000000000";
        digitize_busy     : in std_logic
        -- i_ctime          : out std_logic_vector(5 downto 0)   -- by me;
        -- analog_store_state1  : out state_type := RESETTING;  -- by me;
        -- masking_state1  : out masking_state_machine := IDLE; 
        -- mask_win_ctr1  : out std_logic_vector(8 downto 0) := (others=>'0')
    );
end SamplingLgc;
 
architecture Behavioral of SamplingLgc is


    -- --state machine drives SAMPLING logic signals directly
    -- type state_type is (
    --     RESETTING,
    --     SAMPLING
    -- );
    signal analog_store_state : state_type := RESETTING;

    -- current write address
    signal cur_win_i       : UNSIGNED(8 downto 0) := "000000000";
    signal samp_mod8_i     : std_logic_vector(1 downto 0) := "00";
    
    -- wires to TargetX
    signal wr_addrclr_i    : std_logic := '0'; --Clear Write Address Counter
    -- signal wr_ena          : std_logic := '1'; --Enable Write procedure
    signal wr_ena : std_logic_vector(NUM_DCs downto 0) := (others => '1');

    -- signal wr_ena_mask : std_logic_vector(511 downto 0) := (others=>'1');

    signal i_reset : std_logic := '0';
    signal i_sync_sr : std_logic_vector(1 downto 0) := "00";
    signal i_ctime64ns_bit_sr : std_logic_vector(5 downto 0) := (others=>'0');  
    -- signal i_ctime : std_logic_vector(5 downto 0) := (others=>'0'); --mudit
    -- signal masking_state11 : masking_state_machine := IDLE;
    -- signal mask_win_ctr11  : std_logic_vector(8 downto 0) := (others=>'0');

begin
------------------- ASYNCHRONOUS LOGIC ---------------------------------------------
    BUSA_WR_ADDRCLR <= wr_addrclr_i;
    BUSB_WR_ADDRCLR <= wr_addrclr_i;
    -- i_ctime <= i_ctime64ns_bit_sr ;--by me (i_ctime64ns_bit_sr'left - 1 downto i_ctime64ns_bit_sr'left - 2)
    cur_win_ii <= std_logic_vector(cur_win_i(8 downto 0));
    WR1_ENA <= wr_ena;
    WR2_ENA <= wr_ena;
    -- analog_store_state1 <= analog_store_state; --by me
    -- masking_state1 <=masking_state11; --by me
    -- mask_win_ctr1 <= mask_win_ctr11;

    GEN_SSTIN : for i in 0 to NUM_DCs generate
        obuf_ds_sstin_i : OBUFDS port map (
            i => i_ctime64ns_bit_sr(i_ctime64ns_bit_sr'left), --changing every 4 clk cycles
            o => SSTIN_P(i),
            ob => SSTIN_N(i)
        );
    end generate;

--------------------- SYNCHRONOUS LOGIC ---------------------------------------------
    -- latch window counter to output
    process(clk, cur_win_i)
    begin
        if rising_edge(clk) then
            cur_win <= std_logic_vector(cur_win_i(8 downto 0)); --output only row + colum sections
            samp_mod8 <= samp_mod8_i;
        end if;
    end process;

    -- latch reset to local domain
    process(clk, reset)
    begin
        if rising_edge(clk) then
            i_reset <= reset;
        end if;
    end process;

    -- detect rising edge of sync bit
    process(clk, sync_bit)
    begin
        if rising_edge(clk) then
            i_sync_sr <= i_sync_sr(0) & sync_bit;
        end if;
    end process;

    -- buffer ctime64ns_bit by 4 (if more buffering needed, make length 8 and switch o/ob in OBUFDS below)
    process(clk, ctime64ns_bit)
    begin
        if rising_edge(clk) then
            i_ctime64ns_bit_sr <= i_ctime64ns_bit_sr(i_ctime64ns_bit_sr'left - 1 downto 0) & ctime64ns_bit;
            -- i_ctime1 <= i_ctime64ns_bit_sr(i_ctime64ns_bit_sr'left - 1 downto 0) & ctime64ns_bit; --by me
            -- i_ctime <= i_ctime64ns_bit_sr; --by me
        end if;
    end process;



    -- Assert mask on write-enable pins
    process(clk, cur_win_i) --, wr_ena_mask
    begin
        if (rising_edge(clk)) then
            if digitize_busy = '1' then  -- stop storage when digitizing
            for i in 0 to NUM_DCs loop
                wr_ena(i) <= '0'; -- wr_ena_mask(to_integer(cur_win_i));
            end loop;
            else
            for i in 0 to NUM_DCs loop
                wr_ena(i) <= '1';                
            end loop;
            end if;
        end if;
    end process;

    -- Main Sampling FSM
    process(clk, cur_win_i, i_reset, i_sync_sr)
    begin
        if (rising_edge(clk)) then
            if (i_reset='1') then
                 wr_addrclr_i <= '1';
                 cur_win_i <= (others=>'0');
                 samp_mod8_i <= (others=>'0');
                 analog_store_state <= RESETTING;
            else
                case analog_store_state is

                    when RESETTING =>
                        cur_win_i <= (others=>'0');
                        samp_mod8_i <= (others=>'0');
                        if (i_sync_sr = "01") then  -- (delayed) rising edge of sync bit
                             wr_addrclr_i <= '0';
                             analog_store_state <= SAMPLING;
                        else
                            wr_addrclr_i <= '1'; -- don't release until sync
                            analog_store_state <= RESETTING;
                        end if;

                    when SAMPLING =>
                        wr_addrclr_i <= '0';
                        if (i_ctime64ns_bit_sr(i_ctime64ns_bit_sr'left - 1 downto i_ctime64ns_bit_sr'left - 2) = "10") -- SSTIN_P rising, isn't it sstin_N??
                        or (i_ctime64ns_bit_sr(i_ctime64ns_bit_sr'left - 1 downto i_ctime64ns_bit_sr'left - 2) = "01") -- or SSTIN_N rising
                        then
                            cur_win_i <= cur_win_i + 1;
                            samp_mod8_i <= (others=>'0');
                        else
                            cur_win_i <= cur_win_i;
                            samp_mod8_i <= samp_mod8_i + '1';
                        end if;
                        analog_store_state <= SAMPLING;

                    -- when others =>
                    --     cur_win_i <= (others => '-');
                    --     analog_store_state <= SAMPLING;

                end case;
            end if;
        end if;
    end process;

---------------------BEGIN MODULES ---------------------------------------------
    -- SamplingMask : entity work.SamplingMask
    -- port map (
    --     clk         => clk,
    --     rst         => i_reset,
    --     ena         => ana_wr_ena_mask.ena,
    --     new_bit     => ana_wr_ena_mask.mask_bit,
    --     win_start   => ana_wr_ena_mask.win_start,
    --     N_win       => ana_wr_ena_mask.n_win,
    --     wr_ena_mask => wr_ena_mask
    --     -- masking_state1 => masking_state11, --by me
    --     -- mask_win_ctr1 => mask_win_ctr11
    -- );


end Behavioral;









