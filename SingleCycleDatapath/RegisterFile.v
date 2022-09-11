module RegisterFile(input [4:0] readReg1, 
                    input [4:0] readReg2,
                    input [4:0] writeReg, 
                    input [31:0] writeData, 
                    output reg [31:0] readData1, 
                    output reg [31:0] readData2, 
                    input RegWrite);
     
     reg [31:0]RegMemory[0:31];
     
     initial 
     for (integer i = 0; i < 32 ; i = i + 1) begin
         RegMemory[i] = 0;
      end

     
     always @(*)
     begin
         if(RegWrite)  
            RegMemory[writeReg] = writeData;
         else
          begin
            readData1 = RegMemory[readReg1];
            readData2 = RegMemory[readReg2];
          end
      end
      
     
endmodule  
