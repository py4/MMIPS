`timescale 1ns/1ns
module DataMemory(input[7:0] address, input[7:0] write_data, input mem_write_sig, clk, output reg[7:0] read_data);

  reg[7:0] data[31:0];

  initial begin
    $readmemb("instructions.mips", data);
  end

  always @(posedge clk) begin
    if(mem_write_sig & clk)
      data[address] <= write_data;
  end

  always @(address) begin
    read_data = data[address];
  end

  integer i;
  initial begin
    for(i = 0; i < 6; i = i + 1) begin: loop
      $dumpvars(0, data[100+i]);
    end
  end

endmodule
