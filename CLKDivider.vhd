

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

BEGIN


CLK1M  <= CLK_PLL1_i;
CLKxM <= CLK_PLL0_i;

myPLLblock: MyPLL
port map
(
		refclk   =>	CLK,
		rst      =>	not(RST),
		outclk_0 => CLK_PLL0_i,
		outclk_1 =>  CLK_PLL1_i
);


end CLKDivider_arch;