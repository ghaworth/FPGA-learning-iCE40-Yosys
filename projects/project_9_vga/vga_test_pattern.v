///////////////////////////////////////////////////////////////////////////////
// Module: VGA_Test_Pattern
// Purpose: Generate test patterns for VGA display verification
//
// This module reads the current pixel position (column, row) and generates
// appropriate RGB color based on the selected pattern. Patterns include:
// - Solid colors
// - Color bars (vertical stripes)
// - Checkerboard
// - Gradients
//
// The output is synchronous with the input - HSync/VSync are passed through
// to maintain timing alignment.
///////////////////////////////////////////////////////////////////////////////

module VGA_Test_Pattern (
  input i_Clk,
  input [3:0] i_Pattern,           // Which test pattern to display
  input i_HSync,                   // Horizontal sync (input)
  input i_VSync,                   // Vertical sync (input)
  input [9:0] i_Col_Count,         // Current column (pixel x-position)
  input [9:0] i_Row_Count,         // Current row (pixel y-position)
  output reg o_HSync,              // Horizontal sync (output, pass-through)
  output reg o_VSync,              // Vertical sync (output, pass-through)
  output reg [2:0] o_Red_Video,    // Red component (3-bit)
  output reg [2:0] o_Grn_Video,    // Green component (3-bit)
  output reg [2:0] o_Blu_Video     // Blue component (3-bit)
);

  parameter ACTIVE_COLS = 640;
  parameter ACTIVE_ROWS = 480;

  ///////////////////////////////////////////////////////////////////////////////
  // Synchronous output: Pass through sync signals and generate color
  ///////////////////////////////////////////////////////////////////////////////
  
  always @(posedge i_Clk)
  begin
    // Pass through sync signals
    o_HSync <= i_HSync;
    o_VSync <= i_VSync;

    // Default: black (0,0,0)
    o_Red_Video <= 3'b000;
    o_Grn_Video <= 3'b000;
    o_Blu_Video <= 3'b000;

    // Generate color based on selected pattern
    case (i_Pattern)
      4'h0: // Pattern 0: Solid Red
      begin
        o_Red_Video <= 3'b111;
        o_Grn_Video <= 3'b000;
        o_Blu_Video <= 3'b000;
      end

      4'h1: // Pattern 1: Solid Green
      begin
        o_Red_Video <= 3'b000;
        o_Grn_Video <= 3'b111;
        o_Blu_Video <= 3'b000;
      end

      4'h2: // Pattern 2: Solid Blue
      begin
        o_Red_Video <= 3'b000;
        o_Grn_Video <= 3'b000;
        o_Blu_Video <= 3'b111;
      end

      4'h3: // Pattern 3: White
      begin
        o_Red_Video <= 3'b111;
        o_Grn_Video <= 3'b111;
        o_Blu_Video <= 3'b111;
      end

      4'h4: // Pattern 4: Color Bars (vertical stripes - 8 colors)
      begin
        // Divide screen into 8 vertical bars
        case (i_Col_Count[9:7])  // Top 3 bits: 8 divisions
          3'b000:  // Red
          begin
            o_Red_Video <= 3'b111;
            o_Grn_Video <= 3'b000;
            o_Blu_Video <= 3'b000;
          end
          3'b001:  // Green
          begin
            o_Red_Video <= 3'b000;
            o_Grn_Video <= 3'b111;
            o_Blu_Video <= 3'b000;
          end
          3'b010:  // Blue
          begin
            o_Red_Video <= 3'b000;
            o_Grn_Video <= 3'b000;
            o_Blu_Video <= 3'b111;
          end
          3'b011:  // Cyan (Green + Blue)
          begin
            o_Red_Video <= 3'b000;
            o_Grn_Video <= 3'b111;
            o_Blu_Video <= 3'b111;
          end
          3'b100:  // Magenta (Red + Blue)
          begin
            o_Red_Video <= 3'b111;
            o_Grn_Video <= 3'b000;
            o_Blu_Video <= 3'b111;
          end
          3'b101:  // Yellow (Red + Green)
          begin
            o_Red_Video <= 3'b111;
            o_Grn_Video <= 3'b111;
            o_Blu_Video <= 3'b000;
          end
          3'b110:  // White
          begin
            o_Red_Video <= 3'b111;
            o_Grn_Video <= 3'b111;
            o_Blu_Video <= 3'b111;
          end
          3'b111:  // Black
          begin
            o_Red_Video <= 3'b000;
            o_Grn_Video <= 3'b000;
            o_Blu_Video <= 3'b000;
          end
        endcase
      end

      4'h5: // Pattern 5: Checkerboard (large squares)
      begin
        if ((i_Col_Count[7] ^ i_Row_Count[7]) == 1'b1)
        begin
          o_Red_Video <= 3'b111;
          o_Grn_Video <= 3'b111;
          o_Blu_Video <= 3'b111;
        end
      end

      4'h6: // Pattern 6: Horizontal gradient (Red channel varies with row)
      begin
        o_Red_Video <= {i_Row_Count[9:7]};  // Red increases top to bottom
        o_Grn_Video <= 3'b000;
        o_Blu_Video <= 3'b000;
      end

      4'h7: // Pattern 7: Vertical gradient (Green channel varies with column)
      begin
        o_Red_Video <= 3'b000;
        o_Grn_Video <= {i_Col_Count[9:7]};  // Green increases left to right
        o_Blu_Video <= 3'b000;
      end

      default: // All other patterns: Black
      begin
        o_Red_Video <= 3'b000;
        o_Grn_Video <= 3'b000;
        o_Blu_Video <= 3'b000;
      end
    endcase
  end

endmodule
