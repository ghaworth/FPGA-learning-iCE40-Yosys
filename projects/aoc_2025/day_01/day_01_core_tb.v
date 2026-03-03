`timescale 1ns/1ps

module day_01_core_tb;
	reg clk;
	reg start;
	wire [31:0] result;
	wire done;

	// Instantiate the core
	Day_01_Core uut (
		.clk(clk),
		.start(start),
		.result(result),
		.done(done)
	);

	// Clock generation
	always #5 clk = ~clk; // 100MHz clock

	initial begin
		clk = 0;
		start = 1;
		#10;
		start = 0;

		@(posedge clk);
		wait(done);	
		if (result == 6860) begin
			$display("PASS: result = %d", result);
		end	else begin
			$display("FAIL: expected 6860, got %d", result);
		end
		$finish;
	end

	initial begin
    #100000;
    $display("TIMEOUT: done never asserted");
    $finish;
	end

endmodule