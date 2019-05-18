module synchronizer (
    input logic clock,
    input logic rst_n,
    input logic sync_in,
    input logic sync_out
);

logic data_1;

always_ff (@posedge clock or negedge rst_n) begin 
  if (!rst_n)
    data_1 <= 1'b0;
    sync_out <= 1'b0;
  else
    data_1 <= sync_in;
    sync_out <= data_1;
end

endmodule