// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   openmips.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-13
// Description:
//
// ---********************************************************************------
`include "defines.v"
module openmips
    (
    output                                       rom_ce_o,
      /*AUTOINPUT*/
      // Beginning of automatic inputs (from unused autoinst inputs)
    input                                        clk,                          // To u_pc_reg of pc_reg.v, ...
    input                              [`RegBus] mem_data_i,                   // To u_mem of mem.v
    input                             [`InstBus] rom_data_i,                   // To u_if_id of if_id.v
    input                                        rst_n,                        // To u_pc_reg of pc_reg.v, ...
      // End of automatics
    output                        [`InstAddrBus] rom_addr_o,
      /*AUTOOUTPUT*/
      // Beginning of automatic outputs (from unused autoinst outputs)
    output                             [`RegBus] mem_addr_o,                   // From u_mem of mem.v
    output                                       mem_ce_o,                     // From u_mem of mem.v
    output                             [`RegBus] mem_data_o,                   // From u_mem of mem.v
    output                                 [3:0] mem_sel_o,                    // From u_mem of mem.v
    output                                       mem_we_o                      // From u_mem of mem.v
      // End of automatics
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire                                             branch_flag_o;                // From u_id of id.v
wire                                   [`RegBus] branch_target_address_o;      // From u_id of id.v
wire                                   [`RegBus] div_opdata1_o;                // From u_ex of ex.v
wire                                   [`RegBus] div_opdata2_o;                // From u_ex of ex.v
wire                                      [63:0] div_result_i;                 // From u_mips_div of mips_div.v
wire                                             div_start_o;                  // From u_ex of ex.v
wire                                             div_valid_i;                  // From u_mips_div of mips_div.v
wire                                 [`AluOpBus] ex_aluop;                     // From u_id_ex of id_ex.v
wire                                 [`AluOpBus] ex_aluop_o;                   // From u_ex of ex.v
wire                                [`AluSelBus] ex_alusel;                    // From u_id_ex of id_ex.v
wire                                       [1:0] ex_cnt_i;                     // From u_ex_mem of ex_mem.v
wire                                       [1:0] ex_cnt_o;                     // From u_ex of ex.v
wire                                       [4:0] ex_cp0_raddr_o;               // From u_ex of ex.v
wire                                      [31:0] ex_cp0_rdata_i;               // From u_cp0_reg of cp0_reg.v
wire                                       [4:0] ex_cp0_waddr_o;               // From u_ex of ex.v
wire                                   [`RegBus] ex_cp0_wdata_o;               // From u_ex of ex.v
wire                                             ex_cp0_we_o;                  // From u_ex of ex.v
wire                                   [`RegBus] ex_hi;                        // From u_ex of ex.v
wire                             [`DoubleRegBus] ex_hilo_tmp_i;                // From u_ex_mem of ex_mem.v
wire                             [`DoubleRegBus] ex_hilo_tmp_o;                // From u_ex of ex.v
wire                                   [`RegBus] ex_inst;                      // From u_id_ex of id_ex.v
wire                                             ex_is_in_delayslot;           // From u_id_ex of id_ex.v
wire                                   [`RegBus] ex_link_address;              // From u_id_ex of id_ex.v
wire                                   [`RegBus] ex_lo;                        // From u_ex of ex.v
wire                                   [`RegBus] ex_mem_addr_o;                // From u_ex of ex.v
wire                                   [`RegBus] ex_reg1;                      // From u_id_ex of id_ex.v
wire                                   [`RegBus] ex_reg2;                      // From u_id_ex of id_ex.v
wire                                   [`RegBus] ex_reg2_o;                    // From u_ex of ex.v
wire                               [`RegAddrBus] ex_wd;                        // From u_id_ex of id_ex.v
wire                               [`RegAddrBus] ex_wd_o;                      // From u_ex of ex.v
wire                                   [`RegBus] ex_wdata_o;                   // From u_ex of ex.v
wire                                             ex_whilo;                     // From u_ex of ex.v
wire                                             ex_wreg;                      // From u_id_ex of id_ex.v
wire                                             ex_wreg_o;                    // From u_ex of ex.v
wire                                   [`RegBus] hi_i;                         // From u_hilo_reg of hilo_reg.v
wire                                 [`AluOpBus] id_aluop;                     // From u_id of id.v
wire                                [`AluSelBus] id_alusel;                    // From u_id of id.v
wire                                  [`InstBus] id_inst;                      // From u_if_id of if_id.v
wire                                  [`InstBus] id_inst_o;                    // From u_id of id.v
wire                                             id_is_in_delayslot;           // From u_id of id.v
wire                                   [`RegBus] id_link_address;              // From u_id of id.v
wire                              [`InstAddrBus] id_pc;                        // From u_if_id of if_id.v
wire                                   [`RegBus] id_reg1;                      // From u_id of id.v
wire                                   [`RegBus] id_reg2;                      // From u_id of id.v
wire                                             id_rom_ce;                    // From u_if_id of if_id.v
wire                               [`RegAddrBus] id_wd;                        // From u_id of id.v
wire                                             id_wreg;                      // From u_id of id.v
wire                              [`InstAddrBus] if_pc;                        // From u_pc_reg of pc_reg.v
wire                                             is_in_delayslot_o;            // From u_id_ex of id_ex.v
wire                                   [`RegBus] lo_i;                         // From u_hilo_reg of hilo_reg.v
wire                                 [`AluOpBus] mem_aluop;                    // From u_ex_mem of ex_mem.v
wire                                       [4:0] mem_cp0_raddr_i;              // From u_ex_mem of ex_mem.v
wire                                       [4:0] mem_cp0_raddr_o;              // From u_mem of mem.v
wire                                       [4:0] mem_cp0_waddr_i;              // From u_ex_mem of ex_mem.v
wire                                       [4:0] mem_cp0_waddr_o;              // From u_mem of mem.v
wire                                   [`RegBus] mem_cp0_wdata_i;              // From u_ex_mem of ex_mem.v
wire                                   [`RegBus] mem_cp0_wdata_o;              // From u_mem of mem.v
wire                                             mem_cp0_we_i;                 // From u_ex_mem of ex_mem.v
wire                                             mem_cp0_we_o;                 // From u_mem of mem.v
wire                                   [`RegBus] mem_hi;                       // From u_ex_mem of ex_mem.v
wire                                   [`RegBus] mem_hi_o;                     // From u_mem of mem.v
wire                                             mem_llbit_value;              // From u_mem of mem.v
wire                                             mem_llbit_value_i;            // From u_llbit_reg of llbit_reg.v
wire                                             mem_llbit_we;                 // From u_mem of mem.v
wire                                   [`RegBus] mem_lo;                       // From u_ex_mem of ex_mem.v
wire                                   [`RegBus] mem_lo_o;                     // From u_mem of mem.v
wire                                   [`RegBus] mem_mem_addr;                 // From u_ex_mem of ex_mem.v
wire                                   [`RegBus] mem_reg2;                     // From u_ex_mem of ex_mem.v
wire                               [`RegAddrBus] mem_wd;                       // From u_ex_mem of ex_mem.v
wire                               [`RegAddrBus] mem_wd_o;                     // From u_mem of mem.v
wire                                   [`RegBus] mem_wdata;                    // From u_ex_mem of ex_mem.v
wire                                   [`RegBus] mem_wdata_o;                  // From u_mem of mem.v
wire                                             mem_whilo;                    // From u_ex_mem of ex_mem.v
wire                                             mem_whilo_o;                  // From u_mem of mem.v
wire                                             mem_wreg;                     // From u_ex_mem of ex_mem.v
wire                                             mem_wreg_o;                   // From u_mem of mem.v
wire                                             nxt_is_in_delayslot_i;        // From u_id of id.v
wire                               [`RegAddrBus] reg1_addr_o;                  // From u_id of id.v
wire                                   [`RegBus] reg1_data_i;                  // From u_regfile of regfile.v
wire                                             reg1_read_o;                  // From u_id of id.v
wire                               [`RegAddrBus] reg2_addr_o;                  // From u_id of id.v
wire                                   [`RegBus] reg2_data_i;                  // From u_regfile of regfile.v
wire                                             reg2_read_o;                  // From u_id of id.v
wire                                             signed_div_o;                 // From u_ex of ex.v
wire                                       [5:0] stall;                        // From u_stall_ctrl of stall_ctrl.v
wire                                             stallreq_from_ex;             // From u_ex of ex.v
wire                                             stallreq_from_id;             // From u_id of id.v
wire                                       [4:0] wb_cp0_raddr_i;               // From u_mem_wb of mem_wb.v
wire                                       [4:0] wb_cp0_waddr_i;               // From u_mem_wb of mem_wb.v
wire                                   [`RegBus] wb_cp0_wdata_i;               // From u_mem_wb of mem_wb.v
wire                                             wb_cp0_we_i;                  // From u_mem_wb of mem_wb.v
wire                                   [`RegBus] wb_hi;                        // From u_mem_wb of mem_wb.v
wire                                             wb_llbit_value;               // From u_mem_wb of mem_wb.v
wire                                             wb_llbit_we;                  // From u_mem_wb of mem_wb.v
wire                                   [`RegBus] wb_lo;                        // From u_mem_wb of mem_wb.v
wire                               [`RegAddrBus] wb_wd;                        // From u_mem_wb of mem_wb.v
wire                                   [`RegBus] wb_wdata;                     // From u_mem_wb of mem_wb.v
wire                                             wb_whilo;                     // From u_mem_wb of mem_wb.v
wire                                             wb_wreg;                      // From u_mem_wb of mem_wb.v
// End of automatics

// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO

/* pc_reg AUTO_TEMPLATE (
    .ce                                (rom_ce_o[]                             ),
    .pc                                (if_pc[]                                ),
    .branch_flag_i                     (branch_flag_o[]                        ),
    .branch_target_address_i           (branch_target_address_o[]              ),
     );*/

pc_reg u_pc_reg
(
  /*AUTOINST*/
 // Outputs
    .ce                                (rom_ce_o                               ), // Templated
    .pc                                (if_pc[`InstAddrBus]                    ), // Templated
 // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .stall                             (stall[5:0]                             ),
    .branch_flag_i                     (branch_flag_o                          ), // Templated
    .branch_target_address_i           (branch_target_address_o[`RegBus]       )); // Templated

assign rom_addr_o            = if_pc;

 /* if_id AUTO_TEMPLATE (
    .if_inst                           (rom_data_i[]                           ),
    .if_rom_ce                         (rom_ce_o                               ),
    .id_rom_ce                         (id_rom_ce                              ),
    );*/
if_id u_if_id
(
/*AUTOINST*/
 // Outputs
    .id_pc                             (id_pc[`InstAddrBus]                    ),
    .id_inst                           (id_inst[`InstBus]                      ),
    .id_rom_ce                         (id_rom_ce                              ), // Templated
 // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .if_pc                             (if_pc[`InstAddrBus]                    ),
    .if_inst                           (rom_data_i[`InstBus]                   ), // Templated
    .if_rom_ce                         (rom_ce_o                               ), // Templated
    .stall                             (stall[5:0]                             ));

 /* id AUTO_TEMPLATE (
    .pc_i                              (id_pc[]                                ),
    .inst_i                            (id_inst[]                              ),
    .wd_o                              (id_wd[]                                ),
    .wreg_o                            (id_wreg[]                              ),
    .aluop_o                           (id_aluop[]                             ),
    .alusel_o                          (id_alusel[]                            ),
    .reg1_o                            (id_reg1[]                              ),
    .reg2_o                            (id_reg2[]                              ),
    .ex_wreg_i                         (ex_wreg_o[]                            ),
    .ex_wd_i                           (ex_wd_o[]                              ),
    .ex_wdata_i                        (ex_wdata_o[]                           ),
    .mem_wreg_i                        (mem_wreg_o[]                           ),
    .mem_wd_i                          (mem_wd_o[]                             ),
    .mem_wdata_i                       (mem_wdata_o[]                          ),
    .rom_ce_dff_i                      (id_rom_ce                              ),
    .stallreq                          (stallreq_from_id                       ),
    .link_address_o                    (id_link_address[]                      ),
    .is_in_delayslot_o                 (id_is_in_delayslot[]                   ),
    .nxt_is_in_delayslot_o             (nxt_is_in_delayslot_i[]                ),
    .is_in_delayslot_i                 (is_in_delayslot_o[]                    ),
    .inst_o                            (id_inst_o[]                            ),
    .ex_aluop_i                        (ex_aluop[]                             ),
    );*/

id u_id
 (
/*AUTOINST*/
  // Outputs
    .inst_o                            (id_inst_o[`InstBus]                    ), // Templated
    .reg1_read_o                       (reg1_read_o                            ),
    .reg2_read_o                       (reg2_read_o                            ),
    .reg1_addr_o                       (reg1_addr_o[`RegAddrBus]               ),
    .reg2_addr_o                       (reg2_addr_o[`RegAddrBus]               ),
    .wd_o                              (id_wd[`RegAddrBus]                     ), // Templated
    .wreg_o                            (id_wreg                                ), // Templated
    .aluop_o                           (id_aluop[`AluOpBus]                    ), // Templated
    .alusel_o                          (id_alusel[`AluSelBus]                  ), // Templated
    .reg1_o                            (id_reg1[`RegBus]                       ), // Templated
    .reg2_o                            (id_reg2[`RegBus]                       ), // Templated
    .branch_flag_o                     (branch_flag_o                          ),
    .branch_target_address_o           (branch_target_address_o[`RegBus]       ),
    .link_address_o                    (id_link_address[`RegBus]               ), // Templated
    .is_in_delayslot_o                 (id_is_in_delayslot                     ), // Templated
    .nxt_is_in_delayslot_o             (nxt_is_in_delayslot_i                  ), // Templated
    .stallreq                          (stallreq_from_id                       ), // Templated
  // Inputs
    .rst_n                             (rst_n                                  ),
    .pc_i                              (id_pc[`InstAddrBus]                    ), // Templated
    .inst_i                            (id_inst[`InstBus]                      ), // Templated
    .rom_ce_dff_i                      (id_rom_ce                              ), // Templated
    .reg1_data_i                       (reg1_data_i[`RegBus]                   ),
    .reg2_data_i                       (reg2_data_i[`RegBus]                   ),
    .ex_wd_i                           (ex_wd_o[`RegAddrBus]                   ), // Templated
    .ex_wdata_i                        (ex_wdata_o[`RegBus]                    ), // Templated
    .ex_wreg_i                         (ex_wreg_o                              ), // Templated
    .mem_wd_i                          (mem_wd_o[`RegAddrBus]                  ), // Templated
    .mem_wdata_i                       (mem_wdata_o[`RegBus]                   ), // Templated
    .mem_wreg_i                        (mem_wreg_o                             ), // Templated
    .is_in_delayslot_i                 (is_in_delayslot_o                      ), // Templated
    .ex_aluop_i                        (ex_aluop[`AluOpBus]                    )); // Templated

 /* regfile AUTO_TEMPLATE (
    .we                                (wb_wreg[]                              ),
    .waddr                             (wb_wd[]                                ),
    .wdata                             (wb_wdata[]                             ),
    .raddr1                            (reg1_addr_o[]                          ),
    .re1                               (reg1_read_o[]                          ),
    .raddr2                            (reg2_addr_o[]                          ),
    .re2                               (reg2_read_o[]                          ),
    .rdata1                            (reg1_data_i[]                          ),
    .rdata2                            (reg2_data_i[]                          ),
    );*/

