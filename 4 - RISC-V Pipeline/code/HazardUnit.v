module HazardUnit(ID_EX_MemRead, ID_EX_rs1, ID_EX_rs2, IF_ID_rs1, 
                  IF_ID_rs2, IF_ID_MemRead, IF_ID_opcode, stall);

    input ID_EX_MemRead;
    input [4:0] ID_EX_rs1, ID_EX_rs2, IF_ID_rs1, IF_ID_rs2;
    input IF_ID_MemRead;
    input [6:0] IF_ID_opcode;

    output stall;

    wire rs1_hazard, rs2_hazard, mem_hazard;

    assign rs1_hazard = ((ID_EX_MemRead && (ID_EX_rs1 != 0) && ((ID_EX_rs1 == IF_ID_rs1) || (_EX_rs1 == IF_ID_rs2))) ||
                         (IF_ID_MemRead && ((IF_ID_rs1 == IF_ID_rs2) && (IF_ID_rs1 != 0))));
    assign rs2_hazard = ((ID_EX_MemRead && (ID_EX_rs2 != 0) && ((ID_EX_rs2 == IF_ID_rs1) || (ID_EX_rs2 == IF_ID_rs2))) ||
                         (IF_ID_MemRead && ((IF_ID_rs1 == IF_ID_rs2) && (IF_ID_rs2 != 0))));
    assign mem_hazard = (IF_ID_MemRead && ((IF_ID_rs1 == IF_ID_rs2) && (IF_ID_rs1 !=0)));

    always @(*) begin
        if (mem_hazard || ((rs1_hazard || rs2_hazard) && (IF_ID_opcode != `B_T)))
            stall = 1;
        else
            stall = 0;
    end

endmodule
