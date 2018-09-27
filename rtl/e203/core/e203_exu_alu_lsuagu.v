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

  output amo_wait,
  input  oitf_empty,

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
  `ifdef E203_SUPPORT_AMO//{
  wire agu_icb_rsp_hsked = agu_icb_rsp_valid & agu_icb_rsp_ready; 
  `endif//E203_SUPPORT_AMO}
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
  `ifdef E203_SUPPORT_AMO//{
  wire state_idle_exit_ena;
  wire unalgn_flg_r;
  // Set when the ICB state is starting and it is unalign
  wire unalgn_flg_set = agu_i_addr_unalgn & state_idle_exit_ena;
  // Clear when the ICB state is entering
  wire unalgn_flg_clr = unalgn_flg_r & state_last_exit_ena;
  wire unalgn_flg_ena = unalgn_flg_set | unalgn_flg_clr;
  wire unalgn_flg_nxt = unalgn_flg_set | (~unalgn_flg_clr);
  sirv_gnrl_dfflr #(1) unalgn_flg_dffl (unalgn_flg_ena, unalgn_flg_nxt, unalgn_flg_r, clk, rst_n);
  `endif//E203_SUPPORT_AMO}

  wire agu_addr_unalgn = 
  `ifndef E203_SUPPORT_UNALGNLDST//{
      `ifdef E203_SUPPORT_AMO//{
      icb_sta_is_idle ? agu_i_addr_unalgn : unalgn_flg_r;
      `endif//E203_SUPPORT_AMO}
      `ifndef E203_SUPPORT_AMO//{
      agu_i_addr_unalgn;
      `endif//}
  `endif//}

 
  wire agu_i_unalgnld = (agu_addr_unalgn & agu_i_load)
                      ;
  wire agu_i_unalgnst = (agu_addr_unalgn & agu_i_store) 
                      ;
  wire agu_i_unalgnldst = (agu_i_unalgnld | agu_i_unalgnst)
                      ;
  wire agu_i_algnld = (~agu_addr_unalgn) & agu_i_load
                      ;
  wire agu_i_algnst = (~agu_addr_unalgn) & agu_i_store
                      ;
  wire agu_i_algnldst = (agu_i_algnld | agu_i_algnst)
                      ;

  `ifdef E203_SUPPORT_AMO//{
  wire agu_i_unalgnamo = (agu_addr_unalgn & agu_i_amo) 
                        ;
  wire agu_i_algnamo = ((~agu_addr_unalgn) & agu_i_amo) 
                        ;
  `endif//E203_SUPPORT_AMO}

  wire agu_i_ofst0  = agu_i_amo | ((agu_i_load | agu_i_store) & agu_i_excl); 


  localparam ICB_STATE_WIDTH = 4;

  wire icb_state_ena;
  wire [ICB_STATE_WIDTH-1:0] icb_state_nxt;
  wire [ICB_STATE_WIDTH-1:0] icb_state_r;

  // State 0: The idle state, means there is no any oustanding ifetch request
  localparam ICB_STATE_IDLE = 4'd0;
  `ifdef E203_SUPPORT_AMO//{
  // State  : Issued first request and wait response
  localparam ICB_STATE_1ST  = 4'd1;
  // State  : Wait to issue second request 
  localparam ICB_STATE_WAIT2ND  = 4'd2;
  // State  : Issued second request and wait response
  localparam ICB_STATE_2ND  = 4'd3;
  // State  : For AMO instructions, in this state, read-data was in leftover
  //            buffer for ALU calculation 
  localparam ICB_STATE_AMOALU  = 4'd4;
  // State  : For AMO instructions, in this state, ALU have caculated the new
  //            result and put into leftover buffer again 
  localparam ICB_STATE_AMORDY  = 4'd5;
  // State  : For AMO instructions, in this state, the response data have been returned
  //            and the write back result to commit/wback interface
  localparam ICB_STATE_WBCK  = 4'd6;
  `endif//E203_SUPPORT_AMO}
  
   
  
 
  `ifdef E203_SUPPORT_AMO//{
  wire [ICB_STATE_WIDTH-1:0] state_idle_nxt   ;
  wire [ICB_STATE_WIDTH-1:0] state_1st_nxt    ;
  wire [ICB_STATE_WIDTH-1:0] state_wait2nd_nxt;
  wire [ICB_STATE_WIDTH-1:0] state_2nd_nxt    ;
  wire [ICB_STATE_WIDTH-1:0] state_amoalu_nxt ;
  wire [ICB_STATE_WIDTH-1:0] state_amordy_nxt ;
  wire [ICB_STATE_WIDTH-1:0] state_wbck_nxt ;
  `endif//E203_SUPPORT_AMO}
  `ifdef E203_SUPPORT_AMO//{
  wire state_1st_exit_ena      ;
  wire state_wait2nd_exit_ena  ;
  wire state_2nd_exit_ena      ;
  wire state_amoalu_exit_ena   ;
  wire state_amordy_exit_ena   ;
  wire state_wbck_exit_ena   ;
  `endif//E203_SUPPORT_AMO}

  // Define some common signals and reused later to save gatecounts
  assign icb_sta_is_idle    = (icb_state_r == ICB_STATE_IDLE   );
  `ifdef E203_SUPPORT_AMO//{
  wire   icb_sta_is_1st     = (icb_state_r == ICB_STATE_1ST    );
  wire   icb_sta_is_amoalu  = (icb_state_r == ICB_STATE_AMOALU );
  wire   icb_sta_is_amordy  = (icb_state_r == ICB_STATE_AMORDY );
  wire   icb_sta_is_wait2nd = (icb_state_r == ICB_STATE_WAIT2ND);
  wire   icb_sta_is_2nd     = (icb_state_r == ICB_STATE_2ND    );
  wire   icb_sta_is_wbck    = (icb_state_r == ICB_STATE_WBCK    );
  `endif//E203_SUPPORT_AMO}


  `ifdef E203_SUPPORT_AMO//{
      // **** If the current state is idle,
          // If a new load-store come and the ICB cmd channel is handshaked, next
          //   state is ICB_STATE_1ST
  wire state_idle_to_exit =    (( agu_i_algnamo
                                  // Why do we add an oitf empty signal here? because
                                  //   it is better to start AMO state-machine when the 
                                  //   long-pipes are completed, to avoid the long-pipes 
                                  //   have error-return which need to flush the pipeline
                                  //   and which also need to wait the AMO state-machine
                                  //   to complete first, in corner cases it may end 
                                  //   up with deadlock.
                                  // Force to wait oitf empty before doing amo state-machine
                                  //   may hurt performance, but we dont care it. In e200 implementation
                                  //   the AMO was not target for performance.
                                  & oitf_empty)
                                 );
  assign state_idle_exit_ena = icb_sta_is_idle & state_idle_to_exit 
                               & agu_icb_cmd_hsked & (~flush_pulse);
  assign state_idle_nxt      = ICB_STATE_1ST;

      // **** If the current state is 1st,
          // If a response come, exit this state
  assign state_1st_exit_ena = icb_sta_is_1st & (agu_icb_rsp_hsked | flush_pulse);
  assign state_1st_nxt      = flush_pulse ? ICB_STATE_IDLE : 
                (
                 // (agu_i_algnamo) ?  // No need this condition, because it will be either
                                       // amo or unalgn load-store in this state
                  ICB_STATE_AMOALU
                );
            
      // **** If the current state is AMOALU 
              // Since the ALU is must be holdoff now, it can always be
              //   served and then enter into next state
  assign state_amoalu_exit_ena = icb_sta_is_amoalu & ( 1'b1 | flush_pulse);
  assign state_amoalu_nxt      = flush_pulse ? ICB_STATE_IDLE : ICB_STATE_AMORDY;
            
      // **** If the current state is AMORDY
              // It always enter into next state
  assign state_amordy_exit_ena = icb_sta_is_amordy & ( 1'b1 | flush_pulse);
  assign state_amordy_nxt      = flush_pulse ? ICB_STATE_IDLE : 
            (
              // AMO after caculated read-modify-result, need to issue 2nd uop as store
              //   back to memory, hence two ICB needed and we dont care the performance,
              //   so always let it jump to wait2nd state
                                       ICB_STATE_WAIT2ND
            );

      // **** If the current state is wait-2nd,
  assign state_wait2nd_exit_ena = icb_sta_is_wait2nd & (agu_icb_cmd_ready | flush_pulse);
              // If the ICB CMD is ready, then next state is ICB_STATE_2ND
  assign state_wait2nd_nxt      = flush_pulse ? ICB_STATE_IDLE : ICB_STATE_2ND;
  
      // **** If the current state is 2nd,
          // If a response come, exit this state
  assign state_2nd_exit_ena = icb_sta_is_2nd & (agu_icb_rsp_hsked | flush_pulse);
  assign state_2nd_nxt      = flush_pulse ? ICB_STATE_IDLE : 
                (
                  ICB_STATE_WBCK 
                );

       // **** If the current state is wbck,
          // If it can be write back, exit this state
  assign state_wbck_exit_ena = icb_sta_is_wbck & (agu_o_ready | flush_pulse);
  assign state_wbck_nxt      = flush_pulse ? ICB_STATE_IDLE : 
                (
                  ICB_STATE_IDLE 
                );
  `endif//E203_SUPPORT_AMO}

    // The state will only toggle when each state is meeting the condition to exit:
  assign icb_state_ena = 1'b0 
         `ifdef E203_SUPPORT_AMO//{
            | state_idle_exit_ena | state_1st_exit_ena  
            | state_amoalu_exit_ena  | state_amordy_exit_ena  
            | state_wait2nd_exit_ena | state_2nd_exit_ena   
            | state_wbck_exit_ena 
          `endif//E203_SUPPORT_AMO}
          ;

  // The next-state is onehot mux to select different entries
  assign icb_state_nxt = 
              ({ICB_STATE_WIDTH{1'b0}})
         `ifdef E203_SUPPORT_AMO//{
            | ({ICB_STATE_WIDTH{state_idle_exit_ena   }} & state_idle_nxt   )
            | ({ICB_STATE_WIDTH{state_1st_exit_ena    }} & state_1st_nxt    )
            | ({ICB_STATE_WIDTH{state_amoalu_exit_ena }} & state_amoalu_nxt )
            | ({ICB_STATE_WIDTH{state_amordy_exit_ena }} & state_amordy_nxt )
            | ({ICB_STATE_WIDTH{state_wait2nd_exit_ena}} & state_wait2nd_nxt)
            | ({ICB_STATE_WIDTH{state_2nd_exit_ena    }} & state_2nd_nxt    )
            | ({ICB_STATE_WIDTH{state_wbck_exit_ena   }} & state_wbck_nxt   )
          `endif//E203_SUPPORT_AMO}
              ;


  sirv_gnrl_dfflr #(ICB_STATE_WIDTH) icb_state_dfflr (icb_state_ena, icb_state_nxt, icb_state_r, clk, rst_n);


  `ifdef E203_SUPPORT_AMO//{
  wire  icb_sta_is_last = icb_sta_is_wbck;
  `endif//E203_SUPPORT_AMO}
  `ifndef E203_SUPPORT_AMO//{
  wire  icb_sta_is_last = 1'b0; 
  `endif//}

  `ifdef E203_SUPPORT_AMO//{
  assign state_last_exit_ena = state_wbck_exit_ena;
  `endif//E203_SUPPORT_AMO}
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
  `ifdef E203_SUPPORT_AMO//{
                    // As long as the statemachine started, we must wait it to be empty
                    // We cannot really kill this instruction when IRQ comes, becuase
                    // the AMO uop alreay write data into the memory, and we must commit
                    // this instructions
  assign amo_wait = ~icb_sta_is_idle;
  `endif//E203_SUPPORT_AMO}
  `ifndef E203_SUPPORT_AMO//{
  assign amo_wait = 1'b0;// If no AMO or UNaligned supported, then always 0
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
 `ifdef E203_SUPPORT_AMO//{
  wire amo_1stuop = icb_sta_is_1st & agu_i_algnamo;
  wire amo_2nduop = icb_sta_is_2nd & agu_i_algnamo;
 `endif//E203_SUPPORT_AMO}
  assign leftover_ena = agu_icb_rsp_hsked & (
                   1'b0
                   `ifdef E203_SUPPORT_AMO//{
                   | amo_1stuop 
                   | amo_2nduop 
                   `endif//E203_SUPPORT_AMO}
                   );
  assign leftover_nxt = 
              {`E203_XLEN{1'b0}}
         `ifdef E203_SUPPORT_AMO//{
            | ({`E203_XLEN{amo_1stuop        }} & agu_icb_rsp_rdata)// Load the data from bus
            | ({`E203_XLEN{amo_2nduop        }} & leftover_r)// Unchange the value of leftover_r
         `endif//E203_SUPPORT_AMO}
            ;
                                   
  assign leftover_err_nxt = 1'b0 
         `ifdef E203_SUPPORT_AMO//{
            | ({{amo_1stuop        }} & agu_icb_rsp_err)// 1st error from the bus
            | ({{amo_2nduop        }} & (agu_icb_rsp_err | leftover_err_r))// second error merged
         `endif//E203_SUPPORT_AMO}
         ;
  //
  // The instantiation of leftover buffer is actually shared with the ALU SBF-0 Buffer
  assign agu_sbf_0_ena = leftover_ena;
  assign agu_sbf_0_nxt = leftover_nxt;
  assign leftover_r    = agu_sbf_0_r;

  // The error bit is implemented here
  sirv_gnrl_dfflr #(1) icb_leftover_err_dfflr (leftover_ena, leftover_err_nxt, leftover_err_r, clk, rst_n);
  
  assign leftover_1_ena = 1'b0 
         `ifdef E203_SUPPORT_AMO//{
           | icb_sta_is_amoalu 
         `endif//E203_SUPPORT_AMO}
         ;
  assign leftover_1_nxt = agu_req_alu_res;
  //
  // The instantiation of last_icb_addr buffer is actually shared with the ALU SBF-1 Buffer
  assign agu_sbf_1_ena   = leftover_1_ena;
  assign agu_sbf_1_nxt   = leftover_1_nxt;
  assign leftover_1_r = agu_sbf_1_r;


  assign agu_req_alu_add  = 1'b0
                     `ifdef E203_SUPPORT_AMO//{
                           | (icb_sta_is_amoalu & agu_i_amoadd)
                             // In order to let AMO 2nd uop have correct address
                           | (agu_i_amo & (icb_sta_is_wait2nd | icb_sta_is_2nd | icb_sta_is_wbck))
                     `endif//E203_SUPPORT_AMO}
                           // To cut down the timing loop from agu_i_valid // | (icb_sta_is_idle & agu_i_valid)
                           //   we dont need this signal at all
                           | icb_sta_is_idle
                           ;

  assign agu_req_alu_op1 =  icb_sta_is_idle   ? agu_i_rs1
                     `ifdef E203_SUPPORT_AMO//{
                          : icb_sta_is_amoalu ? leftover_r
                             // In order to let AMO 2nd uop have correct address
                          : (agu_i_amo & (icb_sta_is_wait2nd | icb_sta_is_2nd | icb_sta_is_wbck)) ? agu_i_rs1
                     `endif//E203_SUPPORT_AMO}
                     `ifndef E203_SUPPORT_UNALGNLDST//{
                          : `E203_XLEN'd0 
                     `endif//}
                     ;

  wire [`E203_XLEN-1:0] agu_addr_gen_op2 = agu_i_ofst0 ? `E203_XLEN'b0 : agu_i_imm;
  assign agu_req_alu_op2 =  icb_sta_is_idle   ? agu_addr_gen_op2 
                     `ifdef E203_SUPPORT_AMO//{
                          : icb_sta_is_amoalu ? agu_i_rs2
                             // In order to let AMO 2nd uop have correct address
                          : (agu_i_amo & (icb_sta_is_wait2nd | icb_sta_is_2nd | icb_sta_is_wbck)) ? agu_addr_gen_op2
                     `endif//E203_SUPPORT_AMO}
                     `ifndef E203_SUPPORT_UNALGNLDST//{
                          : `E203_XLEN'd0 
                     `endif//}
                     ;

  `ifdef E203_SUPPORT_AMO//{
  assign agu_req_alu_swap = (icb_sta_is_amoalu & agu_i_amoswap );
  assign agu_req_alu_and  = (icb_sta_is_amoalu & agu_i_amoand  );
  assign agu_req_alu_or   = (icb_sta_is_amoalu & agu_i_amoor   );
  assign agu_req_alu_xor  = (icb_sta_is_amoalu & agu_i_amoxor  );
  assign agu_req_alu_max  = (icb_sta_is_amoalu & agu_i_amomax  );
  assign agu_req_alu_min  = (icb_sta_is_amoalu & agu_i_amomin  );
  assign agu_req_alu_maxu = (icb_sta_is_amoalu & agu_i_amomaxu );
  assign agu_req_alu_minu = (icb_sta_is_amoalu & agu_i_amominu );
  `endif//E203_SUPPORT_AMO}
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
  `ifdef E203_SUPPORT_AMO//{
       | agu_i_algnamo 
  `endif//E203_SUPPORT_AMO}
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
        `ifdef E203_SUPPORT_AMO//{
      // For the unaligned load/store and aligned AMO, it will enter 
      //   into the state machine and let the last state to send back
      //   to the commit stage
      icb_sta_is_last 
        `endif//E203_SUPPORT_AMO}
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
        `ifdef E203_SUPPORT_AMO//{
           | agu_i_unalgnamo 
        `endif//E203_SUPPORT_AMO}
         )
          ////  // Since it is issuing to commit stage and 
          ////  // LSU at same cycle, so we must qualify the icb_cmd_ready signal from LSU
          ////  // to make sure it is out to commit/LSU at same cycle
               // To cut the critical timing  path from longpipe signal
               // we always assume the AGU will need icb_cmd_ready
          & agu_icb_cmd_ready
      );

  assign agu_o_wbck_wdat = {`E203_XLEN{1'b0 }}
       `ifdef E203_SUPPORT_AMO//{
                    | ({`E203_XLEN{agu_i_algnamo  }} & leftover_r) 
                    | ({`E203_XLEN{agu_i_unalgnamo}} & `E203_XLEN'b0) 
       `endif//E203_SUPPORT_AMO}
       ;

  assign agu_o_cmt_buserr = (1'b0 
                `ifdef E203_SUPPORT_AMO//{
                      | (agu_i_algnamo    & leftover_err_r) 
                      | (agu_i_unalgnamo  & 1'b0) 
                `endif//E203_SUPPORT_AMO}
                      )
                ;
  assign agu_o_cmt_badaddr = agu_icb_cmd_addr;


  assign agu_o_cmt_misalgn = (1'b0
                `ifdef E203_SUPPORT_AMO//{
                       | agu_i_unalgnamo 
                `endif//E203_SUPPORT_AMO}
                       | (agu_i_unalgnldst) //& agu_i_excl) We dont support unaligned load/store regardless it is AMO or not
                       )
                       ;
  assign agu_o_cmt_ld      = agu_i_load & (~agu_i_excl); 
  assign agu_o_cmt_stamo   = agu_i_store | agu_i_amo | agu_i_excl;

  
  // The exception or error result cannot write-back
  assign agu_o_wbck_err = agu_o_cmt_buserr | agu_o_cmt_misalgn
                          ;


  assign agu_icb_rsp_ready = 1'b1;


  

  assign agu_icb_cmd_valid = 
            ((agu_i_algnldst & agu_i_valid)
              // We must qualify the agu_o_ready signal from commit stage
              // to make sure it is out to commit/LSU at same cycle
              & (agu_o_ready)
            )
          `ifdef E203_SUPPORT_AMO//{
            | (agu_i_algnamo & (
                         (icb_sta_is_idle & agu_i_valid 
                             // We must qualify the agu_o_ready signal from commit stage
                             // to make sure it is out to commit/LSU at same cycle
                             & agu_o_ready)
                       | (icb_sta_is_wait2nd)))
            | (agu_i_unalgnamo & 1'b0) 
          `endif//E203_SUPPORT_AMO}
            ;
  assign agu_icb_cmd_addr = agu_req_alu_res[`E203_ADDR_SIZE-1:0];

  assign agu_icb_cmd_read = 
            (agu_i_algnldst & agu_i_load) 
          `ifdef E203_SUPPORT_AMO//{
          | (agu_i_algnamo & icb_sta_is_idle & 1'b1)
          | (agu_i_algnamo & icb_sta_is_wait2nd & 1'b0) 
          `endif//E203_SUPPORT_AMO}
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
  `ifdef E203_SUPPORT_AMO//{
      agu_i_amo ? leftover_1_r :
  `endif//E203_SUPPORT_AMO}
      algnst_wdata;

  assign agu_icb_cmd_wmask =
  `ifdef E203_SUPPORT_AMO//{
         // If the 1st uop have bus-error, then not write the data for 2nd uop
      agu_i_amo ? (leftover_err_r ? 4'h0 : 4'hF) :
  `endif//E203_SUPPORT_AMO}
      algnst_wmask; 

  assign agu_icb_cmd_back2agu = 1'b0 
             `ifdef E203_SUPPORT_AMO//{
                | agu_i_algnamo  
             `endif//E203_SUPPORT_AMO}
             ;
  //We dont support lock and exclusive in such 2 stage simple implementation
  assign agu_icb_cmd_lock     = 1'b0 
             `ifdef E203_SUPPORT_AMO//{
                 | (agu_i_algnamo & icb_sta_is_idle)
             `endif//E203_SUPPORT_AMO}
                 ;
  assign agu_icb_cmd_excl     = 1'b0
             `ifdef E203_SUPPORT_AMO//{
                 | agu_i_excl
             `endif//E203_SUPPORT_AMO}
                 ;

  assign agu_icb_cmd_itag     = agu_i_itag;
  assign agu_icb_cmd_usign    = agu_i_usign;
  assign agu_icb_cmd_size     = 
                agu_i_size;


endmodule                                      
                                               
                                               
                                               
