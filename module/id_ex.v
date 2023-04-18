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
    input                                        id_is_in_delayslot,
    input                              [`RegBus] id_link_address,
    input                                        nxt_is_in_delayslot_i,
    input                              [`RegBus] id_inst,
    //exception
    input                                        flush,
    input                              [`RegBus] id_curr_inst_addr,
    input                                 [31:0] id_excep_type,

    output reg                     [`RegAddrBus] ex_wd,
    output reg                                   ex_wreg,
    output reg                       [`AluOpBus] ex_aluop,
    output reg                      [`AluSelBus] ex_alusel,
    output reg                         [`RegBus] ex_reg1,
    output reg                         [`RegBus] ex_reg2,
    output reg                                   ex_is_in_delayslot,
    output reg                         [`RegBus] ex_link_address,
    output reg                                   is_in_delayslot_o,
    output reg                         [`RegBus] ex_inst,
    //exception
    output reg                         [`RegBus] ex_curr_inst_addr,
    output reg                            [31:0] ex_excep_type
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
    ex_is_in_delayslot       <= `NotInDelaySlot;
    ex_link_address          <= `ZeroWord;
    is_in_delayslot_o        <= `NotInDelaySlot;
    ex_inst                  <= `ZeroWord;
    ex_curr_inst_addr        <= `ZeroWord;
    ex_excep_type            <= `ZeroWord;
  end
  else if (flush == 1'b1)
  begin
    ex_wd                    <= `NOPRegAddr;
    ex_wreg                  <= `WriteDisable;
    ex_aluop                 <= `EXE_NOP_OP;
    ex_alusel                <= `EXE_RES_NOP;
    ex_reg1                  <= `ZeroWord;
    ex_reg2                  <= `ZeroWord;
    ex_is_in_delayslot       <= `NotInDelaySlot;
    ex_link_address          <= `ZeroWord;
    is_in_delayslot_o        <= `NotInDelaySlot;
    ex_inst                  <= `ZeroWord;
    ex_curr_inst_addr        <= `ZeroWord;
    ex_excep_type            <= `ZeroWord;
  end
  else if ((stall[2] == `Stop) && (stall[3] == `NoStop))
  begin
    ex_wd                    <= `NOPRegAddr;
    ex_wreg                  <= `WriteDisable;
    ex_aluop                 <= `EXE_NOP_OP;
    ex_alusel                <= `EXE_RES_NOP;
    ex_reg1                  <= `ZeroWord;
    ex_reg2                  <= `ZeroWord;
    ex_is_in_delayslot       <= `NotInDelaySlot;
    ex_link_address          <= `ZeroWord;
    //is_in_delayslot_o        <= `NotInDelaySlot;  //keep when stall
    ex_inst                  <= `ZeroWord;
    ex_curr_inst_addr        <= `ZeroWord;
    ex_excep_type            <= `ZeroWord;
  end
  else if (stall[2] == `NoStop)
  begin
    ex_wd                    <= id_wd;
    ex_wreg                  <= id_wreg;
    ex_aluop                 <= id_aluop;
    ex_alusel                <= id_alusel;
    ex_reg1                  <= id_reg1;
    ex_reg2                  <= id_reg2;
    ex_is_in_delayslot       <= id_is_in_delayslot;
    ex_link_address          <= id_link_address;
    is_in_delayslot_o        <= nxt_is_in_delayslot_i;
    ex_inst                  <= id_inst;
    ex_curr_inst_addr        <= id_curr_inst_addr;
    ex_excep_type            <= id_excep_type;
  end
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
