// ---********************************************************************------
// Copyright 2020-2030 (c) , Inc. All rights reserved.
// Module Name:   cp0_reg.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-04-09
// Description:
//
// ---********************************************************************------
module cp0_reg
    (
    input                                        clk,
    input                                        rst_n,
    input                                        we_i,
    input                                  [4:0] waddr_i,
    input                                  [4:0] raddr_i,
    input                                 [31:0] wdata_i,
    input                                  [5:0] intr_i,                       // 6 hw ; 2 sw
    output                                [31:0] rdata_o,
    output                                [31:0] count_o,
    output                                [31:0] compare_o,
    output                                [31:0] status_o,
    output                                [31:0] cause_o,
    output                                [31:0] epc_o,
    output                                [31:0] prid_o,
    output                                [31:0] config_o,
    output                                       timer_intr_o,
    input                              [`RegBus] curr_inst_addr_i,
    input                                 [31:0] excep_type_i,
    input                                        is_in_delayslot_i
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
wire                                             sel;
reg                                       [31:0] rdata;
reg                                       [31:0] count;
reg                                       [31:0] compare;
reg                                              timer_intr;
reg                                       [31:0] epc;
wire                                       [7:0] CompID;
wire                                       [9:0] ProcesID;
wire                                       [5:0] Revision;
wire                                             MultiConfig;
wire                                      [14:0] Impl;
wire                                             BigEndian;
wire                                       [1:0] ArchType;
wire                                       [2:0] ArchVersion;
wire                                       [2:0] MmuImpl;
wire                                             VirtualInst;
wire                                             Kseg0Cacheable;
reg                                              BranchDelaySlot;
reg                                        [1:0] CoprocesErr;
reg                                              DisableCount;
reg                                              ProfCountIntr;
reg                                              IntrVec;
reg                                              WatchPend;
reg                                        [5:0] HwIntrPend;
reg                                        [1:0] SwIntrPend;
reg                                        [4:0] ExcpCode;
reg                                        [3:0] CoprocesUse;
reg                                              ReducePower;
reg                                              ResetEadian;
reg                                              BootExcepVec;
reg                                              TlbShutdown;
reg                                              SoftReset;
reg                                              NoMaskIntr;
reg                                        [7:0] IntrMask;
reg                                              UserMode;
reg                                              ExcpDataErr;
reg                                              ExcpLevl;
reg                                              IntrEnable;

// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
// --------------------> Count
always @(posedge clk or negedge rst_n)
begin : COUNT_PROC
  if (rst_n == `RstEnable)
    count                    <= {32{1'b0}};
  else if ((we_i == `WriteEnable) && (waddr_i == `CP0_REG_COUNT))
    count                    <= wdata_i;
  else
    count                    <= count + 1'b1;
end

assign count_o               = count;

// --------------------> Compare
always @(posedge clk or negedge rst_n)
begin : COMPARE_PROC
  if (rst_n == `RstEnable)
    compare                  <= {32{1'b0}};
  else if ((we_i == `WriteEnable) && (waddr_i == `CP0_REG_COMPARE))
    compare                  <= wdata_i;
end

assign compare_o             = compare;

always @(posedge clk or negedge rst_n)
begin : TIMER_INTR_PROC
  if (rst_n == `RstEnable)
    timer_intr               <= {1{1'b0}};
  else if ((compare_o != `ZeroWord) && (compare_o == count))
    timer_intr               <= `InterruptAssert;
  else if ((we_i == `WriteEnable) && (waddr_i == `CP0_REG_COMPARE))
    timer_intr               <= `InterruptDessert;
end

assign timer_intr_o          = timer_intr;

// --------------------> Status
// avoid latch
always @(*)
begin
  CoprocesUse                = 4'b0001; //which copro avail
  ReducePower                = 1'b0;  //low power
  ResetEadian                = 1'b0;  //1: change
  TlbShutdown                = 1'b0;
  UserMode                   = 1'b0;  //1: kernel; 0: user
  ExcpDataErr                = 1'b0;  //parity or ECC data check
end

always @(posedge clk or negedge rst_n)
begin : STATUS_PROC
  if (rst_n == `RstEnable)
  begin
    BootExcepVec             <= 1'b0;  //1: use boot excp vec; 0: general excp vec
    SoftReset                <= 1'b0;  //restart from sw
    NoMaskIntr               <= 1'b0;  //restart from NMI
    IntrMask                 <= 8'b0;  //1: no mask; 0: mask
    IntrEnable               <= 1'b0;  //1: enable
  end
  else if ((we_i == `WriteEnable) && (waddr_i == `CP0_REG_STATUS))
  begin
    BootExcepVec             <= wdata_i[22];
    SoftReset                <= wdata_i[20];
    NoMaskIntr               <= wdata_i[19];
    IntrMask                 <= wdata_i[15:8];
    IntrEnable               <= wdata_i[0];
  end
end

always @(posedge clk or negedge rst_n)
begin : EXCPLEVL_PROC
  if (rst_n == `RstEnable)
    ExcpLevl                 <= {1{1'b0}};
  else if (excep_type_i == 32'he)    //eret
    ExcpLevl                 <= 1'b0;
  else if ((excep_type_i != 32'h0) && (ExcpLevl == 1'b0))    //others
    ExcpLevl                 <= 1'b1;
  else if ((we_i == `WriteEnable) && (waddr_i == `CP0_REG_STATUS)) //sw
    ExcpLevl                 <= wdata_i[1];
end

assign status_o              = {CoprocesUse,ReducePower,1'b0,ResetEadian,2'b0,BootExcepVec,
                                TlbShutdown,SoftReset,NoMaskIntr,3'b0,IntrMask,3'b0,UserMode,
                                1'b0,ExcpDataErr,ExcpLevl,IntrEnable};

// --------------------> Cause
// avoid latch
always @(*)
begin
  CoprocesErr                = 2'b0;
  DisableCount               = 1'b0;
  ProfCountIntr              = 1'b0;
end

always @(posedge clk or negedge rst_n)
begin : CAUSE_PROC
  if (rst_n == `RstEnable)
  begin
    IntrVec                  <= 1'b0;
    WatchPend                <= 1'b0;
    SwIntrPend               <= 2'b0;
  end
  else if ((we_i == `WriteEnable) && (waddr_i == `CP0_REG_CAUSE))
  begin
    IntrVec                  <= wdata_i[23];
    WatchPend                <= wdata_i[22];
    SwIntrPend               <= wdata_i[9:8];
  end
end

always @(posedge clk or negedge rst_n)
begin : HW_INTR_PROC
  if (rst_n == `RstEnable)
    HwIntrPend               <= 6'b0;
  else
    HwIntrPend               <= intr_i;
end

// eret is a special, dont need to updata
always @(posedge clk or negedge rst_n)
begin : EXCPCODE_PROC
  if (rst_n == `RstEnable)
    ExcpCode                 <= {5{1'b0}};
  else if (excep_type_i == 32'h1)           // intr
    ExcpCode                 <= 5'b00000;
  else if (excep_type_i == 32'h8)           // syscall
    ExcpCode                 <= 5'b01000;
  else if (excep_type_i == 32'ha)           // Invalid
    ExcpCode                 <= 5'b01010;
  else if (excep_type_i == 32'hd)           // Ov
    ExcpCode                 <= 5'b01101;
  else if (excep_type_i == 32'hc)           // Trap
    ExcpCode                 <= 5'b01100;
end

always @(posedge clk or negedge rst_n)
begin : BRANCHDELAYSLOT_PROC
  if (rst_n == 1'b0)
    BranchDelaySlot          <= {1{1'b0}};
  else if ((ExcpLevl == 1'b0) && (is_in_delayslot_i == 1'b1) &&
           (excep_type_i != 32'h0) && (excep_type_i != 32'he))
    BranchDelaySlot          <= 1'b1;
  else if ((ExcpLevl == 1'b0) && (is_in_delayslot_i == 1'b0) &&
           (excep_type_i != 32'h0) && (excep_type_i != 32'he))
    BranchDelaySlot          <= 1'b0;
end

assign cause_o               = {BranchDelaySlot,1'b0,CoprocesErr,DisableCount,ProfCountIntr,1'b0,
                                IntrVec,WatchPend,1'b0,HwIntrPend,SwIntrPend,1'b0,ExcpCode,2'b0};

// --------------------> EPC
always @(posedge clk or negedge rst_n)
begin : EPC_PROC
  if (rst_n == `RstEnable)
    epc                      <= {32{1'b0}};
  else if ((ExcpLevl == 1'b0) && (is_in_delayslot_i == 1'b1) &&
           (excep_type_i != 32'h0) && (excep_type_i != 32'he))
    epc                      <= curr_inst_addr_i - 4;
  else if ((ExcpLevl == 1'b0) && (is_in_delayslot_i == 1'b0) &&
           (excep_type_i != 32'h0) && (excep_type_i != 32'he))
    epc                      <= curr_inst_addr_i;
  else if ((we_i == `WriteEnable) && (waddr_i == `CP0_REG_EPC))
    epc                      <= wdata_i;
end

assign epc_o                 = epc;

// --------------------> PRID

assign CompID                = 8'h48;
assign ProcesID              = 10'b0000000001;
assign Revision              = 6'b000010;

assign prid_o                = {8'b0,CompID,ProcesID,Revision};

// --------------------> Config

assign MultiConfig           = 1'b0;
assign Impl                  = 15'b0;
assign BigEndian             = 1'b1;
assign ArchType              = 2'b0;
assign ArchVersion           = 3'b0;
assign MmuImpl               = 3'b0;
assign VirtualInst           = 1'b0;
assign Kseg0Cacheable        = 1'b0;

assign config_o              = {MultiConfig,Impl,BigEndian,ArchType,ArchVersion,
                                MmuImpl,3'b0,VirtualInst,Kseg0Cacheable};

// --------------------> rdata MUX
always @(*)
begin : RDATA_PROC
  case (raddr_i)
    `CP0_REG_COUNT:
      rdata                  = count_o;
    `CP0_REG_COMPARE:
      rdata                  = compare_o;
    `CP0_REG_STATUS:
      rdata                  = status_o;
    `CP0_REG_CAUSE:
      rdata                  = cause_o;
    `CP0_REG_EPC:
      rdata                  = epc_o;
    `CP0_REG_PRID:
      rdata                  = prid_o;
    `CP0_REG_CONFIG:
      rdata                  = config_o;
    default:
      rdata                  = `ZeroWord;
  endcase
end

assign rdata_o               = rdata;

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
