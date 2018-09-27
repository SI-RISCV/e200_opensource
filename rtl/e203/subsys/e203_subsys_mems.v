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
//  The system memory bus and the ROM instance 
//
// ====================================================================


`include "e203_defines.v"


module e203_subsys_mems(
  input                          mem_icb_cmd_valid,
  output                         mem_icb_cmd_ready,
  input  [`E203_ADDR_SIZE-1:0]   mem_icb_cmd_addr, 
  input                          mem_icb_cmd_read, 
  input  [`E203_XLEN-1:0]        mem_icb_cmd_wdata,
  input  [`E203_XLEN/8-1:0]      mem_icb_cmd_wmask,
  //
  output                         mem_icb_rsp_valid,
  input                          mem_icb_rsp_ready,
  output                         mem_icb_rsp_err,
  output [`E203_XLEN-1:0]        mem_icb_rsp_rdata,
  
  //////////////////////////////////////////////////////////
  output                         sysmem_icb_cmd_valid,
  input                          sysmem_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   sysmem_icb_cmd_addr, 
  output                         sysmem_icb_cmd_read, 
  output [`E203_XLEN-1:0]        sysmem_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      sysmem_icb_cmd_wmask,
  //
  input                          sysmem_icb_rsp_valid,
  output                         sysmem_icb_rsp_ready,
  input                          sysmem_icb_rsp_err,
  input  [`E203_XLEN-1:0]        sysmem_icb_rsp_rdata,

    //////////////////////////////////////////////////////////
  output                         qspi0_ro_icb_cmd_valid,
  input                          qspi0_ro_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   qspi0_ro_icb_cmd_addr, 
  output                         qspi0_ro_icb_cmd_read, 
  output [`E203_XLEN-1:0]        qspi0_ro_icb_cmd_wdata,
  //
  input                          qspi0_ro_icb_rsp_valid,
  output                         qspi0_ro_icb_rsp_ready,
  input                          qspi0_ro_icb_rsp_err,
  input  [`E203_XLEN-1:0]        qspi0_ro_icb_rsp_rdata,


    //////////////////////////////////////////////////////////
  output                         otp_ro_icb_cmd_valid,
  input                          otp_ro_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   otp_ro_icb_cmd_addr, 
  output                         otp_ro_icb_cmd_read, 
  output [`E203_XLEN-1:0]        otp_ro_icb_cmd_wdata,
  //
  input                          otp_ro_icb_rsp_valid,
  output                         otp_ro_icb_rsp_ready,
  input                          otp_ro_icb_rsp_err,
  input  [`E203_XLEN-1:0]        otp_ro_icb_rsp_rdata,

    //////////////////////////////////////////////////////////
  output                         dm_icb_cmd_valid,
  input                          dm_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   dm_icb_cmd_addr, 
  output                         dm_icb_cmd_read, 
  output [`E203_XLEN-1:0]        dm_icb_cmd_wdata,
  //
  input                          dm_icb_rsp_valid,
  output                         dm_icb_rsp_ready,
  input  [`E203_XLEN-1:0]        dm_icb_rsp_rdata,

  input  clk,
  input  bus_rst_n,
  input  rst_n
  );



      
  wire                         mrom_icb_cmd_valid;
  wire                         mrom_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   mrom_icb_cmd_addr; 
  wire                         mrom_icb_cmd_read; 
  
  wire                         mrom_icb_rsp_valid;
  wire                         mrom_icb_rsp_ready;
  wire                         mrom_icb_rsp_err  ;
  wire [`E203_XLEN-1:0]        mrom_icb_rsp_rdata;

  wire                     expl_axi_icb_cmd_valid;
  wire                     expl_axi_icb_cmd_ready;
  wire [32-1:0]            expl_axi_icb_cmd_addr; 
  wire                     expl_axi_icb_cmd_read; 
  wire [32-1:0]            expl_axi_icb_cmd_wdata;
  wire [4 -1:0]            expl_axi_icb_cmd_wmask;
  
  wire                     expl_axi_icb_rsp_valid;
  wire                     expl_axi_icb_rsp_ready;
  wire [32-1:0]            expl_axi_icb_rsp_rdata;
  wire                     expl_axi_icb_rsp_err;


 localparam MROM_AW = 12  ;
 localparam MROM_DP = 1024;
  // There are several slaves for Mem bus, including:
  //  * DM        : 0x0000 0000 -- 0x0000 0FFF
  //  * MROM      : 0x0000 1000 -- 0x0000 1FFF
  //  * OTP-RO    : 0x0002 0000 -- 0x0003 FFFF
  //  * QSPI0-RO  : 0x2000 0000 -- 0x3FFF FFFF
  //  * SysMem    : 0x8000 0000 -- 0xFFFF FFFF

  sirv_icb1to8_bus # (
  .ICB_FIFO_DP        (2),// We add a ping-pong buffer here to cut down the timing path
  .ICB_FIFO_CUT_READY (1),// We configure it to cut down the back-pressure ready signal
  .AW                   (32),
  .DW                   (`E203_XLEN),
  .SPLT_FIFO_OUTS_NUM   (1),// The Mem only allow 1 oustanding
  .SPLT_FIFO_CUT_READY  (1),// The Mem always cut ready
  //  * DM        : 0x0000 0000 -- 0x0000 0FFF
  .O0_BASE_ADDR       (32'h0000_0000),       
  .O0_BASE_REGION_LSB (12),
  //  * MROM      : 0x0000 1000 -- 0x0000 1FFF
  .O1_BASE_ADDR       (32'h0000_1000),       
  .O1_BASE_REGION_LSB (12),
  //  * OTP-RO    : 0x0002 0000 -- 0x0003 FFFF
  .O2_BASE_ADDR       (32'h0002_0000),       
  .O2_BASE_REGION_LSB (17),
  //  * QSPI0-RO  : 0x2000 0000 -- 0x3FFF FFFF
  .O3_BASE_ADDR       (32'h2000_0000),       
  .O3_BASE_REGION_LSB (29),
  //  * SysMem    : 0x8000 0000 -- 0xFFFF FFFF
  //    Actually since the 0xFxxx xxxx have been occupied by FIO, 
  //    sysmem have no chance to access it
  .O4_BASE_ADDR       (32'h8000_0000),       
  .O4_BASE_REGION_LSB (31),

      // * Here is an example AXI Peripheral
  .O5_BASE_ADDR       (32'h4000_0000),       
  .O5_BASE_REGION_LSB (28),
  
      // Not used
  .O6_BASE_ADDR       (32'h0000_0000),       
  .O6_BASE_REGION_LSB (0),
  
      // Not used
  .O7_BASE_ADDR       (32'h0000_0000),       
  .O7_BASE_REGION_LSB (0)

  )u_sirv_mem_fab(

    .i_icb_cmd_valid  (mem_icb_cmd_valid),
    .i_icb_cmd_ready  (mem_icb_cmd_ready),
    .i_icb_cmd_addr   (mem_icb_cmd_addr ),
    .i_icb_cmd_read   (mem_icb_cmd_read ),
    .i_icb_cmd_wdata  (mem_icb_cmd_wdata),
    .i_icb_cmd_wmask  (mem_icb_cmd_wmask),
    .i_icb_cmd_lock   (1'b0 ),
    .i_icb_cmd_excl   (1'b0 ),
    .i_icb_cmd_size   (2'b0 ),
    .i_icb_cmd_burst  (2'b0),
    .i_icb_cmd_beat   (2'b0 ),
    
    .i_icb_rsp_valid  (mem_icb_rsp_valid),
    .i_icb_rsp_ready  (mem_icb_rsp_ready),
    .i_icb_rsp_err    (mem_icb_rsp_err  ),
    .i_icb_rsp_excl_ok(),
    .i_icb_rsp_rdata  (mem_icb_rsp_rdata),
    
  //  * DM
    .o0_icb_enable     (1'b1),

    .o0_icb_cmd_valid  (dm_icb_cmd_valid),
    .o0_icb_cmd_ready  (dm_icb_cmd_ready),
    .o0_icb_cmd_addr   (dm_icb_cmd_addr ),
    .o0_icb_cmd_read   (dm_icb_cmd_read ),
    .o0_icb_cmd_wdata  (dm_icb_cmd_wdata),
    .o0_icb_cmd_wmask  (),
    .o0_icb_cmd_lock   (),
    .o0_icb_cmd_excl   (),
    .o0_icb_cmd_size   (),
    .o0_icb_cmd_burst  (),
    .o0_icb_cmd_beat   (),
    
    .o0_icb_rsp_valid  (dm_icb_rsp_valid),
    .o0_icb_rsp_ready  (dm_icb_rsp_ready),
    .o0_icb_rsp_err    (1'b0),
    .o0_icb_rsp_excl_ok(1'b0),
    .o0_icb_rsp_rdata  (dm_icb_rsp_rdata),

  //  * MROM      
    .o1_icb_enable     (1'b1),

    .o1_icb_cmd_valid  (mrom_icb_cmd_valid),
    .o1_icb_cmd_ready  (mrom_icb_cmd_ready),
    .o1_icb_cmd_addr   (mrom_icb_cmd_addr ),
    .o1_icb_cmd_read   (mrom_icb_cmd_read ),
    .o1_icb_cmd_wdata  (),
    .o1_icb_cmd_wmask  (),
    .o1_icb_cmd_lock   (),
    .o1_icb_cmd_excl   (),
    .o1_icb_cmd_size   (),
    .o1_icb_cmd_burst  (),
    .o1_icb_cmd_beat   (),
    
    .o1_icb_rsp_valid  (mrom_icb_rsp_valid),
    .o1_icb_rsp_ready  (mrom_icb_rsp_ready),
    .o1_icb_rsp_err    (mrom_icb_rsp_err),
    .o1_icb_rsp_excl_ok(1'b0  ),
    .o1_icb_rsp_rdata  (mrom_icb_rsp_rdata),

  //  * OTP-RO    
    .o2_icb_enable     (1'b1),

    .o2_icb_cmd_valid  (otp_ro_icb_cmd_valid),
    .o2_icb_cmd_ready  (otp_ro_icb_cmd_ready),
    .o2_icb_cmd_addr   (otp_ro_icb_cmd_addr ),
    .o2_icb_cmd_read   (otp_ro_icb_cmd_read ),
    .o2_icb_cmd_wdata  (otp_ro_icb_cmd_wdata),
    .o2_icb_cmd_wmask  (),
    .o2_icb_cmd_lock   (),
    .o2_icb_cmd_excl   (),
    .o2_icb_cmd_size   (),
    .o2_icb_cmd_burst  (),
    .o2_icb_cmd_beat   (),
    
    .o2_icb_rsp_valid  (otp_ro_icb_rsp_valid),
    .o2_icb_rsp_ready  (otp_ro_icb_rsp_ready),
    .o2_icb_rsp_err    (otp_ro_icb_rsp_err),
    .o2_icb_rsp_excl_ok(1'b0  ),
    .o2_icb_rsp_rdata  (otp_ro_icb_rsp_rdata),


  //  * QSPI0-RO  
    .o3_icb_enable     (1'b1),

    .o3_icb_cmd_valid  (qspi0_ro_icb_cmd_valid),
    .o3_icb_cmd_ready  (qspi0_ro_icb_cmd_ready),
    .o3_icb_cmd_addr   (qspi0_ro_icb_cmd_addr ),
    .o3_icb_cmd_read   (qspi0_ro_icb_cmd_read ),
    .o3_icb_cmd_wdata  (qspi0_ro_icb_cmd_wdata),
    .o3_icb_cmd_wmask  (),
    .o3_icb_cmd_lock   (),
    .o3_icb_cmd_excl   (),
    .o3_icb_cmd_size   (),
    .o3_icb_cmd_burst  (),
    .o3_icb_cmd_beat   (),
    
    .o3_icb_rsp_valid  (qspi0_ro_icb_rsp_valid),
    .o3_icb_rsp_ready  (qspi0_ro_icb_rsp_ready),
    .o3_icb_rsp_err    (qspi0_ro_icb_rsp_err),
    .o3_icb_rsp_excl_ok(1'b0  ),
    .o3_icb_rsp_rdata  (qspi0_ro_icb_rsp_rdata),


  //  * SysMem
    .o4_icb_enable     (1'b1),

    .o4_icb_cmd_valid  (sysmem_icb_cmd_valid),
    .o4_icb_cmd_ready  (sysmem_icb_cmd_ready),
    .o4_icb_cmd_addr   (sysmem_icb_cmd_addr ),
    .o4_icb_cmd_read   (sysmem_icb_cmd_read ),
    .o4_icb_cmd_wdata  (sysmem_icb_cmd_wdata),
    .o4_icb_cmd_wmask  (sysmem_icb_cmd_wmask),
    .o4_icb_cmd_lock   (),
    .o4_icb_cmd_excl   (),
    .o4_icb_cmd_size   (),
    .o4_icb_cmd_burst  (),
    .o4_icb_cmd_beat   (),
    
    .o4_icb_rsp_valid  (sysmem_icb_rsp_valid),
    .o4_icb_rsp_ready  (sysmem_icb_rsp_ready),
    .o4_icb_rsp_err    (sysmem_icb_rsp_err    ),
    .o4_icb_rsp_excl_ok(1'b0),
    .o4_icb_rsp_rdata  (sysmem_icb_rsp_rdata),

   //  * Example AXI    
    .o5_icb_enable     (1'b1),

    .o5_icb_cmd_valid  (expl_axi_icb_cmd_valid),
    .o5_icb_cmd_ready  (expl_axi_icb_cmd_ready),
    .o5_icb_cmd_addr   (expl_axi_icb_cmd_addr ),
    .o5_icb_cmd_read   (expl_axi_icb_cmd_read ),
    .o5_icb_cmd_wdata  (expl_axi_icb_cmd_wdata),
    .o5_icb_cmd_wmask  (expl_axi_icb_cmd_wmask),
    .o5_icb_cmd_lock   (),
    .o5_icb_cmd_excl   (),
    .o5_icb_cmd_size   (),
    .o5_icb_cmd_burst  (),
    .o5_icb_cmd_beat   (),
    
    .o5_icb_rsp_valid  (expl_axi_icb_rsp_valid),
    .o5_icb_rsp_ready  (expl_axi_icb_rsp_ready),
    .o5_icb_rsp_err    (expl_axi_icb_rsp_err),
    .o5_icb_rsp_excl_ok(1'b0  ),
    .o5_icb_rsp_rdata  (expl_axi_icb_rsp_rdata),


        //  * Not used
    .o6_icb_enable     (1'b0),

    .o6_icb_cmd_valid  (),
    .o6_icb_cmd_ready  (1'b0),
    .o6_icb_cmd_addr   (),
    .o6_icb_cmd_read   (),
    .o6_icb_cmd_wdata  (),
    .o6_icb_cmd_wmask  (),
    .o6_icb_cmd_lock   (),
    .o6_icb_cmd_excl   (),
    .o6_icb_cmd_size   (),
    .o6_icb_cmd_burst  (),
    .o6_icb_cmd_beat   (),
    
    .o6_icb_rsp_valid  (1'b0),
    .o6_icb_rsp_ready  (),
    .o6_icb_rsp_err    (1'b0  ),
    .o6_icb_rsp_excl_ok(1'b0  ),
    .o6_icb_rsp_rdata  (`E203_XLEN'b0),

        //  * Not used
    .o7_icb_enable     (1'b0),

    .o7_icb_cmd_valid  (),
    .o7_icb_cmd_ready  (1'b0),
    .o7_icb_cmd_addr   (),
    .o7_icb_cmd_read   (),
    .o7_icb_cmd_wdata  (),
    .o7_icb_cmd_wmask  (),
    .o7_icb_cmd_lock   (),
    .o7_icb_cmd_excl   (),
    .o7_icb_cmd_size   (),
    .o7_icb_cmd_burst  (),
    .o7_icb_cmd_beat   (),
    
    .o7_icb_rsp_valid  (1'b0),
    .o7_icb_rsp_ready  (),
    .o7_icb_rsp_err    (1'b0  ),
    .o7_icb_rsp_excl_ok(1'b0  ),
    .o7_icb_rsp_rdata  (`E203_XLEN'b0),

    .clk           (clk  ),
    .rst_n         (bus_rst_n) 
  );

  sirv_mrom_top #(
    .AW(MROM_AW),
    .DW(32),
    .DP(MROM_DP)
  )u_sirv_mrom_top(

    .rom_icb_cmd_valid  (mrom_icb_cmd_valid),
    .rom_icb_cmd_ready  (mrom_icb_cmd_ready),
    .rom_icb_cmd_addr   (mrom_icb_cmd_addr [MROM_AW-1:0]),
    .rom_icb_cmd_read   (mrom_icb_cmd_read ),
    
    .rom_icb_rsp_valid  (mrom_icb_rsp_valid),
    .rom_icb_rsp_ready  (mrom_icb_rsp_ready),
    .rom_icb_rsp_err    (mrom_icb_rsp_err  ),
    .rom_icb_rsp_rdata  (mrom_icb_rsp_rdata),

    .clk           (clk  ),
    .rst_n         (rst_n) 
  );

      // * Here is an example AXI Peripheral
  wire expl_axi_arvalid;
  wire expl_axi_arready;
  wire [`E203_ADDR_SIZE-1:0] expl_axi_araddr;
  wire [3:0] expl_axi_arcache;
  wire [2:0] expl_axi_arprot;
  wire [1:0] expl_axi_arlock;
  wire [1:0] expl_axi_arburst;
  wire [3:0] expl_axi_arlen;
  wire [2:0] expl_axi_arsize;

  wire expl_axi_awvalid;
  wire expl_axi_awready;
  wire [`E203_ADDR_SIZE-1:0] expl_axi_awaddr;
  wire [3:0] expl_axi_awcache;
  wire [2:0] expl_axi_awprot;
  wire [1:0] expl_axi_awlock;
  wire [1:0] expl_axi_awburst;
  wire [3:0] expl_axi_awlen;
  wire [2:0] expl_axi_awsize;

  wire expl_axi_rvalid;
  wire expl_axi_rready;
  wire [`E203_XLEN-1:0] expl_axi_rdata;
  wire [1:0] expl_axi_rresp;
  wire expl_axi_rlast;

  wire expl_axi_wvalid;
  wire expl_axi_wready;
  wire [`E203_XLEN-1:0] expl_axi_wdata;
  wire [(`E203_XLEN/8)-1:0] expl_axi_wstrb;
  wire expl_axi_wlast;

  wire expl_axi_bvalid;
  wire expl_axi_bready;
  wire [1:0] expl_axi_bresp;
   
sirv_gnrl_icb2axi # (
  .AXI_FIFO_DP (2), // We just add ping-pong buffer here to avoid any potential timing loops
                    //   User can change it to 0 if dont care
  .AXI_FIFO_CUT_READY (1), // This is to cut the back-pressure signal if you set as 1
  .AW   (32),
  .FIFO_OUTS_NUM (4),// We only allow 4 oustandings at most for mem, user can configure it to any value
  .FIFO_CUT_READY(1),
  .DW   (`E203_XLEN) 
) u_expl_axi_icb2axi(
    .i_icb_cmd_valid (expl_axi_icb_cmd_valid),
    .i_icb_cmd_ready (expl_axi_icb_cmd_ready),
    .i_icb_cmd_addr  (expl_axi_icb_cmd_addr ),
    .i_icb_cmd_read  (expl_axi_icb_cmd_read ),
    .i_icb_cmd_wdata (expl_axi_icb_cmd_wdata),
    .i_icb_cmd_wmask (expl_axi_icb_cmd_wmask),
    .i_icb_cmd_size  (),
    
    .i_icb_rsp_valid (expl_axi_icb_rsp_valid),
    .i_icb_rsp_ready (expl_axi_icb_rsp_ready),
    .i_icb_rsp_rdata (expl_axi_icb_rsp_rdata),
    .i_icb_rsp_err   (expl_axi_icb_rsp_err),

    .o_axi_arvalid   (expl_axi_arvalid),
    .o_axi_arready   (expl_axi_arready),
    .o_axi_araddr    (expl_axi_araddr ),
    .o_axi_arcache   (expl_axi_arcache),
    .o_axi_arprot    (expl_axi_arprot ),
    .o_axi_arlock    (expl_axi_arlock ),
    .o_axi_arburst   (expl_axi_arburst),
    .o_axi_arlen     (expl_axi_arlen  ),
    .o_axi_arsize    (expl_axi_arsize ),
                      
    .o_axi_awvalid   (expl_axi_awvalid),
    .o_axi_awready   (expl_axi_awready),
    .o_axi_awaddr    (expl_axi_awaddr ),
    .o_axi_awcache   (expl_axi_awcache),
    .o_axi_awprot    (expl_axi_awprot ),
    .o_axi_awlock    (expl_axi_awlock ),
    .o_axi_awburst   (expl_axi_awburst),
    .o_axi_awlen     (expl_axi_awlen  ),
    .o_axi_awsize    (expl_axi_awsize ),
                     
    .o_axi_rvalid    (expl_axi_rvalid ),
    .o_axi_rready    (expl_axi_rready ),
    .o_axi_rdata     (expl_axi_rdata  ),
    .o_axi_rresp     (expl_axi_rresp  ),
    .o_axi_rlast     (expl_axi_rlast  ),
                    
    .o_axi_wvalid    (expl_axi_wvalid ),
    .o_axi_wready    (expl_axi_wready ),
    .o_axi_wdata     (expl_axi_wdata  ),
    .o_axi_wstrb     (expl_axi_wstrb  ),
    .o_axi_wlast     (expl_axi_wlast  ),
                   
    .o_axi_bvalid    (expl_axi_bvalid ),
    .o_axi_bready    (expl_axi_bready ),
    .o_axi_bresp     (expl_axi_bresp  ),

    .clk           (clk  ),
    .rst_n         (bus_rst_n) 
  );

sirv_expl_axi_slv # (
  .AW   (32),
  .DW   (`E203_XLEN) 
) u_perips_expl_axi_slv (
    .axi_arvalid   (expl_axi_arvalid),
    .axi_arready   (expl_axi_arready),
    .axi_araddr    (expl_axi_araddr ),
    .axi_arcache   (expl_axi_arcache),
    .axi_arprot    (expl_axi_arprot ),
    .axi_arlock    (expl_axi_arlock ),
    .axi_arburst   (expl_axi_arburst),
    .axi_arlen     (expl_axi_arlen  ),
    .axi_arsize    (expl_axi_arsize ),

    .axi_awvalid   (expl_axi_awvalid),
    .axi_awready   (expl_axi_awready),
    .axi_awaddr    (expl_axi_awaddr ),
    .axi_awcache   (expl_axi_awcache),
    .axi_awprot    (expl_axi_awprot ),
    .axi_awlock    (expl_axi_awlock ),
    .axi_awburst   (expl_axi_awburst),
    .axi_awlen     (expl_axi_awlen  ),
    .axi_awsize    (expl_axi_awsize ),
  
    .axi_rvalid    (expl_axi_rvalid ),
    .axi_rready    (expl_axi_rready ),
    .axi_rdata     (expl_axi_rdata  ),
    .axi_rresp     (expl_axi_rresp  ),
    .axi_rlast     (expl_axi_rlast  ),

    .axi_wvalid    (expl_axi_wvalid ),
    .axi_wready    (expl_axi_wready ),
    .axi_wdata     (expl_axi_wdata  ),
    .axi_wstrb     (expl_axi_wstrb  ),
    .axi_wlast     (expl_axi_wlast  ),
 
    .axi_bvalid    (expl_axi_bvalid ),
    .axi_bready    (expl_axi_bready ),
    .axi_bresp     (expl_axi_bresp  ),

    .clk           (clk  ),
    .rst_n         (rst_n) 
  );


endmodule
