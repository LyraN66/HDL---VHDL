`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ethem Bu?ra Arslan
// 
// Create Date: 18.07.2023 11:06:10
// Design Name: 
// Module Name: ADT7420_Temperature_Sensor_Final
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//              In this project the 13 bit temperature value taken from ADT7420 with I2C communication
//              and displayed on the seven segment display and on the leds every 0.5 s interval.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//              
//////////////////////////////////////////////////////////////////////////////////


module ADT7420_Temperature_Sensor_Final(
    // ADT7420 Part
    input clk,
    inout sda,
    output scl,
    output reg [15:0] led, 
    // 7 Segment Display Part
    output reg [7:0] AN_X_Display,  // AN_7 = AN_X[7]
    output reg [7:0] CX_Display     // CA = CX[7]
    );
    
    /////////////////////////////////////////////////////////////////////////////
    //  ADT7420 FSM Section
    ////////////////////////////////////////////////////////////////////////////
    parameter INTERVAL = 1000000000;
    parameter CLK_PER = 10;
    
    localparam TIME_1SEC   =50000000; //(INTERVAL/CLK_PER);// Clock ticks in 1 sec
    localparam TIME_THDSTA =60; //(600/CLK_PER);     // 0.6 us
    localparam TIME_TSUSTA =60; //(600/CLK_PER);     // 0.6 us
    localparam TIME_THIGH  =60; //(600/CLK_PER);     // 0.6 us
    localparam TIME_TLOW   =130; //(1300/CLK_PER);    // 1.3 us
    localparam TIME_TSUDAT =2; //(20/CLK_PER);      // 0.02 us
    localparam TIME_TSUSTO =60; //(600/CLK_PER);     // 0.6 us
    localparam TIME_THDDAT =3; //(30/CLK_PER);      // 0.03 us
    localparam I2C_ADDR = 7'b1001011; // 0x4B
    localparam I2CBITS = 30;
    
    reg sda_en = 1'b0;
    reg scl_en = 1'b0;
    
    reg [29:0] i2c_data = 30'b0;
    reg [29:0] i2c_en = 30'b0;
    reg [29:0] i2c_capt = 30'b0;
    
    reg [31:0]counter = 32'b0;
    reg counter_reset = 1'b0;
    
    reg [29:0] bit_count = 30'b0;
    reg [15:0] temp_data = 16'b0;
    reg capture_en;
    
    assign scl = scl_en ? 1'bz : 1'b0;
    assign sda = sda_en ? 1'bz : 1'b0;
    
    reg [2:0] fsm_state = 3'b000;
    localparam IDLE = 3'b000;
    localparam START = 3'b001;
    localparam TLOW = 3'b010;
    localparam TSU = 3'b011;
    localparam THIGH = 3'b100;
    localparam THD = 3'b101;
    localparam TSTO = 3'b110;
    
    initial begin
        integer_values[0] = zero;
        integer_values[1] = one;
        integer_values[2] = two;
        integer_values[3] = three;
        integer_values[4] = four;
        integer_values[5] = five;
        integer_values[6] = six;
        integer_values[7] = seven;
        integer_values[8] = eight;
        integer_values[9] = nine;
        
        temp_data <= 16'b0;
        scl_en          = 1'b0;
        sda_en          = 1'b0;
        counter_reset   = 1'b0;
        counter         = 32'b0;
        bit_count       = 30'b0;
            AN_X_Display <= 8'b11111111;
            i <= 0;
            value <= 8'b11111111;
            state <= 3'b000;
    end
    
    always @(posedge clk)begin
        capture_en = i2c_capt[I2CBITS - bit_count - 1];
        scl_en  <= 1'b1;
        sda_en  <= ~i2c_en[I2CBITS - bit_count - 1] | i2c_data[I2CBITS - bit_count - 1];
        if(counter_reset)begin
            counter <= 32'b0;
            counter_reset <= 1'b0;
        end
        else begin
            counter <= counter + 1'b1;
        end
        case (fsm_state)
            IDLE:begin
                i2c_data  <= {1'b0, I2C_ADDR, 1'b1, 1'b0, 8'b00, 1'b0, 8'b00, 1'b1, 1'b0, 1'b1};
                i2c_en    <= {1'b1, 7'h7F,    1'b1, 1'b0, 8'b00, 1'b1, 8'b00, 1'b1, 1'b1, 1'b1};
                i2c_capt  <= {1'b0, 7'h00,    1'b0, 1'b0, 8'hFF, 1'b0, 8'hFF, 1'b0, 1'b0, 1'b0};
                bit_count <= 30'b0;
                sda_en    <= 1'b1; // Force to 1 in the beginning.
                conversion_en <= 1'b0;
                if(counter == TIME_1SEC)begin
                    led <= temp_data;
                    sda_en <= 1'b0;
                    fsm_state <= START;
                    counter_reset <= 1'b1;
                end
            end
            START:begin
                sda_en <= 1'b0;              
                if(counter == TIME_THDSTA)begin
                    scl_en <= 1'b0;
                    fsm_state <= TLOW;
                    counter_reset <= 1'b1;
                end
            end
            TLOW:begin
                scl_en <= 1'b0;             
                if(counter == TIME_TLOW)begin
                    bit_count <= bit_count + 1'b1;
                    fsm_state <= TSU;
                    counter_reset <= 1'b1;
                end
            end
            TSU:begin
                scl_en <= 1'b0;            
                if(counter == TIME_TSUSTA)begin
                    fsm_state <= THIGH;
                    counter_reset <= 1'b1;
                end
            end
            THIGH:begin
                scl_en <= 1'b1;           
                if(counter == TIME_THIGH)begin
                    if(capture_en)begin
                        temp_data <= temp_data << 1 | sda;
                    end
                    fsm_state <= THD;
                    counter_reset <= 1'b1;
                end
            end
            THD:begin
                scl_en <= 1'b0;
                if (counter == TIME_THDDAT) begin
                    counter_reset <= 1'b1;
                    fsm_state <= (bit_count == I2CBITS) ? TSTO : TLOW;
                end
            end
            TSTO:begin
                if (counter == TIME_TSUSTO) begin
                    counter_reset <= 1'b1;
                    fsm_state <= IDLE;
                    conversion_en <= 1'b1;
                end
            end
        endcase
    end
    /////////////////////////////////////////////////////////////////////////////
    //  Conversion Section
    ////////////////////////////////////////////////////////////////////////////
    reg [27:0] counter_2 = 28'b0;
    reg [7:0] conversion_integer_data = 8'b0;
    reg [15:0] conversion_fraction_data = 16'b0;
    reg [7:0] integer_value_1 = 8'b0;
    reg [7:0] integer_value_2 = 8'b0;
    reg [7:0] fraction_value_1 = 8'b0;
    reg [7:0] fraction_value_2 = 8'b0;
    reg [3:0] integer_digit_1 = 4'b0;
    reg [3:0] integer_digit_2 = 4'b0;   // MSB
    reg [3:0] fraction_digit_1 = 4'b0;
    reg [11:0]fraction_digit_1_temp = 12'b0;
    reg [3:0] fraction_digit_2 = 4'b0;  // MSB   
    reg conversion_en;
    
    always @(posedge clk)begin
        if (counter_2 == 0) begin
            counter_2 <= 100000000;
            conversion_integer_data <= temp_data [14:7]; // 8 bit integer data
            conversion_fraction_data <= temp_data [6:3] * 625; // 4 bit fraction data
        end
        else begin
            counter_2 <= counter_2 - 1;        
            if(conversion_en) begin
                integer_digit_2 <= conversion_integer_data / 10;
                integer_digit_1 <= conversion_integer_data % 10;
                fraction_digit_2 <= conversion_fraction_data / 1000;
                fraction_digit_1_temp <= conversion_fraction_data % 1000;
                fraction_digit_1 <= fraction_digit_1_temp / 100;
            end
        end
    end
    
    /////////////////////////////////////////////////////////////////////////////
    //  7 Segment Display Section
    ////////////////////////////////////////////////////////////////////////////
    integer i = 200000 ;
    reg [19:0 ] counter_1 = 20'b0;
    reg clk_updated = 1'b0;
    reg [7:0] digit = 8'b11111111;  // decide the location on display
    reg [7:0] value = 8'b11111111;  // decides the value which will be written
    // values for numbers
    reg [7:0] zero  = 8'b00000011;
    reg [7:0] one   = 8'b10011111;
    reg [7:0] two   = 8'b00100101; 
    reg [7:0] three = 8'b00001101;
    reg [7:0] four  = 8'b10011001;
    reg [7:0] five  = 8'b01001001;
    reg [7:0] six   = 8'b01000001;
    reg [7:0] seven = 8'b00011111;
    reg [7:0] eight = 8'b00000001;
    reg [7:0] nine  = 8'b00011001;
    reg [7:0] degree= 8'b00111001;
    // values for letters 
    reg [7:0] Aletter = 8'b00010001;    
    reg [7:0] bletter = 8'b11000001;    
    reg [7:0] Cletter = 8'b01100011;    
    reg [7:0] dletter = 8'b10000101;    
    reg [7:0] Eletter = 8'b01100001;    
    reg [7:0] Fletter = 8'b01110001;
    
    // FSM regs 
    reg [3:0] state = 3'b011;
    reg [3:0] AN_0=3'b000;
    reg [3:0] AN_1=3'b001;
    reg [3:0] AN_2=3'b010;
    reg [3:0] AN_3=3'b011;
    reg [3:0] AN_4=3'b100;
    reg [3:0] AN_5=3'b101;
    reg [3:0] AN_6=3'b110;
    reg [3:0] AN_7=3'b111;
    reg [7:0] integer_values[0:10];
    
    
    always @(posedge clk) begin
        if (counter_1 == 0) begin
            clk_updated <= ~clk_updated;
            counter_1 <= 50000;
        end
        else begin
            counter_1 <= counter_1 - 1;
        end
    end

    always @(posedge clk_updated) begin
        CX_Display <= value;
        AN_X_Display <= digit;
        
        integer_value_2 = integer_values[integer_digit_2];
        integer_value_1 = integer_values[integer_digit_1];
        fraction_value_2 = integer_values[fraction_digit_2];
        fraction_value_1 = integer_values[fraction_digit_1];
         
        if(clk_updated) begin
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
            end
            AN_2: begin
                digit <= 8'b11111011; 
                value <= fraction_value_1;
                state <= AN_3;
            end
            AN_3: begin
                digit <= 8'b11110111; 
                value <= fraction_value_2;
                state <= AN_4;
            end
            AN_4: begin
                digit <= 8'b11101111; 
                value <= integer_value_1;
                value[0] <= 1'b0;   // used for dot
                state <= AN_5;
            end
            AN_5: begin
                digit <= 8'b11011111; 
                value <= integer_value_2;
                state <= AN_6;
            end
            AN_6: begin
                digit <= 8'b11111111; // activate it like digit <= 8'b10111111;
                value <= two;
                state <= AN_7;
            end
            AN_7: begin
                digit <= 8'b11111111; // activate it like digit <= 8'b01111111; 
                value <= one;
                state <= AN_0;
            end            
            endcase
        end    
    end
endmodule
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////