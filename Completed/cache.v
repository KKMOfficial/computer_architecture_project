module cache #(parameter two_info = 1, parameter dir_info = 1, parameter two_hit_out="t_h_o.txt", parameter dir_hit_out="d_h_o.txt",parameter improve_out="imp_o.txt") 
		(input [31:0] address,
			 input [31:0] data,
			 input clk,
			 input mode,	//mode equal to 1 when we write and equal to 0 when we read
			 output [31:0] out,
			 output reg two_sig_hit,
			 output reg dir_sig_hit,
			 input finish,
			 input reset);

//graph and file writing utilities and values
	integer t_h_writer;
	integer d_h_writer;
	integer imp_writer;

//local parameters of the module
	parameter direct_map_cache_size = 64;	// one way direct map cache size
	parameter direct_map_index_size = 6;	// one way index size
	parameter two_way_cache_size = 32;		// two way cache size
	parameter two_way_index_size = 5;	// index size
	parameter ram_size = 4096; //size of a ram in bits

//two way cache values cache values
	reg [31:0] cache_w0[0:(two_way_cache_size) - 1], cache_w1 [0:(two_way_cache_size) - 1]; //registers for the data in cache
	reg [11 - two_way_index_size:0] tag_array_w0[0:(two_way_cache_size) - 1]; // for all tags in cache
	reg [11 - two_way_index_size:0] tag_array_w1[0:(two_way_cache_size) - 1]; // for all tags in cache
	reg valid_array_w0 [0:(two_way_cache_size) - 1],valid_array_w1 [0:(two_way_cache_size) - 1]; //0 - there is no data 1 - there is data
	reg lru_array [0:two_way_cache_size-1];


//one way direct map cache values
	reg [31:0] direct_cache[0:(direct_map_cache_size-1)];
	reg [11 - direct_map_index_size:0] direct_tag_array[0:(direct_map_cache_size-1)];
	reg direct_valid_array[0:(direct_map_cache_size-1)];

//total numbers of mem queries
	integer total_reqs;
//direct map one way cache regs for recording numbers of misses and hits
	real two_way_hits;
	real two_way_misses;
//direct map two way cache regs for recording numbers of misses and hits
	real dir_map_hits;
	real dir_map_misses;

//previous values
	reg [31:0] prev_address, prev_data;
	reg prev_mode;
	reg [31:0] temp_out;
	reg [two_way_index_size - 1:0] index;	// for keeping index of current address
	reg [11 - two_way_index_size:0] tag;	// for keeping tag of ceurrent address




//////////////////////////////////////////////////
////////// system ram located here ///////////////
reg [31:0] ram [0:ram_size-1];
integer i;
initial begin
   for (i = 0; i<ram_size; i=i+1) begin
		ram[i] = i;
	end
end
//////////////////////////////////////////////////
//////////////////////////////////////////////////
initial
	begin: initialization

		integer i;
		for (i = 0; i < two_way_cache_size; i = i + 1)
		begin
			valid_array_w0[i] = 1'b0;
			valid_array_w1[i] = 1'b0;
			tag_array_w0[i] = 6'b000000;
			tag_array_w1[i] = 6'b000000;
			lru_array[i] = 1'b0;
		end
		for (i = 0; i < direct_map_cache_size; i = i + 1)
		begin
			direct_valid_array[i] = 1'b0;
			direct_tag_array[i] = 6'b000000;
		end
		index = 0;
		tag = 0;
		prev_address = 0;
		prev_data = 0;
		prev_mode = 0;
		two_sig_hit = 0;
		dir_sig_hit = 0;
		two_way_hits = 0;
		two_way_misses = 0;
		dir_map_hits = 0;
		dir_map_misses = 0;
		total_reqs = 0;

		t_h_writer = $fopen(two_hit_out,"w");
		d_h_writer = $fopen(dir_hit_out,"w");
		imp_writer = $fopen(improve_out,"w");

	end

