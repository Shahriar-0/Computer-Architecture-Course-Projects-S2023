
module datapath(CLK, RST, init_x, init_y, ldx, ldy, ld_count, Co,
                init_count, en_count, list_push, en_read, init_list,
                init_stack, stack_dir_push, stack_dir_pop, r_update,
                X, Y, Move, finish, empty_stack, complete_read);
    
    parameter DIRECTION_SIZE = 2;
    parameter N = 4;

    // externall signals
    input CLK, RST, init_x, init_y, ldx, ldy, ld_count,
          init_count, en_count, list_push, en_read, init_list,
          init_stack, stack_dir_push, stack_dir_pop, r_update;

    output [N - 1:0] X, Y;
    output [DIRECTION_SIZE - 1:0] Move;
    output finish,empty_stack, complete_read, Co;
    
    // internall wires
    wire [N - 1:0] mux1, mux2, mux3;
    wire [DIRECTION_SIZE-1:0] counter;
    wire slc_mux;
    
    wire [N - 1:0] num2add;
    assign num2add = {1, r_update^(~counter[0])};

    wire [DIRECTION_SIZE - 1:0] stackp;
    wire [N - 1:0] add_res;
    wire fa_co;

    // modules instances
    mux2in mux_1(.a(X), .b(add_res), .slc(slc_mux), .w(mux1));
    mux2in mux_2(.a(add_res), .b(Y), .slc(slc_mux), .w(mux2));
    mux2in mux_3(.a(X), .b(Y), .slc(slc_mux), .w(mux3));

    fulladder FA(.a(mux3), .b(num2add), .cin(1'b0), .w(add_res), .cout(fa_co));

    register regx(.prl(mux1), .CLK(CLK), .RST(RST), .ld(ldx), .init(init_x), .W(X));
    register regy(.prl(mux2), .CLK(CLK), .RST(RST), .ld(ldy), .init(init_y), .W(Y));

    counter2bit counter2b(
        .init(init_count), .ld(ld_count), .en(en_count), .RST(RST),
        .CLK(CLK), .prl(stackp), .out(counter), .Co(Co)
    );

    stack direction_stack(
        .CLK(CLK), .RST(RST), .pop(stack_dir_pop), .push(stack_dir_push),
        .init(init_stack), .empty(empty_stack), .d_in(counter), .d_out(stackp)
    );

    list result_list(
        .CLK(CLK), .RST(RST), .push(list_push), .init(init_list), .en_read(en_read), 
        .data_in(stackp), .complete_read(complete_read), .data_out(Move)
    );

    assign finish = &{X, Y};

endmodule