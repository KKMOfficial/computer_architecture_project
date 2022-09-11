module MUX_4to1( input [31:0] input0 , 
                 input [31:0] input1 , 
                 input [31:0] input2 ,
                 input [31:0] input3 ,
                 input [1:0] select, 
                 output [31:0] out);
   assign out = select[1]? (select[0]?input3:input2) : (select[0]?input1:input0);
 endmodule   