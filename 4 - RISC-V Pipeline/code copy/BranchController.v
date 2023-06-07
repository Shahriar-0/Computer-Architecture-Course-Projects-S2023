
`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b010
`define BGE 3'b011

module BranchController(branchE, jumpE, neg, zero, w);

    input zero, neg;
    inout [2:0] branch;
    input [1:0] jumpE;

    output reg w;
    
    always @(jumpE, zero, neg, branchE) begin
        // FIX ME
    end

endmodule