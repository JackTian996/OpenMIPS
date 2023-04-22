// ---********************************************************************------
// Copyright 2020-2030 (c) , Inc. All rights reserved.
// Module Name:   mips_spbmsram.v
// Author     :   tianshuo@firefox.com
// Project Name:  SOC_CBB
// Create Date:   2023-04-06
// Description:
//
// ---********************************************************************------
`ifndef _MIPS_SPBMSRAM_V__
`define _MIPS_SPBMSRAM_V__

module MIPS_SPBMSRAM
   #(
    parameter MEM_WIDTH                        = 32,
    parameter MEM_DEPTH                        = 256,
    parameter ADDR_WIDTH                       = 8,
    parameter MODE                             = 0
    )
    (
    input                                        clk,
    input                                        rst_n,
    input                                        mem_ce,
    input                                        mem_wen,
    input                       [ADDR_WIDTH-1:0] mem_addr,
    input                        [MEM_WIDTH-1:0] mem_din,
    input                        [MEM_WIDTH-1:0] mem_wbeb,
    output reg                   [MEM_WIDTH-1:0] mem_dout
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
reg                              [MEM_WIDTH-1:0] mem_data[MEM_DEPTH-1:0];

// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
always @(posedge clk)
begin : MEM_DATA_PROC
  integer i, j;
  for (i = 0; i < MEM_DEPTH; i = i + 1)
  begin
    for (j = 0; j < MEM_WIDTH; j = j + 1)
    begin
      if ((mem_ce == 1'b1) && (mem_wen == 1'b1) && (mem_addr == i[ADDR_WIDTH-1:0]) && (mem_wbeb[j] == 1'b1))
        mem_data[i][j]       <= mem_din[j];
    end
  end
end

generate
if (MODE == 0) begin : MODE_C0_GEN
  always @(*)
  begin : MEM_DOUT_PROC
    if ((mem_ce == 1'b1) && (mem_wen == 1'b0))
      mem_dout               = mem_data[mem_addr];
    else
      mem_dout               = {MEM_WIDTH{1'b0}};
  end
end
else begin : MODE_C1_GEN
  always @(posedge clk)
  begin : MEM_DOUT_PROC
    if ((mem_ce == 1'b1) && (mem_wen == 1'b0))
      mem_dout               <= mem_data[mem_addr];
  end
end
endgenerate

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule
`endif

// ---********************************************************************------
