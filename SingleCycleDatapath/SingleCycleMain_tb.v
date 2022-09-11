//auto generated test by : MR_X
//Jan:15:2021
`include "SingleCycleMain.v"
module SingleCycleMain_tb ();
initial begin
$dumpfile("SingleCycleMain.vcd");
$dumpvars(0, SingleCycleMain_tb);
end

reg clk;
reg [31:0] initialPCval;

initial 
begin
    clk = 0;
    initialPCval = 0;    
end

always #20 clk = ~clk;
//make new instance of module here
SingleCycleMain instance1(.initialPCval(initialPCval), 
                          .clk(clk));
initial
begin
#400;
$finish;
end
endmodule //SingleCycleMain_tb