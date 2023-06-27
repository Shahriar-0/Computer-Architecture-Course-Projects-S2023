`timescale 1ns / 1ns

module tb();
    reg Start, Run, clk, rst;
    wire Fail, Done,D_in, D_out, RD, WR;
    wire [3:0] X,Y;
    wire [1:0] Move;
    
    IntelligentRat rat(
        .clk(clk), .rst(rst), .Run(Run), .Start(Start),
        .Fail(Fail), .Done(Done), .Move(Move), .X(X), .Y(Y), 
        .D_in(D_in), .D_out(D_out), .RD(RD), .WR(WR)
    );

    MazeMemory maze(
        .clk(clk), .X(X), .Y(Y), .D_in(D_in), 
        .RD(RD), .WR(WR), .D_out(D_out)
    );

    always #5 clk = ~clk;

    initial begin
        {Start, Run, clk, rst} = 4'b0;
        #30 Start = 1'b1;
        #30 Start = 1'b0;
        #40000 Run = 1'b1;
        #10 Run = 1'b0;
        #3000
        #200 rst = 1'b1;
        #200 rst = 1'b0;
        #10 $stop;
    end

endmodule