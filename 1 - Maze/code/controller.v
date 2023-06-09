`define idle	            5'b00000             
`define init                5'b00001             
`define init_search         5'b00010                    
`define add_to_stack        5'b00011                     
`define update_xy           5'b00100                  
`define make_wall           5'b00101                  
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


module controller(clk, rst, start, Run, Co, found, empty_stack, Done,
				  complete_read, D_out, init_x, init_y, init_count, Fail,
				  en_count, ldc, ldx, ldy, WR, RD, D_in,init_stack, stack_pop,
				  stack_push, r_update, list_push, en_read, init_list, invalid);

	input clk, rst, start, Run, Co, found,
		  empty_stack, complete_read, D_out, invalid;

	output reg init_x, init_y, init_count, en_count,
		   ldc, ldx, ldy, WR, RD, D_in, Done, 
		   list_push, en_read, init_list, Fail,
		   init_stack,stack_push, stack_pop,
		   r_update;

	reg [4:0] pstate = `idle;
	reg [4:0] nstate = `idle;

	always @(Run or start or Co or pstate or D_out or complete_read or empty_stack or found or invalid) begin
		case (pstate)
			`idle:                nstate <= ~start? `idle : `init;                        
			`init:                nstate <= ~start? `init_search : `init;                        
			`init_search:         nstate <= `make_wall;                        
			`make_wall:           nstate <= ~invalid? `add_to_stack : `free_loc_check_bt;                        
			`add_to_stack:        nstate <= `update_xy;                       
			`update_xy:           nstate <= `check_goal;                        
			`check_goal:          nstate <= found ? `stack_read : `check_wall;                       
			`check_wall:          nstate <= D_out ? `check_empty_stack : `init_search;                        
			`check_empty_stack:   nstate <= empty_stack ? `fail : `pop_stack;                        
			`pop_stack:           nstate <= `reload_counter;                         
			`reload_counter:      nstate <= `update_reverse;                        
			`update_reverse:      nstate <= `free_loc_check_bt;                       
			`free_loc_check_bt:   nstate <= Co ? `check_empty_stack : `change_dir;                       
			`change_dir:          nstate <= `make_wall;                        
			`fail:                nstate <= `fail;                        
			`stack_read:          nstate <= `update_list;                       
			`update_list:         nstate <= ~empty_stack ? `stack_read : `done;                        
			`done:                nstate <= Run ? `show : `done;                        
			`show:                nstate <= complete_read ? `done : `show;            
		endcase
	end

	always @(pstate) begin
		{init_x, init_y, init_count,init_stack, en_count, ldc, ldx, ldy,
		WR, RD, D_in, stack_pop, list_push, en_read, init_list,
		r_update , stack_push, Done, Fail} = 19'b0;
		case (pstate)
			`init             : begin init_x = 1'b1; init_y = 1'b1; 
							    init_list = 1'b1; init_stack = 1'b1; 
								init_count= 1'b1; end           
			`init_search	  : begin init_count = 1'b1; end
			`make_wall		  : begin WR = 1'b1; D_in = 1'b1; end
 			`add_to_stack	  : begin stack_push = 1'b1; end
			`update_xy		  :  begin ldx = 1'b1; ldy = 1'b1; end
			`check_goal		  :  begin RD = 1'b1 ; end 
			`pop_stack		  : begin stack_pop = 1'b1; end  
			`reload_counter	  : begin ldc = 1'b1; end   
			`update_reverse	  : begin ldx = 1'b1; ldy = 1'b1; r_update = 1'b1; end
			`free_loc_check_bt: begin WR = 1'b1; end
			`change_dir       : begin en_count = 1'b1; end 
			`fail			  : begin Fail = 1'b1; end 
			`stack_read		  : begin stack_pop = 1'b1 end;
			`update_list	  : begin list_push = 1'b1; end
			`done			  : begin Done = 1'b1; end 
			`show			  : begin en_read = 1'b1; Done = 1'b1; end 
		endcase
	end

	always @(posedge clk or posedge rst) begin
		if (rst)
			pstate <= `idle;
		else 
			pstate <= nstate;
	end
	
endmodule