///////////////////////////////////////////////////////////////////////////////
// Module: VGA_Sync_Porch
// Purpose: Add blanking during front/back porch and pass-through RGB video
//
// This module ensures that video data is only driven during the active area.
// During blanking periods (front porch, sync pulse, back porch), the RGB
// outputs are forced to 0 (black). This is important for VGA monitors to
// properly sync and display the image.
//
// The sync pulses are passed through unchanged. The RGB data is blanked
// (set to 0) when not in the active area.
///////////////////////////////////////////////////////////////////////////////

module VGA_Sync_Porch (
  input i_Clk,
  input i_HSync,
  input i_VSync,
  input [2:0] i_Red_Video,
  input [2:0] i_Grn_Video,
  input [2:0] i_Blu_Video,
  input [9:0] i_Col_Count,
  input [9:0] i_Row_Count,
  output reg o_HSync,
  output reg o_VSync,
  output reg [2:0] o_Red_Video,
  output reg [2:0] o_Grn_Video,
  output reg [2:0] o_Blu_Video
);

  parameter TOTAL_COLS = 800;
  parameter TOTAL_ROWS = 525;
  parameter ACTIVE_COLS = 640;
  parameter ACTIVE_ROWS = 480;

  ///////////////////////////////////////////////////////////////////////////////
  // Blanking Logic: Set video to 0 when outside active area
  ///////////////////////////////////////////////////////////////////////////////
  // The active area is defined by ACTIVE_COLS x ACTIVE_ROWS
  // Outside this area, all video outputs should be 0 (black)
  
  always @(posedge i_Clk)
  begin
    o_HSync <= i_HSync;
    o_VSync <= i_VSync;

    // Determine if we're in the active area
    if ((i_Col_Count < ACTIVE_COLS) && (i_Row_Count < ACTIVE_ROWS))
    begin
      // Inside active area: pass through the color
      o_Red_Video <= i_Red_Video;
      o_Grn_Video <= i_Grn_Video;
      o_Blu_Video <= i_Blu_Video;
    end
    else
    begin
      // Outside active area (blanking): output black
      o_Red_Video <= 3'b000;
      o_Grn_Video <= 3'b000;
      o_Blu_Video <= 3'b000;
    end
  end

endmodule
