// ---********************************************************************------
// Copyright 2020-2030 (c) None, Inc. All rights reserved.
// Module Name:   openmips_min_scop_sram.v
// Author     :   tianshuo2415@firefox.com
// Project Name:  OPEN_MIPS
// Create Date:   2023-03-14
// Description:
//
// ---********************************************************************------
`include "defines.v"
`include "gpio_defines.v"
`include "uart_defines.v"
`include "wb_conmax_defines.v"

module openmips_min_scop_sram
    (
    /*AUTOINOUT*/
      /*AUTOINPUT*/
      // Beginning of automatic inputs (from unused autoinst inputs)
    input                                        clk,                          // To u_openmips of openmips.v, ...
    input                                 [31:0] data_ram_data_i,              // To u_data_wb_bridge of wishbone2ram_sync_bridge.v
    input                                 [15:0] gpio_i,                       // To u_gpio_top of gpio_top.v
    input                                 [31:0] inst_ram_data_i,              // To u_inst_wb_bridge of wishbone2ram_sync_bridge.v
    input                                        rst_n,                        // To u_openmips of openmips.v, ...
    input                                        uart_rx,                      // To u_uart_top of uart_top.v
      // End of automatics
      /*AUTOOUTPUT*/
      // Beginning of automatic outputs (from unused autoinst outputs)
    output                                [31:0] data_ram_addr_o,              // From u_data_wb_bridge of wishbone2ram_sync_bridge.v
    output                                       data_ram_ce_o,                // From u_data_wb_bridge of wishbone2ram_sync_bridge.v
    output                                [31:0] data_ram_data_o,              // From u_data_wb_bridge of wishbone2ram_sync_bridge.v
    output                                 [3:0] data_ram_sel_o,               // From u_data_wb_bridge of wishbone2ram_sync_bridge.v
    output                                       data_ram_we_o,                // From u_data_wb_bridge of wishbone2ram_sync_bridge.v
    output                                [31:0] gpio_o,                       // From u_gpio_top of gpio_top.v
    output                                [31:0] inst_ram_addr_o,              // From u_inst_wb_bridge of wishbone2ram_sync_bridge.v
    output                                       inst_ram_ce_o,                // From u_inst_wb_bridge of wishbone2ram_sync_bridge.v
    output                                [31:0] inst_ram_data_o,              // From u_inst_wb_bridge of wishbone2ram_sync_bridge.v
    output                                 [3:0] inst_ram_sel_o,               // From u_inst_wb_bridge of wishbone2ram_sync_bridge.v
    output                                       inst_ram_we_o,                // From u_inst_wb_bridge of wishbone2ram_sync_bridge.v
    output                                       uart_tx                       // From u_uart_top of uart_top.v
      // End of automatics
    );

// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
wire                                             sdr_init_done;
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
wire                                             s0_ack_i;                     // From u_data_wb_bridge of wishbone2ram_sync_bridge.v
wire                                      [31:0] s0_addr_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s0_cyc_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [31:0] s0_data_i;                    // From u_data_wb_bridge of wishbone2ram_sync_bridge.v
wire                                      [31:0] s0_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                       [3:0] s0_sel_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s0_stb_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s0_we_o;                      // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s1_ack_i;                     // From u_uart_top of uart_top.v
wire                                       [4:0] s1_addr_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s1_cyc_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [31:0] s1_data_i;                    // From u_uart_top of uart_top.v
wire                                      [31:0] s1_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                       [3:0] s1_sel_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s1_stb_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s1_we_o;                      // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_ack_i;                     // From u_gpio_top of gpio_top.v
wire                                       [7:0] s2_addr_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_cyc_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [31:0] s2_data_i;                    // From u_gpio_top of gpio_top.v
wire                                      [31:0] s2_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_err_i;                     // From u_gpio_top of gpio_top.v
wire                                       [3:0] s2_sel_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_stb_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s2_we_o;                      // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s3_ack_i;                     // From u_inst_wb_bridge of wishbone2ram_sync_bridge.v
wire                                      [31:0] s3_addr_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s3_cyc_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [31:0] s3_data_i;                    // From u_inst_wb_bridge of wishbone2ram_sync_bridge.v
wire                                      [31:0] s3_data_o;                    // From u_wb_conmax_top of wb_conmax_top.v
wire                                       [3:0] s3_sel_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s3_stb_o;                     // From u_wb_conmax_top of wb_conmax_top.v
wire                                             s3_we_o;                      // From u_wb_conmax_top of wb_conmax_top.v
wire                                             timer_intr;                   // From u_openmips of openmips.v
wire                                             uart_intr;                    // From u_uart_top of uart_top.v
wire                                      [26:0] unused_s1_addr_o;             // From u_wb_conmax_top of wb_conmax_top.v
wire                                      [23:0] unused_s2_addr_o;             // From u_wb_conmax_top of wb_conmax_top.v
// End of automatics
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ***************************************
// OpenMIPS : mem->m0 pc->m1
// ***************************************
// -------------------->WB_ADDR_WIDTH = 32
// -------------------->WB_DATA_WIDTH = 32

  /*openmips AUTO_TEMPLATE (
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .mem_wishbone_\(.*\)_o             (m0_\1_i[]                              ),
    .mem_wishbone_\(.*\)_i             (m0_\1_o[]                              ),
    .pc_wishbone_\(.*\)_o              (m1_\1_i[]                              ),
    .pc_wishbone_\(.*\)_i              (m1_\1_o[]                              ),
    .timer_intr_o                      (timer_intr                             ),
    .intr_i                            ({3'b000,gpio_intr,uart_intr,timer_intr} ),
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
    .intr_i                            ({3'b000,gpio_intr,uart_intr,timer_intr} ), // Templated
    .mem_wishbone_ack_i                (m0_ack_o                               ), // Templated
    .mem_wishbone_data_i               (m0_data_o[31:0]                        ), // Templated
    .pc_wishbone_ack_i                 (m1_ack_o                               ), // Templated
    .pc_wishbone_data_i                (m1_data_o[31:0]                        ), // Templated
    .rst_n                             (rst_n                                  )); // Templated

// ***************************************
// data sram
// ***************************************
// --------------------> WB_ADDR_WIDTH = 32
// --------------------> WB_DATA_WIDTH = 32

// fake sdram initial done signal
assign sdr_init_done         = 1'b1;

  /*wishbone2ram_sync_bridge AUTO_TEMPLATE (
    .wishbone_\(.*\)_i                 (s0_\1_o[]                              ),
    .wishbone_\(.*\)_o                 (s0_\1_i[]                              ),
    .ram.*                             (data_@"vl-name"[]                      ),
    );*/

wishbone2ram_sync_bridge
#(
    .ADDR_WIDTH                        (32                                     ),
    .DATA_WIDTH                        (32                                     ),
    .SEL_WIDTH                         (4                                      ),
	 .READ_LATENCY                      (2                                      ),
	 .WRITE_LATENCY                     (1                                      )
)
u_data_wb_bridge (
/*AUTOINST*/
                  // Outputs
    .ram_ce_o                          (data_ram_ce_o                          ), // Templated
    .ram_we_o                          (data_ram_we_o                          ), // Templated
    .ram_addr_o                        (data_ram_addr_o[31:0]                  ), // Templated
    .ram_data_o                        (data_ram_data_o[31:0]                  ), // Templated
    .ram_sel_o                         (data_ram_sel_o[3:0]                    ), // Templated
    .wishbone_data_o                   (s0_data_i[31:0]                        ), // Templated
    .wishbone_ack_o                    (s0_ack_i                               ), // Templated
                  // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .ram_data_i                        (data_ram_data_i[31:0]                  ), // Templated
    .wishbone_cyc_i                    (s0_cyc_o                               ), // Templated
    .wishbone_stb_i                    (s0_stb_o                               ), // Templated
    .wishbone_we_i                     (s0_we_o                                ), // Templated
    .wishbone_addr_i                   (s0_addr_o[31:0]                        ), // Templated
    .wishbone_data_i                   (s0_data_o[31:0]                        ), // Templated
    .wishbone_sel_i                    (s0_sel_o[3:0]                          )); // Templated

// ***************************************
// UART s1
// ***************************************
// --------------------> WB_ADDR_WIDTH = 5
// --------------------> WB_DATA_WIDTH = 32

