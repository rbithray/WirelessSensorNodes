`timescale 1ns/1ps

module node_tb;

    reg clk = 0;
    reg rst_n = 1;
    reg enable = 0;
    reg [2:0] inst = 3'b000;
    reg [7:0] environment = 8'h00;
    wire busy;

    // Instantiate the toplevel node
    toplevel uut (
        .clk(clk),
        .rst_n(rst_n),
        .environment(environment),
        .enable(enable),
        .inst(inst),
        .busy(busy)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveforms/node_tb.vcd");
        $dumpvars(0, node_tb);
        $monitor("Time: %0t | enable: %b | inst: %b | environment: %h | busy: %b",
                 $time, enable, inst, environment, busy);

        // Reset sequence
        rst_n = 0;
        enable = 0;
        inst = 3'b000;
        environment = 8'h00;
        #20;
        rst_n = 1;
        #10;

        // Enable the node
        enable = 1;

        // Simulate environment changes
        environment = 8'h10; #10;
        environment = 8'h20; #10;
        environment = 8'h30; #10;

        // Issue a READ_SENSOR instruction
        inst = 3'b001;
        wait(busy == 1); // Wait for busy signal to indicate processing
        inst = 3'b000; // Return to IDLE
        wait(busy == 0); // Wait for processing to complete
        #20; // Allow some time for processing

        // Issue a WRITE_MEMORY instruction
        inst = 3'b100;
        wait(busy == 1); // Wait for busy signal to indicate processing
        inst = 3'b000;
        wait(busy == 0); // Wait for processing to complete
        #20; // Allow some time for processing

        // Issue a READ_MEMORY instruction
        inst = 3'b101;
        wait(busy == 1); // Wait for busy signal to indicate processing
        inst = 3'b000;
        wait(busy == 0); // Wait for processing to complete
        #20; // Allow some time for processing

        // Issue a WRITE_RADIO instruction
        inst = 3'b011;
        wait(busy == 1); // Wait for busy signal to indicate processing
        inst = 3'b000;
        wait(busy == 0); // Wait for processing to complete
        #20; // Allow some time for processing

        // Issue a READ_RADIO instruction
        inst = 3'b010;
        wait(busy == 1); // Wait for busy signal to indicate processing
        inst = 3'b000;
        wait(busy == 0); // Wait for processing to complete
        #20; // Allow some time for processing

        // Simulate more environment changes
        environment = 8'h55; #10;
        environment = 8'hAA; #10;

        // End simulation
        #50;
        $finish;
    end

endmodule