// Module: Sensor

/*
    * This module now serves as an analogue for a sensor, to help test the control signalling.
    * In its current form, this module is just an input buffer.
    * The sensor can be enabled or disabled using an enable signal.
    * The sensor operates on the rising edge of the clock signal.
*/

module sensor(
    input wire [7:0] environment,             // Analog input from the environment
    input wire clk,                      // Clock signal
    input wire enable,                   // Enable signal
    output reg [7:0] data                // Output sensor data
);

    always @(posedge clk) begin
        if (enable) begin
            // Process the environment input and convert it to digital data
            data <= environment; // Scale to 8-bit value
        end else begin
            data <= 8'b0; // Reset output when not enabled
        end
    end

endmodule
