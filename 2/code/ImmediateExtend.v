module ImmExtension(input[2:0] ImmSrc, input [24:0] data, output [31:0] w);

        assign w = (ImmSrc == 3'b000) ? {20{1'b{data[31]}},data[31:20]}:
                   (ImmSrc == 3'b000) ? {data[31:25], data[11:7]}:
                   (ImmSrc == 3'b000) ? {data}:
                   (ImmSrc == 3'b000) ? {}:
                   (ImmSrc == 3'b000) ? {}:
                   (ImmSrc == 3'b000) ? {}:



endmodule