`timescale 1ns/1ns
// IR must have load signal 
module Controller(input [7:0] inst, input clk, zero, output reg pc_src, ld_pc, ld_MDR, mem_adr_src, mem_write,
 stack_src, tos, stack_push, stack_pop, ld_B, ld_IR, output reg [1:0] alu_op);

  localparam[3:0] init = -1, inst_fetch = 0, inst_decode = 1,
    and_sub_add_1 = 2, and_sub_add_2 = 3, and_sub_add_3 = 4,  //3 -> NOT
    push_1 = 5, push_2 = 6,     
    pop_1 = 7, pop_2 = 8,
    jmp = 9,
    jz_1 = 10, jz_2 = 11;
  
  reg[3:0] ps = init, ns = inst_fetch; 
  
  always @(ps) begin 
    pc_src <= 0; ld_pc <= 0; mem_adr_src <= 0; mem_write <= 0; stack_src <= 0; tos <= 0; 
    stack_push <= 0; stack_pop <= 0; ld_B <= 0; ld_IR <= 0; alu_op <= 2'b00;
    ld_MDR <= 0;

    case(ps)
      init: ns <= inst_fetch;

      inst_fetch: begin
        ns <= inst_decode;
        mem_adr_src <= 1;
        ld_IR <= 1;
        ld_pc <= 1;
      end 
      inst_decode: begin
        //ld_IR <= 1;
        case(inst[7:5])
          3'b000: begin
            ns <= and_sub_add_1; //add
            stack_pop <= 1;
            ld_B <= 1;
          end
          3'b001: begin
            ns <= and_sub_add_1; //sub 
            stack_pop <= 1;
            ld_B <= 1;
          end
          3'b010: begin
            ns <= and_sub_add_1; //and
            stack_pop <= 1;
            ld_B <= 1;
          end
          3'b011: begin
            ns <= and_sub_add_2; //not
            stack_pop <= 1;
            ld_B <= 1;
          end 
          3'b100: begin
            ns <= push_1; //push
            ld_MDR <= 1;
          end
          3'b101: begin
            ns <= pop_1; //pop
            stack_pop <= 1;
          end
          3'b110: ns <= jmp; //jmp
          3'b111: ns <= jz_1; //jmp zero
        endcase
      end
      and_sub_add_1: begin
        ns <= and_sub_add_2;
        tos <= 1;
        stack_pop <= 1;
        //ld_B <= 1;
      end
      and_sub_add_2: begin
        //ns <= and_sub_add_3;
        ns <= inst_fetch;
        alu_op <= inst[6:5];
        tos <= 1;
        //stack_pop <= 1;
        //new:
        stack_push <= 1;
        stack_src <= 1;
      end
      and_sub_add_3: begin
        ns <= inst_fetch;
        stack_src <= 1;
        //stack_push <= 1;
      end
      push_1: begin
        ns <= push_2;
        //ld_MDR <= 1;
        stack_push <= 1;
      end
      push_2: begin
        ns <= inst_fetch;
        //stack_push <= 1;
        stack_src <= 0;
        //stack_src <= 1;
      end
      pop_1: begin
        ns <= inst_fetch; //pop_2;
        tos <= 1;
        mem_write <= 1;
      end
/*      pop_2: begin
        ns <= inst_fetch;
        mem_write <= 1;
      end */
      jmp: begin 
        ns <= inst_fetch;
        ld_pc <= 1;
        pc_src <= 1;
      end
      jz_1: begin 
        //ns <= zero ? jz_2 : inst_fetch;
        ns <= inst_fetch;
        tos <= 1;
        if(zero) begin
          ld_pc <= 1;
          pc_src <= 1;
        end
      end
/*      jz_2: begin 
        ns <= inst_fetch;
        ld_pc <= 1;
        pc_src <= 1;
      end       */
    endcase
  end
  
  always@ (posedge clk) begin 
    $display("%b", inst);
    if (inst == 8'b11111111)
      $finish;
    ps <= ns;
  end 
endmodule
