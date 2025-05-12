`timescale 1ns/1ps
module fir_lpf (
    input clk,                     // Clock signal
    input reset,                   // Reset signal
    input enable,                   // Enable signal
    input signed [31:0] out_ecg,    // Input ECG signal (32-bit signed)
    output reg signed [31:0] filtered_ecg // Filtered ECG output (32-bit signed)
);
   
    // FIR Filter Coefficients (Fixed-point representation)
    parameter signed [31:0] COEF0 = 32'h00000800; // 0.03125 ~ (2^-5)
    parameter signed [31:0] COEF1 = 32'h00001800; // 0.09375 ~ (2^-4 + 2^-6)
    parameter signed [31:0] COEF2 = 32'h00002800; // 0.15625 ~ (2^-3 + 2^-6)
    parameter signed [31:0] COEF3 = 32'h00003800; // 0.21875 ~ (2^-2 + 2^-6)
    parameter signed [31:0] COEF4 = COEF3; // Symmetric FIR filter
    parameter signed [31:0] COEF5 = COEF2; // Symmetric FIR filter

    // Registers for the delay line (shift register)
    reg signed [31:0] delay_line [5:0];

    // Intermediate multiplication results
    wire signed [31:0] prod0, prod1, prod2, prod3, prod4, prod5;

    // Multiplication (using bit-shifting for optimization)
    assign prod0 = (delay_line[0] >>> 5); // COEF0 = 2^-5
    assign prod1 = (delay_line[1] >>> 4) + (delay_line[1] >>> 6); // COEF1 = 2^-4 + 2^-6
    assign prod2 = (delay_line[2] >>> 3) + (delay_line[2] >>> 6); // COEF2 = 2^-3 + 2^-6
    assign prod3 = (delay_line[3] >>> 2) + (delay_line[3] >>> 6); // COEF3 = 2^-2 + 2^-6
    assign prod4 = prod3; // COEF4
    assign prod5 = prod2; // COEF5

    // FIR filter processing
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear delay line and output
            delay_line[0] <= 32'b0;
            delay_line[1] <= 32'b0;
            delay_line[2] <= 32'b0;
            delay_line[3] <= 32'b0;
            delay_line[4] <= 32'b0;
            delay_line[5] <= 32'b0;
            filtered_ecg <= 32'b0;
        end else if (enable) begin
            // Shift the input through the delay line
            delay_line[5] <= delay_line[4];
            delay_line[4] <= delay_line[3];
            delay_line[3] <= delay_line[2];
            delay_line[2] <= delay_line[1];
            delay_line[1] <= delay_line[0];
            delay_line[0] <= out_ecg;

            // Compute the filtered output by summing weighted inputs
            filtered_ecg <= prod0 + prod1 + prod2 + prod3 + prod4 + prod5;
        end
    end

endmodule
