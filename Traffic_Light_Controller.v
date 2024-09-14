`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2024 04:46:47 PM
// Design Name: 
// Module Name: Traffic_Light_Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Traffic_Light_Controller(
    input clk,       // Clock input
    input resetn,    // Asynchronous active-low reset
    input sa,        // Traffic Sensor for Street A
    input sb,        // Traffic Sensor for Street B
    output reg Ra,   // Red light Street A
    output reg Ya,   // Yellow light Street A
    output reg Ga,   // Green light Street A
    output reg Rb,   // Red light Street B
    output reg Yb,   // Yellow light Street B
    output reg Gb    // Green light Street B
);

    // State encoding
    parameter [2:0] s0 = 3'b000,
                    s1 = 3'b001,
                    s2 = 3'b010,
                    s3 = 3'b011;
                    
    reg [2:0] state, next_state;
    reg [27:0] counter; // 28-bit counter for up to 60 seconds

    // Sequential block for state and counter updates
    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            state <= s0;
            counter <= 28'b0;
        end else begin
            state <= next_state;
            if (state == s0 || state == s1 || state == s2 || state == s3) begin
                if (counter < 28'd60_000_000 && state == s0)
                    counter <= counter + 1;
                else if (counter < 28'd10_000_000 && state == s1)
                    counter <= counter + 1;
                else if (counter < 28'd50_000_000 && state == s2)
                    counter <= counter + 1;
                else
                    counter <= 28'b0;
            end
        end
    end

    // Combinational block for next state logic
    always @(*) begin
        case(state)
            s0: begin
                if (counter < 28'd60_000_000)
                    next_state = s0;
                else if (sb) // if car approaches street B
                    next_state = s1;
                else
                    next_state = s0;
            end
            s1: begin
                if (counter < 28'd10_000_000)
                    next_state = s1;
                else
                    next_state = s2;
            end
            s2: begin
                if (counter < 28'd50_000_000)
                    next_state = s2;
                else if (sa | ~sb) // if there is a car at A or B is empty
                    next_state = s3;
                else
                    next_state = s2;
            end
            s3: begin
                if (counter < 28'd10_000_000)
                    next_state = s3;
                else
                    next_state = s0;
            end
            default: next_state = s0;
        endcase
    end

    // Combinational block for output signals based on state
    always @(state) begin
        // Initialize all lights to off
        Ga = 1'b0; Ya = 1'b0; Ra = 1'b0;
        Gb = 1'b0; Yb = 1'b0; Rb = 1'b0;
        
        case(state)
            s0: begin
                Ga = 1'b1;  // Green light for Street A
                Rb = 1'b1;  // Red light for Street B
            end
            s1: begin
                Ya = 1'b1;  // Yellow light for Street A
                Rb = 1'b1;  // Red light for Street B
            end
            s2: begin
                Ra = 1'b1;  // Red light for Street A
                Gb = 1'b1;  // Green light for Street B
            end
            s3: begin
                Ra = 1'b1;  // Red light for Street A
                Ya = 1'b1;  // Yellow light for Street A
            end
        endcase
    end

endmodule

