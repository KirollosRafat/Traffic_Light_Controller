`timescale 1 us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2024 06:11:13 PM
// Design Name: 
// Module Name: Traffic_Light_Controller_tb
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

`timescale 1us / 1ns

module tb_Traffic_Light_Controller;

    // Testbench signals
    reg clk;
    reg resetn;
    reg sa;
    reg sb;
    wire Ra;
    wire Ya;
    wire Ga;
    wire Rb;
    wire Yb;
    wire Gb;

    // Instantiate the Traffic_Light_Controller module
    Traffic_Light_Controller uut (
        .clk(clk),
        .resetn(resetn),
        .sa(sa),
        .sb(sb),
        .Ra(Ra),
        .Ya(Ya),
        .Ga(Ga),
        .Rb(Rb),
        .Yb(Yb),
        .Gb(Gb)
    );

    // Clock generation
    always 
    begin
        clk = 0;
        #0.005 clk = ~clk; // 100 MHz clock, 0.005 us period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        resetn = 0;
        sa = 0;
        sb = 0;

        // Apply reset
        #0.01; // 10 ns in microseconds
        resetn = 1;
        #0.01;

        // Test Scenario 1: No cars on either street
        // Expecting Street A to be green and Street B to be red
        #60; // Wait for 60 seconds (60,000,000 ns -> 60 us)
        sa = 0; sb = 0;
        #0.01;

        // Test Scenario 2: Car detected on Street B
        sa = 0; sb = 1;
        #10; // Wait for 10 seconds (10,000,000 ns -> 10 us)
        sa = 0; sb = 0;
        #0.01;

        // Test Scenario 3: Car detected on Street A
        sa = 1; sb = 0;
        #50; // Wait for 50 seconds (50,000,000 ns -> 50 us)
        sa = 0; sb = 0;
        #0.01;

        // Test Scenario 4: Back to Street A
        // Expecting Street A to be red and Street B to be green
        sa = 0; sb = 0;
        #10; // Wait for 10 seconds (10,000,000 ns -> 10 us)
        sa = 0; sb = 0;
        #0.01;

        // End simulation
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time = %0t us, Ra = %b, Ya = %b, Ga = %b, Rb = %b, Yb = %b, Gb = %b, State = %b, Counter = %d", 
                 $time, Ra, Ya, Ga, Rb, Yb, Gb, uut.state, uut.counter);
    end

endmodule


