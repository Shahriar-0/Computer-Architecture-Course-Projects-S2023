module HazardUnit(Rs1D, Rs2D, RdE, RdM, RdW, Rs2E, Rs1E,
                 PCSrcE, resultSrc0, regWriteW,
                 regWriteM, stallF, stallD, flushD,
                 flushE, forwardAE, forwardBE);

    input [4:0] Rs1D, Rs2D, RdE, RdM, RdW, Rs1E, Rs2E;
    input [1:0] PCSrcE;
    input regWriteM, regWriteW, resultSrc0;
    output reg [1:0] forwardAE, forwardBE;
    output reg stallF, stallD, flushD, flushE;

    // assign forwardAE = ((Rs1E == RdM) && regWriteM && (Rs1E != 5'b0)) ? 2'b10:
                    //    ((Rs1E == RdW) && regWriteW && (Rs1E != 5'b0)) ? 2'b01: 2'b00;

    always @(Rs1E or RdM or RdW or regWriteM or regWriteW) begin
        if(Rs1E == 5'b0)
            forwardAE <= 2'b00;
        else if((Rs1E == RdM) && regWriteM)
            forwardAE <= 2'b10;
        else if((Rs1E == RdW) && regWriteW)
            forwardAE <= 2'b01;
        else 
            forwardAE <= 2'b00;
    end    

    // assign forwardBE = ((Rs2E == RdM) && regWriteM && (Rs2E != 5'b0)) ? 2'b10:
    //                    ((Rs2E == RdW) && regWriteW && (Rs2E != 5'b0)) ? 2'b01: 2'b00;

    always @(Rs2E or RdM or RdW or regWriteM or regWriteW) begin
        if(Rs2E == 5'b0)
            forwardBE <= 2'b00;
        else if((Rs2E == RdM) && regWriteM)
            forwardBE <= 2'b10;
        else if((Rs2E == RdW) && regWriteW)
            forwardBE <= 2'b01;
        else 
            forwardBE <= 2'b00;
    end 
                                
    reg lwStall;
    assign lwStall = ((((Rs1D == RdE) || (Rs2D == RdE)) && resultSrc0)) ? 1'b1 : 1'b0;

    assign stallF = lwStall;
    assign stallD = lwStall;

    assign flushD = (PCSrcE != 2'b00) ? 1'b1 : 1'b0 ;
    assign flushE = lwStall || (PCSrcE != 2'b00);

endmodule

