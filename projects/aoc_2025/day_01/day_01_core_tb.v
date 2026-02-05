`timescale 1ns/1ps

module day_01_core_tb;
	reg clk;
	reg rst;
	wire [31:0] result;
	wire done;

	// Instantiate the core
	day_01_core uut (
		.clk(clk),
		.rst(rst),
		.result(result),
		.done(done)
	);

	// Clock generation
	always #5 clk = ~clk; // 100MHz clock

	initial begin
		clk = 0;
		rst = 1;
		#10;
		rst = 0;
		wait(done);	
		if (result == 1158) begin
			$display("PASS: result = %d", result);
		end	else begin
			$display("FAIL: expected 1158, got %d", result);
		end
		$finish;
	end

endmodule