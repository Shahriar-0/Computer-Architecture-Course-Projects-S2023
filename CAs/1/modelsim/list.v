`timescale 1ns/1ns

module list (input clk,rst,push,en_read,input [7:0] data_in, output reg read_done, output [7:0] data_out);

    parameter MAX_LENGTH = 256;
    parameter WIDTH = 4;
    reg [WIDTH-1:0] list [0:MAX_LENGTH-1];
    reg [8:0] ptr;
    reg [8:0] last_ptr;
    reg [8:0] length;
    reg reading;

    // always @ (posedge clk or posedge rst)
    always @ (posedge clk)
    begin
        if (rst) begin
            ptr <= 0;
            last_ptr <= 0;
            length <= 0;
            reading <= 0;
            read_done <= 0;
        end
    end

    always @ (posedge clk)
    begin
        if (push && (length < MAX_LENGTH)) begin
            list[length] <= data_in;
            length <= length + 1;
        end
    end

    always @ (posedge clk)
    begin
        if (en_read && !reading && (length > 0)) begin
            ptr <= length - 1;
            last_ptr <= length - 1;
            reading <= 1;
            read_done <= 0;
        end
        else if (reading && (ptr >= 0)) begin
            data_out <= list[ptr];
            ptr <= ptr - 1;
        end
        else if (reading && (ptr < 0)) begin
            ptr <= last_ptr;
            reading <= 0;
            read_done <= 1;
        end
    end
endmodule
