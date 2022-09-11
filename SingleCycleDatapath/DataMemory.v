module DataMemory(input [31:0] inputAddress, 
                  input [31:0] inputData32bit, 
                  output [31:0] outputData32bit, 
                  input MemRead, 
                  input MemWrite);

reg [7:0]MM[255:0];

reg [7:0]address;
reg [7:0]dataBuff;
reg [31:0]outputData32bit;

always @(*)
begin

  if(MemRead == 1)
    outputData32bit = {MM[inputAddress + 3],MM[inputAddress + 2],MM[inputAddress + 1],MM[inputAddress + 0]};
  
  else if(MemWrite == 1)
  begin
    MM[inputAddress + 0] = inputData32bit[7:0];
    MM[inputAddress + 1] = inputData32bit[15:8];
    MM[inputAddress + 2] = inputData32bit[23:16];
    MM[inputAddress + 3] = inputData32bit[31:24];
  end 
   
end

endmodule