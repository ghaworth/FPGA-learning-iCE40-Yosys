# Day 07: Beam Splitting Simulation
# Synthesis targets to be added when top module is written

# Paths
TOP = Day_07_Top
CONSTRAINTS = ../../../constraints/Go_Board_Constraints.pcf
LIB_IO = ../../../lib/io
LIB_CONV = ../../../lib/converters

# Source files
SRCS = day_07_top.v \
       day_07_core.v \
       $(LIB_IO)/bin_to_bcd.v \
       $(LIB_IO)/scroll_display.v \
       $(LIB_IO)/Debounce_Switch.v \
       $(LIB_CONV)/Binary_To_7Segment.v

# Build targets
all: $(TOP).bin

$(TOP).json: $(SRCS)
	yosys -p "synth_ice40 -top $(TOP) -json $@" $(SRCS)

$(TOP).asc: $(TOP).json $(CONSTRAINTS)
	nextpnr-ice40 --hx1k --package vq100 --json $< --pcf $(CONSTRAINTS) --asc $@

$(TOP).bin: $(TOP).asc
	icepack $< $@

prog: $(TOP).bin
	iceprog $<

sim:
	iverilog -o day_07_tb.vvp day_07_core.v day_07_core_tb.v
	vvp day_07_tb.vvp

clean:
	rm -f *.vvp *.json *.asc *.bin

.PHONY: all prog sim clean
