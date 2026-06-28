sim:
	iverilog -o attention_score_demo_tb.vvp attention_score_demo.v attention_score_demo_tb.v
	vvp attention_score_demo_tb.vvp

synth_check:
	yosys -p "synth_ice40 -top attention_score_demo" attention_score_demo.v

prog:
	yosys -p "synth_ice40 -top top -json hardware.json" top.v attention_score_demo.v ../../../lib/io/Debounce_Switch.v
	nextpnr-ice40 --hx1k --package vq100 --json hardware.json --pcf ../../../constraints/Go_Board_Constraints.pcf --asc hardware.asc
	icepack hardware.asc hardware.bin
	iceprog hardware.bin

clean:
	rm -f *.vvp *.vcd *.json *.asc *.bin
