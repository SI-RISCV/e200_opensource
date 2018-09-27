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
//  The programmiable regs for HCLKGEN
//
// ====================================================================

module sirv_hclkgen_regs(
  input  clk,
  input  rst_n,

  output pllbypass ,
  output pll_RESET ,
  output pll_ASLEEP ,
  output [1:0]  pll_OD,
  output [7:0]  pll_M,
  output [4:0]  pll_N,
  output plloutdivby1,
  output [5:0] plloutdiv,

  output hfxoscen,

  input                      i_icb_cmd_valid,
  output                     i_icb_cmd_ready,
  input  [12-1:0]            i_icb_cmd_addr, 
  input                      i_icb_cmd_read, 
  input  [32-1:0]            i_icb_cmd_wdata,
  
  output                     i_icb_rsp_valid,
  input                      i_icb_rsp_ready,
  output [32-1:0]            i_icb_rsp_rdata
);

// Directly connect the command channel with response channel
  assign i_icb_rsp_valid = i_icb_cmd_valid;
  assign i_icb_cmd_ready = i_icb_rsp_ready;

  wire icb_wr_en = i_icb_cmd_valid & i_icb_cmd_ready & (~i_icb_cmd_read);
  wire [32-1:0]  icb_wdata = i_icb_cmd_wdata;

  wire [32-1:0] hfxosccfg_r;
  wire [32-1:0] pllcfg_r;
  wire [32-1:0] plloutdiv_r;

  // Addr selection
  wire sel_hfxosccfg = (i_icb_cmd_addr == 12'h004);
  wire sel_pllcfg	 = (i_icb_cmd_addr == 12'h008);
  wire sel_plloutdiv = (i_icb_cmd_addr == 12'h00C);

  wire icb_wr_en_hfxosccfg = icb_wr_en & sel_hfxosccfg ;
  wire icb_wr_en_pllcfg    = icb_wr_en & sel_pllcfg	;
  wire icb_wr_en_plloutdiv = icb_wr_en & sel_plloutdiv ;

  assign i_icb_rsp_rdata = 
                   ({32{sel_hfxosccfg}} & hfxosccfg_r)
                 | ({32{sel_pllcfg	 }} & pllcfg_r	 )
                 | ({32{sel_plloutdiv}} & plloutdiv_r);

  /////////////////////////////////////////////////////////////////////////////////////////
  // HFXOSCCFG
  wire hfxoscen_ena = icb_wr_en_hfxosccfg;
     // The reset value is 1 
  sirv_gnrl_dfflrs #(1) hfxoscen_dfflrs (hfxoscen_ena, icb_wdata[30], hfxoscen, clk, rst_n);
  assign hfxosccfg_r = {1'b0, hfxoscen, 30'b0};

  /////////////////////////////////////////////////////////////////////////////////////////
  // PLLCFG
  //
  // N: The reset value is 2 = 5'h2 = 5'b0_0010
  sirv_gnrl_dfflr #(3) pll_N_42_dfflr (icb_wr_en_pllcfg, icb_wdata[4:2], pll_N[4:2], clk, rst_n);
  sirv_gnrl_dfflrs#(1) pll_N_1_dfflr (icb_wr_en_pllcfg, icb_wdata[1], pll_N[1], clk, rst_n);
  sirv_gnrl_dfflr #(1) pll_N_0_dfflr (icb_wr_en_pllcfg, icb_wdata[0], pll_N[0], clk, rst_n);
  //
  // M: The reset value is 50 = 8'h32 = 8'b0011_0010
  sirv_gnrl_dfflr #(1) pll_M_7_dfflr (icb_wr_en_pllcfg, icb_wdata[12], pll_M[7], clk, rst_n);
  sirv_gnrl_dfflr #(1) pll_M_6_dfflr (icb_wr_en_pllcfg, icb_wdata[11], pll_M[6], clk, rst_n);
  sirv_gnrl_dfflrs#(1) pll_M_5_dfflr (icb_wr_en_pllcfg, icb_wdata[10], pll_M[5], clk, rst_n);
  sirv_gnrl_dfflrs#(1) pll_M_4_dfflr (icb_wr_en_pllcfg, icb_wdata[09], pll_M[4], clk, rst_n);
  sirv_gnrl_dfflr #(1) pll_M_3_dfflr (icb_wr_en_pllcfg, icb_wdata[08], pll_M[3], clk, rst_n);
  sirv_gnrl_dfflr #(1) pll_M_2_dfflr (icb_wr_en_pllcfg, icb_wdata[07], pll_M[2], clk, rst_n);
  sirv_gnrl_dfflrs#(1) pll_M_1_dfflr (icb_wr_en_pllcfg, icb_wdata[06], pll_M[1], clk, rst_n);
  sirv_gnrl_dfflr #(1) pll_M_0_dfflr (icb_wr_en_pllcfg, icb_wdata[05], pll_M[0], clk, rst_n);
  
  // OD: The reset value is 2 = 2'b10
  sirv_gnrl_dfflrs #(1) pll_OD_1_dfflrs(icb_wr_en_pllcfg, icb_wdata[14], pll_OD[1], clk, rst_n);
  sirv_gnrl_dfflr  #(1) pll_OD_0_dfflr (icb_wr_en_pllcfg, icb_wdata[13], pll_OD[0], clk, rst_n);

  // Bypass: The reset value is 1
  sirv_gnrl_dfflrs #(1) pllbypass_dfflrs (icb_wr_en_pllcfg, icb_wdata[18], pllbypass, clk, rst_n);

  // RESET: The reset value is 0
  sirv_gnrl_dfflr  #(1) pll_RESET_dfflrs (icb_wr_en_pllcfg, icb_wdata[30], pll_RESET, clk, rst_n);

  // ASLEEP: The asleep value is 0
  sirv_gnrl_dfflr  #(1) pll_ASLEEP_dfflrs (icb_wr_en_pllcfg, icb_wdata[29], pll_ASLEEP, clk, rst_n);

  assign pllcfg_r[31] = 1'b0;
  assign pllcfg_r[30] = pll_RESET;
  assign pllcfg_r[29] = pll_ASLEEP;
  assign pllcfg_r[28:19] = 10'b0;
  assign pllcfg_r[18] = pllbypass;
  assign pllcfg_r[17:15] = 3'b0;
  assign pllcfg_r[14:13] = pll_OD;
  assign pllcfg_r[12:5] = pll_M;
  assign pllcfg_r[4:0] = pll_N;
 
  /////////////////////////////////////////////////////////////////////////////////////////
  // PLLOUTDIV
  //
  wire plloutdiv_ena = icb_wr_en_plloutdiv;
  sirv_gnrl_dfflr #(6) plloutdiv_dfflr (plloutdiv_ena, icb_wdata[5:0], plloutdiv, clk, rst_n);
  wire plloutdivby1_ena = icb_wr_en_plloutdiv;
  // The reset value is 1
  sirv_gnrl_dfflrs #(1) plloutdivby1_dfflrs (plloutdivby1_ena, icb_wdata[8], plloutdivby1, clk, rst_n);

  assign plloutdiv_r[31:9] = 23'b0;
  assign plloutdiv_r[8] = plloutdivby1;
  assign plloutdiv_r[7:6] = 2'b0;
  assign plloutdiv_r[5:0] = plloutdiv;

endmodule
