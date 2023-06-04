module HazardUnit (IFIDRs1, IFIDRs2, IDExRt, IDExmemRead, PcWrite, IFIDLoad, IDExFlush);
    input [4:0] IFIDRs1, IFIDRs2, IDExRt;
    input IDExmemRead;
    output reg PcWrite, IFIDLoad, IDExFlush;

    always @(IFIDRs1, IFIDRs2, IDExRt, IDExmemRead) begin
        {PcWrite, IFIDLoad, IDExFlush} = 3'b110;
        if (IDExmemRead == 1'b1 && (IDExRt == IFIDRs1 || IDExRt == IFIDRs2) && IDExRt != 5'd0)
            {PcWrite, IFIDLoad, IDExFlush} = 3'b001;
    end
endmodule
