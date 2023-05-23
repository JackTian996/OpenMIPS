// ---********************************************************************------
// Copyright 2020-2030 (c) , Inc. All rights reserved.
// Module Name:   mips_div.v
// Author     :   tianshuo@firefox.com
// Project Name:  SOC_CBB
// Create Date:   2023-04-02
// Description:
//
// ---********************************************************************------
`ifndef _MIPS_DIV_V__
`define _MIPS_DIV_V__

module mips_div
   #(
    parameter OPDATA_WIDTH                     = 32,
    parameter CNT_WIDTH                        = 6,                            // log(OPDATA_WIDTH) + 1
    parameter RST_ENABLE                       = 0
    )
    (
    input                                        clk,
    input                                        rst_n,
    input                                        signed_div_i,
    input                     [OPDATA_WIDTH-1:0] opdata1_i,
    input                     [OPDATA_WIDTH-1:0] opdata2_i,
    input                                        start_i,
    input                                        annul_i,
    output                  [2*OPDATA_WIDTH-1:0] result_o,
    output                                       valid_o
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------
localparam DIV_FREE               = 2'b00;
localparam DIV_BY_ZERO            = 2'b01;
localparam DIV_ON                 = 2'b10;
localparam DIV_END                = 2'b11;
localparam DIV_START              = 1'b1;
localparam DIV_STOP               = 1'b0;
// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
reg                                        [1:0] state;
reg                                              valid_tmp;
reg                           [2*OPDATA_WIDTH:0] dividend;
wire                            [OPDATA_WIDTH:0] subn_result;
wire                          [OPDATA_WIDTH-1:0] divisor;
reg                              [CNT_WIDTH-1:0] cnt;
wire                          [OPDATA_WIDTH-1:0] temp_op1;
wire                          [OPDATA_WIDTH-1:0] temp_op2;
reg                                        [1:0] state_nxt;

// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
// Step 1
always @(*)
begin : STATE_NXT_PROC
  case(state)
    DIV_FREE:
      begin
        if ((start_i == DIV_START) && (annul_i == 1'b0) && (opdata2_i == {OPDATA_WIDTH{1'b0}}))
          state_nxt          = DIV_BY_ZERO;
        else if ((start_i == DIV_START) && (annul_i == 1'b0) && (opdata2_i != {OPDATA_WIDTH{1'b0}}))
          state_nxt          = DIV_ON;
        else
          state_nxt          = state;
      end
    DIV_BY_ZERO:
      begin
        state_nxt            = DIV_END;
      end
    DIV_ON:
      begin
        if ((annul_i == 1'b0) && (cnt[CNT_WIDTH-1] == 1'b1))  //cnt full
          state_nxt          = DIV_END;
        else if (annul_i == 1'b1)
          state_nxt          = DIV_FREE;
        else
          state_nxt          = state;
      end
    DIV_END:
      begin
        if (start_i == DIV_STOP)
          state_nxt          = DIV_FREE;
        else
          state_nxt          = state;
      end
    default:
      begin
        state_nxt            = state;
      end
  endcase
end

// Step2
always @(posedge clk or negedge rst_n)
begin : CNT_PROC
  if (rst_n == RST_ENABLE)
    cnt                      <= {CNT_WIDTH{1'b0}};
  else if ((state == DIV_FREE) && (state_nxt == DIV_ON))
    cnt                      <= {CNT_WIDTH{1'b0}};
  else if (state == DIV_ON)
    cnt                      <= cnt + 1'b1;
end

assign temp_op1              = (opdata1_i[OPDATA_WIDTH-1] == 1'b1) && (signed_div_i == 1'b1) ? ~opdata1_i + 1 : opdata1_i;
assign temp_op2              = (opdata2_i[OPDATA_WIDTH-1] == 1'b1) && (signed_div_i == 1'b1) ? ~opdata2_i + 1 : opdata2_i;
assign divisor               = temp_op2;

assign subn_result           = {1'b0,dividend[2*OPDATA_WIDTH-1:OPDATA_WIDTH]} - {1'b0,divisor};

always @(posedge clk or negedge rst_n)
begin : DIVIDEND_PROC
  if (rst_n == RST_ENABLE)
    dividend                 <= {(2*OPDATA_WIDTH+1){1'b0}};
  else if ((state == DIV_FREE) && (state_nxt == DIV_ON))
    dividend                 <= {{OPDATA_WIDTH{1'b0}},temp_op1,1'b0};
  else if ((state == DIV_FREE) && (state_nxt == DIV_BY_ZERO)) // result is 0
    dividend                 <= {(2*OPDATA_WIDTH+1){1'b0}};
  else if ((state == DIV_ON) && (state_nxt != DIV_END))
  begin
    if (subn_result[OPDATA_WIDTH] == 1'b1)
      dividend               <= {dividend[2*OPDATA_WIDTH-1:0],1'b0}; // left shift 1bit
    else
      dividend               <= {subn_result[OPDATA_WIDTH-1:0],dividend[OPDATA_WIDTH-1:0],1'b1};
  end
  else if ((state == DIV_ON) && (state_nxt == DIV_END))
  begin
    if ((signed_div_i == 1'b1) && ((opdata1_i[OPDATA_WIDTH-1] ^ opdata2_i[OPDATA_WIDTH-1]) == 1'b1))
      dividend[OPDATA_WIDTH-1:0] <= ~dividend[OPDATA_WIDTH-1:0] + 1'b1;
    if ((signed_div_i == 1'b1) && ((opdata1_i[OPDATA_WIDTH-1] ^ dividend[2*OPDATA_WIDTH]) == 1'b1))
      dividend[2*OPDATA_WIDTH:OPDATA_WIDTH+1] <= ~dividend[2*OPDATA_WIDTH:OPDATA_WIDTH+1] + 1'b1;
  end
end

assign result_o              = {dividend[2*OPDATA_WIDTH:OPDATA_WIDTH+1],dividend[OPDATA_WIDTH-1:0]};

always @(posedge clk or negedge rst_n)
begin : READY_O_PROC
  if (rst_n == RST_ENABLE)
    valid_tmp                <= 1'b0;
  else if (state_nxt == DIV_END)
    valid_tmp                <= 1'b1;
  else if (state_nxt == DIV_FREE)
    valid_tmp                <= 1'b0;
end

assign valid_o               = valid_tmp;

// Step3
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == RST_ENABLE)
    state                    <= DIV_FREE;
  else if (state_nxt != state)
    state                    <= state_nxt;
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule
`endif
// ---********************************************************************------
