`define BITS(x) $rtoi($ceil($clog2(x)))

module RegisterFile(clk, regWrite, sRst, rst,
                    readRegister1, readRegister2,
                    writeRegister, writeData,
                    readData1, readData2);

    parameter WordLen = 32;
    parameter WordCount = 32;

    input regWrite, sRst, clk, rst;
    input [`BITS(WordCount)-1:0] readRegister1, readRegister2, writeRegister;
    input [WordLen-1:0] writeData;
    output [WordLen-1:0] readData1, readData2;

    reg [WordLen-1:0] registerFile [0:WordCount-1]

    initial 
        registerFile[0] = 32'd0;
    // ------------------------------------------------------------------------------

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst)
            for (i = 0; i < WordCount; i = i + 1)
                registerFile[i] <= {WordLen{1'b0}};
        else if (sRst)
            registerFile[writeRegister] <= {WordLen{1'b0}};
        else if (regWrite & writeRegister)// Forbid writing to R0
            registerFile[writeRegister] <= writeData;
    end

    assign readData1 = registerFile[ReadRegister1];
    assign readData2 = registerFile[ReadRegister2];

endmodule
