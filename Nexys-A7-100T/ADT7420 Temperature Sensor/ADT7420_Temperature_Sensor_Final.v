`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ethem Buğra Arslan
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
        temp_data <= 16'b0;
        scl_en          = 1'b0;
        sda_en          = 1'b0;
        counter_reset   = 1'b0;
        counter         = 32'b0;
        bit_count       = 30'b0;
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
    
    reg [7:0] text [0:7];
    reg [7:0] integer_values [0:15];
    reg [7:0] empty ;
    
    reg [19:0 ] counter_for_seven_segment;
    reg clk_updated;
    reg [7:0] digit;  // decide the location on display
    reg [7:0] value;  // decides the value which will be written
    
    reg [7:0] degree= 8'b00111001;
    
    // FSM regs 
    reg [3:0] state = 3'b000;
    reg [3:0] AN_0=3'b000;
    reg [3:0] AN_1=3'b001;
    reg [3:0] AN_2=3'b010;
    reg [3:0] AN_3=3'b011;
    reg [3:0] AN_4=3'b100;
    reg [3:0] AN_5=3'b101;
    reg [3:0] AN_6=3'b110;
    reg [3:0] AN_7=3'b111;
    
    initial begin
        empty <= 8'b11111111;
        counter_for_seven_segment <= 20'b0;
        clk_updated <= 1'b0;
        digit <= 8'b11111110;
        AN_X_Display <= 8'b11111111;
        value <= 8'b11111111;
        state <= 3'b001;
        integer_values[0] <= 8'b00000011;    // 0
        integer_values[1] <= 8'b10011111;    // 1 
        integer_values[2] <= 8'b00100101;    // 2
        integer_values[3] <= 8'b00001101;    // 3
        integer_values[4] <= 8'b10011001;    // 4
        integer_values[5] <= 8'b01001001;    // 5
        integer_values[6] <= 8'b01000001;    // 6
        integer_values[7] <= 8'b00011111;    // 7
        integer_values[8] <= 8'b00000001;    // 8
        integer_values[9] <= 8'b00011001;    // 9
        integer_values[10] <= 8'b00010001;   // A
        integer_values[11] <= 8'b11000001;   // b
        integer_values[12] <= 8'b01100011;   // C
        integer_values[13] <= 8'b10000101;   // d
        integer_values[14] <= 8'b01100001;   // E
        integer_values[15] <= 8'b01110001;   // F
        
        text[0] <= 8'b0;        
        text[1] <= 8'b0;        
        text[2] <= 8'b0;        
        text[3] <= 8'b0;        
        text[4] <= 8'b0;        
        text[5] <= 8'b0;        
        text[6] <= 8'b0;        
        text[7] <= 8'b0;
    end
    
    always @(posedge clk) begin
        if (counter_for_seven_segment == 0) begin
            clk_updated <= ~clk_updated;
            counter_for_seven_segment <= 50000;
        end
        else begin
            counter_for_seven_segment <= counter_for_seven_segment - 1;
        end
    end
    
    always @(posedge clk_updated) begin
        CX_Display <= value;
        AN_X_Display <= digit;

        text[7] <= empty;
        text[6] <= empty;
        text[5] <= integer_values[integer_digit_2];
        text[4] <= integer_values[integer_digit_1]-1;
        text[3] <= integer_values[fraction_digit_2];
        text[2] <= integer_values[fraction_digit_1];
        text[1] <= 8'b00111001;
        text[0] <= integer_values[12];     

        if(clk_updated) begin
            digit <= (state==0) ? digit : digit - 2**(state-1);
            value <= text[state];
            if(state==8)begin
                state <= 3'b000;
                digit <= 8'b11111110;
            end
            else begin
                state <=  state + 1;
            end
         end    
    end
endmodule
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
