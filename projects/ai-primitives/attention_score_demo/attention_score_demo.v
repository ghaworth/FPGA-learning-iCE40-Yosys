`default_nettype none

module attention_score_demo (
    input  wire clk,
    input  wire reset,
    input  wire start,
    
    // The Query token (4 dimensions)
    input  wire signed [7:0] q0, q1, q2, q3,
    
    // The resulting attention scores against K0 and K1
    output reg  signed [15:0] score_0,
    output reg  signed [15:0] score_1,
    output reg  done
);

    reg [3:0] step;
    reg signed [15:0] acc;

    // The single, shared multiplier inputs. 
    // By routing everything through these registers, Yosys synthesizes EXACTLY ONE multiplier.
    reg signed [7:0] cur_q;
    reg signed [7:0] cur_k;
    wire signed [15:0] product = cur_q * cur_k;

    always @(posedge clk) begin
        if (reset) begin
            step <= 0;
            done <= 0;
            acc <= 0;
            score_0 <= 0;
            score_1 <= 0;
            cur_q <= 0;
            cur_k <= 0;
        end else begin
            done <= 0;
            case (step)
                0: begin
                    if (start) begin
                        acc <= 0;
                        // Load first elements: Q[0] and K0[0]
                        cur_q <= q0; cur_k <= 8'sd1; 
                        step <= 1;
                    end
                end
                
                // --- Compute Score 0 (Query dot K0) ---
                // K0 = [1, -1, 2, 0]
                1: begin acc <= acc + product; cur_q <= q1; cur_k <= -8'sd1; step <= 2; end
                2: begin acc <= acc + product; cur_q <= q2; cur_k <=  8'sd2; step <= 3; end
                3: begin acc <= acc + product; cur_q <= q3; cur_k <=  8'sd0; step <= 4; end
                4: begin 
                    score_0 <= acc + product; // Finalize Score 0
                    acc <= 0;                 // Reset accumulator for next key
                    cur_q <= q0; cur_k <=  8'sd0; // Load first elements: Q[0] and K1[0]
                    step <= 5; 
                end
                
                // --- Compute Score 1 (Query dot K1) ---
                // K1 = [0, 2, -2, 1]
                5: begin acc <= acc + product; cur_q <= q1; cur_k <=  8'sd2; step <= 6; end
                6: begin acc <= acc + product; cur_q <= q2; cur_k <= -8'sd2; step <= 7; end
                7: begin acc <= acc + product; cur_q <= q3; cur_k <=  8'sd1; step <= 8; end
                8: begin 
                    score_1 <= acc + product; // Finalize Score 1
                    done <= 1;
                    step <= 0; 
                end
            endcase
        end
    end
endmodule
