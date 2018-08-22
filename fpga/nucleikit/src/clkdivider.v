// Divide clock by 256, used to generate 32.768 kHz clock for AON block
module clkdivider
(
  input wire clk,
  input wire reset,
  output reg clk_out
);

  reg [7:0] counter;

  always @(posedge clk)
  begin
    if (reset)
    begin
      counter <= 8'd0;
      clk_out <= 1'b0;
    end
//  Bob: this original source code is wrong, because it is actually divided clock by 512, so correct it
    //else if (counter == 8'hff)
    else if (counter == 8'h7f)
    begin
      counter <= 8'd0;
      clk_out <= ~clk_out;
    end
    else
    begin
      counter <= counter+1;
    end
  end
endmodule
