module HazardUnit(Rs1D, Rs2D, RdE, RdM, RdW, Rs2E, Rs1E,
                 PCSrc, resultSrc0, regWriteW,
                 regWriteM, stallF, stallD, flushD,
                 flushE, forwardAE, forwardBE);

    input [4:0] Rs1D,Rs2D, RdE, RdM, RdW, Rs1E, Rs2E;
    input PCSrc, resultSrc0 ;
    input regWriteM, regWriteW;
    output stallF, stallD, flushD; 
    output flushE, forwardAE, forwardBE;

    assign forwardAE = (((Rs1E == RdM) &&  regWriteM) & (Rs1E != 5'b0)) ? 2'b10:
                       (((Rs1E == RdM) &&  regWriteW) & (Rs1E != 5'b0)) ? 2'b01: 2'b00;
    assign forwardBE = (((Rs2E == RdM) &&  regWriteM) & (Rs2E != 5'b0)) ? 2'b10:
                       (((Rs2E == RdM) &&  regWriteW) & (Rs2E != 5'b0)) ? 2'b01: 2'b00;

    reg lwStall = (((Rs1D == RdE) || (Rs2D == RdE)) && resultSrc0);

    assign stallF = lwStall;
    assign stallD = lwStalll;

    assign flushD = PCSrc;
    assign flushE = lwStall || PCSrc;

endmodule
