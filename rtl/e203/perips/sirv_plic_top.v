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
//  The top level module of plic
//
// ====================================================================

module sirv_plic_top(
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

  input   io_devices_0_0,
  input   io_devices_0_1,
  input   io_devices_0_2,
  input   io_devices_0_3,
  input   io_devices_0_4,
  input   io_devices_0_5,
  input   io_devices_0_6,
  input   io_devices_0_7,
  input   io_devices_0_8,
  input   io_devices_0_9,
  input   io_devices_0_10,
  input   io_devices_0_11,
  input   io_devices_0_12,
  input   io_devices_0_13,
  input   io_devices_0_14,
  input   io_devices_0_15,
  input   io_devices_0_16,
  input   io_devices_0_17,
  input   io_devices_0_18,
  input   io_devices_0_19,
  input   io_devices_0_20,
  input   io_devices_0_21,
  input   io_devices_0_22,
  input   io_devices_0_23,
  input   io_devices_0_24,
  input   io_devices_0_25,
  input   io_devices_0_26,
  input   io_devices_0_27,
  input   io_devices_0_28,
  input   io_devices_0_29,
  input   io_devices_0_30,
  input   io_devices_0_31,
  input   io_devices_0_32,
  input   io_devices_0_33,
  input   io_devices_0_34,
  input   io_devices_0_35,
  input   io_devices_0_36,
  input   io_devices_0_37,
  input   io_devices_0_38,
  input   io_devices_0_39,
  input   io_devices_0_40,
  input   io_devices_0_41,
  input   io_devices_0_42,
  input   io_devices_0_43,
  input   io_devices_0_44,
  input   io_devices_0_45,
  input   io_devices_0_46,
  input   io_devices_0_47,
  input   io_devices_0_48,
  input   io_devices_0_49,
  input   io_devices_0_50,
  output  io_harts_0_0
);

  wire  io_tl_in_0_a_ready;
  assign  i_icb_cmd_ready  = io_tl_in_0_a_ready;
  wire  io_tl_in_0_a_valid  = i_icb_cmd_valid;
  wire  [2:0] io_tl_in_0_a_bits_opcode  = i_icb_cmd_read ? 3'h4 : 3'h0;
  wire  [2:0] io_tl_in_0_a_bits_param  = 3'b0;
  wire  [2:0] io_tl_in_0_a_bits_size = 3'd2;
  wire  [4:0] io_tl_in_0_a_bits_source  = 5'b0;
  wire  [27:0] io_tl_in_0_a_bits_address  = i_icb_cmd_addr[27:0];
  wire  [3:0] io_tl_in_0_a_bits_mask  = 4'b1111;
  wire  [31:0] io_tl_in_0_a_bits_data  = i_icb_cmd_wdata;

  
  wire  io_tl_in_0_d_ready = i_icb_rsp_ready;

  wire  [2:0] io_tl_in_0_d_bits_opcode;
  wire  [1:0] io_tl_in_0_d_bits_param;
  wire  [2:0] io_tl_in_0_d_bits_size;
  wire  [4:0] io_tl_in_0_d_bits_source;
  wire  io_tl_in_0_d_bits_sink;
  wire  [1:0] io_tl_in_0_d_bits_addr_lo;
  wire  [31:0] io_tl_in_0_d_bits_data;
  wire  io_tl_in_0_d_bits_error;
  wire  io_tl_in_0_d_valid;

  assign  i_icb_rsp_valid = io_tl_in_0_d_valid;
  assign  i_icb_rsp_rdata = io_tl_in_0_d_bits_data;

  // Not used
  wire  io_tl_in_0_b_ready = 1'b0;
  wire  io_tl_in_0_b_valid;
  wire  [2:0] io_tl_in_0_b_bits_opcode;
  wire  [1:0] io_tl_in_0_b_bits_param;
  wire  [2:0] io_tl_in_0_b_bits_size;
  wire  [4:0] io_tl_in_0_b_bits_source;
  wire  [27:0] io_tl_in_0_b_bits_address;
  wire  [3:0] io_tl_in_0_b_bits_mask;
  wire  [31:0] io_tl_in_0_b_bits_data;

  // Not used
  wire  io_tl_in_0_c_ready;
  wire  io_tl_in_0_c_valid = 1'b0;
  wire  [2:0] io_tl_in_0_c_bits_opcode = 3'b0;
  wire  [2:0] io_tl_in_0_c_bits_param = 3'b0;
  wire  [2:0] io_tl_in_0_c_bits_size = 3'd2;
  wire  [4:0] io_tl_in_0_c_bits_source = 5'b0;
  wire  [27:0] io_tl_in_0_c_bits_address = 28'b0;
  wire  [31:0] io_tl_in_0_c_bits_data = 32'b0;
  wire  io_tl_in_0_c_bits_error = 1'b0;

  // Not used
  wire  io_tl_in_0_e_ready;
  wire  io_tl_in_0_e_valid = 1'b0;
  wire  io_tl_in_0_e_bits_sink = 1'b0;

