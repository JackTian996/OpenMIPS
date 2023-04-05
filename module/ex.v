// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   ex.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-12
// Description:
//
// ---********************************************************************------
`include "defines.v"
module ex
    (
    input                                        rst_n,
    input                            [`AluOpBus] aluop_i,
    input                           [`AluSelBus] alusel_i,
    input                              [`RegBus] reg1_i,
    input                              [`RegBus] reg2_i,
    input                          [`RegAddrBus] wd_i,
    input                                        wreg_i,
   // branch wr link addr
    input                              [`RegBus] link_address_i,
    input                                        is_in_delayslot_i,
   // hilo reg input
    input                                        mem_whilo_i,
    input                              [`RegBus] mem_hi_i,
    input                              [`RegBus] mem_lo_i,
    input                                        wb_whilo_i,
    input                              [`RegBus] wb_hi_i,
    input                              [`RegBus] wb_lo_i,
    input                              [`RegBus] hi_i,
    input                              [`RegBus] lo_i,
   // wr to regfile
    output reg                         [`RegBus] wdata_o,
    output reg                     [`RegAddrBus] wd_o,
    output reg                                   wreg_o,
   // wr to hilo reg
    output reg                                   whilo_o,
    output reg                         [`RegBus] hi_o,
    output reg                         [`RegBus] lo_o,
   //stallreq
    output reg                                   stallreq,
   //madd maddu msub msubu
    input                        [`DoubleRegBus] hilo_tmp_i,
    input                                  [1:0] cnt_i,
    output reg                   [`DoubleRegBus] hilo_tmp_o,
    output reg                             [1:0] cnt_o,
   //div
    input                        [`DoubleRegBus] div_result_i,
    input                                        div_valid_i,
    output reg                                   signed_div_o,
    output reg                         [`RegBus] div_opdata1_o,
    output reg                         [`RegBus] div_opdata2_o,
    output reg                                   div_start_o
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
reg                                    [`RegBus] logicout;
reg                              [`DoubleRegBus] hilo_tmp1;
reg                                              stallreq_for_madd_msub;
reg                                              stallreq_for_div;
wire                                             signed_mul_flag;
reg                                    [`RegBus] arithmeticres;
wire                                             ov_check_op;
reg                              [`DoubleRegBus] mulres;
wire                                   [`RegBus] opdata1_mult;
wire                                   [`RegBus] opdata2_mult;
wire                             [`DoubleRegBus] hilo_tmp;
wire                                             reg1_lt_reg2;
wire                                   [`RegBus] clz_data_i;
wire                                   [`RegBus] clz_res_o;
wire                                       [5:0] clz_res_tmp;
wire                                   [`RegBus] reg1_i_not;
wire                                             ov_sum;
wire                                   [`RegBus] reg2_i_mux;
wire                                   [`RegBus] result_sum;
reg                                    [`RegBus] shiftres;
reg                                    [`RegBus] moveres;
reg                                    [`RegBus] hi_final;
reg                                    [`RegBus] lo_final;

// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
always @(*)
begin : LOGICOUT_PROC
  if (rst_n == `RstEnable)
    logicout                 = `ZeroWord;
  else
  begin
    case (aluop_i)
      `EXE_OR_OP:
        logicout             = reg1_i | reg2_i;
      `EXE_AND_OP:
        logicout             = reg1_i & reg2_i;
      `EXE_XOR_OP:
        logicout             = reg1_i ^ reg2_i;
      `EXE_NOR_OP:
        logicout             = ~(reg1_i | reg2_i);
      default:
        logicout             = `ZeroWord;
    endcase
  end
end

always @(*)
begin : SHIFTRES_PROC
  if (rst_n == `RstEnable)
    shiftres                 = `ZeroWord;
  else
  begin
    case(aluop_i)
      `EXE_SLL_OP:
        shiftres             = reg2_i << reg1_i[4:0];
      `EXE_SRL_OP:
        shiftres             = reg2_i >> reg1_i[4:0];
      `EXE_SRA_OP:
        shiftres             = ({32{reg2_i[31]}} << (6'd32 - {1'b0,reg1_i[4:0]})) | (reg2_i >> reg1_i[4:0]);
      default:
        shiftres             = `ZeroWord;
    endcase
  end
end

always @(*)
begin : HILO_MUX_PROC
  if (rst_n == `RstEnable)
  begin
    hi_final                 = `ZeroWord;
    lo_final                 = `ZeroWord;
  end
  if (mem_whilo_i == `WriteEnable)
  begin
    hi_final                 = mem_hi_i;
    lo_final                 = mem_lo_i;
  end
  else if (wb_whilo_i == `WriteEnable)
  begin
    hi_final                 = wb_hi_i;
    lo_final                 = wb_lo_i;
  end
  else
  begin
    hi_final                 = hi_i;
    lo_final                 = lo_i;
  end
