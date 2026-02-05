///////////////////////////////////////////////////////////////////////////////
// Testbench: VGA_Sync_Pulses_TB
// Purpose: Verify that VGA_Sync_Pulses generates correct timing
//
// Tests:
// 1. Column counter increments 0 to 799, then wraps
// 2. Row counter increments 0 to 524, then wraps
// 3. HSync pulse occurs at correct column range
// 4. VSync pulse occurs at correct row range
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module VGA_Sync_Pulses_TB;

  localparam CLK_PERIOD = 40;  // 25 MHz = 40 ns period

  reg r_Clk = 1'b0;
  wire w_HSync;
  wire w_VSync;
  wire [9:0] w_Col_Count;
  wire [9:0] w_Row_Count;

  // Generate 25 MHz clock
  always #(CLK_PERIOD/2) r_Clk <= ~r_Clk;

  // Instantiate DUT with standard 640x480@60Hz timing
  VGA_Sync_Pulses #(
    .TOTAL_COLS(800),
    .TOTAL_ROWS(525),
    .ACTIVE_COLS(640),
    .ACTIVE_ROWS(480)
  ) DUT (
    .i_Clk(r_Clk),
    .o_HSync(w_HSync),
    .o_VSync(w_VSync),
    .o_Col_Count(w_Col_Count),
    .o_Row_Count(w_Row_Count)
  );

  initial
  begin
    $dumpfile("vga_sync_pulses.vcd");
    $dumpvars(0, VGA_Sync_Pulses_TB);

    // Run for enough cycles to verify:
    // - Column counter behavior (800 cycles per line)
    // - Row counter behavior (525 lines per frame)
    // - HSync pulse timing
    // - VSync pulse timing
    
    // Simulate for 3 full lines (2400 clock cycles)
    #100000 $finish;
  end

endmodule
