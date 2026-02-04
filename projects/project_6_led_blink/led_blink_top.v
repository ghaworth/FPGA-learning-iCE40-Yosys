///////////////////////////////////////////////////////////////////////////////
// Module: LED_Blink_Top
// Purpose: Top-level module for hardware synthesis
//
// This module instantiates LED_Blink with parameters set for 25 MHz operation.
// The parameters define the counter limits for each LED to blink at:
//   LED 1: 10 Hz
//   LED 2: 5 Hz
//   LED 3: 2 Hz
//   LED 4: 1 Hz
//
// Note: LED 1 (10 Hz) is instantiated as open in the current design,
// meaning it toggles internally but isn't wired to an output.
///////////////////////////////////////////////////////////////////////////////

module LED_Blink_Top (
  input i_Clk,
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4
);

  // Instantiate LED_Blink with hardware parameters
  // For 25 MHz clock operation
  LED_Blink #(
    .g_COUNT_10HZ(1250000),
    .g_COUNT_5HZ(2500000),
    .g_COUNT_2HZ(6250000),
    .g_COUNT_1HZ(12500000)
  ) LED_Blink_Inst (
    .i_Clk(i_Clk),
    .o_LED_1(o_LED_1),
    .o_LED_2(o_LED_2),
    .o_LED_3(o_LED_3),
    .o_LED_4(o_LED_4)
  );

endmodule
