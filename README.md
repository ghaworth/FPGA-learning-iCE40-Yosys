# FPGA Learning: iCE40 + Yosys

A structured approach to learning FPGA design with Verilog, targeting the Lattice iCE40 HX1K (Nandland Go Board).

## Structure

```
FPGA-learning-iCE40-Yosys/
├── lib/                           # Reusable component library
│   ├── io/                        # I/O interfaces
│   │   ├── Debounce_Switch.v      # Switch debouncing
│   │   ├── bin_to_bcd.v           # Binary to BCD (double-dabble)
│   │   ├── bin_to_bcd_tb.v        # Testbench
│   │   ├── scroll_display.v       # Scrolling 7-segment display
│   │   └── scroll_display_tb.v    # Testbench
│   └── converters/                # Data conversion modules
│       └── Binary_To_7Segment.v   # BCD to 7-segment encoding
├── projects/                      # Individual project implementations
│   ├── project_5_seven_segment/
│   ├── project_6_led_blink/
│   ├── project_9_vga/
│   └── aoc_2025/                  # Advent of Code 2025
│       └── day_01/
│           ├── day_01_core.v      # Algorithm implementation
│           ├── day_01_top.v       # Top-level module
│           ├── day_01_core_tb.v   # Testbench
│           ├── gen_input.py       # Input parser → hex file
│           ├── rotations.hex      # Block RAM data
│           ├── input.txt          # AoC puzzle input
│           └── Makefile
├── constraints/                   # FPGA constraint files
│   └── Go_Board_Constraints.pcf
├── .github/workflows/             # CI/CD
│   └── simulation.yml
├── .gitignore
└── README.md
```

## Design Principles

- **Centaur mode**: Decision bottleneck retained throughout learning. Deep understanding over pattern-matching.
- **Reusable library**: Components tested once, used everywhere. Bug fixes propagate.
- **First-principles approach**: Derive solutions through reasoning, not copy-paste.
- **One place to fix things**: Library modules live in `lib/`, not copied into projects.

## Building a Project

Each project has its own `Makefile`. Example:

```bash
cd projects/aoc_2025/day_01
make              # Build bitstream
make prog         # Program FPGA
make clean        # Remove build artifacts
```

## Component Library

### `lib/io/Debounce_Switch.v`

Debounces mechanical switch input. 10ms debounce window at 25 MHz.

- **Inputs**: `i_Clk`, `i_Switch`
- **Outputs**: `o_Switch`
- **Parameters**: `c_DEBOUNCE_LIMIT` (default 250000 cycles)

### `lib/io/bin_to_bcd.v`

Converts binary to BCD using double-dabble algorithm. 50 clock cycles for conversion.

- **Inputs**: `clk`, `start`, `bin_num[49:0]`
- **Outputs**: `bcd_num[63:0]`, `done`
- **Supports**: Up to 16 decimal digits

### `lib/io/scroll_display.v`

Scrolls a multi-digit number across two 7-segment displays.

- **Inputs**: `clk`, `start`, `bcd_num[63:0]`, `num_digits[4:0]`
- **Outputs**: `left_digit[4:0]`, `right_digit[4:0]`
- **Parameters**: `COUNTER_BITS` (default 25, ~0.5s per step at 25MHz)

### `lib/converters/Binary_To_7Segment.v`

Converts 5-bit input (0-15, plus blank=16, dot=17) to 7-segment display encoding.

- **Inputs**: `i_Clk`, `i_Binary_Num[4:0]`
- **Outputs**: `o_Segment_A` through `o_Segment_G`
- **Note**: Output active-high; Go Board segments are active-low (invert in top module)

## Advent of Code 2025

Hardware implementations of AoC 2025 puzzles on the Nandland Go Board.

### Day 1: Secret Entrance

Simulates a safe dial rotating through positions 0-99.

- **Part 1**: Count rotations landing on 0. Answer: 1158
- **Part 2**: Count all zero-crossings during rotations. Answer: 6860

**Techniques used**:
- Block RAM for storing 4660 rotation commands
- State machine with synchronous RAM read (1-cycle latency)
- Module pipeline: Core → BCD converter → Scroll display → 7-segment decoders
- Edge detection for button triggering

## Toolchain

- **Synthesis**: Yosys
- **Place & Route**: nextpnr-ice40
- **Pack**: icepack
- **Program**: iceprog
- **Simulation**: Icarus Verilog

Assumes tools are installed and available in `$PATH`.

## CI/CD

GitHub Actions runs simulation tests on push:
- Project 6 LED blink simulation
- Day 1 core algorithm verification (expects result = 1158)
