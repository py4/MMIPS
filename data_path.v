`timescale 1ns/1ns
module DataPath(input clk, mem_write_sig, push_sig, pop_sig, tos_sig, output reg z);
  
  reg[4:0] pc;
  reg[7:0] instruction;
  reg[7:0] mdr;
  reg[7:0] B_reg;
  reg[7:0] alu_out_reg;
  reg z;

  wire[7:0] data_memory_out;
  wire[7:0] stack_out;
  wire[7:0] alu_out;

  initial begin
    pc = 4'b0;
  end

  always @(clk) begin
    if(ld_pc) pc <= (pc_src == 1'b0 ? pc + 1 : instruction[4:0]);
    if(ld_B) B_reg <= stack_out;
  
    mdr <= data_memory_out;
    instruction <= data_memory_out;
    z <= (stack_out == 0);
    alu_out_reg <= alu_out;    
  end

  DataMemory data_memory(pc, stack_out, mem_write_sig, clk, data_memory_out);
  Stack stack(push_sig, pop_sig, tos_sig, clk, (stack_src == 0 ? mdr : alu_out_reg), stack_out);
  ALU alu(B_reg, stack_out, acode, alu_out); 
   
endmodule
