@echo off
set /P file_name="enter module name : "
iverilog -o %file_name% %file_name%_tb.v
vvp %file_name%
echo generation ended...
pause