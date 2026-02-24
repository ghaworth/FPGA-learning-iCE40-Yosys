module Day_07_Core (
	input wire clk,
	input wire start,
	output reg [10:0] result = 0,
	output reg done = 0
);
	// Block RAM for rotations
	reg [15:0] splitters [0:629];
	initial $readmemh("splitters.hex", splitters);

	localparam DONE = 0;
	localparam LOAD = 1;
	localparam PROCESS = 2;
	localparam COUNT = 3;

	reg [9:0] ram_addr;
	reg [3:0] words_read;
	reg [140:0] active = 141'b0;
	reg [140:0] bitmask;
	reg [140:0] hits;
	reg [7:0] bitshifts = 0;
	reg [10:0] splits;
	reg [2:0] state;
	reg [6:0] row_count;

	// Synchronous read from block RAM
	reg [15:0] splitter_data;
	always @(posedge clk) begin
		splitter_data <= splitters[ram_addr];
	end

	always @(posedge clk) begin
		if (start) begin
			row_count <= 0;
			active <= 1 << 70;
			ram_addr <= 0;
			words_read <= 0;
			bitshifts <= 0;
			splits <= 0;
			done <= 0;
			state <= LOAD;
		end

		case(state)
			LOAD: begin

			end
			PROCESS: begin

			end
			COUNT: begin

			end
			DONE: begin

			end
		endcase
	end
