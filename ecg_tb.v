module tb_ecg_clt_32bit;
    reg clk, rst;
    wire [31:0] out_ecg;

    // Instantiate the ECG module
    ecg_clt_32bit uut (
        .clk(clk),
        .rst(rst),
        .out_ecg(out_ecg)
    );

    // Clock Generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        #10;
       
        rst = 0; // Release reset
        #100;

        $stop; // End simulation
    end

    always @(posedge clk) begin
        $display("Time=%0t ECG Output=%h", $time, out_ecg);
    end

endmodule
