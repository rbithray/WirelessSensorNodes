`timescale 1ns/1ps

module packetiser_tb;

    reg clk = 0;
    reg rst_n = 0;
    reg [7:0] data_in = 8'h00;
    reg data_valid = 0;
    wire [7:0] tx_data;
    wire send;
    reg radio_busy = 0;
    wire packet_valid;
    reg packet_ready = 1; // Not used, but kept for compatibility

    // Instantiate the packetiser
    ipv6_packetiser uut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_valid(data_valid),
        .tx_data(tx_data),
        .send(send),
        .radio_busy(radio_busy),
        .packet_valid(packet_valid)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("./Verilog/waveforms/packetiser.vcd");
        $dumpvars(0, packetiser_tb);

        // Reset
        rst_n = 0;
        data_in = 8'h00;
        data_valid = 0;
        radio_busy = 0;
        #12;
        rst_n = 1;
        #10;

        // Send a data byte to be packetised
        data_in = 8'hAB;
        data_valid = 1;
        #10;
        data_valid = 0;

        // Wait for packetiser to output all bytes (header + payload)
        wait(packet_valid == 1);
        while (packet_valid) begin
            // Optionally, simulate radio busy for a few cycles
            if (send) begin
                radio_busy = 1;
                #5;
                radio_busy = 0;
            end
            #10;
        end

        // Send another data byte
        data_in = 8'hCD;
        data_valid = 1;
        #10;
        data_valid = 0;

        // Wait for packetiser to output all bytes (header + payload)
        wait(packet_valid == 1);
        while (packet_valid) begin
            if (send) begin
                radio_busy = 1;
                #5;
                radio_busy = 0;
            end
            #10;
        end

        // End simulation
        #20;
        $finish;
    end

endmodule