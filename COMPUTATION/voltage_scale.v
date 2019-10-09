module voltage_scale(input CLK,input VGA_CLK, input [11:0]DATA_IN, input [11:0]mean, input [2:0]scale,
							output reg [24:0]DATA_OUT, output reg [24:0]MEAN_OUT,input [11:0]TRIG,output reg [24:0]TRIG_OUT);
							
						

always @(posedge CLK)begin
	
	case(scale)
		3'd0: begin
			DATA_OUT <= ((DATA_IN*25'd100000)/25'd1024);
			MEAN_OUT <= ((DATA_IN*25'd100000)/25'd1024);
			TRIG_OUT <=((    TRIG*25'd100   )/25'd1024);
//			DATA_Buffer_0 <=((DATA_IN*10'd1000000)/10'd1024);
//			DATA_OUT =DATA_Buffer_0[9:0];
			end
			
		3'd1: begin
			DATA_OUT <=((DATA_IN*25'd100000)/25'd1024);
			MEAN_OUT <=((DATA_IN*25'd10000 )/25'd1024);
			TRIG_OUT <=(( TRIG*25'd100000  )/25'd1024);
//			DATA_Buffer_1 <=((DATA_IN*10'd100000)/10'd1024);
//			DATA_OUT =DATA_Buffer_1[9:0];
			end
			
		3'd2: begin
			DATA_OUT <=((DATA_IN*25'd10000)/25'd1024);
			MEAN_OUT <=((DATA_IN*25'd10000)/25'd1024);
			TRIG_OUT <=(( TRIG*25'd10000  )/25'd1024);
//			DATA_Buffer_2 <=((DATA_IN*10'd10000)/10'd1024);
//			DATA_OUT =DATA_Buffer_2[9:0];
			end
			
		3'd3: begin
			DATA_OUT <=((DATA_IN*25'd1000)/25'd1024);
			MEAN_OUT <=((DATA_IN*25'd1000)/25'd1024);
			TRIG_OUT <=(( TRIG*25'd1000  )/25'd1024);
//			DATA_Buffer_3 <=((DATA_IN*10'd1000)/10'd1024);
//			DATA_OUT =DATA_Buffer_3[9:0];
			end
			
		3'd4: begin
			DATA_OUT <= ((DATA_IN*25'd100)/25'd1024);
			MEAN_OUT <= ((DATA_IN*25'd100)/25'd1024);
			TRIG_OUT <= (( TRIG*25'd100  )/25'd1024);
//			DATA_Buffer_4 <=((DATA_IN*10'd100)/10'd1024);
//			DATA_OUT =DATA_Buffer_4[9:0];
			end
		default: begin
			DATA_OUT <= ((DATA_IN*25'd100)/25'd1024);
			MEAN_OUT <= ((DATA_IN*25'd100)/25'd1024);
			TRIG_OUT <= ((TRIG*25'd100   )/25'd1024);
//			DATA_Buffer_4 <=((DATA_IN*10'd100)/10'd1024);
//			DATA_OUT = DATA_Buffer_4[9:0];
		end
			
			endcase
		end
endmodule
