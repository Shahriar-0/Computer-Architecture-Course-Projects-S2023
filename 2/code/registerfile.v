`define BITS(x) $rtoi($ceil($clog2(x)))

module RegisterFile(clk, regWrite, sRst,
                    readRegister1, readRegister2,
                    writeRegister, writeData,
                    readData1, readData2);

    parameter WordLen = 32;
    parameter WordCount = $pow(2, 15);

    input regWrite, sRst, clk, rst;
    input [`BITS(WordCount)-1:0] readRegister1, readRegister2, writeRegister;
    input [WordLen-1:0] writeData;
    output [WordLen-1:0] readData1, readData2;

    reg [WordLen-1:0] registerFile [0:WordCount-1]

    initial 
        registerFile[0] = 32'd0;

    always @(posedge clk) begin
        if (sRst)
            registerFile[writeRegister] <= {WordLen{1'b0}};

        else if (regWrite & writeRegister) // Forbid writing to R0
            registerFile[writeRegister] <= writeData;
    end

    assign readData1 = registerFile[ReadRegister1];
    assign readData2 = registerFile[ReadRegister2];

endmodule
