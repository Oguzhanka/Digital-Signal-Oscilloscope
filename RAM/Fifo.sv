module Fifo(
clock,
ADC_CLK,
VGA_CLK,
data_in,
//trigger,
fifo_full,
reset,
xaxis,
PERIOD_FLAG,
waveform,
VGA_out
//VGA_screen_print
);//640 12
parameter FIFO_SIZE = 10'd640;
input PERIOD_FLAG;
input waveform;
input clock;
input ADC_CLK;
input VGA_CLK;
input [12:0]data_in;
//reg [12:0]data_in = 12'd500;
input reset;
//input [12:0]trigger;
//output wire [9:0]Trigger_print; // for auto scale trigger will be equal to mean
input [9:0]xaxis;
output reg  [11:0]VGA_out;
output reg  fifo_full;
reg [639:0][11:0] Data_store;//[120:0]
//reg [9:0]input_counter;
//reg [11:0]buffer;
//reg empty_fifo;
//reg [9:0]Vga_counter;
reg [1:0]STATE;
//reg [12:0]Hz_counter;
//reg [11:0]data_out;
reg [9:0]counter;
//output wire [ 7:0]VGA_screen_print;
wire [0:0][11:0]buffer;
assign buffer[0] = data_in;
initial
	begin
	Data_store = 0;
	//data_out = 0;
	VGA_out = 0;
	STATE = 0;
	//Hz_counter = 1;
	counter = 0;
	end
assign VGA_screen_print = VGA_out[11:4];	
always @(posedge ADC_CLK) //writing data
begin
	if (reset)
		begin
		Data_store <= 0;
		//data_out <= 0;
		end
	else begin
		case (STATE)
			2'b00:begin // wait for trigger
					 if(PERIOD_FLAG)begin
						STATE <= 2'b01;
						fifo_full <= 1'b0;
						end
					else 
						STATE <= 2'b00;
			end
			2'b01:begin // trigger comes
					if(counter == 10'd640)begin
						counter <= 0;
						fifo_full <= 1'b1;
						STATE <= 2'b10;
					end
					else begin
						//data_out <= Data_store[120];
						Data_store[639:0]<={Data_store[638:0],buffer[0]};
						counter <= counter + 1 ;
						STATE <= 2'b01;
					end
			end	
			2'b10:begin// FİFO FULL 
				STATE <= 2'b00;
			end
			2'b11:begin // wait for delay
				STATE <= 2'b00;
			end
			endcase
	end	
end

always @(posedge VGA_CLK)begin
	if (reset)begin
	VGA_out <= 0;
		end
	else if (waveform) begin
		VGA_out <= Data_store[xaxis];
		end
	else begin
		VGA_out <= 12'b0;
		end
	end
	
endmodule
	