module Day_01_Core (
	input wire clk,
	input wire start,
	output reg [31:0] result = 0,
	output reg done = 0
);

	
	// Block RAM for rotations
	reg [7:0] rotations [0:4659];
	initial $readmemh("rotations.hex", rotations);

	localparam NUM_ROTATIONS = 4660;

	reg [6:0] current_position = 50;
	reg [12:0] num_zeros = 0;
	reg [12:0] index = 0;
	reg running = 0;
	reg data_valid = 0;

	// Synchronous read from block RAM
	reg [7:0] rotation_data;
	always @(posedge clk) begin
		rotation_data <= rotations[index];
	end 

	// Extract fields from registered data
	wire direction = rotation_data[7];
	wire [6:0] distance = rotation_data[6:0];

	// Calculate next position 
	wire [6:0] next_position;
	assign next_position = (direction == 0) ? ((distance > current_position) ? (100 + current_position - distance) : (current_position - distance))
											: (((current_position + distance) >= 100) ? (current_position + distance - 100) : (current_position + distance));

	always @(posedge clk) begin
		if (start) begin
			// reset to initial values
			running <= 1;
			current_position <= 50;
			num_zeros <= 0;
			index <= 0; 
			done <= 0;
			result <= 0;
			data_valid <= 0;
		end else if (running) begin
			// normal operation
			if (!data_valid) begin
				// wait one cycle for RAM read
				data_valid <= 1;
			end else begin
				// data is valid, process it
				if (index == NUM_ROTATIONS) begin 
					done <= 1;
					result <= num_zeros;	
					running <= 0;
				end else begin 
					num_zeros <= num_zeros + rotation_data;
					index <= index + 1;
					data_valid <= 0; 
				end 
			end 
		end
	end											
endmodule