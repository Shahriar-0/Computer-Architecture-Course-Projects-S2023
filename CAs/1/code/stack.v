`define BITS(x) $rtoi($ceil($clog2(x)))

module stack(CLK, RST,init, pop, push, empty, din, dout);

    parameter WIDTH = 2;
    parameter DEPTH = 256;

    input CLK, RST, pop, push, init;
    input [WIDTH - 1:0] din;

    output [WIDTH - 1:0] dout;
    output empty;

    reg [WIDTH - 1:0] stack [DEPTH - 1:0];
    reg [`BITS(DEPTH) - 1:0] index, next_index; 
    reg [WIDTH - 1:0] dout, next_dout;

    wire empty;
    assign empty = !(|index);


    always @(posedge CLK or posedge RST) begin

        if(RST || init) begin
            next_dout  = 8'd0;
            next_index = 1'b0;
        end

        else if(push) begin
            stack[index] = din;
            next_index   = index + 1'b1;
        end

        else if(pop) begin
            next_dout  = stack[index - 1'b1];
            next_index = index - 1'b1;
        end
        
        else begin
            next_dout  = dout;
            next_index = index;
        end

        dout  = next_dout;
        index = next_index;
    end

endmodule