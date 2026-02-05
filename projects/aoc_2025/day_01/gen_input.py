#!/usr/bin/env python3
"""
Parse AoC 2025 Day 1 input.txt and generate Verilog constants.

Input format: One rotation per line, e.g. "R19", "L18"
Output: day_01_input.v with packed array

Packed format: [7] = direction (0=L, 1=R), [6:0] = distance mod 100
"""

import sys
from pathlib import Path


def parse_rotation(line: str) -> tuple[int, int]:
    """Parse a single rotation line, return (direction, distance mod 100)."""
    line = line.strip()
    if not line:
        return None
    
    direction = 1 if line[0] == 'R' else 0  # R=1, L=0
    distance = int(line[1:]) % 100  # Pre-compute mod 100
    return (direction, distance)


def generate_verilog(rotations: list[tuple[int, int]], output_path: Path) -> None:
    """Generate Verilog file with packed rotation constants."""
    
    with open(output_path, 'w') as f:
        f.write("// Auto-generated from input.txt by gen_input.py\n")
        f.write("// DO NOT EDIT - regenerate with: python3 gen_input.py input.txt\n")
        f.write(f"// Total rotations: {len(rotations)}\n\n")
        
        f.write(f"localparam NUM_ROTATIONS = {len(rotations)};\n\n")
        
        f.write("// Packed format: [7] = direction (0=L, 1=R), [6:0] = distance mod 100\n")
        f.write(f"reg [7:0] rotations [0:{len(rotations)-1}];\n\n")
        
        f.write("initial begin\n")
        for i, (direction, distance) in enumerate(rotations):
            packed = (direction << 7) | distance
            dir_char = 'R' if direction else 'L'
            f.write(f"    rotations[{i}] = 8'h{packed:02x};  // {dir_char}{distance}\n")
        f.write("end\n")


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} input.txt", file=sys.stderr)
        sys.exit(1)
    
    input_path = Path(sys.argv[1])
    output_path = input_path.parent / "day_01_input.v"
    
    rotations = []
    with open(input_path) as f:
        for line in f:
            result = parse_rotation(line)
            if result:
                rotations.append(result)
    
    generate_verilog(rotations, output_path)
    print(f"Generated {output_path} with {len(rotations)} rotations")


if __name__ == "__main__":
    main()
