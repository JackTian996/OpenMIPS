// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   id_ex.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-12
// Description:
//
// ---********************************************************************------
`include "defines.v"
module id_ex
    (
    input                                        clk,
    input                                        rst_n,
    input                          [`RegAddrBus] id_wd,
    input                                        id_wreg,
    input                            [`AluOpBus] id_aluop,
    input                           [`AluSelBus] id_alusel,
    input                              [`RegBus] id_reg1,
    input                              [`RegBus] id_reg2,
    input                                  [5:0] stall,

    output reg                     [`RegAddrBus] ex_wd,
    output reg                                   ex_wreg,
    output reg                       [`AluOpBus] ex_aluop,
    output reg                      [`AluSelBus] ex_alusel,
    output reg                         [`RegBus] ex_reg1,
    output reg                         [`RegBus] ex_reg2
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
    ex_wd                    <= `NOPRegAddr;
    ex_wreg                  <= `WriteDisable;
    ex_aluop                 <= `EXE_NOP_OP;
    ex_alusel                <= `EXE_RES_NOP;
    ex_reg1                  <= `ZeroWord;
    ex_reg2                  <= `ZeroWord;
  end
  else if ((stall[2] == `Stop) && (stall[3] == `NoStop))
  begin
    ex_wd                    <= `NOPRegAddr;
    ex_wreg                  <= `WriteDisable;
    ex_aluop                 <= `EXE_NOP_OP;
    ex_alusel                <= `EXE_RES_NOP;
    ex_reg1                  <= `ZeroWord;
    ex_reg2                  <= `ZeroWord;
  end
  else if (stall[2] == `NoStop)
  begin
    ex_wd                    <= id_wd;
    ex_wreg                  <= id_wreg;
    ex_aluop                 <= id_aluop;
    ex_alusel                <= id_alusel;
    ex_reg1                  <= id_reg1;
    ex_reg2                  <= id_reg2;
  end
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
