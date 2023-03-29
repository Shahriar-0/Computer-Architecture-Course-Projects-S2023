`define idle                5'b00000             
`define init                5'b00001             
`define init_search         5'b00010                    
`define add_to_stack        5'b00011                     
`define make_wall           5'b00100                  
`define update_xy           5'b00101                  
`define check_goal          5'b00110                   
`define check_wall          5'b00111                   
`define check_empty_stack   5'b01000                          
`define pop_stack           5'b01001                  
`define reload_counter      5'b01010                       
`define update_reverse      5'b01011                       
`define free_loc_check_bt   5'b01100                          
`define change_dir          5'b01101                   
`define fail                5'b01110             
`define stack_read          5'b01111                   
`define update_list         5'b10000                    
`define done                5'b10001             
`define show                5'b10010             


module controller(CLK, RST, start, Run, Co, found, stack_empty, Move,
				  complete_read, D_out, init_x, init_y, init_count,
				  en_count, ldc, ldx, ldy, WR, RD, D_in,init_stack, stack_pop,
				  stack_push, r_update, list_push, en_read, init_list, Done, Fail);

	input CLK, RST, start, Run, Co, found,
		  stack_empty, complete_read, D_out;

	output reg init_x, init_y, init_count, en_count,
		   ldc, ldx, ldy, WR, RD, D_in, Done, 
		   list_push, en_read, init_list, Fail,
		   init_stack,stack_push, stack_pop,
		   r_update, Move;
		   

	reg [4:0] pstate = `idle;
	reg [4:0] nstate;


	always @(Run or start or Co or pstate or D_out or complete_read or stack_empty or found) begin
		case (pstate)
			`idle:                nstate <= ~start? `idle : `init;                        
			`init:                nstate <= ~start? `init_search : `init;                        
			`init_search:         nstate <= `add_to_stack;                        
			`add_to_stack:        nstate <= `make_wall;                       
			`make_wall:           nstate <= `update_xy;                        
			`update_xy:           nstate <= `check_goal;                        
			`check_goal:          nstate <= found ? `stack_read : `check_wall;                       
			`check_wall:          nstate <= D_out ? `check_empty_stack : `init_search;                        
			`check_empty_stack:   nstate <= stack_empty ? `fail : `pop_stack;                        
			`pop_stack:           nstate <= `reload_counter;                         
			`reload_counter:      nstate <= `update_reverse;                        
			`update_reverse:      nstate <= `free_loc_check_bt;                       
			`free_loc_check_bt:   nstate <= Co ? `fail : `pop_stack;                       
			`change_dir:          nstate <= `add_to_stack;                        
			`fail:                nstate <= `fail;                        
			`stack_read:          nstate <= `update_list;                       
			`update_list:         nstate <= ~stack_empty ? `stack_read : `done;                        
			`done:                nstate <= Run ? `show : `done;                        
			`show:                nstate <= complete_read ? `done : `show;            
		endcase
	end

	always @(pstate) begin
		{init_x, init_y, init_count, en_count, ldc, ldx, ldy,
		WR, RD, D_in, stack_pop, list_push, en_read, init_list,
		stack_push, Done, Fail, Move} = 18'b0;
		case (pstate)
			`idle: ;             
			`init: {init_x, init_count, init_y, init_list, init_stack} = 5'b1;             
			`init_search: init_count = 1'b1;      
			`add_to_stack: stack_push = 1'b1;      
			`make_wall: {WR, D_in} = 2'b1;        
			`update_xy: ;       
			`check_goal: ;       
			`check_wall: RD = 1'b1;       
			`check_empty_stack: ;
			`pop_stack: stack_pop = 1'b1;        
			`reload_counter: ldc = 1'b1;   
			`update_reverse: {ldx, ldy, r_update} = 3'b1;  
			`free_loc_check_bt: WR = 1'b1;
			`change_dir: en_count = 1'b1;       
			`fail: Fail = 1'b1;             
			`stack_read: stack_pop = 1'b1;      
			`update_list: list_push = 1'b1;      
			`done: {Done, en_read} = 2'b1;            
			`show: en_read = 1'b1;            
		endcase
	end

	always @(posedge CLK or posedge RST) begin
		if (RST)
			pstate <= `idle;
		else 
			pstate <= nstate;
	end
	
endmodule