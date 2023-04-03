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
    input                                        clk,                          // To u_openmips of openmips.v
    input                                        rst_n                         // To u_openmips of openmips.v
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

  inst_rom u_inst_rom (
    /*AUTOINST*/
                       // Outputs
    .inst                              (rom_data_i[`InstBus]                   ), // Templated
                       // Inputs
    .ce                                (rom_ce_o                               ), // Templated
    .addr                              (rom_addr_o[`InstAddrBus]               )); // Templated 

  openmips u_openmips (
    /*AUTOINST*/
                       // Outputs
    .rom_addr_o                        (rom_addr_o[`InstAddrBus]               ), 
    .rom_ce_o                          (rom_ce_o                               ), 
                       // Inputs
    .clk                               (clk                                    ), 
    .rom_data_i                        (rom_data_i[`InstBus]                   ), 
    .rst_n                             (rst_n                                  )); 
// -----------------------------------------------------------------------------
// Assertion Declarations
// -----------------------------------------------------------------------------
`ifdef SOC_ASSERT_ON

`endif
endmodule

// ---********************************************************************------
