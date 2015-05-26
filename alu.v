`timescale 1ns/1ns

module ALU(input signed [7:0] A, input signed [7:0] B, input [1:0] acode, output reg [7:0] R);

  always @(A, B, acode) begin
    case(acode)
      2'b00: R = A + B;
      2'b01: R = A - B;
      2'b10: R = A & B;
      2'b11: R = ~A;
    endcase
  end
endmodule
