`default_nettype none
`timescale 1ns/1ps

module dot_product_4_tb;

    reg clk = 0;
    reg valid_in = 0;
    
    reg signed [7:0] a0, a1, a2, a3;
    reg signed [7:0] b0, b1, b2, b3;
    
    wire signed [15:0] result;
    wire valid_out;

    dot_product_4 #(
        .D_WIDTH(8),
        .ACC_WIDTH(16)
    ) uut (
        .clk(clk),
        .valid_in(valid_in),
        .a0(a0), .a1(a1), .a2(a2), .a3(a3),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3),
        .result(result),
        .valid_out(valid_out)
    );

    always #20 clk = ~clk;

    initial begin
        $dumpfile("dot_product_4_tb.vcd");
        $dumpvars(0, dot_product_4_tb);

        // Test vectors: 
        // A = [ 1,  2, -1,  4]
        // B = [ 3, -2,  5,  2]
        // Expected = (1*3) + (2*-2) + (-1*5) + (4*2)
        //          = 3 - 4 - 5 + 8 = 2
        
        #40;
        valid_in = 1;
        a0 = 8'sd1;  b0 = 8'sd3;
        a1 = 8'sd2;  b1 = -8'sd2;
        a2 = -8'sd1; b2 = 8'sd5;
        a3 = 8'sd4;  b3 = 8'sd2;
        
        #40;
        valid_in = 0;
        #40;

        if (result === 16'sd2) begin
            $display("PASS: Dot product holds expected value 2");
        end else begin
            $display("FAIL: Dot product is %d, expected 2", result);
        end

        $finish;
    end
endmodule
