`default_nettype none
`timescale 1ns/1ps

module attention_score_demo_tb;

    reg clk = 0;
    reg reset = 0;
    reg start = 0;
    reg signed [7:0] q0, q1, q2, q3;
    
    wire signed [15:0] score_0;
    wire signed [15:0] score_1;
    wire done;

    attention_score_demo uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .q0(q0), .q1(q1), .q2(q2), .q3(q3),
        .score_0(score_0),
        .score_1(score_1),
        .done(done)
    );

    always #20 clk = ~clk;

    initial begin
        $dumpfile("attention_score_demo_tb.vcd");
        $dumpvars(0, attention_score_demo_tb);

        reset = 1;
        #40;
        reset = 0;
        #40;

        // Provide Query = [1, 2, 3, 4]
        // K0 is hardcoded as [1, -1,  2, 0] -> Expected Score: (1*1) + (2*-1) + (3*2) + (4*0) = 5
        // K1 is hardcoded as [0,  2, -2, 1] -> Expected Score: (1*0) + (2*2) + (3*-2) + (4*1) = 2
        
        q0 = 8'sd1;
        q1 = 8'sd2;
        q2 = 8'sd3;
        q3 = 8'sd4;
        
        start = 1;
        #40;
        start = 0;

        // Wait for the 'done' signal
        wait(done == 1);
        #40;

        if (score_0 === 16'sd5) begin
            $display("PASS: Score 0 is exactly 5");
        end else begin
            $display("FAIL: Score 0 is %d, expected 5", score_0);
        end

        if (score_1 === 16'sd2) begin
            $display("PASS: Score 1 is exactly 2");
        end else begin
            $display("FAIL: Score 1 is %d, expected 2", score_1);
        end

        $finish;
    end
endmodule
