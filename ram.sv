module ram (
    input logic clk,
    input logic cs_n,
    input logic we_n,
    input logic [31:0] din,
    input logic [9:0] addr,
    output logic [31:0] dout
);

logic [1023:0] [31:0] ram;
logic [31:0] ram_out;

always_ff (@posedge clk ) begin 
  if (!cs_n && !we_n)
    q[addr] <= din;
end

always_ff (@posedge clk ) begin 
  if (!cs_n && we_n)
    ram_out <= q[addr] ;
end

always_comb dout = ram_out;

endmodule
    