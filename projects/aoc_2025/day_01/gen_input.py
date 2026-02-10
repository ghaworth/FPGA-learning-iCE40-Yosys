#!/usr/bin/env python3
"""
Parse AoC 2025 Day 1 input.txt and generate crossing counts for Part 2.
"""

import sys
from pathlib import Path


def parse_rotation(line: str):
    """Parse a single rotation line, return (direction, distance mod 100)."""
    line = line.strip()
    if not line:
        return None    
    direction = 1 if line[0] == 'R' else 0  # R=1, L=0
    distance = int(line[1:])
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

    position = 50
    total = 0

    with open(output_path, 'w') as f:
        for direction, distance in rotations:
            if direction == 1: # RIGHT
                crossings = (position + distance) // 100
                position = (position + distance) % 100
            else: # LEFT
                if position == 0:
                    crossings = distance // 100
                elif distance >= position:
                    crossings = (distance - position) // 100 + 1
                else:   
                    crossings = 0
                position = (position - distance) % 100
            total += crossings
            f.write(f"{crossings:02x}\n")
            

    print(f"Generated {output_path} with {len(rotations)} entries")
    print(f"Expected total: {total}")

if __name__ == "__main__":
    main()
