`define I_T 3'b000
`define S_T 3'b001
`define B_T 3'b010
`define J_T 3'b011
`define U_T 3'b100

module ImmExtension(immSrc, data, w);

    input [2:0] immSrc;
    input [24:0] data;
    assign w = (immSrc == `I_T) ? {20{1'b{data[31]}},data[31:20]}:
                (immSrc == `S_T) ? {20{1'b{data[31]}},data[31:25], data[11:7]}:
                (immSrc == `B_T) ? {20{1'b{data[31]}},data[31], data[11], data[30:25], data[10:7], 1'b0};
                (immSrc == `U_T) ? {data[31:12], 12{1'b0}}:
                (immSrc == `J_T) ? {12{1'b{data[31]}}, data[31], data[19:12], data[20], data[30:21], 1'b0}:
                32'b0;

    always @(immSrc, data) begin
        case(immSrc) begin
            // TODO: check
            `I_T: w <= {20{data[31]}, data[31:20]};
            `S_T: w <= {20{data[31]}, data[31:25], data[11:7]};
            `J_T: w <= {data[31], data[19:12], data[20], data[30:21], 1'b0};
            `B_T: w <= {20{data[31]}, data[31], data[11], data[30:25], data[10:7], 1'b0};
            `U_T: w <= {data[31:12], 12{1'b0}};
            default: w <= 32'b0;
        endcase
    end

endmodule