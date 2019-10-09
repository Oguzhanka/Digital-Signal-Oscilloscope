module vga_display_test(input dummy);
reg clock,ADC_CLK,VGA_CLK;
reg [11:0]data_in;
wire fifo_full;
reg reset;
reg [9:0]xaxis;
reg PERIOD_FLAG;
reg waveform;
wire  [11:0]VGA_out;
wire [7:0]Blue;
reg [9:0]yaxis;
reg [11:0]mean;
wire [24:0]DATA_OUT;
reg [2:0]SCALE = 3'd4;
wire [9:0]data_out;
assign data_out = DATA_OUT[9:0];
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
Fifo test(.clock(clock),.ADC_CLK(ADC_CLK),.VGA_CLK(VGA_CLK),
.data_in(data_in),.fifo_full(fifo_full),.reset(reset),
.xaxis(xaxis),.PERIOD_FLAG(PERIOD_FLAG),.waveform(waveform),
.VGA_out(VGA_out));


voltage_scale test_1(.CLK(clock),.VGA_CLK(VGA_CLK),.DATA_IN(VGA_out), .mean(mean), .scale(SCALE),.DATA_OUT(DATA_OUT));
wire [11:0] TRIG;
reg [3:0]button_counter = 4'd8;
assign TRIG={button_counter,8'd0};
assign Blue_1 = waveform&&(( data_out<= (yaxis + 10'd2))&&(data_out >= (yaxis - 10'd2)));
assign Blue = {Blue_1,Blue_1,Blue_1,Blue_1,Blue_1,Blue_1,Blue_1,Blue_1};
initial begin
clock = 0;
ADC_CLK= 0;
VGA_CLK = 0;
PERIOD_FLAG = 0;
data_in = 0;
reset = 0;
xaxis = 0;
yaxis = 0;
waveform = 0;
mean = 10'd500;
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
if (yaxis == 10'd525)
		yaxis <=10'd0;
else
	if(xaxis == 10'd793)
		yaxis <= yaxis +10'd1;
		
if (xaxis == 10'd793)begin
	xaxis <= 10'd0;
	end
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