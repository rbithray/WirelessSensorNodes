`timescale 1ns / 1ps

module memory_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 8;

    // Testbench signals
    reg [ADDR_WIDTH-1:0] address;
    reg [DATA_WIDTH-1:0] data_drive;
    wire [DATA_WIDTH-1:0] data;
    reg write_enable;
    reg read_enable;
    reg clk;
    reg rst_n;
    integer i;

    // Tri-state data bus control
    assign data = (write_enable && !read_enable) ? data_drive : 8'bz;

    // Instantiate memory module
    memory dut (
        .addr(address),
        .data(data),
        .write(write_enable),
        .read(read_enable),
        .rst_n(rst_n),
        .clk(clk)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        $dumpfile("./Verilog/waveforms/memory.vcd");
        $dumpvars(0, memory_tb);
        $monitor("Time: %0t | clk: %b | rst_n: %b | addr: %h | write: %b | read: %b | data_drive: %h | data: %h",
                 $time, clk, rst_n, address, write_enable, read_enable, data_drive, data);

        // Initial state
        rst_n = 0;
        address = 0;
        data_drive = 0;
        write_enable = 0;
        read_enable = 0;
        #20;

        // Release reset
        rst_n = 1;
        #10;

        // Write data to memory
        for (i = 0; i < 16; i = i + 1) begin
            @(negedge clk);
            address = i;
            data_drive = i * 3;
            write_enable = 1;
            read_enable = 0;
            @(negedge clk);
            write_enable = 0;
        end

        // Read data from memory
        for (i = 0; i < 16; i = i + 1) begin
            @(negedge clk);
            address = i;
            write_enable = 0;
            read_enable = 1;
            @(negedge clk);
            read_enable = 0;
        end

        // Reset memory
        @(negedge clk);
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;

        // Read memory after reset
        for (i = 0; i < 16; i = i + 1) begin
            @(negedge clk);
            address = i;
            write_enable = 0;
            read_enable = 1;
            @(negedge clk);
            read_enable = 0;
        end

        // End simulation
        #20;
        $finish;
    end

endmodule
