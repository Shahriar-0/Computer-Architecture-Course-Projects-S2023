module RISC_V(clk, rst);

    input clk, rst;
    
    RISC_V_Controller CU(
    );

    RISC_V_Datapath DP(
    );
    
endmodule