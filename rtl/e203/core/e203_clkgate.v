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
// Designer   : Bob Hu
//
// Description:
//  The clock gating cell
//
// ====================================================================
`include "e203_defines.v"

module e203_clkgate (
  input   clk_in,
  input   test_mode,
  input   clock_en,
  output  clk_out
);

`ifdef FPGA_SOURCE//{
    // In the FPGA, the clock gating is just pass through
    assign clk_out = clk_in;
`endif//}

`ifndef FPGA_SOURCE//{

reg enb /*verilator clock_enable*/;

always@(*)
  if (!clk_in)
    enb = (clock_en | test_mode);

assign clk_out = enb & clk_in;

`endif//}

endmodule 

