module tb (clk);
  input clk;  // Clock is required to get initial activation

logic a,b,sel,clk;
wire o;
logic [31:0] clock_count;

initial begin
  a=0;
  b=1;
  sel =0;

end

initial begin
// $dumpfile("mux.vcd");
// $dumpvars;
// #100
// $finish;
end

//always begin
//#10 clk = !clk;
//end

always @(posedge clk) begin
  sel <= !sel;
end

mux u_mux(
    .a   (a   ),
    .b   (b   ),
    .sel (sel ),
    .o   (o   )
);

  always @ (posedge clk)
    begin 
      //$display("Hello World"); //$finish; 
      $display("clk%x:: a= %x; b= %x; sel = %x; o = %x",clock_count,a,b,sel,o); //$finish; 
      clock_count <= clock_count + 32'b1;
      if (clock_count == 10) $finish;
    end
endmodule
