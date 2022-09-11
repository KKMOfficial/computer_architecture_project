module InstructionMemory(input [31:0] readAddress, 
                         output reg[31:0] instruction);
  
  reg [0:7]InstructionMemory[0:31];
  
  initial
      begin
            {InstructionMemory[0], InstructionMemory[1], InstructionMemory[2], InstructionMemory[3]} = 32'b001101_10010_10011_0000000000000001;    //ori $s2, $s1 , 1539;
            // {InstructionMemory[4], InstructionMemory[5], InstructionMemory[6], InstructionMemory[7]} = 32'b000101_10011_00000_0000000000000100;     // bne $s2, reg1, 4h;               
            {InstructionMemory[4], InstructionMemory[5], InstructionMemory[6], InstructionMemory[7]} = 32'b000011_00000000000000000000000110;         // jal to 24
            {InstructionMemory[8], InstructionMemory[9], InstructionMemory[10], InstructionMemory[11]} = 32'b000010_00000000000000000000000000;        // j 0     
            {InstructionMemory[24], InstructionMemory[24+1], InstructionMemory[24+2], InstructionMemory[24+3]} = 32'b001000_10011_10010_0000000000000100;    //addi $s1, $s2 ,4;
            {InstructionMemory[28], InstructionMemory[28+1], InstructionMemory[28+2], InstructionMemory[28+3]} = 32'b000000_00000_00000_0000000000_001000;    // jr 8;                               
            // {InstructionMemory[28], InstructionMemory[28+1], InstructionMemory[28+2], InstructionMemory[28+3]} = 32'b000010_00000000000000000000000000;        // j 0     
      end

  always@(*)
      begin
            instruction = {InstructionMemory[readAddress + 0],InstructionMemory[readAddress + 1],InstructionMemory[readAddress + 2],InstructionMemory[readAddress + 3]};
      end  
  
endmodule



