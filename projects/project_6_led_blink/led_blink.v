///////////////////////////////////////////////////////////////////////////////
// Module: LED_Blink
// Purpose: Controls four LEDs, each blinking at a different rate
//
// Each LED has an independent counter. When the counter reaches its limit,
// the LED toggles and the counter resets. This creates a blinking effect at
// the rate determined by the counter limit and clock frequency.
//
// Parameters are used to make the design portable. For hardware synthesis,
// parameters are set to counts for 25 MHz clock. For testbench simulation,
// parameters are set to much smaller values to speed up testing.
///////////////////////////////////////////////////////////////////////////////

module LED_Blink (
  input i_Clk,
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4
);

  // Parameters set the toggle rate for each LED
  // For 25 MHz clock:
  //   10 Hz = 1,250,000 cycles
  //    5 Hz = 2,500,000 cycles
  //    2 Hz = 6,250,000 cycles
  //    1 Hz = 12,500,000 cycles
  parameter g_COUNT_10HZ = 1250000;
  parameter g_COUNT_5HZ  = 2500000;
  parameter g_COUNT_2HZ  = 6250000;
  parameter g_COUNT_1HZ  = 12500000;

  reg r_LED_1 = 1'b0;
  reg r_LED_2 = 1'b0;
  reg r_LED_3 = 1'b0;
  reg r_LED_4 = 1'b0;

  reg [24:0] r_Count_1 = 25'b0;  // Counter for LED 1 (10 Hz)
  reg [24:0] r_Count_2 = 25'b0;  // Counter for LED 2 (5 Hz)
  reg [24:0] r_Count_3 = 25'b0;  // Counter for LED 3 (2 Hz)
  reg [24:0] r_Count_4 = 25'b0;  // Counter for LED 4 (1 Hz)

  // LED 1: 10 Hz
  always @(posedge i_Clk)
  begin
    if (r_Count_1 == g_COUNT_10HZ)
    begin
      r_LED_1 <= ~r_LED_1;
      r_Count_1 <= 25'b0;
    end
    else
      r_Count_1 <= r_Count_1 + 1;
  end

  // LED 2: 5 Hz
  always @(posedge i_Clk)
  begin
    if (r_Count_2 == g_COUNT_5HZ)
    begin
      r_LED_2 <= ~r_LED_2;
      r_Count_2 <= 25'b0;
    end
    else
      r_Count_2 <= r_Count_2 + 1;
  end

  // LED 3: 2 Hz
  always @(posedge i_Clk)
  begin
    if (r_Count_3 == g_COUNT_2HZ)
    begin
      r_LED_3 <= ~r_LED_3;
      r_Count_3 <= 25'b0;
    end
    else
      r_Count_3 <= r_Count_3 + 1;
  end

  // LED 4: 1 Hz
  always @(posedge i_Clk)
  begin
    if (r_Count_4 == g_COUNT_1HZ)
    begin
      r_LED_4 <= ~r_LED_4;
      r_Count_4 <= 25'b0;
    end
    else
      r_Count_4 <= r_Count_4 + 1;
  end

  assign o_LED_1 = r_LED_1;
  assign o_LED_2 = r_LED_2;
  assign o_LED_3 = r_LED_3;
  assign o_LED_4 = r_LED_4;

endmodule
