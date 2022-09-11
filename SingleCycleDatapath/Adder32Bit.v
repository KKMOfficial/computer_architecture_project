module Adder32Bit(input [31:0] input1, 
                  input [31:0] input2, 
                  output [31:0] out, 
                  output overflowBit);
  
  assign {overflowBit , out } = input1 + input2;
            
endmodule