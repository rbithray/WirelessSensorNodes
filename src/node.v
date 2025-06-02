`include "memory.v"
`include "sensor.v"
`include "radio.v"
`include "packetiser.v"

// Module: Top-level module for the node

/*
    * This module serves as the top-level integration point for the system.
    * It connects the sensor, memory, radio, and controller modules.
    * The system operates based on a clock signal and a reset signal.
    * It also includes an external environment input for the sensor.
*/

module toplevel(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  environment, // External environment input for sensor
    input  wire        enable      // Global enable
    input  wire [2:0]  inst,        // Instruction signal for controller
    output wire        busy,        // Busy signal to indicate controller is processing
);

    // Sensor wires
    wire [7:0] sensor_data;
    wire       sensor_enable;

    // Memory wires
    wire [7:0] mem_data_in;
    wire [7:0] mem_data_out;
    wire [3:0] mem_address;
    wire       mem_write;
    wire       mem_read;

    // Radio wires
    wire        radio_busy;
    wire        radio_send;
    wire        radio_receive;
    wire [7:0]  radio_data;
    wire        radio_enable;
    wire        Tx;
    wire        Rx;
    wire [7:0]  radio_rx_data;

    // Packetizer wires
    wire [7:0] packet_data;
    wire       packet_valid;
    wire       packet_ready;

    // Instantiate Sensor
    sensor sensor_inst (
        .environment(environment),
        .clk(clk),
        .enable(sensor_enable),
        .data(sensor_data)
    );

    // Instantiate Memory
    memory memory_inst (
        .addr(mem_address[3:0]),
        .data_in(mem_data_in),
        .data_out(mem_data_out),
        .write(mem_write),
        .read(mem_read),
        .rst_n(rst_n),
        .clk(clk)
    );

    // Instantiate Radio
    radio radio_inst (
        .clk(clk),
        .enable(radio_enable),
        .send(radio_send),
        .busy(radio_busy),
        .receive(radio_receive),
        .tx_data(radio_data),
        .rx_data(radio_rx_data),
        .Tx(Tx),
        .Rx(Rx)
    );

    // Instantiate Controller
    controller controller_inst (
        .clk(clk),
        .enable(enable),
        // Sensor interface
        .sensor_data(sensor_data),
        .sensor_enable(sensor_enable),
        // Memory interface
        .mem_data_in(mem_data_out),
        .mem_data_out(mem_data_in),
        .mem_address(mem_address),
        .mem_write(mem_write),
        .mem_read(mem_read),
        // Radio interface
        .radio_busy(radio_busy),
        .radio_send(radio_send), // Note: typo in controller.v, should be radio_send
        .radio_receive(radio_receive),
        .radio_data(radio_data),
        .radio_enable(radio_enable)
    );

    // Instantiate Packetizer
    ipv6_packetiser packetiser_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(mem_data_out),
        .data_valid(mem_read), // or a dedicated signal
        .packet_out(packet_data),
        .packet_valid(packet_valid),
        .packet_ready(packet_ready)
    );

    // Connect packet_data to radio_data, and use packet_valid to trigger radio_send, etc.
    assign radio_data = packet_data;
    assign radio_send = packet_valid;

endmodule