regfile u_regfile
 (
/*AUTOINST*/
  // Outputs
    .rdata1                            (reg1_data_i[`RegBus]                   ), // Templated
    .rdata2                            (reg2_data_i[`RegBus]                   ), // Templated
  // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .waddr                             (wb_wd[`RegAddrBus]                     ), // Templated
    .we                                (wb_wreg                                ), // Templated
    .wdata                             (wb_wdata[`RegBus]                      ), // Templated
    .raddr1                            (reg1_addr_o[`RegAddrBus]               ), // Templated
    .re1                               (reg1_read_o                            ), // Templated
    .raddr2                            (reg2_addr_o[`RegAddrBus]               ), // Templated
    .re2                               (reg2_read_o                            )); // Templated

  /* id_ex AUTO_TEMPLATE (
    .id_inst                           (id_inst_o[]                            ),
    )*/

id_ex u_id_ex
(
/*AUTOINST*/
 // Outputs
    .ex_wd                             (ex_wd[`RegAddrBus]                     ),
    .ex_wreg                           (ex_wreg                                ),
    .ex_aluop                          (ex_aluop[`AluOpBus]                    ),
    .ex_alusel                         (ex_alusel[`AluSelBus]                  ),
    .ex_reg1                           (ex_reg1[`RegBus]                       ),
    .ex_reg2                           (ex_reg2[`RegBus]                       ),
    .ex_is_in_delayslot                (ex_is_in_delayslot                     ),
    .ex_link_address                   (ex_link_address[`RegBus]               ),
    .is_in_delayslot_o                 (is_in_delayslot_o                      ),
    .ex_inst                           (ex_inst[`RegBus]                       ),
 // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .id_wd                             (id_wd[`RegAddrBus]                     ),
    .id_wreg                           (id_wreg                                ),
    .id_aluop                          (id_aluop[`AluOpBus]                    ),
    .id_alusel                         (id_alusel[`AluSelBus]                  ),
    .id_reg1                           (id_reg1[`RegBus]                       ),
    .id_reg2                           (id_reg2[`RegBus]                       ),
    .stall                             (stall[5:0]                             ),
    .id_is_in_delayslot                (id_is_in_delayslot                     ),
    .id_link_address                   (id_link_address[`RegBus]               ),
    .nxt_is_in_delayslot_i             (nxt_is_in_delayslot_i                  ),
    .id_inst                           (id_inst_o[`RegBus]                     )); // Templated

  /* ex AUTO_TEMPLATE (
    .aluop_i                           (ex_aluop[]                             ),
    .alusel_i                          (ex_alusel[]                            ),
    .reg1_i                            (ex_reg1[]                              ),
    .reg2_i                            (ex_reg2[]                              ),
    .wd_i                              (ex_wd[]                                ),
    .wreg_i                            (ex_wreg[]                              ),
    .wdata_o                           (ex_wdata_o[]                           ),
    .wd_o                              (ex_wd_o[]                              ),
    .wreg_o                            (ex_wreg_o                              ),
    .whilo_o                           (ex_whilo                               ),
    .hi_o                              (ex_hi[]                                ),
    .lo_o                              (ex_lo[]                                ),
    .mem_whilo_i                       (mem_whilo_o                            ),
    .mem_hi_i                          (mem_hi_o[]                             ),
    .mem_lo_i                          (mem_lo_o[]                             ),
    .wb_whilo_i                        (wb_whilo                               ),
    .wb_hi_i                           (wb_hi[]                                ),
    .wb_lo_i                           (wb_lo[]                                ),
    .stallreq                          (stallreq_from_ex                       ),
    .hilo_tmp_o                        (ex_hilo_tmp_o[]                        ),
    .cnt_o                             (ex_cnt_o[]                             ),
    .hilo_tmp_i                        (ex_hilo_tmp_i[]                        ),
    .cnt_i                             (ex_cnt_i[]                             ),
    .link_address_i                    (ex_link_address[]                      ),
    .is_in_delayslot_i                 (ex_is_in_delayslot[]                   ),
    .inst_i                            (ex_inst[]                              ),
    .aluop_o                           (ex_aluop_o[]                           ),
    .mem_addr_o                        (ex_mem_addr_o[]                        ),
    .reg2_o                            (ex_reg2_o[]                            ),
    .cp0_\(.*\)                        (ex_cp0_\1[]                            ),
    .wb_cp0.*                          (@"vl-name"[]                           ),
    .mem_cp0.*                         (@"vl-name"[]                           ),
    )*/

