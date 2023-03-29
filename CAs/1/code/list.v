`define BITS(x) $rtoi($ceil($clog2(x)))


module list (CLK, RST, push, en_read, data_in, read_done, data_out);

    parameter MAX_LENGTH = 256;
    parameter WIDTH = 2;

    input CLK, RST, push, en_read;
    input [WIDTH - 1:0] data_in;
    output read_done;
    output [WIDTH - 1:0] data_out;
    reg read_done;

    reg [WIDTH - 1:0] list [0: MAX_LENGTH - 1];
    reg [`BITS(MAX_LENGTH) - 1:0] ptr, last_ptr, length;
    reg reading;

    always @(posedge CLK or posedge RST)
    begin
        if (RST) begin
            ptr <= 0;
            last_ptr <= 0;
            length <= 0;
            reading <= 0;
            read_done <= 0;
        end

        else if (push && (length < MAX_LENGTH)) begin
            list[length] <= data_in;
            length <= length + 1;
        end

        else if (en_read && !reading && (length > 0)) begin
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
