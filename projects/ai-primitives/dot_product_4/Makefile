sim:
	iverilog -o dot_product_4_tb.vvp dot_product_4.v dot_product_4_tb.v
	vvp dot_product_4_tb.vvp

synth_check:
	yosys -p "synth_ice40 -top dot_product_4" dot_product_4.v

clean:
	rm -f *.vvp *.vcd
