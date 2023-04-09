// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   ex_mem.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-13
// Description:
//
// ---********************************************************************------
`include "defines.v"
module ex_mem
    (
    input                                        clk,
    input                                        rst_n,
    input                              [`RegBus] ex_wdata,
    input                          [`RegAddrBus] ex_wd,
    input                                        ex_wreg,
    input                                        ex_whilo,
    input                              [`RegBus] ex_hi,
    input                              [`RegBus] ex_lo,
    input                                  [5:0] stall,
    input                        [`DoubleRegBus] hilo_i,
    input                                  [1:0] cnt_i,
    input                              [`RegBus] ex_mem_addr,
    input                            [`AluOpBus] ex_aluop,
    input                              [`RegBus] ex_reg2,

    output reg                         [`RegBus] mem_wdata,
    output reg                     [`RegAddrBus] mem_wd,
    output reg                                   mem_wreg,
    output reg                                   mem_whilo,
    output reg                         [`RegBus] mem_hi,
    output reg                         [`RegBus] mem_lo,
    output reg                   [`DoubleRegBus] hilo_o,
    output reg                             [1:0] cnt_o,
    output reg                         [`RegBus] mem_mem_addr,
    output reg                       [`AluOpBus] mem_aluop,
    output reg                         [`RegBus] mem_reg2
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
    mem_wdata                <= `ZeroWord;
    mem_wd                   <= `NOPRegAddr;
    mem_wreg                 <= `WriteDisable;
    mem_whilo                <= `WriteDisable;
    mem_hi                   <= `ZeroWord;
    mem_lo                   <= `ZeroWord;
    hilo_o                   <= {`ZeroWord,`ZeroWord};
    cnt_o                    <= 2'b00;
    mem_mem_addr             <= `ZeroWord;
    mem_aluop                <= `EXE_NOP_OP;
    mem_reg2                 <= `ZeroWord;
  end
  else if ((stall[3] == `Stop) && (stall[4] == `NoStop))
  begin
    mem_wdata                <= `ZeroWord;
    mem_wd                   <= `NOPRegAddr;
    mem_wreg                 <= `WriteDisable;
    mem_whilo                <= `WriteDisable;
    mem_hi                   <= `ZeroWord;
    mem_lo                   <= `ZeroWord;
    hilo_o                   <= hilo_i;
    cnt_o                    <= cnt_i;
    mem_mem_addr             <= `ZeroWord;
    mem_aluop                <= `EXE_NOP_OP;
    mem_reg2                 <= `ZeroWord;
  end
  else if (stall[3] == `NoStop)
  begin
    mem_wdata                <= ex_wdata;
    mem_wd                   <= ex_wd;
    mem_wreg                 <= ex_wreg;
    mem_whilo                <= ex_whilo;
    mem_hi                   <= ex_hi;
    mem_lo                   <= ex_lo;
    hilo_o                   <= {`ZeroWord,`ZeroWord};
    cnt_o                    <= 2'b00;
    mem_mem_addr             <= ex_mem_addr;
    mem_aluop                <= ex_aluop;
    mem_reg2                 <= ex_reg2;

  end
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
