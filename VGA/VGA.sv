module VGA(clk, VGA_clk, xCount, yCount, display, waveform, VGA_hSync, VGA_vSync, blank_n,Red_1,Blue_1,Green_1);
	
	input clk;
	output reg [9:0]xCount, yCount;   
	output VGA_hSync, VGA_vSync, blank_n;
	output wire [7:0]Red_1;
	output wire [7:0]Blue_1;
	output wire [7:0]Green_1;
	
	reg p_hSync, p_vSync; 	
	reg q;
	reg [3:0]counter;
	reg displayArea;
	reg waveformArea;

	
	output reg VGA_clk;
	
	integer porchHF = 640; //start of horizntal front porch
	integer porchVF_1 = 384;
	integer syncH = 655;//start of horizontal sync
	integer porchHB = 747; //start of horizontal back porch
	integer maxH = 793; //total length of line.
	
	reg count;
	reg [7:0]green;
	
	integer porchVF = 480; //start of vertical front porch 
	integer syncV = 490; //start of vertical sync
	integer porchVB = 492; //start of vertical back porch
	integer maxV = 525; //total rows.
	
	output wire [7:0]display;
	output wire waveform;
	
	//voltage_scale form(.VGA_CLK(VGA_clk), .xCount(xCount), .yCount(yCount),.Dataout(dataout));
//	font_gen print(.clock(clk),
//    .pixel_x(xCount), .pixel_y(yCount),
//    .rgb_text(rgb_text));
	 
	
	
	assign display = {displayArea,displayArea,displayArea,displayArea,displayArea,displayArea,displayArea,displayArea};
	assign waveform = {waveformArea,waveformArea,waveformArea,waveformArea,waveformArea,waveformArea,waveformArea,waveformArea};
	//assign Green_1 = (display&green);
	assign Green_1 = green;
	always@(posedge VGA_clk)
	begin
		if(xCount === maxH)
			xCount <= 0;
		else
			xCount <= xCount + 1;
	end
	
	// 93sync, 46 bp, 640 display, 15 fp
	// 2 sync, 33 bp, 480 display, 10 fp

	always@(posedge clk)
	begin
		q <= ~q; 
		VGA_clk <= q;
	end
	
	always@(posedge VGA_clk)
	begin
		if(xCount === maxH)
		begin
			if(yCount === maxV)
				yCount <= 0;
			else
			yCount <= yCount + 1;
		end
	end
	
	always@(posedge VGA_clk)
	begin
		displayArea <= ((xCount < porchHF) && (yCount < porchVF)); 
		waveformArea <= ((xCount < porchHF) && (yCount < porchVF_1)); 
	end

	always@(posedge VGA_clk)
	begin
		p_hSync <= ((xCount >= syncH) && (xCount < porchHB)); 
		p_vSync <= ((yCount >= syncV) && (yCount < porchVB)); 
	end
 
	assign VGA_vSync = ~p_vSync; 
	assign VGA_hSync = ~p_hSync;
	assign blank_n = displayArea;
	
	always @(posedge VGA_clk)
	begin
	if (waveformArea)begin
		if (xCount == 1 || yCount == 1 || xCount == 320 || yCount == 192 || yCount == 383 || xCount == 636)
			green <= 8'd255;
		else if (((((xCount/64 )*64-xCount)== 0)&&(yCount[0]))||
		((((yCount/48)*48 - yCount) == 0)&&(xCount[0])))
				green <= 8'd122;
		else 
				green <= 0;
		end
	else
		green <= 0;
	end
	
endmodule		


