module controller(
    input wire clock,                      // Clock signal
    input wire enable,                     // Enable signal
    input wire [7:0] sensor_data,          // Sensor data input
    input wire [7:0] memory_data,          // Memory data input
    input wire [7:0] radio_data,           // Radio data input
    output reg write_to_memory,            // Write enable signal
    output reg [7:0] memory_data_out,      // Memory data output
    output reg [7:0] memory_address,       // Memory address output
    output reg radio_Tx,                   // Radio transmit signal
    output reg [2:0] enables,              // Enables for sensor, radio, memory
    input wire [7:0] PMU_data              // PMU data input
);
// Controller logic will be added here later
endmodule