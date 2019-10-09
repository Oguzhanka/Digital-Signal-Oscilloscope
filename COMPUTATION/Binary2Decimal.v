module Binary2Decimal(         
	input             wait_measure_done,
	input 		[31:0]bindata,           //12-bit ADC values
	input             run_stop,          //Run/Stop signal
	output wire  [23:0] decimalout
);
	reg [3:0]dig_5,dig_4,dig_3,dig_2,dig_1,dig_0;
	assign decimalout ={dig_0,dig_1,dig_2,dig_3,dig_4,dig_5};
	
always@ * begin
    if (run_stop)begin  //Stop the transmission and keep it
	 end
    else begin
	 
		//0~4096 scale to 0~4.096V
		dig_0 <=  bindata/100000;
      dig_1 <= (bindata-100000*( bindata/100000))/10000;
      dig_2 <= (bindata-10000*(bindata/10000))/1000;
		dig_3 <= (bindata-1000*(bindata/1000))/100;
		dig_4 <= (bindata-100*(bindata/100))/10;
		dig_5 <= (bindata-10*(bindata/10));
		
	end
end

endmodule