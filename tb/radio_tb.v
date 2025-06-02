`timescale 1ns/1ps

module radio_tb;

    reg clk = 0;
    reg enable = 0;
    reg send = 0;
    reg receive = 0;
    reg [7:0] tx_data = 8'b0;
    wire busy;
    wire [7:0] rx_data;
    wire Tx;
    reg Rx = 0;

    // Instantiate the radio module
    radio uut (
        .clk(clk),
        .enable(enable),
        .send(send),
        .busy(busy),
        .receive(receive),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .Tx(Tx),
        .Rx(Rx)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        // Dumpfile setup for waveform viewing
        $dumpfile("./Verilog/waveforms/radio.vcd");
        $dumpvars(0, radio_tb);
        $monitor("Time: %0t | clk: %b | enable: %b | send: %b | receive: %b | tx_data: %b | busy: %b | Tx: %b | Rx: %b | rx_data: %b",
                 $time, clk, enable, send, receive, tx_data, busy, Tx, Rx, rx_data);

        // Initialize
        enable = 0;
        #10;
        enable = 1;
        send = 0;
        receive = 0;
        tx_data = 8'b10101010;
        Rx = 0;

        // Wait for a few cycles
        #20;

        // Test transmit
        send = 1;
        #10;
        send = 0;

        // Wait for transmission to finish
        wait (!busy);
        #20;

        // Test receive
        receive = 1;
        // Simulate serial data on Rx (LSB first)
        repeat (8) begin
            #10;
            Rx = $random & 1; // Random bit
        end
        receive = 0;
        #20;

        // End simulation
        $finish;

    end
endmodule