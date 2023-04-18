`include "defines.v"
module pc_reg
    (
    input                                        clk,
    input                                        rst_n,
    //from stall control
    input                                  [5:0] stall,
    //exception
    input                                        flush,
    input                              [`RegBus] excep_vector,
    //from id stage
    input                                        branch_flag_i,
    input                              [`RegBus] branch_target_address_i,

    output reg                                   ce,     // inst_rom enable
    output reg                    [`InstAddrBus] pc      // inst_rom address
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
    else if (flush == 1'b1)
      pc <= excep_vector;
    else if (stall[0] == `NoStop)
    begin
      if (branch_flag_i == `Branch)
        pc <= branch_target_address_i;
      else
        pc <= pc + 4'h4;
    end
  end

endmodule