sirv_plic u_sirv_plic(
  .clock                            (clk                              ),
  .reset                            (~rst_n                            ),

  .io_tl_in_0_a_ready                  (io_tl_in_0_a_ready                  ),
  .io_tl_in_0_a_valid                  (io_tl_in_0_a_valid                  ),
  .io_tl_in_0_a_bits_opcode            (io_tl_in_0_a_bits_opcode            ),
  .io_tl_in_0_a_bits_param             (io_tl_in_0_a_bits_param             ),
  .io_tl_in_0_a_bits_size              (io_tl_in_0_a_bits_size              ),
  .io_tl_in_0_a_bits_source            (io_tl_in_0_a_bits_source            ),
  .io_tl_in_0_a_bits_address           (io_tl_in_0_a_bits_address           ),
  .io_tl_in_0_a_bits_mask              (io_tl_in_0_a_bits_mask              ),
  .io_tl_in_0_a_bits_data              (io_tl_in_0_a_bits_data              ),
  .io_tl_in_0_b_ready                  (io_tl_in_0_b_ready                  ),
  .io_tl_in_0_b_valid                  (io_tl_in_0_b_valid                  ),
  .io_tl_in_0_b_bits_opcode            (io_tl_in_0_b_bits_opcode            ),
  .io_tl_in_0_b_bits_param             (io_tl_in_0_b_bits_param             ),
  .io_tl_in_0_b_bits_size              (io_tl_in_0_b_bits_size              ),
  .io_tl_in_0_b_bits_source            (io_tl_in_0_b_bits_source            ),
  .io_tl_in_0_b_bits_address           (io_tl_in_0_b_bits_address           ),
  .io_tl_in_0_b_bits_mask              (io_tl_in_0_b_bits_mask              ),
  .io_tl_in_0_b_bits_data              (io_tl_in_0_b_bits_data              ),
  .io_tl_in_0_c_ready                  (io_tl_in_0_c_ready                  ),
  .io_tl_in_0_c_valid                  (io_tl_in_0_c_valid                  ),
  .io_tl_in_0_c_bits_opcode            (io_tl_in_0_c_bits_opcode            ),
  .io_tl_in_0_c_bits_param             (io_tl_in_0_c_bits_param             ),
  .io_tl_in_0_c_bits_size              (io_tl_in_0_c_bits_size              ),
  .io_tl_in_0_c_bits_source            (io_tl_in_0_c_bits_source            ),
  .io_tl_in_0_c_bits_address           (io_tl_in_0_c_bits_address           ),
  .io_tl_in_0_c_bits_data              (io_tl_in_0_c_bits_data              ),
  .io_tl_in_0_c_bits_error             (io_tl_in_0_c_bits_error             ),
  .io_tl_in_0_d_ready                  (io_tl_in_0_d_ready                  ),
  .io_tl_in_0_d_valid                  (io_tl_in_0_d_valid                  ),
  .io_tl_in_0_d_bits_opcode            (io_tl_in_0_d_bits_opcode            ),
  .io_tl_in_0_d_bits_param             (io_tl_in_0_d_bits_param             ),
  .io_tl_in_0_d_bits_size              (io_tl_in_0_d_bits_size              ),
  .io_tl_in_0_d_bits_source            (io_tl_in_0_d_bits_source            ),
  .io_tl_in_0_d_bits_sink              (io_tl_in_0_d_bits_sink              ),
  .io_tl_in_0_d_bits_addr_lo           (io_tl_in_0_d_bits_addr_lo           ),
  .io_tl_in_0_d_bits_data              (io_tl_in_0_d_bits_data              ),
  .io_tl_in_0_d_bits_error             (io_tl_in_0_d_bits_error             ),
  .io_tl_in_0_e_ready                  (io_tl_in_0_e_ready                  ),
  .io_tl_in_0_e_valid                  (io_tl_in_0_e_valid                  ),
  .io_tl_in_0_e_bits_sink              (io_tl_in_0_e_bits_sink              ),

  .io_devices_0_0  (io_devices_0_0 ),
  .io_devices_0_1  (io_devices_0_1 ),
  .io_devices_0_2  (io_devices_0_2 ),
  .io_devices_0_3  (io_devices_0_3 ),
  .io_devices_0_4  (io_devices_0_4 ),
  .io_devices_0_5  (io_devices_0_5 ),
  .io_devices_0_6  (io_devices_0_6 ),
  .io_devices_0_7  (io_devices_0_7 ),
  .io_devices_0_8  (io_devices_0_8 ),
  .io_devices_0_9  (io_devices_0_9 ),
  .io_devices_0_10 (io_devices_0_10),
  .io_devices_0_11 (io_devices_0_11),
  .io_devices_0_12 (io_devices_0_12),
  .io_devices_0_13 (io_devices_0_13),
  .io_devices_0_14 (io_devices_0_14),
  .io_devices_0_15 (io_devices_0_15),
  .io_devices_0_16 (io_devices_0_16),
  .io_devices_0_17 (io_devices_0_17),
  .io_devices_0_18 (io_devices_0_18),
  .io_devices_0_19 (io_devices_0_19),
  .io_devices_0_20 (io_devices_0_20),
  .io_devices_0_21 (io_devices_0_21),
  .io_devices_0_22 (io_devices_0_22),
  .io_devices_0_23 (io_devices_0_23),
  .io_devices_0_24 (io_devices_0_24),
  .io_devices_0_25 (io_devices_0_25),
  .io_devices_0_26 (io_devices_0_26),
  .io_devices_0_27 (io_devices_0_27),
  .io_devices_0_28 (io_devices_0_28),
  .io_devices_0_29 (io_devices_0_29),
  .io_devices_0_30 (io_devices_0_30),
  .io_devices_0_31 (io_devices_0_31),
  .io_devices_0_32 (io_devices_0_32),
  .io_devices_0_33 (io_devices_0_33),
  .io_devices_0_34 (io_devices_0_34),
  .io_devices_0_35 (io_devices_0_35),
  .io_devices_0_36 (io_devices_0_36),
  .io_devices_0_37 (io_devices_0_37),
  .io_devices_0_38 (io_devices_0_38),
  .io_devices_0_39 (io_devices_0_39),
  .io_devices_0_40 (io_devices_0_40),
  .io_devices_0_41 (io_devices_0_41),
  .io_devices_0_42 (io_devices_0_42),
  .io_devices_0_43 (io_devices_0_43),
  .io_devices_0_44 (io_devices_0_44),
  .io_devices_0_45 (io_devices_0_45),
  .io_devices_0_46 (io_devices_0_46),
  .io_devices_0_47 (io_devices_0_47),
  .io_devices_0_48 (io_devices_0_48),
  .io_devices_0_49 (io_devices_0_49),
  .io_devices_0_50 (io_devices_0_50),
  .io_harts_0_0    (io_harts_0_0   ) 

);

endmodule
