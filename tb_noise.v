`timescale 1ns / 1ps

module tb_noise_detector;

    // Testbench signals
    reg clk;
    reg reset;
    reg [15:0] D1;
    reg [15:0] Tn;
    wire Select; // Single-bit noise detection output

    // Instantiate the Unit Under Test (UUT)
    noise_detector uut (
        .clk(clk),
        .reset(reset),
        .D1(D1),
        .Tn(Tn),
        .Select(Select)
    );

    // Clock generation
    always #5 clk = ~clk;  // Generate clock with period 10ns

    // Test stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        D1 = 16'd0;
        Tn = 16'd100; // Threshold value

        // Reset system
        #10 reset = 0;

        // Test Case 1: Normal condition (D1 < Tn)
        D1 = 16'd80;
        #30;

        // Test Case 2: Noise condition triggered (D1 > Tn multiple times)
        D1 = 16'd150;  // Exceeds threshold
        #50;

        // Test Case 3: Reset condition
        reset = 1;
        #10 reset = 0;

        // Test Case 4: Noise occurs again
        D1 = 16'd200;
        #50;

        // End simulation
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %0t, D1 = %d, Tn = %d, Select (Noise Detected) = %b",
                 $time, D1, Tn, Select);
    end

endmodule


