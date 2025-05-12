module tb_SignalMultiplier;
    reg [15:0] D1, D2, D3, D4;
    reg Select;
    wire [31:0] MPavg;

    // Instantiate the SignalMultiplier module
    SignalMultiplier uut (
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .Select(Select),
        .MPavg(MPavg)
    );

    initial begin
        // Test Case 1: Select = 0 (D1 * D2)
        D1 = 16'h0010;  // 16
        D2 = 16'h0020;  // 32
        D3 = 16'h0008;  // 8
        D4 = 16'h0016;  // 22
        Select = 0;  // Expect (D1 * D2) * (9 / 8)

        #10;  // Wait for 10 time units
        $display("MPavg (D1*D2): %h", MPavg);

        // Test Case 2: Select = 1 (D3 * D4)
        Select = 1;  // Expect (D3 * D4) * (3 / 8)

        #10;
        $display("MPavg (D3*D4): %h", MPavg);

        #10 $stop;  // Stop simulation
    end
endmodule
