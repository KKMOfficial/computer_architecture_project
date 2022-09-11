module MUX_2to1_5bit (input [4:0] input0,
                      input [4:0] input1, 
                      input select, 
                      output [4:0] out);
  assign out = select? input1 : input0;
endmodule   