module radio(
    input wire Rx,                         // Input signal
    input wire enable,                     // Enable signal
    input wire clock,                      // Clock signal
    output reg Tx,                         // Output signal
    output reg [7:0] radio_data            // Radio data output
);
// Radio logic will be added here later
endmodule