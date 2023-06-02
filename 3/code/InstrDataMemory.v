module DataMemory (memAdr, writeData, memWrite, clk, readData);
    input [31:0] memAdr, writeData;
    input memWrite, clk;
    output [31:0] readData;
    reg [31:0] readData;

    reg [7:0] dataMem [0:$pow(2, 16)-1];

    wire [31:0] adr;
    assign adr = {memAdr[31:2], 2'b00};
    
    initial $readmemb("data.mem", dataMem, 1000);

    always @(posedge clk) begin
        if (memWrite)
            {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]} <= writeData;
    end

    
    assign readData = {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]};
    
endmodule