always @(posedge clk)
	begin
		//reset experiment results
		if(reset)
			begin
				for (i = 0; i < two_way_cache_size; i = i + 1)
				begin
					valid_array_w0[i] = 1'b0;
					valid_array_w1[i] = 1'b0;
					tag_array_w0[i] = 6'b000000;
					tag_array_w1[i] = 6'b000000;
					lru_array[i] = 1'b0;
				end
				for (i = 0; i < direct_map_cache_size; i = i + 1)
				begin
					direct_valid_array[i] = 1'b0;
					direct_tag_array[i] = 6'b000000;
				end
				index = 0;
				tag = 0;
				prev_address = 0;
				prev_data = 0;
				prev_mode = 0;
				two_sig_hit = 0;
				dir_sig_hit = 0;
				two_way_hits = 0;
				two_way_misses = 0;
				dir_map_hits = 0;
				dir_map_misses = 0;
				total_reqs = 0;
			end


		//check if the new input is updated
		else 
			begin
				if (prev_address != address || prev_data != data || prev_mode != mode)
					begin

						//////////////////////////////////////////////////////////////////////////////////////////
						////////////////////////two way cache will be located here////////////////////////////////
						//////////////////////////////////////////////////////////////////////////////////////////

						total_reqs = total_reqs + 1;
						prev_address = address % ram_size;
						prev_data = data;
						prev_mode = mode;
						
						tag = prev_address >> two_way_index_size;	// tag = first bits of address except index ones (In our particular case - 6)
						index = address % two_way_cache_size; 		// index value = last n (n = size of cache) bits of address
							
						if (mode == 1) // for update
							begin
								ram[prev_address] = data;
								//write new data to the relevant cache block if there is such one
								if  (valid_array_w0[index] == 1 && tag_array_w0[index] == tag)
									begin
										cache_w0[index] = data;
										lru_array[index] = 0;
										temp_out = data;
										if(two_info)$display("[two_way]:cache way0 updated");
										two_sig_hit = 1;
										two_way_hits = two_way_hits + 1;
									end
								else if(valid_array_w1[index] == 1 && tag_array_w1[index] == tag)
									begin
										cache_w1[index] = data;
										lru_array[index] = 1;
										temp_out = data;
										if(two_info)$display("[two_way]:cache way1 updated");
										two_sig_hit = 1;
										two_way_hits = two_way_hits + 1;
									end
								else
									begin
										two_sig_hit = 0;
										if(two_info)$display("[two_way]:ram was updated without changing cache");
										two_way_misses = two_way_misses + 1;
									end
							end
						else if(mode == 0) // for read
							begin
								//write new data to the relevant cache's block, because the one we addressing to will be possibly addressed one more time soon
								if((valid_array_w0[index] == 1 && tag_array_w0[index] != tag) && // VICTIM CASE
									(valid_array_w1[index] == 1 && tag_array_w1[index] != tag))
									begin
										two_sig_hit = 0;// we can't find data in cache
										two_way_misses = two_way_misses + 1;
										if(lru_array[index] == 0) // then we modify way_1 info
											begin
												tag_array_w1[index] = tag;
												cache_w1[index] = ram[prev_address];
												temp_out = cache_w1[index];
												lru_array[index] = 1;
												if(two_info)$display("[two_way]:miss, cache way1 is victom");
											end
										else if(lru_array[index] == 1) // then we modify way_0 info
											begin
												tag_array_w0[index] = tag;
												temp_out = cache_w0[index];
												cache_w0[index] = ram[prev_address];
												lru_array[index] = 0;
												if(two_info)$display("[two_way]:miss, cache way0 is victom");
											end
									end
								else if(valid_array_w0[index] == 0) // always we fill way_0 at first
									begin
										valid_array_w0[index] = 1;
										tag_array_w0[index] = tag;
										cache_w0[index] = ram[prev_address];
										lru_array[index] = 0;
										temp_out = cache_w0[index];
										two_sig_hit = 0;// we just started
										two_way_misses = two_way_misses + 1;
										if(two_info)$display("[two_way]:miss, write in cache way0");
									end
								else if(valid_array_w0[index] == 1 && tag_array_w0[index] != tag && valid_array_w1[index] == 0) // fill way_1 if way_0 already filled!
									begin
										valid_array_w1[index] = 1;
										tag_array_w1[index] = tag;
										cache_w1[index] = ram[prev_address];
										temp_out = cache_w1[index];
										lru_array[index] = 1;
										two_sig_hit = 0;// we use second way of cache
										two_way_misses = two_way_misses + 1;
										if(two_info)$display("[two_way]:miss, write in cache way1");
									end
								else if(valid_array_w0[index] == 1 && tag_array_w0[index] == tag)
									begin
										lru_array[index] = 0;
										temp_out = cache_w0[index];
										two_sig_hit = 1;// data found in way 0
										two_way_hits = two_way_hits + 1;
										if(two_info)$display("[two_way]:hit in cache way0");
									end
								else if(valid_array_w1[index] == 1 && tag_array_w1[index] == tag)
									begin
										lru_array[index] = 1;
										temp_out = cache_w1[index];
										two_sig_hit = 1;// data found in way 1
										two_way_hits = two_way_hits + 1;
										if(two_info)$display("[two_way]:hit in cache way1");
									end
								
							end	
					

						// $display("[two_way]:address = %b", prev_address);
						// $display("[two_way]:tag = %b",tag);
						// $display("[two_way]:index = %b",index);
						// $display("[two_way]:----------------------------------");

						//////////////////////////////////////////////////////////////////////////////////////////
						////////////////////////Direct Map Cache will be located here/////////////////////////////
						//////////////////////////////////////////////////////////////////////////////////////////
						
						tag = prev_address >> direct_map_index_size;	// tag = first bits of address except index ones (In our particular case - 6)
						index = address % direct_map_cache_size; 		// index value = last n (n = size of cache) bits of address

						if(mode == 1)
							begin
								ram[prev_address] = data;
								if  (direct_valid_array[index] == 1 && direct_tag_array[index] == tag)
									begin
										direct_cache[index] = data;
										if(dir_info)$display("[direct]:cache updated");
										dir_sig_hit = 1;
										dir_map_hits = dir_map_hits + 1;
									end
								else
									begin
										if(dir_info)$display("[direct]:ram updated without using cache");
										dir_sig_hit = 0;
										dir_map_misses = dir_map_misses + 1;
									end
								temp_out = data;
							end
						else if(mode == 0)
							begin
								if  (direct_valid_array[index] == 0 || direct_tag_array[index] != tag)
									begin
										direct_tag_array[index] = tag;
										direct_valid_array[index] = 1;
										direct_cache[index] = ram[prev_address];
										temp_out = direct_cache[index];
										if(dir_info)$display("[direct]:miss, either victom or initialization");
										dir_sig_hit = 0;
										dir_map_misses = dir_map_misses + 1;
									end
								else
									begin
										temp_out = direct_cache[index];
										if(dir_info)$display("[direct]:hit, data found in tag");
										dir_sig_hit = 1;
										dir_map_hits = dir_map_hits + 1;
									end
							end
						
						
						// $display("[direct]:address = %b", prev_address);
						// $display("[direct]:tag = %b",tag);
						// $display("[direct]:index = %b",index);
						// $display("[direct]:----------------------------------");
				
					end
			
				if(finish)
				begin
					$display("total mem requests = %d", total_reqs);
					$display("[two way hit rate = %f],[hits = %d],[misses = %d]",(two_way_hits / total_reqs), two_way_hits, two_way_misses);
					$display("[direct map hit rate = %f],[hits = %d],[misses = %d]",(dir_map_hits / total_reqs), dir_map_hits, dir_map_misses);
					$display("improvement rate = %f", (two_way_hits/(dir_map_hits+0.0001)));

					$fwrite(t_h_writer,"%d,",two_way_hits);
					$fwrite(d_h_writer,"%d,",dir_map_hits);
					$fwrite(imp_writer,"%f,",two_way_hits/(dir_map_hits+0.0001));

				end
			end
	end

assign out = temp_out;

endmodule 