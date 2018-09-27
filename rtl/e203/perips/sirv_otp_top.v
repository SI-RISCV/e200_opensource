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
//  The top level module of otp
//
// ====================================================================

module sirv_otp_top(
  input   clk,
  input   rst_n,

  input                      i_icb_cmd_valid,
  output                     i_icb_cmd_ready,
  input  [32-1:0]            i_icb_cmd_addr, 
  input                      i_icb_cmd_read, 
  input  [32-1:0]            i_icb_cmd_wdata,
  
  output                     i_icb_rsp_valid,
  input                      i_icb_rsp_ready,
  output [32-1:0]            i_icb_rsp_rdata,

  input                      f_icb_cmd_valid,
  output                     f_icb_cmd_ready,
  input  [32-1:0]            f_icb_cmd_addr, 
  input                      f_icb_cmd_read, 
  input  [32-1:0]            f_icb_cmd_wdata,
  
  output                     f_icb_rsp_valid,
  input                      f_icb_rsp_ready,
  output [32-1:0]            f_icb_rsp_rdata 
);

  assign i_icb_cmd_ready = 1'b0;
  
  assign i_icb_rsp_valid = 1'b0;
  assign i_icb_rsp_rdata = 32'b0;

  assign f_icb_cmd_ready = 1'b0;
  
  assign f_icb_rsp_valid = 1'b0;
  assign f_icb_rsp_rdata = 32'b0; 

    // In FPGA platform this module is just an empty wrapper

endmodule
