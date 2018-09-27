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
//  The top level of clint module
//
// ====================================================================

module sirv_clint_top(
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

  output  io_tiles_0_mtip,
  output  io_tiles_0_msip,
  input   io_rtcToggle 
);

  wire io_rtcToggle_r; 
  sirv_gnrl_dffr #(1) io_rtcToggle_dffr (io_rtcToggle, io_rtcToggle_r, clk, rst_n);
  wire io_rtcToggle_edge = io_rtcToggle ^ io_rtcToggle_r; 
  wire io_rtcTick = io_rtcToggle_edge;

  wire  io_in_0_a_ready;
  assign  i_icb_cmd_ready  = io_in_0_a_ready;
  wire  io_in_0_a_valid  = i_icb_cmd_valid;
  wire  [2:0] io_in_0_a_bits_opcode  = i_icb_cmd_read ? 3'h4 : 3'h0;
  wire  [2:0] io_in_0_a_bits_param  = 3'b0;
  wire  [2:0] io_in_0_a_bits_size = 3'd2;
  wire  [4:0] io_in_0_a_bits_source  = 5'b0;
  wire  [25:0] io_in_0_a_bits_address  = i_icb_cmd_addr[25:0];
  wire  [3:0] io_in_0_a_bits_mask  = 4'b1111;
  wire  [31:0] io_in_0_a_bits_data  = i_icb_cmd_wdata;

  
  wire  io_in_0_d_ready = i_icb_rsp_ready;

  wire  [2:0] io_in_0_d_bits_opcode;
  wire  [1:0] io_in_0_d_bits_param;
  wire  [2:0] io_in_0_d_bits_size;
  wire  [4:0] io_in_0_d_bits_source;
  wire  io_in_0_d_bits_sink;
  wire  [1:0] io_in_0_d_bits_addr_lo;
  wire  [31:0] io_in_0_d_bits_data;
  wire  io_in_0_d_bits_error;
  wire  io_in_0_d_valid;

  assign  i_icb_rsp_valid = io_in_0_d_valid;
  assign  i_icb_rsp_rdata = io_in_0_d_bits_data;

  // Not used
  wire  io_in_0_b_ready = 1'b0;
  wire  io_in_0_b_valid;
  wire  [2:0] io_in_0_b_bits_opcode;
  wire  [1:0] io_in_0_b_bits_param;
  wire  [2:0] io_in_0_b_bits_size;
  wire  [4:0] io_in_0_b_bits_source;
  wire  [25:0] io_in_0_b_bits_address;
  wire  [3:0] io_in_0_b_bits_mask;
  wire  [31:0] io_in_0_b_bits_data;

  // Not used
  wire  io_in_0_c_ready;
  wire  io_in_0_c_valid = 1'b0;
  wire  [2:0] io_in_0_c_bits_opcode = 3'b0;
  wire  [2:0] io_in_0_c_bits_param = 3'b0;
  wire  [2:0] io_in_0_c_bits_size = 3'd2;
  wire  [4:0] io_in_0_c_bits_source = 5'b0;
  wire  [25:0] io_in_0_c_bits_address = 26'b0;
  wire  [31:0] io_in_0_c_bits_data = 32'b0;
  wire  io_in_0_c_bits_error = 1'b0;

  // Not used
  wire  io_in_0_e_ready;
  wire  io_in_0_e_valid = 1'b0;
  wire  io_in_0_e_bits_sink = 1'b0;

sirv_clint u_sirv_clint(
  .clock                            (clk                              ),
  .reset                            (~rst_n                            ),

  .io_in_0_a_ready                  (io_in_0_a_ready                  ),
  .io_in_0_a_valid                  (io_in_0_a_valid                  ),
  .io_in_0_a_bits_opcode            (io_in_0_a_bits_opcode            ),
  .io_in_0_a_bits_param             (io_in_0_a_bits_param             ),
  .io_in_0_a_bits_size              (io_in_0_a_bits_size              ),
  .io_in_0_a_bits_source            (io_in_0_a_bits_source            ),
  .io_in_0_a_bits_address           (io_in_0_a_bits_address           ),
  .io_in_0_a_bits_mask              (io_in_0_a_bits_mask              ),
  .io_in_0_a_bits_data              (io_in_0_a_bits_data              ),
  .io_in_0_b_ready                  (io_in_0_b_ready                  ),
  .io_in_0_b_valid                  (io_in_0_b_valid                  ),
  .io_in_0_b_bits_opcode            (io_in_0_b_bits_opcode            ),
  .io_in_0_b_bits_param             (io_in_0_b_bits_param             ),
  .io_in_0_b_bits_size              (io_in_0_b_bits_size              ),
  .io_in_0_b_bits_source            (io_in_0_b_bits_source            ),
  .io_in_0_b_bits_address           (io_in_0_b_bits_address           ),
  .io_in_0_b_bits_mask              (io_in_0_b_bits_mask              ),
  .io_in_0_b_bits_data              (io_in_0_b_bits_data              ),
  .io_in_0_c_ready                  (io_in_0_c_ready                  ),
  .io_in_0_c_valid                  (io_in_0_c_valid                  ),
  .io_in_0_c_bits_opcode            (io_in_0_c_bits_opcode            ),
  .io_in_0_c_bits_param             (io_in_0_c_bits_param             ),
  .io_in_0_c_bits_size              (io_in_0_c_bits_size              ),
  .io_in_0_c_bits_source            (io_in_0_c_bits_source            ),
  .io_in_0_c_bits_address           (io_in_0_c_bits_address           ),
  .io_in_0_c_bits_data              (io_in_0_c_bits_data              ),
  .io_in_0_c_bits_error             (io_in_0_c_bits_error             ),
  .io_in_0_d_ready                  (io_in_0_d_ready                  ),
  .io_in_0_d_valid                  (io_in_0_d_valid                  ),
  .io_in_0_d_bits_opcode            (io_in_0_d_bits_opcode            ),
  .io_in_0_d_bits_param             (io_in_0_d_bits_param             ),
  .io_in_0_d_bits_size              (io_in_0_d_bits_size              ),
  .io_in_0_d_bits_source            (io_in_0_d_bits_source            ),
  .io_in_0_d_bits_sink              (io_in_0_d_bits_sink              ),
  .io_in_0_d_bits_addr_lo           (io_in_0_d_bits_addr_lo           ),
  .io_in_0_d_bits_data              (io_in_0_d_bits_data              ),
  .io_in_0_d_bits_error             (io_in_0_d_bits_error             ),
  .io_in_0_e_ready                  (io_in_0_e_ready                  ),
  .io_in_0_e_valid                  (io_in_0_e_valid                  ),
  .io_in_0_e_bits_sink              (io_in_0_e_bits_sink              ),

  .io_tiles_0_mtip (io_tiles_0_mtip),
  .io_tiles_0_msip (io_tiles_0_msip),
  .io_rtcTick      (io_rtcTick     ) 
);

endmodule
