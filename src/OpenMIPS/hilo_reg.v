// ---********************************************************************------
// Copyright 2020-2030 (c) , Inc. All rights reserved.
// Module Name:   hilo_reg.v
// Author     :   tianshuo@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-25
// Description:
//
// ---********************************************************************------
module hilo_reg
    (
    input                                        clk,
    input                                        rst_n,
    // wr port
    input                                        we,
    input                              [`RegBus] hi_i,
    input                              [`RegBus] lo_i,
    // rd port
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

always @(posedge clk or negedge rst_n)
begin : HILO_REG_PROC
  if (rst_n == `RstEnable)
  begin
    hi_o                     <= `ZeroWord;
    lo_o                     <= `ZeroWord;
  end
  else if (we == `WriteEnable)
  begin
    hi_o                     <= hi_i;
    lo_o                     <= lo_i;
  end
end
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
