///////////////////////////////////////////////////////////////////////////////
// Module: VGA_Sync_Pulses
// Purpose: Generate VGA horizontal and vertical sync pulses with pixel/line counters
//
// This module creates the fundamental timing for VGA displays. It generates:
// - Horizontal sync (HSync) pulses
// - Vertical sync (VSync) pulses  
// - Column counter (pixel position in current line, 0 to TOTAL_COLS-1)
// - Row counter (line position in current frame, 0 to TOTAL_ROWS-1)
//
// Parameters allow 640x480@60Hz or other resolutions.
//
// VGA Timing (640x480@60Hz with 25MHz clock):
//   Total columns: 800 pixels (640 active + 160 blanking)
//   Total rows: 525 lines (480 active + 45 blanking)
//   HSync pulse: 96 pixels (positioned in blanking area)
//   VSync pulse: 2 lines (positioned in blanking area)
///////////////////////////////////////////////////////////////////////////////

module VGA_Sync_Pulses (
  input i_Clk,
  output o_HSync,
  output o_VSync,
  output reg [9:0] o_Col_Count,  // 0 to 799 (TOTAL_COLS-1)
  output reg [9:0] o_Row_Count   // 0 to 524 (TOTAL_ROWS-1)
);

  // VGA timing parameters (640x480@60Hz, 25MHz clock)
  parameter TOTAL_COLS = 800;   // Total pixels per line
  parameter TOTAL_ROWS = 525;   // Total lines per frame
  parameter ACTIVE_COLS = 640;  // Active display area width
  parameter ACTIVE_ROWS = 480;  // Active display area height

  // Derived timing values
  localparam HSYNC_START = 656;  // HSync starts after front porch (ACTIVE_COLS + 16)
  localparam HSYNC_END   = 752;  // HSync ends (HSYNC_START + 96)
  
  localparam VSYNC_START = 490;  // VSync starts after front porch (ACTIVE_ROWS + 10)
  localparam VSYNC_END   = 492;  // VSync ends (VSYNC_START + 2)

  ///////////////////////////////////////////////////////////////////////////////
  // Pixel/Line Counters: Increment every clock cycle
  ///////////////////////////////////////////////////////////////////////////////
  // HSync is active (low) when we're in the sync pulse area
  // VSync is active (low) when we're in the sync pulse area
  
  always @(posedge i_Clk)
  begin
    // Increment column counter
    if (o_Col_Count == TOTAL_COLS - 1)
    begin
      o_Col_Count <= 10'b0;
      
      // At end of line, increment row counter
      if (o_Row_Count == TOTAL_ROWS - 1)
        o_Row_Count <= 10'b0;  // Frame wrap: reset to top
      else
        o_Row_Count <= o_Row_Count + 1;
    end
    else
      o_Col_Count <= o_Col_Count + 1;
  end

  ///////////////////////////////////////////////////////////////////////////////
  // HSync and VSync Pulse Generation
  ///////////////////////////////////////////////////////////////////////////////
  // VGA standard: syncs are ACTIVE LOW (0 = sync active, 1 = sync inactive)
  // HSync pulse: narrow pulse in horizontal blanking area
  // VSync pulse: narrow pulse in vertical blanking area
  
  assign o_HSync = ~((o_Col_Count >= HSYNC_START) && (o_Col_Count < HSYNC_END));
  assign o_VSync = ~((o_Row_Count >= VSYNC_START) && (o_Row_Count < VSYNC_END));

endmodule
