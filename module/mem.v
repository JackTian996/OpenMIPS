// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   mem.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-13
// Description:
//
// ---********************************************************************------
`include "defines.v"
module mem
    (
    input                                        rst_n,
    input                              [`RegBus] wdata_i,
    input                          [`RegAddrBus] wd_i,
    input                                        wreg_i,
    input                                        whilo_i,
    input                              [`RegBus] hi_i,
    input                              [`RegBus] lo_i,
    output reg                         [`RegBus] wdata_o,
    output reg                     [`RegAddrBus] wd_o,
    output reg                                   wreg_o,
    output reg                                   whilo_o,
    output reg                         [`RegBus] hi_o,
    output reg                         [`RegBus] lo_o
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

always @(*)
begin
  if (rst_n == `RstEnable)
  begin
    wdata_o                  = `ZeroWord;
    wd_o                     = `NOPRegAddr;
    wreg_o                   = `WriteDisable;
    whilo_o                  = `WriteDisable;
    hi_o                     = `ZeroWord;
    lo_o                     = `ZeroWord;
  end
  else
  begin
    wdata_o                  = wdata_i;
    wd_o                     = wd_i;
    wreg_o                   = wreg_i;
    whilo_o                  = whilo_i;
    hi_o                     = hi_i;
    lo_o                     = lo_i;
  end
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
