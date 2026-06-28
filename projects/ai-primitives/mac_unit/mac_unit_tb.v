`default_nettype none
`timescale 1ns/1ps

module mac_unit_tb;

    reg clk = 0;
    reg reset = 0;
    reg valid_in = 0;
    reg signed [7:0] a = 0;
    reg signed [7:0] b = 0;
    wire signed [15:0] acc;
    wire valid_out;

    mac_unit #(
        .D_WIDTH(8),
        .ACC_WIDTH(16)
    ) uut (
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .a(a),
        .b(b),
        .acc(acc),
        .valid_out(valid_out)
    );

    always #20 clk = ~clk; // 25 MHz clock (40ns period)

    initial begin
        $dumpfile("mac_unit_tb.vcd");
        $dumpvars(0, mac_unit_tb);

        // 1. Reset the module
        reset = 1;
        #40;
        reset = 0;
        #40;

        // 2. Test positive * positive: 3 * 4 = 12
        valid_in = 1;
        a = 8'sd3;
        b = 8'sd4;
        #40;
        
        // 3. Test negative * positive: -2 * 5 = -10 (Accumulated total: 12 - 10 = 2)
        a = -8'sd2;
        b = 8'sd5;
        #40;

        // 4. Stop input
        valid_in = 0;
        #40;

        if (acc === 16'sd2) begin
            $display("PASS: Accumulator holds expected value 2");
        end else begin
            $display("FAIL: Accumulator is %d, expected 2", acc);
        end

        // 5. Test reset behavior
        reset = 1;
        #40;
        reset = 0;
        
        if (acc === 0) begin
            $display("PASS: Reset cleared accumulator");
        end else begin
            $display("FAIL: Accumulator not cleared");
        end

        $finish;
    end
endmodule
