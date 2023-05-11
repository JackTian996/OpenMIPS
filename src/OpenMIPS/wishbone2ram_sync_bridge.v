// ---********************************************************************------
// Copyright 2020-2030 (c) , Inc. All rights reserved.
// Module Name:   wishbone2ram_sync_bridge.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-05-07
// Description:
//
// ---********************************************************************------
module wishbone2ram_sync_bridge
   #(
    parameter ADDR_WIDTH                       = 32,
    parameter DATA_WIDTH                       = 32,
    parameter SEL_WIDTH                        = 4,
    parameter REG_OUT                          = 0
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

// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
assign wishbone_data_o       = ram_data_i;
assign wishbone_ack_o        = wishbone_cyc_i & wishbone_stb_i;

generate
if (REG_OUT == 1) begin : REG_OUT_C0_GEN
  always @ (posedge clk or negedge rst_n)
  begin : RAM_OUTIF_CTRL
    if (rst_n == `RstEnable) begin
      ram_ce_o                 <= `ChipDisable;
      ram_we_o                 <= `WriteDisable;
      ram_addr_o               <= {ADDR_WIDTH{1'b0}};
      ram_data_o               <= {DATA_WIDTH{1'b0}};
      ram_sel_o                <= {SEL_WIDTH{1'b0}};
    end
    else if ((wishbone_cyc_i & wishbone_stb_i) == 1'b1) begin
      ram_ce_o                 <= `ChipEnable;
      ram_we_o                 <= wishbone_we_i;
      ram_addr_o               <= wishbone_addr_i;
      ram_data_o               <= wishbone_data_i;
      ram_sel_o                <= wishbone_sel_i;
    end
  end
end
else begin : REG_OUT_C1_GEN
  always @(*)
  begin : RAM_OUTIF_CTRL
      ram_ce_o                 = wishbone_cyc_i & wishbone_stb_i;
      ram_we_o                 = wishbone_we_i;
      ram_addr_o               = wishbone_addr_i;
      ram_data_o               = wishbone_data_i;
      ram_sel_o                = wishbone_sel_i;
  end
end
endgenerate

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
