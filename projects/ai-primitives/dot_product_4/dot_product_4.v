`default_nettype none

module dot_product_4 #(
    parameter D_WIDTH = 8,
    parameter ACC_WIDTH = 16
) (
    input  wire                        clk,
    input  wire                        valid_in,
    
    // 4 elements of Vector A
    input  wire signed [D_WIDTH-1:0]   a0,
    input  wire signed [D_WIDTH-1:0]   a1,
    input  wire signed [D_WIDTH-1:0]   a2,
    input  wire signed [D_WIDTH-1:0]   a3,
    
    // 4 elements of Vector B
    input  wire signed [D_WIDTH-1:0]   b0,
    input  wire signed [D_WIDTH-1:0]   b1,
    input  wire signed [D_WIDTH-1:0]   b2,
    input  wire signed [D_WIDTH-1:0]   b3,
    
    output reg  signed [ACC_WIDTH-1:0] result,
    output reg                         valid_out
);

    // Wires for the intermediate products
    wire signed [15:0] p0 = a0 * b0;
    wire signed [15:0] p1 = a1 * b1;
    wire signed [15:0] p2 = a2 * b2;
    wire signed [15:0] p3 = a3 * b3;

    // Pipeline: Add the products and register the output
    always @(posedge clk) begin
        valid_out <= valid_in;
        if (valid_in) begin
            result <= p0 + p1 + p2 + p3;
        end
    end

endmodule

