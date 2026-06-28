# 4-Element Dot Product

This experiment computes a spatial 4-element dot product in a single clock cycle:
`result = (A0 * B0) + (A1 * B1) + (A2 * B2) + (A3 * B3)`

## Resource Usage (iCE40 HX1K)

Synthesizing this pure-logic dot product yields:

- **LUTs**: 864 (`SB_LUT4`)
- **Registers**: 17 (`SB_DFFE` / `SB_DFF`)
- **Carry Cells**: 12 (`SB_CARRY`)

## The Edge AI Bottleneck

The Nandland Go Board has 1,280 LUTs. This module consumes **67.5%** of the entire FPGA fabric just to perform four simultaneous 8-bit multiplications and additions.

This perfectly illustrates the core architectural constraint of Edge AI on small FPGAs: **you cannot compute spatially (unrolled).** 

If a tiny neural network layer requires a 64-element dot product, unrolling it would require ~14,000 LUTs. Therefore, TinyML accelerators on devices like the iCE40 must compute **temporally**. They instantiate a single MAC unit (like the one in `../mac_unit`, costing ~220 LUTs) and stream the weights and activations from Block RAM over 64 clock cycles.
