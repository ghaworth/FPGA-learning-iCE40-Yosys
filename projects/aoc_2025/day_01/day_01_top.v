module Day_01_Top (
  input i_Clk,
  input i_Switch_1,
  output o_Segment1_A,
  output o_Segment1_B,
  output o_Segment1_C,
  output o_Segment1_D,
  output o_Segment1_E,
  output o_Segment1_F,
  output o_Segment1_G,
  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G,
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4
);
  // core outputs
  wire [31:0] core_result;
  wire core_done;

  // bcd converter outputs
  wire [63:0] bcd_result;
  wire bcd_done;

  // scroll display outputs
  wire [4:0] left_digit;
  wire [4:0] right_digit;

  // debounced switch
  wire reset_debounced;

  reg button_prev = 0;
  wire button_edge;
  assign button_edge = reset_debounced && !button_prev;

  reg core_done_prev = 0;
  wire core_done_edge;
  assign core_done_edge = core_done && !core_done_prev;

  always @(posedge i_Clk) begin
    button_prev <= reset_debounced;
    core_done_prev <= core_done;
  end  

  Debounce_Switch debounce_reset (
    .i_Clk(i_Clk),
    .i_Switch(i_Switch_1),
    .o_Switch(reset_debounced)
  );

  Day_01_Core core (
    .clk(i_Clk),
    .result(core_result),
    .done(core_done),
    .start(button_edge)
  ); 

  bin_to_bcd b2bcd (
    .start(core_done_edge),
    .clk(i_Clk),
    .bin_num(core_result),
    .bcd_num(bcd_result),
    .done(bcd_done)
  );

  scroll_display sdisp (
    .clk(i_Clk),
    .start(bcd_done),
    .left_digit(left_digit),
    .right_digit(right_digit),
    .bcd_num(bcd_result),
    .num_digits(5'd4)
  );

  Binary_To_7Segment seg1 (
    .i_Clk(i_Clk),
    .i_Binary_Num(left_digit),
    .o_Segment_A(o_Segment1_A),
    .o_Segment_B(o_Segment1_B),
    .o_Segment_C(o_Segment1_C),
    .o_Segment_D(o_Segment1_D),
    .o_Segment_E(o_Segment1_E),
    .o_Segment_F(o_Segment1_F),
    .o_Segment_G(o_Segment1_G)
);

Binary_To_7Segment seg2 (
    .i_Clk(i_Clk),
    .i_Binary_Num(right_digit),
    .o_Segment_A(o_Segment2_A),
    .o_Segment_B(o_Segment2_B),
    .o_Segment_C(o_Segment2_C),
    .o_Segment_D(o_Segment2_D),
    .o_Segment_E(o_Segment2_E),
    .o_Segment_F(o_Segment2_F),
    .o_Segment_G(o_Segment2_G)
);

assign o_LED_1 = core_done;
assign o_LED_2 = bcd_done;
assign o_LED_3 = |left_digit;   // any bits set in left_digit
assign o_LED_4 = reset_debounced;

endmodule