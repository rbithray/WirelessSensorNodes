#!/bin/bash

# Set variables
SRC_DIR="../src"
TB_FILE="../tb/radio_tb.v"
TOP_MODULE="radio_tb"
OUT_DIR="./.build"
OUT_FILE="$OUT_DIR/radio_tb.out"
VCD_DIR="../waveforms"

# Create build directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Synthesize and run using Icarus Verilog (iverilog + vvp)
iverilog -o "$OUT_FILE" -s "$TOP_MODULE" "$SRC_DIR"/radio.v "$TB_FILE"
if [ $? -ne 0 ]; then
    echo "Synthesis failed."
    exit 1
fi

vvp "$OUT_FILE"

if [ $? -ne 0 ]; then
    echo "Simulation failed."
    exit 1
fi
echo "Simulation completed successfully. Output written to $OUT_FILE."

rm -f "$OUT_FILE"  # Clean up the output file after simulation

surfer "$VCD_DIR"/radio_tb.vcd
if [ $? -ne 0 ]; then
    echo "Waveform viewer failed."
    exit 1
fi
echo "Waveform viewer opened successfully."