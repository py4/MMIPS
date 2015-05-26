`timescale 1ns/1ns

module CPUTest;
  reg clk = 1;

  CPU cpu(clk);
  initial begin
    clk = 1;
  end
  always begin
    #20 clk = ~clk;
    //if(clk == 1) begin
      //$display("");
      //$display("-------------------------------------------------------");
      //$display("a clock pulse passed!");
      //$display("-------------------------------------------------------");
      //$display("");
    //end
  end

  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, CPUTest);
  end
endmodule
