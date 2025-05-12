`timescale 1ns / 1ps

module wavelet_decomposer_tb;

    // Testbench Signals
    reg clk;
    reg rst;
    reg [31:0] filtered_ecg;  // 32-bit ECG input signal
    wire [15:0] D1, D2, D3, D4; // Output detail coefficients

    // Instantiate the wavelet_decomposer module
    wavelet_decomposer uut (
        .clk(clk),
        .rst(rst),
        .filtered_ecg(filtered_ecg),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4)
    );

    // Clock Generation: 50 MHz (20ns period)
    always #10 clk = ~clk;

    // Stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        filtered_ecg = 32'd0;

        // Reset the system
        #20 rst = 0;

        // Apply test values to simulate ECG data
        #20 filtered_ecg = 32'd100000; // Example ECG value
        #20 filtered_ecg = 32'd150000; // Varying ECG signal
        #20 filtered_ecg = 32'd200000;
        #20 filtered_ecg = 32'd250000;
        #20 filtered_ecg = 32'd300000;

        // Edge case values
        #20 filtered_ecg = 32'd0;       // Zero value
        #20 filtered_ecg = 32'hFFFFFFFF; // Maximum 32-bit value (Boundary case)
       
        // End Simulation
        #50 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | ECG=%d | D1=%d | D2=%d | D3=%d | D4=%d",
                 $time, filtered_ecg, D1, D2, D3, D4);
    end

endmodule
