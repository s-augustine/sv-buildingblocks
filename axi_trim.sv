//  Module: axi_trim
//  Authour: Suraj A


module axi_trim

#(
	parameter DATA_WIDTH = 8,
	parameter TRIM_LEN = 7
)
(
	input logic         clk,
	input logic         rst_n,

	//Input streaming interface
	input logic [DATA_WIDTH*8-1:0] trim_in_tdata,
	input logic [DATA_WIDTH-1:0]   trim_in_tkeep,
	input logic                    trim_in_tlast,
	input logic                    trim_in_tvalid,
	output logic                   trim_in_tready,

	//Output streaming interface
	output logic [DATA_WIDTH*8-1:0] trim_out_tdata,
	output logic [DATA_WIDTH-1:0]   trim_out_tkeep,
	output logic                    trim_out_tlast,
	output logic                    trim_out_tvalid,
	input logic                   trim_out_tready,

	input logic [TRIM_LEN-1:0]     trim_len
);


logic [DATA_WIDTH*8*2-1:0] trim_in_tdata_d1;
logic [DATA_WIDTH*8*2-1:0] trim_in_tdata_d1_masked;
logic [DATA_WIDTH*8*2-1:0] trim_in_tdata_d2_in;
logic [DATA_WIDTH*8*2-1:0] trim_in_tdata_d2;
logic [DATA_WIDTH*8*2-1:0] trim_in_tdata_d3_in;
logic [DATA_WIDTH*8*2-1:0] trim_in_tdata_d3;

logic [1:0] d1_valid;
logic d2_valid;
logic d3_valid;
logic d1_out_valid;

logic [1:0] d1_last;
logic d2_last;
logic d3_last;
logic d1_out_last;

logic [7:0] trim_len_d1_in;
logic [7:0] trim_len_d1_0;
logic [7:0] trim_len_d1_1;
logic [7:0] trim_len_d2;

logic [DATA_WIDTH-1:0] keep_in_d1_in;
logic [DATA_WIDTH-1:0] keep_in_d1_0;
logic [DATA_WIDTH-1:0] keep_in_d1_1;
logic [DATA_WIDTH*2-1:0] keep_in_d1_masked;
logic [DATA_WIDTH*2-1:0] keep_in_d2_in;
logic [DATA_WIDTH*2-1:0] keep_in_d2;
logic [DATA_WIDTH*2-1:0] keep_in_d3_in;
logic [DATA_WIDTH*2-1:0] keep_in_d3;

logic d1_push;

always_comb d1_push = (trim_in_tvalid | |d1_last ) & trim_out_tready;


always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    trim_in_tdata_d1 <= 'b0;
  else
    if (d1_push)
    begin
	trim_in_tdata_d1[DATA_WIDTH*8-1:0] <= trim_in_tdata_d1[DATA_WIDTH*8+:8*DATA_WIDTH];
	trim_in_tdata_d1[DATA_WIDTH*8+:8*DATA_WIDTH] <= trim_in_tdata;
    end
end

always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    d1_valid <= 'b0;
  else
    if (d1_push)
    begin
	d1_valid <= {d1_valid[0],trim_in_tvalid} ;
    end
end


always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    d1_last <= 'b0;
  else
    if (d1_push)
    begin
	d1_last <= {d1_last[0],trim_in_tlast} ;
    end
end

always_comb trim_len_d1_in = 8'b0+ trim_len;

always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
  begin
    trim_len_d1_0 <= 'b0;
    trim_len_d1_1 <= 'b0;
    end
  else
    if (d1_push)
    begin
	trim_len_d1_0 <= trim_len_d1_in ;
	trim_len_d1_1 <= trim_len_d1_0;
    end
end

always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
  begin
    keep_in_d1_0 <= 'b0;
    keep_in_d1_1 <= 'b0;
    end
  else
    if (d1_push)
    begin
	keep_in_d1_0 <= trim_in_tkeep ;
	keep_in_d1_1 <= keep_in_d1_0;
    end
end

