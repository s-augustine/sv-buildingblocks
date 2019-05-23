module register (
    input logic clock,
    input logic rst_n,
    input logic d,
    input logic en,
    output logic q
);

always_ff @(posedge clock or negedge rst_n) begin 
  if (!rst_n)
    q <= 1'b0;
  else
    if (en)
      q <= d;
end

endmodule
    