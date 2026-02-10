#!/usr/bin/env python3
"""
Parse AoC 2025 Day 1 input.txt and generate hex file for block RAM.
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


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} input.txt", file=sys.stderr)
        sys.exit(1)
    
    input_path = Path(sys.argv[1])
    output_path = input_path.parent / "rotations.hex"
    
    rotations = []
    with open(input_path) as f:
        for line in f:
            result = parse_rotation(line)
            if result:
                rotations.append(result)

    with open(output_path, 'w') as f:
        for direction, distance in rotations:
            packed = (direction<< 7) | distance
            f.write(f"{packed:02x}\n")

    print(f"Generated {output_path} with {len(rotations)} entries")


if __name__ == "__main__":
    main()
