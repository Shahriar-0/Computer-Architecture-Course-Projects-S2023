
module intelligent_rat(CLK, RST, Run, Start,
                       Fail, Done, Move, X, Y, 
                       D_in, D_out, RD, WR);

    parameter DIRECTION_SIZE = 2;
    parameter N = 4;

    input CLK, RST, Run, Start, D_out;

    output D_in, Fail, Done, RD, WR;
    output [DIRECTION_SIZE - 1:0] Move;
    output [N - 1:0] X, Y;

    wire init_x, init_y, ld_x, ld_y, 
        ld_count, en_count, list_push,
        en_read, init_list, init_stack, 
        stack_dir_push, stack_dir_pop, 
        r_update, finish, empty_stack, 
        complete_read, Co;


    datapath dp(
        .CLK(CLK), .RST(RST), .init_x(init_x), .init_y(init_y), .ld_x(ld_x), .ld_y(ld_y),
        .ld_count(ld_count), .init_count(init_count), .en_count(en_count), .list_push(list_push),
        .en_read(en_read), .init_list(init_list), .init_stack(init_stack), .X(X), .Y(Y),                         
        .stack_dir_push(stack_dir_push), .stack_dir_pop(stack_dir_pop), .r_update(r_update),  
        .Move(Move), .finish(finish), .empty_stack(empty_stack), .read_done(complete_read), .Co(Co)
    );

    controller cu(
        .CLK(CLK), .RST(RST), .start(Start), .Run(Run), .Co(Co), .found(found), .WR(WR), .RD(RD),
        .complete_read(complete_read), .D_out(D_out), .init_x(init_x), .init_y(init_y), .ldy(ld_y), 
        .D_in(D_in), .init_count(init_count), .en_count(en_count), .ldc(ld_count), .ldx(ld_x),
        .stack_pop(stack_dir_pop), .stack_push(stack_dir_push), .list_push(list_push), .Move(Move),
        .en_read(en_read), .init_list(init_list), .Done(Done), .Fail(Fail), .stack_empty(stack_empty)
    );

endmodule