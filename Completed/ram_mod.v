module ram_mod(
    input mode, //0 for read 1 for write
    input [31:0] data_in,
    input [11:0] address,
    output [31:0] read_data,

);

parameter size = 4096; //size of a ram in bits

reg [31:0] ram [0:size-1]; //data matrix for ram

endmodule
