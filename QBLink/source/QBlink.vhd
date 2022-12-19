library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.UtilityPkg.all;
library UNISIM;
use UNISIM.VComponents.all;
entity QBlink is
generic (
	GATE_DELAY_G   : time    := 1 ns
);
   Port (
      -- master clock
      sstClk              : in  sl;
      sstX5Clk            : in  sl; 
      -- Async reset signal (synced in module)
      rst                 : in  sl;
			
      -- Serial link - outgoing
      rawSerialOut        : out sl;
      -- Serial link - incoming
      rawSerialIn         : in  sl;

      -- Word-wise data in
      localWordIn         : in  slv(31 downto 0);
		localWordInValid    : in  sl;
      -- Word-wise data out
      localWordOut        : out slv(31 downto 0) := (others => '0');
      localWordOutValid   : out sl;
      localWordOutReq     : in sl;  -- Word Read Enable
		
      -- Status bits out
      trgLinkSynced     : out sl;
      serialClkLocked   : out sl :='0';
		
		--
		sync  : in sl := '0'
		);
end QBlink;

architecture Behavioral of QBlink is
   -- signal sstX5Clk       : sl; --by me
   signal sstRst         : sl;
   signal sstX5Rst       : sl;
   signal linkAligned    : sl;
   signal txData10b      : slv(9 downto 0);
   signal rxData10b      : slv(9 downto 0);
   signal txSerialData   : sl;
   signal rxSerialData   : sl;
   signal rx_fifo_empty  : sl;	
-- Received Bytewise	
   signal localByteOut       : slv(7 downto 0);
   signal localByteOutValid  : sl;
-- Transmitted Bytewise	
   signal localByteIn        : slv(7 downto 0);
   signal localByteInValid   : sl;
	signal tx_fifo_empty	     : sl;
	
	signal i_sync : sl :='0';
	
component axi_fifo_32w_32d is

  port (
   s_aclk : in std_logic;
   s_aresetn : in std_logic;
   
   s_axis_tvalid : in std_logic;
   s_axis_tready :out std_logic;
   s_axis_tdata : in std_logic_vector(31 downto 0);
   
   m_axis_tvalid : out std_logic;
   m_axis_tready : in std_logic;
   m_axis_tdata : out std_logic_vector(31 downto 0)
  );
end component;


 signal i_s_axis_tdata : std_logic_vector(31 downto 0) := (others => '0');
 signal i_s_axis_tvalid :  std_logic := '0';
 signal i_s_axis_tready :std_logic;

--  signal ii_sync :std_logic :='0';
begin

	-- Input from ports
	rxSerialData <= rawSerialIn;
   -- Outputs to ports
	rawSerialOut <= txSerialData;
   trgLinkSynced <= linkAligned;
	
	i_sync <= sync;

   -- -- DCM to generate the 5x serial clock for the DDR links, by meeee
   -- U_ClockGenByteLink : entity work.clockgen_bytelink
   --    port map (
   --       -- Clock in ports
   --       SST_CLK_IN    => sstClk,
   --       -- Clock out ports
   --       SSTx5_CLK_OUT => sstX5Clk,
   --       -- Status and control signals
   --       RESET         => rst,
   --       LOCKED        => serialClkLocked
   --    );

   -- -- create sync after 1clk by meeeeeeee, not original
   --  delay_sync : process(sstClk)
   --  begin
    
   --      if rising_edge(sstClk) then
   --          if i_sync='1' then
   --             ii_sync <= '1';
   --          else
   --             ii_sync <= '0';
   --          end if;
   --      end if;
   --  end process;


   -- Create two resets, one on SSTx5, the other on SST
   U_SstReset : entity work.SyncBit_QBL
      generic map (
         INIT_STATE_G => '1'
      )
      port map (
         clk      => sstClk,
         rst      => rst,
         asyncBit => i_sync,
         syncBit  => sstRst
      );
   U_SstX5Reset : entity work.SyncBit_QBL
      generic map (
         INIT_STATE_G => '1'
      )
      port map (
         clk      => sstX5Clk,
         rst      => rst,
         asyncBit => i_sync, --   '0',
         syncBit  => sstX5Rst
      );
   -- Transmit interface (serial part)
   U_SerialInterfaceOut : entity work.S6SerialInterfaceOut
      port map (
         -- Parallel clock and reset
         sstClk    => sstClk,
         sstRst    => sstRst,
         -- Parallel data in
         data10bIn => txData10b,
         -- Serial clock
         sstX5Clk  => sstX5Clk,
         sstX5Rst  => sstX5Rst,
         -- Serial data out
         dataOut   => txSerialData
      );
   -- Receive interface (serial part)
   U_SerialInterfaceIn : entity work.S6SerialInterfaceIn
      port map (
         -- Parallel clock and reset
         sstClk    => sstClk,
         sstRst    => sstRst,
         -- Aligned indicator
         aligned   => linkAligned,
         -- Parallel data out
         dataOut   => rxData10b,
         -- Serial clock in
         sstX5Clk  => sstX5Clk,
         sstX5Rst  => sstX5Rst,
         -- Serial data in
         dataIn    => rxSerialData
      );
   -- Main link logic (parallel part)
   U_ByteLink : entity work.ByteLink
      generic map (
         ALIGN_CYCLES_G => 100
      )
      port map (
         -- User clock and reset
         clk           => sstClk,
         rst           => sstRst,
         -- Incoming encoded data
         rxData10b     => rxData10b,
         -- Received true data
         rxData8b      => localByteOut,
         rxData8bValid => localByteOutValid,
         -- Align signal
         aligned       => linkAligned,
         -- Outgoing true data
         txData8b      => localByteIn,
         txData8bValid => localByteInValid,
         -- Transmitted encoded data
         txData10b     => txData10b
      );

