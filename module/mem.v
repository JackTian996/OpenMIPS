// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   mem.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-13
// Description:
//
// ---********************************************************************------
`include "defines.v"
module mem
    (
    input                                        rst_n,
    input                              [`RegBus] wdata_i,
    input                          [`RegAddrBus] wd_i,
    input                                        wreg_i,
    input                                        whilo_i,
    input                              [`RegBus] hi_i,
    input                              [`RegBus] lo_i,
    // ld/st needed info from ex stage
    input                            [`AluOpBus] aluop_i,
    input                              [`RegBus] mem_addr_i,
    input                              [`RegBus] reg2_i,

    output reg                         [`RegBus] wdata_o,
    output reg                     [`RegAddrBus] wd_o,
    output reg                                   wreg_o,
    output reg                                   whilo_o,
    output reg                         [`RegBus] hi_o,
    output reg                         [`RegBus] lo_o,
    //interface with data ram
    output reg                                   mem_ce_o,
    output reg                                   mem_we_o,
    output reg                         [`RegBus] mem_addr_o,
    output reg                         [`RegBus] mem_data_o,
    output reg                             [3:0] mem_sel_o,
    input                              [`RegBus] mem_data_i,
    //interface with llbit_reg
    output reg                                   llbit_we_o,
    output reg                                   llbit_value_o,
    input                                        llbit_value_i,
      //llbit forward from wb
    input                                        wb_llbit_we_i,
    input                                        wb_llbit_value_i,

    input                                        mem_cp0_we_i,
    input                                  [4:0] mem_cp0_waddr_i,
    input                                  [4:0] mem_cp0_raddr_i,
    input                              [`RegBus] mem_cp0_wdata_i,

    output reg                                   mem_cp0_we_o,
    output reg                             [4:0] mem_cp0_waddr_o,
    output reg                             [4:0] mem_cp0_raddr_o,
    output reg                         [`RegBus] mem_cp0_wdata_o
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
reg                                              llbit_real;
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
always @(*)
begin : LLBIT_REAL_PROC
  if (rst_n == `RstEnable)
    llbit_real               = {1{1'b0}};
  else if (wb_llbit_we_i == 1'b1)
    llbit_real               = wb_llbit_value_i;
  else
    llbit_real               = llbit_value_i;
end

always @(*)
begin
  if (rst_n == `RstEnable)
  begin
    wdata_o                  = `ZeroWord;
    wd_o                     = `NOPRegAddr;
    wreg_o                   = `WriteDisable;
    whilo_o                  = `WriteDisable;
    hi_o                     = `ZeroWord;
    lo_o                     = `ZeroWord;
    mem_ce_o                 = `ChipDisable;
    mem_we_o                 = `WriteDisable;
    mem_addr_o               = `ZeroWord;
    mem_data_o               = `ZeroWord;
    mem_sel_o                = 4'b1111;
    llbit_we_o               = `WriteDisable;
    llbit_value_o            = 1'b0;
    mem_cp0_we_o             = `WriteDisable;
    mem_cp0_waddr_o          = 5'b0;
    mem_cp0_raddr_o          = 5'b0;
    mem_cp0_wdata_o          = `ZeroWord;
  end
  else
  begin
    wdata_o                  = wdata_i;
    wd_o                     = wd_i;
    wreg_o                   = wreg_i;
    whilo_o                  = whilo_i;
    hi_o                     = hi_i;
    lo_o                     = lo_i;
    mem_ce_o                 = `ChipDisable;
    mem_we_o                 = `WriteDisable;
    mem_addr_o               = `ZeroWord;     // addr will ignore bit[1:0]
    mem_data_o               = `ZeroWord;
    mem_sel_o                = 4'b1111;       //sel is not used when read
    llbit_we_o               = `WriteDisable;
    llbit_value_o            = 1'b0;
    mem_cp0_we_o             = mem_cp0_we_i;
    mem_cp0_waddr_o          = mem_cp0_waddr_i;
    mem_cp0_raddr_o          = mem_cp0_raddr_i;
    mem_cp0_wdata_o          = mem_cp0_wdata_i;
    case (aluop_i)
      `EXE_LB_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteDisable;
        mem_addr_o           = mem_addr_i;
        case (mem_addr_i[1:0])
          2'b00: wdata_o     = {{24{mem_data_i[31]}},mem_data_i[31:24]};
          2'b01: wdata_o     = {{24{mem_data_i[23]}},mem_data_i[23:16]};
          2'b10: wdata_o     = {{24{mem_data_i[15]}},mem_data_i[15:8]};
          default: wdata_o   = {{24{mem_data_i[7]}},mem_data_i[7:0]};
        endcase
      end
      `EXE_LBU_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteDisable;
        mem_addr_o           = mem_addr_i;
        case (mem_addr_i[1:0])
          2'b00: wdata_o     = {{24{1'b0}},mem_data_i[31:24]};
          2'b01: wdata_o     = {{24{1'b0}},mem_data_i[23:16]};
          2'b10: wdata_o     = {{24{1'b0}},mem_data_i[15:8]};
          default: wdata_o = {{24{1'b0}},mem_data_i[7:0]}; //2'b11
        endcase
      end
      `EXE_LH_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteDisable;
        mem_addr_o           = mem_addr_i;
        case (mem_addr_i[1:0])
          2'b00: wdata_o     = {{16{mem_data_i[31]}},mem_data_i[31:16]};
          default: wdata_o = {{16{mem_data_i[15]}},mem_data_i[15:0]}; //2'b10
        endcase
      end
      `EXE_LHU_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteDisable;
        mem_addr_o           = mem_addr_i;
        case (mem_addr_i[1:0])
          2'b00: wdata_o     = {{16{1'b0}},mem_data_i[31:16]};
          default: wdata_o = {{16{1'b0}},mem_data_i[15:0]}; //2'b10
        endcase
      end
      `EXE_LW_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteDisable;
        mem_addr_o           = mem_addr_i;
        wdata_o              = mem_data_i; //2'b10
      end
      `EXE_LWL_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteDisable;
        mem_addr_o           = mem_addr_i;
        case (mem_addr_i[1:0])
          2'b00: wdata_o     = mem_data_i;
          2'b01: wdata_o     = {mem_data_i[23:0],reg2_i[7:0]};
          2'b10: wdata_o     = {mem_data_i[15:0],reg2_i[15:0]};
          default: wdata_o = {mem_data_i[7:0],reg2_i[23:0]}; //2'b11
        endcase
      end
      `EXE_LWR_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteDisable;
        mem_addr_o           = mem_addr_i;
        case (mem_addr_i[1:0])
          2'b00: wdata_o     = {reg2_i[31:8],mem_data_i[31:24]};
          2'b01: wdata_o     = {reg2_i[31:16],mem_data_i[31:16]};
          2'b10: wdata_o     = {reg2_i[31:24],mem_data_i[31:8]};
          default: wdata_o = mem_data_i; //2'b11
        endcase
      end
      `EXE_SB_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteEnable;
        mem_addr_o           = mem_addr_i;
        mem_data_o           = {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
        case (mem_addr_i[1:0])
          2'b00: mem_sel_o   = 4'b1000;
          2'b01: mem_sel_o   = 4'b0100;
          2'b10: mem_sel_o   = 4'b0010;
          default: mem_sel_o = 4'b0001;
        endcase
      end
      `EXE_SH_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteEnable;
        mem_addr_o           = mem_addr_i;
        mem_data_o           = {reg2_i[15:0],reg2_i[15:0]};
        case (mem_addr_i[1:0])
          2'b00: mem_sel_o   = 4'b1100;
          default: mem_sel_o = 4'b0011;
        endcase
      end
      `EXE_SW_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteEnable;
        mem_addr_o           = mem_addr_i;
        mem_data_o           = reg2_i;
        mem_sel_o            = 4'b1111;
      end
      `EXE_SWL_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteEnable;
        mem_addr_o           = mem_addr_i;
        case (mem_addr_i[1:0])
          2'b00:
            begin
              mem_data_o     = reg2_i;
              mem_sel_o      = 4'b1111;
            end
          2'b01:
            begin
              mem_data_o     = {{8{1'b0}},reg2_i[31:8]};
              mem_sel_o      = 4'b0111;
            end
          2'b10:
            begin
              mem_data_o     = {{16{1'b0}},reg2_i[31:16]};
              mem_sel_o      = 4'b0011;
            end
          default:
            begin
              mem_data_o     = {{24{1'b0}},reg2_i[31:24]};
              mem_sel_o      = 4'b0001;
            end
        endcase
      end
      `EXE_SWR_OP:
      begin
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteEnable;
        mem_addr_o           = mem_addr_i;
        case (mem_addr_i[1:0])
          2'b00:
            begin
              mem_data_o     = {reg2_i[7:0],{24{1'b0}}};
              mem_sel_o      = 4'b1000;
            end
          2'b01:
            begin
              mem_data_o     = {reg2_i[15:0],{16{1'b0}}};
              mem_sel_o      = 4'b1100;
            end
          2'b10:
            begin
              mem_data_o     = {reg2_i[23:0],{8{1'b0}}};
              mem_sel_o      = 4'b1110;
            end
          default:
            begin
              mem_data_o     = reg2_i;
              mem_sel_o      = 4'b1111;
            end
        endcase
      end
      `EXE_LL_OP:
      begin
        //step1: read ram and write rt
        mem_ce_o             = `ChipEnable;
        mem_we_o             = `WriteDisable;
        mem_addr_o           = mem_addr_i;
        wdata_o              = mem_data_i; //2'b10
        //step2: write llbit 1
        llbit_we_o           = `WriteEnable;
        llbit_value_o        = 1'b1;
      end
      `EXE_SC_OP:
      begin
        if (llbit_real == 1'b1)
        begin
          //step1: store
          mem_ce_o           = `ChipEnable;
          mem_we_o           = `WriteEnable;
          mem_addr_o         = mem_addr_i;
          mem_data_o         = reg2_i;
          mem_sel_o          = 4'b1111;
          //step2: release llbit
          llbit_we_o         = `WriteEnable;
          llbit_value_o      = 1'b0;
          //step3: write success flag to rt
          wdata_o            = 32'b1;
        end
        else
          wdata_o            = 32'b0;
      end
    endcase //aluop
  end //if
end //always

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
