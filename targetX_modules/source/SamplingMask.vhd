library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_MISC.ALL;
library work;
use work.klm_scint_pkg.all;


entity SamplingMask is
    generic (N_WINS_PADDING : std_logic_vector(2 downto 0) := "001");
    port (
        clk              : in  std_logic;
        rst              : in  std_logic := '0';
        ena              : in  std_logic := '0';
        new_bit          : in  std_logic := '1';
        win_start        : in  std_logic_vector(8 downto 0) := (others=>'0');
        n_win            : in  std_logic_vector(8 downto 0) := (others=>'0');
        wr_ena_mask      : out std_logic_vector(511 downto 0) := (others=>'1')
        -- masking_state1 : out masking_state_machine := IDLE;
        -- mask_win_ctr1  : out std_logic_vector(8 downto 0) := (others=>'0')
    );
end SamplingMask;
architecture Behavioral of SamplingMask is


    signal ena_q0        : std_logic := '0';
    signal ena_q1        : std_logic := '0';
    signal count         : std_logic_vector(4 downto 0) := "00000";
    signal mask_win_ctr  : std_logic_vector(8 downto 0) := (others=>'0');
    signal win_start_q0  : std_logic_vector(8 downto 0) := (others=>'0');
    signal n_win_q0      : std_logic_vector(8 downto 0) := (others=>'0');
    signal n_win_q1      : std_logic_vector(8 downto 0) := (others=>'0');
    signal mask_bit_q0   : std_logic := '1';
    signal mask_bit_q1   : std_logic := '1';
    signal i_wr_ena_mask : std_logic_vector(511 downto 0) := (others=>'1');
    signal masking_state : masking_state_machine := IDLE;
    -- type masking_state_machine is (
    --     IDLE,
    --     MODIFY_MASK
    -- );
    -- signal masking_state : masking_state_machine := IDLE;


begin

    wr_ena_mask <= i_wr_ena_mask;
    -- masking_state1 <= masking_state;
    -- mask_win_ctr1 <= mask_win_ctr;

    process (clk, ena)
    begin
        if rising_edge(clk) then
            ena_q0 <=  ena;
            ena_q1 <=  ena_q0;
        end if;
    end process;


    process(clk, rst, masking_state, ena_q0, ena_q1, count, new_bit, mask_bit_q0, mask_bit_q1,
            win_start, win_start_q0, mask_win_ctr, n_win, n_win_q0, n_win_q1)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                masking_state <= IDLE;
                i_wr_ena_mask <= (others=>'1');
            else
                case( masking_state ) is

                    when IDLE =>
                        n_win_q0 <= n_win;
                        mask_bit_q0 <= new_bit;
                        count <= "00000";
                        win_start_q0 <= win_start;
                        if (not ena_q1 and ena_q0) = '1'  then
                            n_win_q1 <= n_win_q0;
                            mask_bit_q1 <= mask_bit_q0;
                            mask_win_ctr <= win_start_q0 - ("00000" & N_WINS_PADDING); --("00000" & N_WINS_PADDING)
                            masking_state <= MODIFY_MASK;
                        else
                            masking_state <= IDLE;
                        end if;

                    when MODIFY_MASK =>
                        if count = n_win_q1 + (N_WINS_PADDING & "0") then
                            masking_state <= IDLE;
                        else
                            count <= count + '1';
                            mask_win_ctr <= mask_win_ctr + '1';
                            i_wr_ena_mask(to_integer(unsigned(mask_win_ctr))) <= mask_bit_q1;
                            masking_state <= MODIFY_MASK;
                        end if;
                end case;
            end if;
        end if;
    end process;



end Behavioral;
