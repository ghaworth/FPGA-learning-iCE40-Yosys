# Makefile for Project 9 - VGA Introduction
# Targets: sim (simulation), all (synthesis), prog (program FPGA), clean

# Project configuration
PROJECT = project_9_vga_top
TOP_MODULE = Project_9_VGA_Top
SOURCES = project_9_vga_top.v vga_sync_pulses.v vga_test_pattern.v vga_sync_porch.v
PCF = ../../constraints/Go_Board_Constraints.pcf

# FPGA device specifications for Go Board
DEVICE = hx1k
PACKAGE = vq100

# Build directories
BUILD_DIR = build
SIM_DIR = sim

# Default target
.PHONY: all
all: $(BUILD_DIR)/$(PROJECT).bin

# ============================================================================
# SIMULATION TARGETS
# ============================================================================

# Run simulation with iverilog and vvp
.PHONY: sim
sim:
	@mkdir -p $(SIM_DIR)
	@iverilog -o $(SIM_DIR)/vga_sync_pulses_tb.vvp -I. vga_sync_pulses_tb.v vga_sync_pulses.v
	@cd $(SIM_DIR) && vvp vga_sync_pulses_tb.vvp
	@echo "Simulation complete. Waveforms saved to $(SIM_DIR)/vga_sync_pulses.vcd"

# View waveforms (requires gtkwave installed)
.PHONY: wave
wave: sim
	gtkwave $(SIM_DIR)/vga_sync_pulses.vcd

# ============================================================================
# SYNTHESIS TARGETS
# ============================================================================

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

# Clean build and simulation artifacts
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(SIM_DIR)

# Show help
.PHONY: help
help:
	@echo "Project 9 - VGA Introduction"
	@echo ""
	@echo "Simulation Targets:"
	@echo "  sim          - Run simulation, generate waveforms"
	@echo "  wave         - Run simulation and view waveforms (requires gtkwave)"
	@echo ""
	@echo "Synthesis Targets:"
	@echo "  all          - Build bitstream (default)"
	@echo "  prog         - Program FPGA"
	@echo "  prog-verify  - Program FPGA with verification"
	@echo "  stats        - Show resource usage"
	@echo "  timing       - Show timing analysis"
	@echo "  check        - Quick syntax check"
	@echo ""
	@echo "Maintenance:"
	@echo "  clean        - Remove build and simulation artifacts"
	@echo "  help         - Show this help"
	@echo ""
	@echo "Workflow:"
	@echo "  1. Simulate:  make sim"
	@echo "  2. Synthesise: make all"
	@echo "  3. Program:   make prog"
