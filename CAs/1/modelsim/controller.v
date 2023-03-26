`timescale 1ns/1ns

module controller(input CLK,RST,start,Run,co,found,stack_empty,end_fifo,dout
	output init_x,init_y,init_c,en_c,ldc,ldx,ldy, ld_maze,WR,RD,Din,stack_pop,
	fifo_push,fifo_pop,init_read_ptr,stack_push,Done,Fail,Move);

	parameter  idle = 5'b00000,init = 5'b00001 , load_maze = 5'b00010 , w_memory = 5'b00011,init_s =5'b00100;
	parameter push_stack = 5'b00101,make_wall = 5'b00110,update_xy = 5'b00111,founded = 5'b01000,check_wall = 5'b01001;
	parameter pop_stack = 5'01010,update_reverse = 5'b01011,free_loc = 5'b01100,chack_bt = 5'b01101,next_dir =5'b01110;
	parameter fail = 5'b01111,fifow = 5'b10000,done = 5'b10001,show = 5'b10010;

	wire [4:0] pstate = idle;
	wire [4:0] nstate;
	reg init_cc = 1'b0;
	reg en_c_co;
	wire c_co;
	always @(Run,start,co,pstate){

		case pstate:
			idle: nstate <= init ? start : idle;
			init: nstate <= load_maze ? ~start : init;{init_x,init_y,init_c,init_cc}=4'b1;
			load_maze: nstate <= w_memory; ld_maze = 1'b1;
			// in w_memory irad dare
			w_memory: nstate <= init_s ? c_co ? w_memory; {WR,en_c_co}= 1'b1;
			init_s : nstate <= push_stack; stack_push = 1'b1;
			make_wall: nstate <= update_xy; {WR,Din}= 2'b1;
			update_xy: nstate <= founded;{ldx,ldy}= 1'b1;
			founded: nstate <= fifow ? found : check_wall;RD= 1'b1;
			check_wall:; nstate <= pop_stack ? dout : init;RD= 1'b1
			pop_stack: nstate<= update_reverse?~stack_empty : fail ;{ldc,stack_pop}= 1'b1;
			update_reverse: nstate<= free_loc; {ldx,ldy}= 1'b1;
			free_loc: nstate <= chack_bt; WR 1'b1,Din = 1'b0;
			chack_bt: nstate <= next_dir?~co : pop_stack;
			next_dir: nstate <= push_stack; en_c = 1'b1;
			fail : nstate <= init ? RST : fail;Fail = 1'b1;
			// fifow ham irad dare
			fifow : nstate <= stack_empty ? done : fifow; {stack_pop,fifo_push}= 2'b1;
			done : nstate <= show ? Run  : done; {Done,init_read_ptr}=2'b1;
			show : nstate <= done ? fifo_empty : show; fifo_read = 1'b1;
	}

	reg counter = 8'b0;
	always @(CLK,RST){
		if(RST) 
			{c_co,counter} <= 9'b0;
		else if(en_c_co)
			{c_co,counter} = counter + 1;

	}
	