ex u_ex
 (
/*AUTOINST*/
  // Outputs
    .wdata_o                           (ex_wdata_o[`RegBus]                    ), // Templated
    .wd_o                              (ex_wd_o[`RegAddrBus]                   ), // Templated
    .wreg_o                            (ex_wreg_o                              ), // Templated
    .whilo_o                           (ex_whilo                               ), // Templated
    .hi_o                              (ex_hi[`RegBus]                         ), // Templated
    .lo_o                              (ex_lo[`RegBus]                         ), // Templated
    .stallreq                          (stallreq_from_ex                       ), // Templated
    .hilo_tmp_o                        (ex_hilo_tmp_o[`DoubleRegBus]           ), // Templated
    .cnt_o                             (ex_cnt_o[1:0]                          ), // Templated
    .signed_div_o                      (signed_div_o                           ),
    .div_opdata1_o                     (div_opdata1_o[`RegBus]                 ),
    .div_opdata2_o                     (div_opdata2_o[`RegBus]                 ),
    .div_start_o                       (div_start_o                            ),
    .mem_addr_o                        (ex_mem_addr_o[`RegBus]                 ), // Templated
    .reg2_o                            (ex_reg2_o[`RegBus]                     ), // Templated
    .aluop_o                           (ex_aluop_o[`AluOpBus]                  ), // Templated
    .cp0_we_o                          (ex_cp0_we_o                            ), // Templated
    .cp0_waddr_o                       (ex_cp0_waddr_o[4:0]                    ), // Templated
    .cp0_raddr_o                       (ex_cp0_raddr_o[4:0]                    ), // Templated
    .cp0_wdata_o                       (ex_cp0_wdata_o[`RegBus]                ), // Templated
  // Inputs
    .rst_n                             (rst_n                                  ),
    .aluop_i                           (ex_aluop[`AluOpBus]                    ), // Templated
    .alusel_i                          (ex_alusel[`AluSelBus]                  ), // Templated
    .reg1_i                            (ex_reg1[`RegBus]                       ), // Templated
    .reg2_i                            (ex_reg2[`RegBus]                       ), // Templated
    .wd_i                              (ex_wd[`RegAddrBus]                     ), // Templated
    .wreg_i                            (ex_wreg                                ), // Templated
    .inst_i                            (ex_inst[`RegBus]                       ), // Templated
    .link_address_i                    (ex_link_address[`RegBus]               ), // Templated
    .is_in_delayslot_i                 (ex_is_in_delayslot                     ), // Templated
    .mem_whilo_i                       (mem_whilo_o                            ), // Templated
    .mem_hi_i                          (mem_hi_o[`RegBus]                      ), // Templated
    .mem_lo_i                          (mem_lo_o[`RegBus]                      ), // Templated
    .wb_whilo_i                        (wb_whilo                               ), // Templated
    .wb_hi_i                           (wb_hi[`RegBus]                         ), // Templated
    .wb_lo_i                           (wb_lo[`RegBus]                         ), // Templated
    .hi_i                              (hi_i[`RegBus]                          ),
    .lo_i                              (lo_i[`RegBus]                          ),
    .hilo_tmp_i                        (ex_hilo_tmp_i[`DoubleRegBus]           ), // Templated
    .cnt_i                             (ex_cnt_i[1:0]                          ), // Templated
    .div_result_i                      (div_result_i[`DoubleRegBus]            ),
    .div_valid_i                       (div_valid_i                            ),
    .cp0_rdata_i                       (ex_cp0_rdata_i[`RegBus]                ), // Templated
    .wb_cp0_we_i                       (wb_cp0_we_i                            ), // Templated
    .wb_cp0_waddr_i                    (wb_cp0_waddr_i[4:0]                    ), // Templated
    .wb_cp0_wdata_i                    (wb_cp0_wdata_i[`RegBus]                ), // Templated
    .mem_cp0_we_i                      (mem_cp0_we_i                           ), // Templated
    .mem_cp0_waddr_i                   (mem_cp0_waddr_i[4:0]                   ), // Templated
    .mem_cp0_wdata_i                   (mem_cp0_wdata_i[`RegBus]               )); // Templated

/*ex_mem AUTO_TEMPLATE (
    .ex_wdata                          (ex_wdata_o[]                           ),
    .ex_wreg                           (ex_wreg_o                              ),
    .ex_wdata                          (ex_wdata_o[]                           ),
    .ex_wd                             (ex_wd_o[]                              ),
    .hilo_i                            (ex_hilo_tmp_o[]                        ),
    .cnt_i                             (ex_cnt_o[]                             ),
    .hilo_o                            (ex_hilo_tmp_i[]                        ),
    .cnt_o                             (ex_cnt_i[]                             ),
    .ex_aluop                          (ex_aluop_o[]                           ),
    .ex_mem_addr                       (ex_mem_addr_o[]                        ),
    .ex_reg2                           (ex_reg2_o[]                            ),
    .ex_cp0.*                          (@"vl-name"_o[]                         ),
    .mem_cp0.*                         (@"vl-name"_i[]                         ),
  );*/
ex_mem u_ex_mem
 (
/*AUTOINST*/
  // Outputs
    .mem_wdata                         (mem_wdata[`RegBus]                     ),
    .mem_wd                            (mem_wd[`RegAddrBus]                    ),
    .mem_wreg                          (mem_wreg                               ),
    .mem_whilo                         (mem_whilo                              ),
    .mem_hi                            (mem_hi[`RegBus]                        ),
    .mem_lo                            (mem_lo[`RegBus]                        ),
    .hilo_o                            (ex_hilo_tmp_i[`DoubleRegBus]           ), // Templated
    .cnt_o                             (ex_cnt_i[1:0]                          ), // Templated
    .mem_mem_addr                      (mem_mem_addr[`RegBus]                  ),
    .mem_aluop                         (mem_aluop[`AluOpBus]                   ),
    .mem_reg2                          (mem_reg2[`RegBus]                      ),
    .mem_cp0_we                        (mem_cp0_we_i                           ), // Templated
    .mem_cp0_waddr                     (mem_cp0_waddr_i[4:0]                   ), // Templated
    .mem_cp0_raddr                     (mem_cp0_raddr_i[4:0]                   ), // Templated
    .mem_cp0_wdata                     (mem_cp0_wdata_i[`RegBus]               ), // Templated
  // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .ex_wdata                          (ex_wdata_o[`RegBus]                    ), // Templated
    .ex_wd                             (ex_wd_o[`RegAddrBus]                   ), // Templated
    .ex_wreg                           (ex_wreg_o                              ), // Templated
    .ex_whilo                          (ex_whilo                               ),
    .ex_hi                             (ex_hi[`RegBus]                         ),
    .ex_lo                             (ex_lo[`RegBus]                         ),
    .stall                             (stall[5:0]                             ),
    .hilo_i                            (ex_hilo_tmp_o[`DoubleRegBus]           ), // Templated
    .cnt_i                             (ex_cnt_o[1:0]                          ), // Templated
    .ex_mem_addr                       (ex_mem_addr_o[`RegBus]                 ), // Templated
    .ex_aluop                          (ex_aluop_o[`AluOpBus]                  ), // Templated
    .ex_reg2                           (ex_reg2_o[`RegBus]                     ), // Templated
    .ex_cp0_we                         (ex_cp0_we_o                            ), // Templated
    .ex_cp0_waddr                      (ex_cp0_waddr_o[4:0]                    ), // Templated
    .ex_cp0_raddr                      (ex_cp0_raddr_o[4:0]                    ), // Templated
    .ex_cp0_wdata                      (ex_cp0_wdata_o[`RegBus]                )); // Templated

  /* mem AUTO_TEMPLATE (
    .wdata_i                           (mem_wdata[]                            ),
    .wd_i                              (mem_wd[]                               ),
    .wreg_i                            (mem_wreg[]                             ),
    .wdata_o                           (mem_wdata_o[]                          ),
    .wd_o                              (mem_wd_o[]                             ),
    .wreg_o                            (mem_wreg_o                             ),
    .whilo_i                           (mem_whilo                              ),
    .hi_i                              (mem_hi[]                               ),
    .lo_i                              (mem_lo[]                               ),
    .whilo_o                           (mem_whilo_o                            ),
    .hi_o                              (mem_hi_o[]                             ),
    .lo_o                              (mem_lo_o[]                             ),
    .aluop_i                           (mem_aluop[]                            ),
    .mem_addr_i                        (mem_mem_addr[]                         ),
    .reg2_i                            (mem_reg2[]                             ),
    .llbit_value_i                     (mem_llbit_value_i                      ),
    .wb_llbit_we_i                     (wb_llbit_we                            ),
    .wb_llbit_value_i                  (wb_llbit_value                         ),
    .llbit_we_o                        (mem_llbit_we                           ),
    .llbit_value_o                     (mem_llbit_value                        ),
    )*/

 mem u_mem
 (
/*AUTOINST*/
  // Outputs
    .wdata_o                           (mem_wdata_o[`RegBus]                   ), // Templated
    .wd_o                              (mem_wd_o[`RegAddrBus]                  ), // Templated
    .wreg_o                            (mem_wreg_o                             ), // Templated
    .whilo_o                           (mem_whilo_o                            ), // Templated
    .hi_o                              (mem_hi_o[`RegBus]                      ), // Templated
    .lo_o                              (mem_lo_o[`RegBus]                      ), // Templated
    .mem_ce_o                          (mem_ce_o                               ),
    .mem_we_o                          (mem_we_o                               ),
    .mem_addr_o                        (mem_addr_o[`RegBus]                    ),
    .mem_data_o                        (mem_data_o[`RegBus]                    ),
    .mem_sel_o                         (mem_sel_o[3:0]                         ),
    .llbit_we_o                        (mem_llbit_we                           ), // Templated
    .llbit_value_o                     (mem_llbit_value                        ), // Templated
    .mem_cp0_we_o                      (mem_cp0_we_o                           ),
    .mem_cp0_waddr_o                   (mem_cp0_waddr_o[4:0]                   ),
    .mem_cp0_raddr_o                   (mem_cp0_raddr_o[4:0]                   ),
    .mem_cp0_wdata_o                   (mem_cp0_wdata_o[`RegBus]               ),
  // Inputs
    .rst_n                             (rst_n                                  ),
    .wdata_i                           (mem_wdata[`RegBus]                     ), // Templated
    .wd_i                              (mem_wd[`RegAddrBus]                    ), // Templated
    .wreg_i                            (mem_wreg                               ), // Templated
    .whilo_i                           (mem_whilo                              ), // Templated
    .hi_i                              (mem_hi[`RegBus]                        ), // Templated
    .lo_i                              (mem_lo[`RegBus]                        ), // Templated
    .aluop_i                           (mem_aluop[`AluOpBus]                   ), // Templated
    .mem_addr_i                        (mem_mem_addr[`RegBus]                  ), // Templated
    .reg2_i                            (mem_reg2[`RegBus]                      ), // Templated
    .mem_data_i                        (mem_data_i[`RegBus]                    ),
    .llbit_value_i                     (mem_llbit_value_i                      ), // Templated
    .wb_llbit_we_i                     (wb_llbit_we                            ), // Templated
    .wb_llbit_value_i                  (wb_llbit_value                         ), // Templated
    .mem_cp0_we_i                      (mem_cp0_we_i                           ),
    .mem_cp0_waddr_i                   (mem_cp0_waddr_i[4:0]                   ),
    .mem_cp0_raddr_i                   (mem_cp0_raddr_i[4:0]                   ),
    .mem_cp0_wdata_i                   (mem_cp0_wdata_i[`RegBus]               ));

