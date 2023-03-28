`timescale 1ns/1ns

module mazememory(input [N-1:0] x,y , input D_in,RD,WR,init_maze,output D_out);
    parameter N = 4;
    parameter FILENAME = "maze.dat";
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    reg [WIDTH-1 : 0] maze [HEIGHT-1 : 0];

    initial begin
        $readmemh(FILENAME, maze);
    end
    if(RD)
        D_out = maze[x][y];
    if(WR)
        maze[x][y] = D_in;
endmodule