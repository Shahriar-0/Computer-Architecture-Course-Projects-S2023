module ForwardingUnit (ExMemRd, MemWBRd, ExMemregWrite, MemWBregWrite, IDExRsA, IDExRsB, forwardA, forwardB);
    input [4:0] ExMemRd, MemWBRd, IDExRsA, IDExRsB;
    input ExMemregWrite, MemWBregWrite;
    output reg [1:0] forwardA, forwardB;

    always @(ExMemRd, MemWBRd, ExMemregWrite, MemWBregWrite, IDExRsA) begin
        forwardA = 2'b00;
        if (ExMemregWrite == 1'b1 && ExMemRd != 5'd0 && ExMemRd == IDExRsA)
            forwardA = 2'b01;
        else if (MemWBregWrite == 1'b1 && MemWBRd != 5'd0 && MemWBRd == IDExRsA)
            forwardA = 2'b10;
    end

    always @(ExMemRd, MemWBRd, ExMemregWrite, MemWBregWrite, IDExRsB) begin
        forwardB = 2'b00;
        if (ExMemregWrite == 1'b1 && ExMemRd != 5'd0 && ExMemRd == IDExRsB)
            forwardB = 2'b01;
        else if (MemWBregWrite == 1'b1 && MemWBRd != 5'd0 && MemWBRd == IDExRsB)
            forwardB = 2'b10;
    end
endmodule
