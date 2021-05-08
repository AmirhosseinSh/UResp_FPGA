
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module US_FPGA(

	//////////// ADC //////////
	output		          		ADC_CONVST,
	output		          		ADC_SCK,
	output		          		ADC_SDI,
	input 		          		ADC_SDO,

	//////////// ARDUINO //////////
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,
	
	//////////// CLOCK //////////
	input 		          		FPGA_CLK1_50,
	input 		          		FPGA_CLK2_50,
	input 		          		FPGA_CLK3_50,
	
	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// SW //////////
	input 		     [3:0]		SW,

	//////////// GPIO_0, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_1
);



//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================



// Amir work:

	USController (
			.CLK 				(FPGA_CLK1_50),
			.RST 				(KEY[0]),
			.CLK_OUT			(GPIO_1[34]),
			.CLK_OUT22		(GPIO_0[34]),
			.CLK_OUTxM		(GPIO_0[33]),
			.PCLK				(GPIO_1[17]),
			.NCLK				(GPIO_1[16]),
			.BTN1				(KEY[0]), 		
			.BTN2				(KEY[1]), 			
			.KEY0 			(SW[0]),		
			.KEY1 			(SW[1]), 		
			.KEY8 			(SW[2]), 		
			.KEY9 			(SW[3]), 		
			.OUT1Push 		(GPIO_1[30]),
			.OUT1RxEnv 		(GPIO_1[32]),	
			//.MODE[0]			(GPIO_1[19]),		
			//.MODE[1]			(GPIO_1[18]),		
			.MODE				({GPIO_1[18],GPIO_1[19]}),		
			.OUT1P   		(GPIO_1[0]),		
			.OUT1N   		(GPIO_1[1]),		
			.OUT2P   		(GPIO_1[2]),		
			.OUT2N  	 		(GPIO_1[3]),	
			.OUT3P  	 		(GPIO_1[4]),	
			.OUT3N  	 		(GPIO_1[5]),	
			.OUT4P  	 		(GPIO_1[6]),	
			.OUT4N  	 		(GPIO_1[7]),	
			.DAC_VAL			({GPIO_1[21],GPIO_1[23],GPIO_1[25],GPIO_1[27],GPIO_1[29],GPIO_1[31],GPIO_1[33],GPIO_1[35]}),	
			.DAC_WR 	 		(GPIO_1[20]),	
			.DAC_AB 	 		(GPIO_1[22]),
			.LED0				(LED[0]),
			.LED1				(LED[1]),
			.LED2				(LED[2])
				
	);



endmodule
