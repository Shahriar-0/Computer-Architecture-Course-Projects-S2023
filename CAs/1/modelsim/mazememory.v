`timescale 1ns/1ns

module MazeMemory(x, y, D_in, RD, WR , init_maze, D_out);
    parameter N = 4;
    parameter FILENAME = "maze.dat";
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    input [N - 1:0] x;
    input [N - 1:0] y;
    input D_in;
    input RD;
    input WR;
    input init_maze;
    output D_out;

    reg [0:WIDTH - 1] maze [0:HEIGHT - 1];

    initial begin
        $readmemh(FILENAME, maze);
    end
    
    assign D_out = (RD) ? maze[x][y] : D_out;
    assign maze[x][y] = (WR) ? D_in : maze[x][y];

endmodule