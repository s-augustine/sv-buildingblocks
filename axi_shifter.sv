module axi_shifter
#(
	parameter DATA_WIDTH = 16,
	parameter SHIFTER = 0,
	parameter SHIFT_VALUE_LEN = 4
)
(
	input logic [DATA_WIDTH*8 -1 : 0] data_in,
        input logic [SHIFT_VALUE_LEN-1:0] shift_value,

	output logic [DATA_WIDTH*8 -1 : 0] data_out
);
// Replace with barrel shifter
always_comb data_out = (SHIFTER ==0) ?  data_in >> (8 * shift_value* 16 ) : data_in >> (8 * shift_value ) ; 

endmodule
