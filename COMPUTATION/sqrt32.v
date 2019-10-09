module sqrt32(clk, rdy, reset, x, .y(acc));
   input  clk;
   output rdy;
   input  reset;

   input [31:0] x;
   output [15:0] acc;


   // acc holds the accumulated result, and acc2 is the accumulated
   // square of the accumulated result.
   reg [15:0] acc;
   reg [31:0] acc2;

   // Keep track of which bit I'm working on.
   reg [4:0]  bitl;
   wire [15:0] bit = 1 << bitl;
   wire [31:0] bit2 = 1 << (bitl << 1);

   // The output is ready when the bitl counter underflows.
   wire rdy = (bitl[4] & bitl[3] & bitl[2] & bitl[1] & bitl[0]);

   wire [15:0] guess  = acc | bit;
   wire [31:0] guess2 = acc2 + bit2 + ((acc << bitl) << 1);

   task clear;
      begin
	 acc = 0;
	 acc2 = 0;
	 bitl = 15;
      end
   endtask

   initial clear;

   always @(posedge clk)
      if (reset)
       clear;
      else begin
	 if (guess2 <= x) begin
	    acc  <= guess;
	    acc2 <= guess2;
	 end
	 bitl <= bitl - 1;
      end

endmodule
