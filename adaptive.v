module AdaptiveThreshold (
    input [15:0] Vt1, Vt2, Vt3, Vt4,  // 16-bit threshold values
    input [31:0] MPavg,               // 32-bit MPavg input
    output reg Out                    // Single-bit output renamed from DetectedQRS to Out
);
    reg [15:0] lambda1, lambda2, lambda3;
    reg [15:0] mean_vt;
    reg MPavg_2_found; // Correctly initialized

    always @(*) begin
        // Initialize MPavg_2_found to avoid undefined values
        MPavg_2_found = (MPavg > 32'd500); // Example condition for assignment

        // Calculate λ1, λ2, and λ3 thresholds
        mean_vt = (Vt1 + Vt2 + Vt3 + Vt4) >> 2;  // Dividing by 4 for correct averaging
        lambda1 = mean_vt + 16'd8;               // Adding bias
        lambda2 = (lambda1 * 5) >> 2;            // 1.25 * λ1
        lambda3 = MPavg_2_found ? (lambda1 * 3) >> 1 : (2 * Vt1 - lambda1);

        // Decision rule for QRS detection
        Out = (MPavg > lambda3);  // Correct assignment to Out
    end
endmodule
