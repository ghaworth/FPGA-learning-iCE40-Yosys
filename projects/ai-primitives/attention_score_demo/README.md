# Attention Score Demo (Temporal Streaming)

This module demonstrates the core architectural trick of Edge AI: computing complex vector math without running out of LUTs.

It calculates the dot product of a 4-dimensional Query token against two different Key tokens (`K0` and `K1`), which is the first step of the Transformer attention mechanism.

## Resource Usage vs Strategy

| Module | Math Performed | Architecture | LUTs |
|---|---|---|---|
| `mac_unit` | 1 MAC | 1 Multiplier | ~220 |
| `dot_product_4` | 4 MACs | 4 Multipliers (Unrolled) | ~864 |
| `attention_score_demo` | 8 MACs | 1 Multiplier (Streamed) | ~236 |

## The TinyML "Aha" Moment

By explicitly instantiating a single multiplier and routing data through it temporally using a state machine, we performed **twice the math** of the `dot_product_4` experiment using **a quarter of the LUTs**. 

The cost is latency (it takes 8 clock cycles instead of 1), but at 25 MHz, that's only 320 nanoseconds. 

This is how actual neural network accelerators work. To scale this up to a real LLM on a larger board like the ULX3S, the architecture remains the same:
1. Replace the LUT-based multiplier with hard DSP blocks.
2. Replace the hardcoded Key vectors with weights streamed from SDRAM.
3. Scale the state machine to handle loops of length `N` (hidden dimension) rather than length 4.
