module tb_AdaptiveThreshold;
    reg [15:0] Vt1, Vt2, Vt3, Vt4;
    reg [31:0] MPavg;      // Now MPavg is 32-bit
    wire Out;              // Output renamed to Out

    // Instantiate the AdaptiveThreshold module
    AdaptiveThreshold uut (
        .Vt1(Vt1),
        .Vt2(Vt2),
        .Vt3(Vt3),
        .Vt4(Vt4),
        .MPavg(MPavg),
        .Out(Out)
    );

    initial begin
        // Test Case 1: MPavg less than threshold
        Vt1 = 16'h0015;  // 21
        Vt2 = 16'h0017;  // 23
        Vt3 = 16'h0018;  // 24
        Vt4 = 16'h0016;  // 22
        MPavg = 32'h00100010;  // 16 (less than threshold)

        #10;  // Wait for 10 time units
        $display("Out (MPavg = 16): %b", Out);

        // Test Case 2: MPavg greater than threshold
        MPavg = 32'h00250025;  // 37 (greater than threshold)

        #10;
        $display("Out (MPavg = 37): %b", Out);

        #10 $stop;  // Stop simulation
    end
endmodule
