`timescale 1ns/1ns

module datapath(input CLK,RST,init_x,init_y,ld_x,ld_y,ld_count,init_count,en_count,list_push,en_read,
    init_list,init_stack,stack_dir_push,stack_dir_pop,r_update,output [3:0] x,y,output finish,empty_stack,list_empty,complete_read,Co);
    wire [3:0] mux1,mux2,mux3;
    reg [2:0] counter;
    wire slc_mux,
    wire [3:0] num2add = {1,r_update^counter[1]};
    


endmodule