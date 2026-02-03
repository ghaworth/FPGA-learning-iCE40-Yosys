///////////////////////////////////////////////////////////////////////////////
// Project 5: Seven Segment Display
// 
// Description:
// Increment a binary counter (0-9) each time a switch is released.
// Display the counter value on a 7-segment display.
//
// Design:
// 1. Debounce the switch input
// 2. Detect rising edge (switch release)
// 3. Increment counter (mod 10)
// 4. Convert counter to 7-segment display encoding
// 5. Output inverted segments (Go Board uses active-low)
///////////////////////////////////////////////////////////////////////////////

module Project_7_Segment_Top (
  input i_Clk,
  input i_Switch_1,
  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G
);

  wire w_Switch_1;
  reg r_Switch_1 = 1'b0;
  reg [3:0] r_Count = 4'b0000;

  wire w_Segment_A;
  wire w_Segment_B;
  wire w_Segment_C;
  wire w_Segment_D;
  wire w_Segment_E;
  wire w_Segment_F;
  wire w_Segment_G;

  // Instantiate Debounce Filter
  Debounce_Switch Debounce_Switch_Inst (
    .i_Clk(i_Clk),
    .i_Switch(i_Switch_1),
    .o_Switch(w_Switch_1)
  );

  // Purpose: When Switch is pressed and released, increment counter.
  // When counter gets to 9, start it back at 0 again.
  always @(posedge i_Clk)
  begin
    r_Switch_1 <= w_Switch_1;

    // Increment Count when switch transitions from 0 to 1 (release)
    if (w_Switch_1 == 1'b1 && r_Switch_1 == 1'b0)
    begin
      if (r_Count == 9)
        r_Count <= 4'b0000;
      else
        r_Count <= r_Count + 1;
    end
  end

  // Instantiate Binary to 7-Segment Converter
  Binary_To_7Segment Binary_To_7Segment_Inst (
    .i_Clk(i_Clk),
    .i_Binary_Num(r_Count),
    .o_Segment_A(w_Segment_A),
    .o_Segment_B(w_Segment_B),
    .o_Segment_C(w_Segment_C),
    .o_Segment_D(w_Segment_D),
    .o_Segment_E(w_Segment_E),
    .o_Segment_F(w_Segment_F),
    .o_Segment_G(w_Segment_G)
  );

  // Go Board uses active-low segments, so invert the outputs
  assign o_Segment2_A = ~w_Segment_A;
  assign o_Segment2_B = ~w_Segment_B;
  assign o_Segment2_C = ~w_Segment_C;
  assign o_Segment2_D = ~w_Segment_D;
  assign o_Segment2_E = ~w_Segment_E;
  assign o_Segment2_F = ~w_Segment_F;
  assign o_Segment2_G = ~w_Segment_G;

endmodule
