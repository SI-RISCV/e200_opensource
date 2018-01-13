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
//  The lsu_ctrl module control the LSU access requests 
//
// ====================================================================
`include "e203_defines.v"

module e203_lsu(
  input  commit_mret,
  input  commit_trap,
  input  excp_active,
  output  lsu_active,

  `ifdef E203_HAS_ITCM //{
  input [`E203_ADDR_SIZE-1:0] itcm_region_indic,
  `endif//}
  `ifdef E203_HAS_DTCM //{
  input [`E203_ADDR_SIZE-1:0] dtcm_region_indic,
  `endif//}
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The LSU Write-Back Interface
  output lsu_o_valid, // Handshake valid
  input  lsu_o_ready, // Handshake ready
  output [`E203_XLEN-1:0] lsu_o_wbck_wdat,
  output [`E203_ITAG_WIDTH -1:0] lsu_o_wbck_itag,
  output lsu_o_wbck_err , 
  output lsu_o_cmt_ld,
  output lsu_o_cmt_st,
  output [`E203_ADDR_SIZE -1:0] lsu_o_cmt_badaddr,
  output lsu_o_cmt_buserr , // The bus-error exception generated
  

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The AGU ICB Interface to LSU-ctrl
  //    * Bus cmd channel
  input                          agu_icb_cmd_valid, // Handshake valid
  output                         agu_icb_cmd_ready, // Handshake ready
  input  [`E203_ADDR_SIZE-1:0]   agu_icb_cmd_addr, // Bus transaction start addr 
  input                          agu_icb_cmd_read,   // Read or write
  input  [`E203_XLEN-1:0]        agu_icb_cmd_wdata, 
  input  [`E203_XLEN/8-1:0]      agu_icb_cmd_wmask, 
  input                          agu_icb_cmd_lock,
  input                          agu_icb_cmd_excl,
  input  [1:0]                   agu_icb_cmd_size,
           // Several additional side channel signals
           //   Indicate LSU-ctrl module to
           //     return the ICB response channel back to AGU
           //     this is only used by AMO or unaligned load/store 1st uop
           //     to return the response
  input                          agu_icb_cmd_back2agu, 
           //   Sign extension or not
  input                          agu_icb_cmd_usign,
  input  [`E203_ITAG_WIDTH -1:0] agu_icb_cmd_itag,

  //    * Bus RSP channel
  output                         agu_icb_rsp_valid, // Response valid 
  input                          agu_icb_rsp_ready, // Response ready
  output                         agu_icb_rsp_err  , // Response error
  output                         agu_icb_rsp_excl_ok, // Response error
  output [`E203_XLEN-1:0]        agu_icb_rsp_rdata,


  

  `ifdef E203_HAS_ITCM //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to ITCM
  //
  //    * Bus cmd channel
  output                         itcm_icb_cmd_valid,
  input                          itcm_icb_cmd_ready,
  output [`E203_ITCM_ADDR_WIDTH-1:0]   itcm_icb_cmd_addr, 
  output                         itcm_icb_cmd_read, 
  output [`E203_XLEN-1:0]        itcm_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      itcm_icb_cmd_wmask,
  output                         itcm_icb_cmd_lock,
  output                         itcm_icb_cmd_excl,
  output [1:0]                   itcm_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          itcm_icb_rsp_valid,
  output                         itcm_icb_rsp_ready,
  input                          itcm_icb_rsp_err  ,
  input                          itcm_icb_rsp_excl_ok  ,
  input  [`E203_XLEN-1:0]        itcm_icb_rsp_rdata,
  `endif//}

  
  `ifdef E203_HAS_DTCM //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to DTCM
  //
  //    * Bus cmd channel
  output                         dtcm_icb_cmd_valid,
  input                          dtcm_icb_cmd_ready,
  output [`E203_DTCM_ADDR_WIDTH-1:0]   dtcm_icb_cmd_addr, 
  output                         dtcm_icb_cmd_read, 
  output [`E203_XLEN-1:0]        dtcm_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      dtcm_icb_cmd_wmask,
  output                         dtcm_icb_cmd_lock,
  output                         dtcm_icb_cmd_excl,
  output [1:0]                   dtcm_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          dtcm_icb_rsp_valid,
  output                         dtcm_icb_rsp_ready,
  input                          dtcm_icb_rsp_err  ,
  input                          dtcm_icb_rsp_excl_ok  ,
  input  [`E203_XLEN-1:0]        dtcm_icb_rsp_rdata,
  `endif//}

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to BIU
  //
  //    * Bus cmd channel
  output                         biu_icb_cmd_valid,
  input                          biu_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   biu_icb_cmd_addr, 
  output                         biu_icb_cmd_read, 
  output [`E203_XLEN-1:0]        biu_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      biu_icb_cmd_wmask,
  output                         biu_icb_cmd_lock,
  output                         biu_icb_cmd_excl,
  output [1:0]                   biu_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          biu_icb_rsp_valid,
  output                         biu_icb_rsp_ready,
  input                          biu_icb_rsp_err  ,
  input                          biu_icb_rsp_excl_ok  ,
  input  [`E203_XLEN-1:0]        biu_icb_rsp_rdata,


  input  clk,
  input  rst_n
  );

    `ifdef E203_HAS_DCACHE //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to DCache
  //
  //    * Bus cmd channel
  wire                          dcache_icb_cmd_valid;
  wire                          dcache_icb_cmd_ready;
  wire  [`E203_ADDR_SIZE-1:0]   dcache_icb_cmd_addr; 
  wire                          dcache_icb_cmd_read; 
  wire  [`E203_XLEN-1:0]        dcache_icb_cmd_wdata;
  wire  [`E203_XLEN/8-1:0]      dcache_icb_cmd_wmask;
  wire                          dcache_icb_cmd_lock;
  wire                          dcache_icb_cmd_excl;
  wire  [1:0]                   dcache_icb_cmd_size;
  //
  //    * Bus RSP channel
  wire                          dcache_icb_rsp_valid;
  wire                          dcache_icb_rsp_ready;
  wire                          dcache_icb_rsp_err  ;
  wire                          dcache_icb_rsp_excl_ok  ;
  wire  [`E203_XLEN-1:0]        dcache_icb_rsp_rdata;
  `endif//}

  wire lsu_ctrl_active;


  e203_lsu_ctrl u_e203_lsu_ctrl(
    .commit_mret           (commit_mret),
    .commit_trap           (commit_trap),
    .lsu_ctrl_active       (lsu_ctrl_active),
  `ifdef E203_HAS_ITCM //{
    .itcm_region_indic     (itcm_region_indic),
  `endif//}
  `ifdef E203_HAS_DTCM //{
    .dtcm_region_indic     (dtcm_region_indic),
  `endif//}
    .lsu_o_valid           (lsu_o_valid ),
    .lsu_o_ready           (lsu_o_ready ),
    .lsu_o_wbck_wdat       (lsu_o_wbck_wdat),
    .lsu_o_wbck_itag       (lsu_o_wbck_itag),
    .lsu_o_wbck_err        (lsu_o_wbck_err  ),
    .lsu_o_cmt_buserr      (lsu_o_cmt_buserr  ),
    .lsu_o_cmt_badaddr     (lsu_o_cmt_badaddr ),
    .lsu_o_cmt_ld          (lsu_o_cmt_ld ),
    .lsu_o_cmt_st          (lsu_o_cmt_st ),
    
    .agu_icb_cmd_valid     (agu_icb_cmd_valid ),
    .agu_icb_cmd_ready     (agu_icb_cmd_ready ),
    .agu_icb_cmd_addr      (agu_icb_cmd_addr ),
    .agu_icb_cmd_read      (agu_icb_cmd_read   ),
    .agu_icb_cmd_wdata     (agu_icb_cmd_wdata ),
    .agu_icb_cmd_wmask     (agu_icb_cmd_wmask ),
    .agu_icb_cmd_lock      (agu_icb_cmd_lock),
    .agu_icb_cmd_excl      (agu_icb_cmd_excl),
    .agu_icb_cmd_size      (agu_icb_cmd_size),
   
    .agu_icb_cmd_back2agu  (agu_icb_cmd_back2agu ),
    .agu_icb_cmd_usign     (agu_icb_cmd_usign),
    .agu_icb_cmd_itag      (agu_icb_cmd_itag),
  
    .agu_icb_rsp_valid     (agu_icb_rsp_valid ),
    .agu_icb_rsp_ready     (agu_icb_rsp_ready ),
    .agu_icb_rsp_err       (agu_icb_rsp_err   ),
    .agu_icb_rsp_excl_ok   (agu_icb_rsp_excl_ok),
    .agu_icb_rsp_rdata     (agu_icb_rsp_rdata),
 
      `ifndef E203_HAS_EAI 
    .eai_mem_holdup        (1'b0),
    .eai_icb_cmd_valid     (1'b0),
    .eai_icb_cmd_ready     (),
    .eai_icb_cmd_addr      (`E203_ADDR_SIZE'b0 ),
    .eai_icb_cmd_read      (1'b0 ),
    .eai_icb_cmd_wdata     (`E203_XLEN'b0),
    .eai_icb_cmd_wmask     ({`E203_XLEN/8{1'b0}}),
    .eai_icb_cmd_lock      (1'b0),
    .eai_icb_cmd_excl      (1'b0),
    .eai_icb_cmd_size      (2'b0),
    
    .eai_icb_rsp_valid     (),
    .eai_icb_rsp_ready     (1'b0),
    .eai_icb_rsp_err       (),
    .eai_icb_rsp_excl_ok   (),
    .eai_icb_rsp_rdata     (),
      `endif           


      `ifdef E203_HAS_DCACHE
    .dcache_icb_cmd_valid  (dcache_icb_cmd_valid),
    .dcache_icb_cmd_ready  (dcache_icb_cmd_ready),
    .dcache_icb_cmd_addr   (dcache_icb_cmd_addr ),
    .dcache_icb_cmd_read   (dcache_icb_cmd_read ),
    .dcache_icb_cmd_wdata  (dcache_icb_cmd_wdata),
    .dcache_icb_cmd_wmask  (dcache_icb_cmd_wmask),
    .dcache_icb_cmd_lock   (dcache_icb_cmd_lock),
    .dcache_icb_cmd_excl   (dcache_icb_cmd_excl),
    .dcache_icb_cmd_size   (dcache_icb_cmd_size),
    
    .dcache_icb_rsp_valid  (dcache_icb_rsp_valid),
    .dcache_icb_rsp_ready  (dcache_icb_rsp_ready),
    .dcache_icb_rsp_err    (dcache_icb_rsp_err  ),
    .dcache_icb_rsp_excl_ok(dcache_icb_rsp_excl_ok  ),
    .dcache_icb_rsp_rdata  (dcache_icb_rsp_rdata),
      `endif 

      `ifdef E203_HAS_DTCM
    .dtcm_icb_cmd_valid    (dtcm_icb_cmd_valid),
    .dtcm_icb_cmd_ready    (dtcm_icb_cmd_ready),
    .dtcm_icb_cmd_addr     (dtcm_icb_cmd_addr ),
    .dtcm_icb_cmd_read     (dtcm_icb_cmd_read ),
    .dtcm_icb_cmd_wdata    (dtcm_icb_cmd_wdata),
    .dtcm_icb_cmd_wmask    (dtcm_icb_cmd_wmask),
    .dtcm_icb_cmd_lock     (dtcm_icb_cmd_lock),
    .dtcm_icb_cmd_excl     (dtcm_icb_cmd_excl),
    .dtcm_icb_cmd_size     (dtcm_icb_cmd_size),
    
    .dtcm_icb_rsp_valid    (dtcm_icb_rsp_valid),
    .dtcm_icb_rsp_ready    (dtcm_icb_rsp_ready),
    .dtcm_icb_rsp_err      (dtcm_icb_rsp_err  ),
    .dtcm_icb_rsp_excl_ok  (dtcm_icb_rsp_excl_ok  ),
    .dtcm_icb_rsp_rdata    (dtcm_icb_rsp_rdata),
     `endif            
    
      `ifdef E203_HAS_ITCM
    .itcm_icb_cmd_valid    (itcm_icb_cmd_valid),
    .itcm_icb_cmd_ready    (itcm_icb_cmd_ready),
    .itcm_icb_cmd_addr     (itcm_icb_cmd_addr ),
    .itcm_icb_cmd_read     (itcm_icb_cmd_read ),
    .itcm_icb_cmd_wdata    (itcm_icb_cmd_wdata),
    .itcm_icb_cmd_wmask    (itcm_icb_cmd_wmask),
    .itcm_icb_cmd_lock     (itcm_icb_cmd_lock),
    .itcm_icb_cmd_excl     (itcm_icb_cmd_excl),
    .itcm_icb_cmd_size     (itcm_icb_cmd_size),
    
    .itcm_icb_rsp_valid    (itcm_icb_rsp_valid),
    .itcm_icb_rsp_ready    (itcm_icb_rsp_ready),
    .itcm_icb_rsp_err      (itcm_icb_rsp_err  ),
    .itcm_icb_rsp_excl_ok  (itcm_icb_rsp_excl_ok  ),
    .itcm_icb_rsp_rdata    (itcm_icb_rsp_rdata),
      `endif 
    
    .biu_icb_cmd_valid     (biu_icb_cmd_valid),
    .biu_icb_cmd_ready     (biu_icb_cmd_ready),
    .biu_icb_cmd_addr      (biu_icb_cmd_addr ),
    .biu_icb_cmd_read      (biu_icb_cmd_read ),
    .biu_icb_cmd_wdata     (biu_icb_cmd_wdata),
    .biu_icb_cmd_wmask     (biu_icb_cmd_wmask),
    .biu_icb_cmd_lock      (biu_icb_cmd_lock),
    .biu_icb_cmd_excl      (biu_icb_cmd_excl),
    .biu_icb_cmd_size      (biu_icb_cmd_size),
   
    .biu_icb_rsp_valid     (biu_icb_rsp_valid),
    .biu_icb_rsp_ready     (biu_icb_rsp_ready),
    .biu_icb_rsp_err       (biu_icb_rsp_err  ),
    .biu_icb_rsp_excl_ok   (biu_icb_rsp_excl_ok  ),
    .biu_icb_rsp_rdata     (biu_icb_rsp_rdata),
  
    .clk                   (clk),
    .rst_n                 (rst_n)
  );

  assign lsu_active = lsu_ctrl_active 
                    // When interrupts comes, need to update the exclusive monitor
                    // so also need to turn on the clock
                    | excp_active;
endmodule

