
// Module: controller

/*
    * Controller module to manage interactions between sensors, memory, and radio.
    * It processes instructions to read sensor data, write to memory, and communicate with a radio module.
    * The controller operates in a finite state machine (FSM) manner.
    * It handles various states such as IDLE, READ_SENSOR, READ_RADIO, WRITE_RADIO, WRITE_MEMORY, and READ_MEMORY.
    * The controller could be replaced with a more complex RISC-V processor in the future.
*/

module controller(
    input  wire        clk,                 // Clock signal
    input  wire        enable,              // Enable signal
    input  wire [2:0]  inst,                // Instruction signal
    output reg         busy,                // Busy signal to indicate controller is processing
    // Sensor signals
    input  wire [7:0]  sensor_data,         // Sensor data input
    output reg         sensor_enable,       // Sensor enable signal
    // Memory signals
    inout  wire [7:0]  mem_data,            // Memory data input
    output reg [7:0]   mem_address,         // Memory address output
    output reg         mem_write,           // Write enable signal
    output reg         mem_read,            // Read enable signal
    input  wire        mem_data_ready,      // Memory data ready signal
    // Radio signals
    input  wire        radio_busy,          // Radio busy signal
    output reg         radio_send,          // Control signal to radio for transmit
    output reg         radio_receive,       // Control signal to radio for receive 
    inout  wire [7:0]  radio_data,          // Data received from 
    output reg         radio_enable         // Radio enable signal

);

    // State encoding
    parameter   IDLE = 3'b000, 
                READ_SENSOR = 3'b001,
                READ_RADIO = 3'b010,
                WRITE_RADIO = 3'b011,
                WRITE_MEMORY = 3'b100,
                READ_MEMORY = 3'b101;

    //reg [1:0] current_state, next_state = IDLE;
    reg [7:0] current_address = 0; // Current address for memory operations
    reg [7:0] data = 8'b0; // "Memory" data register to hold sensor data, memory data or radio data
    reg [2:0] current_state = IDLE, next_state = IDLE; // Current and next state of the FSM
    assign radio_data = (radio_send && !radio_receive) ? data : 8'bz; // Tri-state output for radio data
    assign mem_data = (mem_write && !mem_read) ? data : 8'bz; // Tri-state output for memory data
     
always @(posedge clk) begin
    if(!enable) begin
        // If not enabled, stay in IDLE state, reset all outputs
        sensor_enable <= 1'b0;
        mem_write <= 1'b0;
        mem_read <= 1'b0;
        radio_send <= 1'b0;
        radio_receive <= 1'b0;
        radio_enable <= 1'b0;
        data <= 8'b0;
        mem_address <= 8'b0;
        current_state <= IDLE; // Reset state
    end else begin
        current_state <= next_state; // Transition to next state
        
        case (current_state)
            IDLE: begin
                // In IDLE state, wait for instruction
                sensor_enable <= 1'b0;
                mem_write <= 1'b0;
                mem_read <= 1'b0;
                radio_send <= 1'b0;
                radio_receive <= 1'b0;
                radio_enable <= 1'b0;
                busy <= 1'b0; // Indicate controller is not busy
                next_state <= inst; // set next state based on instruction
            end
            
            READ_SENSOR: begin
                busy <= 1'b1; // Indicate controller is busy
                // Read sensor data
                sensor_enable <= 1'b1; // Enable sensor
                if (sensor_data !== 8'b0) begin
                    data <= sensor_data; // Read data from sensor
                    next_state <= WRITE_MEMORY; // Transition to WRITE_MEMORY state 
                end else begin
                    next_state <= READ_SENSOR; // Stay in READ_SENSOR if no data available 
                end
            end
            
            READ_RADIO: begin
                // Read from radio
                busy <= 1'b1; // Indicate controller is busy
                radio_receive <= 1'b1; // Enable radio receive
                radio_enable <= 1'b1; // Enable radio module
                // Wait for radio to be ready
                if (!radio_busy) begin
                    data <= radio_data; // Read data from radio
                    radio_receive <= 1'b0; // Disable radio receive after reading
                    radio_enable <= 1'b0; // Disable radio module
                    next_state <= WRITE_MEMORY; // Transition to WRITE_MEMORY state
                end 

            end
            
            WRITE_RADIO: begin
                // Write to radio
                if (!radio_busy) begin
                    radio_receive <= 1'b0; // Disable radio receive
                    radio_send <= 1'b1; // Enable radio send
                    radio_enable <= 1'b1; // Enable radio module
                // Wait for radio to be ready
                end else begin
                    radio_send <= 1'b0; // Radio is busy, do not send data
                    radio_enable <= 1'b0; // Disable radio module
                    next_state <= IDLE; // Transition to IDLE state after sending
                end
            end

            READ_MEMORY: begin
                // Read from memory
                busy <= 1'b1; // Indicate controller is busy
                current_address <= current_address - 1; // Decrement address for read
                mem_address <= current_address; // Set memory address for read
                mem_read <= 1'b1; // Enable memory read
                
                if (mem_data_ready) begin
                    // If data is available, read it
                    mem_read <= 1'b0; // Disable memory read after reading
                    next_state <= IDLE; // Transition to IDLE state
                end else begin
                    mem_read <= 1'b0; // Disable memory read if no data available
                end
            end

            WRITE_MEMORY: begin
                // Write to memory
                busy <= 1'b1; // Indicate controller is busy
                mem_address <= current_address; // Set memory address for write
                mem_write <= 1'b1; // Enable memory write
                current_address <= current_address + 1; // Increment address for next write
                next_state <= IDLE; // Transition to IDLE state
            end

            default: begin
                // Default case to handle unexpected states
                next_state <= IDLE;
            end
        endcase
    end
end
endmodule