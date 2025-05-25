module ipv6_packetiser (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,      // Payload data to be packetised
    input  wire        data_valid,   // Assert to start packetization
    output reg  [7:0]  tx_data,      // Data to radio's tx_data
    output reg         send,         // Pulse to radio's send
    input  wire        radio_busy,   // Radio busy signal
    output reg         packet_valid  // High when sending header or payload
);

    // State machine encoding
    parameter IDLE = 2'b00, HEADER = 2'b01, PAYLOAD = 2'b10, DONE = 2'b11;
    reg [1:0] state, next_state;

    // Minimal IPv6 header (4 bytes for demonstration)
    reg [7:0] IPV6_HEADER [0:3];
    reg [1:0] header_cnt;

    // Initialise header bytes
    initial begin
        IPV6_HEADER[0] = 8'h60; // Version, Traffic Class, Flow Label
        IPV6_HEADER[1] = 8'h00; // Payload Length (dummy)
        IPV6_HEADER[2] = 8'h00; // Next Header, Hop Limit (dummy)
        IPV6_HEADER[3] = 8'h00; // Source/Dest Address (dummy)
    end

    // Sequential logic: state transitions and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            header_cnt   <= 0;
            tx_data      <= 8'b0;
            send         <= 1'b0;
            packet_valid <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    // Wait for data_valid to start packetization
                    send         <= 1'b0;
                    packet_valid <= 1'b0;
                    header_cnt   <= 0;
                end
                HEADER: begin
                    // Send header bytes one by one when radio is not busy
                    if (!radio_busy) begin
                        tx_data      <= IPV6_HEADER[header_cnt];
                        send         <= 1'b1;
                        packet_valid <= 1'b1;
                    end else begin
                        send         <= 1'b0;
                    end
                end
                PAYLOAD: begin
                    // Send payload data when radio is not busy
                    if (!radio_busy) begin
                        tx_data      <= data_in;
                        send         <= 1'b1;
                        packet_valid <= 1'b1;
                    end else begin
                        send         <= 1'b0;
                    end
                end
                DONE: begin
                    // Finish packetization, return to IDLE
                    send         <= 1'b0;
                    packet_valid <= 1'b0;
                end
            endcase
        end
    end

    // Combinational logic: next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data_valid)
                    next_state = HEADER;
            end
            HEADER: begin
                // Advance header count and move to PAYLOAD after last header byte
                if (!radio_busy && send) begin
                    if (header_cnt == 2'd3)
                        next_state = PAYLOAD;
                    else
                        next_state = HEADER;
                end
            end
            PAYLOAD: begin
                // After sending payload, go to DONE
                if (!radio_busy && send)
                    next_state = DONE;
            end
            DONE: begin
                // Return to IDLE after done
                next_state = IDLE;
            end
        endcase
    end

    // Header counter logic: counts header bytes sent
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            header_cnt <= 0;
        else if (state == HEADER && !radio_busy && send)
            header_cnt <= header_cnt + 1;
        else if (state == IDLE)
            header_cnt <= 0;
    end

endmodule