`include "defines.v"
module pc_reg
    (
    input                                        clk,
    input                                        rst_n,
    input                                  [5:0] stall,
    output reg                                   ce,
    output reg                    [`InstAddrBus] pc
    );

  always @(posedge clk)
  begin : CE_PROC
    if (rst_n == `RstEnable)
      ce <= `ChipDisable;
    else if (ce == `ChipDisable)
      ce <= `ChipEnable;
  end

  always @(posedge clk)
  begin : PC_PROC
    if (ce == `ChipDisable)
      pc <= 32'h0;
    else if (stall[0] == `NoStop)
      pc <= pc + 4'h4;
  end

endmodule
