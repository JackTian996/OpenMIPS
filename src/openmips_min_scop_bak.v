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
      /*AUTOINPUT*/
      // Beginning of automatic inputs (from unused autoinst inputs)
    input                                        clk,                          // To u_data_ram of data_ram.v, ...
    input                                        rst_n                         // To u_data_ram of data_ram.v, ...
      // End of automatics
      /*AUTOOUTPUT*/
    );
// -----------------------------------------------------------------------------
// Constant Parameter
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signals Declarations
// -----------------------------------------------------------------------------
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire                                   [`RegBus] mem_addr_o;                   // From u_openmips of openmips.v
wire                                             mem_ce_o;                     // From u_openmips of openmips.v
wire                                  [`DataBus] mem_data_i;                   // From u_data_ram of data_ram.v
wire                                   [`RegBus] mem_data_o;                   // From u_openmips of openmips.v
wire                                       [3:0] mem_sel_o;                    // From u_openmips of openmips.v
wire                                             mem_we_o;                     // From u_openmips of openmips.v
wire                              [`InstAddrBus] rom_addr_o;                   // From u_openmips of openmips.v
wire                                             rom_ce_o;                     // From u_openmips of openmips.v
wire                                  [`InstBus] rom_data_i;                   // From u_inst_rom of inst_rom.v
// End of automatics
// -----------------------------------------------------------------------------
// Main Code
// -----------------------------------------------------------------------------
// ---->TODO
  /*inst_rom AUTO_TEMPLATE (
    .inst                              (rom_data_i[]                           ),
    .ce                                (rom_ce_o[]                             ),
    .addr                              (rom_addr_o[]                           ),
    );*/

  inst_rom
  #(
    .REG_OUT                           (0                                      )
  )
  u_inst_rom (
    /*AUTOINST*/
                       // Outputs
    .inst                              (rom_data_i[`InstBus]                   ), // Templated
                       // Inputs
    .ce                                (rom_ce_o                               ), // Templated
    .addr                              (rom_addr_o[`InstAddrBus]               )); // Templated

/*data_ram AUTO_TEMPLATE (
    .ce                                (mem_ce_o                               ),
    .we                                (mem_we_o                               ),
    .addr                              (mem_addr_o[]                           ),
    .sel                               (mem_sel_o[]                            ),
    .data_i                            (mem_data_o[]                           ),
    .data_o                            (mem_data_i[]                           ),
  );*/
  data_ram
  (
    .REG_OUT                           (0                                      )
  )
    u_data_ram (
    /*AUTOINST*/
                       // Outputs
    .data_o                            (mem_data_i[`DataBus]                   ), // Templated
                       // Inputs
    .clk                               (clk                                    ),
    .ce                                (mem_ce_o                               ), // Templated
    .we                                (mem_we_o                               ), // Templated
    .addr                              (mem_addr_o[`DataAddrBus]               ), // Templated
    .sel                               (mem_sel_o[3:0]                         ), // Templated
    .data_i                            (mem_data_o[`DataBus]                   )); // Templated

  openmips u_openmips (
    /*AUTOINST*/
                       // Outputs
    .rom_ce_o                          (rom_ce_o                               ),
    .rom_addr_o                        (rom_addr_o[`InstAddrBus]               ),
    .mem_addr_o                        (mem_addr_o[`RegBus]                    ),
    .mem_ce_o                          (mem_ce_o                               ),
    .mem_data_o                        (mem_data_o[`RegBus]                    ),
    .mem_sel_o                         (mem_sel_o[3:0]                         ),
    .mem_we_o                          (mem_we_o                               ),
                       // Inputs
    .clk                               (clk                                    ),
    .mem_data_i                        (mem_data_i[`RegBus]                    ),
    .rom_data_i                        (rom_data_i[`InstBus]                   ),
    .rst_n                             (rst_n                                  ));
// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
