module ALU_Control(input [5:0] FunctField, 
                   input [1:0] ALUOp, 
                   output reg[2:0] ALUCtrl);

always@(*)
begin
    if(ALUOp == 2'b10)
    begin
      case(FunctField)        
        6'b100000: ALUCtrl = 3'b010;    //ADDITION in 'R' Type
        6'b100010: ALUCtrl = 3'b110;    //SUBTRACTION in 'R' Type
        6'b100100: ALUCtrl = 3'b000;    //AND in 'R' Type
        6'b100101: ALUCtrl = 3'b001;    //OR in 'R' Type
        6'b101010: ALUCtrl = 3'b111;    //SLT in 'R' Type
      endcase
    end
    
    if(ALUOp == 2'b00)     //'LW/SW' Type Instructions
        ALUCtrl = 3'b010;  //ADDITION irrespective of the FunctField.
    
    if(ALUOp == 2'b01)     //'BEQ', 'BNE' Type Instructions
        ALUCtrl = 3'b110;  //SUBTRACTION irrespective of the FunctField.      
    
end

endmodule  //ALUOp module

