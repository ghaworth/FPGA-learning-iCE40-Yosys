# Makefile for Nandland Go Board Project 5 - Seven Segment Display
# Requires: yosys, nextpnr-ice40, icepack, iceprog

# Project configuration
PROJECT = project_5_top
TOP_MODULE = Project_7_Segment_Top
SOURCES = project_5_top.v ../../lib/io/debounce_switch.v ../../lib/converters/binary_to_7segment.v
PCF = ../../constraints/Go_Board_Constraints.pcf

# FPGA device specifications for Go Board
DEVICE = hx1k
PACKAGE = vq100

# Build directory
BUILD_DIR = build

# Default target
.PHONY: all
all: $(BUILD_DIR)/$(PROJECT).bin

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Synthesis: Verilog -> JSON netlist
$(BUILD_DIR)/$(PROJECT).json: $(SOURCES) | $(BUILD_DIR)
	yosys -p "read_verilog $(SOURCES); synth_ice40 -top $(TOP_MODULE) -json $@"

# Place and Route: JSON netlist -> ASCII bitstream
$(BUILD_DIR)/$(PROJECT).asc: $(BUILD_DIR)/$(PROJECT).json $(PCF)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --pcf $(PCF) \
		--json $< --asc $@

# Pack: ASCII bitstream -> Binary bitstream
$(BUILD_DIR)/$(PROJECT).bin: $(BUILD_DIR)/$(PROJECT).asc
	icepack $< $@

# Program FPGA via USB
.PHONY: prog
prog: $(BUILD_DIR)/$(PROJECT).bin
	iceprog $<

# Program FPGA with verification
.PHONY: prog-verify
prog-verify: $(BUILD_DIR)/$(PROJECT).bin
	iceprog -v $<

# Show resource utilization
.PHONY: stats
stats: $(BUILD_DIR)/$(PROJECT).json
	@echo "=== Resource Utilization ==="
	@yosys -p "read_json $<; stat"

# Timing analysis
.PHONY: timing
timing: $(BUILD_DIR)/$(PROJECT).asc
	@echo "=== Timing Analysis ==="
	icetime -d $(DEVICE) $<

# Syntax check only (fast)
.PHONY: check
check:
	yosys -p "read_verilog $(SOURCES); hierarchy -check"

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

# Show help
.PHONY: help
help:
	@echo "Nandland Go Board Project 5 - Seven Segment Display"
	@echo ""
	@echo "Targets:"
	@echo "  all          - Build bitstream (default)"
	@echo "  prog         - Program FPGA"
	@echo "  prog-verify  - Program FPGA with verification"
	@echo "  stats        - Show resource usage"
	@echo "  timing       - Show timing analysis"
	@echo "  check        - Quick syntax check"
	@echo "  clean        - Remove build files"
	@echo "  help         - Show this help"
	@echo ""
	@echo "Quick workflow:"
	@echo "  make && make prog"
