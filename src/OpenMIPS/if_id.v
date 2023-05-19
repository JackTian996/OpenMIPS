`include "defines.v"
module if_id (
  input                           clk,
  input                           rst_n,
  input            [`InstAddrBus] if_pc,
  input                [`InstBus] if_inst,
  input                           if_rom_ce,
  input                     [5:0] stall,
  //exception flush
  input                           flush,

  output reg       [`InstAddrBus] id_pc,
  output reg           [`InstBus] id_inst,
  output reg                      id_rom_ce
);

  always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == `RstEnable)
    begin
      id_pc        <= `ZeroWord;
      id_inst      <= `ZeroWord;
      id_rom_ce    <= `ChipDisable;
    end
    else if (flush == 1'b1)
    begin
      id_pc        <= `ZeroWord;
      id_inst      <= `ZeroWord;
      id_rom_ce    <= `ChipDisable;
    end
    else if ((stall[1] == `Stop) && (stall[2] == `NoStop))
    begin
      id_pc        <= `ZeroWord;
      id_inst      <= `ZeroWord;
      id_rom_ce    <= `ChipDisable;
    end
    else if (stall[1] == `NoStop)
    begin
      id_pc        <= if_pc;
      id_inst      <= if_inst;
      id_rom_ce    <= if_rom_ce;
    end
  end

endmodule
