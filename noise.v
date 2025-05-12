`timescale 1ns / 1ps

module noise_detector (
    input wire clk,                // Clock input
    input wire reset,              // Reset input
    input wire [15:0] D1,          // Input signal D1 (16-bit)
    input wire [15:0] Tn,          // Threshold signal (16-bit)
    output reg Select              // Single-bit noise detection output
);

    // Internal signals
    reg [15:0] accumulator_reg;    // Accumulates occurrences of noise condition
    reg [3:0] count;               // Counter for noise threshold logic
    reg comparator_result;         // Result of D1 > Tn comparison

    // Accumulator logic (counts occurrences where D1 exceeds Tn)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulator_reg <= 16'b0;
            count <= 4'b0;
            Select <= 0; // Output as single-bit signal
        end else begin
            // Comparator logic: Check if D1 > Tn
            if (D1 > Tn) begin
                comparator_result <= 1;
            end else begin
                comparator_result <= 0;
            end

            // Accumulate counts if noise condition occurs
            if (comparator_result) begin
                accumulator_reg <= accumulator_reg + 1;
            end
           
            // Noise detection logic based on threshold counts
            if (accumulator_reg >= 3) begin
                count <= count + 1;
                accumulator_reg <= 16'b0; // Reset accumulator after threshold
            end

            // If noise condition crosses count threshold, assert Select (1-bit)
            if (count >= 9) begin
                Select <= 1;  // High noise detected
            end else begin
                Select <= 0;  // Noise level within acceptable range
            end
        end
    end

endmodule
