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
