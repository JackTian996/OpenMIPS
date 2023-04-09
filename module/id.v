// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   id.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-12
// Description:
//
// ---********************************************************************------
`include "defines.v"
module id
    (
    input                                        rst_n,
    // From if
    input                         [`InstAddrBus] pc_i,
    input                             [`InstBus] inst_i,
    output                            [`InstBus] inst_o,
    input                                        rom_ce_dff_i,
    // Read Regfile
    input                              [`RegBus] reg1_data_i,
    input                              [`RegBus] reg2_data_i,
    output reg                                   reg1_read_o,
    output reg                                   reg2_read_o,
    output reg                     [`RegAddrBus] reg1_addr_o,
    output reg                     [`RegAddrBus] reg2_addr_o,
    // Data Forward
      // EX Stage
    input                          [`RegAddrBus] ex_wd_i,
    input                              [`RegBus] ex_wdata_i,
    input                                        ex_wreg_i,
      // MEM Stage
    input                          [`RegAddrBus] mem_wd_i,
    input                              [`RegBus] mem_wdata_i,
    input                                        mem_wreg_i,
    // Output next stage
      // Write Regfile
    output reg                     [`RegAddrBus] wd_o,
    output reg                                   wreg_o,

    output reg                       [`AluOpBus] aluop_o,
    output reg                      [`AluSelBus] alusel_o,
    output reg                         [`RegBus] reg1_o,
    output reg                         [`RegBus] reg2_o,
      // Branch
    output reg                                   branch_flag_o,
    output reg                         [`RegBus] branch_target_address_o,
    output reg                         [`RegBus] link_address_o,
    output reg                                   is_in_delayslot_o,
    output reg                                   nxt_is_in_delayslot_o,
    input                                        is_in_delayslot_i,
    //slove read after load harzard
    input                            [`AluOpBus] ex_aluop_i,
    //stall req
    output                                       stallreq
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
wire                                       [5:0] op;
wire                                             pre_inst_is_load;
wire                                             stallreq_for_reg1_loadrelate;
wire                                             stallreq_for_reg2_loadrelate;
wire                               [`RegBus] branch_addr;
wire                               [`RegBus] pc_plus_4;
wire                           [`RegBus]                  pc_plus_8;
wire                               [`RegBus] imm_sll2_signedext;
wire                               [`RegBus] jump_addr;
reg                                    [`RegBus] imm;
wire                                       [4:0] rs;
wire                                       [4:0] rt;
wire                                       [4:0] rd;
wire                                       [4:0] shamt;
wire                                       [5:0] funct;
wire                                       [4:0] op2;
wire                                       [5:0] op3;
wire                                       [4:0] op4;
reg                                              instvalid;
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
assign op                    = inst_i[31:26];     // op
assign op2                   = inst_i[10:6];
assign op3                   = inst_i[5:0];       // fucntion
assign op4                   = inst_i[20:16];
assign rs                    = inst_i[25:21];
assign rt                    = inst_i[20:16];
assign rd                    = inst_i[15:11];
assign shamt                 = inst_i[10:6];
assign funct                 = inst_i[5:0];

