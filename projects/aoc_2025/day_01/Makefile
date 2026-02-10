# Paths
TOP = Day_01_Top
CONSTRAINTS = ../../../constraints/Go_Board_Constraints.pcf
LIB_IO = ../../../lib/io
LIB_CONV = ../../../lib/converters

# Source files
SRCS = day_01_top.v \
       day_01_core.v \
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

clean:
	rm -f *.json *.asc *.bin

.PHONY: all prog clean
