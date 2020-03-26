module sync_fifo (
    input clk,
    input rst_n
    
    input [31:0] data_in,
    input        put,

    output [31:0] data_out,
    output get,

    output fifo_full,
    output fifo_empty
);

// 256 deep fifo with 32 bit width

logic [7:0] rd_ptr;
logic [7:0] wr_ptr;


endmodule