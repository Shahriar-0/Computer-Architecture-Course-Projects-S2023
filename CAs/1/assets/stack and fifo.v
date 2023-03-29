module Stack(
 clk,
 rstn,
 pop,
 push,
 empty,
 full,
 din,
 dout
    );

parameter WIDTH = 8;
parameter DEPTH = 8;

input clk;
input rstn;
input pop;
input push;
input [WIDTH-1:0]din;

output [WIDTH-1:0]dout;
output empty;
output full;

reg [WIDTH-1:0]stack[DEPTH-1:0]; //memory
reg [WIDTH-1:0]index, next_index; 
reg [WIDTH-1:0]dout, next_dout;

wire empty, full;

always @ (posedge clk) //Sequential block
begin
  if(!rstn)
  begin
    dout  <= 8'd0;
    index <= 1'b0;
  end
  else
  begin
    dout  <= next_dout;
    index <= next_index;
  end
end

assign empty = !(|index);
assign full  = !(|(index ^ DEPTH));

always @ (*) //Combinational Block
begin
  if(push) //write
  begin
  stack[index] = din;
  next_index   = index+1'b1;
  end
  else if(pop)  //read
  begin
  next_dout  = stack[index-1'b1];
  next_index = index-1'b1;
  end
  else
  begin
  next_dout  = dout;
  next_index = index;
  end
 
end
endmodule





















module fifo #(
    parameter WIDTH = 4,
    parameter DEPTH = 4
)(
    input [WIDTH-1:0] data_in,
    input wire clk,
    input wire write,
    input wire read,
    output reg [WIDTH-1:0] data_out,
    output wire fifo_full,
    output wire fifo_empty,
    output wire fifo_not_empty,
    output wire fifo_not_full
);

    // memory will contain the FIFO data.
    reg [WIDTH-1:0] memory [0:DEPTH-1];
    // $clog2(DEPTH+1)-2 to count from 0 to DEPTH
    reg [$clog2(DEPTH)-1:0] write_ptr;
    reg [$clog2(DEPTH)-1:0] read_ptr;

    // Initialization
    initial begin
    
        // Init both write_cnt and read_cnt to 0
        write_ptr = 0;
        read_ptr = 0;

        // Display error if WIDTH is 0 or less.
        if ( WIDTH <= 0 ) begin
            $error("%m ** Illegal condition **, you used %d WIDTH", WIDTH);
        end
        // Display error if DEPTH is 0 or less.
        if ( DEPTH <= 0) begin
            $error("%m ** Illegal condition **, you used %d DEPTH", DEPTH);
        end

    end // end initial

    assign fifo_empty   = ( write_ptr == read_ptr ) ? 1'b1 : 1'b0;
    assign fifo_full    = ( write_ptr == (DEPTH-1) ) ? 1'b1 : 1'b0;
    assign fifo_not_empty = ~fifo_empty;
    assign fifo_not_full = ~fifo_full;

    always @ (posedge clk) begin

        if ( write ) begin
            memory[write_ptr] <= data_in;
        end

        if ( read ) begin
            data_out <= memory[read_ptr];
        end

    end

    always @ ( posedge clk ) begin
        if ( write ) begin
            write_ptr <= write_ptr + 1;
        end

        if ( read && fifo_not_empty ) begin
            read_ptr <= read_ptr + 1;
        end
    end

endmodule










