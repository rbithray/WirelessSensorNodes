module SensorModule(
    input real environment,                // Analog input from the environment
    input wire clk,                      // Clock signal
    input wire enable,                     // Enable signal
    output reg [7:0] data           // Output sensor data
);

    // Internal signal to hold the processed data
    reg [7:0] processed_data;

    always @(posedge clk) begin
        if (enable) begin
            // Process the environment input and convert it to digital data
            processed_data <= $rtoi(environment * 255.0); // Scale to 8-bit value
        end else begin
            processed_data <= 8'b0; // Reset output when not enabled
        end
    end

    // Assign the processed data to the output
    assign data = processed_data;

endmodule
