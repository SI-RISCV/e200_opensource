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
//  The module is to control the mask ROM 
//
// ====================================================================

module sirv_mrom_top #(
    parameter AW = 12,
    parameter DW = 32,
    parameter DP = 1024
)(
  //    * Bus cmd channel
  input  rom_icb_cmd_valid, // Handshake valid
  output rom_icb_cmd_ready, // Handshake ready
  input  [AW-1:0] rom_icb_cmd_addr, // Bus transaction start addr 
  input  rom_icb_cmd_read,   // Read or write

  //    * Bus RSP channel
  output rom_icb_rsp_valid, // Response valid 
  input  rom_icb_rsp_ready, // Response ready
  output rom_icb_rsp_err,   // Response error
  output [DW-1:0] rom_icb_rsp_rdata, 

  input  clk,
  input  rst_n
  );
        
  wire [DW-1:0] rom_dout; 

  assign rom_icb_rsp_valid = rom_icb_cmd_valid;
  assign rom_icb_cmd_ready = rom_icb_rsp_ready;
  assign rom_icb_rsp_err = ~rom_icb_cmd_read;
  assign rom_icb_rsp_rdata = rom_dout;


   sirv_mrom # (
    .AW(AW),
    .DW(DW),
    .DP(DP)
   )u_sirv_mrom (
     .rom_addr (rom_icb_cmd_addr[AW-1:2]),
     .rom_dout (rom_dout) 
   );

endmodule

