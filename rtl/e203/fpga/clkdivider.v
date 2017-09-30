 /*                                                                      
 Copyright 2017 Silicon Integrated Microelectronics, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
                                                                         
                                                                         
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
