`timescale 1ns/1ns
module DataPath(input clk, ld_pc, ld_B, ld_IR, ld_MDR, stack_src, mem_write_sig, push_sig, pop_sig, tos_sig, pc_src,  input[1:0] alu_op, input mem_adr_src, output reg z, output reg[7:0] instruction);
  
  reg[4:0] pc;
  reg[7:0] mdr;
  reg[7:0] B_reg;
  reg[7:0] alu_out_reg;

  wire[7:0] data_memory_out;
  wire[7:0] stack_out;
  wire[7:0] alu_out;

  initial begin
    pc = 4'b0;
  end

  always @(posedge clk) begin
    if(ld_pc) pc <= (pc_src == 1'b0 ? pc + 1 : instruction[4:0]);
    if(ld_B) B_reg <= stack_out;
    if(ld_MDR) mdr <= data_memory_out;
    if (ld_IR == 1'b1) instruction <= data_memory_out;
    z <= (stack_out == 0);
    alu_out_reg <= alu_out;    
  end

  DataMemory data_memory((mem_adr_src ? pc : instruction[4:0]), stack_out, mem_write_sig, clk, data_memory_out);

  //CHANGE: changed alu_out_reg to alu_out
  Stack stack(push_sig, pop_sig, tos_sig, clk, ((stack_src == 1'b0) ? mdr : alu_out), stack_out);
  ALU alu(B_reg, stack_out, alu_op, alu_out); 
   
endmodule
