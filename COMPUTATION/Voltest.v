module Voltest(input dummy);
reg CLK;
reg RSTB;

reg [11:0] DATA_IN;
reg [11:0] TRIG;
wire [31:0] max_vol;
wire [31:0] min_vol;
wire [31:0] mean_vol;
wire [31:0] Vp2p_vol_t;
wire [23:0] frequency;


function_block test(.CLK(CLK), .RSTB(RSTB), .DATA_IN(DATA_IN), TRIG(TRIG),.frequency(frequency),.Vp2p_vol_t(Vp2p_vol_t), .max_vol(max_vol), .min_vol(min_vol), .mean_vol(mean_vol));
initial 
	begin
	CLK = 0;
	RSTB = 1;
	DATA_IN = 0;
	TRIG=12'd1002;
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
	DATA_IN <= 12'd1000;
	#200;
	DATA_IN <= 12'd1002;
	#200;
	DATA_IN <= 12'd1004;
	#200;
	DATA_IN <= 12'd1006;
	#200;
	DATA_IN <= 12'd1008;
	#200;
	DATA_IN <= 12'd1010;
	#200;
	DATA_IN <= 12'd1012;
	#200;
	DATA_IN <= 12'd1010;
	#200;
	DATA_IN <= 12'd1008;
	#200;
	DATA_IN <= 12'd1006;
	#200;
	DATA_IN <= 12'd1004;
	#200;
	DATA_IN <= 12'd1002;
	
	end
	

endmodule
