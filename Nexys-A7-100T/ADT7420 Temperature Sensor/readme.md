# Reading Temperature Data and Displaying on the 7 Segment
https://github.com/LyraN66/HDL---VHDL/assets/101515029/0734cc09-a930-409d-a7a3-e13c0364f6e4

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

## ADT7420 Temperature Sensor Section

  ADT7420 use I2C for communication as specified in the datasheet master should pull down sda while scl is high 
which gives a start bit for communication. Then I send the slave address (0x4B) + R/W bit , then master waits an 
ack from slave. After receiving ack I send the internal register address which I want to read data from there then
again waits an ack from slave after this we are reading the data while SCL is high.

![ADT7420 Timing](https://github.com/LyraN66/HDL---VHDL/assets/101515029/f27acbbc-b60b-4f77-8f29-ced53225c083)

  In the datasheet of ADT7420 SCL timing is showed clearly. According to these values I created parameter which are used in FSM of sensor.
  
  ---
    localparam TIME_1SEC   =50000000; //(INTERVAL/CLK_PER);// Clock ticks in 1 sec
    localparam TIME_THDSTA =60; //(600/CLK_PER);     // 0.6 us
    localparam TIME_TSUSTA =60; //(600/CLK_PER);     // 0.6 us
    .
    .
    .
  ---

![ADT7420 Slave Address](https://github.com/LyraN66/HDL---VHDL/assets/101515029/8f59be1d-5bf8-45d7-85a3-769e252af304)

  ---
    localparam I2C_ADDR = 7'b1001011; // 0x4B
  ---
  
![ADT7420 Data Register](https://github.com/LyraN66/HDL---VHDL/assets/101515029/8caea4a4-bdeb-4890-ada1-e694596790c5)

  In the image below resolution of the sensor is stated. In 16 bit of data first 3 bit (0.,1. and 2.) are reserved 
for flags and last bit (15.) is reserved for sign bit. Therefore [15:3] bits are data bits. Multipliying with 0.0625
per bit means also shifting right by 4 bit. Therefore last 4 bit of data portion represents the fraction part of the data.

  ---
                integer_digit_2 <= conversion_integer_data / 10;
                integer_digit_1 <= conversion_integer_data % 10;
                fraction_digit_2 <= conversion_fraction_data / 1000;
                fraction_digit_1_temp <= conversion_fraction_data % 1000;
                fraction_digit_1 <= fraction_digit_1_temp / 100;
  ---

![ADT7420 Data](https://github.com/LyraN66/HDL---VHDL/assets/101515029/23cc6bad-5757-4a06-bd87-13ad5e25cc26)

  In 13 bit reading mode ADT7420 gives a 0.0625 °C per bit which requires a conversion part.
  
![FSM](https://github.com/LyraN66/HDL---VHDL/assets/101515029/c71d0099-ea4b-45e1-99fa-577d0c7c12e9)

  As a last thing FSM for sensor is showed in the above image. It checks the number of data bit to decide to finish or continue. 









  
