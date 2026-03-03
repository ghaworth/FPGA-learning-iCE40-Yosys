# Day 07: Beam Splitting Simulation
# Synthesis targets to be added when top module is written

sim:
	iverilog -o day_07_tb.vvp day_07_core.v day_07_core_tb.v
	vvp day_07_tb.vvp

clean:
	rm -f *.vvp

.PHONY: sim clean
