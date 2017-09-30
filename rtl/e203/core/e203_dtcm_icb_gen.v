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

  `ifdef E203_HAS_DTCM //{

module e203_dtcm_icb_gen(

  input  i_icb_cmd_valid,
  output i_icb_cmd_ready,
  input  [`E203_DTCM_ADDR_WIDTH-1:0] i_icb_cmd_addr,
  input  i_icb_cmd_read,
  input  [`E203_DTCM_DATA_WIDTH-1:0] i_icb_cmd_wdata,
  input  [`E203_DTCM_WMSK_WIDTH-1:0] i_icb_cmd_wmask,

  output i_icb_rsp_valid,
  input  i_icb_rsp_ready,
  output i_icb_rsp_err,
  output [`E203_DTCM_DATA_WIDTH-1:0] i_icb_rsp_rdata,

  output o_icb_cmd_valid,
  input  o_icb_cmd_ready,
  output [`E203_DTCM_ADDR_WIDTH-1:0] o_icb_cmd_addr,
  output o_icb_cmd_read,
  output [`E203_DTCM_DATA_WIDTH-1:0] o_icb_cmd_wdata,
  output [`E203_DTCM_WMSK_WIDTH-1:0] o_icb_cmd_wmask,

  input  o_icb_rsp_valid,
  output o_icb_rsp_ready,
  input  o_icb_rsp_err,
  input  [`E203_DTCM_DATA_WIDTH-1:0] o_icb_rsp_rdata 

);

`ifndef E203_HAS_ECC //{
  assign o_icb_cmd_valid = i_icb_cmd_valid;
  assign o_icb_cmd_addr  = i_icb_cmd_addr ;
  assign o_icb_cmd_read  = i_icb_cmd_read ;
  assign o_icb_cmd_wdata = i_icb_cmd_wdata;
  assign o_icb_cmd_wmask = i_icb_cmd_wmask;

  assign o_icb_rsp_ready = i_icb_rsp_ready;

  assign i_icb_cmd_ready = o_icb_cmd_ready;
                         
  assign i_icb_rsp_valid = o_icb_rsp_valid;
  assign i_icb_rsp_err   = o_icb_rsp_err ;
  assign i_icb_rsp_rdata = o_icb_rsp_rdata;
`endif//}

endmodule

  `endif//}