always_comb trim_in_tdata_d1_masked = ( d1_last[1] ) ?  trim_in_tdata_d1 & {DATA_WIDTH*8{1'b1}} : trim_in_tdata_d1 ;
always_comb keep_in_d1_masked = ( d1_last[1] ) ?  {keep_in_d1_0,keep_in_d1_1} & {DATA_WIDTH{1'b1}} : {keep_in_d1_0,keep_in_d1_1} ;

axi_shifter
#( .DATA_WIDTH (8* DATA_WIDTH*2),
  .SHIFTER (0)
  ) u_axi_shifter_0

(
	.data_in ( trim_in_tdata_d1_masked ),
	.data_out ( trim_in_tdata_d2_in ),
	.shift_value (trim_len_d1_1[7:4])
);


axi_keep_shifter
#( .DATA_WIDTH (DATA_WIDTH*2),
   .SHIFTER (0)
  ) u_axi_shifter_keep_0

(
	.data_in ( keep_in_d1_masked),
	.data_out ( keep_in_d2_in ),
	.shift_value (trim_len_d1_1[7:4])
);

always_comb d1_out_valid = d1_valid[1] ;
	
always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    trim_in_tdata_d2 <= 'b0;
  else
    if ( trim_out_tready)
    begin
	trim_in_tdata_d2 <=  d1_out_valid ? trim_in_tdata_d2_in : '0 ;
    end
end

	
always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    keep_in_d2 <= 'b0;
  else
    if ( trim_out_tready)
    begin
	keep_in_d2 <=  d1_out_valid ? keep_in_d2_in : '0 ;
    end
end


always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    d2_valid <= 'b0;
  else
    if ( trim_out_tready)
    begin
	d2_valid <= d1_out_valid;
    end
end


always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    d2_last <= 'b0;
  else
    if ( trim_out_tready)
    begin
	d2_last <= d1_last[1];
    end
end




always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    trim_len_d2 <= 'b0;
  else
    if ( trim_out_tready)
    begin
	trim_len_d2 <= trim_len_d1_1 ;
    end
end

axi_shifter
#( .DATA_WIDTH (8*DATA_WIDTH*2),
  .SHIFTER (1)
  ) u_axi_shifter_1

(
	.data_in ( trim_in_tdata_d2 ),
	.data_out ( trim_in_tdata_d3_in ),
	.shift_value (trim_len_d2[3:0])
);


axi_keep_shifter
#( .DATA_WIDTH (DATA_WIDTH*2),
  .SHIFTER (1)
  ) u_axi_shifter_keep_1

(
	.data_in ( keep_in_d2 ),
	.data_out ( keep_in_d3_in ),
	.shift_value (trim_len_d2[3:0])
);

always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    trim_in_tdata_d3 <= 'b1;
  else
    if ( trim_out_tready)
    begin
	trim_in_tdata_d3 <= trim_in_tdata_d3_in;
    end
end


always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    keep_in_d3 <= 'b1;
  else
    if ( trim_out_tready)
    begin
	keep_in_d3 <= keep_in_d3_in;
    end
end


always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    d3_valid <= 'b0;
  else
    if (trim_out_tready)
    begin
	d3_valid <= d2_valid ;
    end
end



always_ff @(posedge clk or negedge rst_n) begin 
  if (!rst_n)
    d3_last <= 'b0;
  else
    if (trim_out_tready)
    begin
	d3_last <= d2_last ;
    end
end


always_comb trim_out_tdata = trim_in_tdata_d3[DATA_WIDTH*8-1:0];
always_comb trim_out_tkeep = keep_in_d3[DATA_WIDTH-1:0];
always_comb trim_out_tvalid = d3_valid & |(keep_in_d3[DATA_WIDTH-1:0]) ;
always_comb trim_out_tlast = trim_out_tvalid & ((d2_valid & ( |(keep_in_d3_in[DATA_WIDTH-1:0]) == 0)) ? d2_last : d3_last );

always_comb trim_in_tready = trim_out_tready; 
endmodule
