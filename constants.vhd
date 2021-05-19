
package CONSTANTS is


constant T_PRF : integer := 44000+1;	-- 40000 is 50Hz sampling, 20000 is 100Hz.
constant T_ON  : integer := 6;
constant T_CLAMP  : integer := 4;
constant T_DAMP  : integer := 4;
constant T_RX : integer := 400;
constant T_OFF : integer := T_PRF;
--constant T_OFF : integer := T_PRF - T_ON - T_CLAMP - T_DAMP;


end CONSTANTS;