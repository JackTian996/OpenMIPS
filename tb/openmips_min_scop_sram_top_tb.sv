`include "defines.v"
`timescale 1ns/1ps
module openmips_min_scop_sram_top_tb ();

  reg CLOCK_50;
  reg rst_n;
  wire [31:0] gpio_o;
  wire uart_tx;
// --------------------> CLK: 50MHz
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end

// --------------------> Rst
  initial begin
    rst_n = `RstEnable;
    #195 rst_n = `RstDisable;
    #5000000 $finish;
  end

// --------------------> Inst DUT
  openmips_min_scop_sram_top u_openmips_min_scop (
    /*input                                        */  .clk     (CLOCK_50),
    /*input                                 [15:0] */  .gpio_i  (16'b0),
    /*input                                        */  .rst_n   (rst_n),
    /*input                                        */  .uart_rx (1'b0),
    /*output                                [31:0] */  .gpio_o  (gpio_o[31:0]),
    /*output                                       */  .uart_tx (uart_tx)
  );

//----------------------------------
//gen fsdb
//----------------------------------

initial	begin
	$fsdbDumpfile("tb.fsdb");
        $fsdbDumpvars;
        $fsdbDumpMDA;
end

endmodule
