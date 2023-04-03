// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   mem_wb.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-13
// Description:
//
// ---********************************************************************------
`include "defines.v"
module mem_wb
    (
    input                                        clk,
    input                                        rst_n,
    input                              [`RegBus] mem_wdata,
    input                          [`RegAddrBus] mem_wd,
    input                                        mem_wreg,
    input                                        mem_whilo,
    input                              [`RegBus] mem_hi,
    input                              [`RegBus] mem_lo,
    input                                  [5:0] stall,

    output reg                         [`RegBus] wb_wdata,
    output reg                     [`RegAddrBus] wb_wd,
    output reg                                   wb_wreg,
    output reg                                   wb_whilo,
    output reg                         [`RegBus] wb_hi,
    output reg                         [`RegBus] wb_lo
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
always @(posedge clk or negedge rst_n)
begin
  if (rst_n == `RstEnable)
  begin
    wb_wdata                 <= `ZeroWord;
    wb_wd                    <= `NOPRegAddr;
    wb_wreg                  <= `WriteDisable;
    wb_whilo                 <= `WriteDisable;
    wb_hi                    <= `ZeroWord;
    wb_lo                    <= `ZeroWord;
  end
  else if ((stall[4] == `Stop) && (stall[5] == `NoStop))
  begin
    wb_wdata                 <= `ZeroWord;
    wb_wd                    <= `NOPRegAddr;
    wb_wreg                  <= `WriteDisable;
    wb_whilo                 <= `WriteDisable;
    wb_hi                    <= `ZeroWord;
    wb_lo                    <= `ZeroWord;
  end
  else if (stall[4] == `NoStop)
  begin
    wb_wdata                 <= mem_wdata;
    wb_wd                    <= mem_wd;
    wb_wreg                  <= mem_wreg;
    wb_whilo                 <= mem_whilo;
    wb_hi                    <= mem_hi;
    wb_lo                    <= mem_lo;
  end
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
