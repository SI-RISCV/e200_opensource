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
// Designer   : Bob Hu
//
// Description:
//  This module to implement the CSR instructions
//
//
// ====================================================================
`include "e203_defines.v"

module e203_exu_alu_csrctrl(

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The Handshake Interface 
  //
  input  csr_i_valid, // Handshake valid
  output csr_i_ready, // Handshake ready

  input  [`E203_XLEN-1:0] csr_i_rs1,
  input  [`E203_DECINFO_CSR_WIDTH-1:0] csr_i_info,
  input  csr_i_rdwen,   

  output csr_ena,
  output csr_wr_en,
  output csr_rd_en,
  output [12-1:0] csr_idx,

  input  csr_access_ilgl,
  input  [`E203_XLEN-1:0] read_csr_dat,
  output [`E203_XLEN-1:0] wbck_csr_dat,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The CSR Write-back/Commit Interface
  output csr_o_valid, // Handshake valid
  input  csr_o_ready, // Handshake ready
  //   The Write-Back Interface for Special (unaligned ldst and AMO instructions) 
  output [`E203_XLEN-1:0] csr_o_wbck_wdat,
  output csr_o_wbck_err,   

  input  clk,
  input  rst_n
  );

  assign csr_o_valid      = csr_i_valid;
  assign csr_i_ready      = csr_o_ready;
  assign csr_o_wbck_err   = csr_access_ilgl;
  assign csr_o_wbck_wdat  = read_csr_dat;

  wire        csrrw  = csr_i_info[`E203_DECINFO_CSR_CSRRW ];
  wire        csrrs  = csr_i_info[`E203_DECINFO_CSR_CSRRS ];
  wire        csrrc  = csr_i_info[`E203_DECINFO_CSR_CSRRC ];
  wire        rs1imm = csr_i_info[`E203_DECINFO_CSR_RS1IMM];
  wire        rs1is0 = csr_i_info[`E203_DECINFO_CSR_RS1IS0];
  wire [4:0]  zimm   = csr_i_info[`E203_DECINFO_CSR_ZIMMM ];
  wire [11:0] csridx = csr_i_info[`E203_DECINFO_CSR_CSRIDX];

  wire [`E203_XLEN-1:0] csr_op1 = rs1imm ? {27'b0,zimm} : csr_i_rs1;

  assign csr_rd_en = csr_i_valid & 
    (
      (csrrw ? csr_i_rdwen : 1'b0) // the CSRRW only read when the destination reg need to be writen
      | csrrs | csrrc // The set and clear operation always need to read CSR
     );
  assign csr_wr_en = csr_i_valid & (
                csrrw // CSRRW always write the original RS1 value into the CSR
               | ((csrrs | csrrc) & (~rs1is0)) // for CSRRS/RC, if the RS is x0, then should not really write                                        
            );                                                                           
                                                                                         
  assign csr_idx = csridx;

  assign csr_ena = csr_o_valid & csr_o_ready;

  assign wbck_csr_dat = 
              ({`E203_XLEN{csrrw}} & csr_op1)
            | ({`E203_XLEN{csrrs}} & (  csr_op1  | read_csr_dat))
            | ({`E203_XLEN{csrrc}} & ((~csr_op1) & read_csr_dat));

endmodule
