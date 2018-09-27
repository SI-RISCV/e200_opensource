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
//  The programmiable regs for LCLKGEN
//
// ====================================================================

module sirv_aon_lclkgen_regs(
  input  clk,
  input  rst_n,

  output lfxoscen,

  input                      i_icb_cmd_valid,
  output                     i_icb_cmd_ready,
  input  [8 -1:0]            i_icb_cmd_addr, 
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

  wire [32-1:0] lfxosccfg_r;

  // Addr selection
  wire sel_lfxosccfg = (i_icb_cmd_addr == 8'h00);

  wire icb_wr_en_lfxosccfg = icb_wr_en & sel_lfxosccfg ;

  assign i_icb_rsp_rdata = ({32{sel_lfxosccfg}} & lfxosccfg_r);

  /////////////////////////////////////////////////////////////////////////////////////////
  // LFXOSCCFG
  wire lfxoscen_ena = icb_wr_en_lfxosccfg;
    // The reset value is 1
  sirv_gnrl_dfflrs #(1) lfxoscen_dfflrs (lfxoscen_ena, icb_wdata[30], lfxoscen, clk, rst_n);
  assign lfxosccfg_r = {1'b0, lfxoscen, 30'b0};


endmodule
