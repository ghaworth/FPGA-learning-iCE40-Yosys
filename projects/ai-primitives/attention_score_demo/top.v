`default_nettype none

module top (
    input  wire i_Clk,
    input  wire i_Switch_1,
    output wire o_LED_1,
    output wire o_LED_2,
    output wire o_LED_3,
    output wire o_LED_4
);

    wire w_Switch_1_Debounced;
    
    Debounce_Switch debounce_inst (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(w_Switch_1_Debounced)
    );

    // Initialize to 0 so it matches the debounce module's boot state.
    // (After 10ms, debounce goes to 1 since the physical button is active-low and unpressed).
    reg r_Switch_1_Sync1 = 1'b0; 
    reg r_Switch_1_Sync2 = 1'b0;

    always @(posedge i_Clk) begin
        r_Switch_1_Sync1 <= w_Switch_1_Debounced;
        r_Switch_1_Sync2 <= r_Switch_1_Sync1;
    end

    // Falling edge detection: 1 -> 0 (Button pressed)
    wire w_Start_Pulse = (r_Switch_1_Sync2 == 1'b1 && r_Switch_1_Sync1 == 1'b0);

    wire signed [15:0] w_Score_0;
    wire signed [15:0] w_Score_1;
    wire w_Done;

    attention_score_demo core (
        .clk(i_Clk),
        .reset(1'b0),
        .start(w_Start_Pulse),
        .q0(8'sd1),   
        .q1(8'sd2),
        .q2(8'sd3),
        .q3(8'sd4),
        .score_0(w_Score_0),
        .score_1(w_Score_1),
        .done(w_Done)
    );

    // Toggle state to flip between showing Score 0 and Score 1
    reg r_Toggle = 1'b0;
    reg [3:0] r_LEDs = 4'b0000;
    
    always @(posedge i_Clk) begin
        if (w_Start_Pulse) begin
            r_Toggle <= ~r_Toggle; // Flip the toggle
            r_LEDs <= 4'b0000;     // Clear LEDs so we know it's thinking
        end else if (w_Done) begin
            if (r_Toggle == 1'b1) begin
                r_LEDs <= w_Score_0[3:0]; // Show 5 (LEDs 1 & 3)
            end else begin
                r_LEDs <= w_Score_1[3:0]; // Show 2 (LED 2)
            end
        end
    end

    assign o_LED_1 = r_LEDs[0];
    assign o_LED_2 = r_LEDs[1];
    assign o_LED_3 = r_LEDs[2];
    assign o_LED_4 = r_LEDs[3];

endmodule
