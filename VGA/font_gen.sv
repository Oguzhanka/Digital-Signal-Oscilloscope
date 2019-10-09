module font_gen
   (
    clock,
	 max, min, mea, p2p, rms, frq,
	 vol, time1,
	 mode,
    pixel_x, pixel_y,
    rgb_text
   );
	 input wire clock;
	 input wire [23:0] frq ;
	 input wire [19:0]max, min, mea, p2p, rms; 
	 input wire [15:0]vol, time1 ;
	 input wire mode;
    input wire [9:0] pixel_x, pixel_y;
    output reg [7:0] rgb_text;
	 /*reg [23:0] frq ;
	 reg [19:0] reg_max, reg_min, mea, p2p, rms; 
	 reg [15:0] vol, time1 ;
	 reg reg_mode;*/
	 
	 wire [10:0] rom_addr;
	 wire [6:0] char_addr;
	 reg [3:0] row_addr;
	 reg [2:0] bit_addr;
	 wire [7:0] font_word;
	 //wire [7:0] rule_rom_addr;
   // max signal
   wire [10:0] rom_addr_mx;
   reg  [6:0] char_addr_mx;
   wire [3:0] row_addr_mx;
   wire [2:0] bit_addr_mx;
	wire mx_on;

	// min signal
   wire [10:0] rom_addr_mn;
   reg  [6:0] char_addr_mn;
   wire [3:0] row_addr_mn;
   wire [2:0] bit_addr_mn;
	wire mn_on;	
	
	// mean signal
   wire [10:0] rom_addr_me;
   reg  [6:0] char_addr_me;
   wire [3:0] row_addr_me;
   wire [2:0] bit_addr_me;
	wire me_on;
	
	
	// peak-peak signal
   wire [10:0] rom_addr_p2p;
   reg  [6:0] char_addr_p2p;
   wire [3:0] row_addr_p2p;
   wire [2:0] bit_addr_p2p;
	wire p2p_on;
	
	
	// rms signal
   wire [10:0] rom_addr_rms;
   reg  [6:0] char_addr_rms;
   wire [3:0] row_addr_rms;
   wire [2:0] bit_addr_rms;
	wire rms_on;
	
	// Frequency1
   wire [10:0] rom_addr_frq;
   reg  [6:0] char_addr_frq;
   wire [3:0] row_addr_frq;
   wire [2:0] bit_addr_frq;
	wire frq_on;

	// voltage scaling
   wire [10:0] rom_addr_vol;
   reg  [6:0] char_addr_vol;
   wire [3:0] row_addr_vol;
   wire [2:0] bit_addr_vol;
	wire vol_on;
	
	// time_scale
   wire [10:0] rom_addr_time;
   reg  [6:0] char_addr_time;
   wire [3:0] row_addr_time;
   wire [2:0] bit_addr_time;
	wire time_on;

	// signal mode
   wire [10:0] rom_addr_mode;
   reg  [6:0] char_addr_mode;
   wire [3:0] row_addr_mode;
   wire [2:0] bit_addr_mode;
	wire mode_on;	
	
	// text
   wire [10:0] rom_addr_text;
   reg [6:0] char_addr_text;
   wire [3:0] row_addr_text;
   wire [2:0] bit_addr_text;
	wire text_on;
	
