`timescale 1ns/1ns

module datapath(CLK, RST, init_x, init_y, ld_x, ld_y, ld_count, init_count, en_count, list_push, en_read, init_list, init_stack, stack_dir_push, stack_dir_pop, r_update, x, y, Move, finish, empty_stack, list_empty, complete_read, Co);
    
    // externall signals
    input CLK;
    input RST;
    input init_x;
    input init_y;
    input ld_x;
    input ld_y;
    input ld_count;
    input init_count;
    input en_count;
    input list_push;
    input en_read;
    input init_list;
    input init_stack;
    input stack_dir_push;
    input stack_dir_pop;
    input r_update;
    //--
    output [3:0] x;
    output [3:0] y;
    output [1:0] Move;
    output finish;
    output empty_stack;
    // output list_empty;   // TODO: ask elahe
    output complete_read;
    output Co;
    
    // internall wires
    wire [3:0] mux1, mux2, mux3;
    reg [2:0] counter;
    wire slc_mux;
    wire [3:0] num2add;
    assign num2add = {1, r_update^counter[1]};
    wire [1:0] stackp;
    reg [3:0] add_res;
    wire fa_co;

    // modules instances
    mux2in mux_1(.a(x), .b(add_res), .slc(slc_mux), .w(mux1));
    mux2in mux_2(.a(add_res), .b(y), .slc(slc_mux), .w(mux2));
    mux2in mux_3(.a(x), .b(y), .slc(slc_mux), .w(mux3));
    fulladder FA(.a(mux3)., (num2add)b, .cin(1'b0), .w(add_res), .cout(fa_co));
    register regx(.prl(mux1), .CLK(CLK), .RST(RST), .ld(ld_x), .init(init_x), .W(x));
    register regy(.prl(mux2), .CLK(CLK), .RST(RST), .ld(ld_y), .init(init_y), .W(y));
    counter2bit counter2b(.init(init_count), .ld(ld_count), .en(en_count), .RST(RST), .CLK(CLK), .prl(stackp), .out(counter), .co(Co));
    stack stackk( .CLK(CLK), .RST(RST), .pop(stack_dir_pop), .push(stack_dir_push), .empty(empty_stack), .din(counter), .dout(stackp));
    list liist(.clk(CLK),.rst(RST),.push(list_push),.en_read(en_read),.data_in(stackp),.read_done(complete_read),.data_out(Move));
    assign finish = (&x) & (&y);

endmodule