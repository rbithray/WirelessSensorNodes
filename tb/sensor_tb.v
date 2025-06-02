`timescale 1ns/1ps

module sensor_tb;

    reg clk = 0;
    reg enable = 0;
    real environment = 0.0;
    wire [7:0] sensor_data;

    // Instantiate the sensor
    sensor uut (
        .environment(environment),
        .clk(clk),
        .enable(enable),
        .data(sensor_data)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        $dumpfile("./Verilog/waveforms/sensor.vcd");
        $dumpvars(0, sensor_tb);
        $monitor("Time: %0t | clk: %b | enable: %b | environment: %f | sensor_data: %b",
                 $time, clk, enable, environment, sensor_data);

        // Initialize
        enable = 0;
        environment = 0.0;
        #10;

        // Enable sensor and apply different environment values
        enable = 1;

        environment = 8'h00;   #10;
        environment = 8'h0F;  #10;
        environment = 8'h50;   #10;
        environment = 8'h5F;  #10;
        environment = 8'hFF;   #10;

        // Disable sensor
        enable = 0;
        environment = 8'b0;   #10;

        // End simulation
        $finish;
    end

endmodule