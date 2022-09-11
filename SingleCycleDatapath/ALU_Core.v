module ALU_Core(input [31:0] ALUSrc1 , 
                input [31:0] ALUSrc2 , 
                input [2:0] ALUCtrl , 
                output reg [31:0] ALUResult , 
                output reg Zero);
  
  always @(*)
    begin

     case(ALUCtrl)
          0: ALUResult = ALUSrc1 & ALUSrc2; 
          1: ALUResult = ALUSrc1 | ALUSrc2; 
          2: ALUResult = ALUSrc1 + ALUSrc2; 
          3: ALUResult = ALUSrc2;
          6: ALUResult = ALUSrc1 - ALUSrc2; 
          7: ALUResult = ALUSrc1 - ALUSrc2; 
          default: ALUResult = ALUSrc2;
     endcase
     
     Zero = ALUResult == 0;
        
    end
  
endmodule