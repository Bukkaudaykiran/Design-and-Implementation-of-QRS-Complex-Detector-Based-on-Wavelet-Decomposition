`timescale 1ns / 1ps

module tb_fir_lpf;

    reg clk;
    reg reset;
    reg enable;
    reg signed [31:0] out_ecg;
    wire signed [31:0] filtered_ecg;

    // Instantiate the FIR filter module
    fir_lpf uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .out_ecg(out_ecg),
        .filtered_ecg(filtered_ecg)
    );

    // Clock generation (50MHz -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        enable = 0;
        out_ecg = 0;

        // Apply Reset
        #20 reset = 0;
        enable = 1;

        // Apply test ECG signals
        #20 out_ecg = 32'd10000;  // Simulated ECG input
        #20 out_ecg = 32'd15000;
        #20 out_ecg = 32'd20000;
        #20 out_ecg = 32'd25000;
        #20 out_ecg = 32'd30000;
        #20 out_ecg = 32'd35000;
        #20 out_ecg = 32'd40000;
        #20 out_ecg = 32'd45000;
        #20 out_ecg = 32'd50000;
        #20 out_ecg = 32'd55000;
        #20 out_ecg = 32'd60000;

        // Hold input steady
        #200 out_ecg = 32'd0;

        // End simulation
        #100 $stop;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0dns | out_ecg: %d | filtered_ecg: %d", $time, out_ecg, filtered_ecg);
    end

endmodule