/* mem_wb AUTO_TEMPLATE (
    .mem_wdata                         (mem_wdata_o[]                          ),
    .mem_wd                            (mem_wd_o[]                             ),
    .mem_wreg                          (mem_wreg_o                             ),
    .mem_whilo                         (mem_whilo_o                            ),
    .mem_hi                            (mem_hi_o[]                             ),
    .mem_lo                            (mem_lo_o[]                             ),
    .mem_cp0.*                         (@"vl-name"_o[]                         ),
    .wb_cp0.*                          (@"vl-name"_i[]                         ),
   );*/

 mem_wb u_mem_wb
 (
/*AUTOINST*/
  // Outputs
    .wb_wdata                          (wb_wdata[`RegBus]                      ),
    .wb_wd                             (wb_wd[`RegAddrBus]                     ),
    .wb_wreg                           (wb_wreg                                ),
    .wb_whilo                          (wb_whilo                               ),
    .wb_hi                             (wb_hi[`RegBus]                         ),
    .wb_lo                             (wb_lo[`RegBus]                         ),
    .wb_llbit_we                       (wb_llbit_we                            ),
    .wb_llbit_value                    (wb_llbit_value                         ),
    .wb_cp0_we                         (wb_cp0_we_i                            ), // Templated
    .wb_cp0_waddr                      (wb_cp0_waddr_i[4:0]                    ), // Templated
    .wb_cp0_raddr                      (wb_cp0_raddr_i[4:0]                    ), // Templated
    .wb_cp0_wdata                      (wb_cp0_wdata_i[`RegBus]                ), // Templated
  // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .mem_wdata                         (mem_wdata_o[`RegBus]                   ), // Templated
    .mem_wd                            (mem_wd_o[`RegAddrBus]                  ), // Templated
    .mem_wreg                          (mem_wreg_o                             ), // Templated
    .mem_whilo                         (mem_whilo_o                            ), // Templated
    .mem_hi                            (mem_hi_o[`RegBus]                      ), // Templated
    .mem_lo                            (mem_lo_o[`RegBus]                      ), // Templated
    .stall                             (stall[5:0]                             ),
    .mem_llbit_we                      (mem_llbit_we                           ),
    .mem_llbit_value                   (mem_llbit_value                        ),
    .mem_cp0_we                        (mem_cp0_we_o                           ), // Templated
    .mem_cp0_waddr                     (mem_cp0_waddr_o[4:0]                   ), // Templated
    .mem_cp0_raddr                     (mem_cp0_raddr_o[4:0]                   ), // Templated
    .mem_cp0_wdata                     (mem_cp0_wdata_o[`RegBus]               )); // Templated

