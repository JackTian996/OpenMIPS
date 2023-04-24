// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   openmips_min_scop.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-14
// Description:
//
// ---********************************************************************------
`include "defines.v"
module openmips_min_scop
    (
    /*AUTOINOUT*/
    // Beginning of automatic inouts (from unused autoinst inouts)
    inout                           [SDR_DW-1:0] sdr_dq,                       // To/From u_sdrc_top of sdrc_top.v
    // End of automatics
      /*AUTOINPUT*/
      // Beginning of automatic inputs (from unused autoinst inputs)
    input                                 [31:0] aux_i,                        // To u_gpio_top of gpio_top.v
    input                                  [1:0] cfg_colbits,                  // To u_sdrc_top of sdrc_top.v
    input                                  [1:0] cfg_req_depth,                // To u_sdrc_top of sdrc_top.v
    input                                  [2:0] cfg_sdr_cas,                  // To u_sdrc_top of sdrc_top.v
    input                                        cfg_sdr_en,                   // To u_sdrc_top of sdrc_top.v
    input                                 [12:0] cfg_sdr_mode_reg,             // To u_sdrc_top of sdrc_top.v
    input              [`SDR_RFSH_ROW_CNT_W-1:0] cfg_sdr_rfmax,                // To u_sdrc_top of sdrc_top.v
    input                [`SDR_RFSH_TIMER_W-1:0] cfg_sdr_rfsh,                 // To u_sdrc_top of sdrc_top.v
    input                                  [3:0] cfg_sdr_tras_d,               // To u_sdrc_top of sdrc_top.v
    input                                  [3:0] cfg_sdr_trcar_d,              // To u_sdrc_top of sdrc_top.v
    input                                  [3:0] cfg_sdr_trcd_d,               // To u_sdrc_top of sdrc_top.v
    input                                  [3:0] cfg_sdr_trp_d,                // To u_sdrc_top of sdrc_top.v
    input                                  [3:0] cfg_sdr_twr_d,                // To u_sdrc_top of sdrc_top.v
    input                                  [1:0] cfg_sdr_width,                // To u_sdrc_top of sdrc_top.v
    input                                        clk,                          // To u_openmips of openmips.v, ...
    input                                        clk_pad_i,                    // To u_gpio_top of gpio_top.v
    input                                        cts_pad_i,                    // To u_uart_top of uart_top.v
    input                                        dcd_pad_i,                    // To u_uart_top of uart_top.v
    input                                        dsr_pad_i,                    // To u_uart_top of uart_top.v
    input                                 [31:0] ext_pad_i,                    // To u_gpio_top of gpio_top.v
    input                                  [7:0] flash_dat_i,                  // To u_flash_top of flash_top.v
    input                                        ri_pad_i,                     // To u_uart_top of uart_top.v
    input                                        rst,                          // To u_openmips of openmips.v, ...
    input                                        srx_pad_i,                    // To u_uart_top of uart_top.v
      // End of automatics
      /*AUTOOUTPUT*/
      // Beginning of automatic outputs (from unused autoinst outputs)
    output                                       baud_o,                       // From u_uart_top of uart_top.v
    output                                       dtr_pad_o,                    // From u_uart_top of uart_top.v
    output                                [31:0] ext_pad_o,                    // From u_gpio_top of gpio_top.v
    output                                [31:0] ext_padoe_o,                  // From u_gpio_top of gpio_top.v
    output                                [31:0] flash_adr_o,                  // From u_flash_top of flash_top.v
    output                                       flash_ce,                     // From u_flash_top of flash_top.v
    output                                       flash_oe,                     // From u_flash_top of flash_top.v
    output                                       flash_rst,                    // From u_flash_top of flash_top.v
    output                                       flash_we,                     // From u_flash_top of flash_top.v
    output                                       rts_pad_o,                    // From u_uart_top of uart_top.v
    output                                [12:0] sdr_addr,                     // From u_sdrc_top of sdrc_top.v
    output                                 [1:0] sdr_ba,                       // From u_sdrc_top of sdrc_top.v
    output                                       sdr_cas_n,                    // From u_sdrc_top of sdrc_top.v
    output                                       sdr_cke,                      // From u_sdrc_top of sdrc_top.v
    output                                       sdr_cs_n,                     // From u_sdrc_top of sdrc_top.v
    output                          [SDR_BW-1:0] sdr_dqm,                      // From u_sdrc_top of sdrc_top.v
    output                                       sdr_init_done,                // From u_sdrc_top of sdrc_top.v
    output                                       sdr_ras_n,                    // From u_sdrc_top of sdrc_top.v
    output                                       sdr_we_n,                     // From u_sdrc_top of sdrc_top.v
    output                                       stx_pad_o                     // From u_uart_top of uart_top.v
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
wire                                             gpio_intr;                    // From u_gpio_top of gpio_top.v
wire                                             m0_ack_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [31:0] m0_addr_i;                    // From u_openmips of openmips.v
wire                                             m0_cyc_i;                     // From u_openmips of openmips.v
wire                                      [31:0] m0_data_i;                    // From u_openmips of openmips.v
wire                                      [31:0] m0_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                       [3:0] m0_sel_i;                     // From u_openmips of openmips.v
wire                                             m0_stb_i;                     // From u_openmips of openmips.v
wire                                             m0_we_i;                      // From u_openmips of openmips.v
wire                                             m1_ack_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [31:0] m1_addr_i;                    // From u_openmips of openmips.v
wire                                             m1_cyc_i;                     // From u_openmips of openmips.v
wire                                      [31:0] m1_data_i;                    // From u_openmips of openmips.v
wire                                      [31:0] m1_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                       [3:0] m1_sel_i;                     // From u_openmips of openmips.v
wire                                             m1_stb_i;                     // From u_openmips of openmips.v
wire                                             m1_we_i;                      // From u_openmips of openmips.v
wire                                             s0_ack_i;                     // From u_sdrc_top of sdrc_top.v
wire                                      [31:0] s0_addr_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s0_cyc_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                    [dw-1:0] s0_data_i;                    // From u_sdrc_top of sdrc_top.v
wire                                      [31:0] s0_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                       [3:0] s0_sel_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s0_stb_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s0_we_o;                      // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s1_ack_i;                     // From u_uart_top of uart_top.v
wire                                      [31:0] s1_addr_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s1_cyc_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [31:0] s1_data_i;                    // From u_uart_top of uart_top.v
wire                                      [31:0] s1_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                       [3:0] s1_sel_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s1_stb_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s1_we_o;                      // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_ack_i;                     // From u_gpio_top of gpio_top.v
wire                                      [31:0] s2_addr_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_cyc_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [31:0] s2_data_i;                    // From u_gpio_top of gpio_top.v
wire                                      [31:0] s2_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_err_i;                     // From u_gpio_top of gpio_top.v
wire                                       [3:0] s2_sel_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_stb_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_we_o;                      // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s3_ack_i;                     // From u_flash_top of flash_top.v
wire                                      [31:0] s3_addr_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s3_cyc_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [31:0] s3_data_i;                    // From u_flash_top of flash_top.v
wire                                      [31:0] s3_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                       [3:0] s3_sel_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s3_stb_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s3_we_o;                      // From u_wb_conmax_top of wb_conmax_top.v
wire                                             timer_intr;                   // From u_openmips of openmips.v
wire                                             uart_intr;                    // From u_uart_top of uart_top.v
// End of automatics
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ***************************************
// OpenMIPS : mem->m0 pc->m1
// ***************************************
  /*openmips AUTO_TEMPLATE (
    .clk                               (clk                                    ),
    .rst_n                             (rst                                    ),
    .mem_wishbone_\(.*\)_o             (m0_\1_i[]                              ),
    .mem_wishbone_\(.*\)_i             (m0_\1_o[]                              ),
    .pc_wishbone_\(.*\)_o              (m1_\1_i[]                              ),
    .pc_wishbone_\(.*\)_i              (m1_\1_o[]                              ),
    .timer_intr_o                      (timer_intr                             ),
    .intr_i                            ({3'b000,gpio_intr,uart_intr,timer_intr}),
    );*/

  openmips u_openmips (
    /*AUTOINST*/
                       // Outputs
    .mem_wishbone_addr_o               (m0_addr_i[31:0]                        ), // Templated
    .mem_wishbone_cyc_o                (m0_cyc_i                               ), // Templated
    .mem_wishbone_data_o               (m0_data_i[31:0]                        ), // Templated
    .mem_wishbone_sel_o                (m0_sel_i[3:0]                          ), // Templated
    .mem_wishbone_stb_o                (m0_stb_i                               ), // Templated
    .mem_wishbone_we_o                 (m0_we_i                                ), // Templated
    .pc_wishbone_addr_o                (m1_addr_i[31:0]                        ), // Templated
    .pc_wishbone_cyc_o                 (m1_cyc_i                               ), // Templated
    .pc_wishbone_data_o                (m1_data_i[31:0]                        ), // Templated
    .pc_wishbone_sel_o                 (m1_sel_i[3:0]                          ), // Templated
    .pc_wishbone_stb_o                 (m1_stb_i                               ), // Templated
    .pc_wishbone_we_o                  (m1_we_i                                ), // Templated
    .timer_intr_o                      (timer_intr                             ), // Templated
                       // Inputs
    .clk                               (clk                                    ), // Templated
    .intr_i                            ({3'b000,gpio_intr,uart_intr,timer_intr}), // Templated
    .mem_wishbone_ack_i                (m0_ack_o                               ), // Templated
    .mem_wishbone_data_i               (m0_data_o[31:0]                        ), // Templated
    .pc_wishbone_ack_i                 (m1_ack_o                               ), // Templated
    .pc_wishbone_data_i                (m1_data_o[31:0]                        ), // Templated
    .rst_n                             (rst                                    )); // Templated

// ***************************************
// SDRAM_CONTROLLER s0
// ***************************************
  /*sdrc_top AUTO_TEMPLATE (
    .wb_clk_i                          (clk                                    ),
    .wb_rst_i                          (rst                                    ),
    .sdram_clk                         (clk                                    ),
    .sdram_resetn                      (~rst                                   ),

    .wb_cti_i                          ('0                                     ),
    .wb_dat_i                          (s0_data_o[]                            ),
    .wb_dat_o                          (s0_data_i[]                            ),
    .wb_\(.*\)_i                       (s0_\1_o[]                              ),
    .wb_\(.*\)_o                       (s0_\1_i[]                              ),

   );*/

  sdrc_top u_sdrc_top (
  /*AUTOINST*/
                       // Outputs
    .wb_ack_o                          (s0_ack_i                               ), // Templated
    .wb_dat_o                          (s0_data_i[dw-1:0]                      ), // Templated
    .sdr_cke                           (sdr_cke                                ),
    .sdr_cs_n                          (sdr_cs_n                               ),
    .sdr_ras_n                         (sdr_ras_n                              ),
    .sdr_cas_n                         (sdr_cas_n                              ),
    .sdr_we_n                          (sdr_we_n                               ),
    .sdr_dqm                           (sdr_dqm[SDR_BW-1:0]                    ),
    .sdr_ba                            (sdr_ba[1:0]                            ),
    .sdr_addr                          (sdr_addr[12:0]                         ),
    .sdr_init_done                     (sdr_init_done                          ),
                       // Inouts
    .sdr_dq                            (sdr_dq[SDR_DW-1:0]                     ),
                       // Inputs
    .sdram_clk                         (clk                                    ), // Templated
    .sdram_resetn                      (~rst                                   ), // Templated
    .cfg_sdr_width                     (cfg_sdr_width[1:0]                     ),
    .cfg_colbits                       (cfg_colbits[1:0]                       ),
    .wb_rst_i                          (rst                                    ), // Templated
    .wb_clk_i                          (clk                                    ), // Templated
    .wb_stb_i                          (s0_stb_o                               ), // Templated
    .wb_addr_i                         (s0_addr_o[APP_AW-1:0]                  ), // Templated
    .wb_we_i                           (s0_we_o                                ), // Templated
    .wb_dat_i                          (s0_data_o[dw-1:0]                      ), // Templated
    .wb_sel_i                          (s0_sel_o[dw/8-1:0]                     ), // Templated
    .wb_cyc_i                          (s0_cyc_o                               ), // Templated
    .wb_cti_i                          ('0                                     ), // Templated
    .cfg_sdr_tras_d                    (cfg_sdr_tras_d[3:0]                    ),
    .cfg_sdr_trp_d                     (cfg_sdr_trp_d[3:0]                     ),
    .cfg_sdr_trcd_d                    (cfg_sdr_trcd_d[3:0]                    ),
    .cfg_sdr_en                        (cfg_sdr_en                             ),
    .cfg_req_depth                     (cfg_req_depth[1:0]                     ),
    .cfg_sdr_mode_reg                  (cfg_sdr_mode_reg[12:0]                 ),
    .cfg_sdr_cas                       (cfg_sdr_cas[2:0]                       ),
    .cfg_sdr_trcar_d                   (cfg_sdr_trcar_d[3:0]                   ),
    .cfg_sdr_twr_d                     (cfg_sdr_twr_d[3:0]                     ),
    .cfg_sdr_rfsh                      (cfg_sdr_rfsh[`SDR_RFSH_TIMER_W-1:0]    ),
    .cfg_sdr_rfmax                     (cfg_sdr_rfmax[`SDR_RFSH_ROW_CNT_W-1:0] ));

// ***************************************
// UART s1
// ***************************************
/*uart_top AUTO_TEMPLATE (
    .wb_clk_i                          (clk                                    ),
    .wb_rst_i                          (rst                                    ),
    .wb_adr_i                          (s1_addr_o[]                            ),
    .wb_dat_i                          (s1_data_o[]                            ),
    .wb_dat_o                          (s1_data_i[]                            ),
    .wb_\(.*\)_i                       (s1_\1_o[]                              ),
    .wb_\(.*\)_o                       (s1_\1_i[]                              ),
    .int_o                             (uart_intr                              ),
  );*/

uart_top
#(
    .uart_data_width                   (32                                     ),
    .uart_addr_width                   (32                                     )
)
u_uart_top (
/*AUTOINST*/
            // Outputs
    .wb_dat_o                          (s1_data_i[31:0]                        ), // Templated
    .wb_ack_o                          (s1_ack_i                               ), // Templated
    .int_o                             (uart_intr                              ), // Templated
    .stx_pad_o                         (stx_pad_o                              ),
    .rts_pad_o                         (rts_pad_o                              ),
    .dtr_pad_o                         (dtr_pad_o                              ),
    .baud_o                            (baud_o                                 ),
            // Inputs
    .wb_clk_i                          (clk                                    ), // Templated
    .wb_rst_i                          (rst                                    ), // Templated
    .wb_adr_i                          (s1_addr_o[31:0]                        ), // Templated
    .wb_dat_i                          (s1_data_o[31:0]                        ), // Templated
    .wb_we_i                           (s1_we_o                                ), // Templated
    .wb_stb_i                          (s1_stb_o                               ), // Templated
    .wb_cyc_i                          (s1_cyc_o                               ), // Templated
    .wb_sel_i                          (s1_sel_o[3:0]                          ), // Templated
    .srx_pad_i                         (srx_pad_i                              ),
    .cts_pad_i                         (cts_pad_i                              ),
    .dsr_pad_i                         (dsr_pad_i                              ),
    .ri_pad_i                          (ri_pad_i                               ),
    .dcd_pad_i                         (dcd_pad_i                              ));

// ***************************************
// GPIO s2
// ***************************************
/*gpio_top AUTO_TEMPLATE (
    .wb_clk_i                          (clk                                    ),
    .wb_rst_i                          (rst                                    ),
    .wb_adr_i                          (s2_addr_o[]                            ),
    .wb_dat_i                          (s2_data_o[]                            ),
    .wb_dat_o                          (s2_data_i[]                            ),
    .wb_inta_o                         (gpio_intr                              ),
    .wb_\(.*\)_i                       (s2_\1_o[]                              ),
    .wb_\(.*\)_o                       (s2_\1_i[]                              ),

  );*/

gpio_top
#(
    .dw                                (32                                     ),
    .aw                                (32                                     ),
    .gw                                (32                                     )
)
u_gpio_top (
/*AUTOINST*/
            // Outputs
    .wb_dat_o                          (s2_data_i[31:0]                        ), // Templated
    .wb_ack_o                          (s2_ack_i                               ), // Templated
    .wb_err_o                          (s2_err_i                               ), // Templated
    .wb_inta_o                         (gpio_intr                              ), // Templated
    .ext_pad_o                         (ext_pad_o[31:0]                        ),
    .ext_padoe_o                       (ext_padoe_o[31:0]                      ),
            // Inputs
    .wb_clk_i                          (clk                                    ), // Templated
    .wb_rst_i                          (rst                                    ), // Templated
    .wb_cyc_i                          (s2_cyc_o                               ), // Templated
    .wb_adr_i                          (s2_addr_o[31:0]                        ), // Templated
    .wb_dat_i                          (s2_data_o[31:0]                        ), // Templated
    .wb_sel_i                          (s2_sel_o[3:0]                          ), // Templated
    .wb_we_i                           (s2_we_o                                ), // Templated
    .wb_stb_i                          (s2_stb_o                               ), // Templated
    .aux_i                             (aux_i[31:0]                            ),
    .ext_pad_i                         (ext_pad_i[31:0]                        ),
    .clk_pad_i                         (clk_pad_i                              ));

// ***************************************
// FLASH s3
// ***************************************
/*flash_top AUTO_TEMPLATE (
    .wb_clk_i                          (clk                                    ),
    .wb_rst_i                          (rst                                    ),
    .wb_adr_i                          (s3_addr_o[]                            ),
    .wb_dat_i                          (s3_data_o[]                            ),
    .wb_dat_o                          (s3_data_i[]                            ),
    .wb_\(.*\)_i                       (s3_\1_o[]                              ),
    .wb_\(.*\)_o                       (s3_\1_i[]                              ),

  );*/

flash_top
#(
    .aw                                (32                                     ),
    .dw                                (32                                     )
)
u_flash_top (
/*AUTOINST*/
             // Outputs
    .wb_dat_o                          (s3_data_i[31:0]                        ), // Templated
    .wb_ack_o                          (s3_ack_i                               ), // Templated
    .flash_adr_o                       (flash_adr_o[31:0]                      ),
    .flash_rst                         (flash_rst                              ),
    .flash_oe                          (flash_oe                               ),
    .flash_ce                          (flash_ce                               ),
    .flash_we                          (flash_we                               ),
             // Inputs
    .wb_clk_i                          (clk                                    ), // Templated
    .wb_rst_i                          (rst                                    ), // Templated
    .wb_adr_i                          (s3_addr_o[31:0]                        ), // Templated
    .wb_dat_i                          (s3_data_o[31:0]                        ), // Templated
    .wb_sel_i                          (s3_sel_o[3:0]                          ), // Templated
    .wb_we_i                           (s3_we_o                                ), // Templated
    .wb_stb_i                          (s3_stb_o                               ), // Templated
    .wb_cyc_i                          (s3_cyc_o                               ), // Templated
    .flash_dat_i                       (flash_dat_i[7:0]                       ));


// ***************************************
// WB_CONMAX
// ***************************************
  /*wb_conmax_top AUTO_TEMPLATE (
    .clk_i                             (clk                                    ),
    .rst_i                             (rst                                    ),
    .m[01]_err_o                       (                                       ),
    .m[01]_rty_o                       (                                       ),
    .s[013]_err_i                      ('0                                     ),
    .s[0123]_rty_i                     ('0                                     ),

    .m[2-7].*                          (@"(if (equal vl-dir \\"input\\") \\"'0\\" \\"\\")"),
    .s[4-9].*                          (@"(if (equal vl-dir \\"input\\") \\"'0\\" \\"\\")"),
    .s1[0-5].*                         (@"(if (equal vl-dir \\"input\\") \\"'0\\" \\"\\")"),
    );*/

  wb_conmax_top
  #(
    .dw                                (32                                     ),
    .aw                                (32                                     ),
    .sw                                (4                                      )
  )
    u_wb_conmax_top (
    /*AUTOINST*/
                     // Outputs
    .m0_data_o                         (m0_data_o[31:0]                        ),
    .m0_ack_o                          (m0_ack_o                               ),
    .m0_err_o                          (                                       ), // Templated
    .m0_rty_o                          (                                       ), // Templated
    .m1_data_o                         (m1_data_o[31:0]                        ),
    .m1_ack_o                          (m1_ack_o                               ),
    .m1_err_o                          (                                       ), // Templated
    .m1_rty_o                          (                                       ), // Templated
    .m2_data_o                         (                                       ), // Templated
    .m2_ack_o                          (                                       ), // Templated
    .m2_err_o                          (                                       ), // Templated
    .m2_rty_o                          (                                       ), // Templated
    .m3_data_o                         (                                       ), // Templated
    .m3_ack_o                          (                                       ), // Templated
    .m3_err_o                          (                                       ), // Templated
    .m3_rty_o                          (                                       ), // Templated
    .m4_data_o                         (                                       ), // Templated
    .m4_ack_o                          (                                       ), // Templated
    .m4_err_o                          (                                       ), // Templated
    .m4_rty_o                          (                                       ), // Templated
    .m5_data_o                         (                                       ), // Templated
    .m5_ack_o                          (                                       ), // Templated
    .m5_err_o                          (                                       ), // Templated
    .m5_rty_o                          (                                       ), // Templated
    .m6_data_o                         (                                       ), // Templated
    .m6_ack_o                          (                                       ), // Templated
    .m6_err_o                          (                                       ), // Templated
    .m6_rty_o                          (                                       ), // Templated
    .m7_data_o                         (                                       ), // Templated
    .m7_ack_o                          (                                       ), // Templated
    .m7_err_o                          (                                       ), // Templated
    .m7_rty_o                          (                                       ), // Templated
    .s0_data_o                         (s0_data_o[31:0]                        ),
    .s0_addr_o                         (s0_addr_o[31:0]                        ),
    .s0_sel_o                          (s0_sel_o[3:0]                          ),
    .s0_we_o                           (s0_we_o                                ),
    .s0_cyc_o                          (s0_cyc_o                               ),
    .s0_stb_o                          (s0_stb_o                               ),
    .s1_data_o                         (s1_data_o[31:0]                        ),
    .s1_addr_o                         (s1_addr_o[31:0]                        ),
    .s1_sel_o                          (s1_sel_o[3:0]                          ),
    .s1_we_o                           (s1_we_o                                ),
    .s1_cyc_o                          (s1_cyc_o                               ),
    .s1_stb_o                          (s1_stb_o                               ),
    .s2_data_o                         (s2_data_o[31:0]                        ),
    .s2_addr_o                         (s2_addr_o[31:0]                        ),
    .s2_sel_o                          (s2_sel_o[3:0]                          ),
    .s2_we_o                           (s2_we_o                                ),
    .s2_cyc_o                          (s2_cyc_o                               ),
    .s2_stb_o                          (s2_stb_o                               ),
    .s3_data_o                         (s3_data_o[31:0]                        ),
    .s3_addr_o                         (s3_addr_o[31:0]                        ),
    .s3_sel_o                          (s3_sel_o[3:0]                          ),
    .s3_we_o                           (s3_we_o                                ),
    .s3_cyc_o                          (s3_cyc_o                               ),
    .s3_stb_o                          (s3_stb_o                               ),
    .s4_data_o                         (                                       ), // Templated
    .s4_addr_o                         (                                       ), // Templated
    .s4_sel_o                          (                                       ), // Templated
    .s4_we_o                           (                                       ), // Templated
    .s4_cyc_o                          (                                       ), // Templated
    .s4_stb_o                          (                                       ), // Templated
    .s5_data_o                         (                                       ), // Templated
    .s5_addr_o                         (                                       ), // Templated
    .s5_sel_o                          (                                       ), // Templated
    .s5_we_o                           (                                       ), // Templated
    .s5_cyc_o                          (                                       ), // Templated
    .s5_stb_o                          (                                       ), // Templated
    .s6_data_o                         (                                       ), // Templated
    .s6_addr_o                         (                                       ), // Templated
    .s6_sel_o                          (                                       ), // Templated
    .s6_we_o                           (                                       ), // Templated
    .s6_cyc_o                          (                                       ), // Templated
    .s6_stb_o                          (                                       ), // Templated
    .s7_data_o                         (                                       ), // Templated
    .s7_addr_o                         (                                       ), // Templated
    .s7_sel_o                          (                                       ), // Templated
    .s7_we_o                           (                                       ), // Templated
    .s7_cyc_o                          (                                       ), // Templated
    .s7_stb_o                          (                                       ), // Templated
    .s8_data_o                         (                                       ), // Templated
    .s8_addr_o                         (                                       ), // Templated
    .s8_sel_o                          (                                       ), // Templated
    .s8_we_o                           (                                       ), // Templated
    .s8_cyc_o                          (                                       ), // Templated
    .s8_stb_o                          (                                       ), // Templated
    .s9_data_o                         (                                       ), // Templated
    .s9_addr_o                         (                                       ), // Templated
    .s9_sel_o                          (                                       ), // Templated
    .s9_we_o                           (                                       ), // Templated
    .s9_cyc_o                          (                                       ), // Templated
    .s9_stb_o                          (                                       ), // Templated
    .s10_data_o                        (                                       ), // Templated
    .s10_addr_o                        (                                       ), // Templated
    .s10_sel_o                         (                                       ), // Templated
    .s10_we_o                          (                                       ), // Templated
    .s10_cyc_o                         (                                       ), // Templated
    .s10_stb_o                         (                                       ), // Templated
    .s11_data_o                        (                                       ), // Templated
    .s11_addr_o                        (                                       ), // Templated
    .s11_sel_o                         (                                       ), // Templated
    .s11_we_o                          (                                       ), // Templated
    .s11_cyc_o                         (                                       ), // Templated
    .s11_stb_o                         (                                       ), // Templated
    .s12_data_o                        (                                       ), // Templated
    .s12_addr_o                        (                                       ), // Templated
    .s12_sel_o                         (                                       ), // Templated
    .s12_we_o                          (                                       ), // Templated
    .s12_cyc_o                         (                                       ), // Templated
    .s12_stb_o                         (                                       ), // Templated
    .s13_data_o                        (                                       ), // Templated
    .s13_addr_o                        (                                       ), // Templated
    .s13_sel_o                         (                                       ), // Templated
    .s13_we_o                          (                                       ), // Templated
    .s13_cyc_o                         (                                       ), // Templated
    .s13_stb_o                         (                                       ), // Templated
    .s14_data_o                        (                                       ), // Templated
    .s14_addr_o                        (                                       ), // Templated
    .s14_sel_o                         (                                       ), // Templated
    .s14_we_o                          (                                       ), // Templated
    .s14_cyc_o                         (                                       ), // Templated
    .s14_stb_o                         (                                       ), // Templated
    .s15_data_o                        (                                       ), // Templated
    .s15_addr_o                        (                                       ), // Templated
    .s15_sel_o                         (                                       ), // Templated
    .s15_we_o                          (                                       ), // Templated
    .s15_cyc_o                         (                                       ), // Templated
    .s15_stb_o                         (                                       ), // Templated
                     // Inputs
    .clk_i                             (clk                                    ), // Templated
    .rst_i                             (rst                                    ), // Templated
    .m0_data_i                         (m0_data_i[31:0]                        ),
    .m0_addr_i                         (m0_addr_i[31:0]                        ),
    .m0_sel_i                          (m0_sel_i[3:0]                          ),
    .m0_we_i                           (m0_we_i                                ),
    .m0_cyc_i                          (m0_cyc_i                               ),
    .m0_stb_i                          (m0_stb_i                               ),
    .m1_data_i                         (m1_data_i[31:0]                        ),
    .m1_addr_i                         (m1_addr_i[31:0]                        ),
    .m1_sel_i                          (m1_sel_i[3:0]                          ),
    .m1_we_i                           (m1_we_i                                ),
    .m1_cyc_i                          (m1_cyc_i                               ),
    .m1_stb_i                          (m1_stb_i                               ),
    .m2_data_i                         ('0                                     ), // Templated
    .m2_addr_i                         ('0                                     ), // Templated
    .m2_sel_i                          ('0                                     ), // Templated
    .m2_we_i                           ('0                                     ), // Templated
    .m2_cyc_i                          ('0                                     ), // Templated
    .m2_stb_i                          ('0                                     ), // Templated
    .m3_data_i                         ('0                                     ), // Templated
    .m3_addr_i                         ('0                                     ), // Templated
    .m3_sel_i                          ('0                                     ), // Templated
    .m3_we_i                           ('0                                     ), // Templated
    .m3_cyc_i                          ('0                                     ), // Templated
    .m3_stb_i                          ('0                                     ), // Templated
    .m4_data_i                         ('0                                     ), // Templated
    .m4_addr_i                         ('0                                     ), // Templated
    .m4_sel_i                          ('0                                     ), // Templated
    .m4_we_i                           ('0                                     ), // Templated
    .m4_cyc_i                          ('0                                     ), // Templated
    .m4_stb_i                          ('0                                     ), // Templated
    .m5_data_i                         ('0                                     ), // Templated
    .m5_addr_i                         ('0                                     ), // Templated
    .m5_sel_i                          ('0                                     ), // Templated
    .m5_we_i                           ('0                                     ), // Templated
    .m5_cyc_i                          ('0                                     ), // Templated
    .m5_stb_i                          ('0                                     ), // Templated
    .m6_data_i                         ('0                                     ), // Templated
    .m6_addr_i                         ('0                                     ), // Templated
    .m6_sel_i                          ('0                                     ), // Templated
    .m6_we_i                           ('0                                     ), // Templated
    .m6_cyc_i                          ('0                                     ), // Templated
    .m6_stb_i                          ('0                                     ), // Templated
    .m7_data_i                         ('0                                     ), // Templated
    .m7_addr_i                         ('0                                     ), // Templated
    .m7_sel_i                          ('0                                     ), // Templated
    .m7_we_i                           ('0                                     ), // Templated
    .m7_cyc_i                          ('0                                     ), // Templated
    .m7_stb_i                          ('0                                     ), // Templated
    .s0_data_i                         (s0_data_i[31:0]                        ),
    .s0_ack_i                          (s0_ack_i                               ),
    .s0_err_i                          ('0                                     ), // Templated
    .s0_rty_i                          ('0                                     ), // Templated
    .s1_data_i                         (s1_data_i[31:0]                        ),
    .s1_ack_i                          (s1_ack_i                               ),
    .s1_err_i                          ('0                                     ), // Templated
    .s1_rty_i                          ('0                                     ), // Templated
    .s2_data_i                         (s2_data_i[31:0]                        ),
    .s2_ack_i                          (s2_ack_i                               ),
    .s2_err_i                          (s2_err_i                               ),
    .s2_rty_i                          ('0                                     ), // Templated
    .s3_data_i                         (s3_data_i[31:0]                        ),
    .s3_ack_i                          (s3_ack_i                               ),
    .s3_err_i                          ('0                                     ), // Templated
    .s3_rty_i                          ('0                                     ), // Templated
    .s4_data_i                         ('0                                     ), // Templated
    .s4_ack_i                          ('0                                     ), // Templated
    .s4_err_i                          ('0                                     ), // Templated
    .s4_rty_i                          ('0                                     ), // Templated
    .s5_data_i                         ('0                                     ), // Templated
    .s5_ack_i                          ('0                                     ), // Templated
    .s5_err_i                          ('0                                     ), // Templated
    .s5_rty_i                          ('0                                     ), // Templated
    .s6_data_i                         ('0                                     ), // Templated
    .s6_ack_i                          ('0                                     ), // Templated
    .s6_err_i                          ('0                                     ), // Templated
    .s6_rty_i                          ('0                                     ), // Templated
    .s7_data_i                         ('0                                     ), // Templated
    .s7_ack_i                          ('0                                     ), // Templated
    .s7_err_i                          ('0                                     ), // Templated
    .s7_rty_i                          ('0                                     ), // Templated
    .s8_data_i                         ('0                                     ), // Templated
    .s8_ack_i                          ('0                                     ), // Templated
    .s8_err_i                          ('0                                     ), // Templated
    .s8_rty_i                          ('0                                     ), // Templated
    .s9_data_i                         ('0                                     ), // Templated
    .s9_ack_i                          ('0                                     ), // Templated
    .s9_err_i                          ('0                                     ), // Templated
    .s9_rty_i                          ('0                                     ), // Templated
    .s10_data_i                        ('0                                     ), // Templated
    .s10_ack_i                         ('0                                     ), // Templated
    .s10_err_i                         ('0                                     ), // Templated
    .s10_rty_i                         ('0                                     ), // Templated
    .s11_data_i                        ('0                                     ), // Templated
    .s11_ack_i                         ('0                                     ), // Templated
    .s11_err_i                         ('0                                     ), // Templated
    .s11_rty_i                         ('0                                     ), // Templated
    .s12_data_i                        ('0                                     ), // Templated
    .s12_ack_i                         ('0                                     ), // Templated
    .s12_err_i                         ('0                                     ), // Templated
    .s12_rty_i                         ('0                                     ), // Templated
    .s13_data_i                        ('0                                     ), // Templated
    .s13_ack_i                         ('0                                     ), // Templated
    .s13_err_i                         ('0                                     ), // Templated
    .s13_rty_i                         ('0                                     ), // Templated
    .s14_data_i                        ('0                                     ), // Templated
    .s14_ack_i                         ('0                                     ), // Templated
    .s14_err_i                         ('0                                     ), // Templated
    .s14_rty_i                         ('0                                     ), // Templated
    .s15_data_i                        ('0                                     ), // Templated
    .s15_ack_i                         ('0                                     ), // Templated
    .s15_err_i                         ('0                                     ), // Templated
    .s15_rty_i                         ('0                                     )); // Templated
// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
// Local Variables:
// verilog-library-directories:("." "OpenMIPS" "flash" "gpio" "uart" "wb_conmax" "sdram_controller")
// verilog-auto-inst-param-value:t
// End:
