module ForwardingUnit(EX_MEM_RegWrite, EX_MEM_rd, EX_MEM_ALUResult,
                      MEM_WB_RegWrite, MEM_WB_rd, MEM_WB_MToReg, MEM_WB_ALUResult,
                      ID_EX_rs1, ID_EX_rs2,
                      forwarded_rs1, forwarded_rs2);

    input EX_MEM_RegWrite, MEM_WB_RegWrite;
    input [4:0] EX_MEM_rd, MEM_WB_rd;
    input [31:0] EX_MEM_ALUResult, MEM_WB_ALUResult, ID_EX_rs1, ID_EX_rs2;
    input MEM_WB_MemToReg;

    output [31:0] forwarded_rs1, forwarded_rs2;

    wire ex_mem_forward_rs1, ex_mem_forward_rs2, mem_wb_forward_rs1, mem_wb_forward_rs2;

    assign ex_mem_forward_rs1 = (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1));
    assign ex_mem_forward_rs2 = (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2));
    assign mem_wb_forward_rs1 = (MEM_WB_RegWrite && (MEM_WB_rd != 0) && !MEM_WB_MemToReg && (MEM_WB_rd == ID_EX_rs1));
    assign mem_wb_forward_rs2 = (MEM_WB_RegWrite && (MEM_WB_rd != 0) && !MEM_WB_MemToReg && (MEM_WB_rd == ID_EX_rs2;    
    assign forwarded_rs1 = (ex_mem_forward_rs1 || mem_wb_forward_rs1)? MEM_WB_ALUResult : ID_EX_rs1;
    assign forwarded_rs2 = (ex_mem_forward_rs2 || mem_wb_forward_rs2)? MEM_WB_ALUResult : ID_EX_rs2;

endmodule
