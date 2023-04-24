// ---********************************************************************------
// Copyright 2020-2030 (c) , Inc. All rights reserved.
// Module Name:   ram2wishbone_sync_bridge.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-04-20
// Description:
//
// ---********************************************************************------
module ram2wishbone_sync_bridge
   #(
    parameter ADDR_WIDTH                       = 32,
    parameter DATA_WIDTH                       = 32,
    parameter SEL_WIDTH                        = 4
    )
    (
    input                                        clk,
    input                                        rst_n,
    // from ctrl
    input                                  [5:0] stall_i,
    input                                        flush_i,
    output                                       stall_req,
    // slv
    input                                        ram_ce_i,
    input                                        ram_we_i,
    input                       [ADDR_WIDTH-1:0] ram_addr_i,
    input                       [DATA_WIDTH-1:0] ram_data_i,
    input                        [SEL_WIDTH-1:0] ram_sel_i,
    output                      [DATA_WIDTH-1:0] ram_data_o,
    // mst
    output reg                                   wishbone_cyc_o,
    output reg                                   wishbone_stb_o,
    output reg                                   wishbone_we_o,
    output reg                  [ADDR_WIDTH-1:0] wishbone_addr_o,
    output reg                  [DATA_WIDTH-1:0] wishbone_data_o,
    output reg                   [SEL_WIDTH-1:0] wishbone_sel_o,
    input                       [DATA_WIDTH-1:0] wishbone_data_i,
    input                                        wishbone_ack_i
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------
localparam WB_IDLE                = 2'b00;
localparam WB_BUSY                = 2'b01;
localparam WB_STALL               = 2'b10;

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
reg                                        [1:0] state_nxt;
reg                                        [1:0] state;
reg                             [DATA_WIDTH-1:0] return_data_buf;
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
// --------------------> session1 : state transition
always @(*)
begin : STATE_NXT_PROC
  case (state)
    WB_IDLE : state_nxt      = ((flush_i == 1'b0) && (ram_ce_i == `ChipEnable)) ? WB_BUSY : state;
    WB_BUSY : state_nxt      = ((flush_i == 1'b1) || ((wishbone_ack_i == 1'b1)  && (stall_i[1] == `NoStop))) ?
                               WB_IDLE :
                               ((wishbone_ack_i == 1'b1)  && (stall_i[1] == `Stop)) ? WB_STALL : state;
    WB_STALL : state_nxt     = (stall_i[1] == `NoStop) ? WB_IDLE : state;
    default : state_nxt      = WB_IDLE;
  endcase
end

// --------------------> session2 : signal ctrl
assign stall_req             = (((state == WB_IDLE) && (flush_i == 1'b0) && (ram_ce_i == `ChipEnable)) ||
                    ((state == WB_BUSY) && (wishbone_ack_i == 1'b0))) ? 1'b1 : 1'b0;

assign ram_data_o            = (state == WB_BUSY) ? wishbone_data_i : return_data_buf;

always @(posedge clk or negedge rst_n)
begin : RETURN_DATA_BUF_PROC
  if (rst_n == `RstEnable)
    return_data_buf          <= {DATA_WIDTH{1'b0}};
  else if ((state == WB_BUSY) && (wishbone_we_o == 1'b0) && (wishbone_ack_i == 1'b1) && (stall_i[1] == `Stop))
    return_data_buf          <= wishbone_data_i;
end

always @(*)
begin : WISHBONE_IF_PROC
  wishbone_we_o              = ram_we_i;
  wishbone_addr_o            = ram_addr_i;
  wishbone_data_o            = ram_data_i;
  wishbone_sel_o             = ram_sel_i;
  if ((state == WB_IDLE) && (flush_i == 1'b0) && (ram_ce_i == `ChipEnable) || (state == WB_BUSY))
  begin
    wishbone_cyc_o           = 1'b1;
    wishbone_stb_o           = 1'b1;
  end
  else
  begin
    wishbone_cyc_o           = 1'b0;
    wishbone_stb_o           = 1'b0;
  end
end

// --------------------> session3
always @(posedge clk or negedge rst_n)
begin : STATE_PROC
  if (rst_n == `RstEnable)
    state                    <= WB_IDLE;
  else if (state != state_nxt)
    state                    <= state_nxt;
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
