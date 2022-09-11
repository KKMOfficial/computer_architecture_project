module MUX_4to1_5bit (input [4:0] input0,
                      input [4:0] input1, 
                      input [4:0] input2,
                      input [4:0] input3,
                      input [1:0] select, 
                      output [4:0] out);
    assign out = select[1]? (select[0]?input3:input2) : (select[0]?input1:input0);
endmodule //MUX_4to1_5bit