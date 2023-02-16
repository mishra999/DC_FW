
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use work.BMD_definitions.all; 
use work.UtilityPkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--Hello
entity DC_Comm_back is 
	Generic ( num_DC : integer := 0; --highest index in DC signal vectors: (# of DCs) - 1 
            TIMEOUT_G       : integer := 125000; 
            GATE_DELAY_G : time := 1 ns );
    Port ( DATA_CLK : in  sl;
            sstX5Clk : in sl; --by me
           RX : in  slv(num_DC downto 0); 
           TX : out  slv(num_DC downto 0);
           DC_RESPONSE : in  slv (31 downto 0); 
           RES_VALID : in  slv( num_DC downto 0); 
        --    RESP_REQ : in slv(num_DC downto 0);
			--   CMD_DATA : out  slv(31 downto 0); 
			 	--to be added: WAVE_WD : out slv(31 downto 0);
				--             and WaveValid
				--to be added: TRIG : slv(31 downto 0);
				--            and TrigValid
        --    CMD_VALID : out  slv(num_DC downto 0);
			  QB_RST : in slv(num_DC downto 0) := (others => '0');
			--   TrigLogicRst : in sl; --me
			  SERIAL_CLK_LCK : out slv(num_DC downto 0);
			  TRIG_LINK_SYNC : out slv(num_DC downto 0);
			--   Event_Trig : out sl; --global event trigger --me
			  sync : in slv(num_DC downto 0);
              regAddr : out std_logic_vector(15 downto 0);
              regWrData : out std_logic_vector(15 downto 0);
              regReq    : out sl;
              regOp     : out std_logic_vector(1 downto 0);
              dataReq    : out sl;
              write_dac   : out sl
            --   start_win  : out slv(8 downto 0);
            --   stop_win  : out slv(8 downto 0)

			  );
end DC_Comm_back;

architecture Behaviorial of DC_Comm_back is

signal DC_RESPONSE_i : slv (31 downto 0):= (others => '0');
signal RES_VALID_i : slv( num_DC downto 0):= (others => '0');
signal tx_dc_back : slv(num_DC downto 0):= (others => '0');
signal rx_dc_back : slv(num_DC downto 0);
signal dc_cmdValid : slv(num_DC downto 0):= (others => '0');
signal rd_req : slv(num_DC downto 0):= (others => '0');
signal cmd_data : Word32Array(num_DC downto 0);
signal trgLinkSync :slv(num_DC downto 0):= (others => '0');
signal serialClkLck : slv(num_DC downto 0):= (others => '0');
-- signal TrigFlag : slv(num_DC downto 0) := (others => '0'); --me
-- signal DC_sel : slv(num_DC downto 0) := (others => '0'); --me
-- signal evnt_trig : sl := '0'; --me
-- signal CtrlRegister : GPR:= (others => x"9987");
signal i_sync : slv(num_DC downto 0) := (others => '0');

type StateType     is (IDLE,DECODE_COMMAND,READ_ADDR_VALUE);  

type RegType is record
    state       : StateType;
    rd_req     : slv(num_DC downto 0);
    read   : slv(1 downto 0);
    write   : slv(1 downto 0);
    timeoutCnt  : slv(31 downto 0);
    regAddr  : slv(15 downto 0);
    regWrData  : slv(15 downto 0);
    regReq    : sl;
    regOp     : slv(1 downto 0);
    -- start_win  : slv(15 downto 0);
    -- stop_win  : slv(15 downto 0);
    dataReq    : sl;
    write_dac    : sl;

end record RegType;  

constant REG_INIT_C : RegType := (
    state   => IDLE,
    rd_req  => (others => '0'),
    read   => "00",
    write   => "00",
    timeoutCnt   => (others => '0'),
    regAddr   => (others => '0'),
    regReq     => '0',
    regWrData  => (others => '0'),
    regOp => "00",
    -- start_win  => (others => '0'),
    -- stop_win  => (others => '0'),
    dataReq     => '0',
    write_dac     => '0'
);

-- constant N_GPR : integer := 20;--127;
-- type GPR is array(N_GPR-1 downto 0) of std_logic_vector(15 downto 0);

signal r   : RegType := REG_INIT_C;
signal rin : RegType;
signal stateNum : slv(1 downto 0);
attribute mark_debug : string;
attribute mark_debug of stateNum : signal is "true";

constant WORD_READ_C      : slv(31 downto 0) := x"72656164";
constant WORD_WRITE_C     : slv(31 downto 0) := x"72697465";
constant WORD_WRITE_DAC     : slv(31 downto 0) := x"72697445";
constant WORD_READ_DATA      : slv(31 downto 0) := x"72652124";

begin
TX <= tx_dc_back;
rx_dc_back <= RX;
DC_RESPONSE_i <= DC_RESPONSE;
RES_VALID_i <= RES_VALID;
-- CMD_VALID <= dc_cmdValid; 
-- CMD_DATA <= cmd_data1;
-- rd_req <= RESP_REQ;  
TRIG_LINK_SYNC <= trgLinkSync;
SERIAL_CLK_LCK <= serialClkLck;
-- Event_trig <= evnt_trig;
i_sync <= sync;

StateNum <= 	"00" when r.state = IDLE else
						"01" when r.state = DECODE_COMMAND else
						"10" when r.state = READ_ADDR_VALUE;
  

-- DC_resp : Process(dc_cmd, DATA_CLK) --DC_sel,evnt_trig
-- 	-- variable count : integer := 0;
-- begin
-- 	IF rising_edge(DATA_CLK) THEN
-- 		if rd_req(0) = '1' then
-- 			DC_CMD <= cmd_data(0);
-- 		end if;
-- 	end if;
-- end process; 


DC_Interface_back : entity work.QBLink                                                     
PORT MAP( 
			 sstClk => DATA_CLK,
             sstX5Clk => sstX5Clk, --me 
			 rst => QB_RST(0), --(I),
			 rawSerialOut => tx_dc_back(0), --(I),
			 rawSerialIn => rx_dc_back(0), --(I),
			 localWordIn => DC_RESPONSE_i, 
			 localWordInValid => RES_VALID_i(0) ,--(I),
			 localWordOut => cmd_data(0), --(I),
			 localWordOutValid => dc_cmdValid(0), --(I),
			 localWordOutReq => rd_req(0), --(I),
			 trgLinkSynced => trgLinkSync(0), --(I),
			 serialClkLocked => serialClkLck(0), --(I),
			 sync => i_sync(0) --(I)
			 );
-- end GENERATE Gen_QBLink;


   -- Master state machine (combinatorial)
   comb : process(r,dc_cmdValid) is --, DC_RESPONSE, RES_VALID, QB_RST,
      variable v : RegType;
   begin
      v := r;
    --   RES_VALID(0) <= '0';
    v.regReq := '0';
    v.dataReq := '0';
    v.regOp := "00"; 
    v.write_dac := '0';     
      -- State machine 
    case(r.state) is
        when IDLE =>
            v.rd_req := (others => '1');
            v.read := "00";
            v.write := "00";
            v.timeoutCnt  := (others => '0');
            if dc_cmdValid(0) = '1' then
                v.rd_req(0) := '1';
                v.state := DECODE_COMMAND;
            end if;
        when DECODE_COMMAND =>
            v.timeoutCnt := r.timeoutCnt + 1;
            v.rd_req(0) := '1';
            if (cmd_data(0)=WORD_READ_C) then
                v.read := "01";
                v.state := READ_ADDR_VALUE;
                v.timeoutCnt  := (others => '0');
            elsif (cmd_data(0)=WORD_WRITE_C) then
                v.write := "01";
                v.state := READ_ADDR_VALUE;
                v.timeoutCnt  := (others => '0');
            elsif (cmd_data(0)=WORD_WRITE_DAC) then
                v.write := "10";
                v.state := READ_ADDR_VALUE;
                v.timeoutCnt  := (others => '0');
            elsif (cmd_data(0)=WORD_READ_DATA) then
                v.read := "11";
                v.state := READ_ADDR_VALUE;
                v.timeoutCnt  := (others => '0');
            elsif r.timeoutCnt = TIMEOUT_G then 
				v.state    := IDLE;
            end if;
        when READ_ADDR_VALUE => 
            v.timeoutCnt := r.timeoutCnt + 1;
            if dc_cmdValid(0) = '1' then
                if (r.read = "01") then
                    v.regAddr := cmd_data(0)(15 downto 0);
                    v.rd_req(0) := '0';
                    -- v.read := "11";
                    v.regReq := '1';
                    v.regOp := "00";
                    v.timeoutCnt  := (others => '0');
                    v.state    := IDLE;
                elsif (r.read = "11") then --read data
                    v.regAddr := cmd_data(0)(15 downto 0); 
                    v.regWrData := cmd_data(0)(31 downto 16);
                    v.rd_req(0) := '0';
                    -- v.read := "11";
                    v.dataReq := '1';
                    v.regOp := "11";
                    v.timeoutCnt  := (others => '0');
                    v.state    := IDLE;                    
                elsif (r.write = "01") then
                    v.regAddr := cmd_data(0)(15 downto 0); 
                    v.regWrData := cmd_data(0)(31 downto 16);
                    v.rd_req(0) := '0';
                    -- v.write := "01";
                    v.regOp := "01";
                    v.regReq := '1';
                    v.timeoutCnt  := (others => '0');
                    v.state    := IDLE;
                elsif (r.write = "10") then
                    v.regAddr := cmd_data(0)(15 downto 0); 
                    v.regWrData := cmd_data(0)(31 downto 16);
                    v.rd_req(0) := '0';
                    -- v.write := "11";
                    v.regOp := "10";
                    v.regReq := '1';
                    v.write_dac := '1';
                    v.timeoutCnt  := (others => '0');
                    v.state    := IDLE;
                else 
                    v.state    := IDLE;
                    v.timeoutCnt  := (others => '0');
                end if;
            elsif r.timeoutCnt = TIMEOUT_G then 
				v.state    := IDLE;
                
            end if;
      end case; 

    --   -- Reset logic
    --   if (rst = '1') then
    --      v := REG_INIT_C;
    --   end if;

      -- Assignment of combinatorial variable to signal
      rin <= v;
      rd_req <= r.rd_req;
      -- Outputs to ports
      
      regAddr     <= r.regAddr;
      regWrData   <= r.regWrData;
      regReq      <= r.regReq;
      dataReq      <= r.dataReq;
      regOp       <= r.regOp;
      write_dac       <= r.write_dac;
    --   start_win    <= r.start_win(8 downto 0);
    --   stop_win    <= r.stop_win(8 downto 0);
    --   rxData8b      <= r.rxData8b;
    --   rxData8bValid <= r.rxData8bValid;
    --   aligned       <= r.aligned;
    --   txData10b     <= r.txData10b;

   end process;


    seq : process (DATA_CLK) is
    begin
        if (rising_edge(DATA_CLK)) then
            -- RES_VALID(0) <= '0';
            r <= rin after GATE_DELAY_G;
            -- if r.read = "11" then
            --     DC_RESPONSE(15 downto 0) <= "0000" + CtrlRegister(to_integer(unsigned(r.regAddr)));
            --     RES_VALID(0) <= '1';
            -- elsif r.write = "11" then
            --     CtrlRegister(to_integer(unsigned(r.regAddr))) <= r.regWrData;
            --     DC_RESPONSE(15 downto 0) <= "0000" + r.regAddr;
            --     RES_VALID(0) <= '1';                
            -- end if;
        end if;
    end process;


end Behaviorial;




-- library IEEE;
-- use IEEE.STD_LOGIC_1164.ALL;
-- use work.all;
-- use work.BMD_definitions.all; 
-- use work.UtilityPkg.all;
-- -- Uncomment the following library declaration if using
-- -- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;
-- use ieee.std_logic_unsigned.all;
-- -- Uncomment the following library declaration if instantiating
-- -- any Xilinx primitives in this code.
-- --library UNISIM;
-- --use UNISIM.VComponents.all;
-- --Hello
-- entity DC_Comm_back is 
-- 	Generic ( num_DC : integer := 0; --highest index in DC signal vectors: (# of DCs) - 1 
--             TIMEOUT_G       : integer := 125000; 
--             GATE_DELAY_G : time := 1 ns );
--     Port ( DATA_CLK : in  sl;
--             sstX5Clk : in sl; --by me
--            RX : in  slv(num_DC downto 0); 
--            TX : out  slv(num_DC downto 0);
--            DC_RESPONSE : in  slv (31 downto 0); 
--            RES_VALID : in  slv( num_DC downto 0); 
--         --    RESP_REQ : in slv(num_DC downto 0);
-- 			--   CMD_DATA : out  slv(31 downto 0); 
-- 			 	--to be added: WAVE_WD : out slv(31 downto 0);
-- 				--             and WaveValid
-- 				--to be added: TRIG : slv(31 downto 0);
-- 				--            and TrigValid
--         --    CMD_VALID : out  slv(num_DC downto 0);
-- 			  QB_RST : in slv(num_DC downto 0) := (others => '0');
-- 			--   TrigLogicRst : in sl; --me
-- 			  SERIAL_CLK_LCK : out slv(num_DC downto 0);
-- 			  TRIG_LINK_SYNC : out slv(num_DC downto 0);
-- 			--   Event_Trig : out sl; --global event trigger --me
-- 			  sync : in slv(num_DC downto 0);
--               regAddr : out std_logic_vector(15 downto 0);
--               regWrData : out std_logic_vector(15 downto 0);
--               regReq    : out sl;
--               regOp     : out sl
-- 			  );
-- end DC_Comm_back;

-- architecture Behaviorial of DC_Comm_back is

-- signal DC_RESPONSE_i : slv (31 downto 0):= (others => '0');
-- signal RES_VALID_i : slv( num_DC downto 0):= (others => '0');
-- signal tx_dc_back : slv(num_DC downto 0):= (others => '0');
-- signal rx_dc_back : slv(num_DC downto 0);
-- signal dc_cmdValid : slv(num_DC downto 0):= (others => '0');
-- signal rd_req : slv(num_DC downto 0):= (others => '0');
-- signal cmd_data : Word32Array(num_DC downto 0);
-- signal trgLinkSync :slv(num_DC downto 0):= (others => '0');
-- signal serialClkLck : slv(num_DC downto 0):= (others => '0');
-- -- signal TrigFlag : slv(num_DC downto 0) := (others => '0'); --me
-- -- signal DC_sel : slv(num_DC downto 0) := (others => '0'); --me
-- -- signal evnt_trig : sl := '0'; --me
-- -- signal CtrlRegister : GPR:= (others => x"9987");
-- signal i_sync : slv(num_DC downto 0) := (others => '0');

-- type StateType     is (IDLE,DECODE_COMMAND);  

-- type RegType is record
--     state       : StateType;
--     rd_req     : slv(num_DC downto 0);
--     -- read   : slv(1 downto 0);
--     -- write   : slv(1 downto 0);
--     timeoutCnt  : slv(31 downto 0);
--     regAddr  : slv(15 downto 0);
--     regWrData  : slv(15 downto 0);
--     regReq    : sl;
--     regOp     : sl;

-- end record RegType;  

-- constant REG_INIT_C : RegType := (
--     state   => IDLE,
--     rd_req  => (others => '0'),
--     -- read   => "00",
--     -- write   => "00",
--     timeoutCnt   => (others => '0'),
--     regAddr   => (others => '0'),
--     regReq     => '0',
--     regWrData  => (others => '0'),
--     regOp => '0'
-- );

-- -- constant N_GPR : integer := 20;--127;
-- -- type GPR is array(N_GPR-1 downto 0) of std_logic_vector(15 downto 0);

-- signal r   : RegType := REG_INIT_C;
-- signal rin : RegType;
-- signal stateNum : sl;
-- attribute mark_debug : string;
-- attribute mark_debug of stateNum : signal is "true";

-- constant WORD_READ_C      : slv(31 downto 0) := x"72656164";
-- constant WORD_WRITE_C     : slv(31 downto 0) := x"72697465";

-- begin
-- TX <= tx_dc_back;
-- rx_dc_back <= RX;
-- DC_RESPONSE_i <= DC_RESPONSE;
-- RES_VALID_i <= RES_VALID;
-- -- CMD_VALID <= dc_cmdValid; 
-- -- CMD_DATA <= cmd_data1;
-- -- rd_req <= RESP_REQ;  
-- TRIG_LINK_SYNC <= trgLinkSync;
-- SERIAL_CLK_LCK <= serialClkLck;
-- -- Event_trig <= evnt_trig;
-- i_sync <= sync;

-- StateNum <= 	'0' when r.state = IDLE else
-- 						'1' when r.state = DECODE_COMMAND; -- else
-- 						-- "10" when r.state = READ_ADDR_VALUE;
  

-- -- DC_resp : Process(dc_cmd, DATA_CLK) --DC_sel,evnt_trig
-- -- 	-- variable count : integer := 0;
-- -- begin
-- -- 	IF rising_edge(DATA_CLK) THEN
-- -- 		if rd_req(0) = '1' then
-- -- 			DC_CMD <= cmd_data(0);
-- -- 		end if;
-- -- 	end if;
-- -- end process; 


-- DC_Interface_back : entity work.QBLink                                                     
-- PORT MAP( 
-- 			 sstClk => DATA_CLK,
--              sstX5Clk => sstX5Clk, --me 
-- 			 rst => QB_RST(0), --(I),
-- 			 rawSerialOut => tx_dc_back(0), --(I),
-- 			 rawSerialIn => rx_dc_back(0), --(I),
-- 			 localWordIn => DC_RESPONSE_i, 
-- 			 localWordInValid => RES_VALID_i(0) ,--(I),
-- 			 localWordOut => cmd_data(0), --(I),
-- 			 localWordOutValid => dc_cmdValid(0), --(I),
-- 			 localWordOutReq => rd_req(0), --(I),
-- 			 trgLinkSynced => trgLinkSync(0), --(I),
-- 			 serialClkLocked => serialClkLck(0), --(I),
-- 			 sync => i_sync(0) --(I)
-- 			 );
-- -- end GENERATE Gen_QBLink;


--    -- Master state machine (combinatorial)
--    comb : process(QB_RST,r,dc_cmdValid,cmd_data) is --, DC_RESPONSE, RES_VALID
--       variable v : RegType;
--    begin
--       v := r;
--     --   RES_VALID(0) <= '0';
      
--       -- State machine 
--     case(r.state) is
--         when IDLE =>
--             v.rd_req := (others => '1');
--             v.regReq := '0';
--             v.regOp := '0';
--             v.timeoutCnt  := (others => '0');
--             if dc_cmdValid(0) = '1' then
--                 v.rd_req(0) := '1';
--                 v.state := DECODE_COMMAND;
--             end if;
--         when DECODE_COMMAND =>
--             v.regReq := '0';
--             v.regOp := '0';
--             v.timeoutCnt := r.timeoutCnt + 1;
--             v.rd_req(0) := '1';
--             if (cmd_data(0)(31 downto 16)= x"0000") then
--                 v.regAddr := cmd_data(0)(15 downto 0);
--                 v.rd_req(0) := '0';
--                 v.regReq := '1';
--                 v.regOp := '0';
--                 v.timeoutCnt  := (others => '0');
--                 v.state    := IDLE;
--             elsif (cmd_data(0)(31 downto 16) /= x"0000") then
--                 v.regAddr := cmd_data(0)(15 downto 0); 
--                 v.regWrData := cmd_data(0)(31 downto 16);
--                 v.rd_req(0) := '0';
--                 -- v.write := "11";
--                 v.regOp := '1';
--                 v.regReq := '1';
--                 v.timeoutCnt  := (others => '0');
--                 v.state    := IDLE;
--             elsif r.timeoutCnt = TIMEOUT_G then 
-- 				v.state    := IDLE;
--             end if;
--         -- when READ_ADDR_VALUE => 
--         --     v.timeoutCnt := r.timeoutCnt + 1;
--         --     if dc_cmdValid(0) = '1' then
--         --         if (v.read = "01") then
--         --             v.regAddr := cmd_data(0)(15 downto 0);
--         --             v.rd_req(0) := '0';
--         --             v.read := "11";
--         --             v.regReq := '1';
--         --             v.regOp := '0';
--         --             v.timeoutCnt  := (others => '0');
--         --             v.state    := IDLE;
                    
--         --         elsif (v.write = "01") then
--         --             v.regAddr := cmd_data(0)(15 downto 0); 
--         --             v.regWrData := cmd_data(0)(31 downto 16);
--         --             v.rd_req(0) := '0';
--         --             v.write := "11";
--         --             v.regOp := '1';
--         --             v.regReq := '1';
--         --             v.timeoutCnt  := (others => '0');
--         --             v.state    := IDLE;
                    
--         --         else 
--         --             v.state    := IDLE;
--         --             v.timeoutCnt  := (others => '0');
--         --         end if;
--         --     elsif r.timeoutCnt = TIMEOUT_G then 
-- 		-- 		v.state    := IDLE;
                
--         --     end if;
--       end case; 

--     --   -- Reset logic
--     --   if (rst = '1') then
--     --      v := REG_INIT_C;
--     --   end if;

--       -- Assignment of combinatorial variable to signal
--       rin <= v;
--       rd_req <= r.rd_req;
--       -- Outputs to ports
      
--       regAddr     <= r.regAddr;
--       regWrData   <= r.regWrData;
--       regReq      <= r.regReq;
--       regOp       <= r.regOp;
--     --   rxData8b      <= r.rxData8b;
--     --   rxData8bValid <= r.rxData8bValid;
--     --   aligned       <= r.aligned;
--     --   txData10b     <= r.txData10b;

--    end process;


--     seq : process (DATA_CLK) is
--     begin
--         if (rising_edge(DATA_CLK)) then
--             -- RES_VALID(0) <= '0';
--             r <= rin after GATE_DELAY_G;
--             -- if r.read = "11" then
--             --     DC_RESPONSE(15 downto 0) <= "0000" + CtrlRegister(to_integer(unsigned(r.regAddr)));
--             --     RES_VALID(0) <= '1';
--             -- elsif r.write = "11" then
--             --     CtrlRegister(to_integer(unsigned(r.regAddr))) <= r.regWrData;
--             --     DC_RESPONSE(15 downto 0) <= "0000" + r.regAddr;
--             --     RES_VALID(0) <= '1';                
--             -- end if;
--         end if;
--     end process;


-- end Behaviorial;



