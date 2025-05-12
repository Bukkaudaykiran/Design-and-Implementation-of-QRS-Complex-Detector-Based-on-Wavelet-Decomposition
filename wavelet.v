`timescale 1ns / 1ps
module wavelet_decomposer (
    input clk,              // Clock signal
    input rst,              // Reset signal
    input [31:0] filtered_ecg, // 32-bit filtered ECG input
    output reg [15:0] D1,   // Detail coefficient level 1
    output reg [15:0] D2,   // Detail coefficient level 2
    output reg [15:0] D3,   // Detail coefficient level 3
    output reg [15:0] D4    // Detail coefficient level 4
);

    // Daubechies-4 filter coefficients (scaled for fixed-point implementation)
    parameter signed [15:0] H0 = 16'sd125,   // Low-pass filter coefficient 1
                            H1 = 16'sd475,   // Low-pass filter coefficient 2
                            H2 = 16'sd475,   // Low-pass filter coefficient 3
                            H3 = 16'sd125;   // Low-pass filter coefficient 4

    parameter signed [15:0] G0 = -16'sd125,  // High-pass filter coefficient 1
                            G1 = 16'sd475,   // High-pass filter coefficient 2
                            G2 = -16'sd475,  // High-pass filter coefficient 3
                            G3 = 16'sd125;   // High-pass filter coefficient 4

    // Internal registers for storing intermediate wavelet coefficients
    reg signed [31:0] temp_L, temp_H;  // Temporary registers for filtering

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            D1 <= 16'd0;
            D2 <= 16'd0;
            D3 <= 16'd0;
            D4 <= 16'd0;
        end else begin
            // Apply wavelet transform filtering

            // First level decomposition (D1)
            temp_L = (H0 * filtered_ecg[31:16]) + (H1 * filtered_ecg[15:0]) +
                     (H2 * filtered_ecg[31:16]) + (H3 * filtered_ecg[15:0]);
            temp_H = (G0 * filtered_ecg[31:16]) + (G1 * filtered_ecg[15:0]) +
                     (G2 * filtered_ecg[31:16]) + (G3 * filtered_ecg[15:0]);
            D1 <= temp_H[31:16];  // High-pass output

            // Second level decomposition (D2)
            temp_L = (H0 * temp_L[31:16]) + (H1 * temp_L[15:0]) +
                     (H2 * temp_L[31:16]) + (H3 * temp_L[15:0]);
            temp_H = (G0 * temp_L[31:16]) + (G1 * temp_L[15:0]) +
                     (G2 * temp_L[31:16]) + (G3 * temp_L[15:0]);
            D2 <= temp_H[31:16];

            // Third level decomposition (D3)
            temp_L = (H0 * temp_L[31:16]) + (H1 * temp_L[15:0]) +
                     (H2 * temp_L[31:16]) + (H3 * temp_L[15:0]);
            temp_H = (G0 * temp_L[31:16]) + (G1 * temp_L[15:0]) +
                     (G2 * temp_L[31:16]) + (G3 * temp_L[15:0]);
            D3 <= temp_H[31:16];

            // Fourth level decomposition (D4)
            temp_L = (H0 * temp_L[31:16]) + (H1 * temp_L[15:0]) +
                     (H2 * temp_L[31:16]) + (H3 * temp_L[15:0]);
            temp_H = (G0 * temp_L[31:16]) + (G1 * temp_L[15:0]) +
                     (G2 * temp_L[31:16]) + (G3 * temp_L[15:0]);
            D4 <= temp_H[31:16];
        end
    end
endmodule


