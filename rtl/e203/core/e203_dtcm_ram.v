 /*                                                                      
 Copyright 2018 Nuclei System Technology, Inc.                
                                                                         
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
//
// Designer   : Bob Hu
//
// Description:
//  The DTCM-SRAM module to implement DTCM SRAM
//
// ====================================================================
`include "e203_defines.v"

  `ifdef E203_HAS_DTCM //{


module e203_dtcm_ram(

  input                              sd,
  input                              ds,
  input                              ls,

  input                              cs,  
  input                              we,  
  input  [`E203_DTCM_RAM_AW-1:0] addr, 
  input  [`E203_DTCM_RAM_MW-1:0] wem,
  input  [`E203_DTCM_RAM_DW-1:0] din,          
  output [`E203_DTCM_RAM_DW-1:0] dout,
  input                              rst_n,
  input                              clk

);

  sirv_gnrl_ram #(
    .FORCE_X2ZERO(1),//Always force X to zeros
    .DP(`E203_DTCM_RAM_DP),
    .DW(`E203_DTCM_RAM_DW),
    .MW(`E203_DTCM_RAM_MW),
    .AW(`E203_DTCM_RAM_AW) 
  ) u_e203_dtcm_gnrl_ram(
  .sd  (sd  ),
  .ds  (ds  ),
  .ls  (ls  ),

  .rst_n (rst_n ),
  .clk (clk ),
  .cs  (cs  ),
  .we  (we  ),
  .addr(addr),
  .din (din ),
  .wem (wem ),
  .dout(dout)
  );
                                                      
endmodule
  `endif//}
