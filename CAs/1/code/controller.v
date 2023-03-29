// 00000
// 00001
// 00010
// 00011
// 00100
// 00101
// 00110
// 00111
// 01000
// 01001
// 01010
// 01011
// 01100
// 01101
// 01110
// 01111
// 10000
// 10001
// 10010
// 10011





module controller(CLK, RST, start, Run, Co, found, stack_empty, complete_read, D_out
	init_x, init_y, init_count, en_count, ldc, ldx, ldy, WR, RD, D_in, stack_pop, stack_push,
	list_push, en_read, init_list, Done, Fail, Move);

	input CLK, RST, start, Run, Co, found, stack_empty, complete_read, D_out;
	output init_x, init_y, init_count, en_count, ldc, ldx, ldy, WR, RD, D_in, stack_pop, list_push,
		   en_read, init_list, stack_push, Done, Fail, Move;

	parameter idle = 1, init = 2, init_search = 3,
		add_to_stack = 4, make_wall = 5, update_xy = 6, check_goal = 7, check_wall = 8,
		check_empty_stack = 9, pop_stack = 10, reload_counter = 11, update_reverse = 12, 
		free_loc_check_bt = 13, change_dir = 14, fail = 15, stack_read = 16,
		update_list = 17, done = 18, show = 19;

	wire [4:0] pstate = idle;
	wire [4:0] nstate;

	always @(Run, start, Co, pstate, D_out, complete_read, empty_stack, found){
		{init_x, init_y, init_count, en_count, ldc, ldx, ldy, WR, RD, D_in, stack_pop, 				list_push, en_read, init_list, stack_push, Done, Fail, Move} = 18'b0;
		
		case pstate:
			
			idle: nstate <= ~start? idle : init;
			
			init: begin 
				nstate <= ~start ? init_search : init; 
				{init_x, init_count, init_y, init_list, init_stack} = 5'b1;
			end
			
			init_search: begin nstate <= add_to_stack; init_count = 1'b1; end
			
			add_to_stack: begin nstate <= make_wall; stack_dir_push = 1'b1 end
			
			make_wall: begin
				nstate <= update_xy;
				{WR, D_in} = 2'b1;
			end

			update_xy: nstate <= check_goal;

			check_goal: nstate <= found ? stack_read : check_wall;

			check_wall: begin 
				nstate <= D_out ? check_empty_stack : init_search;
				RD = 1'b1;
			end

			check_empty_stack: nstate <= empty_stack ? fail : pop_stack;

			pop_stack: begin nstate <= reload_counter; stack_dir_pop = 1'b1; end
			
			reload_counter: begin nstate <= update_reverse; ld_count = 1'b1; end

			update_reverse: begin 
				nstate <= free_loc_check_bt;
				{ld_x, ld_y, r_update} = 3'b1;
			end

			free_loc_check_bt: begin  nstate <= Co ? fail : pop_stack; WR = 1'b1; end 

			change_dir: begin nstate <= add_to_stack; en_count = 1'b1; end

			stack_read: begin nstate <= update_list; stack_dir_pop = 1'b1; end

			update_list: begin
				nstate <= ~empty_stack ? stack_read : done; 
				list_push = 1'b1; 
			end

			done: begin 
				nstate <= Run ? show : done;
				{Done, en_read} = 2'b1;
			end

			show: begin 
				nstate <= complete_read ? done : show;
				en_read = 1'b1;
			end

		endcase	
	}

	always @(posedge CLK or posedge RST) begin
		if (RST)
			pstate <= idle;
		else 
			pstate <= nstate;
	end
	
endmodule

