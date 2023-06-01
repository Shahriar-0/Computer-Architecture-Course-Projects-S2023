module DataMemory(memAdr, writeData, clk, memWrite, readData);
    parameter N = 32;

    input memWrite, clk;
    input [N-1:0] memAdr, writeData;

    output [N-1:0] readData;

    reg [7:0] dataMem [0:$pow(2, 16)-1]; // 64KB

    wire [31:0] adr;
    assign adr = {memAdr[31:2], 2'b00};

    initial $readmemb("data.mem", dataMem, 1000); // TODO: 1000 file

    always @(posedge clk) begin
        if(memWrite)
            {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]} <= writeData;
    end

    assign readData = {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]};

endmodule
