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

module openmips_min_scop_sram_top
    (
    /*AUTOINOUT*/
      /*AUTOINPUT*/
      // Beginning of automatic inputs (from unused autoinst inputs)
    input                                        clk,                          // To u_openmips_min_scop of openmips_min_scop_sram.v, ...
    input                                 [15:0] gpio_i,                       // To u_openmips_min_scop of openmips_min_scop_sram.v
    input                                        rst_n,                        // To u_openmips_min_scop of openmips_min_scop_sram.v, ...
    input                                        uart_rx,                      // To u_openmips_min_scop of openmips_min_scop_sram.v
      // End of automatics
      /*AUTOOUTPUT*/
      // Beginning of automatic outputs (from unused autoinst outputs)
    output                                [31:0] gpio_o,                       // From u_openmips_min_scop of openmips_min_scop_sram.v
    output                                       uart_tx                       // From u_openmips_min_scop of openmips_min_scop_sram.v
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
wire                                      [31:0] data_ram_addr_o;              // From u_openmips_min_scop of openmips_min_scop_sram.v
wire                                             data_ram_ce_o;                // From u_openmips_min_scop of openmips_min_scop_sram.v
wire                                  [`DataBus] data_ram_data_i;              // From u_data_ram of data_ram.v
wire                                      [31:0] data_ram_data_o;              // From u_openmips_min_scop of openmips_min_scop_sram.v
wire                                       [3:0] data_ram_sel_o;               // From u_openmips_min_scop of openmips_min_scop_sram.v
wire                                             data_ram_we_o;                // From u_openmips_min_scop of openmips_min_scop_sram.v
wire                                      [31:0] inst_ram_addr_o;              // From u_openmips_min_scop of openmips_min_scop_sram.v
wire                                             inst_ram_ce_o;                // From u_openmips_min_scop of openmips_min_scop_sram.v
wire                                  [`InstBus] inst_ram_data_i;              // From u_inst_rom of inst_rom.v
// End of automatics
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
/*openmips_min_scop_sram AUTO_TEMPLATE (
    .inst_ram_we_o                     (                                       ),
    .inst_ram_data_o                   (                                       ),
    .inst_ram_sel_o                    (                                       ),
  );*/

openmips_min_scop_sram u_openmips_min_scop (
/*AUTOINST*/
                                            // Outputs
    .data_ram_addr_o                   (data_ram_addr_o[31:0]                  ),
    .data_ram_ce_o                     (data_ram_ce_o                          ),
    .data_ram_data_o                   (data_ram_data_o[31:0]                  ),
    .data_ram_sel_o                    (data_ram_sel_o[3:0]                    ),
    .data_ram_we_o                     (data_ram_we_o                          ),
    .gpio_o                            (gpio_o[31:0]                           ),
    .inst_ram_addr_o                   (inst_ram_addr_o[31:0]                  ),
    .inst_ram_ce_o                     (inst_ram_ce_o                          ),
    .inst_ram_data_o                   (                                       ), // Templated
    .inst_ram_sel_o                    (                                       ), // Templated
    .inst_ram_we_o                     (                                       ), // Templated
    .uart_tx                           (uart_tx                                ),
                                            // Inputs
    .clk                               (clk                                    ),
    .data_ram_data_i                   (data_ram_data_i[31:0]                  ),
    .gpio_i                            (gpio_i[15:0]                           ),
    .inst_ram_data_i                   (inst_ram_data_i[31:0]                  ),
    .rst_n                             (rst_n                                  ),
    .uart_rx                           (uart_rx                                ));

/*data_ram AUTO_TEMPLATE (
    .ce                                (data_ram_ce_o                          ),
    .we                                (data_ram_we_o                          ),
    .addr                              (data_ram_addr_o[]                      ),
    .sel                               (data_ram_sel_o[]                       ),
    .data_i                            (data_ram_data_o[]                      ),
    .data_o                            (data_ram_data_i[]                      ),
  );*/
  data_ram u_data_ram (
  /*AUTOINST*/
                       // Outputs
    .data_o                            (data_ram_data_i[`DataBus]              ), // Templated
                       // Inputs
    .clk                               (clk                                    ),
    .rst_n                             (rst_n                                  ),
    .ce                                (data_ram_ce_o                          ), // Templated
    .we                                (data_ram_we_o                          ), // Templated
    .addr                              (data_ram_addr_o[`DataAddrBus]          ), // Templated
    .sel                               (data_ram_sel_o[3:0]                    ), // Templated
    .data_i                            (data_ram_data_o[`DataBus]              )); // Templated

  /*inst_rom AUTO_TEMPLATE (
    .inst                              (inst_ram_data_i[]                      ),
    .ce                                (inst_ram_ce_o[]                        ),
    .addr                              (inst_ram_addr_o[]                      ),
    );*/

  inst_rom u_inst_rom (
    /*AUTOINST*/
                       // Outputs
    .inst                              (inst_ram_data_i[`InstBus]              ), // Templated
                       // Inputs
    .ce                                (inst_ram_ce_o                          ), // Templated
    .addr                              (inst_ram_addr_o[`InstAddrBus]          )); // Templated

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
