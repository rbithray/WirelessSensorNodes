module controller(
    input  wire        clk,                 // Clock signal
    input  wire        enable,              // Enable signal
    // Sensor signals
    input  wire [7:0]  sensor_data,         // Sensor data input
    input  wire        sensor_enable,       // Sensor enable signal
    // Memory signals
    inout  wire [7:0]  memory_data,         // Memory data input
    output reg [7:0]   memory_address,      // Memory address output
    output reg         write_to_memory,     // Write enable signal
    // Radio signals
    input  wire        radio_busy,          // Radio busy signal
    output reg         redio_send,          // Control signal to radio for transmit
    output reg         radio_receive,       // Control signal to radio for receive 
    inout  wire [7:0]  radio_data,       // Data received from 
    output reg        radio_enable         // Radio enable signal

);
// Controller logic will be added here later
endmodule