`timescale 1ns/1ns

module Stack( CLK, RST, pop, push, empty, din, dout);

    parameter WIDTH = 4;
    parameter DEPTH = 256;

    input CLK;
    input RST;
    input pop;
    input push;
    input [WIDTH-1:0]din;

    output [WIDTH-1:0]dout;
    output empty;
    output full;

    reg [WIDTH-1:0]stack[DEPTH-1:0];
    reg [WIDTH-1:0]index, next_index; 
    reg [WIDTH-1:0]dout, next_dout;

    wire empty;

    // always @ (posedge CLK) //Sequential block
    //     begin
        // if(RST)
        //     begin
        //         dout  <= 8'd0;
        //         index <= 1'b0;
        //     end
        // else
        //     begin
        //         dout  <= next_dout;
        //         index <= next_index;
        //     end
        // end

    assign empty = !(|index);


    always @ (posedge CLK)
        begin
        if(RST)
            begin
                dout  <= 8'd0;
                index <= 1'b0;
            end
        else if(push)
            begin
            stack[index] = din;
            next_index   = index+1'b1;
            end
        else if(pop)
            begin
            next_dout  = stack[index-1'b1];
            next_index = index-1'b1;
            end
        else
            begin
            next_dout  = dout;
            next_index = index;
            end
        dout  <= next_dout;
        index <= next_index;
        end
endmodule