assign pc_plus_4             = pc_i + 4;
assign pc_plus_8             = pc_i + 8;
assign imm_sll2_signedext    = {{14{inst_i[15]}},inst_i[15:0],2'b00};
assign jump_addr             = {pc_plus_4[31:28],inst_i[25:0],2'b00};
assign branch_addr           = pc_plus_4 + imm_sll2_signedext;

assign inst_o                = inst_i;

always @(*)
begin
  if (rom_ce_dff_i == `ChipDisable)
  begin
    aluop_o                  = `EXE_NOP_OP;
    alusel_o                 = `EXE_RES_NOP;
    wd_o                     = `NOPRegAddr;
    wreg_o                   = `WriteDisable;
    instvalid                = `InstValid;
    reg1_read_o              = `ReadDisable;
    reg2_read_o              = `ReadDisable;
    reg1_addr_o              = `NOPRegAddr;
    reg2_addr_o              = `NOPRegAddr;
    imm                      = `ZeroWord;
    link_address_o           = `ZeroWord;
    nxt_is_in_delayslot_o    = `NotInDelaySlot;
    branch_flag_o            = `NotBranch;
    branch_target_address_o  = `ZeroWord;
  end
  else
  begin
    aluop_o                  = `EXE_NOP_OP;
    alusel_o                 = `EXE_RES_NOP;
    wd_o                     = rd;
    wreg_o                   = `WriteDisable;
    instvalid                = `InstInvalid;
    reg1_read_o              = `ReadDisable;
    reg2_read_o              = `ReadDisable;
    reg1_addr_o              = rs;
    reg2_addr_o              = rt;
    imm                      = `ZeroWord;
    link_address_o           = `ZeroWord;
    nxt_is_in_delayslot_o    = `NotInDelaySlot;
    branch_flag_o            = `NotBranch;
    branch_target_address_o  = `ZeroWord;
    case(op)
      `EXE_SPECIAL_INST:
      begin
        case(op2)
          5'b00000:
          begin
            case(op3)
              `EXE_AND:
              begin
                aluop_o      = `EXE_AND_OP;
                alusel_o     = `EXE_RES_LOGIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_OR:
              begin
                aluop_o      = `EXE_OR_OP;
                alusel_o     = `EXE_RES_LOGIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_XOR:
              begin
                aluop_o      = `EXE_XOR_OP;
                alusel_o     = `EXE_RES_LOGIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_NOR:
              begin
                aluop_o      = `EXE_NOR_OP;
                alusel_o     = `EXE_RES_LOGIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_SLLV:
              begin
                aluop_o      = `EXE_SLL_OP;
                alusel_o     = `EXE_RES_SHIFT;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_SRLV:
              begin
                aluop_o      = `EXE_SRL_OP;
                alusel_o     = `EXE_RES_SHIFT;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_SRAV:
              begin
                aluop_o      = `EXE_SRA_OP;
                alusel_o     = `EXE_RES_SHIFT;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_SYNC:
              begin
                aluop_o      = `EXE_NOP_OP;
                alusel_o     = `EXE_RES_NOP;
                wd_o         = `ZeroWord;
                wreg_o       = `WriteDisable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadDisable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_MOVN:
              begin
                aluop_o      = `EXE_MOVN_OP;
                alusel_o     = `EXE_RES_MOVE;
                wd_o         = rd;
                wreg_o       = (reg2_o == `ZeroWord) ? `WriteDisable : `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_MOVZ:
              begin
                aluop_o      = `EXE_MOVZ_OP;
                alusel_o     = `EXE_RES_MOVE;
                wd_o         = rd;
                wreg_o       = (reg2_o == `ZeroWord) ? `WriteEnable: `WriteDisable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_MFHI:
              begin
                aluop_o      = `EXE_MFHI_OP;
                alusel_o     = `EXE_RES_MOVE;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadDisable;
                reg2_read_o  = `ReadDisable;
              end
              `EXE_MFLO:
              begin
                aluop_o      = `EXE_MFLO_OP;
                alusel_o     = `EXE_RES_MOVE;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadDisable;
                reg2_read_o  = `ReadDisable;
              end
              `EXE_MTHI:
              begin
                aluop_o      = `EXE_MTHI_OP;
                //alusel_o   = `EXE_RES_MOVE;
                wd_o         = `ZeroWord;
                //wreg_o     = `WriteDisable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadDisable;
              end
              `EXE_MTLO:
              begin
                aluop_o      = `EXE_MTLO_OP;
                //alusel_o   = `EXE_RES_MOVE;
                wd_o         = `ZeroWord;
                //wreg_o     = `WriteDisable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadDisable;
              end
              `EXE_SLT:
              begin
                aluop_o      = `EXE_SLT_OP;   // signed compare
                alusel_o     = `EXE_RES_ARITHMETIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_SLTU:
              begin
                aluop_o      = `EXE_SLTU_OP;  // unsigned compare
                alusel_o     = `EXE_RES_ARITHMETIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_ADD:
              begin
                aluop_o      = `EXE_ADD_OP;  // overflow check
                alusel_o     = `EXE_RES_ARITHMETIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_ADDU:
              begin
                aluop_o      = `EXE_ADDU_OP; // no overflow check
                alusel_o     = `EXE_RES_ARITHMETIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_SUB:
              begin
                aluop_o      = `EXE_SUB_OP; // overflow check
                alusel_o     = `EXE_RES_ARITHMETIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_SUBU:
              begin
                aluop_o      = `EXE_SUBU_OP; // no overflow check
                alusel_o     = `EXE_RES_ARITHMETIC;
                wd_o         = rd;
                wreg_o       = `WriteEnable;
                instvalid    = `InstValid;
                reg1_read_o  = `ReadEnable;
                reg2_read_o  = `ReadEnable;
              end
              `EXE_MULT:
              begin
               aluop_o      = `EXE_MULT_OP; // signed multip
               wreg_o        = `WriteDisable;
               instvalid     = `InstValid;
               reg1_read_o   = `ReadEnable;
               reg2_read_o   = `ReadEnable;
              end
              `EXE_MULTU:
              begin
               aluop_o      = `EXE_MULTU_OP; // unsigned multip
               wreg_o        = `WriteDisable;
               instvalid     = `InstValid;
               reg1_read_o   = `ReadEnable;
               reg2_read_o   = `ReadEnable;
              end
              `EXE_DIV:
              begin
               aluop_o       = `EXE_DIV_OP;
               wreg_o        = `WriteDisable;
               instvalid     = `InstValid;
               reg1_read_o   = `ReadEnable;
               reg2_read_o   = `ReadEnable;
              end
              `EXE_DIVU:
              begin
               aluop_o       = `EXE_DIVU_OP;
               wreg_o        = `WriteDisable;
               instvalid     = `InstValid;
               reg1_read_o   = `ReadEnable;
               reg2_read_o   = `ReadEnable;
              end
              `EXE_JR:
              begin
               aluop_o       = `EXE_JR_OP;
               alusel_o      = `EXE_RES_JUMP_BRANCH;
               wreg_o        = `WriteDisable;
               instvalid     = `InstValid;
               reg1_read_o   = `ReadEnable;
               reg2_read_o   = `ReadDisable;
               link_address_o           = `ZeroWord;
               nxt_is_in_delayslot_o    = `InDelaySlot;
               branch_flag_o            = `Branch;
               branch_target_address_o  = reg1_o;
              end
              `EXE_JALR:
              begin
               aluop_o       = `EXE_JALR_OP;
               alusel_o      = `EXE_RES_JUMP_BRANCH;
               wreg_o        = `WriteEnable;
               wd_o          = rd;
               instvalid     = `InstValid;
               reg1_read_o   = `ReadEnable;
               reg2_read_o   = `ReadDisable;
               link_address_o           = pc_plus_8;
               nxt_is_in_delayslot_o    = `InDelaySlot;
               branch_flag_o            = `Branch;
               branch_target_address_o  = reg1_o;
              end
              default:
              begin
              end
            endcase
          end
        default :
        begin
        end
        endcase
      end
      `EXE_ORI:
      begin
        aluop_o              = `EXE_OR_OP;
        alusel_o             = `EXE_RES_LOGIC;
        wd_o                 = rt;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadEnable;
        reg2_read_o          = `ReadDisable;
        imm                  = {16'h0,inst_i[15:0]};
      end
      `EXE_ANDI:
      begin
        aluop_o              = `EXE_AND_OP;
        alusel_o             = `EXE_RES_LOGIC;
        wd_o                 = rt;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadEnable;
        reg2_read_o          = `ReadDisable;
        imm                  = {16'h0,inst_i[15:0]};
      end
      `EXE_XORI:
      begin
        aluop_o              = `EXE_XOR_OP;
        alusel_o             = `EXE_RES_LOGIC;
        wd_o                 = rt;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadEnable;
        reg2_read_o          = `ReadDisable;
        imm                  = {16'h0,inst_i[15:0]};
      end
      `EXE_LUI:
      begin
        aluop_o              = `EXE_OR_OP;
        alusel_o             = `EXE_RES_LOGIC;
        wd_o                 = rt;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadEnable;
        reg2_read_o          = `ReadDisable;
        imm                  = {inst_i[15:0],16'h0};
      end
      `EXE_PREF:
      begin
        aluop_o              = `EXE_NOP_OP;
        alusel_o             = `EXE_RES_NOP;
        wd_o                 = `ZeroWord;
        wreg_o               = `WriteDisable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadDisable;
        reg2_read_o          = `ReadDisable;
      end
      `EXE_SLTI:
      begin
        aluop_o              = `EXE_SLT_OP;   // same with SLT
        alusel_o             = `EXE_RES_ARITHMETIC;
        wd_o                 = rt;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadEnable;
        reg2_read_o          = `ReadDisable;
        imm                  = {{16{inst_i[15]}},inst_i[15:0]};
      end
      `EXE_SLTIU:
      begin
        aluop_o              = `EXE_SLTU_OP;  //same with SLTU
        alusel_o             = `EXE_RES_ARITHMETIC;
        wd_o                 = rt;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadEnable;
        reg2_read_o          = `ReadDisable;
        imm                  = {{16{inst_i[15]}}, inst_i[15:0]};
      end
      `EXE_ADDI:
      begin
        aluop_o              = `EXE_ADD_OP;         //same with ADD
        alusel_o             = `EXE_RES_ARITHMETIC;
        wd_o                 = rt;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadEnable;
        reg2_read_o          = `ReadDisable;
        imm                  = {{16{inst_i[15]}}, inst_i[15:0]};
      end
      `EXE_ADDIU:
      begin
        aluop_o              = `EXE_ADDU_OP;        //same with ADDU
        alusel_o             = `EXE_RES_ARITHMETIC;
        wd_o                 = rt;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadEnable;
        reg2_read_o          = `ReadDisable;
        imm                  = {{16{inst_i[15]}}, inst_i[15:0]};
      end
      `EXE_J:
      begin
        aluop_o       = `EXE_J_OP;
        alusel_o      = `EXE_RES_JUMP_BRANCH;
        wreg_o        = `WriteDisable;
        wd_o          = rd;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadDisable;
        reg2_read_o   = `ReadDisable;
        link_address_o           = `ZeroWord;
        nxt_is_in_delayslot_o    = `InDelaySlot;
        branch_flag_o            = `Branch;
        branch_target_address_o  = jump_addr;
      end
      `EXE_JAL:
      begin
        aluop_o       = `EXE_JAL_OP;
        alusel_o      = `EXE_RES_JUMP_BRANCH;
        wreg_o        = `WriteEnable;
        wd_o          = 5'b11111;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadDisable;
        reg2_read_o   = `ReadDisable;
        link_address_o           = pc_plus_8;
        nxt_is_in_delayslot_o    = `InDelaySlot;
        branch_flag_o            = `Branch;
        branch_target_address_o  = jump_addr;
      end
      `EXE_BEQ:
      begin
        aluop_o       = `EXE_BEQ_OP;
        alusel_o      = `EXE_RES_JUMP_BRANCH;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
        if (reg1_o == reg2_o)
        begin
          nxt_is_in_delayslot_o    = `InDelaySlot;
          branch_flag_o            = `Branch;
          branch_target_address_o  = branch_addr;
        end
      end
      `EXE_BGTZ:
      begin
        aluop_o       = `EXE_BGTZ_OP;
        alusel_o      = `EXE_RES_JUMP_BRANCH;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadDisable;
        if ((reg1_o[31] == 1'b0) && (reg1_o != `ZeroWord))
        begin
          nxt_is_in_delayslot_o    = `InDelaySlot;
          branch_flag_o            = `Branch;
          branch_target_address_o  = branch_addr;
        end
      end
      `EXE_BLEZ:
      begin
        aluop_o       = `EXE_BLEZ_OP;
        alusel_o      = `EXE_RES_JUMP_BRANCH;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadDisable;
        if ((reg1_o[31] == 1'b1) || (reg1_o == `ZeroWord))
        begin
          nxt_is_in_delayslot_o    = `InDelaySlot;
          branch_flag_o            = `Branch;
          branch_target_address_o  = branch_addr;
        end
      end
      `EXE_BNE:
      begin
        aluop_o       = `EXE_BNE_OP;
        alusel_o      = `EXE_RES_JUMP_BRANCH;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
        if (reg1_o != reg2_o)
        begin
          nxt_is_in_delayslot_o    = `InDelaySlot;
          branch_flag_o            = `Branch;
          branch_target_address_o  = branch_addr;
        end
      end
      `EXE_LB:
      begin
        aluop_o       = `EXE_LB_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteEnable;
        wd_o          = rt;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadDisable;
      end
      `EXE_LBU:
      begin
        aluop_o       = `EXE_LBU_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteEnable;
        wd_o          = rt;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadDisable;
      end
      `EXE_LH:
      begin
        aluop_o       = `EXE_LH_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteEnable;
        wd_o          = rt;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadDisable;
      end
      `EXE_LHU:
      begin
        aluop_o       = `EXE_LHU_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteEnable;
        wd_o          = rt;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadDisable;
      end
      `EXE_LW:
      begin
        aluop_o       = `EXE_LW_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteEnable;
        wd_o          = rt;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadDisable;
      end
      `EXE_LWL:
      begin
        aluop_o       = `EXE_LWL_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteEnable;
        wd_o          = rt;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
      end
      `EXE_LWR:
      begin
        aluop_o       = `EXE_LWR_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteEnable;
        wd_o          = rt;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
      end
      `EXE_SB:
      begin
        aluop_o       = `EXE_SB_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteDisable;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
      end
      `EXE_SH:
      begin
        aluop_o       = `EXE_SH_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteDisable;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
      end
      `EXE_SW:
      begin
        aluop_o       = `EXE_SW_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteDisable;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
      end
      `EXE_SWL:
      begin
        aluop_o       = `EXE_SWL_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteDisable;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
      end
      `EXE_SWR:
      begin
        aluop_o       = `EXE_SWR_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteDisable;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
      end
      `EXE_LL:  //same with LW
      begin
        aluop_o       = `EXE_LL_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteEnable;
        wd_o          = rt;
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadDisable;
      end
      `EXE_SC:  //same with SW
      begin
        aluop_o       = `EXE_SC_OP;
        alusel_o      = `EXE_RES_LOAD_STORE;
        wreg_o        = `WriteEnable;
        wd_o          = rt; //success write 1, other write 0
        instvalid     = `InstValid;
        reg1_read_o   = `ReadEnable;
        reg2_read_o   = `ReadEnable;
      end
      `EXE_REGIMM_INST:
      begin
        case(op4)
          `EXE_BLTZ:
          begin
            aluop_o       = `EXE_BLTZ_OP;
            alusel_o      = `EXE_RES_JUMP_BRANCH;
            instvalid     = `InstValid;
            reg1_read_o   = `ReadEnable;
            reg2_read_o   = `ReadDisable;
            if (reg1_o[31] == 1'b1)
            begin
              nxt_is_in_delayslot_o    = `InDelaySlot;
              branch_flag_o            = `Branch;
              branch_target_address_o  = branch_addr;
            end
          end
          `EXE_BGEZ:
          begin
            aluop_o       = `EXE_BGEZ_OP;
            alusel_o      = `EXE_RES_JUMP_BRANCH;
            instvalid     = `InstValid;
            reg1_read_o   = `ReadEnable;
            reg2_read_o   = `ReadDisable;
            if (reg1_o[31] == 1'b0)
            begin
              nxt_is_in_delayslot_o    = `InDelaySlot;
              branch_flag_o            = `Branch;
              branch_target_address_o  = branch_addr;
            end
          end
          `EXE_BLTZAL:
          begin
            aluop_o       = `EXE_BLTZAL_OP;
            alusel_o      = `EXE_RES_JUMP_BRANCH;
            instvalid     = `InstValid;
            reg1_read_o   = `ReadEnable;
            reg2_read_o   = `ReadDisable;
            wreg_o        = `WriteEnable;
            wd_o          = 5'b11111;
            link_address_o = pc_plus_8;
            if (reg1_o[31] == 1'b1)
            begin
              nxt_is_in_delayslot_o    = `InDelaySlot;
              branch_flag_o            = `Branch;
              branch_target_address_o  = branch_addr;
            end
          end
          `EXE_BGEZAL:
          begin
            aluop_o       = `EXE_BGEZAL_OP;
            alusel_o      = `EXE_RES_JUMP_BRANCH;
            instvalid     = `InstValid;
            reg1_read_o   = `ReadEnable;
            reg2_read_o   = `ReadDisable;
            wreg_o        = `WriteEnable;
            wd_o          = 5'b11111;
            link_address_o = pc_plus_8;
            if (reg1_o[31] == 1'b0)
            begin
              nxt_is_in_delayslot_o    = `InDelaySlot;
              branch_flag_o            = `Branch;
              branch_target_address_o  = branch_addr;
            end
          end
          default:
          begin
          end
        endcase
      end
      `EXE_SPECIAL2_INST:
      begin
        case(op3)
          `EXE_CLZ:
          begin
            aluop_o          = `EXE_CLZ_OP;
            alusel_o         = `EXE_RES_ARITHMETIC;
            wd_o             = rd;
            wreg_o           = `WriteEnable;
            instvalid        = `InstValid;
            reg1_read_o      = `ReadEnable;
            reg2_read_o      = `ReadDisable;
          end
          `EXE_CLO:
          begin
            aluop_o          = `EXE_CLO_OP;
            alusel_o         = `EXE_RES_ARITHMETIC;
            wd_o             = rd;
            wreg_o           = `WriteEnable;
            instvalid        = `InstValid;
            reg1_read_o      = `ReadEnable;
            reg2_read_o      = `ReadDisable;
          end
          `EXE_MUL:
          begin
            aluop_o          = `EXE_MUL_OP; // signed multip
            alusel_o         = `EXE_RES_MUL;
            wd_o             = rd;
            wreg_o           = `WriteEnable;
            instvalid        = `InstValid;
            reg1_read_o      = `ReadEnable;
            reg2_read_o      = `ReadEnable;
          end
          `EXE_MADD:
          begin
            aluop_o          = `EXE_MADD_OP;
            alusel_o         = `EXE_RES_MUL;
            wreg_o           = `WriteDisable;
            instvalid        = `InstValid;
            reg1_read_o      = `ReadEnable;
            reg2_read_o      = `ReadEnable;
          end
          `EXE_MADDU:
          begin
            aluop_o          = `EXE_MADDU_OP;
            alusel_o         = `EXE_RES_MUL;
            wreg_o           = `WriteDisable;
            instvalid        = `InstValid;
            reg1_read_o      = `ReadEnable;
            reg2_read_o      = `ReadEnable;
          end
          `EXE_MSUB:
          begin
            aluop_o          = `EXE_MSUB_OP;
            alusel_o         = `EXE_RES_MUL;
            wreg_o           = `WriteDisable;
            instvalid        = `InstValid;
            reg1_read_o      = `ReadEnable;
            reg2_read_o      = `ReadEnable;
          end
          `EXE_MSUBU:
          begin
            aluop_o          = `EXE_MSUBU_OP;
            alusel_o         = `EXE_RES_MUL;
            wreg_o           = `WriteDisable;
            instvalid        = `InstValid;
            reg1_read_o      = `ReadEnable;
            reg2_read_o      = `ReadEnable;
          end
          default:
          begin
          end
        endcase
      end
      default:
      begin
      end
    endcase
    if (inst_i[31:21] == 11'b0)
    begin
      if (op3 == `EXE_SLL)
      begin
        aluop_o              = `EXE_SLL_OP;
        alusel_o             = `EXE_RES_SHIFT;
        wd_o                 = rd;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadDisable;
        reg2_read_o          = `ReadEnable;
        imm[4:0]             = inst_i[10:6];
      end
      else if (op3 == `EXE_SRL)
      begin
        aluop_o              = `EXE_SRL_OP;
        alusel_o             = `EXE_RES_SHIFT;
        wd_o                 = rd;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadDisable;
        reg2_read_o          = `ReadEnable;
        imm[4:0]             = inst_i[10:6];
      end
      else if (op3 == `EXE_SRA)
      begin
        aluop_o              = `EXE_SRA_OP;
        alusel_o             = `EXE_RES_SHIFT;
        wd_o                 = rd;
        wreg_o               = `WriteEnable;
        instvalid            = `InstValid;
        reg1_read_o          = `ReadDisable;
        reg2_read_o          = `ReadEnable;
        imm[4:0]             = inst_i[10:6];
      end
    end
  end //if
end //always

always @(*)
begin : REG1_O_PROC
  if (rst_n == `RstEnable)
    reg1_o                   = `ZeroWord;
  else if ((reg1_read_o == `ReadEnable) && (ex_wreg_i == `WriteEnable) && (ex_wd_i == rs))
    reg1_o                   = ex_wdata_i;
  else if ((reg1_read_o == `ReadEnable) && (mem_wreg_i == `WriteEnable) && (mem_wd_i == rs))
    reg1_o                   = mem_wdata_i;
  else if (reg1_read_o == `ReadEnable)
    reg1_o                   = reg1_data_i;
  else if (reg1_read_o == `ReadDisable)
    reg1_o                   = imm;
  else
    reg1_o                   = `ZeroWord;
end

always @(*)
begin : REG2_O_PROC
  if (rst_n == `RstEnable)
    reg2_o                   = `ZeroWord;
  else if ((reg2_read_o == `ReadEnable) && (ex_wreg_i == `WriteEnable) && (ex_wd_i == rt))
    reg2_o                   = ex_wdata_i;
  else if ((reg2_read_o == `ReadEnable) && (mem_wreg_i == `WriteEnable) && (mem_wd_i == rt))
    reg2_o                   = mem_wdata_i;
  else if (reg2_read_o == `ReadEnable)
    reg2_o                   = reg2_data_i;
  else if (reg2_read_o == `ReadDisable)
    reg2_o                   = imm;
  else
    reg2_o                   = `ZeroWord;
end

// --------------------> stallreq
assign pre_inst_is_load      = (ex_aluop_i == `EXE_LB_OP) || (ex_aluop_i == `EXE_LBU_OP) ||
                               (ex_aluop_i == `EXE_LH_OP) || (ex_aluop_i == `EXE_LHU_OP) ||
                               (ex_aluop_i == `EXE_LW_OP) || (ex_aluop_i == `EXE_LWL_OP) ||
                               (ex_aluop_i == `EXE_LWR_OP) || (ex_aluop_i == `EXE_LL_OP) ||
                               (ex_aluop_i == `EXE_SC_OP);

assign stallreq_for_reg1_loadrelate = (pre_inst_is_load == 1'b1) && (ex_wd_i == reg1_addr_o) && (reg1_read_o == 1'b1);
assign stallreq_for_reg2_loadrelate = (pre_inst_is_load == 1'b1) && (ex_wd_i == reg2_addr_o) && (reg2_read_o == 1'b1);

assign  stallreq                    = (stallreq_for_reg1_loadrelate | stallreq_for_reg2_loadrelate);

// --------------------> is_in_delayslot_o
always @(*)
begin : IS_IN_DELAYSLOT_O_PROC
  if (rst_n == `RstEnable)
    is_in_delayslot_o        = `NotInDelaySlot;
  else
    is_in_delayslot_o        = is_in_delayslot_i;
end

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif

endmodule
// ---********************************************************************------
