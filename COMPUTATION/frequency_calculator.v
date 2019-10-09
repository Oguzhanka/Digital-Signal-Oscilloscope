module frequency_calculator(CLOCK, CLOCK_FREQ, RESET, SIG_MODE, ACQ_STATE, DATA_IN, TRIGGER, frequency);

//This module takes ADC values and calculates frequency of the given signals

input SIG_MODE;	//signal is DC(0) or AC(1)
input CLOCK;		//Main device clock
input CLOCK_FREQ;	//Clock for frequency calculator should have 20k frequency
input RESET;		//Block reset control
input ACQ_STATE;	//Data acquisition state completed(1) or uncomplete(0)

input [8:0] DATA_IN;		//Design specification, 10V/20mV=500 data points
input [8:0] TRIGGER;		//can be encoded with minimum 9- bits[0, 512]


output reg [12:0] frequency;	//Following from 1 being the least significant bit,
//We used binary coded decimal to further deal with, frequency resolution
// 10 Hz resolution and 20k max frequency needed



reg [7:0] TRIGGER_TEMP;			//temporary trigger values used to search the trigger value
reg [3:0] TRIGGER_COUNTER;		//trigger counter
reg TRIGGERED;						//A flag that determines if the signal is triggered or not

reg [31:0] TIME_COUNTER;		//Value of the counter that counts clock pulses for time difference
reg [31:0] TIME_PERIOD;			//PEriod value obtained from the counter
reg COUNTER_FLAG;					//Flag that determines when to start count time difference
reg [1:0] COUNTER_STATE;		//Counter has 3 states, start, count, record
reg TIME_GET;						//Flag to record period to RAM

reg DATA_READ;						//Flag to determine if data is succesfully read
reg [7:0] DATA_MEMORY;			//memory register for the input data
reg RECORD;							//Flag to determine whether to record data or not
reg [1:0] MEMORY_STATE;			//Waiting state of the reading


reg [2:0] STATE;					//State of the frequency calculator



always @(posedge CLOCK)begin

	if(~RESET)begin
		TRIGGERED<=0;
		end
		
	else begin
		
		if(((TRIGGER-9'd1) < DATA_IN) | ((TRIGGER+9'd1) > DATA_IN))begin
			TRIGGERED<=1'b1;
			end
			
		else begin
			TRIGGERED<=1'b0;
			end
		end
		
	end


//Time difference counter counts how many clock pulses are passed
//during measurement

always @(posedge CLOCK_FREQ)begin
	
	if(~RESET)begin
		TIME_COUNTER<=32'b0;
		TIME_PERIOD<=32'd0;
		COUNTER_STATE<=2'b00;
		end
		
	else begin
		case(COUNTER_STATE)
		
			2'b00: begin
				if(COUNTER_FLAG)begin
					TIME_COUNTER<=32'd0;
					COUNTER_STATE<=2'b01;
					end
				else begin
					COUNTER_STATE<=2'b00;
					end
				end
			
			2'b01: begin
				if(TIME_GET)begin
					COUNTER_STATE<=2'b10;
					end
				
				else if(COUNTER_FLAG)begin
					TIME_COUNTER<=TIME_COUNTER+32'd1;
					COUNTER_STATE<=2'b01;
					end
					
				else begin
					COUNTER_STATE<=2'b00;
					end
				end
				
			2'b10: begin
				TIME_PERIOD<=TIME_COUNTER;
				COUNTER_STATE<=2'b00;
				end
			
			endcase
	end
	
end



//Storing data to memory in order to check rise/fall

always @(posedge CLOCK)begin

	if(~RESET)begin
		DATA_READ<=0;
		MEMORY_STATE<=2'b00;
		end
	
	else begin
		case(MEMORY_STATE)
			2'b00: begin
				MEMORY_STATE<=2'b00;
				DATA_READ<=0;
				end
			2'b01: begin
				DATA_MEMORY<=DATA_IN;
				MEMORY_STATE<=2'b10;
				end
			2'b10:begin
				DATA_READ<=1;
				MEMORY_STATE<=2'b00;
				end
		endcase
	end
end




//Main state machine with 10 states to calculate frequency

always @(posedge CLOCK)begin
	
	if(~RESET)begin						//RESET and start state of the calculator
		STATE<=3'b0;						//State is initialized
		COUNTER_FLAG<=0;					//Counter is initialized
		end
		
	else begin
		case(STATE)
			3'b000: begin					//Check signal mode DC or AC
				TIME_GET<=1'b0;
				if(SIG_MODE == 1)begin	//If AC is obtained, proceed to next state
					STATE<=3'b001;
					end
				else begin
					STATE<=3'b000;			//If DC is obtained, stay idle to save computation
					end
					
				end
				
			3'b001: begin					//Wait until trigger value is caught
			
				if(TRIGGERED)begin		//If trigger value is reached, proceed to next state
					STATE<=3'b010;
					end	
				else begin
					STATE<=3'b001;			//Wait until ignal is triggered 
					end
				
				end
				
			3'b010: begin											//Wait for the rising edge of the trigger signal,
			
				if(DATA_IN > (TRIGGER + 9'd1))begin			//DATA_IN>TRIGGER when signal exceeds trigger value
					COUNTER_FLAG<=1;								//Start time difference counter
					STATE<=3'b011;									//Jump to the next state
					end
					
				else begin
					STATE<=3'b010;
					end
				end
					
			3'b011: begin											//A dummy state to check second crit. point
				
				if(DATA_IN < (TRIGGER - 9'd1))begin			//Means signal is decreasing
					STATE<=3'b100;
					end
					
				else begin
					STATE<=3'b011;
					end
				end
				
			3'b100: begin
			
				if(DATA_IN > (TRIGGER + 9'd1))begin
					COUNTER_FLAG<=0;
					TIME_GET<=1'b1;
					STATE<=3'b000;
					end
					
				else begin
					STATE<=3'b100;
					end
				end
					
		endcase
	end
end


always @(posedge CLOCK)begin
	
	if(~RESET)begin						//RESET the values
		frequency<=11'd0;
		end
		
	else begin
	
		if(SIG_MODE==1'b0) begin
			frequency<=11'd0;
			end
			
		else begin
			
			frequency<=TIME_PERIOD;
			end
		end
	end



endmodule
