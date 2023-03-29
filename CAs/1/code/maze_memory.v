module maze_memory(X, Y, D_in, RD, WR, D_out);
    parameter N = 4;
    parameter FILENAME = "maze.dat";
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    input [N - 1:0] X, Y;
    input D_in, RD, WR;
    output D_out;

    reg [0:WIDTH - 1] maze [0:HEIGHT - 1];

    initial begin
        $readmemh(FILENAME, maze);
    end
    
    assign D_out = (RD) ? maze[X][Y] : D_out;
    assign maze[X][Y] = (WR) ? D_in : maze[X][Y];

endmodule