
library ieee; --allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
use WORK.constants.all;

--library lpm;  
--USE lpm.lpm_components.all; --this library includes 32-bit adder

entity USController is
port (	
      	CLK 		: in std_logic;
	RST 		: in std_logic;
	CLK_OUT		: out std_logic;
	CLK_OUT22	: out std_logic;
	CLK_OUTxM	: out std_logic;
	PCLK		: out std_logic;
	NCLK		: out std_logic;
	BTN1 		: in std_logic;
	BTN2 		: in std_logic;
	KEY0 		: in std_logic;
	KEY1 		: in std_logic;
	KEY8 		: in std_logic;		-- to change the mode
	KEY9 		: in std_logic;		-- to change the fire lenght
	OUT1Push 	: out std_logic;	-- Fitted envelop of the OUT1
	OUT1RxEnv	: out std_logic;
	MODE		: out std_logic_vector(1 downto 0);
	OUT1P  		: out std_logic;
	OUT1N  		: out std_logic;
	OUT2P  		: out std_logic;
	OUT2N  		: out std_logic;
	OUT3P  		: out std_logic;
	OUT3N  		: out std_logic;
	OUT4P  		: out std_logic;
	OUT4N  		: out std_logic;
	DAC_VAL		: out std_logic_vector(7 downto 0);
	DAC_WR 		: out std_logic;	
	DAC_AB 		: out std_logic;		-- '0' => Block 12(A), '1' => block 34(B)
	LED0			: out std_logic;
	LED1			: out std_logic;
	LED2			: out std_logic
);
end USController;



architecture USController_arch of USController is

component CLKDivider
port (	    
	CLK 		: in std_logic;
	RST 		: in std_logic;
	ENABLE 		: in std_logic;
	CLK2  		: out std_logic;
	CLK1M  		: out std_logic;	-- Clock 2.2 MHZ
	CLKxM 		: out std_logic;	-- Clock 3.68 MHZ
	SHIFT_INDEX	: in  std_logic_vector(5 downto 0);
	CLK1Shift	: out std_logic;
	CLK1  		: out std_logic	
			);
end component;


component DeBouncer
port (	
    	CLK 		: in std_logic;		-- Clock 50 MHZ
	RST 		: in std_logic;
	DIN 		: in std_logic;
	DOUT		: out std_logic	
);
end component;



TYPE OP_MODE_Type is (SHUTDOWN, LEVEL3, LEVEL5, TR_DISABLE );
signal OP_MODE : OP_MODE_Type;

TYPE PulsGen_Type is (BURST_OFF,BURST_ON,BURST_CLAMP, BURST_TR_SWITCH, BURST_RX,BURST_HALT, RX_ONLY, TX_ONLY);
signal GenStages : PulsGen_Type;



signal ENABLE		: std_logic;
signal Burst_EN		: std_logic;
signal Counter		: integer;
signal CLK_xM		: std_logic;
signal CLK_1M		: std_logic;
signal CLK1		: std_logic;
signal CLK_shifted	: std_logic;
signal FIRE_EN		: std_logic;

signal BTN2_DB		: std_logic;
signal BTN1_DB		: std_logic;
signal BTN2_i		: std_logic;
signal BTN1_i		: std_logic;

signal OUT1CM		: std_logic;
signal DAC_VAL_i	: std_logic_vector(7 downto 0);
signal DAC_WR_i		: std_logic;
signal DAC_TIME_REF	: std_logic;
signal DAC_TIME_Count	: std_logic_vector(2 downto 0);
signal SHIFT_INDEX_i	: std_logic_vector(5 downto 0);

--signal KEY8			:std_logic;
--signal KEY9			:std_logic;
signal KEY2			:std_logic;
signal KEY3			:std_logic;
BEGIN

B0: CLKDivider 
port map(    
	CLK 	=> CLK,	     
	RST 	=> RST,
	ENABLE 	=> ENABLE,
	CLK2	=> CLK_OUT22,
	CLK1M	=> CLK_1M,
	CLKxM	=> CLK_xM,
	SHIFT_INDEX => SHIFT_INDEX_i,
	CLK1shift=> CLK_shifted,
	CLK1	=> CLK1
	);
  
