`define I_T 3'b000
`define S_T 3'b001
`define J_T 3'b010
`define B_T 3'b011
`define U_T 3'b100

module ImmExtension(ImmSrc, data, w);

    input [2:0] ImmSrc;
    input [24:0] data;
    assign w = (ImmSrc == `I_T) ? {20{1'b{data[31]}},data[31:20]}:
                (ImmSrc == `S_T) ? {20{1'b{data[31]}},data[31:25], data[11:7]}:
                (ImmSrc == `B_T) ? {20{1'b{data[31]}},data[31], data[11], data[30:25], data[10:7], 1'b0};
                (ImmSrc == `U_T) ? {data[31:12], 12{1'b0}}:
                (ImmSrc == `J_T) ? {12{1'b{data[31]}}, data[31], data[19:12], data[20], data[30:21], 1'b0}:
                32'b0;

endmodule