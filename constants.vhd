
package CONSTANTS is

constant PulseLength : integer := (50-1);  -- 1 MHz
-- 49 => 1.020 MHz
-- 48 => 1.041 MHz
-- 47 => 1.063 MHz
-- 46 => 1.087 MHz
-- 45 => 1.111 MHz
-- 44 => 1.136 MHz

constant CLK1Precision:		integer := 24;
		-- 23 => 1.0417 MHz

constant CLK2Precision:		integer := 12;
		-- 12 => 2.0 MHz
		-- 11 => 2.0833 MHz
constant PulseDuty : integer := ((2**25)-1);  -- 1 MHz
constant CLKSourceState_ini : integer := 1;
constant PulseRepet_init : integer := 1;
constant PRF_ini	 : integer := 10000-PulseRepet_init;   --12500 for 25ms , 25000 50ms
constant CLK_ShiftReg_ini : integer :=2730; -- 2730 for CLK/2, 3276 for CLK/4, 3640 for CLK/6

constant T_PRF : integer := 40000+1;	-- 40000 is 50Hz sampling, 20000 is 100Hz.
constant T_ON  : integer := 6;
constant T_CLAMP  : integer := 6;
constant T_DAMP  : integer := 6;
constant T_RX : integer := 350;
constant T_OFF : integer := T_PRF;
--constant T_OFF : integer := T_PRF - T_ON - T_CLAMP - T_DAMP;


end CONSTANTS;