module intelligent_rat(CLK, RST, Run, Start, Fail, Done,
     Move, X, Y, D_in, D_out, RD, WR);

    input CLK, RST, Run, Start, D_out;

    output D_in, Fail, Done;
    output [1:0] Move;
    output [3:0] X, Y;

    wire init_x, init_y;
    wire ld_x, ld_y;
    wire ld_count, en_count;
    wire list_push, en_read;
    wire init_list, init_stack;
    wire stack_dir_push, stack_dir_pop;
    wire r_update;
    wire finish, empty_stack, complete_read, Co;


    // ok i'm officialy too old for this shit
    datapath dp(.CLK(CLK), .RST(RST), .init_x(init_x), .init_y(init_y), .ld_x(ld_x), .ld_y(ld_y), .ld_count(ld_count), .init_count(init_count), .en_count(en_count), .list_push(list_push), .en_read(en_read), .init_list(init_list), .init_stack(init_stack), .stack_dir_push(stack_dir_push), .stack_dir_pop(stack_dir_pop), .r_update(r_update), .X(X), .Y(Y), .Move(Move), .finish(finish), .empty_stack(empty_stack), .read_done(complete_read), .Co(Co));


    controller cu(CLK(CLK), .RST(RST), .start(Start), .Run(Run), .Co(Co), .found(found), .stack_empty(stack_empty), .complete_read(complete_read), .D_out(D_out), 
	init_x(init_x), .init_y(init_y), .init_count(init_count), .en_count(en_count), .ldc(ld_count), .ldx(ld_x), .ldy(ld_y), .WR(WR), .RD(RD), .D_in(D_in), .stack_pop(stack_dir_pop), .stack_push(stack_dir_push)
	list_push(list_push), .en_read(en_read), .init_list(init_list), .Done(Done), .Fail(Fail), .Move(Move));

endmodule