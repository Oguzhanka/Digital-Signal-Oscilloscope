module voltage_block(CLK, RSTB, MEAN_FLAG, DATA_IN, max_vol, min_vol, mean_vol1, mean_vol2);


input CLK;		//Main device clock
input RSTB;		//Block reset control
input MEAN_FLAG;
input [11:0] DATA_IN;	//Design specification, 10V/20mV=500 data points
								//can be encoded with minimum 9- bits[0, 512]

output reg [31:0] max_vol;
output reg [31:0] min_vol;
output reg [31:0] mean_vol1;
output reg [31:0] mean_vol2;


reg [31:0]sum;
reg [31:0]sum2;
reg [31:0]min_vol_t;
reg [12:0]counter;
reg counter_flag;

reg [31:0]max_t;
reg [31:0]min_t;

wire [31:0]square;

assign square = (DATA_IN[11:0]*DATA_IN[11:0]);

initial begin
	max_vol = 32'd0;
	min_vol_t = 32'd2048;
	mean_vol1= 32'd0;
	sum = 32'd0;
	end

//Max and min calculation of the sequence

always @(posedge CLK)begin

	if(~RSTB)begin
		max_t  <= 32'd0;
		min_t  <= 32'd2048;
		end
		
	else begin
			if(MEAN_FLAG)begin
				max_t  <= 32'd0;
				min_t  <= 32'd2048;				
				end
				
			if(DATA_IN>max_t) begin
				max_t<=DATA_IN;
				end
				
			else if(DATA_IN<min_t) begin
				min_t<=DATA_IN;
				end
				
			else begin
				end
		end
	end
	

always @(posedge CLK)begin
	if(~RSTB)begin
		mean_vol1<= 32'd0;
		mean_vol2<=32'd0;
		sum <=32'd0;
		sum2<=32'd0;
		end
		
	else begin
			if(MEAN_FLAG)begin
				mean_vol1 <= sum;
				mean_vol2 <= sum2;
				sum <= 32'd0;
				end
		
			else begin
				sum <= sum + {8'd0, DATA_IN};
				sum2<= (sum2+ square); 
				end
		end
	end
	

always @(posedge CLK)begin
	if(~RSTB)begin
		min_vol<=32'd4095;
		max_vol<=32'd0;
		end
		
	else begin
		if(MEAN_FLAG)begin
			min_vol<=min_t;
			max_vol<=max_t;
			end
		else begin
			min_vol<=min_vol;
			max_vol<=max_vol;			
			end
		end
	end
	
	
	
endmodule
