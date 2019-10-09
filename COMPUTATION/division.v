module division(input CLK, input RSTB, input [31:0]DATA_IN, output reg [19:0]DATA_OUT, output reg ready);

wire [31:0]result1;
wire [31:0]result2;
wire [31:0]result3;
wire [31:0]result4;
wire [31:0]result5;
wire [31:0]remainder1;
wire [31:0]remainder2;
wire [31:0]remainder3;
wire [31:0]remainder4;
wire [31:0]remainder5;
wire VALID_1, VALID_2, VALID_3, VALID_4, VALID_5;

wire [31:0]div1;
wire [31:0]div2;
wire [31:0]div3;
wire [31:0]div4;
wire [31:0]div5;

assign div1=32'd820;
assign div2=32'd820;
assign div3=32'd820;
assign div4=32'd820;
assign div5=32'd820;

reg [3:0]dig1;
reg [3:0]dig2;
reg [3:0]dig3;
reg [3:0]dig4;
reg [3:0]dig5;

reg [2:0]counter;

divider digit1(result1,remainder1,VALID_1, DATA_IN, div1, CLK);
divider digit2(result2,remainder2,VALID_2, (remainder1*12'd10), div2, CLK);
divider digit3(result3,remainder3,VALID_3, (remainder2*12'd100), div3, CLK);
divider digit4(result4,remainder4,VALID_4, (remainder3*12'd1000), div4, CLK);
divider digit5(result5,remainder5,VALID_5, (remainder4*12'd10000), div5, CLK);


always @(posedge CLK)begin
	if(~RSTB)begin
	end
	
	else begin
		if(VALID_1)begin
			ready<=0;
			dig1<=result1[3:0];
			counter<=counter+1;
			end
			
		if(VALID_2)begin
			ready<=0;
			dig2<=result2[3:0];
			counter<=counter+1;
			end
			
		if(VALID_3)begin
			ready<=0;
			if(result3[3:0]>4'd9)begin
				dig3<=(result3[3:0]+4'd6);
				end	
			else begin
				dig3<=result3[3:0];
				end
			counter<=counter+1;
			end
			
		if(VALID_4)begin
			ready<=0;
			if(result4[3:0]>4'd9)begin
				dig4<=(result4[3:0]+4'd6);
				end	
			else begin
				dig4<=result4[3:0];
				end
			counter<=counter+1;
			end
		
		if(VALID_5)begin
			ready<=0;
			if(result5[3:0]>4'd9)begin
				dig5<=(result5[3:0]+4'd6);
				end	
			else begin
				dig5<=result5[3:0];
				end
			counter<=counter+1;
			end
			
		if(counter==3'd5)begin
			ready<=1;
			DATA_OUT<={dig1, dig2, dig3, dig4, dig5};
			counter<=3'd0;
			end
		end
		
	end
	
endmodule
			