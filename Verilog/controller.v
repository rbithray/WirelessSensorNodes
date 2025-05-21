module controller(
    input  wire        clk,                 // Clock signal
    input  wire        enable,              // Enable signal
    // Sensor signals
    input  wire [7:0]  sensor_data,         // Sensor data input
    input  wire        sensor_enable,       // Sensor enable signal
    // Memory signals
    input  wire [7:0]  memory_data,         // Memory data input
    output reg [7:0]   memory_data_out,     // Memory data output
    output reg [7:0]   memory_address,      // Memory address output
    output reg         write_to_memory,     // Write enable signal
    // Radio signals
    input  wire        radio_busy,          // Radio busy signal
    output reg         redio_send,          // Control signal to radio for transmit
    output reg         radio_receive,       // Control signal to radio for receive 
    input  wire [7:0]  radio_rx_data,       // Data received from radio
    output reg [7:0]   radio_tx_data,       // Data to radio for transmit
    output reg        radio_enable,         // Radio enable signal

);
// Controller logic will be added here later
endmodule