

library ieee; --allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
use WORK.constants.all;

--library lpm;  
--USE lpm.lpm_components.all; --this library includes 32-bit adder

entity CLKDivider is
port (	
    CLK 		: in std_logic;		-- Clock 50 MHZ
	RST 		: in std_logic;
	ENABLE 		: in std_logic;
	CLK2  		: out std_logic;	-- Clock 2 MHZ
	CLK1M  		: out std_logic;	-- Clock 2.2 MHZ
	CLKxM 		: out std_logic;	-- Clock 3.68 MHZ
	SHIFT_INDEX	: in  std_logic_vector(5 downto 0);
	CLK1Shift	: out std_logic;
	CLK1  		: out std_logic		-- Clock 1 MHZ
);
end CLKDivider;



architecture CLKDivider_arch of CLKDivider is

component MyPLL is
	port (
		refclk   : in  std_logic ; --  refclk.clk
		rst      : in  std_logic; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		outclk_1 : out std_logic        -- outclk1.clk
	);
end component;

--signal CLK_ShiftReg : std_logic_vector(12-1 downto 0):= std_logic_vector(to_unsigned(CLK_ShiftReg_ini,12));
signal CLK1_i : std_logic := '0';
signal CLK2_i : std_logic := '0';
signal CLK10_i : std_logic := '0';
signal CLK_PLL1_i : std_logic := '0';
signal CLK_PLL0_i : std_logic := '0';
signal CLK_Counter	:integer range 0 to 24;
signal CLK_Counter2	:integer range 0 to 24;
signal shiftreg : std_logic_vector(25-1 downto 0);     
signal shiftreg2 : std_logic_vector(50-1 downto 0);     
signal shiftreg2_index	:integer range 0 to 49;

BEGIN



CLK1Shift <= ENABLE and shiftreg2(shiftreg2_index);

CLK1M  <= CLK_PLL1_i;
CLKxM <= CLK_PLL0_i;

CLK1 <= CLK1_i;
CLK2 <= CLK2_i;
CLK2_i <= shiftreg(24) and ENABLE;
shiftreg2_index <= to_integer(unsigned(SHIFT_INDEX));

myPLLblock: MyPLL
port map
(
		refclk   =>	CLK,
		rst      =>	not(RST),
		outclk_0 => CLK_PLL0_i,
		outclk_1 =>  CLK_PLL1_i
);

CLKdiv : PROCESS(RST,CLK)                                        
                          
BEGIN                                                         
if (RST = '0') then

	CLK_Counter <= 0;
	CLK1_i <= '0';


elsif((CLK ='1') and CLK'event ) then --clock is rising edge
	if(ENABLE = '1') then

		if (CLK_Counter = CLK1Precision) then 
			CLK1_i <= not(CLK1_i); 
			CLK_Counter <= 0;
		else 	
			CLK_Counter <= CLK_Counter + 1;
		end if;


	end if;
end if;

END PROCESS ;



--CLK2div : PROCESS(RST,CLK)                                        
                          
--BEGIN                                                         
--if (RST = '0') then

--	CLK_Counter2 <= 0;

--	CLK2_i <= '0';

--elsif((CLK ='1') and CLK'event  ) then --clock is rising edge
--	if(ENABLE = '1') then
--
--		if ((CLK_Counter2 = CLK2Precision)) then 
--			CLK2_i <= not(CLK2_i); 
--			CLK_Counter2 <= 0;
--		else 	
--			CLK_Counter2 <= CLK_Counter2 + 1;
--		end if;
--
--	end if;
--end if;

--END PROCESS ;

CLK2div : PROCESS(RST,CLK)       -- Shifting technique is used to generate the 2 MHz clock                                 
                          
BEGIN                                                         
if (RST = '0') then
  	shiftreg <= "1111111111110000000000000";
  	shiftreg2 <= "11111111111111111111111110000000000000000000000000";

elsif((CLK ='1') and CLK'event ) then --clock is rising edge
	if(ENABLE = '1') then

			  shiftreg(24 downto 1) <= shiftreg(23 downto 0);		  
			  shiftreg(0) <= shiftreg(24);
			  shiftreg2(49 downto 1) <= shiftreg2(48 downto 0);		  
			  shiftreg2(0) <= shiftreg2(49);
			  


	end if;
end if;

END PROCESS ;


end CLKDivider_arch;