#!/bin/bash

# check dependencies
if command -v iverilog >/dev/null 2>&1; then
    echo "iverilog is installed"
else
    echo "iverilog is NOT installed"
    exit 1
fi

if command -v surfer >/dev/null 2>&1; then
    echo "surfer is installed"
    VCD_VIEWER="surfer"
elif command -v gtkwave >/dev/null 2>&1; then
    echo "surfer is NOT installed"
    echo "Using gtkwave as the VCD viewer"
    VCD_VIEWER="gtkwave"
else
    echo "Neither surfer nor gtkwave is installed"
    echo "Please install one of them to view VCD files"
    exit 1
fi

# Set variables
# read -p "Enter module name: " MODULE
modules=("radio" "controller" "sensor" "memory" "packetiser" "node")

echo "Select a module:"
select opt in "${modules[@]}"; do
    if [[ -n "$opt" ]]; then
        MODULE="$opt"
        echo "You selected: $MODULE"
        break
    else
        echo "Invalid option. Try again."
    fi
done

SRC_DIR="./src"
TB_FILE="./tb/"$MODULE"_tb.v"
TOP_MODULE=$MODULE"_tb"
OUT_DIR="./.build"
OUT_FILE="$OUT_DIR/"$MODULE"_tb.out"
VCD_DIR="./waveforms"

# Create build directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Synthesize and run using Icarus Verilog (iverilog + vvp)
iverilog -o "$OUT_FILE" -s "$TOP_MODULE" "$SRC_DIR"/"$MODULE".v "$TB_FILE"
if [ $? -ne 0 ]; then
    echo "Synthesis failed."
    exit 1
fi
echo "Synthesis completed successfully. Output file: $OUT_FILE"

# Run the simulation
vvp "$OUT_FILE"

if [ $? -ne 0 ]; then
    echo "Simulation failed."
    exit 1
fi
echo "Simulation completed successfully. Output written to $OUT_FILE."

rm -rf "$OUT_DIR" # Clean up the build directory
mkdir -p "$VCD_DIR" # Create waveform directory if it doesn't exist

$VCD_VIEWER "$VCD_DIR"/"$MODULE"_tb.vcd
if [ $? -ne 0 ]; then
    echo "Waveform viewer failed."
    exit 1
fi
echo "Waveform viewer opened successfully."