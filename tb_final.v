`timescale 1ns / 1ps

module tb_ECG_Processing_System;
    reg clk;
    reg rst;
    reg [15:0] ecg_signal;
    reg [15:0] Tn;
    wire FinalOut;

    // Internal Signals
    wire [15:0] fir_out;
    wire [15:0] D1, D2, D3, D4;
    wire Select;
    wire [31:0] MPavg;

    // Instantiate the DUT (Device Under Test)
    ECG_Processing_System uut (
        .clk(clk),
        .rst(rst),
        .ecg_signal(ecg_signal),
        .Tn(Tn),
        .FinalOut(FinalOut)
    );

    // Assign internal signals for monitoring
    assign fir_out = uut.fir.fir_out;
    assign D1 = uut.wavelet.D1;
    assign D2 = uut.wavelet.D2;
    assign D3 = uut.wavelet.D3;
    assign D4 = uut.wavelet.D4;
    assign Select = uut.noise.Select;
    assign MPavg = uut.signal.MPavg;

    // Clock generation
    always #5 clk = ~clk;  // 10ns period

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        ecg_signal = 16'h0000;
        Tn = 16'h0010;

        // Apply reset
        #20 rst = 0;
       
        // Test Case 1
        ecg_signal = 16'h000A;
        #10;
        $display("Time: %0t | ECG: %h | FIR: %h | D1: %h | D2: %h | D3: %h | D4: %h | Select: %b | MPavg: %h | FinalOut: %b",
                  $time, ecg_signal, fir_out, D1, D2, D3, D4, Select, MPavg, FinalOut);

        // Test Case 2
        ecg_signal = 16'h002F;
        #10;
        $display("Time: %0t | ECG: %h | FIR: %h | D1: %h | D2: %h | D3: %h | D4: %h | Select: %b | MPavg: %h | FinalOut: %b",
                  $time, ecg_signal, fir_out, D1, D2, D3, D4, Select, MPavg, FinalOut);

        // Test Case 3
        ecg_signal = 16'h00A0;
        #10;
        $display("Time: %0t | ECG: %h | FIR: %h | D1: %h | D2: %h | D3: %h | D4: %h | Select: %b | MPavg: %h | FinalOut: %b",
                  $time, ecg_signal, fir_out, D1, D2, D3, D4, Select, MPavg, FinalOut);

        // Test Case 4
        ecg_signal = 16'h01F0;
        #10;
        $display("Time: %0t | ECG: %h | FIR: %h | D1: %h | D2: %h | D3: %h | D4: %h | Select: %b | MPavg: %h | FinalOut: %b",
                  $time, ecg_signal, fir_out, D1, D2, D3, D4, Select, MPavg, FinalOut);

        // Test Case 5
        ecg_signal = 16'h0025;
        #10;
        $display("Time: %0t | ECG: %h | FIR: %h | D1: %h | D2: %h | D3: %h | D4: %h | Select: %b | MPavg: %h | FinalOut: %b",
                  $time, ecg_signal, fir_out, D1, D2, D3, D4, Select, MPavg, FinalOut);

        // End simulation
        #50;
        $finish;
    end
endmodule
