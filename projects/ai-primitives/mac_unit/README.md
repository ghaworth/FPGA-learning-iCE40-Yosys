# 8-bit Signed MAC Unit

A foundational multiply-accumulate (MAC) primitive for TinyML experiments. 
Multiplies two 8-bit signed integers and adds the result to a 16-bit signed accumulator in a single clock cycle.

## Resource Usage (iCE40 HX1K)

Synthesizing this pure-logic MAC unit on the iCE40 (which lacks hard DSP blocks) yields:

- **LUTs**: 220 (`SB_LUT4`)
- **Registers**: 17 (`SB_DFFESR` / `SB_DFFSR`)
- **Carry Cells**: 11 (`SB_CARRY`)

## Architectural Takeaway

The Nandland Go Board has 1,280 LUTs. A single 8-bit MAC consumes ~17% of the total logic fabric (220 / 1280). 

This means the absolute maximum number of parallel MAC operations we can synthesize on this board is **5**. 

To perform larger dot products or matrix multiplications, we cannot unroll the operations spatially. We must instead build a small systolic array or a single MAC engine and stream the weights/activations through it temporally (over multiple clock cycles) using Block RAM.
