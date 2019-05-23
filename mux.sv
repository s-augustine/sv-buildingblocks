module mux (
  input logic a,
  input logic b,
  input logic sel,
  output wire o
  );

assign o = sel ? b : a;

endmodule
