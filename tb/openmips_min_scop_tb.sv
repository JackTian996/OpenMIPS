`include "defines.v"
`timescale 1ns/1ps
module openmips_min_scop_tb ();

  reg CLOCK_50;
  reg rst;

// --------------------> CLK: 50MHz
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end

// --------------------> Rst
  initial begin
    rst = `RstEnable;
    #195 rst = `RstDisable;
    #5000 $finish;
  end

// --------------------> Inst DUT
  openmips_min_scop u_openmips_min_scop (
    /*AUTOINST*/
    // Inputs
    .clk                   (CLOCK_50),
    .rst_n                 (rst));

//----------------------------------
//gen fsdb
//----------------------------------

initial	begin
	$fsdbDumpfile("tb.fsdb");
        $fsdbDumpvars;
        $fsdbDumpMDA;
end

endmodule
