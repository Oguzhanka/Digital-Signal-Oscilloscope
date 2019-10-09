module time_block(CLK, RSTB, DATA_IN, TRIG, PERIOD1, PERIOD2, PERIOD_FLAG);

input CLK;
input RSTB;

input [11:0] DATA_IN;
input [11:0] TRIG;

reg [3:0]STATE;
reg [1:0]TIMER_STATE;


reg [24:0]TIME;
reg PERIOD_COUNTER;
reg TIME1_RECORD;
reg TIME2_RECORD;
output reg [24:0]PERIOD1;			//DUTY CYCLE ON
output reg [24:0]PERIOD2;			//TOTAL PERIOD
output reg PERIOD_FLAG;

initial begin

	STATE=4'd0;
	TIME =25'd0;
	TIME1_RECORD=0;
	TIME2_RECORD=0;
	PERIOD1=25'd0;
	PERIOD2=25'd0;
	PERIOD_COUNTER=0;
	TIMER_STATE=2'd0;
	
	end


always @(posedge CLK)begin    //Main state machine
	
	if(~RSTB)begin
		STATE<=4'd0;
		PERIOD_COUNTER<=0;
		TIME1_RECORD<=0;
		TIME2_RECORD<=0;
		end
	
	else begin
		
		case(STATE)
			
			4'd0: begin
				TIME2_RECORD<=0;
				if(DATA_IN > (TRIG-12'd6))begin
					STATE<=4'd1;
					end
					
				else begin
					STATE<=4'd0;
					end
				end
			
			4'd1: begin
				if(DATA_IN>(TRIG))begin
					PERIOD_COUNTER<=1;
					STATE<=4'd2;
					end
					
				else begin
					STATE<=4'd1;
					end
				end
			
			4'd2: begin
				if(DATA_IN<(TRIG))begin
					TIME1_RECORD<=1;
					STATE<=4'd3;
					end
				
				else begin
					STATE<=4'd2;
					end	
				end
				
			4'd3: begin
				TIME1_RECORD<=0;
				if(DATA_IN>(TRIG))begin
					TIME2_RECORD<=1;
					PERIOD_COUNTER<=0;
					STATE<=4'd0;
					end
				
				else begin
					STATE<=4'd3;
					end
				end
		endcase
	end
end


always @(posedge CLK)begin
	if(~RSTB)begin
		TIME<=25'd0;
		PERIOD_FLAG<=0;
		end
		
	else begin
		case(TIMER_STATE)
			
			2'b00: begin
				if(PERIOD_COUNTER)begin
					TIME<=TIME+25'd1;
					TIMER_STATE<=2'b01;
					PERIOD_FLAG<=0;
					end
				else begin
					TIMER_STATE<=2'b00;
					PERIOD_FLAG<=0;
					end
				end
				
			2'b01: begin
				if(TIME1_RECORD)begin
					PERIOD1<=TIME;
					TIME<=TIME+25'd1;
					TIMER_STATE<=2'b10;
					PERIOD_FLAG<=0;
					end
				
				else begin
					TIMER_STATE<=2'b01;
					TIME<=TIME+25'd1;
					PERIOD_FLAG<=0;
					end
				end
				
			2'b10: begin
				if(TIME2_RECORD)begin
					PERIOD2<=TIME;
					TIME<=TIME+25'd1;
					TIMER_STATE<=2'b11;
					PERIOD_FLAG<=0;
					end
				
				else begin
					TIMER_STATE<=2'b10;
					TIME<=TIME+25'd1;
					PERIOD_FLAG<=0;
					end
				end
				
			2'b11:  begin
				TIME<=25'd0;
				TIMER_STATE<=2'b00;
				PERIOD_FLAG<=1;
				end
				
			endcase
		end
	end

endmodule
