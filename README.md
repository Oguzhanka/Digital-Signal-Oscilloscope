Authors: Oguzhan Karaahmetoglu, Mete Can Kaya (Rest in Peace, my friend)

# Project Description

​	Aim of this project is to design a digital signal oscilloscope using Verilog HDL and an FPGA. For demonstration purposes, DE1-SOC 5CSEMA5F31C6 was used for implementation. And the algorithms were implemented using Verilog HDL and SysVerilog. ADC module of the FPGA was used to sample and quantize an analog signal to 12 bits. After sampling the input signal, a computation block will perform arithmetic operations on the digital signal to compute the period, root-mean-square, minimum, maximum and various other properties of the digital signal. These values are then printed on the screen. For this purpose, a 640x480 VGA screen is used and VGA module of the FPGA was used. 

![1571589745700](/IMAGES/diagram.jpeg)

​	In the above figure you can see the overall diagram of the design.



# Block Descriptions



## ADC Module

​	In this part, analog signal will be transfer to digital signal. Hence, ADC(analog to digital converter) is needed. We will use AD7908 (ADC chip on DE1-SoC rev. c board) as ADC module. The voltage range of the chip is 0-5 V and it has the maximum clock frequency 20 MHz. The chip can be used in several modes according to its datasheet. In this project, it is used in normal operation mode. The timing of the ADC[1] is made of two part.

​	After giving the necessary configuration inputs to the ADC chip, it will yield 15 bit serial bit data at ever clock. The first three bits are address bits and they give information about which channel the digital signal comes from. Remaining 12 bits are the quantized analog signal. In order to obtain parallel 12 bit data, serial outputs parallelized. Hence , there is a loop that converts 15 bit serial in to 15 bit parallel data. Then, store it in a buffer register . The buffer stores 15 bit data.



## Computation Block

​	This is the main block responsible for computing the properties of the digital signal such as period, maximum, minimum value. Also prepares the calculated properties for displaying on the VGA screen (scaling the values to real values and converting binary information to BCD encoding). There are two sub blocks in the Computation Block namely, the voltage block and the time block.

### Time Block

​	Depending on a trigger value (adjusted by the user via an input switch), the period (hence the frequency) of the input signal is calculated. Further details about the calculation and the state machine used in this part can be found in the code.



### Voltage Block

​	This block computes the following properties of the input signal,

		* Minimum voltage value
		* Maximum voltage value
		* Mean voltage value
		* Root-Mean-Square value
		* Peak-to-peak voltage value



​	Calculating, minimum and the maximum of the input signal is relatively easier and it is done by storing the minimum and the maximum value encountered until the end of a period. Mean value of the input signal is calculated by accumulating the sample values and dividing the sum of the sample to the number of samples at the end of a period. Root mean square of the signal is obtained by accumulating the squared values of the samples and averaged over a period. Square root operation is implemented with the bisection method. Hence, it is not a single-clock operation.



## RAM Unit

​	This block consists of two subparts, a FIFO buffer that stores the incoming samples in a 640x12 bit 2-D array. This FIFO unit is not triggered by every new sample, but triggered when a new sample passes the trigger value. This is done because the oscilloscope should not display a streaming signal, but a stationary signal when the trigger value cuts the signal. Once FIFO is triggered, new 640 samples will be stored in the buffer.

​	There is an additional memory structure in this part, video-memory. It stores the signal values that will be displayed on the screen. Contents of this memory should not change while new samples arrive to the FPGA. The contents will only be updated once FIFO gets refreshed.



## Trigger Level Adjustment

​	Trigger adjustment unit is a simple but an important part of the overall project considering that all calculations are carried out according to trigger value. For this purpose, a unit that enables the user to set trigger level manually was required. A small and simple state machine was built for this purpose. This block uses two push buttons as control input and using them to increment/decrement trigger voltage level.



## Display Module

​	VGA is a screen type which has its own transmission protocol and connector type that takes signals to operate. Block takes two main signals, hsync and vsync, which are used to control the position of the screen counters (position pointer on screen). A VGA screen is painted with this cursor which travels through every single pixel and paints the pixel with three color masks (RGB) with specified intensity (8 bit).



​	Color masks are stored in three separate arrays RED, GREEN, BLUE. In this project, grid area and measurement numbers are colored with green hence their positions are stored in that array. Observe the below figure which shows the oscilloscope screen.

![1571592818559](/IMAGES/display.jpeg)

​	As seen from the figure, periodic grid values are generated together with the thick axis lines. Generating lines on VGA screen is easy considering that modeling and calculating their positions are as easy as (grid = 1 ? (x_count==320); 0). However generating alphanumeric codes are hard since for a 16x8 pixel area, one should encode the mask of every single character. Instead of doing so, a project available on the web[1]
was used as a template since every ASCII character was encoded and can be printed on the screen by just calling its hexadecimal ASCII code. The strings are printed by calling characters sequentially.



​	Displaying the waveform on the screen is a bit more complicated operation since the waveform is obtained in 12 bit unsigned 6 binary format and this value should be mapped to a different one to be drawn on the screen. There are 400 pixels in the grid area which is used to draw the waveform on the screen. And in this project, voltage scale was fixed to 0.75V/div and a division has 50 px length meaning that every pixel corresponds to 0.75 V/50 px = 0.015 V/px. Mapping can be done as 5 V / 400 px = 0.0125 V/px 0.015/0.0125= 1.2000 V/V.

​	Hence, if every signal value is amplified with this factor, it is possible to obtain its vertical position on the screen. In a similar way, horizontal position of a value can be calculated as scaling the sampling rate of the data inputs. The time scale of the display unit is also fixed at 6.86 ms which determines the time delay between two successive samples until the whole screen is filled with the waveform. As seen from the figure again, the color of the waveform was chosen as blue and hence its mask was recorded in the BLUE array. All intensity values are set to 255 in order to display with full color intensity.



# References

[1] https://github.com/bogini/Pong/



# Images

### Demo-1



![1571592818559](/IMAGES/screen_sample_input.jpeg)

![1571592818559](/IMAGES/screen_sample.jpeg)



### Demo 2

![1571592818559](/IMAGES/input_no_offset.jpeg)

![1571592818559](/IMAGES/screen_no_offset.jpeg)



### Demo 3

![1571592818559](/IMAGES/screen_offset.jpeg)
