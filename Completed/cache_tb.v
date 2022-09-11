//auto generated test by : MR_X
//Jan:16:2021
`include "cache.v"

module cache_tb ();
parameter ram_size = 4096; //size of a ram in bits
initial begin
$dumpfile("cache.vcd");
$dumpvars(0, cache_tb);
end

reg [31:0]address;
reg [31:0]data;
reg clk;
reg mode;
wire [31:0]out;
wire two_sig_hit;
wire dir_sig_hit;
reg finish;
reg reset;
integer i,j,k,l,m;
//locality test parameters
integer num_of_tests = 100;
//spacial locality test parameters
integer radius_start = 5;
integer radius_end = 32;
//temporal locality test parameters
integer population;
parameter initial_population_start = 5;
parameter initial_population_end = 150;
integer repeated_samples[0:initial_population_end-1];



initial clk = 0;
always #5 clk = ~clk;
//make new instance of module here
cache #(.two_info(0),.dir_info(0),.two_hit_out("two_way_cache_hit.txt"),.dir_hit_out("direct_map_cache_hit.txt"),.improve_out("improvement.txt")) instance1(.address(address),.data(data),.clk(clk),.mode(mode),.out(out),.two_sig_hit(two_sig_hit),.dir_sig_hit(dir_sig_hit),.finish(finish),.reset(reset));
initial begin
reset = 0;

//////////////////////////////////////////////////////////////////////////
//////temporal locality test with respect to initial population size//////
//////////////////////////////////////////////////////////////////////////
// k = 1;
// population = $fopen("initial_population.txt","w");
// for(j = initial_population_start; j<initial_population_end; j = j + 1)
//     begin
//         $display("test[%d]------------------------------------------",k);
//         $fwrite(population,"%d,",j);
//         k = k +1;
//         reset = 0;
//         finish = 0;
//         mode = 0;
//         for(i = 0; i<j; i = i + 1)
//             begin
//                 repeated_samples[i] = $urandom%ram_size;
//             end
// 
//         for(i = 0; i<num_of_tests; i = i +1)
//             begin
//                 address = repeated_samples[$urandom%j];
//                 #10;
//             end
//         address = 0; finish = 1;
//         #10;
//         reset = 1;
//         #10;
//     end





//////////////////////////////////////////////////////////////////////////
//////////spacial locality test with respect to radius////////////////////
//////////////////////////////////////////////////////////////////////////
// finish = 0;
// mode = 0;
// radius_range = $fopen("radius_range.txt","w");
// for(i = radius_start; i < radius_end; i = i + 1)
//     begin
//         $fwrite(radius_range,"%d,",i);
//         reset = 0;
//         k = i + $urandom%(ram_size-i);
//         for(l = 0; l<num_of_tests; l = l +1)
//             begin
//                 address = k + ($urandom%2?1:-1)*($urandom%i);
//                 #10;
//             end
//         address = 0; finish = 1;
//         #10;
//         reset = 1;
//         finish = 0;
//         #10;
//     end
    


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////maximal improvement/////////////////////
////////////////////////////////////////////////////////////////////////////
// finish = 0;
// mode = 0;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; #10;
// address = 20; #10;
// address = 52; finish = 1;#10;


$finish;
end
endmodule //cache_tb