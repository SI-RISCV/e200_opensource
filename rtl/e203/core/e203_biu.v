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
//  The BIU module control the ICB request to external memory system
//
// ====================================================================
`include "e203_defines.v"

module e203_biu(

  output                         biu_active,
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface from LSU 
  input                          lsu2biu_icb_cmd_valid,
  output                         lsu2biu_icb_cmd_ready,
  input  [`E203_ADDR_SIZE-1:0]   lsu2biu_icb_cmd_addr, 
  input                          lsu2biu_icb_cmd_read, 
  input  [`E203_XLEN-1:0]        lsu2biu_icb_cmd_wdata,
  input  [`E203_XLEN/8-1:0]      lsu2biu_icb_cmd_wmask,
  input  [1:0]                   lsu2biu_icb_cmd_burst,
  input  [1:0]                   lsu2biu_icb_cmd_beat,
  input                          lsu2biu_icb_cmd_lock,
  input                          lsu2biu_icb_cmd_excl,
  input  [1:0]                   lsu2biu_icb_cmd_size,
  
  output                         lsu2biu_icb_rsp_valid,
  input                          lsu2biu_icb_rsp_ready,
  output                         lsu2biu_icb_rsp_err  ,
  output                         lsu2biu_icb_rsp_excl_ok,
  output [`E203_XLEN-1:0]        lsu2biu_icb_rsp_rdata,

  `ifdef E203_HAS_MEM_ITF //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // the icb interface from ifetch 
  //
  //    * bus cmd channel
  input                          ifu2biu_icb_cmd_valid,
  output                         ifu2biu_icb_cmd_ready,
  input  [`E203_ADDR_SIZE-1:0]   ifu2biu_icb_cmd_addr, 
  input                          ifu2biu_icb_cmd_read, 
  input  [`E203_XLEN-1:0]        ifu2biu_icb_cmd_wdata,
  input  [`E203_XLEN/8-1:0]      ifu2biu_icb_cmd_wmask,
  input  [1:0]                   ifu2biu_icb_cmd_burst,
  input  [1:0]                   ifu2biu_icb_cmd_beat,
  input                          ifu2biu_icb_cmd_lock,
  input                          ifu2biu_icb_cmd_excl,
  input  [1:0]                   ifu2biu_icb_cmd_size,
  //
  //    * bus rsp channel
  output                         ifu2biu_icb_rsp_valid,
  input                          ifu2biu_icb_rsp_ready,
  output                         ifu2biu_icb_rsp_err  ,
  output                         ifu2biu_icb_rsp_excl_ok,
  output [`E203_XLEN-1:0]        ifu2biu_icb_rsp_rdata,

  //output                         ifu2biu_replay,
  `endif//}



  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to Private Peripheral Interface
  //
  input [`E203_ADDR_SIZE-1:0]    ppi_region_indic,
  input                          ppi_icb_enable,
  //    * Bus cmd channel
  output                         ppi_icb_cmd_valid,
  input                          ppi_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   ppi_icb_cmd_addr, 
  output                         ppi_icb_cmd_read, 
  output [`E203_XLEN-1:0]        ppi_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      ppi_icb_cmd_wmask,
  output [1:0]                   ppi_icb_cmd_burst,
  output [1:0]                   ppi_icb_cmd_beat,
  output                         ppi_icb_cmd_lock,
  output                         ppi_icb_cmd_excl,
  output [1:0]                   ppi_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          ppi_icb_rsp_valid,
  output                         ppi_icb_rsp_ready,
  input                          ppi_icb_rsp_err  ,
  input                          ppi_icb_rsp_excl_ok,
  input  [`E203_XLEN-1:0]        ppi_icb_rsp_rdata,

    //
  input [`E203_ADDR_SIZE-1:0]    clint_region_indic,
  input                          clint_icb_enable,
  //    * Bus cmd channel
  output                         clint_icb_cmd_valid,
  input                          clint_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   clint_icb_cmd_addr, 
  output                         clint_icb_cmd_read, 
  output [`E203_XLEN-1:0]        clint_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      clint_icb_cmd_wmask,
  output [1:0]                   clint_icb_cmd_burst,
  output [1:0]                   clint_icb_cmd_beat,
  output                         clint_icb_cmd_lock,
  output                         clint_icb_cmd_excl,
  output [1:0]                   clint_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          clint_icb_rsp_valid,
  output                         clint_icb_rsp_ready,
  input                          clint_icb_rsp_err  ,
  input                          clint_icb_rsp_excl_ok,
  input  [`E203_XLEN-1:0]        clint_icb_rsp_rdata,

      //
  input [`E203_ADDR_SIZE-1:0]    plic_region_indic,
  input                          plic_icb_enable,
  //    * Bus cmd channel
  output                         plic_icb_cmd_valid,
  input                          plic_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   plic_icb_cmd_addr, 
  output                         plic_icb_cmd_read, 
  output [`E203_XLEN-1:0]        plic_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      plic_icb_cmd_wmask,
  output [1:0]                   plic_icb_cmd_burst,
  output [1:0]                   plic_icb_cmd_beat,
  output                         plic_icb_cmd_lock,
  output                         plic_icb_cmd_excl,
  output [1:0]                   plic_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          plic_icb_rsp_valid,
  output                         plic_icb_rsp_ready,
  input                          plic_icb_rsp_err  ,
  input                          plic_icb_rsp_excl_ok,
  input  [`E203_XLEN-1:0]        plic_icb_rsp_rdata,


  `ifdef E203_HAS_FIO //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to Fast I/O
  input [`E203_ADDR_SIZE-1:0]    fio_region_indic,
  input                          fio_icb_enable,
  //
  //    * Bus cmd channel
  output                         fio_icb_cmd_valid,
  input                          fio_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   fio_icb_cmd_addr, 
  output                         fio_icb_cmd_read, 
  output [`E203_XLEN-1:0]        fio_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      fio_icb_cmd_wmask,
  output [1:0]                   fio_icb_cmd_burst,
  output [1:0]                   fio_icb_cmd_beat,
  output                         fio_icb_cmd_lock,
  output                         fio_icb_cmd_excl,
  output [1:0]                   fio_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          fio_icb_rsp_valid,
  output                         fio_icb_rsp_ready,
  input                          fio_icb_rsp_err  ,
  input                          fio_icb_rsp_excl_ok,
  input  [`E203_XLEN-1:0]        fio_icb_rsp_rdata,
  `endif//}

  `ifdef E203_HAS_MEM_ITF //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface from Ifetch 
  //
  input                          mem_icb_enable,
  //    * Bus cmd channel
  output                         mem_icb_cmd_valid,
  input                          mem_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   mem_icb_cmd_addr, 
  output                         mem_icb_cmd_read, 
  output [`E203_XLEN-1:0]        mem_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      mem_icb_cmd_wmask,
  output [1:0]                   mem_icb_cmd_burst,
  output [1:0]                   mem_icb_cmd_beat,
  output                         mem_icb_cmd_lock,
  output                         mem_icb_cmd_excl,
  output [1:0]                   mem_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          mem_icb_rsp_valid,
  output                         mem_icb_rsp_ready,
  input                          mem_icb_rsp_err  ,
  input                          mem_icb_rsp_excl_ok,
  input  [`E203_XLEN-1:0]        mem_icb_rsp_rdata,
  `endif//}

  input  clk,
  input  rst_n
  );


  `ifdef E203_HAS_MEM_ITF //{
      localparam BIU_ARBT_I_NUM = 2;
      localparam BIU_ARBT_I_PTR_W = 1;
  `else//}{
      localparam BIU_ARBT_I_NUM = 1;
      localparam BIU_ARBT_I_PTR_W = 1;
  `endif//}

  
  // The SPLT_NUM is the sum of following components
  //   * ppi, clint, plic, SystemITF, Fast-IO, IFU-err 
      localparam BIU_SPLT_I_NUM_0 = 4;

  `ifdef E203_HAS_MEM_ITF //{
      localparam BIU_SPLT_I_NUM_1 = (BIU_SPLT_I_NUM_0 + 1);
  `else//}{
      localparam BIU_SPLT_I_NUM_1 = BIU_SPLT_I_NUM_0;
  `endif//}

  `ifdef E203_HAS_FIO //{
      localparam BIU_SPLT_I_NUM_2 = (BIU_SPLT_I_NUM_1 + 1);
  `else//}{
      localparam BIU_SPLT_I_NUM_2 = BIU_SPLT_I_NUM_1;
  `endif//}

      localparam BIU_SPLT_I_NUM   = BIU_SPLT_I_NUM_2;

  wire                         ifuerr_icb_cmd_valid;
  wire                         ifuerr_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   ifuerr_icb_cmd_addr; 
  wire                         ifuerr_icb_cmd_read; 
  wire [2-1:0]                 ifuerr_icb_cmd_burst;
  wire [2-1:0]                 ifuerr_icb_cmd_beat;
  wire [`E203_XLEN-1:0]        ifuerr_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0]      ifuerr_icb_cmd_wmask;
  wire                         ifuerr_icb_cmd_lock;
  wire                         ifuerr_icb_cmd_excl;
  wire [1:0]                   ifuerr_icb_cmd_size;
  
  wire                         ifuerr_icb_rsp_valid;
  wire                         ifuerr_icb_rsp_ready;
  wire                         ifuerr_icb_rsp_err  ;
  wire                         ifuerr_icb_rsp_excl_ok;
  wire [`E203_XLEN-1:0]        ifuerr_icb_rsp_rdata;

  wire arbt_icb_cmd_valid;
  wire arbt_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0] arbt_icb_cmd_addr;
  wire arbt_icb_cmd_read;
  wire [`E203_XLEN-1:0] arbt_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0] arbt_icb_cmd_wmask;
  wire [1:0] arbt_icb_cmd_burst;
  wire [1:0] arbt_icb_cmd_beat;
  wire arbt_icb_cmd_lock;
  wire arbt_icb_cmd_excl;
  wire [1:0] arbt_icb_cmd_size;
  wire arbt_icb_cmd_usr;


  wire arbt_icb_rsp_valid;
  wire arbt_icb_rsp_ready;
  wire arbt_icb_rsp_err;
  wire arbt_icb_rsp_excl_ok;
  wire [`E203_XLEN-1:0] arbt_icb_rsp_rdata;

  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_valid;
  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_ready;
  wire [BIU_ARBT_I_NUM*`E203_ADDR_SIZE-1:0] arbt_bus_icb_cmd_addr;
  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_read;
  wire [BIU_ARBT_I_NUM*`E203_XLEN-1:0] arbt_bus_icb_cmd_wdata;
  wire [BIU_ARBT_I_NUM*`E203_XLEN/8-1:0] arbt_bus_icb_cmd_wmask;
  wire [BIU_ARBT_I_NUM*2-1:0] arbt_bus_icb_cmd_burst;
  wire [BIU_ARBT_I_NUM*2-1:0] arbt_bus_icb_cmd_beat;
  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_lock;
  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_excl;
  wire [BIU_ARBT_I_NUM*2-1:0] arbt_bus_icb_cmd_size;
  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_usr;

  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_valid;
  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_ready;
  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_err;
  wire [BIU_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_excl_ok;
  wire [BIU_ARBT_I_NUM*`E203_XLEN-1:0] arbt_bus_icb_rsp_rdata;

  //CMD Channel
  assign arbt_bus_icb_cmd_valid =
      // The  LSU take higher priority
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_valid,
                           `endif//}
                             lsu2biu_icb_cmd_valid
                           } ;

  assign arbt_bus_icb_cmd_addr =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_addr,
                           `endif//}
                             lsu2biu_icb_cmd_addr
                           } ;

  assign arbt_bus_icb_cmd_read =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_read,
                           `endif//}
                             lsu2biu_icb_cmd_read
                           } ;

  assign arbt_bus_icb_cmd_wdata =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_wdata,
                           `endif//}
                             lsu2biu_icb_cmd_wdata
                           } ;

  assign arbt_bus_icb_cmd_wmask =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_wmask,
                           `endif//}
                             lsu2biu_icb_cmd_wmask
                           } ;
                         
  assign arbt_bus_icb_cmd_burst =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_burst,
                           `endif//}
                             lsu2biu_icb_cmd_burst
                           } ;
                         
  assign arbt_bus_icb_cmd_beat =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_beat,
                           `endif//}
                             lsu2biu_icb_cmd_beat
                           } ;
                         
  assign arbt_bus_icb_cmd_lock =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_lock,
                           `endif//}
                             lsu2biu_icb_cmd_lock
                           } ;

  assign arbt_bus_icb_cmd_excl =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_excl,
                           `endif//}
                             lsu2biu_icb_cmd_excl
                           } ;
                           
  assign arbt_bus_icb_cmd_size =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_size,
                           `endif//}
                             lsu2biu_icb_cmd_size
                           } ;

 wire ifu2biu_icb_cmd_ifu = 1'b1;
 wire lsu2biu_icb_cmd_ifu = 1'b0;
 assign arbt_bus_icb_cmd_usr =
                           {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_ifu,
                           `endif//}
                             lsu2biu_icb_cmd_ifu
                           } ;

  assign                   {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_cmd_ready,
                           `endif//}
                             lsu2biu_icb_cmd_ready
                           } = arbt_bus_icb_cmd_ready;

  //RSP Channel
  assign                   {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_rsp_valid,
                           `endif//}
                             lsu2biu_icb_rsp_valid
                           } = arbt_bus_icb_rsp_valid;

  assign                   {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_rsp_err,
                           `endif//}
                             lsu2biu_icb_rsp_err
                           } = arbt_bus_icb_rsp_err;

  assign                   {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_rsp_excl_ok,
                           `endif//}
                             lsu2biu_icb_rsp_excl_ok
                           } = arbt_bus_icb_rsp_excl_ok;
                           
  assign                   {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_rsp_rdata,
                           `endif//}
                             lsu2biu_icb_rsp_rdata
                           } = arbt_bus_icb_rsp_rdata;

  assign arbt_bus_icb_rsp_ready = {
                           `ifdef E203_HAS_MEM_ITF //{
                             ifu2biu_icb_rsp_ready,
                           `endif//}
                             lsu2biu_icb_rsp_ready
                           };

  sirv_gnrl_icb_arbt # (
  .ARBT_SCHEME (0),// Priority based
  .ALLOW_0CYCL_RSP (0),// Dont allow the 0 cycle response because in BIU we always have CMD_DP larger than 0
                       //   when the response come back from the external bus, it is at least 1 cycle later
  .FIFO_OUTS_NUM   (`E203_BIU_OUTS_NUM),
  .FIFO_CUT_READY  (`E203_BIU_CMD_CUT_READY),
  .ARBT_NUM   (BIU_ARBT_I_NUM),
  .ARBT_PTR_W (BIU_ARBT_I_PTR_W),
  .USR_W      (1),
  .AW         (`E203_ADDR_SIZE),
  .DW         (`E203_XLEN) 
  ) u_biu_icb_arbt(
  .o_icb_cmd_valid        (arbt_icb_cmd_valid )     ,
  .o_icb_cmd_ready        (arbt_icb_cmd_ready )     ,
  .o_icb_cmd_read         (arbt_icb_cmd_read )      ,
  .o_icb_cmd_addr         (arbt_icb_cmd_addr )      ,
  .o_icb_cmd_wdata        (arbt_icb_cmd_wdata )     ,
  .o_icb_cmd_wmask        (arbt_icb_cmd_wmask)      ,
  .o_icb_cmd_burst        (arbt_icb_cmd_burst)     ,
  .o_icb_cmd_beat         (arbt_icb_cmd_beat )     ,
  .o_icb_cmd_excl         (arbt_icb_cmd_excl )     ,
  .o_icb_cmd_lock         (arbt_icb_cmd_lock )     ,
  .o_icb_cmd_size         (arbt_icb_cmd_size )     ,
  .o_icb_cmd_usr          (arbt_icb_cmd_usr  )     ,
                                
  .o_icb_rsp_valid        (arbt_icb_rsp_valid )     ,
  .o_icb_rsp_ready        (arbt_icb_rsp_ready )     ,
  .o_icb_rsp_err          (arbt_icb_rsp_err)        ,
  .o_icb_rsp_excl_ok      (arbt_icb_rsp_excl_ok)    ,
  .o_icb_rsp_rdata        (arbt_icb_rsp_rdata )     ,
  .o_icb_rsp_usr          (1'b0   )     ,
                               
  .i_bus_icb_cmd_ready    (arbt_bus_icb_cmd_ready ) ,
  .i_bus_icb_cmd_valid    (arbt_bus_icb_cmd_valid ) ,
  .i_bus_icb_cmd_read     (arbt_bus_icb_cmd_read )  ,
  .i_bus_icb_cmd_addr     (arbt_bus_icb_cmd_addr )  ,
  .i_bus_icb_cmd_wdata    (arbt_bus_icb_cmd_wdata ) ,
  .i_bus_icb_cmd_wmask    (arbt_bus_icb_cmd_wmask)  ,
  .i_bus_icb_cmd_burst    (arbt_bus_icb_cmd_burst),
  .i_bus_icb_cmd_beat     (arbt_bus_icb_cmd_beat ),
  .i_bus_icb_cmd_excl     (arbt_bus_icb_cmd_excl ),
  .i_bus_icb_cmd_lock     (arbt_bus_icb_cmd_lock ),
  .i_bus_icb_cmd_size     (arbt_bus_icb_cmd_size ),
  .i_bus_icb_cmd_usr      (arbt_bus_icb_cmd_usr ),
                                
  .i_bus_icb_rsp_valid    (arbt_bus_icb_rsp_valid ) ,
  .i_bus_icb_rsp_ready    (arbt_bus_icb_rsp_ready ) ,
  .i_bus_icb_rsp_err      (arbt_bus_icb_rsp_err)    ,
  .i_bus_icb_rsp_excl_ok  (arbt_bus_icb_rsp_excl_ok),
  .i_bus_icb_rsp_rdata    (arbt_bus_icb_rsp_rdata ) ,
  .i_bus_icb_rsp_usr      () ,
                             
  .clk                    (clk  )                     ,
  .rst_n                  (rst_n)
  );

  //// To breakup the dead-lock cases, when incoming load/store request to the BIU but not granted 
  ////  This kind of potential deadlock case only happened at the low end core, where the ifetch response
  ////  provided to IFU, but IFU cannot accept it because it is waiting the IR stage to be cleared, and IR
  ////  stage is waiting the LSU to be cleared, and LSU is waiting this BIU to be cleared.
  //// At any mid of high end core (or with multiple oustandings), we definitely will update IFU
  ////  to make sure it always can accept any oustanding transactions traded with area cost.
  //// So back to this very low end core, to save areas, we prefetch without knowing if IR can accept
  ////  the response or not, and also in very low end core it is just 1 oustanding (multiple oustanding 
  ////  belong to mid or high end core), so to cut off this deadlocks, we just let the BIU to trigger
  ////  and replay indication if LSU cannot get granted, if IFU just overkilly forced to be replayed, it
  ////  just lost performance, but we dont care, because in low end core, ifetch to system mem is not
  ////  guranteed by performance. If IFU really suppose to be replayed, then good luck to break this deadlock.
  //wire ifu_replay_r;
  //// The IFU replay will be set when:
  ////    * Accessed by non-IFU access
  ////    * Or non-IFU access is to access ITCM, but not granted
  //wire ifu_replay_set = (arbt_icb_cmd_valid & arbt_icb_cmd_ready & lsu2biu_icb_cmd_valid)
  //               | (lsu2biu_icb_cmd_valid & (~lsu2biu_icb_cmd_ready));
  //// The IFU replay will be cleared after accessed by a IFU access
  //wire ifu_replay_clr = (arbt_icb_cmd_valid & arbt_icb_cmd_ready & ifu2biu_icb_cmd_valid);
  //wire ifu_replay_ena = ifu_replay_set | ifu_replay_clr;
  //wire ifu_replay_nxt = ifu_replay_set | (~ifu_replay_clr);
  //sirv_gnrl_dfflr #(1)ifu_replay_dffl(ifu_replay_ena, ifu_replay_nxt, ifu_replay_r, clk, rst_n);
  //assign ifu2biu_replay = ifu_replay_r;

  wire buf_icb_cmd_valid;
  wire buf_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0] buf_icb_cmd_addr;
  wire buf_icb_cmd_read;
  wire [`E203_XLEN-1:0] buf_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0] buf_icb_cmd_wmask;
  wire [1:0] buf_icb_cmd_burst;
  wire [1:0] buf_icb_cmd_beat;
  wire buf_icb_cmd_lock;
  wire buf_icb_cmd_excl;
  wire [1:0] buf_icb_cmd_size;
  wire buf_icb_cmd_usr;

  wire buf_icb_cmd_ifu = buf_icb_cmd_usr;

  wire buf_icb_rsp_valid;
  wire buf_icb_rsp_ready;
  wire buf_icb_rsp_err;
  wire buf_icb_rsp_excl_ok;
  wire [`E203_XLEN-1:0] buf_icb_rsp_rdata;

  wire icb_buffer_active;

  sirv_gnrl_icb_buffer # (
    .OUTS_CNT_W   (`E203_BIU_OUTS_CNT_W),
    .AW    (`E203_ADDR_SIZE),
    .DW    (`E203_XLEN), 
    .CMD_DP(`E203_BIU_CMD_DP),
    .RSP_DP(`E203_BIU_RSP_DP),
    .CMD_CUT_READY (`E203_BIU_CMD_CUT_READY),
    .RSP_CUT_READY (`E203_BIU_RSP_CUT_READY),
    .USR_W (1)
  )u_sirv_gnrl_icb_buffer(
    .icb_buffer_active      (icb_buffer_active),
    .i_icb_cmd_valid        (arbt_icb_cmd_valid),
    .i_icb_cmd_ready        (arbt_icb_cmd_ready),
    .i_icb_cmd_read         (arbt_icb_cmd_read ),
    .i_icb_cmd_addr         (arbt_icb_cmd_addr ),
    .i_icb_cmd_wdata        (arbt_icb_cmd_wdata),
    .i_icb_cmd_wmask        (arbt_icb_cmd_wmask),
    .i_icb_cmd_lock         (arbt_icb_cmd_lock ),
    .i_icb_cmd_excl         (arbt_icb_cmd_excl ),
    .i_icb_cmd_size         (arbt_icb_cmd_size ),
    .i_icb_cmd_burst        (arbt_icb_cmd_burst),
    .i_icb_cmd_beat         (arbt_icb_cmd_beat ),
    .i_icb_cmd_usr          (arbt_icb_cmd_usr  ),
                     
    .i_icb_rsp_valid        (arbt_icb_rsp_valid),
    .i_icb_rsp_ready        (arbt_icb_rsp_ready),
    .i_icb_rsp_err          (arbt_icb_rsp_err  ),
    .i_icb_rsp_excl_ok      (arbt_icb_rsp_excl_ok),
    .i_icb_rsp_rdata        (arbt_icb_rsp_rdata),
    .i_icb_rsp_usr          (),
    
    .o_icb_cmd_valid        (buf_icb_cmd_valid),
    .o_icb_cmd_ready        (buf_icb_cmd_ready),
    .o_icb_cmd_read         (buf_icb_cmd_read ),
    .o_icb_cmd_addr         (buf_icb_cmd_addr ),
    .o_icb_cmd_wdata        (buf_icb_cmd_wdata),
    .o_icb_cmd_wmask        (buf_icb_cmd_wmask),
    .o_icb_cmd_lock         (buf_icb_cmd_lock ),
    .o_icb_cmd_excl         (buf_icb_cmd_excl ),
    .o_icb_cmd_size         (buf_icb_cmd_size ),
    .o_icb_cmd_burst        (buf_icb_cmd_burst),
    .o_icb_cmd_beat         (buf_icb_cmd_beat ),
    .o_icb_cmd_usr          (buf_icb_cmd_usr),
                         
    .o_icb_rsp_valid        (buf_icb_rsp_valid),
    .o_icb_rsp_ready        (buf_icb_rsp_ready),
    .o_icb_rsp_err          (buf_icb_rsp_err  ),
    .o_icb_rsp_excl_ok      (buf_icb_rsp_excl_ok),
    .o_icb_rsp_rdata        (buf_icb_rsp_rdata),
    .o_icb_rsp_usr          (1'b0  ),

    .clk                    (clk  ),
    .rst_n                  (rst_n)
  );

  wire [BIU_SPLT_I_NUM*1-1:0] splt_bus_icb_cmd_valid;
  wire [BIU_SPLT_I_NUM*1-1:0] splt_bus_icb_cmd_ready;
  wire [BIU_SPLT_I_NUM*`E203_ADDR_SIZE-1:0] splt_bus_icb_cmd_addr;
  wire [BIU_SPLT_I_NUM*1-1:0] splt_bus_icb_cmd_read;
  wire [BIU_SPLT_I_NUM*`E203_XLEN-1:0] splt_bus_icb_cmd_wdata;
  wire [BIU_SPLT_I_NUM*`E203_XLEN/8-1:0] splt_bus_icb_cmd_wmask;
  wire [BIU_SPLT_I_NUM*2-1:0] splt_bus_icb_cmd_burst;
  wire [BIU_SPLT_I_NUM*2-1:0] splt_bus_icb_cmd_beat;
  wire [BIU_SPLT_I_NUM*1-1:0] splt_bus_icb_cmd_lock;
  wire [BIU_SPLT_I_NUM*1-1:0] splt_bus_icb_cmd_excl;
  wire [BIU_SPLT_I_NUM*2-1:0] splt_bus_icb_cmd_size;

  wire [BIU_SPLT_I_NUM*1-1:0] splt_bus_icb_rsp_valid;
  wire [BIU_SPLT_I_NUM*1-1:0] splt_bus_icb_rsp_ready;
  wire [BIU_SPLT_I_NUM*1-1:0] splt_bus_icb_rsp_err;
  wire [BIU_SPLT_I_NUM*1-1:0] splt_bus_icb_rsp_excl_ok;
  wire [BIU_SPLT_I_NUM*`E203_XLEN-1:0] splt_bus_icb_rsp_rdata;

  //CMD Channel
  assign {
                             ifuerr_icb_cmd_valid
                           , ppi_icb_cmd_valid
                           , clint_icb_cmd_valid
                           , plic_icb_cmd_valid
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_valid
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_valid
                           `endif//}
                           } = splt_bus_icb_cmd_valid;

  assign {
                             ifuerr_icb_cmd_addr
                           , ppi_icb_cmd_addr
                           , clint_icb_cmd_addr
                           , plic_icb_cmd_addr
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_addr
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_addr
                           `endif//}
                           } = splt_bus_icb_cmd_addr;

  assign {
                             ifuerr_icb_cmd_read
                           , ppi_icb_cmd_read
                           , clint_icb_cmd_read
                           , plic_icb_cmd_read
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_read
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_read
                           `endif//}
                           } = splt_bus_icb_cmd_read;

  assign {
                             ifuerr_icb_cmd_wdata
                           , ppi_icb_cmd_wdata
                           , clint_icb_cmd_wdata
                           , plic_icb_cmd_wdata
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_wdata
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_wdata
                           `endif//}
                           } = splt_bus_icb_cmd_wdata;

  assign {
                             ifuerr_icb_cmd_wmask
                           , ppi_icb_cmd_wmask
                           , clint_icb_cmd_wmask
                           , plic_icb_cmd_wmask
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_wmask
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_wmask
                           `endif//}
                           } = splt_bus_icb_cmd_wmask;
                         
  assign {
                             ifuerr_icb_cmd_burst
                           , ppi_icb_cmd_burst
                           , clint_icb_cmd_burst
                           , plic_icb_cmd_burst
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_burst
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_burst
                           `endif//}
                           } = splt_bus_icb_cmd_burst;
                         
  assign {
                             ifuerr_icb_cmd_beat
                           , ppi_icb_cmd_beat
                           , clint_icb_cmd_beat
                           , plic_icb_cmd_beat
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_beat
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_beat
                           `endif//}
                           } = splt_bus_icb_cmd_beat;
                         
  assign {
                             ifuerr_icb_cmd_lock
                           , ppi_icb_cmd_lock
                           , clint_icb_cmd_lock
                           , plic_icb_cmd_lock
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_lock
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_lock
                           `endif//}
                           } = splt_bus_icb_cmd_lock;

  assign {
                             ifuerr_icb_cmd_excl
                           , ppi_icb_cmd_excl
                           , clint_icb_cmd_excl
                           , plic_icb_cmd_excl
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_excl
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_excl
                           `endif//}
                           } = splt_bus_icb_cmd_excl;
                           
  assign {
                             ifuerr_icb_cmd_size
                           , ppi_icb_cmd_size
                           , clint_icb_cmd_size
                           , plic_icb_cmd_size
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_size
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_size
                           `endif//}
                           } = splt_bus_icb_cmd_size;

  assign splt_bus_icb_cmd_ready = {
                             ifuerr_icb_cmd_ready
                           , ppi_icb_cmd_ready
                           , clint_icb_cmd_ready
                           , plic_icb_cmd_ready
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_cmd_ready
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_cmd_ready
                           `endif//}
                           };

  //RSP Channel
  assign splt_bus_icb_rsp_valid = {
                             ifuerr_icb_rsp_valid
                           , ppi_icb_rsp_valid
                           , clint_icb_rsp_valid
                           , plic_icb_rsp_valid
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_rsp_valid
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_rsp_valid
                           `endif//}
                           };

  assign splt_bus_icb_rsp_err = {
                             ifuerr_icb_rsp_err
                           , ppi_icb_rsp_err
                           , clint_icb_rsp_err
                           , plic_icb_rsp_err
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_rsp_err
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_rsp_err
                           `endif//}
                           };

  assign splt_bus_icb_rsp_excl_ok = {
                             ifuerr_icb_rsp_excl_ok
                           , ppi_icb_rsp_excl_ok
                           , clint_icb_rsp_excl_ok
                           , plic_icb_rsp_excl_ok
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_rsp_excl_ok
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_rsp_excl_ok
                           `endif//}
                           };

  assign splt_bus_icb_rsp_rdata = {
                             ifuerr_icb_rsp_rdata
                           , ppi_icb_rsp_rdata
                           , clint_icb_rsp_rdata
                           , plic_icb_rsp_rdata
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_rsp_rdata
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_rsp_rdata
                           `endif//}
                           };

  assign {
                             ifuerr_icb_rsp_ready
                           , ppi_icb_rsp_ready
                           , clint_icb_rsp_ready
                           , plic_icb_rsp_ready
                           `ifdef E203_HAS_FIO //{
                           , fio_icb_rsp_ready
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , mem_icb_rsp_ready
                           `endif//}
                           } = splt_bus_icb_rsp_ready;

  wire buf_icb_cmd_ppi = ppi_icb_enable & (buf_icb_cmd_addr[`E203_PPI_BASE_REGION] ==  ppi_region_indic[`E203_PPI_BASE_REGION]);
  wire buf_icb_sel_ppi = buf_icb_cmd_ppi & (~buf_icb_cmd_ifu);

  wire buf_icb_cmd_clint = clint_icb_enable & (buf_icb_cmd_addr[`E203_CLINT_BASE_REGION] ==  clint_region_indic[`E203_CLINT_BASE_REGION]);
  wire buf_icb_sel_clint = buf_icb_cmd_clint & (~buf_icb_cmd_ifu);

  wire buf_icb_cmd_plic = plic_icb_enable & (buf_icb_cmd_addr[`E203_PLIC_BASE_REGION] ==  plic_region_indic[`E203_PLIC_BASE_REGION]);
  wire buf_icb_sel_plic = buf_icb_cmd_plic & (~buf_icb_cmd_ifu);

  `ifdef E203_HAS_FIO //{
  wire buf_icb_cmd_fio = fio_icb_enable & (buf_icb_cmd_addr[`E203_FIO_BASE_REGION] ==  fio_region_indic[`E203_FIO_BASE_REGION]);
  wire buf_icb_sel_fio = buf_icb_cmd_fio & (~buf_icb_cmd_ifu);
  `endif//}

  wire buf_icb_sel_ifuerr =(
                            buf_icb_cmd_ppi 
                          | buf_icb_cmd_clint 
                          | buf_icb_cmd_plic
                           `ifdef E203_HAS_FIO //{
                          | buf_icb_cmd_fio
                           `endif//}
                           ) & buf_icb_cmd_ifu;

  `ifdef E203_HAS_MEM_ITF //{
  wire buf_icb_sel_mem = mem_icb_enable 
                             & (~buf_icb_sel_ifuerr)
                             & (~buf_icb_sel_ppi)
                             & (~buf_icb_sel_clint)
                             & (~buf_icb_sel_plic)
                          `ifdef E203_HAS_FIO //{
                             & (~buf_icb_sel_fio)
                          `endif//}
                             ;
  `endif//}

  wire [BIU_SPLT_I_NUM-1:0] buf_icb_splt_indic = 
      {
                             buf_icb_sel_ifuerr
                           , buf_icb_sel_ppi
                           , buf_icb_sel_clint
                           , buf_icb_sel_plic
                           `ifdef E203_HAS_FIO //{
                           , buf_icb_sel_fio
                           `endif//}
                           `ifdef E203_HAS_MEM_ITF //{
                           , buf_icb_sel_mem
                           `endif//}
      };

  sirv_gnrl_icb_splt # (
  .ALLOW_DIFF (0),// Dont allow different branches oustanding
  .ALLOW_0CYCL_RSP (1),// Allow the 0 cycle response because in BIU the splt
                       //  is after the buffer, and will directly talk to the external
                       //  bus, where maybe the ROM is 0 cycle responsed.
  .FIFO_OUTS_NUM   (`E203_BIU_OUTS_NUM),
  .FIFO_CUT_READY  (`E203_BIU_CMD_CUT_READY),
  .SPLT_NUM   (BIU_SPLT_I_NUM),
  .SPLT_PTR_W (BIU_SPLT_I_NUM),
  .SPLT_PTR_1HOT (1),
  .USR_W      (1),
  .AW         (`E203_ADDR_SIZE),
  .DW         (`E203_XLEN) 
  ) u_biu_icb_splt(
  .i_icb_splt_indic       (buf_icb_splt_indic),        

  .i_icb_cmd_valid        (buf_icb_cmd_valid )     ,
  .i_icb_cmd_ready        (buf_icb_cmd_ready )     ,
  .i_icb_cmd_read         (buf_icb_cmd_read )      ,
  .i_icb_cmd_addr         (buf_icb_cmd_addr )      ,
  .i_icb_cmd_wdata        (buf_icb_cmd_wdata )     ,
  .i_icb_cmd_wmask        (buf_icb_cmd_wmask)      ,
  .i_icb_cmd_burst        (buf_icb_cmd_burst)     ,
  .i_icb_cmd_beat         (buf_icb_cmd_beat )     ,
  .i_icb_cmd_excl         (buf_icb_cmd_excl )     ,
  .i_icb_cmd_lock         (buf_icb_cmd_lock )     ,
  .i_icb_cmd_size         (buf_icb_cmd_size )     ,
  .i_icb_cmd_usr          (1'b0   )     ,
 
  .i_icb_rsp_valid        (buf_icb_rsp_valid )     ,
  .i_icb_rsp_ready        (buf_icb_rsp_ready )     ,
  .i_icb_rsp_err          (buf_icb_rsp_err)        ,
  .i_icb_rsp_excl_ok      (buf_icb_rsp_excl_ok)    ,
  .i_icb_rsp_rdata        (buf_icb_rsp_rdata )     ,
  .i_icb_rsp_usr          ( )     ,
                               
  .o_bus_icb_cmd_ready    (splt_bus_icb_cmd_ready ) ,
  .o_bus_icb_cmd_valid    (splt_bus_icb_cmd_valid ) ,
  .o_bus_icb_cmd_read     (splt_bus_icb_cmd_read )  ,
  .o_bus_icb_cmd_addr     (splt_bus_icb_cmd_addr )  ,
  .o_bus_icb_cmd_wdata    (splt_bus_icb_cmd_wdata ) ,
  .o_bus_icb_cmd_wmask    (splt_bus_icb_cmd_wmask)  ,
  .o_bus_icb_cmd_burst    (splt_bus_icb_cmd_burst),
  .o_bus_icb_cmd_beat     (splt_bus_icb_cmd_beat ),
  .o_bus_icb_cmd_excl     (splt_bus_icb_cmd_excl ),
  .o_bus_icb_cmd_lock     (splt_bus_icb_cmd_lock ),
  .o_bus_icb_cmd_size     (splt_bus_icb_cmd_size ),
  .o_bus_icb_cmd_usr      ()     ,
  
  .o_bus_icb_rsp_valid    (splt_bus_icb_rsp_valid ) ,
  .o_bus_icb_rsp_ready    (splt_bus_icb_rsp_ready ) ,
  .o_bus_icb_rsp_err      (splt_bus_icb_rsp_err)    ,
  .o_bus_icb_rsp_excl_ok  (splt_bus_icb_rsp_excl_ok),
  .o_bus_icb_rsp_rdata    (splt_bus_icb_rsp_rdata ) ,
  .o_bus_icb_rsp_usr      ({BIU_SPLT_I_NUM{1'b0}}) ,
                             
  .clk                    (clk  )                     ,
  .rst_n                  (rst_n)
  );


  assign biu_active = ifu2biu_icb_cmd_valid | lsu2biu_icb_cmd_valid | icb_buffer_active; 

  ///////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////
  // Implement the IFU-accessed-Peripheral region error
  assign  ifuerr_icb_cmd_ready = ifuerr_icb_rsp_ready;
  
     // 0 Cycle response
  assign  ifuerr_icb_rsp_valid = ifuerr_icb_cmd_valid;
  assign  ifuerr_icb_rsp_err   = 1'b1;
  assign  ifuerr_icb_rsp_excl_ok = 1'b0;
  assign  ifuerr_icb_rsp_rdata   = {`E203_XLEN{1'b0}};


endmodule

