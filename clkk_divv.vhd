---------------------------------------------------------------------------------- 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
   use ieee.numeric_std.all;
   use ieee.std_logic_unsigned.all;
library UNISIM;                                                                                                        
   use UNISIM.vcomponents.all;                                                                                            

entity clkk_divv is
   generic (
      RATIO : integer := 40
   );
   port (
      clk       : in  std_logic;
      rst       : in  std_logic;
      strb      : in  std_logic;

      clkdiv    : out std_logic;
      hb        : out std_logic;
      sync_strb : out std_logic
   );
end clkk_divv;

architecture beh of clkk_divv is
   constant max_cnt      : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(RATIO/2 - 1, 32));
   constant max_cnt_prd  : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(RATIO - 1, 32));
   constant zero_cnt     : std_logic_vector(31 downto 0) := (others => '0');
   signal   i_cnt        : std_logic_vector(31 downto 0) := (others => '0');
   signal   i_clkdiv     : std_logic := '0';

   signal   i_hb_cnt     : std_logic_vector(31 downto 0) := (others => '0');
   signal   i_hb         : std_logic;

   signal   i_strb_cnt   : std_logic_vector(31 downto 0) := (others => '0');
   signal   i_strb       : std_logic := '0';
   signal   i_strb_e     : std_logic := '0';
begin                                                                                                                

   CLK_PROC : process(clk)
   begin
      if rising_edge(clk) then
         if rst = '1' then
            i_cnt <= (others => '0');
            i_clkdiv <= '0';
         else
            if i_cnt = max_cnt then
               i_cnt <= (others => '0');
               i_clkdiv <= not i_clkdiv;
            else
               i_cnt <= i_cnt + '1';
            end if;
         end if;
      end if;
   end process CLK_PROC;

   clkdiv <= i_clkdiv;

   HB_PROC : process(clk)
   begin
      if rising_edge(clk) then
         i_hb <= '0';
         i_hb_cnt <= i_hb_cnt + 1;
         if i_hb_cnt = max_cnt then
            i_hb <= '1';
         end if;
         if i_hb_cnt = max_cnt_prd then
            i_hb_cnt <= (others => '0');
         end if;
      end if;
   end process;

   hb <= i_hb;

   STRB_PROC : process(clk)
   begin
      if rising_edge(clk) then

         if strb = '1' then
            i_strb_e <= '1';
         end if;

         if i_strb_e = '1' and i_hb_cnt = max_cnt then
            i_strb <= '1';
            i_strb_e <= '0';
         else
            i_strb <= '0';
         end if;

      end if;
   end process STRB_PROC;

   sync_strb <= i_strb;

end beh;

