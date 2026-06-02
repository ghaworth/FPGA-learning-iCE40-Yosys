// uart_tx.v
// 8N1 UART transmitter
//
// i_TX_DV   : pulse high for one clock to start transmission
// i_TX_Byte : byte to send, sampled when i_TX_DV is asserted
// o_TX_Done : pulses high for one clock when stop bit is complete
// o_TX_Serial : idle high (UART convention)

module uart_tx #(
    parameter CLKS_PER_BIT = 2604   // 25 MHz / 9600 baud
) (
    input           i_Clk,
    input           i_TX_DV,
    input  [7:0]    i_TX_Byte,
    output reg      o_TX_Serial,
    output reg      o_TX_Active,
    output reg      o_TX_Done
);

    localparam IDLE         = 3'd0;
    localparam TX_START_BIT = 3'd1;
    localparam TX_DATA_BITS = 3'd2;
    localparam TX_STOP_BIT  = 3'd3;
    localparam CLEANUP      = 3'd4;

    // Declaration-time initialisation is reliable on iCE40 (nextpnr packs
    // initial FF values into the bitstream). This is NOT reliable on Artix-7
    // with GSR -- use explicit reset logic there instead.
    reg [2:0]  r_State     = IDLE;
    reg [11:0] r_Clk_Count = 12'd0;  // 12 bits: max value 4095 > 2604
    reg [2:0]  r_Bit_Idx   = 3'd0;
    reg [7:0]  r_TX_Data   = 8'd0;

    initial o_TX_Serial = 1'b1;      // UART line idles high

    always @(posedge i_Clk) begin
        o_TX_Done <= 1'b0;

        case (r_State)
            IDLE: begin
                o_TX_Serial <= 1'b1;
                o_TX_Active <= 1'b0;
                r_Clk_Count <= 12'd0;
                r_Bit_Idx   <= 3'd0;
                if (i_TX_DV) begin
                    r_TX_Data <= i_TX_Byte;
                    r_State   <= TX_START_BIT;
                end
            end

            TX_START_BIT: begin
                o_TX_Serial <= 1'b0;
                o_TX_Active <= 1'b1;
                if (r_Clk_Count < CLKS_PER_BIT - 1) begin
                    r_Clk_Count <= r_Clk_Count + 1'b1;
                end else begin
                    r_Clk_Count <= 12'd0;
                    r_State     <= TX_DATA_BITS;
                end
            end

            TX_DATA_BITS: begin
                o_TX_Serial <= r_TX_Data[r_Bit_Idx];
                if (r_Clk_Count < CLKS_PER_BIT - 1) begin
                    r_Clk_Count <= r_Clk_Count + 1'b1;
                end else begin
                    r_Clk_Count <= 12'd0;
                    if (r_Bit_Idx < 3'd7) begin
                        r_Bit_Idx <= r_Bit_Idx + 1'b1;
                    end else begin
                        r_Bit_Idx <= 3'd0;
                        r_State   <= TX_STOP_BIT;
                    end
                end
            end

            TX_STOP_BIT: begin
                o_TX_Serial <= 1'b1;
                if (r_Clk_Count < CLKS_PER_BIT - 1) begin
                    r_Clk_Count <= r_Clk_Count + 1'b1;
                end else begin
                    r_Clk_Count <= 12'd0;
                    o_TX_Done   <= 1'b1;
                    r_State     <= CLEANUP;
                end
            end

            CLEANUP: begin
                o_TX_Active <= 1'b0;
                r_State     <= IDLE;
            end

            default: r_State <= IDLE;
        endcase
    end

endmodule
