`timescale 1ns / 1ns

module tb();
    reg Start, Run, CLK, RST;
    wire Fail, Done,D_in, D_out, RD, WR;
    wire [3:0] X,Y;
    wire [1:0] Move;
    intelligent_rat rat(
        .CLK(CLK), .RST(RST), .Run(Run), .Start(Start),
        .Fail(Fail), .Done(Done), .Move(Move), .X(X), .Y(Y), 
        .D_in(D_in), .D_out(D_out), .RD(RD), .WR(WR)
    );

    maze_memory maze(
        .clk(CLK), .X(X), .Y(Y), .D_in(D_in), .RD(RD), .WR(WR), .D_out(D_out)
    );

    always #5 CLK = ~CLK;

    initial begin
        {Start, Run, CLK, RST} = 4'b0;
        #30 Start = 1'b1;
        #30 Start = 1'b0;
        #50000 Run = 1'b1;
        #10 Run = 1'b0;
	#1000
        #200 RST = 1'b1;
        #200 RST = 1'b0;
        #10 $stop;
    end

endmodule