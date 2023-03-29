module fulladder(a, b, cin, w, cout);
    parameter N = 4;
    input [N - 1:0] a, b;
    input cin;
    
    output [N - 1:0] w;
    output cout;
    assign {cout, w} = a + b + cin;
endmodule