/*initial begin
	//[19:0]
	reg_max = {4'd0,4'd1,4'd2,4'd3};
	reg_min = {4'd4,4'd5,4'd6,4'd7};
	mea = {4'd8,4'd9,4'd2,4'd1};
	p2p = {4'd4,4'd5,4'd6,4'd7};
	rms = {4'd4,4'd5,4'd6,4'd7};
	frq = {4'd4,4'd4,4'd5,4'd6,4'd7};
	//[15:0]
	vol = {4'd4,4'd5,4'd6};
	time1 = {4'd4,4'd5,4'd6};
	// mode
	reg_mode = 1'b1;
	end*/

   // body
   // instantiate font ROM
   font_rom font_unit
      (.clk(clock), .addr(rom_addr), .data(font_word));
		
	
   //-------------------------------------------
   // max region
   //  - display max voltage
   //-------------------------------------------
   assign mx_on = ((10'd415<pixel_y)&&(pixel_y<10'd432)) && ((pixel_x>10'd0)&&(pixel_x<10'd120));
   assign row_addr_mx = pixel_y[3:0];
   assign bit_addr_mx = pixel_x[2:0];
	assign rom_addr_mx = {char_addr_mx, row_addr_mx};
   always @*
      case (pixel_x[6:3])
         4'h0: char_addr_mx = 7'h56; // V
         4'h1: char_addr_mx = 7'h6d; // m
         4'h2: char_addr_mx = 7'h61; // a
         4'h3: char_addr_mx = 7'h78; // x
         4'h4: char_addr_mx = 7'h3d; // =
         4'h5: char_addr_mx = (7'd48 + max[19:16]); // digit 10
         4'h6: char_addr_mx = 7'h2e; // .
         4'h7: char_addr_mx = (7'd48 + max[15:12]); // digit 10
         4'h8: char_addr_mx = (7'd48 +  max[11:8]); // digit 10
         4'h9: char_addr_mx = (7'd48 +  max[7:4]); // digit 10
         4'ha: char_addr_mx = (7'd48 +  max[3:0]); // digit 10
         4'hb: char_addr_mx = 7'h00; // 
         4'hc: char_addr_mx = 7'h56; // V
         4'hd: char_addr_mx = 7'h00; // 
         4'he: char_addr_mx = 7'h00; // 
         4'hf: char_addr_mx = 7'h00; // 
      endcase
		
   //-------------------------------------------
   // min region
   //  - display min voltage
   //-------------------------------------------
   assign mn_on = ((10'd431<pixel_y)&&(pixel_y<10'd448)) && ((pixel_x>10'd0)&&(pixel_x<10'd120));
   assign row_addr_mn = pixel_y[3:0];
   assign bit_addr_mn = pixel_x[2:0];
	assign rom_addr_mn = {char_addr_mn, row_addr_mn};
   always @*
      case (pixel_x[6:3])
         4'h0: char_addr_mn = 7'h56; // V
         4'h1: char_addr_mn = 7'h6d; // m
         4'h2: char_addr_mn = 7'h69; // i
         4'h3: char_addr_mn = 7'h6e; // n
         4'h4: char_addr_mn = 7'h3d; // =
         4'h5: char_addr_mn = (7'd48 + min[19:16]); // digit 10
         4'h6: char_addr_mn = 7'h2e; // .
         4'h7: char_addr_mn = (7'd48 + min[15:12]); // digit 10
         4'h8: char_addr_mn = (7'd48 + min[11:8]); // digit 10
         4'h9: char_addr_mn = (7'd48 + min[7:4]); // digit 10
         4'ha: char_addr_mn = (7'd48 + min[3:0]); // digit 10
         4'hb: char_addr_mn = 7'h00; // 
         4'hc: char_addr_mn = 7'h56; //  V
         4'hd: char_addr_mn = 7'h00; // 
         4'he: char_addr_mn = 7'h00; // 
         4'hf: char_addr_mn = 7'h00; // 
      endcase
	
   //-------------------------------------------
   // mean region
   //  - display mean voltage
   //-------------------------------------------
   assign me_on = ((10'd447<pixel_y)&&(pixel_y<10'd464)) && ((pixel_x>10'd0)&&(pixel_x<10'd120));
   assign row_addr_me = pixel_y[3:0];
   assign bit_addr_me = pixel_x[2:0];
	assign rom_addr_me = {char_addr_me, row_addr_me};
   always @*
      case (pixel_x[6:3])
         4'h0: char_addr_me = 7'h56; // V
         4'h1: char_addr_me = 7'h6d; // m
         4'h2: char_addr_me = 7'h65; // e
         4'h3: char_addr_me = 7'h61; // a
         4'h4: char_addr_me = 7'h3d; // =
         4'h5: char_addr_me = (7'd48 +  mea[19:16]); // digit 10
         4'h6: char_addr_me = 7'h2e; // .
         4'h7: char_addr_me = (7'd48 +  mea[15:12]); // digit 10
         4'h8: char_addr_me = (7'd48 +  mea[11:8]); // digit 10
         4'h9: char_addr_me = (7'd48 +  mea[7:4]); // digit 10
         4'ha: char_addr_me = (7'd48 +  mea[3:0]); // digit 10
         4'hb: char_addr_me = 7'h00; // 
         4'hc: char_addr_me = 7'h56; // V
         4'hd: char_addr_me = 7'h00; // 
         4'he: char_addr_me = 7'h00; // 
         4'hf: char_addr_me = 7'h00; // 
      endcase
		
   //-------------------------------------------
   // peak-peak region
   //  - display peak-peak voltage
   //-------------------------------------------
   assign p2p_on = ((10'd415<pixel_y)&&(pixel_y<10'd432)) && ((pixel_x>10'd127)&&(pixel_x<10'd256));
   assign row_addr_p2p = pixel_y[3:0];
   assign bit_addr_p2p = pixel_x[2:0];
	assign rom_addr_p2p = {char_addr_p2p, row_addr_p2p};
   always @*
      case (pixel_x[6:3])
         4'h0: char_addr_p2p = 7'h56; // V
         4'h1: char_addr_p2p = 7'h70; // p
         4'h2: char_addr_p2p = 7'h32; // 2
         4'h3: char_addr_p2p = 7'h70; // p
         4'h4: char_addr_p2p = 7'h3d; // =
         4'h5: char_addr_p2p = (7'd48 +  p2p[19:16]); // digit 10
         4'h6: char_addr_p2p = 7'h2e; // .
         4'h7: char_addr_p2p = (7'd48 +  p2p[15:12]); // digit 10
         4'h8: char_addr_p2p = (7'd48 +  p2p[11:8]); // digit 10
         4'h9: char_addr_p2p = (7'd48 +  p2p[7:4]); // digit 10
         4'ha: char_addr_p2p = (7'd48 + p2p[3:0]); // digit 10
         4'hb: char_addr_p2p = 7'h00; // 
         4'hc: char_addr_p2p = 7'h56; // V
         4'hd: char_addr_p2p = 7'h00; // 
         4'he: char_addr_p2p = 7'h00; // 
         4'hf: char_addr_p2p = 7'h00; // 
      endcase
		
   //-------------------------------------------
   // RMS region
   //  - display rms voltage
   //-------------------------------------------
   assign rms_on = ((10'd431<pixel_y)&&(pixel_y<10'd448)) && ((pixel_x>10'd127)&&(pixel_x<10'd256));
   assign row_addr_rms = pixel_y[3:0];
   assign bit_addr_rms = pixel_x[2:0];
	assign rom_addr_rms = {char_addr_rms, row_addr_rms};
   always @*
      case (pixel_x[6:3])
         4'h0: char_addr_rms = 7'h56; // V
         4'h1: char_addr_rms = 7'h72; // r
         4'h2: char_addr_rms = 7'h6d; // m
         4'h3: char_addr_rms = 7'h73; // s
         4'h4: char_addr_rms = 7'h3d; // =
         4'h5: char_addr_rms = (7'd48 +  rms[19:16]); // digit 10
         4'h6: char_addr_rms = 7'h2e; // .
         4'h7: char_addr_rms = (7'd48 +  rms[15:12]); // digit 10
         4'h8: char_addr_rms = (7'd48 +  rms[11:8]); // digit 10
         4'h9: char_addr_rms = (7'd48 +  rms[7:4]); // digit 10
         4'ha: char_addr_rms = (7'd48 +  rms[3:0]); // digit 10
         4'hb: char_addr_rms = 7'h00; // 
         4'hc: char_addr_rms = 7'h56; // V
         4'hd: char_addr_rms = 7'h00; // 
         4'he: char_addr_rms = 7'h00; // 
         4'hf: char_addr_rms = 7'h00; // 
      endcase
	
   //-------------------------------------------
   // Volts/div region
   //  - display scale voltage
   //-------------------------------------------
   assign vol_on = ((10'd447<pixel_y)&&(pixel_y<10'd464)) && ((pixel_x>10'd127)&&(pixel_x<10'd256));
   assign row_addr_vol = pixel_y[3:0];
	assign bit_addr_vol = pixel_x[2:0];
   assign rom_addr_vol = {char_addr_vol, row_addr_vol};
   always @*
      case (pixel_x[6:3])
         4'h0: char_addr_vol = (7'd48 + 7'd0); // digit 10vol[15:12]
         4'h1: char_addr_vol = 7'h2e; // .
         4'h2: char_addr_vol = (7'd48 + 7'd7 ); // digit 10vol[11:8]
         4'h3: char_addr_vol = (7'd48 + 7'd5 ); // digit 10vol[7:4]
         4'h4: char_addr_vol = {3'b011, vol[3:0]}; // digit 10
         4'h5: char_addr_vol = 7'h56; // V
         4'h6: char_addr_vol = 7'h2f; // /
         4'h7: char_addr_vol = 7'h64; // d
         4'h8: char_addr_vol = 7'h69; // i
         4'h9: char_addr_vol = 7'h76; // v
         4'ha: char_addr_vol = 7'h00; //
         4'hb: char_addr_vol = 7'h00; // 
         4'hc: char_addr_vol = 7'h00; // 
         4'hd: char_addr_vol = 7'h00; // 
         4'he: char_addr_vol = 7'h00; // 
         4'hf: char_addr_vol = 7'h00; // 
      endcase
		
   //-------------------------------------------
   // Frequency region
   //  - display frequency value
   //-------------------------------------------
   assign frq_on = ((10'd415<pixel_y)&&(pixel_y<10'd432)) && ((pixel_x>10'd255)&&(pixel_x<10'd384));
   assign row_addr_frq = pixel_y[3:0];
	assign bit_addr_frq = pixel_x[2:0];
   assign rom_addr_frq = {char_addr_frq, row_addr_frq};
   always @*
      case (pixel_x[6:3])
			4'h0: char_addr_frq = (7'd48 +  frq[19:16]); // digit 10
         4'h1: char_addr_frq = (7'd48 +  frq[15:12]); // digit 10
         4'h2: char_addr_frq = 7'h2c; // ,
         4'h3: char_addr_frq = (7'd48 +  frq[11:8]); // digit 10
         4'h4: char_addr_frq = (7'd48 +  frq[7:4]); // digit 10
         4'h5: char_addr_frq = (7'd48 +  frq[3:0]); // digit 10
         4'h6: char_addr_frq = 7'h00; // digit 10
         4'h7: char_addr_frq = 7'h48; // H
         4'h8: char_addr_frq = 7'h7a; // z
         4'h9: char_addr_frq = 7'h00; // 
         4'ha: char_addr_frq = 7'h00; // 
         4'hb: char_addr_frq = 7'h00; //
         4'hc: char_addr_frq = 7'h00; // 
         4'hd: char_addr_frq = 7'h00; // 
         4'he: char_addr_frq = 7'h00; // 
         4'hf: char_addr_frq = 7'h00; // 
      endcase
		
   //-------------------------------------------
   // Tİme/div region
   //  - display scale time
   //-------------------------------------------
   assign time_on = ((10'd431<pixel_y)&&(pixel_y<10'd448)) && ((pixel_x>10'd255)&&(pixel_x<10'd384));
   assign row_addr_time = pixel_y[3:0];
	assign bit_addr_time = pixel_x[2:0];
   assign rom_addr_time = {char_addr_time, row_addr_time};
   always @*
      case (pixel_x[6:3])
         4'h0: char_addr_time = (7'd48 +7'd6); // digit 10 time1[15:12]
         4'h1: char_addr_time = 7'h2e; // .
         4'h2: char_addr_time = (7'd48 + 7'd8); // digit 10time1[11:8]
         4'h3: char_addr_time = (7'd48 + 7'd6);  // digit 10time1[7:4]);
         4'h4: char_addr_time = (7'd48 + 7'd0); // digit 10time1[3:0]
         4'h5: char_addr_time = 7'h6d; // m
         4'h6: char_addr_time = 7'h73; // s
         4'h7: char_addr_time = 7'h2f; // /
         4'h8: char_addr_time = 7'h64; // d
         4'h9: char_addr_time = 7'h69; // i
         4'ha: char_addr_time = 7'h76; //	v
         4'hb: char_addr_time = 7'h00; // 
         4'hc: char_addr_time = 7'h00; // 
         4'hd: char_addr_time = 7'h00; // 
         4'he: char_addr_time = 7'h00; // 
         4'hf: char_addr_time = 7'h00; // 
      endcase

   //-------------------------------------------
   // MODE region
   //  - display mode voltage
   //-------------------------------------------
   assign mode_on = ((10'd447<pixel_y)&&(pixel_y<10'd464)) && ((pixel_x>10'd255)&&(pixel_x<10'd384));
   assign row_addr_mode = pixel_y[3:0];
	assign bit_addr_mode = pixel_x[2:0];
   assign rom_addr_mode = {char_addr_mode, row_addr_mode};
   always @*
      case (pixel_x[6:3])
         4'h0: char_addr_mode = 7'h4d; // M
         4'h1: char_addr_mode = 7'h4f; // O
         4'h2: char_addr_mode = 7'h44; // D
         4'h3: char_addr_mode = 7'h45; // E
         4'h4: char_addr_mode = 7'h3a; // :
         4'h5: char_addr_mode = 7'h20; // 
         4'h6: char_addr_mode = 7'd68-3*mode; // dig1
         4'h7: char_addr_mode = 7'h43; // C
         4'h8: char_addr_mode = 7'h00; //
         4'h9: char_addr_mode = 7'h00; //
         4'ha: char_addr_mode = 7'h00; //
         4'hb: char_addr_mode = 7'h00; // 
         4'hc: char_addr_mode = 7'h00; // 
         4'hd: char_addr_mode = 7'h00; // 
         4'he: char_addr_mode = 7'h00; // 
         4'hf: char_addr_mode = 7'h00; // 
      endcase
		
   // "on" region limited to top-left corner

   // rgb multiplexing circuit
   always @*
	begin
		if(mx_on) begin                  //Vmax
			char_addr = char_addr_mx;
         row_addr = row_addr_mx;
         bit_addr = bit_addr_mx;
         if(font_bit) begin
            rgb_text = 8'b11111111;// green
				end
          else begin
            rgb_text = 8'b0;  // black
				end
			end
			
		else if(mn_on) begin              //Vmin
			char_addr = char_addr_mn;
         row_addr = row_addr_mn;
         bit_addr = bit_addr_mn;
         if(font_bit) begin
            rgb_text = 8'b11111111;// green
				end
          else begin
            rgb_text = 8'b0;  // black
				end
			end
			
		else if(me_on) begin              //Vmean
			char_addr = char_addr_me;
         row_addr = row_addr_me;
         bit_addr = bit_addr_me;
         if(font_bit) begin
            rgb_text = 8'b11111111;// green
				end
          else begin
            rgb_text = 8'b0;  // black
				end
			end

		else if(p2p_on) begin              //Vp2p
			char_addr = char_addr_p2p;
         row_addr = row_addr_p2p;
         bit_addr = bit_addr_p2p;
         if(font_bit) begin
            rgb_text = 8'b11111111;// green
				end
          else begin
            rgb_text = 8'b0;  // black
				end
			end
			
		else if(rms_on) begin              //Vrms
			char_addr = char_addr_rms;
         row_addr = row_addr_rms;
         bit_addr = bit_addr_rms;
         if(font_bit) begin
            rgb_text = 8'b11111111;// green
				end
          else begin
            rgb_text = 8'b0;  // black
				end
			end
			
		else if(frq_on) begin              //Frquency
			char_addr = char_addr_frq;
         row_addr = row_addr_frq;
         bit_addr = bit_addr_frq;
         if(font_bit) begin
            rgb_text = 8'b11111111;// green
				end
          else begin
            rgb_text = 8'b0;  // black
				end
			end
			
		else if(vol_on) begin              //Volts/div
			char_addr = char_addr_vol;
         row_addr = row_addr_vol;
         bit_addr = bit_addr_vol;
         if(font_bit) begin
            rgb_text = 8'b11111111;// green
				end
          else begin
            rgb_text = 8'b0;  // black
				end
			end
			 
		else if(time_on) begin             //Secs/div
			char_addr = char_addr_time;
         row_addr = row_addr_time;
         bit_addr = bit_addr_time;
         if(font_bit) begin
            rgb_text = 8'b11111111;// green
				end
          else begin
            rgb_text = 8'b0;  // black
				end
			end
			 
		else if(mode_on) begin             //AC/DC mode
			char_addr = char_addr_mode; 
         row_addr = row_addr_mode;
         bit_addr = bit_addr_mode;
         if(font_bit) begin
            rgb_text = 8'b11111111;// green
				end
          else begin
            rgb_text = 8'b0;  // black
				end
			end
			
		else begin
			rgb_text = 8'b0;  // black
			end
	end	
	assign text_on = {mx_on, mn_on, me_on, p2p_on, rms_on, frq_on, vol_on, time_on, mode_on};
   //-------------------------------------------
   // font rom interface
   //-------------------------------------------
   assign rom_addr = {char_addr, row_addr};
   assign font_bit = font_word[~bit_addr];
//	
//always @*
//	begin
//	 frq <= frq ;
//	 reg_max <= max;
//	 reg_min <= min;
//	 mea <= mea;
//	 p2p <= p2p;
//	 rms <= rms;
//	 vol <= vol ;
//	 time1 <= time1 ;
//	 reg_mode <= mode;
//	end
endmodule
