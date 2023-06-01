`define I_T 3'b000
`define S_T 3'b001
`define J_T 3'b010
`define B_T 3'b011
`define U_T 3'b100

module ImmExtension(ImmSrc, data, w);

    input [2:0] ImmSrc;
    input [24:0] data;

    output [31:0] w;

    always@(ImmSrc) begin
        case(ImmSrc) begin
            `I_T: w <= {20{data[31]}, data[31:20]};
            `S_T: w <= {20{data[31]}, data[31:25], data[11:7]};
            `J_T: w <= {data[31], data[19:12], data[20], data[30:21], 1'b0};
            `B_T: w <= {20{data[31]}, data[31], data[11], data[30:25], data[10:7], 1'b0};
            `U_T: w <= {data[31:12], 12{1'b0}};
            default: w <= 32'b0;
        endcase
    end

endmodule