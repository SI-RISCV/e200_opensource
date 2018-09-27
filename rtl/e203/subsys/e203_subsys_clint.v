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
//  The CLINT module
//
// ====================================================================

`include "e203_defines.v"


module e203_subsys_clint(
  input                          clint_icb_cmd_valid,
  output                         clint_icb_cmd_ready,
  input  [`E203_ADDR_SIZE-1:0]   clint_icb_cmd_addr, 
  input                          clint_icb_cmd_read, 
  input  [`E203_XLEN-1:0]        clint_icb_cmd_wdata,
  input  [`E203_XLEN/8-1:0]      clint_icb_cmd_wmask,
  //
  output                         clint_icb_rsp_valid,
  input                          clint_icb_rsp_ready,
  output                         clint_icb_rsp_err,
  output [`E203_XLEN-1:0]        clint_icb_rsp_rdata,

  output  clint_tmr_irq,
  output  clint_sft_irq,

  input   aon_rtcToggle_a,
  input   tm_stop,

  input  clk,
  input  rst_n
  );


  wire aon_rtcToggle_r;
  wire aon_rtcToggle;
  sirv_gnrl_sync # (
  .DP(`E203_ASYNC_FF_LEVELS),
  .DW(1)
  ) u_aon_rtctoggle_sync(
      .din_a    (aon_rtcToggle_a),
      .dout     (aon_rtcToggle_r),
      .clk      (clk  ),
      .rst_n    (rst_n) 
  );

  sirv_clint_top u_sirv_clint_top(
  .clk             (clk   ),
  .rst_n           (rst_n ),

  .i_icb_cmd_valid (clint_icb_cmd_valid),
  .i_icb_cmd_ready (clint_icb_cmd_ready),
  .i_icb_cmd_addr  (clint_icb_cmd_addr ),
  .i_icb_cmd_read  (clint_icb_cmd_read ),
  .i_icb_cmd_wdata (clint_icb_cmd_wdata),
  
  .i_icb_rsp_valid (clint_icb_rsp_valid),
  .i_icb_rsp_ready (clint_icb_rsp_ready),
  .i_icb_rsp_rdata (clint_icb_rsp_rdata),

  .io_tiles_0_mtip (clint_tmr_irq),
  .io_tiles_0_msip (clint_sft_irq),
  .io_rtcToggle    (aon_rtcToggle)
  );

  // We self-defined a mcounterstop CSR which contained a tm_stop field, this 
  //   field can be use to disable different counters to save dynamic powers
  //   in the case where they dont really need the counters
  assign aon_rtcToggle = aon_rtcToggle_r & (~tm_stop);

  assign clint_icb_rsp_err     = 1'b0;

endmodule

