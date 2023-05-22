module DataMemory(memAdr, writeData, clk, memWrite, readData);
    parameter N = 32;

    input memWrite, clk;
    input [N-1:0] memAdr, writeData;

    output [N-1:0] readData;

   
endmodule
