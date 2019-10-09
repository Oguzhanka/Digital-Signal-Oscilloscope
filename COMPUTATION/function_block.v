module function_block(input CLK, input RSTB, input [11:0]DATA_IN, input [11:0]TRIG,
							 output wire [23:0]frequency, output wire [19:0]max_t, output wire [19:0]min_t, output wire [19:0]mean_t,
							 output wire [19:0]Vp2p_vol_t,output wire PERIOD_FLAG, output wire [19:0]mean_t2,output wire [31:0]min_vol,output wire [31:0]max_vol,output wire [31:0]mean_vol );

wire [24:0]PERIOD1;
wire [24:0]PERIOD2;

wire [19:0]max;
wire [19:0]min;
wire [19:0]mean;
wire [19:0]mean2;
wire [19:0]Vp2p_vol;

reg [19:0]max_k;
reg [19:0]min_k;
reg [19:0]mean_k;
reg [19:0]mean_k2;
reg [19:0]Vp2p_vol_k;
reg [31:0]FREQ_BIN;

time_block time1(CLK, RSTB, DATA_IN, TRIG, PERIOD1, PERIOD2, PERIOD_FLAG);

assign max_t=max_k;
assign min_t=min_k;
assign mean_t=mean_k;
assign mean_t2=mean_k2;
assign Vp2p_vol_t=Vp2p_vol_k;

//wire [31:0]max_vol;
//wire [31:0]min_vol;
wire [31:0]sum;
wire [31:0]sum2;

voltage_block voltage1(.CLK(CLK), .RSTB(RSTB), .MEAN_FLAG(PERIOD_FLAG), .DATA_IN(DATA_IN), .max_vol(max_vol), .min_vol(min_vol), .mean_vol1(sum), .mean_vol2(sum2));


wire VALID_1;
wire [31:0]freq_bin;
wire [31:0]remainder1;

divider freq(freq_bin,remainder1,VALID_1,32'd93284,{7'd0, PERIOD2},CLK);

wire VALID_2;
wire VALID_3;
//wire [31:0]mean_vol;
wire [31:0]mean_vol2;

divider volt1(mean_vol, remainder2, VALID_2, sum, PERIOD2, CLK);
divider volt2(mean_vol2, remainder3, VALID_3, sum2, PERIOD2, CLK);

reg [31:0]mean2_sqrt_k;
wire [31:0]mean2_sqrt;
wire rdy;

sqrt32 sqrt(CLK, rdy, ~RSTB, sum2, mean2_sqrt);


wire ready1;
wire ready2;
wire ready3;
wire ready4;
wire ready5;
wire [31:0]Vp2p;
assign Vp2p_vol=(max_vol-min_vol);


division b_to_d1(CLK, RSTB, max_vol, max, ready1);
division b_to_d2(CLK, RSTB, min_vol, min, ready2);
division b_to_d3(CLK, RSTB, mean_vol, mean, ready3);
division b_to_d8(CLK, RSTB, mean2_sqrt_k, mean2, ready4);
division b_to_d9(CLK, RSTB, Vp2p_vol, Vp2p, ready5);

reg buffer_1;

Binary2Decimal b_to_d5(.wait_measure_done(0), .bindata(FREQ_BIN), .run_stop(0),.decimalout(frequency));

always @(posedge CLK)begin
	buffer_1<= VALID_1;
	if (VALID_1)begin
		FREQ_BIN <= freq_bin;
		end
	end


always @* begin
	if(ready4)begin
		mean_k2<= mean2;
		end
	if(ready3)begin
		mean_k<= mean;
		end
	if(ready2)begin
		min_k<= min;
		end
	if(ready1)begin
		max_k<= max;
		end
	if(ready5)begin
		Vp2p_vol_k<= Vp2p;
		end
	end
	
always @* begin
	if(rdy)begin
		mean2_sqrt_k<=mean2_sqrt;
		end
	end

endmodule
//module function_block(input CLK, input RSTB, input [11:0]DATA_IN, input [11:0]TRIG,
//							 output wire [23:0]frequency_t, output wire [19:0]max_t, output wire [19:0]min_t, output wire [19:0]mean_t,
//							 output wire [19:0]Vp2p_vol_t,output wire PERIOD_FLAG, output wire [19:0]mean_t2);
//
//wire [24:0]PERIOD1;
//wire [24:0]PERIOD2;
////wire PERIOD_FLAG;
//
//wire [23:0]frequency;
//wire [19:0]max;
//wire [19:0]min;
//wire [19:0]mean;
//wire [19:0]Vp2p_vol;
//
//reg [23:0]frequency_k;
//reg [19:0]max_k;
//reg [19:0]min_k;
//reg [19:0]mean_k;
//reg [19:0]mean_k2;
//reg [19:0]Vp2p_vol_k;
//
//time_block time1(CLK, RSTB, DATA_IN, TRIG, PERIOD1, PERIOD2, PERIOD_FLAG);
//
//assign frequency_t = frequency_k;
//assign max_t =  max_k;
//assign min_t = min_k;
//assign mean_t =mean_k;
//assign mean_t2 =mean_k2;
//
//wire [31:0]max_vol;
//wire [31:0]min_vol;
//wire [31:0]sum;
//wire [31:0]mean_vol2;
//reg [31:0]FREQ_BIN;
//voltage_block voltage1(.CLK(CLK), .RSTB(RSTB), .MEAN_FLAG(PERIOD_FLAG), .DATA_IN(DATA_IN), .max_vol(max_vol), .min_vol(min_vol), .mean_vol1(sum), .mean_vol2(sum2));
//
//
//wire VALID_1;
//wire [31:0]freq_bin;
//wire [31:0]remainder1;
//
//divider freq(freq_bin,remainder1,VALID_1,32'd93284,{7'd0, PERIOD2},CLK);
//
//wire VALID_2;
//wire [31:0]mean_vol;
////wire [31:0]mean_vol2;
//
//divider volt(mean_vol, remainder2, VALID_2, sum, PERIOD2, CLK);
////divider volt(mean_vol2, remainder2, VALID_2, sum2, PERIOD2, CLK);
//
//
//
//
//wire ready1;
//wire ready2;
//wire ready3;
//wire ready4;
//wire [31:0]Vp2p;
//assign Vp2p=(max_vol-min_vol);
//reg buffer_1,buffer_2;
//
//
//division b_to_d1(CLK, RSTB, max_vol, max, ready1);
//division b_to_d2(CLK, RSTB, min_vol, min, ready2);
//division b_to_d3(CLK, RSTB, mean_vol, mean, ready3);
//division b_to_d8(CLK, RSTB, mean_vol2, mean2, ready4);
//
//
//Binary2Decimal5 b_to_d4(.wait_measure_done(0), .bindata(Vp2p), .run_stop(0),.decimalout(Vp2p_vol_t));
////binary_to_bcd2 b_to_d5(CLK, 1, VALID_1, buffer_1, FREQ_BIN, frequency, freq_ready);
//Binary2Decimal b_to_d5(.wait_measure_done(0), .bindata(FREQ_BIN), .run_stop(0),.decimalout(frequency));
//always @(posedge CLK)
//begin
//	buffer_1<= VALID_1;
//	if (VALID_1)
//		FREQ_BIN <= freq_bin;
//end
//always @*
//	if (ready4||ready3||ready2||ready1)
//	begin
//		min_k <= min;
//		max_k <=  max;
//		mean_k <= mean;
//		mean_k2<= mean2;
//		Vp2p_vol_k <=Vp2p_vol;
//		frequency_k <= frequency;
//	end
//		
//		
//		
//		
//endmodule

