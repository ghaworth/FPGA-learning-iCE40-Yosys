module Day_01_Core (
	input wire clk,
	input wire start,
	output reg [31:0] result = 0,
	output reg done = 0
);

`include "day_01_input_test.v"
	reg [6:0] current_position = 50;
	reg [12:0] num_zeros = 0;
	reg [12:0] index = 0;

	wire [6:0] next_position;
	reg running = 0;

	always @(posedge clk) begin
		if (start) begin
			// reset to initial values
			running <= 1;
			current_position <= 50;
			num_zeros <= 0;
			index <= 0; 
			done <= 0;
			result <= 0;
		end else if (running) begin
			// normal operation
			if (index == NUM_ROTATIONS) begin
				// we're done
				done <= 1;
				result <= num_zeros;
				running <= 0;
			end else begin
				// process next rotation
				current_position <= next_position;
				if (next_position == 0) 
					num_zeros <= num_zeros + 1;	
				index <= index + 1;
			end
		end
	end

	wire direction = rotations[index][7];
	wire [6:0] distance = rotations[index][6:0]; 

	assign next_position = (direction == 0) ? ((distance > current_position) ? (100 + current_position - distance) : (current_position - distance))
											: (((current_position + distance) >= 100) ? (current_position + distance - 100) : (current_position + distance));
											
											
endmodule