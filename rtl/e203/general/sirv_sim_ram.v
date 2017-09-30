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
                                                                         
                                                                         
                                                                         
//=====================================================================
//--        _______   ___
//--       (   ____/ /__/
//--        \ \     __
//--     ____\ \   / /
//--    /_______\ /_/   MICROELECTRONICS
//--
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The simulation model of SRAM
//
// ====================================================================
module sirv_sim_ram 
#(parameter DP = 512,
  parameter DW = 32,
  parameter AW = 32 
)
(
  input             clk, 
  input  [DW-1  :0] din, 
  input  [AW-1  :0] addr,
  input             cs,
  input             we,
  input  [DW/8-1:0] wem,
  output [DW  -1:0] dout
);

    reg [DW-1:0] mem_r [0:DP-1];
    reg [AW-1:0] addr_r;
    wire [DW/8-1:0] wen;
    wire ren;

    assign ren = cs & (~we);
    assign wen = ({DW/8{cs & we}} & wem);



    genvar i;

    always @(posedge clk)
    begin
        if (ren) begin
            addr_r <= addr;
        end
    end

    generate
      for (i = 0; i < DW/8; i = i+1) begin :mem
        always @(posedge clk) begin
            if (wen[i]) begin
               mem_r[addr][8*i+:8] <= din[8*i+:8];
            end
        end
      end
    endgenerate

 assign dout = mem_r[addr_r];

 
endmodule
