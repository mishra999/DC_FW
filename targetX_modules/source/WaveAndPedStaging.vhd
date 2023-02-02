library IEEE;
    use IEEE.std_logic_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    use IEEE.std_logic_MISC.ALL;
    use IEEE.std_logic_UNSIGNED.ALL;
Library work;
    use work.klm_scint_pkg.all;


--!
--! ## Overview
--! <p>Temporary waveform and pedestal memory for one channel on each of 5 asics.
--! Because only one asic is read at a time, all fifo data i/o's are tied together
--! while the enable signals are multiplexed based on asic number.
--! This module will be instantiated 15 times per bus (2 buses)</p>
--! <p>In pedestal calculating mode, writing waveform samples to the wave fifo
--! kicks off a state machine which first reads the wave and ped fifos,
--! then adds the new sample to the sum of all prior iterations, and it
--! stores this sum as a 24 bit vector shared by the wave and ped fifos.
--! This scheme allows 2^12 averages of each pedestal value, but in practice
--! 2^6 or 2^7 averages is sufficient.</p>
--!

entity WaveAndPedStaging is
    Generic (
        FIFO_DIN_SHIFT_DEPTH_g  : integer := 2
    );
    Port (
        clk                      : in  std_logic := '0';
        reset                    : in  std_logic := '0';
        prime_fifos              : in  std_logic := '0';
        summing_ena              : in  std_logic := '0';

        -- fifo writing
        wave_fifo_wr_asic        : in  std_logic_vector(4 downto 0) := (others=>'0');
        wave_fifo_wr_ena         : in  std_logic := '0';
        main_samp_in             : in  std_logic_vector(11 downto 0) := (others=>'0');
        ped_fifo_wr_asic         : in  std_logic_vector(4 downto 0) := (others=>'0');
        ped_fifo_wr_ena          : in  std_logic := '0';
        ped_fifo_din             : in  std_logic_vector(11 downto 0) := (others=>'0');
        
        -- fifo reading
        fifo_rd_asic             : in  std_logic_vector(4 downto 0) := (others=>'0');
        fifo_rd_ena              : in  std_logic := '0';
        fifo_dout                : out std_logic_vector(23 downto 0) := (others=>'0');
        fifo_drdy                : out std_logic := '0';
        
        fifos_empty              : out std_logic := '0'

    );
end WaveAndPedStaging;

architecture Behavioral of WaveAndPedStaging is

    type ped_navg_adder is (
        IDLE,
        WAIT_FIFO_READ_LAG,
        ADD_SAMPLE_AND_WRITE_FIFOS,
        PRIME_FIFOS_WITH_ZEROS
    );
    signal add_peds_state : ped_navg_adder := IDLE;

    signal i_ped_fifo_wr_ena          : std_logic_vector(4 downto 0) := "00000";
    signal i_ped_fifo_din             : std_logic_vector(11 downto 0) := (others=>'0');

    signal i_wave_fifo_wr_ena         : slv5(FIFO_DIN_SHIFT_DEPTH_g - 1 downto 0) := (others=>(others=>'0'));
    signal wave_fifo_wr_asic_copy     : std_logic_vector(4 downto 0) := (others=>'0');
    signal i_fifo_rd_ena              : std_logic_vector(4 downto 0) := "00000";
    signal i_fifo_rd_asic             : std_logic_vector(4 downto 0) := "00001";
    signal i_wave_fifo_din            : slv12(FIFO_DIN_SHIFT_DEPTH_g - 1 downto 0) := (others=>(others=>'0'));
    signal main_samp_in_copy          : std_logic_vector(11 downto 0) := (others=>'0');
    
    signal wave_fifo_dout_q0          : slv12(4 downto 0) := (others=>"000000000000");
    signal wave_fifo_dout_q1          : slv12(4 downto 0) := (others=>"000000000000");
    signal wave_fifo_dout_q2          : std_logic_vector(11 downto 0) := (others=>'0');
    signal fifo_drdy_q0               : std_logic := '0';
    signal fifo_drdy_q1               : std_logic := '0';
    signal fifo_drdy_q2               : std_logic := '0';
    signal ped_fifo_dout_q0           : slv12(4 downto 0) := (others=>"000000000000");
    signal ped_fifo_dout_q1           : slv12(4 downto 0) := (others=>"000000000000");
    signal ped_fifo_dout_q2           : std_logic_vector(11 downto 0) := (others=>'0');

    signal start_adder                : std_logic := '0';
    signal pedcalc_dual_fifo_wr_asic  : std_logic_vector(4 downto 0) := (others=>'0');
    signal pedcalc_dual_fifo_wr_ena   : std_logic_vector(4 downto 0) := (others=>'0');
    signal pedcalc_dual_fifo_din      : std_logic_vector(23 downto 0) := (others=>'0');
    signal pedcalc_dual_fifo_rd_asic  : std_logic_vector(4 downto 0) := (others=>'0');
    signal pedcalc_dual_fifo_rd_ena   : std_logic_vector(4 downto 0) := (others=>'0');

    signal ped_fifos_empty            : std_logic_vector(4 downto 0) := (others => '0');
    signal wave_fifos_empty           : std_logic_vector(4 downto 0) := (others => '0');
    signal all_ped_fifos_empty        : std_logic := '0';
    signal all_wave_fifos_empty       : std_logic := '0';
    signal i_ped_reset                : std_logic_vector(4 downto 0) := (others => '0');
    signal i_wave_reset               : std_logic_vector(4 downto 0) := (others => '0');
    signal reset_q1                   : std_logic_vector(1 downto 0) := (others => '0');


