// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   inst_rom.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-14
// Description:
//
// ---********************************************************************------
`include "defines.v"
module inst_rom
    (
    input                                        ce,
    input                         [`InstAddrBus] addr,
    output reg                        [`InstBus] inst
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
reg                                   [`InstBus] inst_mem[`InstMemNum-1:0];
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
integer n;

initial
  begin
    $readmemh ("/home/ICer/ic_prjs/open_mips/AsmTest/inst_rom.data", inst_mem);
    for(n=0;n<4;n=n+1)
      $display("%h",inst_mem[n]);
  end

always @(*)
begin : INST_PROC
  if (ce == `ChipDisable)
    inst                     = `ZeroWord;
  else
    inst                     = inst_mem[addr[`InstMemNumLog2+1:2]];
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
