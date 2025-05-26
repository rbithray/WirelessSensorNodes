module controller(
    input  wire        clk,                 // Clock signal
    input  wire        enable,              // Enable signal
    // Sensor signals
    input  wire [7:0]  sensor_data,         // Sensor data input
    input  wire        sensor_enable,       // Sensor enable signal
    // Memory signals
    input  wire [7:0]  mem_data_in,         // Memory data input
    output reg [7:0]   mem_data_out,        // Memory data output
    output reg [7:0]   mem_address,      // Memory address output
    output reg         mem_write,     // Write enable signal
    output reg         mem_read,      // Read enable signal
    // Radio signals
    input  wire        radio_busy,          // Radio busy signal
    output reg         radio_send,          // Control signal to radio for transmit
    output reg         radio_receive,       // Control signal to radio for receive 
    inout  wire [7:0]  radio_data,       // Data received from 
    output reg        radio_enable         // Radio enable signal

);

    // State encoding
    parameter IDLE = 2'b00, 
              READ_SENSOR = 2'b01,
              WRITE_MEMORY = 2'b10,
              RADIO_COMM = 2'b11;
    reg [1:0] current_state, next_state;
     
always_ff @(posedge clk) begin
    if(!enable) begin
        // If not enabled, stay in IDLE state, reset all outputs
        sensor_enable <= 1'b0;
        mem_write <= 1'b0;
        mem_read <= 1'b0;
        radio_send <= 1'b0;
        radio_receive <= 1'b0;
        radio_enable <= 1'b0;
        mem_data_out <= 8'b0;
        mem_address <= 8'b0;
        radio_data <= 8'b0;
        current_state <= IDLE; // Reset state
    end else begin
        current_state <= next_state; // Transition to next state
    end
end
endmodule