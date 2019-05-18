module mux (
  input logic a,
  input logic b,
  input logic sel,
  output o
  );

always_comb o = sel ? b : a;

endmodule
