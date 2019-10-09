module Freqtest(input dummy);
reg CLK;
reg RSTB;

reg [11:0] DATA_IN;
reg [11:0] TRIG;
wire [24:0]PERIOD1;			//DUTY CYCLE ON
wire [24:0]PERIOD2;
wire PERIOD_FLAG;

time_block test(CLK, RSTB, DATA_IN, TRIG, PERIOD1, PERIOD2, PERIOD_FLAG);
initial 
	begin
	CLK = 0;
	RSTB = 1;
	DATA_IN = 0;
	TRIG = 'd10;
	end
always
	begin
	#10;
	CLK = 0;
	#10;
	CLK = 1;
	end
always 
	begin
	#200;
	DATA_IN <= 12'd0;
	#200;
	DATA_IN <= 12'd2;
	#200;
	DATA_IN <= 12'd4;
	#200;
	DATA_IN <= 12'd6;
	#200;
	DATA_IN <= 12'd8;
	#200;
	DATA_IN <= 12'd10;
	#200;
	DATA_IN <= 12'd12;
	#200;
	DATA_IN <= 12'd10;
	#200;
	DATA_IN <= 12'd8;
	#200;
	DATA_IN <= 12'd6;
	#200;
	DATA_IN <= 12'd4;
	#200;
	DATA_IN <= 12'd2;
	
	end
endmodule