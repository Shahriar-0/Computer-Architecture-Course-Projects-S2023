`define I_T 3'b000
`define S_T 3'b001
`define B_T 3'b010
`define J_T 3'b011
`define U_T 3'b100

module ImmExtension(immSrc, data, w);

    input [2:0] immSrc;
    input [24:0] data;
    
    output reg [31:0] w;

    always @(immSrc, data) begin
        case(immSrc)
            `I_T   : w <= {{20{data[24]}}, data[24:13]};
            `S_T   : w <= {{20{data[24]}}, data[24:18], data[4:0]};
            `J_T   : w <= {{12{data[24]}}, data[12:5], data[13], data[23:14], 1'b0};
            `B_T   : w <= {{20{data[24]}}, data[0], data[23:18], data[4:1], 1'b0};
            `U_T   : w <= {data[24:5], {12{1'b0}}};
            default: w <= 32'b0;
        endcase
    end

endmodule