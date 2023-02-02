library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library work;
use work.klm_scint_pkg.all;

--! TargetX trigger-bit multiplexer. 
--! 
--! Chris Ketter. 11/30/2018.
--!
--! Input is 5 TargetX trigger bits, 
--! Output is 15-bit channel mask.
--! If trigger-bit 5 is low, one channel is hit, 
--! and mask has one bit high.
--! If trigger-bit 5 is high, multiple channels hit
--! and mask has bits high for each channel where 
--! there may be hits.
--! 

entity TrigBit2Mask is
    Port ( 
        clk            : in  std_logic := '0';
        bits           : in  STD_LOGIC_VECTOR (4 downto 0);
        ch_mask        : out std_logic_vector(14 downto 0)
        -- asic_mask      : out std_logic := '0'
    );
end TrigBit2Mask;

architecture Behavioral of TrigBit2Mask is
    
    signal X : std_logic_vector(14 downto 0) := (others=>'0');
    -- signal ch : integer range 0 to 14;
    
begin
    
    ch_mask <= X;
    -- asic_mask <= or_reduce(bits);

    process(clk)
        variable ch : integer;
    begin
        if rising_edge(clk) then
            if or_reduce(bits) = '0' then
                X <= (others=>'0');
            elsif bits(4) = '0' then
                ch := to_integer(unsigned(bits(3 downto 0)))-1;
                X <= (others=>'0');
                X(ch) <= '1';
            else
                X <= (bits(3) & bits(3) & bits(3) &
                      bits(2) & bits(2) & bits(2) & bits(2) & 
                      bits(1) & bits(1) & bits(1) & bits(1) & 
                      bits(0) & bits(0) & bits(0) & bits(0));
            end if;

        end if;
    end process;


end Behavioral;
 