/*uart_top AUTO_TEMPLATE (
    .wb_clk_i                          (clk                                    ),
    .wb_rst_i                          (~rst_n                                 ),
    .wb_adr_i                          (s1_addr_o[4:0]                         ),
    .wb_dat_i                          (s1_data_o[]                            ),
    .wb_dat_o                          (s1_data_i[]                            ),
    .wb_\(.*\)_i                       (s1_\1_o[]                              ),
    .wb_\(.*\)_o                       (s1_\1_i[]                              ),
    .int_o                             (uart_intr                              ),
    .stx_pad_o                         (uart_tx[]                              ),
    .srx_pad_i                         (uart_rx[]                              ),
    ..*                                (@"(if (equal vl-dir \\"input\\") (concat \\"{\\" (concat vl-width \\"{1'b0}}\\")) \\"\\")"),
  );*/

uart_top
#(
    .uart_data_width                   (32                                     ),
    .uart_addr_width                   (5                                      )
)
u_uart_top (
/*AUTOINST*/
            // Outputs
    .wb_dat_o                          (s1_data_i[31:0]                        ), // Templated
    .wb_ack_o                          (s1_ack_i                               ), // Templated
    .int_o                             (uart_intr                              ), // Templated
    .stx_pad_o                         (uart_tx                                ), // Templated
    .rts_pad_o                         (                                       ), // Templated
    .dtr_pad_o                         (                                       ), // Templated
    //.baud_o                            (                                       ), // Templated
            // Inputs
    .wb_clk_i                          (clk                                    ), // Templated
    .wb_rst_i                          (~rst_n                                 ), // Templated
    .wb_adr_i                          (s1_addr_o[4:0]                         ), // Templated
    .wb_dat_i                          (s1_data_o[31:0]                        ), // Templated
    .wb_we_i                           (s1_we_o                                ), // Templated
    .wb_stb_i                          (s1_stb_o                               ), // Templated
    .wb_cyc_i                          (s1_cyc_o                               ), // Templated
    .wb_sel_i                          (s1_sel_o[3:0]                          ), // Templated
    .srx_pad_i                         (uart_rx                                ), // Templated
    .cts_pad_i                         ({1{1'b0}}                              ), // Templated
    .dsr_pad_i                         ({1{1'b0}}                              ), // Templated
    .ri_pad_i                          ({1{1'b0}}                              ), // Templated
    .dcd_pad_i                         ({1{1'b0}}                              )); // Templated

// ***************************************
// GPIO s2
// ***************************************
// --------------------> WB_ADDR_WIDTH = 8
// --------------------> WB_DATA_WIDTH = 32
// --------------------> GPIO_PIN = 32

/*gpio_top AUTO_TEMPLATE (
    .wb_clk_i                          (clk                                    ),
    .wb_rst_i                          (~rst_n                                 ),
    .wb_adr_i                          (s2_addr_o[7:0]                         ),
    .wb_dat_i                          (s2_data_o[]                            ),
    .wb_dat_o                          (s2_data_i[]                            ),
    .wb_inta_o                         (gpio_intr                              ),
    .wb_\(.*\)_i                       (s2_\1_o[]                              ),
    .wb_\(.*\)_o                       (s2_\1_i[]                              ),
    .ext_pad_i                         ({15'b0,sdr_init_done,gpio_i[15:0]}     ),
    .ext_pad_o                         (gpio_o[]                               ),
    .ext_padoe_o                       (                                       ),
    .aux_i                             ({@"vl-width"{1'b0}}                    ),
    .clk_pad_i                         ({@"vl-width"{1'b0}}                    ),
  );*/

gpio_top
#(
    .dw                                (32                                     ),
    .aw                                (8                                      ),
    .gw                                (32                                     )
)
u_gpio_top (
/*AUTOINST*/
            // Outputs
    .wb_dat_o                          (s2_data_i[31:0]                        ), // Templated
    .wb_ack_o                          (s2_ack_i                               ), // Templated
    .wb_err_o                          (s2_err_i                               ), // Templated
    .wb_inta_o                         (gpio_intr                              ), // Templated
    .ext_pad_o                         (gpio_o[31:0]                           ), // Templated
    .ext_padoe_o                       (                                       ), // Templated
            // Inputs
    .wb_clk_i                          (clk                                    ), // Templated
    .wb_rst_i                          (~rst_n                                 ), // Templated
    .wb_cyc_i                          (s2_cyc_o                               ), // Templated
    .wb_adr_i                          (s2_addr_o[7:0]                         ), // Templated
    .wb_dat_i                          (s2_data_o[31:0]                        ), // Templated
    .wb_sel_i                          (s2_sel_o[3:0]                          ), // Templated
    .wb_we_i                           (s2_we_o                                ), // Templated
    .wb_stb_i                          (s2_stb_o                               ), // Templated
    //.aux_i                             ({32{1'b0}}                             ), // Templated
    .ext_pad_i                         ({15'b0,sdr_init_done,gpio_i[15:0]}     )); // Templated
    //.clk_pad_i                         ({1{1'b0}}                              )); // Templated

// ***************************************
// instruction sram s3
// ***************************************
// --------------------> WB_ADDR_WIDTH = 32
// --------------------> WB_DATA_WIDTH = 32

  /*wishbone2ram_sync_bridge AUTO_TEMPLATE (
    .wishbone_\(.*\)_i                 (s3_\1_o[]                              ),
    .wishbone_\(.*\)_o                 (s3_\1_i[]                              ),
    .ram.*                             (inst_@"vl-name"[]                      ),
    );*/

wishbone2ram_sync_bridge
#(
    .ADDR_WIDTH                        (32                                     ),
    .DATA_WIDTH                        (32                                     ),
    .SEL_WIDTH                         (4                                      ),
    .READ_LATENCY                      (1                                      ),
	 .WRITE_LATENCY                     (1                                      )
)
u_inst_wb_bridge (
/*AUTOINST*/
                  // Outputs
    .ram_ce_o                          (inst_ram_ce_o                          ), // Templated
    .ram_we_o                          (inst_ram_we_o                          ), // Templated
    .ram_addr_o                        (inst_ram_addr_o[31:0]                  ), // Templated
    .ram_data_o                        (inst_ram_data_o[31:0]                  ), // Templated
    .ram_sel_o                         (inst_ram_sel_o[3:0]                    ), // Templated
    .wishbone_data_o                   (s3_data_i[31:0]                        ), // Templated
    .wishbone_ack_o                    (s3_ack_i                               ), // Templated
                  // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .ram_data_i                        (inst_ram_data_i[31:0]                  ), // Templated
    .wishbone_cyc_i                    (s3_cyc_o                               ), // Templated
    .wishbone_stb_i                    (s3_stb_o                               ), // Templated
    .wishbone_we_i                     (s3_we_o                                ), // Templated
    .wishbone_addr_i                   (s3_addr_o[31:0]                        ), // Templated
    .wishbone_data_i                   (s3_data_o[31:0]                        ), // Templated
    .wishbone_sel_i                    (s3_sel_o[3:0]                          )); // Templated


// ***************************************
// WB_CONMAX
// ***************************************
  /*wb_conmax_top AUTO_TEMPLATE (
    .clk_i                             (clk                                    ),
    .rst_i                             (~rst_n                                 ),

    .s0_addr_o                         (s0_addr_o[]                            ),
    .s1_addr_o                         ({unused_s1_addr_o[26:0],s1_addr_o[4:0]} ),
    .s2_addr_o                         ({unused_s2_addr_o[23:0],s2_addr_o[7:0]} ),
    .m[01]_err_o                       (                                       ),
    .m[01]_rty_o                       (                                       ),
    .s[013]_err_i                      ({@"vl-width"{1'b0}}                    ),
    .s[0123]_rty_i                     ({@"vl-width"{1'b0}}                    ),

    .m[2-7].*                          (@"(if (equal vl-dir \\"input\\") (concat \\"{\\" (concat vl-width \\"{1'b0}}\\")) \\"\\")"),
    .s[4-9].*                          (@"(if (equal vl-dir \\"input\\") (concat \\"{\\" (concat vl-width \\"{1'b0}}\\")) \\"\\")"),
    .s1[0-5].*                         (@"(if (equal vl-dir \\"input\\") (concat \\"{\\" (concat vl-width \\"{1'b0}}\\")) \\"\\")"),
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
    .s0_addr_o                         (s0_addr_o[31:0]                        ), // Templated
    .s0_sel_o                          (s0_sel_o[3:0]                          ),
    .s0_we_o                           (s0_we_o                                ),
    .s0_cyc_o                          (s0_cyc_o                               ),
    .s0_stb_o                          (s0_stb_o                               ),
    .s1_data_o                         (s1_data_o[31:0]                        ),
    .s1_addr_o                         ({unused_s1_addr_o[26:0],s1_addr_o[4:0]} ), // Templated
    .s1_sel_o                          (s1_sel_o[3:0]                          ),
    .s1_we_o                           (s1_we_o                                ),
    .s1_cyc_o                          (s1_cyc_o                               ),
    .s1_stb_o                          (s1_stb_o                               ),
    .s2_data_o                         (s2_data_o[31:0]                        ),
    .s2_addr_o                         ({unused_s2_addr_o[23:0],s2_addr_o[7:0]} ), // Templated
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
    .rst_i                             (~rst_n                                 ), // Templated
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
    .m2_data_i                         ({32{1'b0}}                             ), // Templated
    .m2_addr_i                         ({32{1'b0}}                             ), // Templated
    .m2_sel_i                          ({4{1'b0}}                              ), // Templated
    .m2_we_i                           ({1{1'b0}}                              ), // Templated
    .m2_cyc_i                          ({1{1'b0}}                              ), // Templated
    .m2_stb_i                          ({1{1'b0}}                              ), // Templated
    .m3_data_i                         ({32{1'b0}}                             ), // Templated
    .m3_addr_i                         ({32{1'b0}}                             ), // Templated
    .m3_sel_i                          ({4{1'b0}}                              ), // Templated
    .m3_we_i                           ({1{1'b0}}                              ), // Templated
    .m3_cyc_i                          ({1{1'b0}}                              ), // Templated
    .m3_stb_i                          ({1{1'b0}}                              ), // Templated
    .m4_data_i                         ({32{1'b0}}                             ), // Templated
    .m4_addr_i                         ({32{1'b0}}                             ), // Templated
    .m4_sel_i                          ({4{1'b0}}                              ), // Templated
    .m4_we_i                           ({1{1'b0}}                              ), // Templated
    .m4_cyc_i                          ({1{1'b0}}                              ), // Templated
    .m4_stb_i                          ({1{1'b0}}                              ), // Templated
    .m5_data_i                         ({32{1'b0}}                             ), // Templated
    .m5_addr_i                         ({32{1'b0}}                             ), // Templated
    .m5_sel_i                          ({4{1'b0}}                              ), // Templated
    .m5_we_i                           ({1{1'b0}}                              ), // Templated
    .m5_cyc_i                          ({1{1'b0}}                              ), // Templated
    .m5_stb_i                          ({1{1'b0}}                              ), // Templated
    .m6_data_i                         ({32{1'b0}}                             ), // Templated
    .m6_addr_i                         ({32{1'b0}}                             ), // Templated
    .m6_sel_i                          ({4{1'b0}}                              ), // Templated
    .m6_we_i                           ({1{1'b0}}                              ), // Templated
    .m6_cyc_i                          ({1{1'b0}}                              ), // Templated
    .m6_stb_i                          ({1{1'b0}}                              ), // Templated
    .m7_data_i                         ({32{1'b0}}                             ), // Templated
    .m7_addr_i                         ({32{1'b0}}                             ), // Templated
    .m7_sel_i                          ({4{1'b0}}                              ), // Templated
    .m7_we_i                           ({1{1'b0}}                              ), // Templated
    .m7_cyc_i                          ({1{1'b0}}                              ), // Templated
    .m7_stb_i                          ({1{1'b0}}                              ), // Templated
    .s0_data_i                         (s0_data_i[31:0]                        ),
    .s0_ack_i                          (s0_ack_i                               ),
    .s0_err_i                          ({1{1'b0}}                              ), // Templated
    .s0_rty_i                          ({1{1'b0}}                              ), // Templated
    .s1_data_i                         (s1_data_i[31:0]                        ),
    .s1_ack_i                          (s1_ack_i                               ),
    .s1_err_i                          ({1{1'b0}}                              ), // Templated
    .s1_rty_i                          ({1{1'b0}}                              ), // Templated
    .s2_data_i                         (s2_data_i[31:0]                        ),
    .s2_ack_i                          (s2_ack_i                               ),
    .s2_err_i                          (s2_err_i                               ),
    .s2_rty_i                          ({1{1'b0}}                              ), // Templated
    .s3_data_i                         (s3_data_i[31:0]                        ),
    .s3_ack_i                          (s3_ack_i                               ),
    .s3_err_i                          ({1{1'b0}}                              ), // Templated
    .s3_rty_i                          ({1{1'b0}}                              ), // Templated
    .s4_data_i                         ({32{1'b0}}                             ), // Templated
    .s4_ack_i                          ({1{1'b0}}                              ), // Templated
    .s4_err_i                          ({1{1'b0}}                              ), // Templated
    .s4_rty_i                          ({1{1'b0}}                              ), // Templated
    .s5_data_i                         ({32{1'b0}}                             ), // Templated
    .s5_ack_i                          ({1{1'b0}}                              ), // Templated
    .s5_err_i                          ({1{1'b0}}                              ), // Templated
    .s5_rty_i                          ({1{1'b0}}                              ), // Templated
    .s6_data_i                         ({32{1'b0}}                             ), // Templated
    .s6_ack_i                          ({1{1'b0}}                              ), // Templated
    .s6_err_i                          ({1{1'b0}}                              ), // Templated
    .s6_rty_i                          ({1{1'b0}}                              ), // Templated
    .s7_data_i                         ({32{1'b0}}                             ), // Templated
    .s7_ack_i                          ({1{1'b0}}                              ), // Templated
    .s7_err_i                          ({1{1'b0}}                              ), // Templated
    .s7_rty_i                          ({1{1'b0}}                              ), // Templated
    .s8_data_i                         ({32{1'b0}}                             ), // Templated
    .s8_ack_i                          ({1{1'b0}}                              ), // Templated
    .s8_err_i                          ({1{1'b0}}                              ), // Templated
    .s8_rty_i                          ({1{1'b0}}                              ), // Templated
    .s9_data_i                         ({32{1'b0}}                             ), // Templated
    .s9_ack_i                          ({1{1'b0}}                              ), // Templated
    .s9_err_i                          ({1{1'b0}}                              ), // Templated
    .s9_rty_i                          ({1{1'b0}}                              ), // Templated
    .s10_data_i                        ({32{1'b0}}                             ), // Templated
    .s10_ack_i                         ({1{1'b0}}                              ), // Templated
    .s10_err_i                         ({1{1'b0}}                              ), // Templated
    .s10_rty_i                         ({1{1'b0}}                              ), // Templated
    .s11_data_i                        ({32{1'b0}}                             ), // Templated
    .s11_ack_i                         ({1{1'b0}}                              ), // Templated
    .s11_err_i                         ({1{1'b0}}                              ), // Templated
    .s11_rty_i                         ({1{1'b0}}                              ), // Templated
    .s12_data_i                        ({32{1'b0}}                             ), // Templated
    .s12_ack_i                         ({1{1'b0}}                              ), // Templated
    .s12_err_i                         ({1{1'b0}}                              ), // Templated
    .s12_rty_i                         ({1{1'b0}}                              ), // Templated
    .s13_data_i                        ({32{1'b0}}                             ), // Templated
    .s13_ack_i                         ({1{1'b0}}                              ), // Templated
    .s13_err_i                         ({1{1'b0}}                              ), // Templated
    .s13_rty_i                         ({1{1'b0}}                              ), // Templated
    .s14_data_i                        ({32{1'b0}}                             ), // Templated
    .s14_ack_i                         ({1{1'b0}}                              ), // Templated
    .s14_err_i                         ({1{1'b0}}                              ), // Templated
    .s14_rty_i                         ({1{1'b0}}                              ), // Templated
    .s15_data_i                        ({32{1'b0}}                             ), // Templated
    .s15_ack_i                         ({1{1'b0}}                              ), // Templated
    .s15_err_i                         ({1{1'b0}}                              ), // Templated
    .s15_rty_i                         ({1{1'b0}}                              )); // Templated
// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
// Local Variables:
// verilog-library-flags:("-f ../verification/file.lst")
// verilog-auto-inst-param-value:t
// verilog-auto-output-ignore-regexp: ""
// eval:(setq verilog-auto-output-ignore-regexp (concat
// "^\\("
// "unused.*"
// "\\|unconnected.*"
// "\\)$"
// ))
// eval:(verilog-read-defines)
// eval:(verilog-read-includes)
// End:
