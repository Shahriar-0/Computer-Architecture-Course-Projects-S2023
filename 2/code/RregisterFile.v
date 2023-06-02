`define BITS(x) $rtoi($ceil($clog2(x)))

module RegisterFile(clk, regWrite,
                    readRegister1, readRegister2,
                    writeRegister, writeData,
                    readData1, readData2);

    parameter WordLen = 32;
    parameter WordCount = $pow(2, 14);

    input regWrite, clk;
    input [`BITS(WordCount)-1:0] readRegister1, readRegister2, writeRegister;
    input [WordLen-1:0] writeData;
    output [WordLen-1:0] readData1, readData2;

    reg [WordLen-1:0] registerFile [0:WordCount-1]

    initial 
        registerFile[0] = 32'd0;

    always @(posedge clk) begin
        else if (regWrite & writeRegister)
            registerFile[writeRegister] <= writeData;
    end

    assign readData1 = registerFile[ReadRegister1];
    assign readData2 = registerFile[ReadRegister2];

endmodule