/* hilo_reg AUTO_TEMPLATE (
    .we                                (wb_whilo                               ),
    .hi_i                              (wb_hi[]                                ),
    .lo_i                              (wb_lo[]                                ),
    .hi_o                              (hi_i[]                                 ),
    .lo_o                              (lo_i[]                                 ),
   );*/

hilo_reg u_hilo_reg
(
/*AUTOINST*/
 // Outputs
    .hi_o                              (hi_i[`RegBus]                          ), // Templated
    .lo_o                              (lo_i[`RegBus]                          ), // Templated
 // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .we                                (wb_whilo                               ), // Templated
    .hi_i                              (wb_hi[`RegBus]                         ), // Templated
    .lo_i                              (wb_lo[`RegBus]                         )); // Templated

/* stall_ctrl AUTO_TEMPLATE (

   );*/

stall_ctrl u_stall_ctrl
(
/*AUTOINST*/
 // Outputs
    .stall                             (stall[5:0]                             ),
 // Inputs
    .rst_n                             (rst_n                                  ),
    .stallreq_from_id                  (stallreq_from_id                       ),
    .stallreq_from_ex                  (stallreq_from_ex                       ));

/*MIPS_DIV AUTO_TEMPLATE (
    .signed_div_i                      (signed_div_o[]                         ),
    .opdata1_i                         (div_opdata1_o[]                        ),
    .opdata2_i                         (div_opdata2_o[]                        ),
    .start_i                           (div_start_o[]                          ),
    .annul_i                           (1'b0                                   ),
    .result_o                          (div_result_i[]                         ),
    .valid_o                           (div_valid_i[]                          ),
  );*/

