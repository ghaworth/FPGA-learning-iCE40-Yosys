`default_nettype none

module mac_unit #(
    parameter D_WIDTH = 8,
    parameter ACC_WIDTH = 16
) (
    input  wire                        clk,
    input  wire                        reset,     // Synchronous reset (clears accumulator)
    input  wire                        valid_in,  // When high, multiply and accumulate
    input  wire signed [D_WIDTH-1:0]   a,
    input  wire signed [D_WIDTH-1:0]   b,
    output reg  signed [ACC_WIDTH-1:0] acc,
    output reg                         valid_out
);

    // At 25MHz on iCE40, an 8x8 LUT-based multiply easily fits in one cycle.
    always @(posedge clk) begin
        if (reset) begin
            acc <= 0;
            valid_out <= 0;
        end else begin
            valid_out <= valid_in;
            if (valid_in) begin
                acc <= acc + (a * b);
            end
        end
    end

endmodule
