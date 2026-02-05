///////////////////////////////////////////////////////////////////////////////
// Project 9: VGA Introduction - Test Pattern Display
//
// Top-level module for VGA display on Go Board.
// Displays a test pattern on a VGA monitor connected to the board.
//
// Currently displays pattern 4 (color bars) by default.
// Future: Add UART input to select different patterns.
///////////////////////////////////////////////////////////////////////////////

module Project_9_VGA_Top (
  input i_Clk,
  
  // VGA output (11 pins total: HSync, VSync, R[2:0], G[2:0], B[2:0])
  output o_VGA_HSync,
  output o_VGA_VSync,
  output o_VGA_Red_0,
  output o_VGA_Red_1,
  output o_VGA_Red_2,
  output o_VGA_Grn_0,
  output o_VGA_Grn_1,
  output o_VGA_Grn_2,
  output o_VGA_Blu_0,
  output o_VGA_Blu_1,
  output o_VGA_Blu_2
);

  // VGA timing parameters for 640x480@60Hz with 25MHz clock
  localparam TOTAL_COLS  = 800;
  localparam TOTAL_ROWS  = 525;
  localparam ACTIVE_COLS = 640;
  localparam ACTIVE_ROWS = 480;

  // Internal signals
  wire [9:0] w_Col_Count;
  wire [9:0] w_Row_Count;
  
  wire w_HSync_Raw;
  wire w_VSync_Raw;
  
  wire w_HSync_TP;
  wire w_VSync_TP;
  wire [2:0] w_Red_TP;
  wire [2:0] w_Grn_TP;
  wire [2:0] w_Blu_TP;
  
  wire w_HSync_Porch;
  wire w_VSync_Porch;
  wire [2:0] w_Red_Porch;
  wire [2:0] w_Grn_Porch;
  wire [2:0] w_Blu_Porch;

  // Pattern selector: Currently hardcoded to pattern 4 (color bars)
  // Future: Wire to UART input
  wire [3:0] w_Pattern = 4'h4;

  ///////////////////////////////////////////////////////////////////////////////
  // Module Instantiation: VGA Sync Pulse Generation
  ///////////////////////////////////////////////////////////////////////////////
  // Generates pixel/line counters and HSync/VSync timing
  VGA_Sync_Pulses #(
    .TOTAL_COLS(TOTAL_COLS),
    .TOTAL_ROWS(TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS)
  ) VGA_Sync_Pulses_Inst (
    .i_Clk(i_Clk),
    .o_HSync(w_HSync_Raw),
    .o_VSync(w_VSync_Raw),
    .o_Col_Count(w_Col_Count),
    .o_Row_Count(w_Row_Count)
  );

  ///////////////////////////////////////////////////////////////////////////////
  // Module Instantiation: Test Pattern Generator
  ///////////////////////////////////////////////////////////////////////////////
  // Generates RGB color based on pixel position and selected pattern
  VGA_Test_Pattern #(
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS)
  ) VGA_Test_Pattern_Inst (
    .i_Clk(i_Clk),
    .i_Pattern(w_Pattern),
    .i_HSync(w_HSync_Raw),
    .i_VSync(w_VSync_Raw),
    .i_Col_Count(w_Col_Count),
    .i_Row_Count(w_Row_Count),
    .o_HSync(w_HSync_TP),
    .o_VSync(w_VSync_TP),
    .o_Red_Video(w_Red_TP),
    .o_Grn_Video(w_Grn_TP),
    .o_Blu_Video(w_Blu_TP)
  );

  ///////////////////////////////////////////////////////////////////////////////
  // Module Instantiation: Sync Porch (Blanking)
  ///////////////////////////////////////////////////////////////////////////////
  // Blanks RGB during non-active areas, passes sync signals
  VGA_Sync_Porch #(
    .TOTAL_COLS(TOTAL_COLS),
    .TOTAL_ROWS(TOTAL_ROWS),
    .ACTIVE_COLS(ACTIVE_COLS),
    .ACTIVE_ROWS(ACTIVE_ROWS)
  ) VGA_Sync_Porch_Inst (
    .i_Clk(i_Clk),
    .i_HSync(w_HSync_TP),
    .i_VSync(w_VSync_TP),
    .i_Red_Video(w_Red_TP),
    .i_Grn_Video(w_Grn_TP),
    .i_Blu_Video(w_Blu_TP),
    .i_Col_Count(w_Col_Count),
    .i_Row_Count(w_Row_Count),
    .o_HSync(w_HSync_Porch),
    .o_VSync(w_VSync_Porch),
    .o_Red_Video(w_Red_Porch),
    .o_Grn_Video(w_Grn_Porch),
    .o_Blu_Video(w_Blu_Porch)
  );

  ///////////////////////////////////////////////////////////////////////////////
  // Output Assignment: Drive VGA pins
  ///////////////////////////////////////////////////////////////////////////////
  assign o_VGA_HSync = w_HSync_Porch;
  assign o_VGA_VSync = w_VSync_Porch;
  
  // Red channel (3 bits)
  assign o_VGA_Red_0 = w_Red_Porch[0];
  assign o_VGA_Red_1 = w_Red_Porch[1];
  assign o_VGA_Red_2 = w_Red_Porch[2];
  
  // Green channel (3 bits)
  assign o_VGA_Grn_0 = w_Grn_Porch[0];
  assign o_VGA_Grn_1 = w_Grn_Porch[1];
  assign o_VGA_Grn_2 = w_Grn_Porch[2];
  
  // Blue channel (3 bits)
  assign o_VGA_Blu_0 = w_Blu_Porch[0];
  assign o_VGA_Blu_1 = w_Blu_Porch[1];
  assign o_VGA_Blu_2 = w_Blu_Porch[2];

endmodule
