`timescale 1ns/1ns
module DataMemory(input[4:0] address, input[7:0] write_data, input mem_write_sig, clk, output reg[7:0] read_data);

  reg[7:0] data[31:0];

  initial begin
    data[15] = 8'b00000001;
    data[16] = 8'b00000010;
    data[17] = 8'b00000000;
    $readmemb("instructions.mips", data);
  end

  always @(posedge clk) begin
    if(mem_write_sig) begin
      $display("FUCK!");
      $display("%b",write_data);
      data[address] <= write_data;
    end
  end

  always @(address) begin
    read_data = data[address];
  end

  integer i;
  initial begin
    for(i = 0; i < 20; i = i + 1) begin: loop
      $dumpvars(0, data[i]);
    end
  end

endmodule
