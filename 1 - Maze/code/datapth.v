
module datapath(clk, rst, init_x, init_y, ldx, ldy, ld_count, Co,
                init_count, en_count, list_push, en_read, init_list,
                init_stack, stack_dir_push, stack_dir_pop, r_update,
                X, Y, Move, found, empty_stack, complete_read, invalid);
    
    parameter DIRECTION_SIZE = 2;
    parameter N = 4;

    input clk, rst, init_x, init_y, ldx, ldy, ld_count,
          init_count, en_count, list_push, en_read, init_list,
          init_stack, stack_dir_push, stack_dir_pop, r_update;

    output [N - 1:0] X, Y, add_res;
    output [DIRECTION_SIZE - 1:0] Move, stackp;
    output found, empty_stack, complete_read, Co, invalid;
    
    wire [N - 1:0] mux1, mux2, mux3;
    wire [DIRECTION_SIZE-1:0] counter;
    wire slc_mux, dec_en, fa_co;
    
    assign dec_en = r_update ^ (~counter[0]);
    assign slc_mux = ^counter;


    mux2in mux_1(.a(X), .b(add_res), .slc(slc_mux), .w(mux1));
    mux2in mux_2(.a(add_res), .b(Y), .slc(slc_mux), .w(mux2));
    mux2in mux_3(.a(Y), .b(X), .slc(slc_mux), .w(mux3));

    inc_dec inc_dec_instance(.a(mux3), .dec_en(dec_en), .w(add_res), .invalid(invalid));

    register regx(.prl(mux1), .clk(clk), .rst(rst), .ld(ldx), .init(init_x), .W(X));
    register regy(.prl(mux2), .clk(clk), .rst(rst), .ld(ldy), .init(init_y), .W(Y));

    counter2bit counter2b(
        .init(init_count), .ld(ld_count), .en(en_count), .rst(rst),
        .clk(clk), .prl(stackp), .out(counter), .Co(Co)
    );

    stack direction_stack(
        .clk(clk), .rst(rst), .pop(stack_dir_pop), .push(stack_dir_push),
        .init(init_stack), .empty(empty_stack), .d_in(counter), .d_out(stackp)
    );

    list result_list(
        .clk(clk), .rst(rst), .push(list_push), .init(init_list), .en_read(en_read), 
        .data_in(stackp), .complete_read(complete_read), .data_out(Move)
    );

    assign found = &{X, Y};

endmodule