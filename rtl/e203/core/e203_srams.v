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
//  The SRAM module to implement all SRAMs
//
// ====================================================================

`include "e203_defines.v"

module e203_srams(

  `ifdef E203_HAS_ITCM //{
  input  itcm_ram_sd,
  input  itcm_ram_ds,
  input  itcm_ram_ls,

  input                          itcm_ram_cs,  
  input                          itcm_ram_we,  
  input  [`E203_ITCM_RAM_AW-1:0] itcm_ram_addr, 
  input  [`E203_ITCM_RAM_MW-1:0] itcm_ram_wem,
  input  [`E203_ITCM_RAM_DW-1:0] itcm_ram_din,          
  output [`E203_ITCM_RAM_DW-1:0] itcm_ram_dout,
  input                          clk_itcm_ram,
  input  rst_itcm,
  `endif//}

  `ifdef E203_HAS_DTCM //{
  input  dtcm_ram_sd,
  input  dtcm_ram_ds,
  input  dtcm_ram_ls,

  input                          dtcm_ram_cs,  
  input                          dtcm_ram_we,  
  input  [`E203_DTCM_RAM_AW-1:0] dtcm_ram_addr, 
  input  [`E203_DTCM_RAM_MW-1:0] dtcm_ram_wem,
  input  [`E203_DTCM_RAM_DW-1:0] dtcm_ram_din,          
  output [`E203_DTCM_RAM_DW-1:0] dtcm_ram_dout,
  input                          clk_dtcm_ram,
  input  rst_dtcm,
  `endif//}

  input  test_mode

);


                                                      
  `ifdef E203_HAS_ITCM //{
  wire [`E203_ITCM_RAM_DW-1:0]  itcm_ram_dout_pre;

  e203_itcm_ram u_e203_itcm_ram (
    .sd   (itcm_ram_sd),
    .ds   (itcm_ram_ds),
    .ls   (itcm_ram_ls),
  
    .cs   (itcm_ram_cs   ),
    .we   (itcm_ram_we   ),
    .addr (itcm_ram_addr ),
    .wem  (itcm_ram_wem  ),
    .din  (itcm_ram_din  ),
    .dout (itcm_ram_dout_pre ),
    .rst_n(rst_itcm      ),
    .clk  (clk_itcm_ram  )
    );
    
  // Bob: we dont need this bypass here, actually the DFT tools will handle this SRAM black box 
  //assign itcm_ram_dout = test_mode ? itcm_ram_din : itcm_ram_dout_pre;
  assign itcm_ram_dout = itcm_ram_dout_pre;
  `endif//}

  `ifdef E203_HAS_DTCM //{
  wire [`E203_DTCM_RAM_DW-1:0]  dtcm_ram_dout_pre;

  e203_dtcm_ram u_e203_dtcm_ram (
    .sd   (dtcm_ram_sd),
    .ds   (dtcm_ram_ds),
    .ls   (dtcm_ram_ls),
  
    .cs   (dtcm_ram_cs   ),
    .we   (dtcm_ram_we   ),
    .addr (dtcm_ram_addr ),
    .wem  (dtcm_ram_wem  ),
    .din  (dtcm_ram_din  ),
    .dout (dtcm_ram_dout_pre ),
    .rst_n(rst_dtcm      ),
    .clk  (clk_dtcm_ram  )
    );
    
  // Bob: we dont need this bypass here, actually the DFT tools will handle this SRAM black box 
  //assign dtcm_ram_dout = test_mode ? dtcm_ram_din : dtcm_ram_dout_pre;
  assign dtcm_ram_dout = dtcm_ram_dout_pre;
  `endif//}

endmodule