DB_EnableBTN2: DeBouncer 
port map(    
	CLK 	=> CLK_1M,	     
	RST 	=> RST,
	DIN 	=> BTN2_i,
	DOUT 	=> BTN2_DB
	);
  
DB_EnableBTN1: DeBouncer 
port map(    
	CLK 	=> CLK_1M,	     
	RST 	=> RST,
	DIN 	=> BTN1_i,
	DOUT 	=> BTN1_DB
	);

with OP_MODE select
	MODE <=
	"00" when SHUTDOWN,
	"01" when LEVEL3,
	"10" when LEVEL5,
	"11" when TR_DISABLE;

--CLK_1M		<= CLK_xM;					-- Use this line when the sensor is 1 MHz, to share the same CLK
LED0			<= Burst_EN;
LED1			<= ((FIRE_EN and CLK_xM) or OUT1CM);
LED2			<= FIRE_EN;
ENABLE	 	<= KEY0;
Burst_EN	<= KEY1 and KEY0;
--CLK_OUT		<= CLK1;
CLK_OUT		<= CLK_shifted;	-- shifted phase of a 1 MHz clock
PCLK		<= CLK_xM and KEY3;
NCLK		<= not(CLK_xM) and KEY3;

BTN1_i		<= not(BTN1);
BTN2_i		<= not(BTN2);
DAC_VAL		<= DAC_VAL_i;
DAC_WR		<= DAC_TIME_REF;
OUT1N		<= ((FIRE_EN and CLK_xM) or OUT1CM);
OUT1P		<= ((FIRE_EN and (not(CLK_xM))) or OUT1CM);
OUT1Push	<= FIRE_EN;

OUT2N		<= ((FIRE_EN and CLK_xM) or OUT1CM);
OUT2P		<= ((FIRE_EN and (not(CLK_xM))) or OUT1CM);
OUT3N		<= ((FIRE_EN and CLK_xM) or OUT1CM);
OUT3P		<= ((FIRE_EN and (not(CLK_xM))) or OUT1CM);
OUT4N		<= ((FIRE_EN and CLK_xM) or OUT1CM);
OUT4P		<= ((FIRE_EN and (not(CLK_xM))) or OUT1CM);

KEY3		<= '1';
KEY2		<= '1';
Time_Source: process(RST,CLK_1M)
begin                                                     
if (RST = '0') then	
	Counter <= 0;
	DAC_TIME_REF <= '0';
	DAC_TIME_Count <= b"000";
