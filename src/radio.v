//Module: Radio

/*    
    * This module implements a simple radio interface for transmitting and receiving data.
    * It supports an 8-bit data bus and operates on the rising edge of the clock signal.
    * The radio can be enabled or disabled using an enable signal.
    * The radio operates in two modes: transmit and receive, controlled by the send and receive signals.
*/

module radio(
    input  wire        clk,         // Clock signal
    input  wire        enable,      // Enable signal
    // Control signals
    input  wire        send,        // Control signal from controller to trigger transmit
    output wire        busy,        // Indicates if the radio is busy
    input  wire        receive,     // Control signal from controller to trigger receive
    // Data transfer between controller and radio
    inout  wire [7:0]  data,     // Data from controller to transmit
    // Radio signals
    output reg         Tx,          // Output signal (to antenna)
    input  wire        Rx          // Input signal (from antenna)

);

    // Transmit state
    reg [2:0] tx_bit_cnt = 0;
    reg [7:0] tx_shift_reg = 0;
    reg [7:0] tx_data = 0; // Data to be transmitted
    reg       tx_busy = 0;

    // Receive state
    reg [2:0] rx_bit_cnt = 0;
    reg [7:0] rx_shift_reg = 0;
    reg [7:0] rx_data = 0; // Data received
    reg       rx_busy = 0;



    // Assign busy signal based on transmit and receive states
    assign busy = tx_busy || rx_busy;
    assign data = (receive && !send) ? rx_data : 8'bz;

    always @(posedge clk) begin
        if (!enable) begin
            // Reset everything if not enabled
            Tx <= 0;
            tx_bit_cnt <= 0;
            tx_shift_reg <= 0;
            tx_busy <= 0;
            rx_bit_cnt <= 0;
            rx_shift_reg <= 0;
            rx_busy <= 0;
            rx_data <= 8'b0;
        end else begin
            // TRANSMIT LOGIC
            if (send && !tx_busy) begin
                // Start transmission
                tx_shift_reg <= tx_data;
                tx_bit_cnt <= 0;
                tx_busy <= 1;
            end

            if (tx_busy) begin
                Tx <= tx_shift_reg[0]; // Send LSB first
                tx_shift_reg <= {1'b0, tx_shift_reg[7:1]}; // Shift right
                tx_bit_cnt <= tx_bit_cnt + 1;
                if (tx_bit_cnt == 7) begin
                    tx_busy <= 0; // Done transmitting 8 bits
                end
            end else begin
                Tx <= 0;
            end

            // RECEIVE LOGIC
            // Simple: sample Rx on every clock when enabled
            if (receive && !rx_busy) begin
                rx_busy <= 1;
                rx_bit_cnt <= 0;
                rx_shift_reg <= 0;
            end

            if (rx_busy) begin
                rx_shift_reg <= {Rx, rx_shift_reg[7:1]}; // Shift in Rx
                rx_bit_cnt <= rx_bit_cnt + 1;
                if (rx_bit_cnt == 7) begin
                    rx_data <= rx_shift_reg;
                    rx_busy <= 0;
                end
            end
        end
    end

endmodule