module fifo_test(input dummy);
reg clock,ADC_CLK,VGA_CLK;
reg [11:0]data_in;
wire fifo_full;
reg reset;
reg [9:0]xaxis;
reg PERIOD_FLAG;
reg waveform;
wire  [11:0]VGA_out;
//wire [7:0]VGA_screen_print;
reg [9:0]yaxis;
//ADC_CLK,
//VGA_CLK,
//data_in,
//Fifo_Full,
//reset,
//xaxis,
//PERIOD_FLAG,
//waveform,
//VGA_out,
//VGA_screen_print
Fifo test(clock,ADC_CLK,VGA_CLK,data_in,fifo_full,reset,xaxis,PERIOD_FLAG,waveform,VGA_out);
initial begin
clock = 0;
ADC_CLK= 0;
VGA_CLK = 0;
PERIOD_FLAG = 0;
data_in = 0;
reset = 0;
xaxis = 0;
waveform = 0;
end
always begin
#10;
clock <= 0;
#10 ;
clock <= 1;
end
always begin
#100;
ADC_CLK <= 0;
#100 ;
ADC_CLK <= 1;
end
always begin
#20;
VGA_CLK <= 0;
#20 ;
VGA_CLK <= 1;
end
always begin
#2400;
PERIOD_FLAG <= 1;
#100
PERIOD_FLAG <= 1;
end
always @(posedge VGA_CLK) begin
if (xaxis == 10'd793)
	xaxis <= 10'd0;
else 
	xaxis <=xaxis+10'd1;
end
always @(posedge VGA_CLK)begin
if (xaxis > 10'd638)
	waveform <= 0;
else
	waveform <= 1;
end
always begin
#100
data_in <= 12'd1000;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in +12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
#100
data_in <= data_in -12'd40;
end
/*always begin
#10;
#100000;
data_out_request  <= 1;
#1000;
data_out_request <= 0;
end*/
endmodule
