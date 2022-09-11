module SignExtender_16to32(input [15:0] inputData, 
                           output[31:0] outputData);
  assign outputData = {16'b0, inputData};
endmodule