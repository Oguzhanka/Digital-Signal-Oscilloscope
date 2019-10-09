module trigger_adjust(input CLK, input RSTB, input button_u, input button_d, output wire [11:0]TRIG);

reg [3:0]button_counter ;
reg [10:0]counter;
reg [1:0]state;
initial
begin
button_counter = 4'd6;
end
always @(posedge  CLK)begin
	if(~RSTB)begin
		button_counter<=4'd0;
		end
		
	else begin
		case(state)
		
			2'b00:begin
				if(~button_u)begin
					button_counter<=button_counter+3'd1;
					state<=2'b01;
					end
			
				if(~button_d)begin
					button_counter<=button_counter-3'd1;
					state<=2'b01;
					end
				end
			
			2'b01: begin
				if(counter==10'd10000)begin
					counter<=10'd0;
					state<=2'b00;
					end
				else begin
					counter<=counter+10'd1;
					state<=2'b01;
					end
				end
			default: begin
				state <= 2'b00;
			end
			endcase	
		end
	end
	
assign TRIG={button_counter,8'd0};

endmodule
