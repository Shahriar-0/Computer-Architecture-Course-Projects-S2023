`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b010
`define BGE 3'b011
module BranchController(func3, branch, neg, zero, w);
    input branch, zero, neg;
    inout [2:0] func3;
    output w;
    
    assign w = (func3 == `BEQ) ? branch & zero:
                   (func3 == `BNE) ? branch & ~zero:
                   (func3 == `BLT) ? branch & neg:
                   (func3 == `BGE) ? branch & (zero | ~neg):
                   1'b0;
endmodule