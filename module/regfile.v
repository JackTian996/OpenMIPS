// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   regfile.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-12
// Description:
//
// ---********************************************************************------
`include "defines.v"
module regfile
    (
    input                                clk,
    input                                        rst_n,
    input                          [`RegAddrBus] waddr,
    input                                        we,
    input                              [`RegBus] wdata,
    input                          [`RegAddrBus] raddr1,
    input                                        re1,
    output reg                         [`RegBus] rdata1,
    input                          [`RegAddrBus] raddr2,
    input                                        re2,
    output reg                         [`RegBus] rdata2
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
reg                                    [`RegBus] regs[`RegNum-1:0];

// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO

always @(posedge clk)
begin : REGS_ENTRY_WR_PROC
  integer i;
  for (i = 0; i < `RegNum; i = i + 1)
  begin : REGS_ENRTY_WR_LOOP
    if ((rst_n == `RstDisable) && (we == `WriteEnable) && (|waddr == 1'b1) && (waddr == i[`RegAddrBus]))
      regs[i]                <= wdata;
  end
end

always @(*)
begin : RDATA1_PROC
  if (rst_n == `RstEnable)
    rdata1                   = `ZeroWord;
  else if ((re1 == `ReadEnable) && (raddr1 == `RegNumLog2'h0))
    rdata1                   = `ZeroWord;
  else if ((we == `WriteEnable) && (waddr == raddr1) && (re1 == `ReadEnable))
    rdata1                   = wdata;
  else if (re1 == `ReadEnable)
    rdata1                   = regs[raddr1];
  else
    rdata1                   = `ZeroWord;
end

always @(*)
begin : RDATA2_PROC
  if (rst_n == `RstEnable)
    rdata2                   = `ZeroWord;
  else if ((re2 == `ReadEnable) && (raddr2 == `RegNumLog2'h0))
    rdata2                   = `ZeroWord;
  else if ((we == `WriteEnable) && (waddr == raddr2) && (re2 == `ReadEnable))
    rdata2                   = wdata;
  else if (re2 == `ReadEnable)
    rdata2                   = regs[raddr2];
  else
    rdata2                   = `ZeroWord;
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
