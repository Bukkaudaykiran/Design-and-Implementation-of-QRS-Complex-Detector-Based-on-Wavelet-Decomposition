`timescale 1ns / 1ps

module ECG_Processing_System (
    input clk,                    // Clock signal
    input rst,                    // Reset signal
    input [15:0] ecg_signal,       // Input ECG signal
    input [15:0] Tn,               // Noise threshold
    output wire FinalOut           // Final QRS detection output
);

    // Internal Signals
    wire [15:0] fir_out;
    wire [15:0] D1, D2, D3, D4;    // Wavelet coefficients
    wire Select;                   // Noise detector output
    wire [31:0] MPavg;             // Signal Processing output

    // FIR Filter
    FIR_Filter fir (
        .clk(clk),
        .rst(rst),
        .ecg_in(ecg_signal),
        .fir_out(fir_out)
    );

    // Wavelet Decomposition
    wavelet_decomposer wavelet (
        .clk(clk),
        .rst(rst),
        .out_ecg(fir_out),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4)
    );

    // Noise Detector
    noise_detector noise (
        .clk(clk),
        .reset(rst),
        .D1(D1),
        .Tn(Tn),
        .Select(Select)
    );

    // Signal Multiplier
    SignalMultiplier signal (
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .Select(Select),
        .MPavg(MPavg)
    );

    // Adaptive Threshold
    AdaptiveThreshold adaptive (
        .MPavg(MPavg),
        .Out(FinalOut)
    );

endmodule

// FIR Filter Module
module FIR_Filter (
    input clk,
    input rst,
    input [15:0] ecg_in,
    output reg [15:0] fir_out
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            fir_out <= 16'd0;
        else
            fir_out <= (ecg_in >> 1) + (ecg_in >> 2);  // Simple averaging filter
    end
endmodule

// Wavelet Decomposition Module
module wavelet_decomposer (
    input clk,
    input rst,
    input [15:0] out_ecg,
    output reg [15:0] D1, D2, D3, D4
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            D1 <= 16'd0;
            D2 <= 16'd0;
            D3 <= 16'd0;
            D4 <= 16'd0;
        end else begin
            D1 <= out_ecg >> 1;
            D2 <= out_ecg >> 2;
            D3 <= out_ecg >> 3;
            D4 <= out_ecg >> 4;
        end
    end
endmodule

// Noise Detector Module
module noise_detector (
    input clk,
    input reset,
    input [15:0] D1,
    input [15:0] Tn,
    output reg Select
);
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0;
            Select <= 0;
        end else begin
            if (D1 > Tn)
                count <= count + 1;
            if (count >= 9)
                Select <= 1;
            else
                Select <= 0;
        end
    end
endmodule

// Signal Processing (Multiplier) Module
module SignalMultiplier (
    input [15:0] D1, D2, D3, D4,
    input Select,
    output [31:0] MPavg
);
    reg [31:0] product;

    always @(*) begin
        if (Select)
            product = D3 * D4;  // High noise condition
        else
            product = D1 * D2;  // Low noise condition
    end

    assign MPavg = (Select) ? (3 * product) >> 3 : (9 * product) >> 3;
endmodule

// Adaptive Threshold Module (Without Vt1, Vt2, Vt3, Vt4)
module AdaptiveThreshold (
    input [31:0] MPavg,
    output reg Out
);
    reg [15:0] lambda1, lambda3;
    reg MPavg_2_found;

    always @(*) begin
        MPavg_2_found = (MPavg > 32'd500);
        lambda1 = 16'd50;  // Fixed threshold
        lambda3 = MPavg_2_found ? (lambda1 * 3) >> 1 : (lambda1 * 2);

        Out = (MPavg > lambda3);
    end
endmodule
