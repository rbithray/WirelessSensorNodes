`timescale 1ns / 1ps

module memory_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    
    // Inputs
    reg [ADDR_WIDTH-1:0] address;
    reg [DATA_WIDTH-1:0] data;
    reg write_enable;
    reg read_enable;
    
    // Outputs
    wire [DATA_WIDTH-1:0] data_out;
    
    // Testbench signals
    reg clk;
    reg rst_n;
    integer i;

    // Instantiate memory module
    memory dut (
        .addr(address), 
        .data_in(data),
        .data_out(data_out),
        .write(write_enable),
        .read(read_enable),
        .rst_n(rst_n),
        .clk(clk)
    );

    // Clock generation
    initial begin
        $dumpfile("./Verilog/waveforms/memory.vcd");
        $dumpvars(0, memory_tb);
        $monitor("Time: %0t | clk: %b | rst_n: %b | address: %h | data_in: %h | write_enable: %b | read_enable: %b | data_out: %h",
                 $time, clk, rst_n, address, data, write_enable, read_enable, data_out);
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Stimulus
    initial begin
        rst_n = 0;
        address = 0;
        data = 0;
        write_enable = 0;
        read_enable = 0;
        #10;
        rst_n = 1;
        #10;

        // Test write operation
        for (i = 0; i < 16; i = i + 1) begin
            address = i; // Address to write to
            data = i * 2; // Write some data
            write_enable = 1;
            read_enable = 0;
            #10;
            write_enable = 0;
            #10;
        end

        // Test read operation
        for (i = 0; i < 16; i = i + 1) begin
            address = i; // Address to read from
            write_enable = 0;
            read_enable = 1;
            #10;
            read_enable = 0;
            #10;
        end

        // Test reset operation
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;

        // Test read after reset
        for (i = 0; i < 16; i = i + 1) begin
            address = i; // Address to read from
            write_enable = 0;
            read_enable = 1;
            #10;
            read_enable = 0;
            #10;
        end

        // Finish simulation
        $finish;
    end

endmodule