begin

    fifo_dout_mux : process(clk, i_fifo_rd_asic, wave_fifo_dout_q1, fifo_drdy_q1, ped_fifo_dout_q1)
    begin
        if rising_edge(clk) then
            case i_fifo_rd_asic is
                -- when "00000" =>
                --     wave_fifo_dout_q2 <= (others=>'-');
                --     ped_fifo_dout_q2 <= "------------";
                --     fifo_drdy_q2 <= '0';
                when "00001" =>
                    wave_fifo_dout_q2 <= wave_fifo_dout_q1(0);
                    ped_fifo_dout_q2 <= ped_fifo_dout_q1(0);
                    fifo_drdy_q2 <= fifo_drdy_q1;
                when "00010" =>
                    wave_fifo_dout_q2 <= wave_fifo_dout_q1(1);
                    ped_fifo_dout_q2 <= ped_fifo_dout_q1(1);
                    fifo_drdy_q2 <= fifo_drdy_q1;
                when "00100" =>
                    wave_fifo_dout_q2 <= wave_fifo_dout_q1(2);
                    ped_fifo_dout_q2 <= ped_fifo_dout_q1(2);
                    fifo_drdy_q2 <= fifo_drdy_q1;
                when "01000" =>
                    wave_fifo_dout_q2 <= wave_fifo_dout_q1(3);
                    ped_fifo_dout_q2 <= ped_fifo_dout_q1(3);
                    fifo_drdy_q2 <= fifo_drdy_q1;
                when "10000" =>
                    wave_fifo_dout_q2 <= wave_fifo_dout_q1(4);
                    ped_fifo_dout_q2 <= ped_fifo_dout_q1(4);
                    fifo_drdy_q2 <= fifo_drdy_q1;
                when others =>
                    -- wave_fifo_dout_q2 <= (others=>'-');
                    -- ped_fifo_dout_q2 <= "------------";
                    fifo_drdy_q2 <= '0';
            end case;
        end if;
    end process fifo_dout_mux;


    dout_concatenation: process(clk, fifo_drdy_q2, wave_fifo_dout_q2, ped_fifo_dout_q2)
    begin
        if rising_edge(clk) then
            fifo_dout <= ped_fifo_dout_q2 & wave_fifo_dout_q2;
            fifo_drdy <= fifo_drdy_q2;
        end if;
    end process dout_concatenation;


    dout_buf: process(clk, wave_fifo_dout_q0, ped_fifo_dout_q0, fifo_drdy_q0)
    begin
        if rising_edge(clk) then
              wave_fifo_dout_q1 <= wave_fifo_dout_q0;
              fifo_drdy_q1 <= fifo_drdy_q0;
              ped_fifo_dout_q1 <= ped_fifo_dout_q0;
        end if;
    end process;


    chk_all_empty_fan_in_1: process(clk, ped_fifos_empty, wave_fifos_empty)
    begin
        if rising_edge(clk) then
            all_ped_fifos_empty <= and_reduce(ped_fifos_empty);
            all_wave_fifos_empty <= and_reduce(wave_fifos_empty);
        end if;
    end process;

    chk_all_empty_fan_in_2: process(clk, all_ped_fifos_empty, all_wave_fifos_empty)
    begin
        if rising_edge(clk) then
            fifos_empty <= all_ped_fifos_empty and all_wave_fifos_empty;
        end if;
    end process;

    reset_fanout_1: process(clk, reset)
    begin
        if rising_edge(clk) then
            reset_q1 <= reset & reset;
        end if;
    end process;

    reset_fanout_2: process(clk, reset_q1)
    begin
        if rising_edge(clk) then
            i_ped_reset <= reset_q1(0) & reset_q1(0) & reset_q1(0) & reset_q1(0) & reset_q1(0);
            i_wave_reset <= reset_q1(1) & reset_q1(1) & reset_q1(1) & reset_q1(1) & reset_q1(1);
        end if;
    end process;

    PedFifo : for i in 0 to 4 generate
        ped_i : entity work.fifo_w12_d512
        PORT MAP (
            CLK              => clk,
            SRST             => i_ped_reset(i),
            WR_EN            => i_ped_fifo_wr_ena(i),
            RD_EN            => i_fifo_rd_ena(i),
            DIN              => i_ped_fifo_din,
            DOUT             => ped_fifo_dout_q0(i),
            FULL             => open, --ped_fifo_full(i),
            EMPTY            => ped_fifos_empty(i)
        );
    end generate;
    
    WaveFifo : for i in 0 to 4 generate
        wave_i : entity work.fifo_w12_d512
        PORT MAP (
            CLK              => clk,
            SRST             => i_wave_reset(i),
            WR_EN            => i_wave_fifo_wr_ena(FIFO_DIN_SHIFT_DEPTH_g - 1)(i),
            RD_EN            => i_fifo_rd_ena(i),
            DIN              => i_wave_fifo_din(FIFO_DIN_SHIFT_DEPTH_g - 1),
            DOUT             => wave_fifo_dout_q0(i),
            FULL             => open, --wave_fifo_full(i),
            EMPTY            => wave_fifos_empty(i)
        );
    end generate;


    -- PedFifo : for i in 0 to 4 generate
    --     ped_i : entity work.fifo_cc
    --     generic map(
    --         DATA_WIDTH => 12,
    --         DEPTH => 7 -- bit
    --     )
    --     PORT MAP (
    --         CLK              => clk,
    --         RST             => i_ped_reset(i),
    --         WEN            => i_ped_fifo_wr_ena(i),
    --         REN            => i_fifo_rd_ena(i),
    --         DIN              => i_ped_fifo_din,
    --         DOUT             => ped_fifo_dout_q0(i),
    --         FULL             => open, --ped_fifo_full(i),
    --         EMPTY            => ped_fifos_empty(i)
    --     );
    -- end generate;
    -- 
    -- WaveFifo : for i in 0 to 4 generate
    --     -- wave_i : entity work.pedFIFO
    --     wave_i : entity work.fifo_cc
    --     generic map(
    --         DATA_WIDTH => 12,
    --         DEPTH => 7 -- bit
    --     )
    --     PORT MAP (
    --         CLK              => clk,
    --         RST             => i_wave_reset(i),
    --         WEN            => i_wave_fifo_wr_ena(FIFO_DIN_SHIFT_DEPTH_g - 1)(i),
    --         REN            => i_fifo_rd_ena(i),
    --         DIN              => i_wave_fifo_din(FIFO_DIN_SHIFT_DEPTH_g - 1),
    --         DOUT             => wave_fifo_dout_q0(i),
    --         FULL             => open, --wave_fifo_full(i),
    --         EMPTY            => wave_fifos_empty(i)
    --     );
    -- end generate;


    sync_rdy_sig: process(clk, i_fifo_rd_ena)
    begin
        if rising_edge(clk) then
            fifo_drdy_q0 <= '0';
            if or_reduce(i_fifo_rd_ena) = '1' then
                fifo_drdy_q0 <= '1';
            end if;
        end if;
    end process;


    mode_mux: process(clk, summing_ena, wave_fifo_wr_ena, fifo_rd_ena,
            pedcalc_dual_fifo_wr_ena, pedcalc_dual_fifo_din,
            pedcalc_dual_fifo_rd_ena,
            wave_fifo_wr_asic, fifo_rd_asic, main_samp_in)
    begin
        if rising_edge(clk) then

            if summing_ena = '0' then -- normal mode
                i_wave_fifo_wr_ena(i_wave_fifo_wr_ena'left downto 1) <= i_wave_fifo_wr_ena(i_wave_fifo_wr_ena'left - 1 downto 0);
                asic_ena_mux : for i in 0 to 4 loop
                    i_wave_fifo_wr_ena(0)(i) <=  wave_fifo_wr_ena and wave_fifo_wr_asic(i);
                    i_ped_fifo_wr_ena(i) <= ped_fifo_wr_ena and ped_fifo_wr_asic(i);
                    i_fifo_rd_ena(i) <= fifo_rd_ena and fifo_rd_asic(i);
                end loop;
                i_wave_fifo_din <= i_wave_fifo_din(i_wave_fifo_din'left - 1 downto 0) & main_samp_in;
                i_ped_fifo_din <= ped_fifo_din;
                i_fifo_rd_asic <= fifo_rd_asic;

            else -- add input to output and use ped fifos for carry bits
                start_adder <= wave_fifo_wr_ena;
                i_wave_fifo_wr_ena <= i_wave_fifo_wr_ena(i_wave_fifo_wr_ena'left - 1 downto 0) & pedcalc_dual_fifo_wr_ena;
                i_ped_fifo_wr_ena <= pedcalc_dual_fifo_wr_ena;
                i_wave_fifo_din <= i_wave_fifo_din(i_wave_fifo_din'left - 1 downto 0) & pedcalc_dual_fifo_din(11 downto 0);
                i_ped_fifo_din <= pedcalc_dual_fifo_din(23 downto 12);
                i_fifo_rd_ena <= pedcalc_dual_fifo_rd_ena;
                i_fifo_rd_asic <= pedcalc_dual_fifo_rd_asic;
            end if;               
                
        end if;
    end process mode_mux;

    cp_samp: process(clk, wave_fifo_wr_ena, main_samp_in)
    begin
        if rising_edge(clk) then
            if wave_fifo_wr_ena = '1' then
                main_samp_in_copy <= main_samp_in;
            end if;
        end if;
    end process;



    add_peds: process(clk, start_adder, prime_fifos, wave_fifo_wr_asic, main_samp_in_copy,
                      ped_fifo_dout_q2, wave_fifo_dout_q2)
        variable count : integer range 0 to 31 := 0;
    begin
        if rising_edge(clk) then
            case add_peds_state is

                When IDLE =>
                    count := 0;
                    pedcalc_dual_fifo_wr_ena <= (others=>'0');
                    if start_adder = '1' then
                        wave_fifo_wr_asic_copy <= wave_fifo_wr_asic;
                        pedcalc_dual_fifo_rd_asic <= wave_fifo_wr_asic;
                        pedcalc_dual_fifo_rd_ena <= wave_fifo_wr_asic;
                        add_peds_state <= WAIT_FIFO_READ_LAG;
                    elsif prime_fifos = '1' then
                        add_peds_state <= PRIME_FIFOS_WITH_ZEROS;
                    else
                        add_peds_state <= IDLE;
                    end if;

                When WAIT_FIFO_READ_LAG =>
                    pedcalc_dual_fifo_rd_ena <= (others=>'0');
                    if count < 3 then
                        count := count + 1;
                        add_peds_state <= WAIT_FIFO_READ_LAG;
                    else
                        count := 0;
                        add_peds_state <= ADD_SAMPLE_AND_WRITE_FIFOS;
                    end if;

                When ADD_SAMPLE_AND_WRITE_FIFOS =>
                    pedcalc_dual_fifo_din <= ("000000000000" & main_samp_in_copy) + (ped_fifo_dout_q2 & wave_fifo_dout_q2);
                    pedcalc_dual_fifo_wr_ena <= wave_fifo_wr_asic_copy;
                    add_peds_state <= IDLE;

                When PRIME_FIFOS_WITH_ZEROS =>
                    pedcalc_dual_fifo_wr_ena <= "11111";
                    pedcalc_dual_fifo_din <= (others=>'0');
                    if count = 31 then
                        count := 0;
                        add_peds_state <= IDLE;
                    else
                        count := count + 1;
                        add_peds_state <= PRIME_FIFOS_WITH_ZEROS;
                    end if;

                -- When OTHERS =>
                --     add_peds_state <= IDLE;

            end case;
        end if;
    end process;

end Behavioral;
