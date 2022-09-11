module LeftShifter_2bit(input [31:0] inData,
                        output [31:0]outData);
                        
      assign outData=inData<<2;
endmodule    