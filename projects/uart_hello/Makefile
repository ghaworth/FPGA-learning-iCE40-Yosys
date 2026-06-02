PROJ    = uart_hello
BUILD   = build

TOP     = uart_hello_top
DEVICE  = hx1k
PACKAGE = vq100
PCF     = ../../constraints/Go_Board_Constraints.pcf
SOURCES = uart_tx.v uart_hello_top.v

all: $(BUILD)/$(PROJ).bin

$(BUILD)/$(PROJ).json: $(SOURCES) | $(BUILD)
	yosys -p "synth_ice40 -top $(TOP) -json $@" $(SOURCES)

$(BUILD)/$(PROJ).asc: $(BUILD)/$(PROJ).json $(PCF)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --json $< --pcf $(PCF) --asc $@

$(BUILD)/$(PROJ).bin: $(BUILD)/$(PROJ).asc
	icepack $< $@

$(BUILD):
	mkdir -p $(BUILD)

prog: $(BUILD)/$(PROJ).bin
	iceprog $<

clean:
	rm -rf $(BUILD)

.PHONY: all prog clean
