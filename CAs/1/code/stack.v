`define BITS(x) $rtoi($ceil($clog2(x)))

module stack(CLK, RST, init, pop, push, empty, d_in, d_out);

    parameter WIDTH = 2;
    parameter DEPTH = 256;

    input CLK, RST, pop, push, init;
    input [WIDTH - 1:0] d_in;

    output [WIDTH - 1:0] d_out;
    output empty;

    reg [WIDTH - 1:0] stack [DEPTH - 1:0];
    reg [`BITS(DEPTH) - 1:0] index, next_index; 
    reg [WIDTH - 1:0] d_out, next_d_out;

    wire empty;
    assign empty = !(|index);


    always @(posedge CLK , posedge RST) begin

        if(RST || init) begin
            next_d_out  = 8'd0;
            next_index = 1'b0;
        end

        else if(push) begin
            stack[index] = d_in;
            next_index   = index + 1'b1;
        end

        else if(pop) begin
            next_d_out  = stack[index - 1'b1];
            next_index = index - 1'b1;
        end
        
        else begin
            next_d_out  = d_out;
            next_index = index;
        end

        d_out  = next_d_out;
        index = next_index;
    end

endmodule