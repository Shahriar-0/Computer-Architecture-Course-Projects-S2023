module MazeMemory(clk, X, Y, D_in, RD, WR, D_out);
    parameter N = 4;
    parameter FILENAME = "maze.dat";
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    input [N - 1:0] X, Y;
    input D_in, RD, WR, clk;
    output reg D_out;

    reg [0:WIDTH - 1] maze [0:HEIGHT - 1];

    initial begin
        $readmemh(FILENAME, maze);
    end
    
    always @(posedge clk, posedge RD) begin 
        if(WR)
            maze[Y][X] = D_in;
        else if (RD)
            D_out = maze[Y][X];
    end
endmodule