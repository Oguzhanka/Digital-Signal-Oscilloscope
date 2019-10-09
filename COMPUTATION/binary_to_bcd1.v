module binary_to_bcd1 (
  clk_i,
  ce_i,
  rst_i,
  start_i,
  dat_binary_i,
  dat_bcd_o,
  done_o
  );
parameter BITS_IN_PP         = 32; // # of bits of binary input
parameter BCD_DIGITS_OUT_PP  = 5;  // # of digits of BCD output
parameter BIT_COUNT_WIDTH_PP = 16;  // Width of bit counter

// I/O declarations
input  clk_i;                      // clock signal
input  ce_i;                       // clock enable input
input  rst_i;                      // synchronous reset
input  start_i;                    // initiates a conversion
input  [BITS_IN_PP-1:0] dat_binary_i;        // input bus
output [4*BCD_DIGITS_OUT_PP-1:0] dat_bcd_o;  // output bus
output done_o;                     // indicates conversion is done

reg [4*BCD_DIGITS_OUT_PP-1:0] dat_bcd_o;

// Internal signal declarations

reg  [BITS_IN_PP-1:0] bin_reg;
reg  [4*BCD_DIGITS_OUT_PP-1:0] bcd_reg;
wire [BITS_IN_PP-1:0] bin_next;
reg  [4*BCD_DIGITS_OUT_PP-1:0] bcd_next;
reg  busy_bit;
reg  [BIT_COUNT_WIDTH_PP-1:0] bit_count;
wire bit_count_done;

//--------------------------------------------------------------------------
// Functions & Tasks
//--------------------------------------------------------------------------

function [4*BCD_DIGITS_OUT_PP-1:0] bcd_asl;
  input [4*BCD_DIGITS_OUT_PP-1:0] din;
  input newbit;
  integer k;
  reg cin;
  reg [3:0] digit;
  reg [3:0] digit_less;
  begin
    cin = newbit;
    for (k=0; k<BCD_DIGITS_OUT_PP; k=k+1)
    begin
      digit[3] = din[4*k+3];
      digit[2] = din[4*k+2];
      digit[1] = din[4*k+1];
      digit[0] = din[4*k];
      digit_less = digit - 5;
      if (digit > 4'b0100)
      begin
        bcd_asl[4*k+3] = digit_less[2];
        bcd_asl[4*k+2] = digit_less[1];
        bcd_asl[4*k+1] = digit_less[0];
        bcd_asl[4*k+0] = cin;
        cin = 1'b1;
      end
      else
      begin
        bcd_asl[4*k+3] = digit[2];
        bcd_asl[4*k+2] = digit[1];
        bcd_asl[4*k+1] = digit[0];
        bcd_asl[4*k+0] = cin;
        cin = 1'b0;
      end

    end // end of for loop
  end
endfunction

//--------------------------------------------------------------------------
// Module code
//--------------------------------------------------------------------------

// Perform proper shifting, binary ASL and BCD ASL
assign bin_next = {bin_reg,1'b0};
always @(bcd_reg or bin_reg)
begin
  bcd_next <= bcd_asl(bcd_reg,bin_reg[BITS_IN_PP-1]);
end

// Busy bit, input and output registers
always @(posedge clk_i)
begin
  if (rst_i)
  begin
    busy_bit <= 0;  // Synchronous reset
    dat_bcd_o <= 0;
  end
  else if (start_i && ~busy_bit)
  begin
    busy_bit <= 1;
    bin_reg <= dat_binary_i;
    bcd_reg <= 0;
  end
  else if (busy_bit && ce_i && bit_count_done && ~start_i)
  begin
    busy_bit <= 0;
    dat_bcd_o <= bcd_next;
  end
  else if (busy_bit && ce_i && ~bit_count_done)
  begin
    bcd_reg <= bcd_next;
    bin_reg <= bin_next;
  end
end
assign done_o = ~busy_bit;

// Bit counter
always @(posedge clk_i)
begin
  if (~busy_bit) bit_count <= 0;
  else if (ce_i && ~bit_count_done) bit_count <= bit_count + 1;
end
assign bit_count_done = (bit_count == (BITS_IN_PP-1));

endmodule

