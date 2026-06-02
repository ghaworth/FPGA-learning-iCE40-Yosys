// uart_hello_top.v
// Repeatedly transmits "Hello\r\n" at 9600 8N1 on PMOD pin 1.
// LED 1 lights while the UART is actively sending a byte.
//
// Probe PMOD pin 1 (header row 1, pin 1) with the nanoDLA.
// Connect nanoDLA GND to Go Board GND (PMOD header GND pin).

module uart_hello_top (
    input  i_Clk,
    output io_PMOD_1,
    output o_LED_1
);

    localparam CLKS_PER_BIT = 2604;     // 25 MHz / 9600 baud
    localparam GAP_CLKS     = 250_000;  // ~10 ms idle between messages
    localparam MSG_LEN      = 7;        // "Hello\r\n"

    localparam S_SEND = 2'd0;
    localparam S_WAIT = 2'd1;
    localparam S_GAP  = 2'd2;

    reg [1:0]  r_State     = S_SEND;
    reg [2:0]  r_Msg_Idx   = 3'd0;
    reg [17:0] r_Gap_Count = 18'd0;  // 18 bits: max 262143 > 250000
    reg        r_TX_DV     = 1'b0;

    wire w_TX_Serial;
    wire w_TX_Active;
    wire w_TX_Done;

    // Combinatorial message ROM
    reg [7:0] r_ROM_Data;
    always @(*) begin
        case (r_Msg_Idx)
            3'd0: r_ROM_Data = 8'h48; // 'H'
            3'd1: r_ROM_Data = 8'h65; // 'e'
            3'd2: r_ROM_Data = 8'h6C; // 'l'
            3'd3: r_ROM_Data = 8'h6C; // 'l'
            3'd4: r_ROM_Data = 8'h6F; // 'o'
            3'd5: r_ROM_Data = 8'h0D; // CR
            3'd6: r_ROM_Data = 8'h0A; // LF
            default: r_ROM_Data = 8'h00;
        endcase
    end

    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) u_tx (
        .i_Clk      (i_Clk),
        .i_TX_DV    (r_TX_DV),
        .i_TX_Byte  (r_ROM_Data),
        .o_TX_Serial(w_TX_Serial),
        .o_TX_Active(w_TX_Active),
        .o_TX_Done  (w_TX_Done)
    );

    assign io_PMOD_1 = w_TX_Serial;
    assign o_LED_1   = w_TX_Serial;

    always @(posedge i_Clk) begin
        r_TX_DV <= 1'b0;  // default: no data valid

        case (r_State)
            // Assert DV for one clock, then wait for the UART to finish
            S_SEND: begin
                r_TX_DV <= 1'b1;
                r_State  <= S_WAIT;
            end

            S_WAIT: begin
                if (w_TX_Done) begin
                    if (r_Msg_Idx == MSG_LEN - 1) begin
                        r_Msg_Idx   <= 3'd0;
                        r_Gap_Count <= 18'd0;
                        r_State     <= S_GAP;
                    end else begin
                        r_Msg_Idx <= r_Msg_Idx + 1'b1;
                        r_State   <= S_SEND;
                    end
                end
            end

            S_GAP: begin
                if (r_Gap_Count < GAP_CLKS - 1) begin
                    r_Gap_Count <= r_Gap_Count + 1'b1;
                end else begin
                    r_State <= S_SEND;
                end
            end

            default: r_State <= S_SEND;
        endcase
    end

endmodule
