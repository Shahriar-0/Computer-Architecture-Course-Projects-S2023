module inc_dec(a, dec_en, w,cout, invalid);
    parameter N = 4;
    input [N - 1:0] a, b;
    input dec_en;
    output reg [N - 1:0] w;
    output reg cout;
    output reg invalid;
    always @(a,dec_en) begin
        if((a == N{1'b0} && dec_en == 1'b1) || (a == N{1'b1} && dec_en == 1'b0))
            invalid <= 1'b1;
        else {cout,w} <=  (dec_en) ? a - 1 : a + 1;
     end
    
endmodule