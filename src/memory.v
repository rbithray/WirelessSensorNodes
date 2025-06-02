//Module: Memory 

/*
    * This module implements a simple memory with read and write capabilities.
    * It supports 256 bytes of memory, with an 8-bit address and data bus.
    * The memory can be accessed using read and write signals.
 */

module memory(
    input wire [7:0] addr,             // Memory address
    inout wire [7:0] data,             // Memory data in
    input wire write,                  // Write enable signal
    input wire read,                   // Read enable signal
    input wire rst_n,                 // Active low reset signal
    input wire clk                       // Clock signal
);

reg [7:0] mem [0:255]; // Memory array (256 bytes)
integer i;

reg [7:0] data_out; // Output data register

always @(posedge clk) begin
    if (write) begin
        mem[addr] <= data; // Write data to memory
        
    end else
    if (read) begin
        data_out <= mem[addr]; // Read data from memory
    end else begin
        data_out <= 8'b0; // Default output
    end
end

assign data = (read && !write) ? data_out : 8'bz; // Tri-state output for read operation

endmodule