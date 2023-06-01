module InstructionMemory (pc, instruction);
    input [31:0] pc;

    output [31:0] instruction;

    reg [7:0] instMem [0:$pow(2, 16)-1]; // 64KB 

    wire [31:0] adr;
    assign adr = {pc[31:2], 2'b00}; 

    initial $readmemb("instructions.mem", instMem);

    assign instruction = {instMem[adr], instMem[adr + 1], instMem[adr + 2], instMem[adr + 3]};

endmodule
