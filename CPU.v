`timescale 1ns/1ns
module CPU(input clk);
  wire z;
  wire[7:0] inst;
  wire pc_src, ld_pc, mem_adr_src, mem_write_sig, stack_src, tos_sig, push_sig, pop_sig, ld_B, ld_IR, ld_MDR;
  wire[1:0] alu_op;

  
  DataPath data_path(clk, ld_pc, ld_B, ld_IR, ld_MDR, stack_src, mem_write_sig, push_sig, pop_sig, tos_sig, pc_src, alu_op, mem_adr_src, z, inst);
  Controller controller(inst, clk, z, pc_src, ld_pc, ld_MDR, mem_adr_src, mem_write_sig, stack_src, tos_sig, push_sig, pop_sig, ld_B, ld_IR, alu_op);

endmodule
