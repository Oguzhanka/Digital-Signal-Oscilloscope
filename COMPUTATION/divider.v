module divider(quotient,remainder,VALID,dividend,divider,CLK);

input  CLK;
input [31:0]  dividend,divider;

output [31:0] quotient,remainder;
output VALID;

reg [31:0]    quotient;
reg [63:0]    dividend_copy, divider_copy, diff;
reg [6:0]     bit;

wire          VALID=!bit;
wire [31:0]   remainder = dividend_copy[31:0];

initial bit = 0;

always @(posedge CLK)

	if(VALID) begin

     bit = 32;
     quotient = 0;
     dividend_copy = {32'd0,dividend};
     divider_copy = {1'b0,divider,31'd0};
	  end
	  else begin

        diff = dividend_copy - divider_copy;
        quotient = { quotient[30:0], ~diff[63] };
        divider_copy = { 1'b0, divider_copy[63:1] };
        if ( !diff[63] ) dividend_copy = diff;
        bit = bit - 1;

        end

endmodule
