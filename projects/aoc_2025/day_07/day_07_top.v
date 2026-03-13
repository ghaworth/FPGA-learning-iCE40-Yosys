module Day_07_Top (
  input i_Clk,
  input i_Switch_1,
  output o_UART_TX
);
  // state machine definitions
  localparam IDLE = 0;
  localparam SEND_RESULT = 1;
  localparam SEND_TIMER = 2;
  reg [2:0] current_state = 0;
  wire sending_result = (current_state == SEND_RESULT);

  reg [2:0] prev_state = 0;
  wire enter_send_result = (current_state == SEND_RESULT) && (prev_state != SEND_RESULT);
  wire enter_send_timer = (current_state == SEND_TIMER) && (prev_state != SEND_TIMER);

  always @(posedge i_Clk) begin
    prev_state <= current_state;
    case (current_state) 
      IDLE: begin 
        if (core_done_edge) begin
          current_state <= SEND_RESULT;
        end
      end  

      SEND_RESULT: begin
        if (result_done) begin
          current_state <= SEND_TIMER;
        end
      end

      SEND_TIMER: begin 
        if (cc_done) begin
          current_state <= IDLE;
        end
      end
    endcase
  end

  // muxed signals
  wire [7:0] mux_byte_out = sending_result ? result_out : cc_byte_out;
  wire mux_byte_sent = sending_result ? result_sent : cc_sent;
  wire result_next = sending_result ? tx_done : 1'b0;
  wire cc_next = sending_result ? 1'b0 : tx_done;

  // core outputs
  wire [10:0] core_result;
  wire core_done;

  // timer outputs
  wire [31:0] tmr_result;
  wire tmr_done;

  // cycle count outputs
  wire [7:0] cc_byte_out;
  wire cc_sent;
  wire cc_done;

  // result outputs
  wire [7:0] result_out;
  wire result_sent;
  wire result_done;

  // uart transmitter outputs
  wire tx_active;
  wire tx_done;

  // debounced switch
  wire reset_debounced;

  reg button_prev = 0;
  wire button_edge;
  assign button_edge = reset_debounced && !button_prev;

  reg core_done_prev = 0;
  wire core_done_edge;
  assign core_done_edge = core_done && !core_done_prev;

  always @(posedge i_Clk) begin
    button_prev <= reset_debounced;
    core_done_prev <= core_done;
  end  

  Debounce_Switch debounce_reset (
    .i_Clk(i_Clk),
    .i_Switch(i_Switch_1),
    .o_Switch(reset_debounced)
  );

  Day_07_Core core (
    .clk(i_Clk),
    .result(core_result),
    .done(core_done),
    .start(button_edge)
  ); 

uart_tx #(.CLKS_PER_BIT(217)) uart_trans (
    .i_Clock    (i_Clk),
    .i_Tx_DV    (mux_byte_sent),
    .i_Tx_Byte  (mux_byte_out),
    .o_Tx_Active(tx_active),
    .o_Tx_Serial(o_UART_TX),
    .o_Tx_Done  (tx_done)
  );

Day_07_Timer tmr (
    .clk   (i_Clk),
    .start (button_edge),
    .stop  (core_done),
    .result(tmr_result),
    .done  (tmr_done)
  );

Value_To_Bytes #(.VALUE_WIDTH(32)) cycle_count (
    .clk             (i_Clk),
    .send_data_now   (enter_send_timer),
    .next_byte_please(cc_next),
    .data_in         (tmr_result),
    .byte_out        (cc_byte_out),
    .byte_sent       (cc_sent),
    .all_bytes_sent  (cc_done)
  );

Value_To_Bytes #(.VALUE_WIDTH(16)) result (
    .clk             (i_Clk),
    .send_data_now   (enter_send_result),
    .next_byte_please(result_next),
    .data_in         (core_result),
    .byte_out        (result_out),
    .byte_sent       (result_sent),
    .all_bytes_sent  (result_done)
    );

endmodule