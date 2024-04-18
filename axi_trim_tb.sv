module tb (clk);
  input clk;  // Clock is required to get initial activation

logic [63:0] tdata_in, tdata_out;
logic [7:0] tkeep_in, tkeep_out;
logic tlast_in,clk, tlast_outi, tvalid_out , tvalid_in;
logic [31:0] clock_count = 32'b0;
logic [31:0] data_count = 32'b0;
logic rst_n;

logic [15:0] [63:0] tdata_array = 

			{   64'h0000000000000000,
			    64'h0000000000000000,
			    64'h0000000000000000,
			    64'h000000000000BBAA,
			    64'hDDDDDDDDDDDDDDDD,
			    64'h0000000000000000,
			    64'hDDDDDDDDDDDDDDDD,
			    64'hCCCCCCCCCCCCCCCC,
			    64'h0000000000000000,
			    64'hBBBBBBBBBBBBBBBB,
			    64'hAAAAAAAAAAAAAAAA,
			    64'h0000000000000000,
			    64'hDDDDDDDDDDDDDDDD,
			    64'hCCCCCCCCCCCCCCCC,
			    64'hBBBBBBBBBBBBBBBB,
			    64'hAAAAAAAAAAAAAAAA};

logic [15:0] [7:0] tkeep_array = 

			{   8'h00,
			    8'h00,
			    8'h00,
			    8'h03,
			    8'hFF,
			    8'h00,
			    8'hFF,
			    8'hFF,
			    8'h00,
			    8'hFF,
			    8'hFF,
			    8'h00,
			    8'hFF,
			    8'hFF,
			    8'hFF,
			    8'hFF};


logic [15:0] tlast_array = 

			{   1'b0,
			    1'b0,
			    1'b0,
			    1'b1,
			    1'b0,
			    1'b0,
			    1'b1,
			    1'b0,
			    1'b0,
			    1'b1,
			    1'b0,
			    1'b0,
			    1'b1,
			    1'b0,
			    1'b1,
			    1'b0};

logic [15:0] tvalid_array = 

			{   1'b0,
			    1'b0,
			    1'b0,
			    1'b1,
			    1'b1,
			    1'b0,
			    1'b1,
			    1'b1,
			    1'b0,
			    1'b1,
			    1'b1,
			    1'b0,
			    1'b1,
			    1'b1,
			    1'b1,
			    1'b1};


initial begin
  tdata_in=64'h00000000000000000;
  tkeep_in=8'h00;
  tlast_in=0;
  tvalid_in=0;

end

initial begin
// $dumpfile("mux.vcd");
// $dumpvars;
// #100
// $finish;
end

initial begin
	rst_n = 1'b0;
	#1;
	rst_n = 1'b1;
end

//always begin
//#10 clk = !clk;
//end

axi_trim u_axi_trim(
    .clk   (clk   ),
    .rst_n   (rst_n),
    .trim_in_tdata (tdata_in),
    .trim_in_tkeep (tkeep_in),
    .trim_in_tlast (tlast_in),
    .trim_in_tvalid (tvalid_in),
    .trim_in_tready (trim_in_tready),
    .trim_out_tdata (tdata_out),
    .trim_out_tkeep (tkeep_out),
    .trim_out_tlast (tlast_out),
    .trim_out_tvalid (tvalid_out),
    .trim_out_tready (1'b1),
    .trim_len (8'd2)
);

  always @ (posedge clk)
    begin 
      //$display("Hello World"); //$finish; 
      $display("clk%x:: tvalid_out = %x; tdata_out= %x; tkeep_out= %x; tlast_out = %x", clock_count,tvalid_out,tdata_out,tkeep_out,tlast_out); //$finish; 
      clock_count <= clock_count + 32'b1;
      if (trim_in_tready)
      begin
        data_count <= data_count +32'b1;
        tdata_in    <= tdata_array[data_count];
        tkeep_in    <= tkeep_array[data_count];
        tlast_in    <= tlast_array[data_count];
        tvalid_in   <= tvalid_array[data_count];
      end
      if (clock_count == 20) $finish;
    end
endmodule