elsif((CLK_1M ='1') and CLK_1M'event) then --clock is rising edge
	if (Burst_EN = '1') then
		Counter <= Counter + 1;
		if (Counter = T_PRF) then Counter <= 0; end if;

		if(DAC_TIME_Count = b"101") then
			DAC_TIME_REF <= '1';
			DAC_TIME_Count <= b"000";
		else
			DAC_TIME_REF <= '0';
			DAC_TIME_Count <= std_logic_vector(unsigned(DAC_TIME_Count) + 1);
		end if;
	end if;
end if;
end process;


PRF_Gen : PROCESS(RST,CLK_xM)                                                                 
BEGIN                                                         
if (RST = '0') then
  FIRE_EN 	<= '0';
  OP_MODE 	<= LEVEL3;
  GenStages 	<= BURST_OFF;
  OUT1CM	<= '0';
  OUT1RxEnv	<= '0';
  DAC_VAL_i <= (b"00101101");
  DAC_WR_i	<= '0';
  DAC_AB		<= '1';

elsif((CLK_xM ='1') and CLK_xM'event) then --clock is rising edge



case GenStages is
	when BURST_OFF =>
	  	FIRE_EN <= '0';
		-- look for the btn pressed, once pressed go to BURST_ON and init it.
	 	if (Burst_EN = '1') then 
			GenStages <= BURST_ON;
			OP_MODE <= LEVEL3;
			FIRE_EN <= '1';
		else
			if (KEY8 = '0' and KEY9 = '1') then 
				--GenStages <= RX_ONLY;
				OP_MODE <= LEVEL3;
				OUT1CM <= '1';
			elsif (KEY9 = '0' and KEY8 = '1') then 
				--GenStages <= TX_ONLY;
				OP_MODE <= LEVEL3;
				OUT1CM <= '0';
			elsif (KEY9 = '1' and KEY8 = '1') then 
				OP_MODE <= TR_DISABLE;
				OUT1CM <= '1';
			end if;

	  	end if;


	when BURST_ON =>
		if (Counter < T_ON)  then
			FIRE_EN <= '1';    		
			
		  
		--elsif (Counter < T_OFF)  then
			--FIRE_EN <= '0';
			--GenStages <= BURST_ON;
		else
			FIRE_EN <= '0';
			OUT1CM <= '0';
			--GenStages <= BURST_CLAMP;
			GenStages <= BURST_RX;
		end if;
		
	
	when BURST_CLAMP =>
		 -- OP_MODE <= LEVEL3;
		if (Counter < (T_CLAMP + T_ON))  then
			OUT1CM <= '0';    		
		else
			OUT1CM <= '1';    		
		 	GenStages <= BURST_TR_SWITCH;
		end if;	



	when BURST_TR_SWITCH =>

		 -- OP_MODE <= TR_DISABLE;
		 -- GenStages <= BURST_RX;

		if (Counter < (T_DAMP + T_ON + T_CLAMP))  then
			OUT1CM <= '1';    		
		else
			--OUT1CM <= '0';    		
			
		 	GenStages <= BURST_RX;
			OP_MODE <= TR_DISABLE;
		end if;	

	when BURST_RX =>


		OUT1RxEnv <= '1';

		if (Counter < (T_DAMP + T_ON + T_CLAMP + T_RX))  then
			OUT1CM <= '1'; 
			if (KEY2 = '1') then OP_MODE <= TR_DISABLE;
			else OP_MODE <= LEVEL3; end if;	
	else
		
	
			
			GenStages <= BURST_HALT;
			OP_MODE <= TR_DISABLE;
			FIRE_EN <= '0';
			OUT1CM <= '0'; 
			OUT1RxEnv <= '0';
		end if;			
		if ((DAC_TIME_REF = '1')and (DAC_VAL_i < b"01111100")) then
			if (DAC_VAL_i < b"00101111") then
				DAC_VAL_i <= std_logic_vector(unsigned(DAC_VAL_i) + 1);
			else
				DAC_VAL_i <= std_logic_vector(unsigned(DAC_VAL_i) + 2);
			end if;
		end if;
		--DAC_WR_i<= not(DAC_WR_i);
		DAC_AB		<= '1';


	when BURST_HALT =>

		if (Counter < T_OFF)  then
			OUT1CM <= '0'; 
		else
			GenStages <= BURST_ON;
			OP_MODE <= LEVEL3;
			FIRE_EN <= '1';
		end if;		

		if ((DAC_TIME_REF = '1') and not(DAC_VAL_i = b"00101101")) then
			DAC_VAL_i <= std_logic_vector(unsigned(DAC_VAL_i) - 1);
		end if;
		-- wait for a few multiple times than the BURST_ON.
		  --OP_MODE <= TR_DISABLE;


	when RX_ONLY =>


	when TX_ONLY =>

end case;

end if;
end process;


-- To control the shift using BTN2 and BTN1,
ShiftIndex_Gen: process(RST,CLK_xM)
begin                                                     
if (RST = '0') then	

	SHIFT_INDEX_i <= b"001000";
elsif((CLK_xM ='1') and CLK_xM'event) then --clock is rising edge

	if ((BTN2_DB = '1') and ((SHIFT_INDEX_i < b"110001"))) then 
		SHIFT_INDEX_i <= std_logic_vector(unsigned(SHIFT_INDEX_i) + 1);
	elsif ((BTN1_DB = '1') and (SHIFT_INDEX_i > b"000000")) then 
		SHIFT_INDEX_i <= std_logic_vector(unsigned(SHIFT_INDEX_i) - 1);
	end if;
end if;
end process;


end USController_arch;