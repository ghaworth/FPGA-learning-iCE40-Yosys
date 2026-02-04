///////////////////////////////////////////////////////////////////////////////
// Testbench: LED_Blink_TB
// Purpose: Simulate LED_Blink module with fast-running parameters
//
// This testbench generates a clock, instantiates the LED_Blink module with
// small counter parameters (to speed up simulation), and monitors the outputs.
// The waveforms are dumped to a VCD file for inspection.
//
// Parameters are set much smaller than hardware values to make simulation fast:
//   LED 1 (10 Hz simulation): toggles every 10 cycles
//   LED 2 (5 Hz simulation):  toggles every 20 cycles
//   LED 3 (2 Hz simulation):  toggles every 40 cycles
//   LED 4 (1 Hz simulation):  toggles every 80 cycles
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module LED_Blink_TB;

  // Simulation clock: 25 MHz = 40 ns period
  // We'll use 1 ns units, so 40 time units per clock cycle
  localparam CLK_PERIOD = 40;

  reg r_Clk = 1'b0;
  wire w_LED_1;
  wire w_LED_2;
  wire w_LED_3;
  wire w_LED_4;

  // Generate a 25 MHz clock
  // This is simulation-only code (non-synthesizable)
  always #(CLK_PERIOD/2) r_Clk <= ~r_Clk;

  // Instantiate LED_Blink with small parameters for fast simulation
  LED_Blink #(
    .g_COUNT_10HZ(10),   // Toggle LED 1 every 10 cycles
    .g_COUNT_5HZ(20),    // Toggle LED 2 every 20 cycles
    .g_COUNT_2HZ(40),    // Toggle LED 3 every 40 cycles
    .g_COUNT_1HZ(80)     // Toggle LED 4 every 80 cycles
  ) LED_Blink_UUT (
    .i_Clk(r_Clk),
    .o_LED_1(w_LED_1),
    .o_LED_2(w_LED_2),
    .o_LED_3(w_LED_3),
    .o_LED_4(w_LED_4)
  );

  // Simulation-only code: initialize, dump waveforms, and run
  initial
  begin
    // Dump waveforms to VCD file for viewing in gtkwave
    $dumpfile("led_blink.vcd");
    $dumpvars(0, LED_Blink_TB);

    // Run simulation for 2000 time units (50 clock cycles at 40ns/cycle)
    // This is enough to see all LEDs toggle at least once
    #2000 $finish;
  end

endmodule
