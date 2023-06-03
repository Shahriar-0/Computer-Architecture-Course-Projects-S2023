module InstructionMemory(pc, instruction);

    input [31:0] pc;

    output [31:0] instruction;

    reg [7:0] instructionMemory [0:$pow(2, 16)-1]; 

    wire [31:0] adr;
    assign adr = {pc[31:2], 2'b00}; 

    initial $readmemb("instructions.mem", instructionMemory);

    assign instruction = {instructionMemory[adr], instructionMemory[adr + 1], 
                            instructionMemory[adr + 2], instructionMemory[adr + 3]};

endmodule
