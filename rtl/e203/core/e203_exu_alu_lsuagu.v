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
//  This module to implement the AGU (address generation unit for load/store 
//  and AMO instructions), which is mostly share the datapath with ALU module
//  to save gatecount to mininum
//
//
// ====================================================================
`include "e203_defines.v"

module e203_exu_alu_lsuagu(

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The Issue Handshake Interface to AGU 
  //
  input  agu_i_valid, // Handshake valid
  output agu_i_ready, // Handshake ready

  input  [`E203_XLEN-1:0] agu_i_rs1,
  input  [`E203_XLEN-1:0] agu_i_rs2,
  input  [`E203_XLEN-1:0] agu_i_imm,
  input  [`E203_DECINFO_AGU_WIDTH-1:0] agu_i_info,
  input  [`E203_ITAG_WIDTH-1:0] agu_i_itag,

  output agu_i_longpipe,

  input  flush_req,
  input  flush_pulse,

  output agu_no_outs_mem,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The AGU Write-Back/Commit Interface
  output agu_o_valid, // Handshake valid
  input  agu_o_ready, // Handshake ready
  output [`E203_XLEN-1:0] agu_o_wbck_wdat,
  output agu_o_wbck_err,   
  //   The Commit Interface for all ldst and amo instructions
  output agu_o_cmt_misalgn, // The misalign exception generated
  output agu_o_cmt_ld, 
  output agu_o_cmt_stamo,
  output agu_o_cmt_buserr, // The bus-error exception generated
  output [`E203_ADDR_SIZE-1:0] agu_o_cmt_badaddr,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to LSU-ctrl
  //    * Bus cmd channel
  output                       agu_icb_cmd_valid, // Handshake valid
  input                        agu_icb_cmd_ready, // Handshake ready
            // Note: The data on rdata or wdata channel must be naturally
            //       aligned, this is in line with the AXI definition
  output [`E203_ADDR_SIZE-1:0] agu_icb_cmd_addr, // Bus transaction start addr 
  output                       agu_icb_cmd_read,   // Read or write
  output [`E203_XLEN-1:0]      agu_icb_cmd_wdata, 
  output [`E203_XLEN/8-1:0]    agu_icb_cmd_wmask, 
  output                       agu_icb_cmd_back2agu, 
  output                       agu_icb_cmd_lock,
  output                       agu_icb_cmd_excl,
  output [1:0]                 agu_icb_cmd_size,
  output [`E203_ITAG_WIDTH-1:0]agu_icb_cmd_itag,
  output                       agu_icb_cmd_usign,

  //    * Bus RSP channel
  input                        agu_icb_rsp_valid, // Response valid 
  output                       agu_icb_rsp_ready, // Response ready
  input                        agu_icb_rsp_err  , // Response error
  input                        agu_icb_rsp_excl_ok,
            // Note: the RSP rdata is inline with AXI definition
  input  [`E203_XLEN-1:0]      agu_icb_rsp_rdata,


  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // To share the ALU datapath, generate interface to ALU
  //   for single-issue machine, seems the AGU must be shared with ALU, otherwise
  //   it wasted the area for no points 
  // 
     // The operands and info to ALU
  output [`E203_XLEN-1:0] agu_req_alu_op1,
  output [`E203_XLEN-1:0] agu_req_alu_op2,
  output agu_req_alu_swap,
  output agu_req_alu_add ,
  output agu_req_alu_and ,
  output agu_req_alu_or  ,
  output agu_req_alu_xor ,
  output agu_req_alu_max ,
  output agu_req_alu_min ,
  output agu_req_alu_maxu,
  output agu_req_alu_minu,
  input  [`E203_XLEN-1:0] agu_req_alu_res,

     // The Shared-Buffer interface to ALU-Shared-Buffer
  output agu_sbf_0_ena,
  output [`E203_XLEN-1:0] agu_sbf_0_nxt,
  input  [`E203_XLEN-1:0] agu_sbf_0_r,

  output agu_sbf_1_ena,
  output [`E203_XLEN-1:0] agu_sbf_1_nxt,
  input  [`E203_XLEN-1:0] agu_sbf_1_r,

  input  clk,
  input  rst_n
  );

  //

      // When there is a nonalu_flush which is going to flush the ALU, then we need to mask off it
  wire       icb_sta_is_idle;
  wire       flush_block = flush_req & icb_sta_is_idle; 

  wire       agu_i_load    = agu_i_info [`E203_DECINFO_AGU_LOAD   ] & (~flush_block);
  wire       agu_i_store   = agu_i_info [`E203_DECINFO_AGU_STORE  ] & (~flush_block);
  wire       agu_i_amo     = agu_i_info [`E203_DECINFO_AGU_AMO    ] & (~flush_block);

  wire [1:0] agu_i_size    = agu_i_info [`E203_DECINFO_AGU_SIZE   ];
  wire       agu_i_usign   = agu_i_info [`E203_DECINFO_AGU_USIGN  ];
  wire       agu_i_excl    = agu_i_info [`E203_DECINFO_AGU_EXCL   ];
  wire       agu_i_amoswap = agu_i_info [`E203_DECINFO_AGU_AMOSWAP];
  wire       agu_i_amoadd  = agu_i_info [`E203_DECINFO_AGU_AMOADD ];
  wire       agu_i_amoand  = agu_i_info [`E203_DECINFO_AGU_AMOAND ];
  wire       agu_i_amoor   = agu_i_info [`E203_DECINFO_AGU_AMOOR  ];
  wire       agu_i_amoxor  = agu_i_info [`E203_DECINFO_AGU_AMOXOR ];
  wire       agu_i_amomax  = agu_i_info [`E203_DECINFO_AGU_AMOMAX ];
  wire       agu_i_amomin  = agu_i_info [`E203_DECINFO_AGU_AMOMIN ];
  wire       agu_i_amomaxu = agu_i_info [`E203_DECINFO_AGU_AMOMAXU];
  wire       agu_i_amominu = agu_i_info [`E203_DECINFO_AGU_AMOMINU];


  wire agu_icb_cmd_hsked = agu_icb_cmd_valid & agu_icb_cmd_ready; 
    // These strange ifdef/ifndef rather than the ifdef-else, because of 
    //   our internal text processing scripts need this style
  `ifndef E203_SUPPORT_AMO//{
    `ifndef E203_SUPPORT_UNALGNLDST//{
  wire agu_icb_rsp_hsked = 1'b0;
    `endif//}
  `endif//}

  wire agu_i_size_b  = (agu_i_size == 2'b00);
  wire agu_i_size_hw = (agu_i_size == 2'b01);
  wire agu_i_size_w  = (agu_i_size == 2'b10);

  wire agu_i_addr_unalgn = 
            (agu_i_size_hw &  agu_icb_cmd_addr[0])
          | (agu_i_size_w  &  (|agu_icb_cmd_addr[1:0]));

  wire state_last_exit_ena;

  wire agu_addr_unalgn = 
  `ifndef E203_SUPPORT_UNALGNLDST//{
      `ifndef E203_SUPPORT_AMO//{
      agu_i_addr_unalgn;
      `endif//}
  `endif//}

 
  wire agu_i_unalgnld = agu_addr_unalgn & agu_i_load;
  wire agu_i_unalgnst = agu_addr_unalgn & agu_i_store;
  wire agu_i_unalgnldst = agu_i_unalgnld | agu_i_unalgnst;
  wire agu_i_algnld = (~agu_addr_unalgn) & agu_i_load;
  wire agu_i_algnst = (~agu_addr_unalgn) & agu_i_store;
  wire agu_i_algnldst = agu_i_algnld | agu_i_algnst;


  wire agu_i_ofst0  = agu_i_amo | ((agu_i_load | agu_i_store) & agu_i_excl); 


  localparam ICB_STATE_WIDTH = 4;

  wire icb_state_ena;
  wire [ICB_STATE_WIDTH-1:0] icb_state_nxt;
  wire [ICB_STATE_WIDTH-1:0] icb_state_r;

  // State 0: The idle state, means there is no any oustanding ifetch request
  localparam ICB_STATE_IDLE = 4'd0;
  
   
  
 

  // Define some common signals and reused later to save gatecounts
  assign icb_sta_is_idle    = (icb_state_r == ICB_STATE_IDLE   );



    // The state will only toggle when each state is meeting the condition to exit:
  assign icb_state_ena = 1'b0 
          ;

  // The next-state is onehot mux to select different entries
  assign icb_state_nxt = 
              ({ICB_STATE_WIDTH{1'b0}})
              ;


  sirv_gnrl_dfflr #(ICB_STATE_WIDTH) icb_state_dfflr (icb_state_ena, icb_state_nxt, icb_state_r, clk, rst_n);


  `ifndef E203_SUPPORT_AMO//{
  wire  icb_sta_is_last = 1'b0; 
  `endif//}

  `ifndef E203_SUPPORT_AMO//{
  assign state_last_exit_ena = 1'b0;
  `endif//}

  `ifndef E203_SUPPORT_UNALGNLDST//{
  `else//}{
      `ifndef E203_SUPPORT_AMO 
  !!!! ERROR: This config is not supported, must be something wrong 
      `endif//}
  `endif//


      // Indicate there is no oustanding memory transactions
  `ifndef E203_SUPPORT_AMO//{
  assign agu_no_outs_mem = 1'b1;// If no AMO or UNaligned supported, then always 0
  `endif//}
  //
  /////////////////////////////////////////////////////////////////////////////////
  // Implement the leftover 0 buffer
  wire leftover_ena;
  wire [`E203_XLEN-1:0] leftover_nxt;
  wire [`E203_XLEN-1:0] leftover_r;
  wire leftover_err_nxt;
  wire leftover_err_r;

  wire [`E203_XLEN-1:0] leftover_1_r;
  wire leftover_1_ena;
  wire [`E203_XLEN-1:0] leftover_1_nxt;
  //
  assign leftover_ena = agu_icb_rsp_hsked & (
                   1'b0
                   );
  assign leftover_nxt = 
              {`E203_XLEN{1'b0}}
            ;
                                   
  assign leftover_err_nxt = 1'b0 
         ;
  //
  // The instantiation of leftover buffer is actually shared with the ALU SBF-0 Buffer
  assign agu_sbf_0_ena = leftover_ena;
  assign agu_sbf_0_nxt = leftover_nxt;
  assign leftover_r    = agu_sbf_0_r;

  // The error bit is implemented here
  sirv_gnrl_dfflr #(1) icb_leftover_err_dfflr (leftover_ena, leftover_err_nxt, leftover_err_r, clk, rst_n);
  
  assign leftover_1_ena = 1'b0 
         ;
  assign leftover_1_nxt = agu_req_alu_res;
  //
  // The instantiation of last_icb_addr buffer is actually shared with the ALU SBF-1 Buffer
  assign agu_sbf_1_ena   = leftover_1_ena;
  assign agu_sbf_1_nxt   = leftover_1_nxt;
  assign leftover_1_r = agu_sbf_1_r;


  assign agu_req_alu_add  = 1'b0
                           // To cut down the timing loop from agu_i_valid // | (icb_sta_is_idle & agu_i_valid)
                           //   we dont need this signal at all
                           | icb_sta_is_idle
                           ;

  assign agu_req_alu_op1 =  icb_sta_is_idle   ? agu_i_rs1
                     `ifndef E203_SUPPORT_UNALGNLDST//{
                          : `E203_XLEN'd0 
                     `endif//}
                     ;

  wire [`E203_XLEN-1:0] agu_addr_gen_op2 = agu_i_ofst0 ? `E203_XLEN'b0 : agu_i_imm;
  assign agu_req_alu_op2 =  icb_sta_is_idle   ? agu_addr_gen_op2 
                     `ifndef E203_SUPPORT_UNALGNLDST//{
                          : `E203_XLEN'd0 
                     `endif//}
                     ;

  `ifndef E203_SUPPORT_AMO//{
  assign agu_req_alu_swap = 1'b0;
  assign agu_req_alu_and  = 1'b0;
  assign agu_req_alu_or   = 1'b0;
  assign agu_req_alu_xor  = 1'b0;
  assign agu_req_alu_max  = 1'b0;
  assign agu_req_alu_min  = 1'b0;
  assign agu_req_alu_maxu = 1'b0;
  assign agu_req_alu_minu = 1'b0;
  `endif//}


/////////////////////////////////////////////////////////////////////////////////
// Implement the AGU op handshake ready signal
//
// The AGU op handshakeke interface will be ready when
//   * If it is unaligned instructions, then it will just 
//       directly pass out the write-back interface, hence it will only be 
//       ready when the write-back interface is ready
//   * If it is not unaligned load/store instructions, then it will just 
//       directly pass out the instruction to LSU-ctrl interface, hence it need to check
//       the AGU ICB interface is ready, but it also need to ask write-back interface 
//       for commit, so, also need to check if write-back interfac is ready
//       
  `ifndef E203_SUPPORT_UNALGNLDST//{
  `else//}{
  !!!! ERROR: This UNALIGNED load/store is not supported, must be something wrong 
  `endif//}

  assign agu_i_ready =
      ( 1'b0
       ) ? state_last_exit_ena :
      (agu_icb_cmd_ready & agu_o_ready) ;
  
  // The aligned load/store instruction will be dispatched to LSU as long pipeline
  //   instructions
  assign agu_i_longpipe = agu_i_algnldst;
  

  //
  /////////////////////////////////////////////////////////////////////////////////
  // Implement the Write-back interfaces (unaligned and AMO instructions) 

  // The AGU write-back will be valid when:
  //   * For the aligned load/store
  //       Directly passed to ICB interface, but also need to pass 
  //       to write-back interface asking for commit
  assign agu_o_valid = 
      // For the aligned load/store and unaligned AMO, it will be send
      //   to the commit stage right the same cycle of agu_i_valid
      |(
         agu_i_valid & ( agu_i_algnldst 
        `ifndef E203_SUPPORT_UNALGNLDST//{
           // If not support the unaligned load/store by hardware, then 
               // the unaligned load/store will be treated as exception
               // and it will also be send to the commit stage right the
               // same cycle of agu_i_valid
           | agu_i_unalgnldst
        `endif//}
         )
          ////  // Since it is issuing to commit stage and 
          ////  // LSU at same cycle, so we must qualify the icb_cmd_ready signal from LSU
          ////  // to make sure it is out to commit/LSU at same cycle
               // To cut the critical timing  path from longpipe signal
               // we always assume the AGU will need icb_cmd_ready
          & agu_icb_cmd_ready
      );

  assign agu_o_wbck_wdat = {`E203_XLEN{1'b0 }}
       ;

  assign agu_o_cmt_buserr = 1'b0 
                ;
  assign agu_o_cmt_badaddr = agu_icb_cmd_addr;


  assign agu_o_cmt_misalgn = 1'b0
                       | (agu_i_unalgnldst) //& agu_i_excl) We dont support unaligned load/store regardless it is AMO or not
                       ;
  assign agu_o_cmt_ld      = agu_i_load & (~agu_i_excl); 
  assign agu_o_cmt_stamo   = agu_i_store | agu_i_amo | agu_i_excl;

  
  // The exception or error result cannot write-back
  assign agu_o_wbck_err = agu_o_cmt_buserr | agu_o_cmt_misalgn;


  assign agu_icb_rsp_ready = 1'b1;


  

  assign agu_icb_cmd_valid = 
            ((agu_i_algnldst & agu_i_valid)
              // We must qualify the agu_o_ready signal from commit stage
              // to make sure it is out to commit/LSU at same cycle
              & (agu_o_ready)
            )
            ;
  assign agu_icb_cmd_addr = agu_req_alu_res[`E203_ADDR_SIZE-1:0];

  assign agu_icb_cmd_read = 
            (agu_i_algnldst & agu_i_load) 
          ;
     // The AGU ICB CMD Wdata sources:
     //   * For the aligned store instructions
     //       Directly passed to AGU ICB, wdata is op2 repetitive form, 
     //       wmask is generated according to the LSB and size


  wire [`E203_XLEN-1:0] algnst_wdata = 
            ({`E203_XLEN{agu_i_size_b }} & {4{agu_i_rs2[ 7:0]}})
          | ({`E203_XLEN{agu_i_size_hw}} & {2{agu_i_rs2[15:0]}})
          | ({`E203_XLEN{agu_i_size_w }} & {1{agu_i_rs2[31:0]}});
  wire [`E203_XLEN/8-1:0] algnst_wmask = 
            ({`E203_XLEN/8{agu_i_size_b }} & (4'b0001 << agu_icb_cmd_addr[1:0]))
          | ({`E203_XLEN/8{agu_i_size_hw}} & (4'b0011 << {agu_icb_cmd_addr[1],1'b0}))
          | ({`E203_XLEN/8{agu_i_size_w }} & (4'b1111));

          
  assign agu_icb_cmd_wdata = 
      algnst_wdata;

  assign agu_icb_cmd_wmask =
      algnst_wmask; 

  assign agu_icb_cmd_back2agu = 1'b0 
             ;
  //We dont support lock and exclusive in such 2 stage simple implementation
  assign agu_icb_cmd_lock     = 1'b0 
                 ;
  assign agu_icb_cmd_excl     = 1'b0
                 ;

  assign agu_icb_cmd_itag     = agu_i_itag;
  assign agu_icb_cmd_usign    = agu_i_usign;
  assign agu_icb_cmd_size     = 
                agu_i_size;


endmodule                                      
                                               
                                               
                                               
