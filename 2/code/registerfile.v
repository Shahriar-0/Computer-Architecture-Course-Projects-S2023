module registerFile(clk, regWrite, A1, A2, A3, WD, RD1, RD2);
    parameter RN = 5;
    parameter N = 32;

    input clk, regWrite;
    input [RN-1:0] A1, A2, A3;
    input [N-1:0] WD;
    
    output [N-1:0] RD1, RD2;

    reg [N-1:0] registers [0:N-1];

    initial 
        registers[0] = 32'd0;
    
    assign ReadData1 = (ReadRegister1 == 5'd0) ? 32'd0 : registers[ReadRegister1];
    assign ReadData2 = (ReadRegister2 == 5'd0) ? 32'd0 : registers[ReadRegister2];

    always @(posedge clk) begin
        if(regWrite && A3 != 5'b0)
            registers[A3] <= WD;
    end

endmodule