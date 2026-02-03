# FPGA Learning: iCE40 + Yosys

A structured approach to learning FPGA design with Verilog, targeting the Lattice iCE40 HX1K (Nandland Go Board).

## Structure

```
FPGA-learning-iCE40-Yosys/
├── lib/                          # Reusable component library
│   ├── io/                        # I/O interfaces
│   │   ├── debounce_switch.v
│   │   └── debounce_switch_tb.v   (testbench, future)
│   ├── converters/                # Data conversion modules
│   │   ├── binary_to_7segment.v
│   │   └── binary_to_7segment_tb.v (testbench, future)
│   └── README.md                  # Library documentation
├── projects/                      # Individual project implementations
│   ├── project_5_seven_segment/
│   │   ├── project_5_top.v
│   │   ├── Makefile
│   │   └── build/                 (generated, in .gitignore)
│   └── ...
├── constraints/                   # FPGA constraint files
│   └── Go_Board_Constraints.pcf
├── .gitignore
├── README.md                      # This file

```

## Design Principles

- **Centaur mode**: Decision bottleneck retained throughout learning. Deep understanding over pattern-matching.
- **Reusable library**: Components tested once, used everywhere. Bug fixes propagate.
- **Verilog → SystemVerilog progression**: Learning path toward professional-grade testbenches and verification.
- **One place to fix things**: Library modules live in `lib/`, not copied into projects.

## Building a Project

Each project has its own `Makefile`. Example:

```bash
cd projects/project_5_seven_segment
make              # Build bitstream
make prog         # Program FPGA
make clean        # Remove build artifacts
make help         # Show all targets
```

## Component Library

### `lib/io/debounce_switch.v`
Debounces mechanical switch input. 10ms debounce window at 25 MHz.
- **Inputs**: `i_Clk`, `i_Switch`
- **Outputs**: `o_Switch`
- **Parameters**: `c_DEBOUNCE_LIMIT` (default 250000 cycles)

### `lib/converters/binary_to_7segment.v`
Converts 4-bit binary (0-15) to 7-segment display encoding.
- **Inputs**: `i_Clk`, `i_Binary_Num[3:0]`
- **Outputs**: `o_Segment_A` through `o_Segment_G`
- **Note**: Output is active-high; Go Board segments are active-low (invert in top module).

## Toolchain

- **Synthesis**: Yosys
- **Place & Route**: nextpnr-ice40
- **Pack**: icepack
- **Program**: iceprog

Assumes tools are installed and available in `$PATH`.

## Next Steps

1. Project 5: Seven Segment Display (sequential logic, module instantiation)
2. Project 6: Simulation and Testbenches (SystemVerilog introduction)
3. ST7789 SPI Master (communication protocols, real hardware interaction)
4. Advent of Code 2024 (systematic problem-solving with hardware constraints)
