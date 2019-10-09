module ADCmodule (
	clock,
	reset,
	//reset,       // clock (50MHz) and reset
	ADC_CS_N,       // ADC chip selection
	ADC_DIN,          // ADC serial data in (to ADC)
	ADC_SCLK,         // ADC serial clock
	ADC_DOUT,
	Leds,
	ADC_CLK,
	Readed_data1,
	//Readed_data2
);

input clock;
input reset ;
reg [9:0]counter ; // ADC clk counter 67 posedge one valid output . 2 channel 134 cycle wait time for refreshing output data.
output ADC_SCLK;

input ADC_DOUT;
output ADC_DIN; 
output ADC_CS_N;

output reg [4:0] Leds;
//output reg [11:0] Readed_data2;
output reg [11:0] Readed_data1;

output reg ADC_CLK ;
wire [7:0][11:0]Data;
initial 
begin
	//Readed_data2 = 0;
	Readed_data1 = 0;
	ADC_CLK = 0 ;
end
ADC set(.clock(clock),.reset(reset),.ADC_CS_N(ADC_CS_N),.ADC_DIN(ADC_DIN),.ADC_DOUT(ADC_DOUT),.ADC_SCLK(ADC_SCLK),.data(Data));
always @(posedge clock)begin
	if(counter >= 10'd536) begin// refresh with new data
		Readed_data1 <= Data[0];
		//Readed_data2 <= Data[1];
		counter <= 0;
		ADC_CLK <= 1'b1;
		Leds <= Readed_data1[11:7];
		end
	else begin
	counter <= counter + 1 ;
	ADC_CLK <= 1'b0;
	
	
	end
		
end
endmodule
