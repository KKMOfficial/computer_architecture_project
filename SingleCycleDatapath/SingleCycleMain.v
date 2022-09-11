`include "InstructionMemory.v"
`include "LeftShifter_2bit.v"
`include "Adder32Bit.v"
`include "DataMemory.v"
`include "MUX_2to1_5bit.v"
`include "RegisterFile.v"
`include "SignExtender_16to32.v"
`include "MUX_2to1.v"
`include "ALU_Core.v"
`include "ALU_Control.v"
`include "Controller.v"
`include "MUX_4to1.v"
`include "MUX_4to1_5bit.v"

module SingleCycleMain(initialPCval, clk);
  input [31:0]initialPCval;  
  input clk;
  
  reg [31:0]PC;
  reg [31:0]init_PC;
  wire [31:0]instrWire;  
  InstructionMemory instrMem(.readAddress(PC),.instruction(instrWire));
  
  wire [31:0]outputFromShiftLeft;
  LeftShifter_2bit instLftShft(.inData(outputDataSEXT),.outData(outputFromShiftLeft));
  
  reg [31:0]constantFour;
  wire [31:0]nextPCval;
  wire overflow1;
  Adder32Bit nextPCvalue(.input1(PC),.input2(constantFour),.out(nextPCval),.overflowBit(overflow1));

  wire [31:0]nextPCvalPlusOffset; 
  wire overflow2;
  Adder32Bit PCafterBranch(.input1(nextPCval),.input2(outputFromShiftLeft),.out(nextPCvalPlusOffset), .overflowBit(overflow2));
  
  wire[31:0]outputData;
  wire MemRead, MemWrite;
  DataMemory dataMem(.inputAddress(ALUout),.inputData32bit(readData2),.outputData32bit(outputData),.MemRead(MemRead),.MemWrite(MemWrite));
  
  wire [4:0]inputReg1;
  wire [4:0]inputReg2;
  wire [1:0] RegDst;
  wire [4:0]writeRegWire;
  MUX_4to1_5bit regDstMUX(.input0(instrWire[20:16]),.input1(instrWire[15:11]),.input2(5'd31),.input3(5'd0),.select(RegDst),.out(writeRegWire));
  
  wire [4:0]readReg1, readReg2, writeReg, reg2_mux;
  wire [31:0]writeData;
  wire [31:0]readData1, readData2;
  wire RegWrite, is_jr;
  MUX_2to1_5bit regfile_sec_jr(.input0 (instrWire[20:16]),.input1(5'd31),.select(is_jr),.out (reg2_mux));
  RegisterFile regFile(.readReg1(instrWire[25:21]),.readReg2(reg2_mux),.writeReg(writeRegWire),.writeData(writeDataToReg),.readData1(readData1),.readData2(readData2),.RegWrite(RegWrite));
  
  wire [31:0]outputDataSEXT;
  SignExtender_16to32 signExt(.inputData(instrWire[15:0]),.outputData(outputDataSEXT));
  
  wire aluSrc;
  wire [31:0] ALUSrc2;
  MUX_2to1 aluSrc2MUX(.input0 (readData2),.input1(outputDataSEXT),.select(aluSrc),.out (ALUSrc2));
  
  wire [5:0]FunctField;
  wire [1:0]ALUOp;
  
  wire [2:0]ALUCtrl;  
  wire[31:0]ALUout;
  wire ZeroOUT;
  ALU_Core aluCoreInstance(.ALUSrc1 (readData1),.ALUSrc2 (ALUSrc2),.ALUCtrl (ALUCtrl),.ALUResult (ALUout),.Zero(ZeroOUT));
  
  wire Branch;
  wire BranchEnabled;  
  and branchAND(BranchEnabled, Branch, ZeroOUT);
  
  wire [31:0]nextPCactual;
  MUX_2to1 pcSrcMUX(.input0 (nextPCval),.input1(nextPCvalPlusOffset),.select(BranchEnabled),.out (nextPCactual));

  wire [1:0]MemtoReg;
  wire [31:0]writeDataToReg;
  MUX_4to1 mem2regSrcMUX(.input0 (ALUout), .input1(outputData),.input2(jumpTarget),.input3(init_PC),.select(MemtoReg), .out (writeDataToReg));
  

  reg [31:0]jumpTarget;
  reg counter, prevInstrWasJ;

  Controller main_controller(.OpCode(instrWire[31:26]), .ctrl_signals({ALUOp,RegDst,Branch,MemRead,MemWrite,aluSrc,MemtoReg,RegWrite,ALUCtrl,is_jr}),.FunctField(instrWire[5:0]),.ALUOp(ALUOp),.ALUCtrl(ALUCtrl));
  
  always @(initialPCval)
  begin
   counter = 0; 
   constantFour = 4;
   PC = initialPCval;
   prevInstrWasJ = 0;
  end
   
  always@(posedge clk)
  begin



    $display("PC = %d", PC);
    // $display(" = %d", );
    $display("---------------------------------");  
    

    if(instrWire[31:26]==6'b000010 | instrWire[31:26]==6'b000011)begin // for normal jump
      init_PC = nextPCval;
      prevInstrWasJ = 1;
      jumpTarget = {PC[31:28],instrWire[25:0],2'b00};  
    end
    else if (instrWire[31:26]==6'b000000 & instrWire[5:0]==6'b001000)begin // for jr
      prevInstrWasJ = 1;
      jumpTarget = ALUout;  
    end
    else
      prevInstrWasJ = 0;

    counter = 1;

    if(counter != 0)
      PC = nextPCactual;
    
    if(prevInstrWasJ == 1)
      PC = jumpTarget;
  end
  
endmodule