end

// ***************************************
// Write to HILO Register
// ***************************************
always @(*)
begin : WR_HILO_PROC
  if (rst_n == `RstEnable)
  begin
    whilo_o                  = `WriteDisable;
    hi_o                     = `ZeroWord;
    lo_o                     = `ZeroWord;
  end
  else if ((aluop_i == `EXE_MADD_OP) || (aluop_i == `EXE_MADDU_OP))
  begin
    whilo_o                  = `WriteEnable;
    hi_o                     = hilo_tmp1[63:32];
    lo_o                     = hilo_tmp1[31:0];
  end
  else if ((aluop_i == `EXE_MSUB_OP) || (aluop_i == `EXE_MSUBU_OP))
  begin
    whilo_o                  = `WriteEnable;
    hi_o                     = hilo_tmp1[63:32];
    lo_o                     = hilo_tmp1[31:0];
  end
  else if (aluop_i == `EXE_MTHI_OP)
  begin
    whilo_o                  = `WriteEnable;
    hi_o                     = reg1_i;
    lo_o                     = lo_final;
  end
  else if (aluop_i == `EXE_MTLO_OP)
  begin
    whilo_o                  = `WriteEnable;
    hi_o                     = hi_final;
    lo_o                     = reg1_i;
  end
  else if ((aluop_i == `EXE_MULT_OP) || (aluop_i == `EXE_MULTU_OP))
  begin
    whilo_o                  = `WriteEnable;
    hi_o                     = mulres[63:32];
    lo_o                     = mulres[31:0];
  end
  else if ((aluop_i == `EXE_DIV_OP) || (aluop_i == `EXE_DIVU_OP))
  begin
    whilo_o                  = `WriteEnable;
    hi_o                     = div_result_i[63:32];
    lo_o                     = div_result_i[31:0];
  end
  else
  begin
    whilo_o                  = `WriteDisable;
    hi_o                     = `ZeroWord;
    lo_o                     = `ZeroWord;
  end
end

always @(*)
begin : MOVERES_PROC
  if (rst_n == `RstEnable)
    moveres                  = `ZeroWord;
  else
  begin
    case(aluop_i)
      `EXE_MOVN_OP:
        moveres              = reg1_i;
      `EXE_MOVZ_OP:
        moveres              = reg1_i;
      `EXE_MFHI_OP:
        moveres              = hi_final;
      `EXE_MFLO_OP:
        moveres              = lo_final;
      default:
        moveres              = `ZeroWord;
    endcase
  end
end
// ***************************************
// Arithmetic
// ***************************************

// --------------------> get reg2_i 2's complete code
assign reg2_i_mux            = ((aluop_i == `EXE_SUB_OP)  ||
                                (aluop_i == `EXE_SUBU_OP) ||
                                (aluop_i == `EXE_SLT_OP)) ?
                                (~reg2_i + 1'b1) : reg2_i;

// --------------------> general sum result
assign result_sum            = reg1_i + reg2_i_mux;

// --------------------> overflow check
assign ov_check_op           = (aluop_i == `EXE_ADD_OP) || (aluop_i == `EXE_SUB_OP);
assign ov_sum                = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31]) ||
                               ((reg1_i[31] && reg2_i_mux[31]) && !result_sum[31]);

// --------------------> SLT/SLTU reg1 less than reg2 check
assign reg1_lt_reg2          = (aluop_i == `EXE_SLT_OP) ? ((reg1_i[31] && !reg2_i[31]) ||
                                                           (!reg1_i[31] && !reg2_i[31] && result_sum[31]) ||
                                                           (reg1_i[31] && reg2_i[31] && result_sum[31]))
                                                        : (reg1_i < reg2_i);

// --------------------> not reg1_i
assign reg1_i_not            = ~reg1_i;

// --------------------> CLZ/CLO
assign clz_data_i            = (aluop_i == `EXE_CLZ_OP) ? reg1_i : (~reg1_i);

MIPS_CLZ
#(
    .DATA_WIDTH                        (32                                     ),
    .DATA_WIDTH_LOG2                   (5                                      )
 )
U_MIPS_CLZ
(
    .data_i                            (clz_data_i                             ),
    .res_o                             (clz_res_tmp                            )
 );

assign clz_res_o             = {26'b0,clz_res_tmp};

always @(*)
begin : ARITHMETICRES_PROC
  if (rst_n == `RstEnable)
    arithmeticres            = `ZeroWord;
  else
  begin
    case(aluop_i)
      `EXE_SLT_OP, `EXE_SLTU_OP:
      begin
        arithmeticres        = reg1_lt_reg2;
      end
      `EXE_ADD_OP, `EXE_ADDU_OP, `EXE_SUB_OP, `EXE_SUBU_OP:
      begin
        arithmeticres        = result_sum;
      end
      `EXE_CLZ_OP, `EXE_CLO_OP:
      begin
        arithmeticres        = clz_res_o;
      end
      default
      begin
        arithmeticres        = `ZeroWord;
      end
    endcase
  end
end

// ***************************************
// Multi
// ***************************************
assign signed_mul_flag       = ((aluop_i == `EXE_MUL_OP)  ||
                                (aluop_i == `EXE_MULT_OP) ||
                                (aluop_i == `EXE_MADD_OP) ||
                                (aluop_i == `EXE_MSUB_OP));
assign opdata1_mult          = ((signed_mul_flag == 1'b1) && (reg1_i[31] == 1'b1)) ? (~reg1_i + 1'b1) : reg1_i;
assign opdata2_mult          = ((signed_mul_flag == 1'b1) && (reg2_i[31] == 1'b1)) ? (~reg2_i + 1'b1) : reg2_i;
assign hilo_tmp              = opdata1_mult * opdata2_mult;

always @(*)
begin : MULRES_PROC
  if (rst_n == `RstEnable)
    mulres                   = {`ZeroWord, `ZeroWord};
  else if ((signed_mul_flag == 1'b1) && ((reg1_i[31] ^ reg2_i[31]) == 1'b1))
    mulres                   = ~hilo_tmp + 1'b1;
  else
    mulres                   = hilo_tmp;
end

// ***************************************
// MADD MSUB Multi Cycle Control
// ***************************************
always @(*)
begin : MULTI_MUL_PROC
  if (rst_n == `RstEnable)
  begin
    cnt_o                    = 2'b00;
    hilo_tmp_o               = {`ZeroWord,`ZeroWord};
    stallreq_for_madd_msub   = `NoStop;
    hilo_tmp1                = {`ZeroWord,`ZeroWord};
  end
  case (aluop_i)
    `EXE_MADD_OP, `EXE_MADDU_OP:
    begin
      if (cnt_i == 2'b00)
      begin
        cnt_o                = 2'b01;
        hilo_tmp_o           = mulres;
        stallreq_for_madd_msub = `Stop;
        hilo_tmp1            = {`ZeroWord,`ZeroWord};
      end
      else if (cnt_i == 2'b01)
      begin
        cnt_o                = 2'b10;
        hilo_tmp_o           = {`ZeroWord,`ZeroWord};
        stallreq_for_madd_msub = `NoStop;
        hilo_tmp1            = {hi_final,lo_final} + hilo_tmp_i;
      end
    end
    `EXE_MSUB_OP, `EXE_MSUBU_OP:
    begin
      if (cnt_i == 2'b00)
      begin
        cnt_o                = 2'b01;
        hilo_tmp_o           = ~mulres + 1'b1;
        stallreq_for_madd_msub = `Stop;
        hilo_tmp1            = {`ZeroWord,`ZeroWord};
      end
      else if (cnt_i == 2'b01)
      begin
        cnt_o                = 2'b10;
        hilo_tmp_o           = {`ZeroWord,`ZeroWord};
        stallreq_for_madd_msub = `NoStop;
        hilo_tmp1            = {hi_final,lo_final} + hilo_tmp_i;
      end
    end
    default:
    begin
      cnt_o                  = 2'b00;
      hilo_tmp_o             = {`ZeroWord,`ZeroWord};
      stallreq_for_madd_msub = `NoStop;
      hilo_tmp1              = {`ZeroWord,`ZeroWord};
    end
  endcase
end

// ***************************************
// divide control
// ***************************************
always @(*)
begin : DIVIDE_OUPUT_PROC
  if (rst_n == `RstEnable)
  begin
    signed_div_o             = 1'b0;
    div_opdata1_o            = `ZeroWord;
    div_opdata2_o            = `ZeroWord;
    div_start_o              = 1'b0;
    stallreq_for_div = `NoStop;
  end
  else
  begin
    case (aluop_i)
      `EXE_DIV_OP:
      begin
        signed_div_o         = 1'b1;
        div_opdata1_o        = reg1_i;
        div_opdata2_o        = reg2_i;
        if (div_valid_i == 1'b0)
        begin
          div_start_o        = 1'b1;
          stallreq_for_div = `Stop;
        end
        else
        begin
          div_start_o        = 1'b0;
          stallreq_for_div = `NoStop;
        end
      end
      `EXE_DIVU_OP:
      begin
        signed_div_o         = 1'b0;
        div_opdata1_o        = reg1_i;
        div_opdata2_o        = reg2_i;
        if (div_valid_i == 1'b0)
        begin
          div_start_o        = 1'b1;
          stallreq_for_div = `Stop;
        end
        else
        begin
          div_start_o        = 1'b0;
          stallreq_for_div = `NoStop;
        end
      end
      default:
      begin
        signed_div_o         = 1'b0;
        div_opdata1_o        = `ZeroWord;
        div_opdata2_o        = `ZeroWord;
        div_start_o          = 1'b0;
        stallreq_for_div = `NoStop;
      end
    endcase
  end //if-else
end //always

// ***************************************
// Output Control
// ***************************************
always @(*)
begin : WDATA_MUX_PROC
  wd_o                       = wd_i;
  if ((ov_check_op == 1'b1) && (ov_sum == 1'b1))
    wreg_o                   = `WriteDisable;
  else
    wreg_o                   = wreg_i;

  case (alusel_i)
    `EXE_RES_LOGIC:
      wdata_o                = logicout;
    `EXE_RES_SHIFT:
      wdata_o                = shiftres;
    `EXE_RES_MOVE:
      wdata_o                = moveres;
    `EXE_RES_ARITHMETIC:
      wdata_o                = arithmeticres;
    `EXE_RES_MUL:
      wdata_o                = mulres[`RegBus];
    `EXE_RES_JUMP_BRANCH:
      wdata_o                = link_address_i;
    default:
      wdata_o                = `ZeroWord;
  endcase
end

// --------------------> stallreq
always @(*)
begin : STALLREQ_PROC
  stallreq                   = (stallreq_for_madd_msub | stallreq_for_div);
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
