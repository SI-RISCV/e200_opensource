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
//  This module to implement the Conditional Branch Instructions,
//  which is mostly share the datapath with ALU adder to resolve the comparasion
//  result to save gatecount to mininum
//
//
// ====================================================================
`include "e203_defines.v"

module e203_exu_alu_bjp(

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The Handshake Interface
  //
  input  bjp_i_valid, // Handshake valid
  output bjp_i_ready, // Handshake ready

  input  [`E203_XLEN-1:0] bjp_i_rs1,
  input  [`E203_XLEN-1:0] bjp_i_rs2,
  input  [`E203_XLEN-1:0] bjp_i_imm,
  input  [`E203_PC_SIZE-1:0] bjp_i_pc,
  input  [`E203_DECINFO_BJP_WIDTH-1:0] bjp_i_info,
  
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The BJP Commit Interface
  output bjp_o_valid, // Handshake valid
  input  bjp_o_ready, // Handshake ready
    //   The Write-Back Result for JAL and JALR
  output [`E203_XLEN-1:0] bjp_o_wbck_wdat,
  output bjp_o_wbck_err,
    //   The Commit Result for BJP
  output bjp_o_cmt_bjp,
  output bjp_o_cmt_mret,
  output bjp_o_cmt_dret,
  output bjp_o_cmt_fencei,
  output bjp_o_cmt_prdt,// The predicted ture/false  
  output bjp_o_cmt_rslv,// The resolved ture/false

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // To share the ALU datapath
  // 
     // The operands and info to ALU

  output [`E203_XLEN-1:0] bjp_req_alu_op1,
  output [`E203_XLEN-1:0] bjp_req_alu_op2,
  output bjp_req_alu_cmp_eq ,
  output bjp_req_alu_cmp_ne ,
  output bjp_req_alu_cmp_lt ,
  output bjp_req_alu_cmp_gt ,
  output bjp_req_alu_cmp_ltu,
  output bjp_req_alu_cmp_gtu,
  output bjp_req_alu_add,

  input  bjp_req_alu_cmp_res,
  input  [`E203_XLEN-1:0] bjp_req_alu_add_res,

  input  clk,
  input  rst_n
  );


  wire mret   = bjp_i_info [`E203_DECINFO_BJP_MRET ]; 
  wire dret   = bjp_i_info [`E203_DECINFO_BJP_DRET ]; 
  wire fencei = bjp_i_info [`E203_DECINFO_BJP_FENCEI ]; 
  wire bxx   = bjp_i_info [`E203_DECINFO_BJP_BXX ]; 
  wire jump  = bjp_i_info [`E203_DECINFO_BJP_JUMP ]; 
  wire rv32  = bjp_i_info [`E203_DECINFO_RV32]; 

  wire wbck_link = jump;

  wire bjp_i_bprdt = bjp_i_info [`E203_DECINFO_BJP_BPRDT ];

  assign bjp_req_alu_op1 = wbck_link ? 
                            bjp_i_pc 
                          : bjp_i_rs1;
  assign bjp_req_alu_op2 = wbck_link ? 
                            (rv32 ? `E203_XLEN'd4 : `E203_XLEN'd2)
                          : bjp_i_rs2;

  assign bjp_o_cmt_bjp = bxx | jump;
  assign bjp_o_cmt_mret = mret;
  assign bjp_o_cmt_dret = dret;
  assign bjp_o_cmt_fencei = fencei;

  assign bjp_req_alu_cmp_eq  = bjp_i_info [`E203_DECINFO_BJP_BEQ  ]; 
  assign bjp_req_alu_cmp_ne  = bjp_i_info [`E203_DECINFO_BJP_BNE  ]; 
  assign bjp_req_alu_cmp_lt  = bjp_i_info [`E203_DECINFO_BJP_BLT  ]; 
  assign bjp_req_alu_cmp_gt  = bjp_i_info [`E203_DECINFO_BJP_BGT  ]; 
  assign bjp_req_alu_cmp_ltu = bjp_i_info [`E203_DECINFO_BJP_BLTU ]; 
  assign bjp_req_alu_cmp_gtu = bjp_i_info [`E203_DECINFO_BJP_BGTU ]; 

  assign bjp_req_alu_add  = wbck_link;

  assign bjp_o_valid     = bjp_i_valid;
  assign bjp_i_ready     = bjp_o_ready;
  assign bjp_o_cmt_prdt  = bjp_i_bprdt;
  assign bjp_o_cmt_rslv  = jump ? 1'b1 : bjp_req_alu_cmp_res;

  assign bjp_o_wbck_wdat  = bjp_req_alu_add_res;
  assign bjp_o_wbck_err   = 1'b0;

endmodule
