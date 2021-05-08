
library ieee; --allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lpm;  
USE lpm.lpm_components.all; --this library includes 32-bit adder


entity DeBouncer is
port (	
    	CLK 		: in std_logic;		-- Clock 50 MHZ
	RST 		: in std_logic;
	DIN 		: in std_logic;
	DOUT		: out std_logic	
);
end debouncer;



architecture debouncer_arch of debouncer is
                
signal INPUT : std_logic;
signal OUTPUT : std_logic := '0';
signal HOLD :  std_logic :='0' ; --different from a Signal, it's a private register

BEGIN

INPUT <= DIN;                   
DOUT <= OUTPUT;   




PulseGen : PROCESS(CLK)  --means this process works with the clock                                            

variable counter : integer := 0; -- an approximation to 50MHz, which is counting to 2^24 (200ms)                                   
BEGIN                                                         
  
  if((CLK ='1') and CLK'event) then --clock is rising edge
    
    if ((INPUT = '1') and HOLD = '0') then
        OUTPUT <= '1';
        HOLD <= '1';
        
        elsif  (HOLD = '1') then
         counter := counter + 1; 
         OUTPUT <= '0';
          

    end if;

    if (counter = 160000) then -- in testbench, set counter to 2
      HOLD <= '0';
      counter := 0;
      end if;

  --else
    --OUTPUT <= '0';

  end if;                                                       
END PROCESS PulseGen;    

end debouncer_arch;             