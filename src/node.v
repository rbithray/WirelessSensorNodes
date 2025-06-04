`include "./src/memory.v"
`include "./src/sensor.v"
`include "./src/radio.v"
//`include "packetiser.v"
`include "./src/controller.v"

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
    input  wire        enable,      // Global enable
    input  wire [1:0]  inst,        // Instruction signal for controller
    output wire        busy         // Busy signal to indicate controller is processing
);

    // Sensor wires
    wire [7:0] sensor_data;
    wire       sensor_enable;

    // Memory wires
    wire [7:0] mem_data;
    wire [7:0] mem_address;
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

    // Instantiate Sensor
    sensor sensor_inst (
        .environment(environment),
        .clk(clk),
        .enable(sensor_enable),
        .data(sensor_data)
    );

    // Instantiate Memory
    memory memory_inst (
        .addr(mem_address),
        .data(mem_data),
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
        .data(radio_data),
        .Tx(Tx),
        .Rx(Rx)
    );

    // Instantiate Controller
    controller controller_inst (
        .clk(clk),
        .enable(enable),
        .inst(inst),
        .busy(busy),
        // Sensor interface
        .sensor_data(sensor_data),
        .sensor_enable(sensor_enable),
        // Memory interface
        .mem_data(mem_data),
        .mem_address(mem_address),
        .mem_write(mem_write),
        .mem_read(mem_read),
        // Radio interface
        .radio_busy(radio_busy),
        .radio_send(radio_send),
        .radio_receive(radio_receive),
        .radio_data(radio_data),
        .radio_enable(radio_enable)
    );

endmodule