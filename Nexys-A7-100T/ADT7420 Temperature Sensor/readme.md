# Reading Temperature Data and Displaying on the 7 Segment
  In this project I read the 13 bit (1 sign bit 12 data bit) temperature data from ADT7420 which is embedded on Nexys 4 DDR (Nexys A7 100T ) board and displayed on the
seven segment display.

## 7 Segment Display Section
![7 Segment CX](https://github.com/LyraN66/HDL---VHDL/assets/101515029/756ed35b-b12f-4dc6-b6a1-5927fb9402bc)
  
  As seen in the image above there are 8 different leds to display any data on the segment but notice that to give a light to segment '0' need to be send.
  
  Some of the numbers/letters shown down here
  ---
    reg [7:0] zero  = 8'b00000011;
    reg [7:0] one   = 8'b10011111;
    reg [7:0] two   = 8'b00100101; 
    reg [7:0] three = 8'b00001101;
    .
    .
    .
    reg [7:0] Aletter = 8'b00010001;    
    reg [7:0] bletter = 8'b11000001;    
    reg [7:0] Cletter = 8'b01100011;
  ---

  ![7 Segment AN](https://github.com/LyraN66/HDL---VHDL/assets/101515029/f2d0ab6f-b56f-4f49-b0c0-1b4cca9b0403)

    As seen in the image above, more than one data can't be send on the same time therefore I created a FSM to sent data.

  ---
    case (state)
            AN_0: begin
                digit <= 8'b11111110; 
                value <= Cletter;
                state <= AN_1;
            end
            AN_1: begin
                digit <= 8'b11111101;
                value <= degree;
                state <= AN_2;
                .
                .
                .
    endcase
  ---

      In the FSM for 7 Segment Display "digit" parameter defines which segment will display the "value" parameter 
    which is depended on the data which comes from sensor.
