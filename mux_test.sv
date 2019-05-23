module top ();

logic a,b,sel,clk;
wire o;

initial begin
  clk = 0 ;
  a=0;
  b=1;
  sel =0;

end

initial begin
 $dumpfile("mux.vcd");
 $dumpvars;
 #100
 $finish;
end

always begin
#10 clk = !clk;
end

always @(posedge clk) begin
  sel = !sel;
end

mux u_mux(
	.a   (a   ),
    .b   (b   ),
    .sel (sel ),
    .o   (o   )
);


endmodule