mips_div
   #(
    .OPDATA_WIDTH                      (32                                     ),
    .CNT_WIDTH                         (6                                      ),
    .RST_ENABLE                        (1                                      )
    )
u_mips_div (
/*AUTOINST*/
            // Outputs
    .result_o                          (div_result_i[63:0]                     ), // Templated
    .valid_o                           (div_valid_i                            ), // Templated
            // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .signed_div_i                      (signed_div_o                           ), // Templated
    .opdata1_i                         (div_opdata1_o[31:0]                    ), // Templated
    .opdata2_i                         (div_opdata2_o[31:0]                    ), // Templated
    .start_i                           (div_start_o                            ), // Templated
    .annul_i                           (1'b0                                   )); // Templated

/*llbit_reg AUTO_TEMPLATE (
    .we                                (wb_llbit_we                            ),
    .llbit_i                           (wb_llbit_value                         ),
    .flush                             (1'b0                                   ),
    .llbit_o                           (mem_llbit_value_i                      ),
  );*/
llbit_reg u_llbit_reg (
/*AUTOINST*/
                       // Outputs
    .llbit_o                           (mem_llbit_value_i                      ), // Templated
                       // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .flush                             (1'b0                                   ), // Templated
    .we                                (wb_llbit_we                            ), // Templated
    .llbit_i                           (wb_llbit_value                         )); // Templated

/* cp0_reg AUTO_TEMPLATE (
    ..*_i                              (wb_cp0_@"vl-name"[]                    ),
    .intr_i                            (6'b0                                   ),
    .rdata_o                           (ex_cp0_rdata_i[]                       ),
    .count_o                           (                                       ),
    .compare_o                         (                                       ),
    .status_o                          (                                       ),
    .cause_o                           (                                       ),
    .epc_o                             (                                       ),
    .prid_o                            (                                       ),
    .config_o                          (                                       ),
    .timer_intr_o                      (                                       ),
   );*/

cp0_reg u_cp0_reg (
/*AUTOINST*/
                   // Outputs
    .rdata_o                           (ex_cp0_rdata_i[31:0]                   ), // Templated
    .count_o                           (                                       ), // Templated
    .compare_o                         (                                       ), // Templated
    .status_o                          (                                       ), // Templated
    .cause_o                           (                                       ), // Templated
    .epc_o                             (                                       ), // Templated
    .prid_o                            (                                       ), // Templated
    .config_o                          (                                       ), // Templated
    .timer_intr_o                      (                                       ), // Templated
                   // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .we_i                              (wb_cp0_we_i                            ), // Templated
    .waddr_i                           (wb_cp0_waddr_i[4:0]                    ), // Templated
    .raddr_i                           (wb_cp0_raddr_i[4:0]                    ), // Templated
    .wdata_i                           (wb_cp0_wdata_i[31:0]                   ), // Templated
    .intr_i                            (6'b0                                   )); // Templated

// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
// Local Variables:
// verilog-library-directories:("." "/home/ICer/ic_prjs/open_mips/cbb")
// verilog-auto-inst-param-value:t
// End:
