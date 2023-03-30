`define BITS(x) $rtoi($ceil($clog2(x)))


module list (CLK, RST, push, init, en_read, data_in, complete_read, data_out);

    parameter MAX_LENGTH = 256;
    parameter WIDTH = 2;

    input CLK, RST, push, init, en_read;
    input [WIDTH - 1:0] data_in;
    output complete_read;
    output reg [WIDTH - 1:0] data_out;
    reg complete_read;

    reg [WIDTH - 1:0] list [0: MAX_LENGTH - 1];
    reg [`BITS(MAX_LENGTH) - 1:0] ptr, last_ptr, length;
    reg reading;
    integer result_file;
    always @(posedge CLK or posedge RST)
    begin
        if (RST || init) begin
            ptr <= 0;
            last_ptr <= 0;
            length <= 0;
            reading <= 0;
            complete_read <= 0;
        end

        else if (push && (length < MAX_LENGTH)) begin
            list[length] <= data_in;
            length <= length + 1;
        end

        else if (en_read && !reading && (length > 0)) begin
            ptr <= length - 1;
            last_ptr <= length - 1;
            reading <= 1;
            complete_read <= 0;
            result_file = $fopen("result.txt", "wb");
        end

        else if (reading) begin
            if (ptr >= 0) begin
                data_out <= list[ptr];
                ptr <= ptr - 1;
                $fdisplayb (result_file, data_out);
            end
            else begin
                ptr <= last_ptr;
                reading <= 0;
                complete_read <= 1;
                $fclose(errFile);
            end
        end
    end
    
endmodule
