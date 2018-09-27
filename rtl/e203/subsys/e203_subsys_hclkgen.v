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
//  The HCLKGEN module, mainly include the PLL to generate clock
//
// ====================================================================

`include "e203_defines.v"


module e203_subsys_hclkgen(
  input test_mode,
  input hfclkrst,// To reset the PLL Clock
  
  input hfextclk,// The original clock from crystal

  input  pllbypass ,
  input  pll_RESET ,
  input  pll_ASLEEP ,
  input [1:0]  pll_OD,
  input [7:0]  pll_M,
  input [4:0]  pll_N,
  input plloutdivby1,
  input [5:0] plloutdiv, 

  output  inspect_16m_clk,
  output  inspect_pll_clk,

  output  hfclk// The generated clock by this module
  );

  wire hfclkrst_n = ~hfclkrst;

  // The PLL module
  wire plloutclk;
  wire pll_powerd = pll_ASLEEP | hfclkrst; // Power down by PMU or the register programmed
  e203_subsys_pll u_e203_subsys_pll(
    .pll_asleep (pll_powerd ),
    .pll_RESET  (pll_RESET),
    .pll_OD  (pll_OD),
    .pll_M   (pll_M ),
    .pll_N   (pll_N ),
    .pllrefclk  (hfextclk ),
    .plloutclk  (plloutclk ) 
  );

  // The Reset syncer for the PLLout clk
  wire plloutclk_rst_n;
  e203_subsys_hclkgen_rstsync plloutclk_rstsync(
    .clk      (plloutclk),
    .rst_n_a  (hfclkrst_n),
    .test_mode(test_mode),
    .rst_n    (plloutclk_rst_n)
  );

  // The Reset syncer for the HFextclk
  wire hfextclk_rst_n;
  e203_subsys_hclkgen_rstsync hfextclk_rstsync(
    .clk      (hfextclk),
    .rst_n_a  (hfclkrst_n),
    .test_mode(test_mode),
    .rst_n    (hfextclk_rst_n)
  );



  // The PLL divider
  wire plloutdivclk;
  e203_subsys_pllclkdiv u_e203_subsys_pllclkdiv(
    .test_mode(test_mode),
    .rst_n (plloutclk_rst_n),
    .divby1(plloutdivby1),
    .div   (plloutdiv   ), 
    .clk   (plloutclk),// The PLL clock
    .clkout(plloutdivclk) // The divided Clock
  );

  // The glitch free clock mux
  wire gfcm_clk;
  e203_subsys_gfcm u_e203_subsys_gfcm(
    .test_mode(test_mode),
    .clk0_rst_n   (plloutclk_rst_n),
    .clk1_rst_n   (hfextclk_rst_n),
    .sel1    (pllbypass),
    .clk0    (plloutdivclk),// The divided PLL clock
    .clk1    (hfextclk),// The original Crystal clock
    .clkout  (gfcm_clk)
  );

  assign hfclk = test_mode ? hfextclk : gfcm_clk;

  assign inspect_16m_clk = hfextclk ;
  assign inspect_pll_clk = plloutclk;

endmodule

