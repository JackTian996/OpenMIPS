// ---********************************************************************------
// Copyright 2020-2030 (c) , Inc. All rights reserved.
// Module Name:   wishbone2ram_sync_bridge.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-05-07
// Description:
//
// ---********************************************************************------
`include "defines.v"
module wishbone2ram_sync_bridge
   #(
    parameter ADDR_WIDTH                       = 32,
    parameter DATA_WIDTH                       = 32,
    parameter SEL_WIDTH                        = 4,
    parameter READ_LATENCY                     = 1,
	 parameter WRITE_LATENCY                    = 1
    )
    (
    input                                        clk,
    input                                        rst_n,
    // mst
    output reg                                   ram_ce_o,
    output reg                                   ram_we_o,
    output reg                  [ADDR_WIDTH-1:0] ram_addr_o,
    output reg                  [DATA_WIDTH-1:0] ram_data_o,
    output reg                   [SEL_WIDTH-1:0] ram_sel_o,
    input                       [DATA_WIDTH-1:0] ram_data_i,
    // slv
    input                                        wishbone_cyc_i,
    input                                        wishbone_stb_i,
    input                                        wishbone_we_i,
    input                       [ADDR_WIDTH-1:0] wishbone_addr_i,
    input                       [DATA_WIDTH-1:0] wishbone_data_i,
    input                        [SEL_WIDTH-1:0] wishbone_sel_i,
    output                      [DATA_WIDTH-1:0] wishbone_data_o,
    output                                       wishbone_ack_o
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
reg                             [READ_LATENCY:0] rd_phase_flag;
reg                            [WRITE_LATENCY:0] wr_phase_flag;
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
assign wishbone_data_o   = ram_data_i;

always @(*)
begin : RAM_OUTIF_CTRL
  ram_ce_o               = wishbone_cyc_i & wishbone_stb_i;
  ram_we_o               = wishbone_we_i & wishbone_cyc_i & wishbone_stb_i;
  ram_addr_o             = wishbone_addr_i;
  ram_data_o             = wishbone_data_i;
  ram_sel_o              = wishbone_sel_i;
end

always @(posedge clk or negedge rst_n)
begin : RD_PHASE_FLAG_PROC
  if (rst_n == 1'b0)
    rd_phase_flag        <= {{READ_LATENCY{1'b0}},1'b1};
  else if ((wishbone_cyc_i & wishbone_stb_i & (~wishbone_we_i)) == 1'b1)
    rd_phase_flag        <= {rd_phase_flag[READ_LATENCY-1:0],rd_phase_flag[READ_LATENCY]};
end

always @(posedge clk or negedge rst_n)
begin : WR_PHASE_FLAG_PROC
  if (rst_n == 1'b0)
    wr_phase_flag        <= {{WRITE_LATENCY{1'b0}},1'b1};
  else if ((wishbone_cyc_i & wishbone_stb_i & wishbone_we_i) == 1'b1)
    wr_phase_flag        <= {wr_phase_flag[WRITE_LATENCY-1:0],wr_phase_flag[WRITE_LATENCY]};
end

assign wishbone_ack_o     = rd_phase_flag[READ_LATENCY] | wr_phase_flag[WRITE_LATENCY];

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
