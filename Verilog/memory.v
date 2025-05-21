module memory(
    input wire [3:0] addr,             // Memory address
    input wire [7:0] data_in,             // Memory data in
    output reg [7:0] data_out,             // Memory data out
    input wire write,                  // Write enable signal
    input wire read,                   // Read enable signal
    input wire rst_n,                 // Active low reset signal
    input wire clk                       // Clock signal
);

reg [7:0] mem [0:255]; // Memory array (256 bytes)
integer i;

always @(posedge clk) begin
    if (!rst_n) begin
        // Initialize memory to zero on reset
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] <= 8'b0;
        end
    end else if (read && !write) begin
        data_out <= mem[addr]; // Read data from memory
    end else
    if (write) begin
        mem[addr] <= data_in; // Write data to memory
    end
end

endmodule