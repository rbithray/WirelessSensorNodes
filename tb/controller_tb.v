`timescale 1ns/1ps

module controller_tb;

    reg tb_clk = 0;
    reg tb_enable = 0;
    reg [2:0] tb_inst = 3'b000;
    wire [2:0] tb_current_state, tb_next_state;


    // Sensor signals
    reg [7:0] tb_sensor_data = 8'h00;
    wire tb_sensor_enable;

    // Memory signals
    wire [7:0] tb_mem_data;
    reg [7:0] tb_mem_data_driver = 8'bz;
    wire [7:0] tb_mem_address;
    wire tb_mem_write;
    wire tb_mem_read;

    // Radio signals
    reg tb_radio_busy = 0;
    wire tb_radio_send;
    wire tb_radio_receive;
    wire [7:0] tb_radio_data;
    reg [7:0] tb_radio_data_driver = 8'bz;
    wire tb_radio_enable;

    wire tb_busy;

    // Attach drivers to inout buses
    assign tb_mem_data  = tb_mem_read  ? tb_mem_data_driver  : 8'bz;
    assign tb_radio_data = tb_radio_receive ? tb_radio_data_driver : 8'bz;

    // Instantiate the controller
    controller uut (
        .clk(tb_clk),
        .enable(tb_enable),
        .inst(tb_inst),
        .busy(tb_busy),
        .current_state(tb_current_state),
        .next_state(tb_next_state),
        .sensor_data(tb_sensor_data),
        .sensor_enable(tb_sensor_enable),
        .mem_data(tb_mem_data),
        .mem_address(tb_mem_address),
        .mem_write(tb_mem_write),
        .mem_read(tb_mem_read),
        .radio_busy(tb_radio_busy),
        .radio_send(tb_radio_send),
        .radio_receive(tb_radio_receive),
        .radio_data(tb_radio_data),
        .radio_enable(tb_radio_enable)
    );

    // Clock generation
    always #5 tb_clk = ~tb_clk;

    initial begin
        $dumpfile("./waveforms/controller_tb.vcd");
        $dumpvars(0, controller_tb);
        $monitor("inst: %b | busy: %b | sensor_data: %h | mem_data: %h | mem_address: %h | mem_write: %b | mem_read: %b | radio_busy: %b | radio_send: %b | radio_receive: %b | radio_data: %h",
                 $time, tb_clk, tb_enable, tb_inst, tb_busy, tb_sensor_data, tb_mem_data, tb_mem_address, tb_mem_write, tb_mem_read, tb_radio_busy, tb_radio_send, tb_radio_receive, tb_radio_data);

        // Reset
        tb_enable = 0;
        tb_inst = 3'b000;
        tb_sensor_data = 8'h00;
        tb_mem_data_driver = 8'b0;
        tb_radio_data_driver = 8'b0;
        tb_radio_busy = 0;
        #20;

        // Enable controller
        tb_enable = 1;

        // Test READ_SENSOR (simulate sensor data)
        tb_inst = 3'b001; // READ_SENSOR
        tb_sensor_data = 8'hA5;
        wait (tb_busy == 1);
        wait (tb_busy == 0);
#5;
        // Test READ_MEMORY (simulate memory data)
        tb_mem_data_driver = 8'h7E; // Provide data for controller to read
        tb_inst = 3'b101; // READ_MEMORY
        wait (tb_busy == 1);
        wait (tb_busy == 0);
        tb_mem_data_driver = 8'bz; // Release bus
#5;
        // Test WRITE_RADIO (controller writes to radio)
        tb_inst = 3'b011; // WRITE_RADIO
        tb_radio_busy = 0;
        wait (tb_busy == 1);
        wait (tb_busy == 0);
#5;
        // Test READ_RADIO (simulate radio data)
        tb_radio_data_driver = 8'h5F; // Provide data for controller to read
        tb_inst = 3'b010; // READ_RADIO
        tb_radio_busy = 1;
        #15;
        tb_radio_busy = 0; // Simulate radio operation completion
        
        wait (tb_busy == 1);
        wait (tb_busy == 0);
        tb_radio_data_driver = 8'bz; // Release bus

        // Return to IDLE
        tb_inst = 3'b000;
        #20;

        // End simulation
        $finish;
    end

endmodule