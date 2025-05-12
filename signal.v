module SignalMultiplier (
    input [15:0] D1,
    input [15:0] D2,
    input [15:0] D3,
    input [15:0] D4,
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

