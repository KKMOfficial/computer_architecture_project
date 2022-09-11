module Controller (
    input [5:0]OpCode,
    output reg[14:0]ctrl_signals,
    input [5:0] FunctField, 
    input [1:0] ALUOp, 
    output reg[2:0] ALUCtrl
);

initial ctrl_signals = 15'b00_00_0_0_00_0_0_000_0;

always @(OpCode, FunctField, ALUOp)
begin
    //ORDER :: ALUOp,RegDst,Branch,MemRead,MemWrite,aluSrc,MemtoReg,RegWrite,ALUCtrl,is_jr
    case(OpCode)
        6'b000000:ctrl_signals = 15'b10_01_0_0_0_0_00_1_011_0; // ordinary r type, not jr
        6'b000010:ctrl_signals = 15'b00_00_0_0_0_0_00_0_011_0;

        6'b000011:ctrl_signals = 15'b11_10_0_0_0_0_11_1_011_0;

        6'b100011:ctrl_signals = 15'b00_00_0_1_0_1_01_1_011_0;
        6'b101011:ctrl_signals = 15'b00_00_0_0_1_1_01_0_011_0;
        6'b000100:ctrl_signals = 15'b01_00_1_0_0_0_01_0_011_0;
        6'b000101:ctrl_signals = 15'b01_00_1_0_0_0_01_0_011_0;
        6'b001101:ctrl_signals = 15'b01_00_0_0_0_1_00_1_001_0;
        6'b001000:ctrl_signals = 15'b01_00_0_0_0_1_00_1_010_0;
        default:  ctrl_signals = 15'b00_00_0_0_0_0_00_0_011_0;
    endcase

    if(ALUOp == 2'b10)
    begin
      case(FunctField)        
        6'b100000: ALUCtrl = 3'b010;    //ADDITION in 'R' Type
        6'b100010: ALUCtrl = 3'b110;    //SUBTRACTION in 'R' Type
        6'b100100: ALUCtrl = 3'b000;    //AND in 'R' Type
        6'b100101: ALUCtrl = 3'b001;    //OR in 'R' Type
        6'b101010: ALUCtrl = 3'b111;    //SLT in 'R' Type
        6'b001000: begin
            //ORDER :: ALUOp,RegDst,Branch,MemRead,MemWrite,aluSrc,MemtoReg,RegWrite,ALUCtrl,is_jr
            ctrl_signals = 15'b10_00_0_0_0_0_00_0_011_1; // jr control signals
        end
      endcase
    end
    
    if(ALUOp == 2'b00)     //'LW/SW' Type Instructions
        ALUCtrl = 3'b010;  //ADDITION irrespective of the FunctField.
    
    if(ALUOp == 2'b01)     //'BEQ', 'BNE' Type Instructions
        ALUCtrl = 3'b110;  //SUBTRACTION irrespective of the FunctField.   



end


endmodule //Controller