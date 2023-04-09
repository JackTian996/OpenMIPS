// ---********************************************************************------
// Copyright 2020-2030 (c) , Inc. All rights reserved.
// Module Name:   data_ram.v
// Author     :   tianshuo@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-04-06
// Description:
//
// ---********************************************************************------
module data_ram
    (
    input                                        clk,
    input                                        rst_n,
    input                                        ce,
    input                                        we,
    input                         [`DataAddrBus] addr,
    input                                  [3:0] sel,
    input                             [`DataBus] data_i,
    output reg                        [`DataBus] data_o
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
reg                                 [`ByteWidth] data_mem0[`DataMemNum-1:0];
reg                                 [`ByteWidth] data_mem1[`DataMemNum-1:0];
reg                                 [`ByteWidth] data_mem2[`DataMemNum-1:0];
reg                                 [`ByteWidth] data_mem3[`DataMemNum-1:0];
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
always @(posedge clk)
begin : DATA_MEM_PROC
  if ((ce == `ChipEnable) && (we == `WriteEnable))
  begin
    if (sel[0] == 1'b1)
      data_mem0[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];
    if (sel[1] == 1'b1)
      data_mem1[addr[`DataMemNumLog2+1:2]] <= data_i[15:8];
    if (sel[2] == 1'b1)
      data_mem2[addr[`DataMemNumLog2+1:2]] <= data_i[23:16];
    if (sel[3] == 1'b1)
      data_mem3[addr[`DataMemNumLog2+1:2]] <= data_i[31:24];
  end
end

always @(*)
begin : DATA_OUT_PROC
  if ((ce == `ChipEnable) && (we == `WriteDisable))
    data_o                   = {data_mem3[addr[`DataMemNumLog2+1:2]],
                                data_mem2[addr[`DataMemNumLog2+1:2]],
                                data_mem1[addr[`DataMemNumLog2+1:2]],
                                data_mem0[addr[`DataMemNumLog2+1:2]]};
  else
    data_o                   = `ZeroWord;
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
