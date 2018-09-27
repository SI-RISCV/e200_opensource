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
//  The PLL module, need to be replaced with real PLL in ASIC flow
//
// ====================================================================

`include "e203_defines.v"


module e203_subsys_pllclkdiv(
  input rst_n,
  input test_mode,
  input divby1,
  input [5:0] div, 
  input clk,// The PLL clock
  output clkout // The divided Clock
  );

  wire [5:0] div_cnt_r; 
  wire div_cnt_sat = (div_cnt_r == div);
  wire [5:0] div_cnt_nxt = div_cnt_sat ? 6'b0 : (div_cnt_r + 1'b1); 
  wire div_cnt_ena = (~divby1);
  sirv_gnrl_dfflr #(6) div_cnt_dfflr (div_cnt_ena, div_cnt_nxt, div_cnt_r, clk, rst_n);

  wire flag_r; 
  wire flag_nxt = ~flag_r;
  wire flag_ena = div_cnt_ena & div_cnt_sat;
  sirv_gnrl_dfflr #(1) flag_dfflr (flag_ena, flag_nxt, flag_r, clk, rst_n);


  wire plloutdiv_en = divby1 | 
                    ((~flag_r) & div_cnt_sat); 

  e203_clkgate u_pllclkdiv_clkgate(
    .clk_in   (clk        ),
    .test_mode(test_mode  ),
    .clock_en (plloutdiv_en),
    .clk_out  (clkout)
  );
endmodule

