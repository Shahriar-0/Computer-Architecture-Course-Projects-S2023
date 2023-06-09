`define BITS(x) $rtoi($ceil($clog2(x)))


module list (clk, rst, push, init, en_read, data_in, complete_read, data_out);

    parameter MAX_LENGTH = 256;
    parameter WIDTH = 2;

    input clk, rst, push, init, en_read;
    input [WIDTH - 1:0] data_in;
    output complete_read;
    output reg [WIDTH - 1:0] data_out;
    reg complete_read;

    reg [WIDTH - 1:0] list [0: MAX_LENGTH - 1];
    reg [`BITS(MAX_LENGTH) - 1:0] ptr, last_ptr, length;
    reg read_ing;
    integer result_file;
    always @(posedge clk or posedge rst)
    begin
        if (rst || init) begin
            ptr <= 1'b0;
            last_ptr <= 1'b0;
            length <= 1'b0;
            read_ing <= 1'b0;
            complete_read <= 1'b0;
        end

        else if (push && (length < MAX_LENGTH)) begin
            list[length] <= data_in;
            length <= length + 1;
        end

        else if (en_read && !read_ing && (length > 0)) begin
            ptr <= length - 1;
            last_ptr <= length - 1;
            read_ing <= 1'b1;
            complete_read <= 1'b0;
            result_file = $fopen("result.txt", "wb");
        end

        else if (read_ing) begin
            if (ptr >= 0) begin
                data_out <= list[ptr];
                ptr <= ptr - 1;
                $fdisplayb(result_file, data_out);
            end
            else begin
                ptr <= last_ptr;
                read_ing <= 1'b0;
                complete_read <= 1'b1;
                $fclose(result_file);
            end
        end
    end
    
endmodule
