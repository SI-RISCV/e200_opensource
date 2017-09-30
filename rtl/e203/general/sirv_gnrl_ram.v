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
//  The top level RAM module
//
// ====================================================================

module sirv_gnrl_ram 
#(parameter DP = 32,
  parameter DW = 256,
  parameter AW = 5 
  ) (
  input            sd,
  input            ds,
  input            ls,

  input            clk,
  input            cs,
  input            we,
  input [AW-1:0]   addr,
  input [DW-1:0]   din,
  input [DW/8-1:0] wem,
  output[DW-1:0]   dout
);

//To add the ASIC or FPGA or Sim-model control here
// This is the Sim-model
//
`ifdef FPGA_SOURCE
sirv_sim_ram #(
    .DP (DP),
    .AW (AW),
    .DW (DW) 
)u_sirv_sim_ram (
    .clk   (clk),
    .din   (din),
    .addr  (addr),
    .cs    (cs),
    .we    (we),
    .wem   (wem),
    .dout  (dout)
);
`else
    //To instantiate different tech's ASIC SRAM model here
sirv_sim_ram #(
    .DP (DP),
    .AW (AW),
    .DW (DW) 
)u_sirv_sim_ram (
    .clk   (clk),
    .din   (din),
    .addr  (addr),
    .cs    (cs),
    .we    (we),
    .wem   (wem),
    .dout  (dout)
);
`endif

endmodule
