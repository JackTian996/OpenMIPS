// ---********************************************************************------
// Copyright 2020-2030 (c) , Inc. All rights reserved.
// Module Name:   stall_ctrl.v
// Author     :   tianshuo@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-29
// Description:
//
// ---********************************************************************------
`include "defines.v"
module stall_ctrl
    (
    input                                        rst_n,
    input                                        stallreq_from_id,
    input                                        stallreq_from_ex,
    // wishbone if
    input                                        stallreq_from_if,
    input                                        stallreq_from_mem,
    output reg                             [5:0] stall,
    // excetion
    input                                 [31:0] excep_type_i,
    input                              [`RegBus] cp0_epc_i,
    output reg                                   flush,
    output reg                         [`RegBus] excep_vector
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
// stall[0] : pc
// stall[1] : if_id
// stall[2] : id_ex
// stall[3] : ex_mem
// stall[4] : mem_wb
// stall[5] : reserved

always @(*)
begin : STALL_PROC
  if (rst_n == `RstEnable)
    stall                    = {6{1'b0}};
  else if (stallreq_from_mem == `Stop)
    stall                    = 6'b011111;
  else if (stallreq_from_ex == `Stop)
    stall                    = 6'b001111;
  else if (stallreq_from_id == `Stop)
    stall                    = 6'b000111;
  else if (stallreq_from_if == `Stop)
    // keep order branch inst and delayslot inst
    stall                    = 6'b000111;
  else
    stall                    = {6{1'b0}};
end

always @(*)
begin : FLUSH_PROC
  if (rst_n == `RstEnable)
    flush                    = {1{1'b0}};
  else if ((|excep_type_i) == 1'b1)
    flush                    = 1'b1;
  else
    flush                    = 1'b0;
end

always @(*)
begin : EXCEP_VECTOR_PROC
  if (rst_n == `RstEnable)
    excep_vector             = {32{1'b0}};
  else
  begin
    case (excep_type_i)
      32'h1: excep_vector    = 32'h20;
      32'h8: excep_vector    = 32'h40;
      32'ha: excep_vector    = 32'h40;
      32'hd: excep_vector    = 32'h40;
      32'hc: excep_vector    = 32'h40;
      32'he: excep_vector    = cp0_epc_i;
      default: excep_vector  = 32'h40;
    endcase
  end
end


// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
