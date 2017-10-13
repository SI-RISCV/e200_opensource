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
//  The itcm_ctrl module control the ITCM access requests 
//
// ====================================================================
`include "e203_defines.v"

  `ifdef E203_HAS_ITCM //{

module e203_itcm_ctrl(
  output itcm_active,
  // The cgstop is coming from CSR (0xBFE mcgstop)'s filed 1
  // // This register is our self-defined CSR register to disable the 
      // ITCM SRAM clock gating for debugging purpose
  input  tcm_cgstop,
  // Note: the ITCM ICB interface only support the single-transaction
  
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // IFU ICB to ITCM
  //    * Bus cmd channel
  input  ifu2itcm_icb_cmd_valid, // Handshake valid
  output ifu2itcm_icb_cmd_ready, // Handshake ready
            // Note: The data on rdata or wdata channel must be naturally
            //       aligned, this is in line with the AXI definition
  input  [`E203_ITCM_ADDR_WIDTH-1:0] ifu2itcm_icb_cmd_addr, // Bus transaction start addr 
  input  ifu2itcm_icb_cmd_read,   // Read or write
  input  [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_cmd_wdata, 
  input  [`E203_ITCM_WMSK_WIDTH-1:0] ifu2itcm_icb_cmd_wmask, 

  //    * Bus RSP channel
  output ifu2itcm_icb_rsp_valid, // Response valid 
  input  ifu2itcm_icb_rsp_ready, // Response ready
  output ifu2itcm_icb_rsp_err,   // Response error
            // Note: the RSP rdata is inline with AXI definition
  output [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_rsp_rdata, 
  
  output ifu2itcm_holdup,
  //output ifu2itcm_replay,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // LSU ICB to ITCM
  //    * Bus cmd channel
  input  lsu2itcm_icb_cmd_valid, // Handshake valid
  output lsu2itcm_icb_cmd_ready, // Handshake ready
            // Note: The data on rdata or wdata channel must be naturally
            //       aligned, this is in line with the AXI definition
  input  [`E203_ITCM_ADDR_WIDTH-1:0]   lsu2itcm_icb_cmd_addr, // Bus transaction start addr 
  input  lsu2itcm_icb_cmd_read,   // Read or write
  input  [32-1:0] lsu2itcm_icb_cmd_wdata, 
  input  [4-1:0] lsu2itcm_icb_cmd_wmask, 

  //    * Bus RSP channel
  output lsu2itcm_icb_rsp_valid, // Response valid 
  input  lsu2itcm_icb_rsp_ready, // Response ready
  output lsu2itcm_icb_rsp_err,   // Response error
            // Note: the RSP rdata is inline with AXI definition
  output [32-1:0] lsu2itcm_icb_rsp_rdata, 



  `ifdef E203_HAS_ITCM_EXTITF //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // External-agent ICB to ITCM
  //    * Bus cmd channel
  input  ext2itcm_icb_cmd_valid, // Handshake valid
  output ext2itcm_icb_cmd_ready, // Handshake ready
            // Note: The data on rdata or wdata channel must be naturally
            //       aligned, this is in line with the AXI definition
  input  [`E203_ITCM_ADDR_WIDTH-1:0]   ext2itcm_icb_cmd_addr, // Bus transaction start addr 
  input  ext2itcm_icb_cmd_read,   // Read or write
  input  [32-1:0] ext2itcm_icb_cmd_wdata, 
  input  [ 4-1:0] ext2itcm_icb_cmd_wmask, 

  //    * Bus RSP channel
  output ext2itcm_icb_rsp_valid, // Response valid 
  input  ext2itcm_icb_rsp_ready, // Response ready
  output ext2itcm_icb_rsp_err,   // Response error
            // Note: the RSP rdata is inline with AXI definition
  output [32-1:0] ext2itcm_icb_rsp_rdata, 
  `endif//}

  output                         itcm_ram_cs,  
  output                         itcm_ram_we,  
  output [`E203_ITCM_RAM_AW-1:0] itcm_ram_addr, 
  output [`E203_ITCM_RAM_MW-1:0] itcm_ram_wem,
  output [`E203_ITCM_RAM_DW-1:0] itcm_ram_din,          
  input  [`E203_ITCM_RAM_DW-1:0] itcm_ram_dout,
  output                         clk_itcm_ram,

  input  test_mode,
  input  clk,
  input  rst_n
  );

    // LSU2ITCM converted to ICM data width
  //    * Bus cmd channel
  wire lsu_icb_cmd_valid;
  wire lsu_icb_cmd_ready;
  wire [`E203_ITCM_ADDR_WIDTH-1:0] lsu_icb_cmd_addr;
  wire lsu_icb_cmd_read;
  wire [`E203_ITCM_DATA_WIDTH-1:0] lsu_icb_cmd_wdata;
  wire [`E203_ITCM_DATA_WIDTH/8-1:0] lsu_icb_cmd_wmask;

  //    * Bus RSP channel
  wire lsu_icb_rsp_valid;
  wire lsu_icb_rsp_ready;
  wire lsu_icb_rsp_err;
  wire [`E203_ITCM_DATA_WIDTH-1:0] lsu_icb_rsp_rdata; 

  sirv_gnrl_icb_n2w # (
  .FIFO_OUTS_NUM   (`E203_ITCM_OUTS_NUM),
  .FIFO_CUT_READY  (0),
  .USR_W      (1),
  .AW         (`E203_ITCM_ADDR_WIDTH),
  .X_W        (32),
  .Y_W        (`E203_ITCM_DATA_WIDTH) 
  ) u_itcm_icb_lsu2itcm_n2w(
  .i_icb_cmd_valid        (lsu2itcm_icb_cmd_valid ),  
  .i_icb_cmd_ready        (lsu2itcm_icb_cmd_ready ),
  .i_icb_cmd_read         (lsu2itcm_icb_cmd_read ) ,
  .i_icb_cmd_addr         (lsu2itcm_icb_cmd_addr ) ,
  .i_icb_cmd_wdata        (lsu2itcm_icb_cmd_wdata ),
  .i_icb_cmd_wmask        (lsu2itcm_icb_cmd_wmask) ,
  .i_icb_cmd_burst        (2'b0)                   ,
  .i_icb_cmd_beat         (2'b0)                   ,
  .i_icb_cmd_lock         (1'b0),
  .i_icb_cmd_excl         (1'b0),
  .i_icb_cmd_size         (2'b0),
  .i_icb_cmd_usr          (1'b0),
   
  .i_icb_rsp_valid        (lsu2itcm_icb_rsp_valid ),
  .i_icb_rsp_ready        (lsu2itcm_icb_rsp_ready ),
  .i_icb_rsp_err          (lsu2itcm_icb_rsp_err)   ,
  .i_icb_rsp_excl_ok      ()   ,
  .i_icb_rsp_rdata        (lsu2itcm_icb_rsp_rdata ),
  .i_icb_rsp_usr          (),
                                                
  .o_icb_cmd_valid        (lsu_icb_cmd_valid ),  
  .o_icb_cmd_ready        (lsu_icb_cmd_ready ),
  .o_icb_cmd_read         (lsu_icb_cmd_read ) ,
  .o_icb_cmd_addr         (lsu_icb_cmd_addr ) ,
  .o_icb_cmd_wdata        (lsu_icb_cmd_wdata ),
  .o_icb_cmd_wmask        (lsu_icb_cmd_wmask) ,
  .o_icb_cmd_burst        ()                   ,
  .o_icb_cmd_beat         ()                   ,
  .o_icb_cmd_lock         (),
  .o_icb_cmd_excl         (),
  .o_icb_cmd_size         (),
  .o_icb_cmd_usr          (),
   
  .o_icb_rsp_valid        (lsu_icb_rsp_valid ),
  .o_icb_rsp_ready        (lsu_icb_rsp_ready ),
  .o_icb_rsp_err          (lsu_icb_rsp_err)   ,
  .o_icb_rsp_excl_ok      (1'b0)   ,
  .o_icb_rsp_rdata        (lsu_icb_rsp_rdata ),
  .o_icb_rsp_usr          (1'b0),

  .clk                    (clk   )                  ,
  .rst_n                  (rst_n )                 
  );

  `ifdef E203_HAS_ITCM_EXTITF //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // EXTITF converted to ICM data width
  //    * Bus cmd channel
  wire ext_icb_cmd_valid;
  wire ext_icb_cmd_ready;
  wire [`E203_ITCM_ADDR_WIDTH-1:0] ext_icb_cmd_addr;
  wire ext_icb_cmd_read;
  wire [`E203_ITCM_DATA_WIDTH-1:0] ext_icb_cmd_wdata;
  wire [`E203_ITCM_WMSK_WIDTH-1:0] ext_icb_cmd_wmask;

  //    * Bus RSP channel
  wire ext_icb_rsp_valid;
  wire ext_icb_rsp_ready;
  wire ext_icb_rsp_err;
  wire [`E203_ITCM_DATA_WIDTH-1:0] ext_icb_rsp_rdata; 

  `ifdef E203_SYSMEM_DATA_WIDTH_IS_32 //{
  `ifdef E203_ITCM_DATA_WIDTH_IS_64 //{
  sirv_gnrl_icb_n2w # (
  .USR_W      (1),
  .FIFO_OUTS_NUM   (`E203_ITCM_OUTS_NUM),
  .FIFO_CUT_READY  (0),
  .AW         (`E203_ITCM_ADDR_WIDTH),
  .X_W        (`E203_SYSMEM_DATA_WIDTH), 
  .Y_W        (`E203_ITCM_DATA_WIDTH) 
  ) u_itcm_icb_ext2itcm_n2w(
  .i_icb_cmd_valid        (ext2itcm_icb_cmd_valid ),  
  .i_icb_cmd_ready        (ext2itcm_icb_cmd_ready ),
  .i_icb_cmd_read         (ext2itcm_icb_cmd_read ) ,
  .i_icb_cmd_addr         (ext2itcm_icb_cmd_addr ) ,
  .i_icb_cmd_wdata        (ext2itcm_icb_cmd_wdata ),
  .i_icb_cmd_wmask        (ext2itcm_icb_cmd_wmask) ,
  .i_icb_cmd_burst        (2'b0)                   ,
  .i_icb_cmd_beat         (2'b0)                   ,
  .i_icb_cmd_lock         (1'b0),
  .i_icb_cmd_excl         (1'b0),
  .i_icb_cmd_size         (2'b0),
  .i_icb_cmd_usr          (1'b0),
   
  .i_icb_rsp_valid        (ext2itcm_icb_rsp_valid ),
  .i_icb_rsp_ready        (ext2itcm_icb_rsp_ready ),
  .i_icb_rsp_err          (ext2itcm_icb_rsp_err)   ,
  .i_icb_rsp_excl_ok      ()   ,
  .i_icb_rsp_rdata        (ext2itcm_icb_rsp_rdata ),
  .i_icb_rsp_usr          (),
                                                
  .o_icb_cmd_valid        (ext_icb_cmd_valid ),  
  .o_icb_cmd_ready        (ext_icb_cmd_ready ),
  .o_icb_cmd_read         (ext_icb_cmd_read ) ,
  .o_icb_cmd_addr         (ext_icb_cmd_addr ) ,
  .o_icb_cmd_wdata        (ext_icb_cmd_wdata ),
  .o_icb_cmd_wmask        (ext_icb_cmd_wmask) ,
  .o_icb_cmd_burst        ()                   ,
  .o_icb_cmd_beat         ()                   ,
  .o_icb_cmd_lock         (),
  .o_icb_cmd_excl         (),
  .o_icb_cmd_size         (),
  .o_icb_cmd_usr          (),
   
  .o_icb_rsp_valid        (ext_icb_rsp_valid ),
  .o_icb_rsp_ready        (ext_icb_rsp_ready ),
  .o_icb_rsp_err          (ext_icb_rsp_err)   ,
  .o_icb_rsp_excl_ok      (1'b0),
  .o_icb_rsp_rdata        (ext_icb_rsp_rdata ),
  .o_icb_rsp_usr          (1'b0),

  .clk                    (clk  ) ,
  .rst_n                  (rst_n)                 
  );
  `endif//}
  `else//}{
      !!! ERROR: There must be something wrong, our System interface
                must be 32bits and ITCM must be 64bits to save area and powers!!!
  `endif//}
  `endif//}

  wire arbt_icb_cmd_valid;
  wire arbt_icb_cmd_ready;
  wire [`E203_ITCM_ADDR_WIDTH-1:0] arbt_icb_cmd_addr;
  wire arbt_icb_cmd_read;
  wire [`E203_ITCM_DATA_WIDTH-1:0] arbt_icb_cmd_wdata;
  wire [`E203_ITCM_WMSK_WIDTH-1:0] arbt_icb_cmd_wmask;

  wire arbt_icb_rsp_valid;
  wire arbt_icb_rsp_ready;
  wire arbt_icb_rsp_err;
  wire [`E203_ITCM_DATA_WIDTH-1:0] arbt_icb_rsp_rdata;

  `ifdef E203_HAS_ITCM_EXTITF //{
      localparam ITCM_ARBT_I_NUM = 2;
      localparam ITCM_ARBT_I_PTR_W = 1;
  `else//}{
      localparam ITCM_ARBT_I_NUM = 1;
      localparam ITCM_ARBT_I_PTR_W = 1;
  `endif//}

  wire [ITCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_valid;
  wire [ITCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_ready;
  wire [ITCM_ARBT_I_NUM*`E203_ITCM_ADDR_WIDTH-1:0] arbt_bus_icb_cmd_addr;
  wire [ITCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_cmd_read;
  wire [ITCM_ARBT_I_NUM*`E203_ITCM_DATA_WIDTH-1:0] arbt_bus_icb_cmd_wdata;
  wire [ITCM_ARBT_I_NUM*`E203_ITCM_WMSK_WIDTH-1:0] arbt_bus_icb_cmd_wmask;

  wire [ITCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_valid;
  wire [ITCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_ready;
  wire [ITCM_ARBT_I_NUM*1-1:0] arbt_bus_icb_rsp_err;
  wire [ITCM_ARBT_I_NUM*`E203_ITCM_DATA_WIDTH-1:0] arbt_bus_icb_rsp_rdata;

  assign arbt_bus_icb_cmd_valid =
      // LSU take higher priority
                           {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_cmd_valid,
                      `endif//}
                             lsu_icb_cmd_valid
                           } ;
  assign arbt_bus_icb_cmd_addr =
                           {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_cmd_addr,
                      `endif//}
                             lsu_icb_cmd_addr
                           } ;
  assign arbt_bus_icb_cmd_read =
                           {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_cmd_read,
                      `endif//}
                             lsu_icb_cmd_read
                           } ;
  assign arbt_bus_icb_cmd_wdata =
                           {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_cmd_wdata,
                      `endif//}
                             lsu_icb_cmd_wdata
                           } ;
  assign arbt_bus_icb_cmd_wmask =
                           {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_cmd_wmask,
                      `endif//}
                             lsu_icb_cmd_wmask
                           } ;
  assign                   {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_cmd_ready,
                      `endif//}
                             lsu_icb_cmd_ready
                           } = arbt_bus_icb_cmd_ready;


  assign                   {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_rsp_valid,
                      `endif//}
                             lsu_icb_rsp_valid
                           } = arbt_bus_icb_rsp_valid;
  assign                   {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_rsp_err,
                      `endif//}
                             lsu_icb_rsp_err
                           } = arbt_bus_icb_rsp_err;
  assign                   {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_rsp_rdata,
                      `endif//}
                             lsu_icb_rsp_rdata
                           } = arbt_bus_icb_rsp_rdata;
  assign arbt_bus_icb_rsp_ready = {
                      `ifdef E203_HAS_ITCM_EXTITF //{
                             ext_icb_rsp_ready,
                      `endif//}
                             lsu_icb_rsp_ready
                           };

  sirv_gnrl_icb_arbt # (
  .ARBT_SCHEME (0),// Priority based
  .ALLOW_0CYCL_RSP (0),// Dont allow the 0 cycle response because for ITCM and DTCM, 
                       //   Dcache, .etc, definitely they cannot reponse as 0 cycle
  .FIFO_OUTS_NUM   (`E203_ITCM_OUTS_NUM),
  .FIFO_CUT_READY(0),
  .USR_W      (1),
  .ARBT_NUM   (ITCM_ARBT_I_NUM  ),
  .ARBT_PTR_W (ITCM_ARBT_I_PTR_W),
  .AW         (`E203_ITCM_ADDR_WIDTH),
  .DW         (`E203_ITCM_DATA_WIDTH) 
  ) u_itcm_icb_arbt(
  .o_icb_cmd_valid        (arbt_icb_cmd_valid )     ,
  .o_icb_cmd_ready        (arbt_icb_cmd_ready )     ,
  .o_icb_cmd_read         (arbt_icb_cmd_read )      ,
  .o_icb_cmd_addr         (arbt_icb_cmd_addr )      ,
  .o_icb_cmd_wdata        (arbt_icb_cmd_wdata )     ,
  .o_icb_cmd_wmask        (arbt_icb_cmd_wmask)      ,
  .o_icb_cmd_burst        ()     ,
  .o_icb_cmd_beat         ()     ,
  .o_icb_cmd_lock         ()     ,
  .o_icb_cmd_excl         ()     ,
  .o_icb_cmd_size         ()     ,
  .o_icb_cmd_usr          ()     ,
                                
  .o_icb_rsp_valid        (arbt_icb_rsp_valid )     ,
  .o_icb_rsp_ready        (arbt_icb_rsp_ready )     ,
  .o_icb_rsp_err          (arbt_icb_rsp_err)        ,
  .o_icb_rsp_rdata        (arbt_icb_rsp_rdata )     ,
  .o_icb_rsp_usr          (1'b0),
  .o_icb_rsp_excl_ok      (1'b0),
                               
  .i_bus_icb_cmd_ready    (arbt_bus_icb_cmd_ready ) ,
  .i_bus_icb_cmd_valid    (arbt_bus_icb_cmd_valid ) ,
  .i_bus_icb_cmd_read     (arbt_bus_icb_cmd_read )  ,
  .i_bus_icb_cmd_addr     (arbt_bus_icb_cmd_addr )  ,
  .i_bus_icb_cmd_wdata    (arbt_bus_icb_cmd_wdata ) ,
  .i_bus_icb_cmd_wmask    (arbt_bus_icb_cmd_wmask)  ,
  .i_bus_icb_cmd_burst    ({2*ITCM_ARBT_I_NUM{1'b0}}) ,
  .i_bus_icb_cmd_beat     ({2*ITCM_ARBT_I_NUM{1'b0}}) ,
  .i_bus_icb_cmd_lock     ({1*ITCM_ARBT_I_NUM{1'b0}}),
  .i_bus_icb_cmd_excl     ({1*ITCM_ARBT_I_NUM{1'b0}}),
  .i_bus_icb_cmd_size     ({2*ITCM_ARBT_I_NUM{1'b0}}),
  .i_bus_icb_cmd_usr      ({1*ITCM_ARBT_I_NUM{1'b0}}),

                                
  .i_bus_icb_rsp_valid    (arbt_bus_icb_rsp_valid ) ,
  .i_bus_icb_rsp_ready    (arbt_bus_icb_rsp_ready ) ,
  .i_bus_icb_rsp_err      (arbt_bus_icb_rsp_err)    ,
  .i_bus_icb_rsp_rdata    (arbt_bus_icb_rsp_rdata ) ,
  .i_bus_icb_rsp_usr      (),
  .i_bus_icb_rsp_excl_ok  (),
                             
  .clk                    (clk  )                     ,
  .rst_n                  (rst_n)
  );

  //
  wire arbt_o_icb_cmd_valid;
  wire arbt_o_icb_cmd_ready;
  wire [`E203_ITCM_ADDR_WIDTH-1:0] arbt_o_icb_cmd_addr;
  wire arbt_o_icb_cmd_read;
  wire [`E203_ITCM_DATA_WIDTH-1:0] arbt_o_icb_cmd_wdata;
  wire [`E203_ITCM_WMSK_WIDTH-1:0] arbt_o_icb_cmd_wmask;

  wire arbt_o_icb_rsp_valid;
  wire arbt_o_icb_rsp_ready;
  wire arbt_o_icb_rsp_err;
  wire [`E203_ITCM_DATA_WIDTH-1:0] arbt_o_icb_rsp_rdata;

  e203_itcm_icb_gen u_itcm_icb_gen (
  .i_icb_cmd_valid        (arbt_icb_cmd_valid ),  
  .i_icb_cmd_ready        (arbt_icb_cmd_ready ),
  .i_icb_cmd_read         (arbt_icb_cmd_read ) ,
  .i_icb_cmd_addr         (arbt_icb_cmd_addr ) ,
  .i_icb_cmd_wdata        (arbt_icb_cmd_wdata ),
  .i_icb_cmd_wmask        (arbt_icb_cmd_wmask) ,
   
  .i_icb_rsp_valid        (arbt_icb_rsp_valid ),
  .i_icb_rsp_ready        (arbt_icb_rsp_ready ),
  .i_icb_rsp_err          (arbt_icb_rsp_err)   ,
  .i_icb_rsp_rdata        (arbt_icb_rsp_rdata ),
                                                
  .o_icb_cmd_valid        (arbt_o_icb_cmd_valid ),  
  .o_icb_cmd_ready        (arbt_o_icb_cmd_ready ),
  .o_icb_cmd_read         (arbt_o_icb_cmd_read ) ,
  .o_icb_cmd_addr         (arbt_o_icb_cmd_addr ) ,
  .o_icb_cmd_wdata        (arbt_o_icb_cmd_wdata ),
  .o_icb_cmd_wmask        (arbt_o_icb_cmd_wmask) ,
   
  .o_icb_rsp_valid        (arbt_o_icb_rsp_valid ),
  .o_icb_rsp_ready        (arbt_o_icb_rsp_ready ),
  .o_icb_rsp_err          (arbt_o_icb_rsp_err)   ,
  .o_icb_rsp_rdata        (arbt_o_icb_rsp_rdata ) 
  );




  wire sram_ready2ifu = 1'b1
                   //The EXT and load/store have higher priotry than the ifetch
                      & (~arbt_icb_cmd_valid)
                   ;

  wire sram_ready2arbt = 1'b1
                  ;


  wire sram_sel_ifu  = sram_ready2ifu  & ifu2itcm_icb_cmd_valid;
  wire sram_sel_arbt = sram_ready2arbt & arbt_icb_cmd_valid;

  wire sram_icb_cmd_ready;
  wire sram_icb_cmd_valid;

  assign ifu2itcm_icb_cmd_ready = sram_ready2ifu   & sram_icb_cmd_ready;
  assign arbt_o_icb_cmd_ready = sram_ready2arbt  & sram_icb_cmd_ready;



  wire [`E203_ITCM_ADDR_WIDTH-1:0] sram_icb_cmd_addr;
  wire sram_icb_cmd_read;
  wire [`E203_ITCM_DATA_WIDTH-1:0] sram_icb_cmd_wdata;
  wire [`E203_ITCM_WMSK_WIDTH-1:0] sram_icb_cmd_wmask;

  assign sram_icb_cmd_valid = (sram_sel_ifu   & ifu2itcm_icb_cmd_valid)
                            | (sram_sel_arbt  & arbt_o_icb_cmd_valid);


  assign sram_icb_cmd_addr  =  
                              ({`E203_ITCM_ADDR_WIDTH{sram_sel_ifu  }} & ifu2itcm_icb_cmd_addr)
                            | ({`E203_ITCM_ADDR_WIDTH{sram_sel_arbt }} & arbt_o_icb_cmd_addr);
  assign sram_icb_cmd_read  =  
                              (sram_sel_ifu   & ifu2itcm_icb_cmd_read)
                            | (sram_sel_arbt  & arbt_o_icb_cmd_read);
  assign sram_icb_cmd_wdata =  
                              ({`E203_ITCM_DATA_WIDTH{sram_sel_ifu  }} & ifu2itcm_icb_cmd_wdata)
                            | ({`E203_ITCM_DATA_WIDTH{sram_sel_arbt }} & arbt_o_icb_cmd_wdata);
  assign sram_icb_cmd_wmask =  
                              ({`E203_ITCM_WMSK_WIDTH{sram_sel_ifu  }} & ifu2itcm_icb_cmd_wmask)
                            | ({`E203_ITCM_WMSK_WIDTH{sram_sel_arbt }} & arbt_o_icb_cmd_wmask);
 wire e1_sel_ifu_r;
 wire e2_sel_ifu_r;

 wire e1_icb_read_r;
 wire e2_icb_read_r;

 wire[1:0] e1_i_dat;

 wire      e1_o_vld;
 wire      e1_o_rdy;
 wire[1:0] e1_o_dat;

 wire      e2_i_vld;
 wire      e2_i_rdy;
 wire      e2_o_vld;
 wire      e2_o_rdy;
 wire[`E203_ITCM_DATA_WIDTH+2-1:0] e2_i_dat;
 wire[`E203_ITCM_DATA_WIDTH+2-1:0] e2_o_dat;

 wire  [`E203_ITCM_DATA_WIDTH-1:0] itcm_ram_dout_r;

 assign e1_i_dat ={
                       sram_sel_ifu
                      ,sram_icb_cmd_read
                     };
 
 assign {
            e1_sel_ifu_r 
          , e1_icb_read_r 
         } = e1_o_dat;

 assign e2_i_dat = {
             e1_sel_ifu_r 
           , e1_icb_read_r 
           , itcm_ram_dout 
        };

 assign {
             e2_sel_ifu_r 
           , e2_icb_read_r 
           , itcm_ram_dout_r 
        } = e2_o_dat;

 sirv_gnrl_pipe_stage # (
  .CUT_READY(0),
  .DP(1),
  .DW(2)
 ) u_itcm_e1_stage (
   .i_vld(sram_icb_cmd_valid), 
   .i_rdy(sram_icb_cmd_ready), 
   .i_dat(e1_i_dat),
   .o_vld(e1_o_vld), 
   .o_rdy(e1_o_rdy), 
   .o_dat(e1_o_dat),
 
   .clk  (clk  ),
   .rst_n(rst_n)  
  );

 assign e2_i_vld = e1_o_vld;
 assign e1_o_rdy = e2_i_rdy;

 sirv_gnrl_pipe_stage # (
  .CUT_READY(0),
  .DP(0),
  .DW(`E203_ITCM_DATA_WIDTH+2)
 ) u_itcm_e2_stage (
   .i_vld(e2_i_vld), 
   .i_rdy(e2_i_rdy), 
   .i_dat(e2_i_dat),
   .o_vld(e2_o_vld), 
   .o_rdy(e2_o_rdy), 
   .o_dat(e2_o_dat),
 
   .clk  (clk  ),
   .rst_n(rst_n)
  );


  wire chk_icb_rsp_valid;
  wire chk_icb_rsp_ready;
  wire chk_icb_rsp_err;
  wire [`E203_ITCM_DATA_WIDTH-1:0] chk_icb_rsp_rdata;
  wire chk_icb_rsp_ifu;

  //
  e203_itcm_icb_chck u_itcm_icb_chck (
  .i_vld(e2_o_vld), 
  .i_rdy(e2_o_rdy), 
  .i_dat(itcm_ram_dout_r[`E203_ITCM_DATA_WIDTH-1:0]), 
  .i_sel_ifu (e2_sel_ifu_r), 
  .i_icb_read(e2_icb_read_r), 

  .o_icb_rsp_valid        (chk_icb_rsp_valid ),
  .o_icb_rsp_ready        (chk_icb_rsp_ready ),
  .o_icb_rsp_err          (chk_icb_rsp_err)   ,
  .o_icb_rsp_rdata        (chk_icb_rsp_rdata ),
  .o_icb_rsp_ifu          (chk_icb_rsp_ifu ),
                                                
   
  .clk                    (clk  ),
  .rst_n                  (rst_n)                 
  );

  // The E2 pass to IFU RSP channel only when it is IFU access 
  // The E2 pass to ARBT RSP channel only when it is not IFU access
  assign chk_icb_rsp_ready = chk_icb_rsp_ifu ? 
                    ifu2itcm_icb_rsp_ready : arbt_o_icb_rsp_ready;

  assign ifu2itcm_icb_rsp_valid = chk_icb_rsp_valid & chk_icb_rsp_ifu;
  assign ifu2itcm_icb_rsp_err   = chk_icb_rsp_err;
  assign ifu2itcm_icb_rsp_rdata = chk_icb_rsp_rdata;

  assign arbt_o_icb_rsp_valid = chk_icb_rsp_valid & (~chk_icb_rsp_ifu);
  assign arbt_o_icb_rsp_err   = chk_icb_rsp_err;
  assign arbt_o_icb_rsp_rdata = chk_icb_rsp_rdata;

  assign itcm_ram_cs = sram_icb_cmd_valid & sram_icb_cmd_ready;  
  assign itcm_ram_we = (~sram_icb_cmd_read);  
  assign itcm_ram_addr= sram_icb_cmd_addr [`E203_ITCM_ADDR_WIDTH-1:`E203_ITCM_ADDR_WIDTH-`E203_ITCM_RAM_AW];          
  assign itcm_ram_wem = sram_icb_cmd_wmask[`E203_ITCM_WMSK_WIDTH-1:0];          
  assign itcm_ram_din = sram_icb_cmd_wdata[`E203_ITCM_DATA_WIDTH-1:0];          

  wire itcm_sram_clk_en = itcm_ram_cs | tcm_cgstop;

  e203_clkgate u_itcm_clkgate(
    .clk_in   (clk        ),
    .test_mode(test_mode  ),
    .clock_en (itcm_sram_clk_en),
    .clk_out  (clk_itcm_ram)
  );

  // The holdup indicating the target is not accessed by other agents 
  // since last accessed by IFU, and the output of it is holding up
  // last value. Hence,
  //   * The holdup flag it set when there is a succuess (no-error) ifetch
  //       accessed this target
  //   * The holdup flag it clear when when 
  //         ** other agent (non-IFU) accessed this target
  //         ** other agent (non-IFU) accessed this target
                //for example:
                //   *** The external agent accessed the ITCM
                //   *** I$ updated by cache maintaineice operation
  wire ifu_holdup_r;
  // The IFU holdup will be set after last time accessed by a IFU access
  wire ifu_holdup_set =   sram_sel_ifu & itcm_ram_cs;
  // The IFU holdup will be cleared after last time accessed by a non-IFU access
  wire ifu_holdup_clr = (~sram_sel_ifu) & itcm_ram_cs;
  wire ifu_holdup_ena = ifu_holdup_set | ifu_holdup_clr;
  wire ifu_holdup_nxt = ifu_holdup_set & (~ifu_holdup_clr);
  sirv_gnrl_dfflr #(1)ifu_holdup_dffl(ifu_holdup_ena, ifu_holdup_nxt, ifu_holdup_r, clk, rst_n);
  assign ifu2itcm_holdup = ifu_holdup_r;


  assign itcm_active = ifu2itcm_icb_cmd_valid | lsu2itcm_icb_cmd_valid | e1_o_vld | e2_o_vld
                  `ifdef E203_HAS_ITCM_EXTITF //{
                      | ext2itcm_icb_cmd_valid
                  `endif//}
                      ;

endmodule

  `endif//}
