`timescale 1ns / 1ns

`include "intelligent_rat.v"
`include "maze_memory.v"

module tb();
    wire Start, Run, CLK, RST, Fail, Done, Move, X, Y, D_in, D_out, RD, WR;

    intelligent_rat rat(
        .CLK(CLK), .RST(RST), .Run(Run), .Start(Start),
        .Fail(Fail), .Done(Done), .Move(Move), .X(X), .Y(Y), 
        .D_in(D_in), .D_out(D_out), .RD(RD), .WR(WR)
    );

    maze_memory maze(
        .X(X), .Y(Y), .D_in(D_in), .RD(RD), .WR(WR), .D_out(D_out)
    );

    always #5 CLK = ~CLK;

    initial begin
        {Start, Run, CLK, RST} = 4'b0;
        #30 Start = 1'b0;
        #30 Start = 1'b1;
        #700 Run = 1'b1;
        #10 Run = 1'b0;
        #200 RST = 1'b1;
        #200 RST = 1'b0;
        $finish
    end

endmodule