-- FIFO Transmitted Word and convert to bytes

-- logic to load byte to transfer
localByteInValid <= NOT tx_fifo_empty;
				
QBlink_TX_FIFO_W32R8 : entity work.QBLtxFIFO
  PORT MAP (
    rst => sstRst,
    wr_clk => sstClk,
    rd_clk => sstClk,
    
    
    din => localWordIn,
    wr_en => localWordInValid,
    full => open,
    overflow => open,


    rd_en => localByteInValid,
    dout => localByteIn,
    empty => tx_fifo_empty

    
  );		

		
-- FIFO Received bytes and convert to 32-bit word

-- logic to indicate received word available
--localWordOutValid <= NOT rx_fifo_empty;
--
--QBlink_RX_FIFO_W8R32 : entity work.CMD_FIFO_w8r32
--  PORT MAP (
--	 rst    => sstRst,
--    wr_clk => sstClk,
--    rd_clk => sstClk,
--    
--    -- input side 
--    din    => localByteOut, 
--    wr_en  => localByteOutValid,    
--    full   => open,   
--
--
--   -- output side 
--    rd_en  => localWordOutReq,           
--    dout   => localWordOut,            
--    empty  => rx_fifo_empty
--    
--    ); 

	process(sstClk)is 
	variable v_counter : integer :=3;
	variable v_buffer : slv(7 downto 0):= (others =>'0');
	variable v_buffer_valid :sl := '0';
	
	
	begin 
	if rising_edge(sstClk) then
		i_s_axis_tvalid	<= '0';	  -- after GATE_DELAY_G
		if localByteOutValid = '1' then 
			i_s_axis_tdata( v_counter *8 + 7 downto v_counter*8) <= localByteOut; -- after GATE_DELAY_G
			v_counter := v_counter -1;
		end if;
		if v_counter <= -1 then 
			v_counter := 3;
			i_s_axis_tvalid <= '1';	 -- after GATE_DELAY_G
		end if;
	
	
	end if;
	end process;
	
	


    QBlink_RX_FIFO_W8R32_1 : axi_fifo_32w_32d port map(
      s_aclk => sstClk,
      s_aresetn => not sstRst,
   
      s_axis_tvalid => i_s_axis_tvalid,
      s_axis_tready => i_s_axis_tready,
      s_axis_tdata=>i_s_axis_tdata,
   
      m_axis_tvalid => localWordOutValid,
      m_axis_tready => localWordOutReq,
      m_axis_tdata => localWordOut
  );
end Behavioral;