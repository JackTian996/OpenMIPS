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
    input                                        mem_llbit_we,
    input                                        mem_llbit_value,
    input                                        mem_cp0_we,
    input                                  [4:0] mem_cp0_waddr,
    input                                  [4:0] mem_cp0_raddr,
    input                              [`RegBus] mem_cp0_wdata,
    output reg                         [`RegBus] wb_wdata,
    output reg                     [`RegAddrBus] wb_wd,
    output reg                                   wb_wreg,
    output reg                                   wb_whilo,
    output reg                         [`RegBus] wb_hi,
    output reg                         [`RegBus] wb_lo,
    output reg                                   wb_llbit_we,
    output reg                                   wb_llbit_value,
    output reg                                   wb_cp0_we,
    output reg                             [4:0] wb_cp0_waddr,
    output reg                             [4:0] wb_cp0_raddr,
    output reg                         [`RegBus] wb_cp0_wdata

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
    wb_llbit_we              <= `WriteDisable;
    wb_llbit_value           <= 1'b0;
    wb_cp0_we                <= `WriteDisable;
    wb_cp0_waddr             <= 5'b0;
    wb_cp0_raddr             <= 5'b0;
    wb_cp0_wdata             <= `ZeroWord;
  end
  else if ((stall[4] == `Stop) && (stall[5] == `NoStop))
  begin
    wb_wdata                 <= `ZeroWord;
    wb_wd                    <= `NOPRegAddr;
    wb_wreg                  <= `WriteDisable;
    wb_whilo                 <= `WriteDisable;
    wb_hi                    <= `ZeroWord;
    wb_lo                    <= `ZeroWord;
    wb_llbit_we              <= `WriteDisable;
    wb_llbit_value           <= 1'b0;
    wb_cp0_we                <= `WriteDisable;
    wb_cp0_waddr             <= 5'b0;
    wb_cp0_raddr             <= 5'b0;
    wb_cp0_wdata             <= `ZeroWord;
  end
  else if (stall[4] == `NoStop)
  begin
    wb_wdata                 <= mem_wdata;
    wb_wd                    <= mem_wd;
    wb_wreg                  <= mem_wreg;
    wb_whilo                 <= mem_whilo;
    wb_hi                    <= mem_hi;
    wb_lo                    <= mem_lo;
    wb_llbit_we              <= mem_llbit_we;
    wb_llbit_value           <= mem_llbit_value;
    wb_cp0_we                <= mem_cp0_we;
    wb_cp0_waddr             <= mem_cp0_waddr;
    wb_cp0_raddr             <= mem_cp0_raddr;
    wb_cp0_wdata             <= mem_cp0_wdata;
  end
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
