@echo off
setlocal enabledelayedexpansion

:: Check if iverilog is installed
where iverilog >nul 2>&1
if errorlevel 1 (
    echo iverilog is NOT installed
    exit /b 1
) else (
    echo iverilog is installed
)

:: Check if surfer or gtkwave is installed
where surfer >nul 2>&1
if errorlevel 1 (
    echo surfer is NOT installed
    where gtkwave >nul 2>&1
    if errorlevel 1 (
        echo Neither surfer nor gtkwave is installed
        echo Please install one of them to view VCD files
        exit /b 1
    ) else (
        echo Using gtkwave as the VCD viewer
        set "VCD_VIEWER=gtkwave"
    )
) else (
    echo surfer is installed
    set "VCD_VIEWER=surfer"
)

:: Present module list
set MODULES=radio controller sensor memory packetiser toplevel
set /a index=1

echo Select a module:
for %%m in (%MODULES%) do (
    echo (!index!) %%m
    set "choice_!index!=%%m"
    set /a index+=1
)

:ask_choice
set /p USER_CHOICE=Enter the number of the module: 
set "MODULE=!choice_%USER_CHOICE%!"

if not defined MODULE (
    echo Invalid option. Try again.
    goto ask_choice
)

echo You selected: %MODULE%

:: Set paths
set "SRC_DIR=.\src"
set "TB_FILE=.\tb\%MODULE%_tb.v"
set "TOP_MODULE=%MODULE%_tb"
set "OUT_DIR=.\.build"
set "OUT_FILE=%OUT_DIR%\%MODULE%_tb.out"
set "VCD_DIR=.\waveforms"

:: Create build directory if it doesn't exist
if not exist "%OUT_DIR%" (
    mkdir "%OUT_DIR%"
)

:: Compile with iverilog
iverilog -o "%OUT_FILE%" -s "%TOP_MODULE%" "%SRC_DIR%\%MODULE%.v" "%TB_FILE%"
if errorlevel 1 (
    echo Synthesis failed.
    exit /b 1
)

:: Run simulation
vvp "%OUT_FILE%"
if errorlevel 1 (
    echo Simulation failed.
    exit /b 1
)
echo Simulation completed successfully. Output written to %OUT_FILE%.

:: Open VCD in viewer
"%VCD_VIEWER%" "%VCD_DIR%\%MODULE%.vcd"
if errorlevel 1 (
    echo Waveform viewer failed.
    exit /b 1
)
echo Waveform viewer opened successfully.
