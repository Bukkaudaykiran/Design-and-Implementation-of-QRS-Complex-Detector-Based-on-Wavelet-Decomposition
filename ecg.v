module ecg_clt_32bit (
    input  wire        clk,      // Clock signal
    input  wire        rst,      // Reset signal
    output reg  [31:0] out_ecg   // 32-bit ECG output
);

    reg [31:0] sum; // 32-bit sum to accumulate random signals
    reg [31:0] rand1, rand2, rand3, rand4; // Simulated random inputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum     <= 32'h00000000; // Initialize to zero
            out_ecg <= 32'h00000000;
            rand1   <= 32'h00000001;
            rand2   <= 32'h00000002;
            rand3   <= 32'h00000003;
            rand4   <= 32'h00000004;
        end else begin
            // Generate pseudo-random signals (replace with real PRNG if needed)
            rand1 <= rand1 + 32'h00000031;
            rand2 <= rand2 + 32'h0000001C;
            rand3 <= rand3 + 32'h00000027;
            rand4 <= rand4 + 32'h0000000D;

            // CLT summation of multiple signals
            sum <= rand1 + rand2 + rand3 + rand4;

            // Assign 32-bit sum to output
            out_ecg <= sum;
        end
    end

endmodule
