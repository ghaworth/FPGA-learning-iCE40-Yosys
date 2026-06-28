sim:
	iverilog -o attention_score_demo_tb.vvp attention_score_demo.v attention_score_demo_tb.v
	vvp attention_score_demo_tb.vvp

synth_check:
	yosys -p "synth_ice40 -top attention_score_demo" attention_score_demo.v

clean:
	rm -f *.vvp *.vcd
