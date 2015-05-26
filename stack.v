`timescale 1ns/1ns
module Stack(input push_sig, pop_sig, tos_sig, clk, input[7:0] push_data ,output reg [7:0] out_data);
  
  reg[11:0] data[7:0];
  reg[3:0] stack_pointer = 4'b0;
  
  always @(tos_sig) begin
    out_data = data[stack_pointer - 1];
  end
  
  always @(posedge clk, push_sig, tos_sig, pop_sig, push_data) begin
    if(push_sig) begin
      data[stack_pointer] <= push_data;
      stack_pointer <= stack_pointer + 1;
    end
    if(pop_sig) begin
      stack_pointer = stack_pointer - 1;
    end
  end

  integer i;
  initial begin
    for(i = 0; i < 8; i = i + 1) begin: loop2
      $dumpvars(0, data[i]);
    end
  end
  
endmodule
