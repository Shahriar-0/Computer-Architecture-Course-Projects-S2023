module inc_dec(a, dec_en, w, invalid);
    parameter N = 4;
    input [N - 1:0] a;
    input dec_en;
    output reg [N - 1:0] w;

    output reg invalid;
    always @(a, dec_en) begin
        if(((~|a) && dec_en == 1'b1) || ( &a && dec_en == 1'b0))
            invalid <= 1'b1;
        else 
            invalid <= 1'b0;
            
        w <= (dec_en) ? a - 1 : a + 1;
     end
    
endmodule