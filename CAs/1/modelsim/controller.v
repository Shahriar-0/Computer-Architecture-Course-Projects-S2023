`timescale 1ns/1ns

module controller(CLK,RST,start,Run,co,found,stack_empty,end_fifo,dout
	init_x,init_y,init_c,en_c,ldc,ldx,ldy, ld_maze,WR,RD,Din,stack_pop,
	fifo_push,fifo_pop,init_read_ptr,stack_push,Done,Fail,Move);

	input CLK;
	input RST;
	input start;
	input Run;
	input co;
	input found;
	input stack_empty;
	input end_fifo;
	input dout;
	output init_x;
	output init_y;
	output init_c;
	output en_c;
	output ldc;
	output ldx;
	output ldy;
	output  ld_maze;
	output WR;
	output RD;
	output Din;
	output stack_pop;
	output fifo_push;
	output fifo_pop;
	output init_read_ptr;
	output stack_push;
	output Done;
	output Fail;
	output Move;

	parameter idle = 1, init = 2, init_search = 3,
		push_stack = 4, make_wall = 5, update_xy = 6, check_goal = 7, check_wall = 8,
		check_empty_stack = 9, pop_stack = 10, reload_counter = 11, update_reverse = 12, 
		free_loc_check_bt = 13, next_dir = 14, fail = 15, stack_read = 16,
		update_list = 17, done = 18, show = 19;

	wire [4:0] pstate = idle;
	wire [4:0] nstate;
	reg init_cc = 1'b0;
	reg en_c_co;
	wire c_co;
	always @(Run, start, co, pstate){

		case pstate:
			idle: nstate <= init ? start : idle;
			init: nstate <= load_maze ? ~start : init; {init_x,init_y,init_c,init_cc} = 4'b1;
			load_maze: nstate <= w_memory; ld_maze = 1'b1;
			// in w_memory irad dare
			w_memory: nstate <= init_s ? c_co ? w_memory; {WR,en_c_co} = 1'b1;
			init_s : nstate <= push_stack; stack_push = 1'b1;
			make_wall: nstate <= update_xy; {WR, Din}= 2'b1;
			update_xy: nstate <= check_goal;{ldx, ldy}= 1'b1;
			check_goal: nstate <= fifow ? found : check_wall;RD= 1'b1;
			check_wall:; nstate <= pop_stack ? dout : init;RD= 1'b1
			pop_stack: nstate<= update_reverse? ~stack_empty : fail; {ldc,stack_pop}= 1'b1;
			update_reverse: nstate<= free_loc_check_bt; {ldx, ldy}= 1'b1;
			free_loc_check_bt: nstate <= chack_bt; WR 1'b1, Din = 1'b0;
			chack_bt: nstate <= next_dir? ~co : pop_stack;
			next_dir: nstate <= push_stack; en_c = 1'b1;
			fail : nstate <= init ? RST : fail; Fail = 1'b1;
			// fifow ham irad dare
			fifow : nstate <= stack_empty ? done : fifow; {stack_pop, fifo_push}= 2'b1;
			done : nstate <= show ? Run  : done; {Done, init_read_ptr} = 2'b1;
			show : nstate <= done ? fifo_empty : show; fifo_read = 1'b1;
		endcase	
	}

	reg counter = 8'b0;
	always @(CLK,RST){
		if(RST) 
			{c_co,counter} <= 9'b0;
		else if(en_c_co)
			{c_co,counter} = counter + 1;
	}
endmodule