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
// Designer   : Bob Hu
//
// Description:
//  The Write-Back module to arbitrate the write-back request from all 
//  long pipe modules
//
// ====================================================================

`include "e203_defines.v"

module e203_exu_longpwbck(




  //////////////////////////////////////////////////////////////
  // The LSU Write-Back Interface
  input  lsu_wbck_i_valid, // Handshake valid
  output lsu_wbck_i_ready, // Handshake ready
  input  [`E203_XLEN-1:0] lsu_wbck_i_wdat,
  input  [`E203_ITAG_WIDTH -1:0] lsu_wbck_i_itag,
  input  lsu_wbck_i_err , // The error exception generated
  input  lsu_cmt_i_buserr ,
  input  [`E203_ADDR_SIZE -1:0] lsu_cmt_i_badaddr,
  input  lsu_cmt_i_ld, 
  input  lsu_cmt_i_st, 

  //////////////////////////////////////////////////////////////
  // The Long pipe instruction Wback interface to final wbck module
  output longp_wbck_o_valid, // Handshake valid
  input  longp_wbck_o_ready, // Handshake ready
  output [`E203_FLEN-1:0] longp_wbck_o_wdat,
  output [5-1:0] longp_wbck_o_flags,
  output [`E203_RFIDX_WIDTH -1:0] longp_wbck_o_rdidx,
  output longp_wbck_o_rdfpu,
  //
  // The Long pipe instruction Exception interface to commit stage
  output  longp_excp_o_valid,
  input   longp_excp_o_ready,
  output  longp_excp_o_insterr,
  output  longp_excp_o_ld,
  output  longp_excp_o_st,
  output  longp_excp_o_buserr , // The load/store bus-error exception generated
  output [`E203_ADDR_SIZE-1:0] longp_excp_o_badaddr,
  output [`E203_PC_SIZE -1:0] longp_excp_o_pc,
  //
  //The itag of toppest entry of OITF
  input  oitf_empty,
  input  [`E203_ITAG_WIDTH -1:0] oitf_ret_ptr,
  input  [`E203_RFIDX_WIDTH-1:0] oitf_ret_rdidx,
  input  [`E203_PC_SIZE-1:0] oitf_ret_pc,
  input  oitf_ret_rdwen,   
  input  oitf_ret_rdfpu,   
  output oitf_ret_ena,
  
  input  clk,
  input  rst_n
  );


  // The Long-pipe instruction can write-back only when it's itag 
  //   is same as the itag of toppest entry of OITF
  wire wbck_ready4lsu = (lsu_wbck_i_itag == oitf_ret_ptr) & (~oitf_empty);
  wire wbck_sel_lsu = lsu_wbck_i_valid & wbck_ready4lsu;

  //assign longp_excp_o_ld   = wbck_sel_lsu & lsu_cmt_i_ld;
  //assign longp_excp_o_st   = wbck_sel_lsu & lsu_cmt_i_st;
  //assign longp_excp_o_buserr = wbck_sel_lsu & lsu_cmt_i_buserr;
  //assign longp_excp_o_badaddr = wbck_sel_lsu ? lsu_cmt_i_badaddr : `E203_ADDR_SIZE'b0;

  assign {
         longp_excp_o_insterr
        ,longp_excp_o_ld   
        ,longp_excp_o_st  
        ,longp_excp_o_buserr
        ,longp_excp_o_badaddr } = 
             ({`E203_ADDR_SIZE+4{wbck_sel_lsu}} & 
              {
                1'b0,
                lsu_cmt_i_ld,
                lsu_cmt_i_st,
                lsu_cmt_i_buserr,
                lsu_cmt_i_badaddr
              }) 
              ;

  //////////////////////////////////////////////////////////////
  // The Final arbitrated Write-Back Interface
  wire wbck_i_ready;
  wire wbck_i_valid;
  wire [`E203_FLEN-1:0] wbck_i_wdat;
  wire [5-1:0] wbck_i_flags;
  wire [`E203_RFIDX_WIDTH-1:0] wbck_i_rdidx;
  wire [`E203_PC_SIZE-1:0] wbck_i_pc;
  wire wbck_i_rdwen;
  wire wbck_i_rdfpu;
  wire wbck_i_err ;

  assign lsu_wbck_i_ready = wbck_ready4lsu & wbck_i_ready;

  assign wbck_i_valid = ({1{wbck_sel_lsu}} & lsu_wbck_i_valid) 
                         ;
  `ifdef E203_FLEN_IS_32 //{
  wire [`E203_FLEN-1:0] lsu_wbck_i_wdat_exd = lsu_wbck_i_wdat;
  `else//}{
  wire [`E203_FLEN-1:0] lsu_wbck_i_wdat_exd = {{`E203_FLEN-`E203_XLEN{1'b0}},lsu_wbck_i_wdat};
  `endif//}
  assign wbck_i_wdat  = ({`E203_FLEN{wbck_sel_lsu}} & lsu_wbck_i_wdat_exd ) 
                         ;
  assign wbck_i_flags  = 5'b0
                         ;
  assign wbck_i_err   = wbck_sel_lsu & lsu_wbck_i_err 
                         ;
  assign wbck_i_pc    = oitf_ret_pc;
  assign wbck_i_rdidx = oitf_ret_rdidx;
  assign wbck_i_rdwen = oitf_ret_rdwen;
  assign wbck_i_rdfpu = oitf_ret_rdfpu;

  // If the instruction have no error and it have the rdwen, then it need to 
  //   write back into regfile, otherwise, it does not need to write regfile
  wire need_wbck = wbck_i_rdwen & (~wbck_i_err);

  // If the long pipe instruction have error result, then it need to handshake
  //   with the commit module.
  wire need_excp = wbck_i_err;

  assign wbck_i_ready = 
       (need_wbck ? longp_wbck_o_ready : 1'b1)
     & (need_excp ? longp_excp_o_ready : 1'b1);


  assign longp_wbck_o_valid = need_wbck & wbck_i_valid & (need_excp ? longp_excp_o_ready : 1'b1);
  assign longp_excp_o_valid = need_excp & wbck_i_valid & (need_wbck ? longp_wbck_o_ready : 1'b1);

  assign longp_wbck_o_wdat  = wbck_i_wdat ;
  assign longp_wbck_o_flags = wbck_i_flags ;
  assign longp_wbck_o_rdfpu = wbck_i_rdfpu ;
  assign longp_wbck_o_rdidx = wbck_i_rdidx;

  assign longp_excp_o_pc    = wbck_i_pc;

  assign oitf_ret_ena = wbck_i_valid & wbck_i_ready;

endmodule                                      
                                               
                                               
                                               
