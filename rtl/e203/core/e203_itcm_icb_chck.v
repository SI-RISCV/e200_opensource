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
//
// ====================================================================
`include "e203_defines.v"

  `ifdef E203_HAS_ITCM //{

module e203_itcm_icb_chck(

  input  i_vld,
  output i_rdy,
  input  [`E203_ITCM_DATA_WIDTH-1:0] i_dat,
  input  i_sel_ifu ,
  input  i_icb_read,

  output o_icb_rsp_valid,
  input  o_icb_rsp_ready,
  output o_icb_rsp_err,
  output [`E203_ITCM_DATA_WIDTH-1:0] o_icb_rsp_rdata, 
  output o_icb_rsp_ifu,

  input  clk,
  input  rst_n

);

// We just put the ECC into same stage as RAM, to easy the implementation
`ifndef E203_HAS_ECC //{
 assign i_rdy = o_icb_rsp_ready;
 assign o_icb_rsp_valid = i_vld;
 assign o_icb_rsp_rdata = i_dat;
 assign o_icb_rsp_err   = 1'b0;
 assign o_icb_rsp_ifu   = i_sel_ifu;
`endif//}

endmodule

  `endif//}
