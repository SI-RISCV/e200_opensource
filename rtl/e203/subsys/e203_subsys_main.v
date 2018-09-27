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
//  The Subsystem-TOP module to implement CPU and some closely coupled devices
//
// ====================================================================


`include "e203_defines.v"


module e203_subsys_main(
  output core_csr_clk,

  output hfxoscen,// The signal to enable the crystal pad generated clock

  output inspect_pc_29b       ,
  output inspect_dbg_irq      ,

  input  inspect_mode, 
  input  inspect_por_rst, 
  input  inspect_32k_clk, 
  input  inspect_jtag_clk,

  input  [`E203_PC_SIZE-1:0] pc_rtvec,
  ///////////////////////////////////////
  // With the interface to debug module 
  //
    // The interface with commit stage
  output  [`E203_PC_SIZE-1:0] cmt_dpc,
  output  cmt_dpc_ena,

  output  [3-1:0] cmt_dcause,
  output  cmt_dcause_ena,

  input   dbg_irq_a,
  output  dbg_irq_r,

    // The interface with CSR control 
  output  wr_dcsr_ena    ,
  output  wr_dpc_ena     ,
  output  wr_dscratch_ena,



  output  [32-1:0] wr_csr_nxt    ,

  input  [32-1:0] dcsr_r    ,
  input  [`E203_PC_SIZE-1:0] dpc_r     ,
  input  [32-1:0] dscratch_r,

  input  dbg_mode,
  input  dbg_halt_r,
  input  dbg_step_r,
  input  dbg_ebreakm_r,
  input  dbg_stopcycle,


  ///////////////////////////////////////
  input  [`E203_HART_ID_W-1:0] core_mhartid,  
    
  input  aon_wdg_irq_a,
  input  aon_rtc_irq_a,
  input  aon_rtcToggle_a,

  output                         aon_icb_cmd_valid,
  input                          aon_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   aon_icb_cmd_addr, 
  output                         aon_icb_cmd_read, 
  output [`E203_XLEN-1:0]        aon_icb_cmd_wdata,
  //
  input                          aon_icb_rsp_valid,
  output                         aon_icb_rsp_ready,
  input                          aon_icb_rsp_err,
  input  [`E203_XLEN-1:0]        aon_icb_rsp_rdata,

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

  input  io_pads_gpio_0_i_ival,
  output io_pads_gpio_0_o_oval,
  output io_pads_gpio_0_o_oe,
  output io_pads_gpio_0_o_ie,
  output io_pads_gpio_0_o_pue,
  output io_pads_gpio_0_o_ds,
  input  io_pads_gpio_1_i_ival,
  output io_pads_gpio_1_o_oval,
  output io_pads_gpio_1_o_oe,
  output io_pads_gpio_1_o_ie,
  output io_pads_gpio_1_o_pue,
  output io_pads_gpio_1_o_ds,
  input  io_pads_gpio_2_i_ival,
  output io_pads_gpio_2_o_oval,
  output io_pads_gpio_2_o_oe,
  output io_pads_gpio_2_o_ie,
  output io_pads_gpio_2_o_pue,
  output io_pads_gpio_2_o_ds,
  input  io_pads_gpio_3_i_ival,
  output io_pads_gpio_3_o_oval,
  output io_pads_gpio_3_o_oe,
  output io_pads_gpio_3_o_ie,
  output io_pads_gpio_3_o_pue,
  output io_pads_gpio_3_o_ds,
  input  io_pads_gpio_4_i_ival,
  output io_pads_gpio_4_o_oval,
  output io_pads_gpio_4_o_oe,
  output io_pads_gpio_4_o_ie,
  output io_pads_gpio_4_o_pue,
  output io_pads_gpio_4_o_ds,
  input  io_pads_gpio_5_i_ival,
  output io_pads_gpio_5_o_oval,
  output io_pads_gpio_5_o_oe,
  output io_pads_gpio_5_o_ie,
  output io_pads_gpio_5_o_pue,
  output io_pads_gpio_5_o_ds,
  input  io_pads_gpio_6_i_ival,
  output io_pads_gpio_6_o_oval,
  output io_pads_gpio_6_o_oe,
  output io_pads_gpio_6_o_ie,
  output io_pads_gpio_6_o_pue,
  output io_pads_gpio_6_o_ds,
  input  io_pads_gpio_7_i_ival,
  output io_pads_gpio_7_o_oval,
  output io_pads_gpio_7_o_oe,
  output io_pads_gpio_7_o_ie,
  output io_pads_gpio_7_o_pue,
  output io_pads_gpio_7_o_ds,
  input  io_pads_gpio_8_i_ival,
  output io_pads_gpio_8_o_oval,
  output io_pads_gpio_8_o_oe,
  output io_pads_gpio_8_o_ie,
  output io_pads_gpio_8_o_pue,
  output io_pads_gpio_8_o_ds,
  input  io_pads_gpio_9_i_ival,
  output io_pads_gpio_9_o_oval,
  output io_pads_gpio_9_o_oe,
  output io_pads_gpio_9_o_ie,
  output io_pads_gpio_9_o_pue,
  output io_pads_gpio_9_o_ds,
  input  io_pads_gpio_10_i_ival,
  output io_pads_gpio_10_o_oval,
  output io_pads_gpio_10_o_oe,
  output io_pads_gpio_10_o_ie,
  output io_pads_gpio_10_o_pue,
  output io_pads_gpio_10_o_ds,
  input  io_pads_gpio_11_i_ival,
  output io_pads_gpio_11_o_oval,
  output io_pads_gpio_11_o_oe,
  output io_pads_gpio_11_o_ie,
  output io_pads_gpio_11_o_pue,
  output io_pads_gpio_11_o_ds,
  input  io_pads_gpio_12_i_ival,
  output io_pads_gpio_12_o_oval,
  output io_pads_gpio_12_o_oe,
  output io_pads_gpio_12_o_ie,
  output io_pads_gpio_12_o_pue,
  output io_pads_gpio_12_o_ds,
  input  io_pads_gpio_13_i_ival,
  output io_pads_gpio_13_o_oval,
  output io_pads_gpio_13_o_oe,
  output io_pads_gpio_13_o_ie,
  output io_pads_gpio_13_o_pue,
  output io_pads_gpio_13_o_ds,
  input  io_pads_gpio_14_i_ival,
  output io_pads_gpio_14_o_oval,
  output io_pads_gpio_14_o_oe,
  output io_pads_gpio_14_o_ie,
  output io_pads_gpio_14_o_pue,
  output io_pads_gpio_14_o_ds,
  input  io_pads_gpio_15_i_ival,
  output io_pads_gpio_15_o_oval,
  output io_pads_gpio_15_o_oe,
  output io_pads_gpio_15_o_ie,
  output io_pads_gpio_15_o_pue,
  output io_pads_gpio_15_o_ds,
  input  io_pads_gpio_16_i_ival,
  output io_pads_gpio_16_o_oval,
  output io_pads_gpio_16_o_oe,
  output io_pads_gpio_16_o_ie,
  output io_pads_gpio_16_o_pue,
  output io_pads_gpio_16_o_ds,
  input  io_pads_gpio_17_i_ival,
  output io_pads_gpio_17_o_oval,
  output io_pads_gpio_17_o_oe,
  output io_pads_gpio_17_o_ie,
  output io_pads_gpio_17_o_pue,
  output io_pads_gpio_17_o_ds,
  input  io_pads_gpio_18_i_ival,
  output io_pads_gpio_18_o_oval,
  output io_pads_gpio_18_o_oe,
  output io_pads_gpio_18_o_ie,
  output io_pads_gpio_18_o_pue,
  output io_pads_gpio_18_o_ds,
  input  io_pads_gpio_19_i_ival,
  output io_pads_gpio_19_o_oval,
  output io_pads_gpio_19_o_oe,
  output io_pads_gpio_19_o_ie,
  output io_pads_gpio_19_o_pue,
  output io_pads_gpio_19_o_ds,
  input  io_pads_gpio_20_i_ival,
  output io_pads_gpio_20_o_oval,
  output io_pads_gpio_20_o_oe,
  output io_pads_gpio_20_o_ie,
  output io_pads_gpio_20_o_pue,
  output io_pads_gpio_20_o_ds,
  input  io_pads_gpio_21_i_ival,
  output io_pads_gpio_21_o_oval,
  output io_pads_gpio_21_o_oe,
  output io_pads_gpio_21_o_ie,
  output io_pads_gpio_21_o_pue,
  output io_pads_gpio_21_o_ds,
  input  io_pads_gpio_22_i_ival,
  output io_pads_gpio_22_o_oval,
  output io_pads_gpio_22_o_oe,
  output io_pads_gpio_22_o_ie,
  output io_pads_gpio_22_o_pue,
  output io_pads_gpio_22_o_ds,
  input  io_pads_gpio_23_i_ival,
  output io_pads_gpio_23_o_oval,
  output io_pads_gpio_23_o_oe,
  output io_pads_gpio_23_o_ie,
  output io_pads_gpio_23_o_pue,
  output io_pads_gpio_23_o_ds,
  input  io_pads_gpio_24_i_ival,
  output io_pads_gpio_24_o_oval,
  output io_pads_gpio_24_o_oe,
  output io_pads_gpio_24_o_ie,
  output io_pads_gpio_24_o_pue,
  output io_pads_gpio_24_o_ds,
  input  io_pads_gpio_25_i_ival,
  output io_pads_gpio_25_o_oval,
  output io_pads_gpio_25_o_oe,
  output io_pads_gpio_25_o_ie,
  output io_pads_gpio_25_o_pue,
  output io_pads_gpio_25_o_ds,
  input  io_pads_gpio_26_i_ival,
  output io_pads_gpio_26_o_oval,
  output io_pads_gpio_26_o_oe,
  output io_pads_gpio_26_o_ie,
  output io_pads_gpio_26_o_pue,
  output io_pads_gpio_26_o_ds,
  input  io_pads_gpio_27_i_ival,
  output io_pads_gpio_27_o_oval,
  output io_pads_gpio_27_o_oe,
  output io_pads_gpio_27_o_ie,
  output io_pads_gpio_27_o_pue,
  output io_pads_gpio_27_o_ds,
  input  io_pads_gpio_28_i_ival,
  output io_pads_gpio_28_o_oval,
  output io_pads_gpio_28_o_oe,
  output io_pads_gpio_28_o_ie,
  output io_pads_gpio_28_o_pue,
  output io_pads_gpio_28_o_ds,
  input  io_pads_gpio_29_i_ival,
  output io_pads_gpio_29_o_oval,
  output io_pads_gpio_29_o_oe,
  output io_pads_gpio_29_o_ie,
  output io_pads_gpio_29_o_pue,
  output io_pads_gpio_29_o_ds,
  input  io_pads_gpio_30_i_ival,
  output io_pads_gpio_30_o_oval,
  output io_pads_gpio_30_o_oe,
  output io_pads_gpio_30_o_ie,
  output io_pads_gpio_30_o_pue,
  output io_pads_gpio_30_o_ds,
  input  io_pads_gpio_31_i_ival,
  output io_pads_gpio_31_o_oval,
  output io_pads_gpio_31_o_oe,
  output io_pads_gpio_31_o_ie,
  output io_pads_gpio_31_o_pue,
  output io_pads_gpio_31_o_ds,

  input   io_pads_qspi_sck_i_ival,
  output  io_pads_qspi_sck_o_oval,
  output  io_pads_qspi_sck_o_oe,
  output  io_pads_qspi_sck_o_ie,
  output  io_pads_qspi_sck_o_pue,
  output  io_pads_qspi_sck_o_ds,
  input   io_pads_qspi_dq_0_i_ival,
  output  io_pads_qspi_dq_0_o_oval,
  output  io_pads_qspi_dq_0_o_oe,
  output  io_pads_qspi_dq_0_o_ie,
  output  io_pads_qspi_dq_0_o_pue,
  output  io_pads_qspi_dq_0_o_ds,
  input   io_pads_qspi_dq_1_i_ival,
  output  io_pads_qspi_dq_1_o_oval,
  output  io_pads_qspi_dq_1_o_oe,
  output  io_pads_qspi_dq_1_o_ie,
  output  io_pads_qspi_dq_1_o_pue,
  output  io_pads_qspi_dq_1_o_ds,
  input   io_pads_qspi_dq_2_i_ival,
  output  io_pads_qspi_dq_2_o_oval,
  output  io_pads_qspi_dq_2_o_oe,
  output  io_pads_qspi_dq_2_o_ie,
  output  io_pads_qspi_dq_2_o_pue,
  output  io_pads_qspi_dq_2_o_ds,
  input   io_pads_qspi_dq_3_i_ival,
  output  io_pads_qspi_dq_3_o_oval,
  output  io_pads_qspi_dq_3_o_oe,
  output  io_pads_qspi_dq_3_o_ie,
  output  io_pads_qspi_dq_3_o_pue,
  output  io_pads_qspi_dq_3_o_ds,
  input   io_pads_qspi_cs_0_i_ival,
  output  io_pads_qspi_cs_0_o_oval,
  output  io_pads_qspi_cs_0_o_oe,
  output  io_pads_qspi_cs_0_o_ie,
  output  io_pads_qspi_cs_0_o_pue,
  output  io_pads_qspi_cs_0_o_ds,

  `ifdef E203_HAS_ITCM_EXTITF //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // External-agent ICB to ITCM
  //    * Bus cmd channel
  input                          ext2itcm_icb_cmd_valid,
  output                         ext2itcm_icb_cmd_ready,
  input  [`E203_ITCM_ADDR_WIDTH-1:0]   ext2itcm_icb_cmd_addr, 
  input                          ext2itcm_icb_cmd_read, 
  input  [`E203_XLEN-1:0]        ext2itcm_icb_cmd_wdata,
  input  [`E203_XLEN/8-1:0]      ext2itcm_icb_cmd_wmask,
  //
  //    * Bus RSP channel
  output                         ext2itcm_icb_rsp_valid,
  input                          ext2itcm_icb_rsp_ready,
  output                         ext2itcm_icb_rsp_err  ,
  output [`E203_XLEN-1:0]        ext2itcm_icb_rsp_rdata,
  `endif//}

  `ifdef E203_HAS_DTCM_EXTITF //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // External-agent ICB to DTCM
  //    * Bus cmd channel
  input                          ext2dtcm_icb_cmd_valid,
  output                         ext2dtcm_icb_cmd_ready,
  input  [`E203_DTCM_ADDR_WIDTH-1:0]   ext2dtcm_icb_cmd_addr, 
  input                          ext2dtcm_icb_cmd_read, 
  input  [`E203_XLEN-1:0]        ext2dtcm_icb_cmd_wdata,
  input  [`E203_XLEN/8-1:0]      ext2dtcm_icb_cmd_wmask,
  //
  //    * Bus RSP channel
  output                         ext2dtcm_icb_rsp_valid,
  input                          ext2dtcm_icb_rsp_ready,
  output                         ext2dtcm_icb_rsp_err  ,
  output [`E203_XLEN-1:0]        ext2dtcm_icb_rsp_rdata,
  `endif//}

  
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to Private Peripheral Interface
  //
  //    * Bus cmd channel
  output                         sysper_icb_cmd_valid,
  input                          sysper_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   sysper_icb_cmd_addr, 
  output                         sysper_icb_cmd_read, 
  output [`E203_XLEN-1:0]        sysper_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      sysper_icb_cmd_wmask,
  //
  //    * Bus RSP channel
  input                          sysper_icb_rsp_valid,
  output                         sysper_icb_rsp_ready,
  input                          sysper_icb_rsp_err  ,
  input  [`E203_XLEN-1:0]        sysper_icb_rsp_rdata,

  `ifdef E203_HAS_FIO //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to Fast I/O
  //
  //    * Bus cmd channel
  output                         sysfio_icb_cmd_valid,
  input                          sysfio_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   sysfio_icb_cmd_addr, 
  output                         sysfio_icb_cmd_read, 
  output [`E203_XLEN-1:0]        sysfio_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      sysfio_icb_cmd_wmask,
  //
  //    * Bus RSP channel
  input                          sysfio_icb_rsp_valid,
  output                         sysfio_icb_rsp_ready,
  input                          sysfio_icb_rsp_err  ,
  input  [`E203_XLEN-1:0]        sysfio_icb_rsp_rdata,
  `endif//}

  `ifdef E203_HAS_MEM_ITF //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface from Ifetch 
  //
  //    * Bus cmd channel
  output                         sysmem_icb_cmd_valid,
  input                          sysmem_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   sysmem_icb_cmd_addr, 
  output                         sysmem_icb_cmd_read, 
  output [`E203_XLEN-1:0]        sysmem_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      sysmem_icb_cmd_wmask,
  //
  //    * Bus RSP channel
  input                          sysmem_icb_rsp_valid,
  output                         sysmem_icb_rsp_ready,
  input                          sysmem_icb_rsp_err  ,
  input  [`E203_XLEN-1:0]        sysmem_icb_rsp_rdata,
  `endif//}

  input  test_mode,

  input  corerst, // The original async reset
  input  hfclkrst, // The original async reset
  input  hfextclk,// The original clock from crystal
  output hfclk // The generated clock by HCLKGEN

  );

 wire [31:0] inspect_pc;
 wire inspect_mem_cmd_valid;
 wire inspect_mem_cmd_ready;
 wire inspect_mem_rsp_valid;
 wire inspect_mem_rsp_ready;
 wire inspect_core_clk;
 wire inspect_pll_clk;
 wire inspect_16m_clk;

 assign inspect_pc_29b = inspect_pc[29];

 wire  gpio_0_o_oval ;
 wire  gpio_0_o_oe   ;
 wire  gpio_0_o_ie   ;
 wire  gpio_0_o_pue  ;
 wire  gpio_0_o_ds   ;
 wire  gpio_1_o_oval ;
 wire  gpio_1_o_oe   ;
 wire  gpio_1_o_ie   ;
 wire  gpio_1_o_pue  ;
 wire  gpio_1_o_ds   ;
 wire  gpio_2_o_oval ;
 wire  gpio_2_o_oe   ;
 wire  gpio_2_o_ie   ;
 wire  gpio_2_o_pue  ;
 wire  gpio_2_o_ds   ;
 wire  gpio_3_o_oval ;
 wire  gpio_3_o_oe   ;
 wire  gpio_3_o_ie   ;
 wire  gpio_3_o_pue  ;
 wire  gpio_3_o_ds   ;
 wire  gpio_4_o_oval ;
 wire  gpio_4_o_oe   ;
 wire  gpio_4_o_ie   ;
 wire  gpio_4_o_pue  ;
 wire  gpio_4_o_ds   ;
 wire  gpio_5_o_oval ;
 wire  gpio_5_o_oe   ;
 wire  gpio_5_o_ie   ;
 wire  gpio_5_o_pue  ;
 wire  gpio_5_o_ds   ;
 wire  gpio_6_o_oval ;
 wire  gpio_6_o_oe   ;
 wire  gpio_6_o_ie   ;
 wire  gpio_6_o_pue  ;
 wire  gpio_6_o_ds   ;
 wire  gpio_7_o_oval ;
 wire  gpio_7_o_oe   ;
 wire  gpio_7_o_ie   ;
 wire  gpio_7_o_pue  ;
 wire  gpio_7_o_ds   ;
 wire  gpio_8_o_oval ;
 wire  gpio_8_o_oe   ;
 wire  gpio_8_o_ie   ;
 wire  gpio_8_o_pue  ;
 wire  gpio_8_o_ds   ;
 wire  gpio_9_o_oval ;
 wire  gpio_9_o_oe   ;
 wire  gpio_9_o_ie   ;
 wire  gpio_9_o_pue  ;
 wire  gpio_9_o_ds   ;
 wire  gpio_10_o_oval;
 wire  gpio_10_o_oe  ;
 wire  gpio_10_o_ie  ;
 wire  gpio_10_o_pue ;
 wire  gpio_10_o_ds  ;
 wire  gpio_11_o_oval;
 wire  gpio_11_o_oe  ;
 wire  gpio_11_o_ie  ;
 wire  gpio_11_o_pue ;
 wire  gpio_11_o_ds  ;
 wire  gpio_12_o_oval;
 wire  gpio_12_o_oe  ;
 wire  gpio_12_o_ie  ;
 wire  gpio_12_o_pue ;
 wire  gpio_12_o_ds  ;
 wire  gpio_13_o_oval;
 wire  gpio_13_o_oe  ;
 wire  gpio_13_o_ie  ;
 wire  gpio_13_o_pue ;
 wire  gpio_13_o_ds  ;
 wire  gpio_14_o_oval;
 wire  gpio_14_o_oe  ;
 wire  gpio_14_o_ie  ;
 wire  gpio_14_o_pue ;
 wire  gpio_14_o_ds  ;
 wire  gpio_15_o_oval;
 wire  gpio_15_o_oe  ;
 wire  gpio_15_o_ie  ;
 wire  gpio_15_o_pue ;
 wire  gpio_15_o_ds  ;
 wire  gpio_16_o_oval;
 wire  gpio_16_o_oe  ;
 wire  gpio_16_o_ie  ;
 wire  gpio_16_o_pue ;
 wire  gpio_16_o_ds  ;
 wire  gpio_17_o_oval;
 wire  gpio_17_o_oe  ;
 wire  gpio_17_o_ie  ;
 wire  gpio_17_o_pue ;
 wire  gpio_17_o_ds  ;
 wire  gpio_18_o_oval;
 wire  gpio_18_o_oe  ;
 wire  gpio_18_o_ie  ;
 wire  gpio_18_o_pue ;
 wire  gpio_18_o_ds  ;
 wire  gpio_19_o_oval;
 wire  gpio_19_o_oe  ;
 wire  gpio_19_o_ie  ;
 wire  gpio_19_o_pue ;
 wire  gpio_19_o_ds  ;
 wire  gpio_20_o_oval;
 wire  gpio_20_o_oe  ;
 wire  gpio_20_o_ie  ;
 wire  gpio_20_o_pue ;
 wire  gpio_20_o_ds  ;
 wire  gpio_21_o_oval;
 wire  gpio_21_o_oe  ;
 wire  gpio_21_o_ie  ;
 wire  gpio_21_o_pue ;
 wire  gpio_21_o_ds  ;
 wire  gpio_22_o_oval;
 wire  gpio_22_o_oe  ;
 wire  gpio_22_o_ie  ;
 wire  gpio_22_o_pue ;
 wire  gpio_22_o_ds  ;
 wire  gpio_23_o_oval;
 wire  gpio_23_o_oe  ;
 wire  gpio_23_o_ie  ;
 wire  gpio_23_o_pue ;
 wire  gpio_23_o_ds  ;
 wire  gpio_24_o_oval;
 wire  gpio_24_o_oe  ;
 wire  gpio_24_o_ie  ;
 wire  gpio_24_o_pue ;
 wire  gpio_24_o_ds  ;
 wire  gpio_25_o_oval;
 wire  gpio_25_o_oe  ;
 wire  gpio_25_o_ie  ;
 wire  gpio_25_o_pue ;
 wire  gpio_25_o_ds  ;
 wire  gpio_26_o_oval;
 wire  gpio_26_o_oe  ;
 wire  gpio_26_o_ie  ;
 wire  gpio_26_o_pue ;
 wire  gpio_26_o_ds  ;
 wire  gpio_27_o_oval;
 wire  gpio_27_o_oe  ;
 wire  gpio_27_o_ie  ;
 wire  gpio_27_o_pue ;
 wire  gpio_27_o_ds  ;
 wire  gpio_28_o_oval;
 wire  gpio_28_o_oe  ;
 wire  gpio_28_o_ie  ;
 wire  gpio_28_o_pue ;
 wire  gpio_28_o_ds  ;
 wire  gpio_29_o_oval;
 wire  gpio_29_o_oe  ;
 wire  gpio_29_o_ie  ;
 wire  gpio_29_o_pue ;
 wire  gpio_29_o_ds  ;
 wire  gpio_30_o_oval;
 wire  gpio_30_o_oe  ;
 wire  gpio_30_o_ie  ;
 wire  gpio_30_o_pue ;
 wire  gpio_30_o_ds  ;
 wire  gpio_31_o_oval;
 wire  gpio_31_o_oe  ;
 wire  gpio_31_o_ie  ;
 wire  gpio_31_o_pue ;
 wire  gpio_31_o_ds  ;


    // The GPIO are reused for inspect mode, in which the GPIO
  //   is forced to be an output
 assign  io_pads_gpio_0_o_oval    = inspect_mode ? inspect_pc[0] : gpio_0_o_oval;
 assign  io_pads_gpio_0_o_oe      = inspect_mode ? 1'b1          : gpio_0_o_oe;
 assign  io_pads_gpio_0_o_ie      = inspect_mode ? 1'b0          : gpio_0_o_ie;
 assign  io_pads_gpio_0_o_pue     = inspect_mode ? 1'b0          : gpio_0_o_pue;
 assign  io_pads_gpio_0_o_ds      = inspect_mode ? 1'b1          : gpio_0_o_ds;
 assign  io_pads_gpio_1_o_oval    = inspect_mode ? inspect_pc[1] : gpio_1_o_oval;
 assign  io_pads_gpio_1_o_oe      = inspect_mode ? 1'b1          : gpio_1_o_oe;
 assign  io_pads_gpio_1_o_ie      = inspect_mode ? 1'b0          : gpio_1_o_ie;
 assign  io_pads_gpio_1_o_pue     = inspect_mode ? 1'b0          : gpio_1_o_pue;
 assign  io_pads_gpio_1_o_ds      = inspect_mode ? 1'b1          : gpio_1_o_ds;
 assign  io_pads_gpio_2_o_oval    = inspect_mode ? inspect_pc[2] : gpio_2_o_oval;
 assign  io_pads_gpio_2_o_oe      = inspect_mode ? 1'b1          : gpio_2_o_oe;
 assign  io_pads_gpio_2_o_ie      = inspect_mode ? 1'b0          : gpio_2_o_ie;
 assign  io_pads_gpio_2_o_pue     = inspect_mode ? 1'b0          : gpio_2_o_pue;
 assign  io_pads_gpio_2_o_ds      = inspect_mode ? 1'b1          : gpio_2_o_ds;
 assign  io_pads_gpio_3_o_oval    = inspect_mode ? inspect_pc[3] : gpio_3_o_oval;
 assign  io_pads_gpio_3_o_oe      = inspect_mode ? 1'b1          : gpio_3_o_oe;
 assign  io_pads_gpio_3_o_ie      = inspect_mode ? 1'b0          : gpio_3_o_ie;
 assign  io_pads_gpio_3_o_pue     = inspect_mode ? 1'b0          : gpio_3_o_pue;
 assign  io_pads_gpio_3_o_ds      = inspect_mode ? 1'b1          : gpio_3_o_ds;
 assign  io_pads_gpio_4_o_oval    = inspect_mode ? inspect_pc[4] : gpio_4_o_oval;
 assign  io_pads_gpio_4_o_oe      = inspect_mode ? 1'b1          : gpio_4_o_oe;
 assign  io_pads_gpio_4_o_ie      = inspect_mode ? 1'b0          : gpio_4_o_ie;
 assign  io_pads_gpio_4_o_pue     = inspect_mode ? 1'b0          : gpio_4_o_pue;
 assign  io_pads_gpio_4_o_ds      = inspect_mode ? 1'b1          : gpio_4_o_ds;
 assign  io_pads_gpio_5_o_oval    = inspect_mode ? inspect_pc[5] : gpio_5_o_oval;
 assign  io_pads_gpio_5_o_oe      = inspect_mode ? 1'b1          : gpio_5_o_oe;
 assign  io_pads_gpio_5_o_ie      = inspect_mode ? 1'b0          : gpio_5_o_ie;
 assign  io_pads_gpio_5_o_pue     = inspect_mode ? 1'b0          : gpio_5_o_pue;
 assign  io_pads_gpio_5_o_ds      = inspect_mode ? 1'b1          : gpio_5_o_ds;
 assign  io_pads_gpio_6_o_oval    = inspect_mode ? inspect_pc[6] : gpio_6_o_oval;
 assign  io_pads_gpio_6_o_oe      = inspect_mode ? 1'b1          : gpio_6_o_oe;
 assign  io_pads_gpio_6_o_ie      = inspect_mode ? 1'b0          : gpio_6_o_ie;
 assign  io_pads_gpio_6_o_pue     = inspect_mode ? 1'b0          : gpio_6_o_pue;
 assign  io_pads_gpio_6_o_ds      = inspect_mode ? 1'b1          : gpio_6_o_ds;
 assign  io_pads_gpio_7_o_oval    = inspect_mode ? inspect_pc[7] : gpio_7_o_oval;
 assign  io_pads_gpio_7_o_oe      = inspect_mode ? 1'b1          : gpio_7_o_oe;
 assign  io_pads_gpio_7_o_ie      = inspect_mode ? 1'b0          : gpio_7_o_ie;
 assign  io_pads_gpio_7_o_pue     = inspect_mode ? 1'b0          : gpio_7_o_pue;
 assign  io_pads_gpio_7_o_ds      = inspect_mode ? 1'b1          : gpio_7_o_ds;
 assign  io_pads_gpio_8_o_oval    = inspect_mode ? inspect_pc[8] : gpio_8_o_oval;
 assign  io_pads_gpio_8_o_oe      = inspect_mode ? 1'b1          : gpio_8_o_oe;
 assign  io_pads_gpio_8_o_ie      = inspect_mode ? 1'b0          : gpio_8_o_ie;
 assign  io_pads_gpio_8_o_pue     = inspect_mode ? 1'b0          : gpio_8_o_pue;
 assign  io_pads_gpio_8_o_ds      = inspect_mode ? 1'b1          : gpio_8_o_ds;
 assign  io_pads_gpio_9_o_oval    = inspect_mode ? inspect_pc[9] : gpio_9_o_oval;
 assign  io_pads_gpio_9_o_oe      = inspect_mode ? 1'b1          : gpio_9_o_oe;
 assign  io_pads_gpio_9_o_ie      = inspect_mode ? 1'b0          : gpio_9_o_ie;
 assign  io_pads_gpio_9_o_pue     = inspect_mode ? 1'b0          : gpio_9_o_pue;
 assign  io_pads_gpio_9_o_ds      = inspect_mode ? 1'b1          : gpio_9_o_ds;
 assign  io_pads_gpio_10_o_oval   = inspect_mode ? inspect_pc[10]: gpio_10_o_oval;
 assign  io_pads_gpio_10_o_oe     = inspect_mode ? 1'b1          : gpio_10_o_oe;
 assign  io_pads_gpio_10_o_ie     = inspect_mode ? 1'b0          : gpio_10_o_ie;
 assign  io_pads_gpio_10_o_pue    = inspect_mode ? 1'b0          : gpio_10_o_pue;
 assign  io_pads_gpio_10_o_ds     = inspect_mode ? 1'b1          : gpio_10_o_ds;
 assign  io_pads_gpio_11_o_oval   = inspect_mode ? inspect_pc[11]: gpio_11_o_oval;
 assign  io_pads_gpio_11_o_oe     = inspect_mode ? 1'b1          : gpio_11_o_oe;
 assign  io_pads_gpio_11_o_ie     = inspect_mode ? 1'b0          : gpio_11_o_ie;
 assign  io_pads_gpio_11_o_pue    = inspect_mode ? 1'b0          : gpio_11_o_pue;
 assign  io_pads_gpio_11_o_ds     = inspect_mode ? 1'b1          : gpio_11_o_ds;
 assign  io_pads_gpio_12_o_oval   = inspect_mode ? inspect_pc[12]: gpio_12_o_oval;
 assign  io_pads_gpio_12_o_oe     = inspect_mode ? 1'b1          : gpio_12_o_oe;
 assign  io_pads_gpio_12_o_ie     = inspect_mode ? 1'b0          : gpio_12_o_ie;
 assign  io_pads_gpio_12_o_pue    = inspect_mode ? 1'b0          : gpio_12_o_pue;
 assign  io_pads_gpio_12_o_ds     = inspect_mode ? 1'b1          : gpio_12_o_ds;
 assign  io_pads_gpio_13_o_oval   = inspect_mode ? inspect_pc[13]: gpio_13_o_oval;
 assign  io_pads_gpio_13_o_oe     = inspect_mode ? 1'b1          : gpio_13_o_oe;
 assign  io_pads_gpio_13_o_ie     = inspect_mode ? 1'b0          : gpio_13_o_ie;
 assign  io_pads_gpio_13_o_pue    = inspect_mode ? 1'b0          : gpio_13_o_pue;
 assign  io_pads_gpio_13_o_ds     = inspect_mode ? 1'b1          : gpio_13_o_ds;
 assign  io_pads_gpio_14_o_oval   = inspect_mode ? inspect_pc[14]: gpio_14_o_oval;
 assign  io_pads_gpio_14_o_oe     = inspect_mode ? 1'b1          : gpio_14_o_oe;
 assign  io_pads_gpio_14_o_ie     = inspect_mode ? 1'b0          : gpio_14_o_ie;
 assign  io_pads_gpio_14_o_pue    = inspect_mode ? 1'b0          : gpio_14_o_pue;
 assign  io_pads_gpio_14_o_ds     = inspect_mode ? 1'b1          : gpio_14_o_ds;
 assign  io_pads_gpio_15_o_oval   = inspect_mode ? inspect_pc[15]: gpio_15_o_oval;
 assign  io_pads_gpio_15_o_oe     = inspect_mode ? 1'b1          : gpio_15_o_oe;
 assign  io_pads_gpio_15_o_ie     = inspect_mode ? 1'b0          : gpio_15_o_ie;
 assign  io_pads_gpio_15_o_pue    = inspect_mode ? 1'b0          : gpio_15_o_pue;
 assign  io_pads_gpio_15_o_ds     = inspect_mode ? 1'b1          : gpio_15_o_ds;
 assign  io_pads_gpio_16_o_oval   = inspect_mode ? inspect_pc[16]: gpio_16_o_oval;
 assign  io_pads_gpio_16_o_oe     = inspect_mode ? 1'b1          : gpio_16_o_oe;
 assign  io_pads_gpio_16_o_ie     = inspect_mode ? 1'b0          : gpio_16_o_ie;
 assign  io_pads_gpio_16_o_pue    = inspect_mode ? 1'b0          : gpio_16_o_pue;
 assign  io_pads_gpio_16_o_ds     = inspect_mode ? 1'b1          : gpio_16_o_ds;
 assign  io_pads_gpio_17_o_oval   = inspect_mode ? inspect_pc[17]: gpio_17_o_oval;
 assign  io_pads_gpio_17_o_oe     = inspect_mode ? 1'b1          : gpio_17_o_oe;
 assign  io_pads_gpio_17_o_ie     = inspect_mode ? 1'b0          : gpio_17_o_ie;
 assign  io_pads_gpio_17_o_pue    = inspect_mode ? 1'b0          : gpio_17_o_pue;
 assign  io_pads_gpio_17_o_ds     = inspect_mode ? 1'b1          : gpio_17_o_ds;
 assign  io_pads_gpio_18_o_oval   = inspect_mode ? inspect_pc[18]: gpio_18_o_oval;
 assign  io_pads_gpio_18_o_oe     = inspect_mode ? 1'b1          : gpio_18_o_oe;
 assign  io_pads_gpio_18_o_ie     = inspect_mode ? 1'b0          : gpio_18_o_ie;
 assign  io_pads_gpio_18_o_pue    = inspect_mode ? 1'b0          : gpio_18_o_pue;
 assign  io_pads_gpio_18_o_ds     = inspect_mode ? 1'b1          : gpio_18_o_ds;
 assign  io_pads_gpio_19_o_oval   = inspect_mode ? inspect_pc[19]: gpio_19_o_oval;
 assign  io_pads_gpio_19_o_oe     = inspect_mode ? 1'b1          : gpio_19_o_oe;
 assign  io_pads_gpio_19_o_ie     = inspect_mode ? 1'b0          : gpio_19_o_ie;
 assign  io_pads_gpio_19_o_pue    = inspect_mode ? 1'b0          : gpio_19_o_pue;
 assign  io_pads_gpio_19_o_ds     = inspect_mode ? 1'b1          : gpio_19_o_ds;
 assign  io_pads_gpio_20_o_oval   = inspect_mode ? inspect_pc[20]: gpio_20_o_oval;
 assign  io_pads_gpio_20_o_oe     = inspect_mode ? 1'b1          : gpio_20_o_oe;
 assign  io_pads_gpio_20_o_ie     = inspect_mode ? 1'b0          : gpio_20_o_ie;
 assign  io_pads_gpio_20_o_pue    = inspect_mode ? 1'b0          : gpio_20_o_pue;
 assign  io_pads_gpio_20_o_ds     = inspect_mode ? 1'b1          : gpio_20_o_ds;
 assign  io_pads_gpio_21_o_oval   = inspect_mode ? inspect_pc[21]: gpio_21_o_oval;
 assign  io_pads_gpio_21_o_oe     = inspect_mode ? 1'b1          : gpio_21_o_oe;
 assign  io_pads_gpio_21_o_ie     = inspect_mode ? 1'b0          : gpio_21_o_ie;
 assign  io_pads_gpio_21_o_pue    = inspect_mode ? 1'b0          : gpio_21_o_pue;
 assign  io_pads_gpio_21_o_ds     = inspect_mode ? 1'b1          : gpio_21_o_ds;

 assign  io_pads_gpio_22_o_oval   = inspect_mode ? inspect_mem_cmd_valid : gpio_22_o_oval;
 assign  io_pads_gpio_22_o_oe     = inspect_mode ? 1'b1                  : gpio_22_o_oe;
 assign  io_pads_gpio_22_o_ie     = inspect_mode ? 1'b0                  : gpio_22_o_ie;
 assign  io_pads_gpio_22_o_pue    = inspect_mode ? 1'b0                  : gpio_22_o_pue;
 assign  io_pads_gpio_22_o_ds     = inspect_mode ? 1'b1                  : gpio_22_o_ds;
 assign  io_pads_gpio_23_o_oval   = inspect_mode ? inspect_mem_cmd_ready : gpio_23_o_oval;
 assign  io_pads_gpio_23_o_oe     = inspect_mode ? 1'b1                  : gpio_23_o_oe;
 assign  io_pads_gpio_23_o_ie     = inspect_mode ? 1'b0                  : gpio_23_o_ie;
 assign  io_pads_gpio_23_o_pue    = inspect_mode ? 1'b0                  : gpio_23_o_pue;
 assign  io_pads_gpio_23_o_ds     = inspect_mode ? 1'b1                  : gpio_23_o_ds;
 assign  io_pads_gpio_24_o_oval   = inspect_mode ? inspect_mem_rsp_valid : gpio_24_o_oval;
 assign  io_pads_gpio_24_o_oe     = inspect_mode ? 1'b1                  : gpio_24_o_oe;
 assign  io_pads_gpio_24_o_ie     = inspect_mode ? 1'b0                  : gpio_24_o_ie;
 assign  io_pads_gpio_24_o_pue    = inspect_mode ? 1'b0                  : gpio_24_o_pue;
 assign  io_pads_gpio_24_o_ds     = inspect_mode ? 1'b1                  : gpio_24_o_ds;
 assign  io_pads_gpio_25_o_oval   = inspect_mode ? inspect_mem_rsp_ready : gpio_25_o_oval;
 assign  io_pads_gpio_25_o_oe     = inspect_mode ? 1'b1                  : gpio_25_o_oe;
 assign  io_pads_gpio_25_o_ie     = inspect_mode ? 1'b0                  : gpio_25_o_ie;
 assign  io_pads_gpio_25_o_pue    = inspect_mode ? 1'b0                  : gpio_25_o_pue;
 assign  io_pads_gpio_25_o_ds     = inspect_mode ? 1'b1                  : gpio_25_o_ds;
 assign  io_pads_gpio_26_o_oval   = inspect_mode ? inspect_jtag_clk      : gpio_26_o_oval;
 assign  io_pads_gpio_26_o_oe     = inspect_mode ? 1'b1                  : gpio_26_o_oe;
 assign  io_pads_gpio_26_o_ie     = inspect_mode ? 1'b0                  : gpio_26_o_ie;
 assign  io_pads_gpio_26_o_pue    = inspect_mode ? 1'b0                  : gpio_26_o_pue;
 assign  io_pads_gpio_26_o_ds     = inspect_mode ? 1'b1                  : gpio_26_o_ds;
 assign  io_pads_gpio_27_o_oval   = inspect_mode ? inspect_core_clk      : gpio_27_o_oval;
 assign  io_pads_gpio_27_o_oe     = inspect_mode ? 1'b1                  : gpio_27_o_oe;
 assign  io_pads_gpio_27_o_ie     = inspect_mode ? 1'b0                  : gpio_27_o_ie;
 assign  io_pads_gpio_27_o_pue    = inspect_mode ? 1'b0                  : gpio_27_o_pue;
 assign  io_pads_gpio_27_o_ds     = inspect_mode ? 1'b1                  : gpio_27_o_ds;
 assign  io_pads_gpio_28_o_oval   = inspect_mode ? inspect_por_rst       : gpio_28_o_oval;
 assign  io_pads_gpio_28_o_oe     = inspect_mode ? 1'b1                  : gpio_28_o_oe;
 assign  io_pads_gpio_28_o_ie     = inspect_mode ? 1'b0                  : gpio_28_o_ie;
 assign  io_pads_gpio_28_o_pue    = inspect_mode ? 1'b0                  : gpio_28_o_pue;
 assign  io_pads_gpio_28_o_ds     = inspect_mode ? 1'b1                  : gpio_28_o_ds;
 assign  io_pads_gpio_29_o_oval   = inspect_mode ? inspect_32k_clk       : gpio_29_o_oval;
 assign  io_pads_gpio_29_o_oe     = inspect_mode ? 1'b1                  : gpio_29_o_oe;
 assign  io_pads_gpio_29_o_ie     = inspect_mode ? 1'b0                  : gpio_29_o_ie;
 assign  io_pads_gpio_29_o_pue    = inspect_mode ? 1'b0                  : gpio_29_o_pue;
 assign  io_pads_gpio_29_o_ds     = inspect_mode ? 1'b1                  : gpio_29_o_ds;
 assign  io_pads_gpio_30_o_oval   = inspect_mode ? inspect_16m_clk       : gpio_30_o_oval;
 assign  io_pads_gpio_30_o_oe     = inspect_mode ? 1'b1                  : gpio_30_o_oe;
 assign  io_pads_gpio_30_o_ie     = inspect_mode ? 1'b0                  : gpio_30_o_ie;
 assign  io_pads_gpio_30_o_pue    = inspect_mode ? 1'b0                  : gpio_30_o_pue;
 assign  io_pads_gpio_30_o_ds     = inspect_mode ? 1'b1                  : gpio_30_o_ds;
 assign  io_pads_gpio_31_o_oval   = inspect_mode ? inspect_pll_clk       : gpio_31_o_oval;
 assign  io_pads_gpio_31_o_oe     = inspect_mode ? 1'b1                  : gpio_31_o_oe;
 assign  io_pads_gpio_31_o_ie     = inspect_mode ? 1'b0                  : gpio_31_o_ie;
 assign  io_pads_gpio_31_o_pue    = inspect_mode ? 1'b0                  : gpio_31_o_pue;
 assign  io_pads_gpio_31_o_ds     = inspect_mode ? 1'b1                  : gpio_31_o_ds;


  
  //This is to reset the main domain
  wire main_rst;
 sirv_ResetCatchAndSync_2 u_main_ResetCatchAndSync_2_1 (
    .test_mode(test_mode),
    .clock(hfclk),
    .reset(corerst),
    .io_sync_reset(main_rst)
  );

  wire main_rst_n = ~main_rst;

  wire pllbypass ;
  wire pll_RESET ;
  wire pll_ASLEEP ;
  wire [1:0]  pll_OD;
  wire [7:0]  pll_M;
  wire [4:0]  pll_N;
  wire plloutdivby1;
  wire [5:0] plloutdiv;

  e203_subsys_hclkgen u_e203_subsys_hclkgen(
    .test_mode   (test_mode),
    .hfclkrst    (hfclkrst ),
    .hfextclk    (hfextclk    ),
                 
    .pllbypass   (pllbypass   ),
    .pll_RESET   (pll_RESET   ),
    .pll_ASLEEP  (pll_ASLEEP   ),
    .pll_OD      (pll_OD),
    .pll_M       (pll_M ),
    .pll_N       (pll_N ),
    .plloutdivby1(plloutdivby1),
    .plloutdiv   (plloutdiv   ), 

    .inspect_pll_clk(inspect_pll_clk),
    .inspect_16m_clk(inspect_16m_clk),
                
    .hfclk       (hfclk       ) // The generated clock by this module
  );


  wire  tcm_ds = 1'b0;// Currently we dont support it
  wire  tcm_sd = 1'b0;// Currently we dont support it

`ifndef E203_HAS_LOCKSTEP//{
  wire core_rst_n = main_rst_n;
  wire bus_rst_n  = main_rst_n;
  wire per_rst_n  = main_rst_n;
`endif//}





  wire                         ppi_icb_cmd_valid;
  wire                         ppi_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   ppi_icb_cmd_addr; 
  wire                         ppi_icb_cmd_read; 
  wire [`E203_XLEN-1:0]        ppi_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0]      ppi_icb_cmd_wmask;

  wire                         ppi_icb_rsp_valid;
  wire                         ppi_icb_rsp_ready;
  wire                         ppi_icb_rsp_err  ;
  wire [`E203_XLEN-1:0]        ppi_icb_rsp_rdata;

  
  wire                         clint_icb_cmd_valid;
  wire                         clint_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   clint_icb_cmd_addr; 
  wire                         clint_icb_cmd_read; 
  wire [`E203_XLEN-1:0]        clint_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0]      clint_icb_cmd_wmask;

  wire                         clint_icb_rsp_valid;
  wire                         clint_icb_rsp_ready;
  wire                         clint_icb_rsp_err  ;
  wire [`E203_XLEN-1:0]        clint_icb_rsp_rdata;

  
  wire                         plic_icb_cmd_valid;
  wire                         plic_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   plic_icb_cmd_addr; 
  wire                         plic_icb_cmd_read; 
  wire [`E203_XLEN-1:0]        plic_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0]      plic_icb_cmd_wmask;

  wire                         plic_icb_rsp_valid;
  wire                         plic_icb_rsp_ready;
  wire                         plic_icb_rsp_err  ;
  wire [`E203_XLEN-1:0]        plic_icb_rsp_rdata;

  `ifdef E203_HAS_FIO //{
  wire                         fio_icb_cmd_valid;
  wire                         fio_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   fio_icb_cmd_addr; 
  wire                         fio_icb_cmd_read; 
  wire [`E203_XLEN-1:0]        fio_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0]      fio_icb_cmd_wmask;

  wire                         fio_icb_rsp_valid;
  wire                         fio_icb_rsp_ready;
  wire                         fio_icb_rsp_err  ;
  wire [`E203_XLEN-1:0]        fio_icb_rsp_rdata;

  assign sysfio_icb_cmd_valid = fio_icb_cmd_valid;
  assign fio_icb_cmd_ready    = sysfio_icb_cmd_ready;
  assign sysfio_icb_cmd_addr  = fio_icb_cmd_addr ; 
  assign sysfio_icb_cmd_read  = fio_icb_cmd_read ; 
  assign sysfio_icb_cmd_wdata = fio_icb_cmd_wdata;
  assign sysfio_icb_cmd_wmask = fio_icb_cmd_wmask;
                           
  assign fio_icb_rsp_valid    = sysfio_icb_rsp_valid;
  assign sysfio_icb_rsp_ready = fio_icb_rsp_ready;
  assign fio_icb_rsp_err      = sysfio_icb_rsp_err  ;
  assign fio_icb_rsp_rdata    = sysfio_icb_rsp_rdata;
  `endif//}

  wire                         mem_icb_cmd_valid;
  wire                         mem_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   mem_icb_cmd_addr; 
  wire                         mem_icb_cmd_read; 
  wire [`E203_XLEN-1:0]        mem_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0]      mem_icb_cmd_wmask;
  
  wire                         mem_icb_rsp_valid;
  wire                         mem_icb_rsp_ready;
  wire                         mem_icb_rsp_err  ;
  wire [`E203_XLEN-1:0]        mem_icb_rsp_rdata;

  wire  plic_ext_irq;
  wire  clint_sft_irq;
  wire  clint_tmr_irq;

  wire tm_stop;


  wire core_wfi;



  e203_cpu_top u_e203_cpu_top(

  .inspect_pc               (inspect_pc), 
  .inspect_dbg_irq          (inspect_dbg_irq      ),
  .inspect_mem_cmd_valid    (inspect_mem_cmd_valid), 
  .inspect_mem_cmd_ready    (inspect_mem_cmd_ready), 
  .inspect_mem_rsp_valid    (inspect_mem_rsp_valid),
  .inspect_mem_rsp_ready    (inspect_mem_rsp_ready),
  .inspect_core_clk         (inspect_core_clk),

  .core_csr_clk          (core_csr_clk      ),


        
        

    .tm_stop         (tm_stop),
    .pc_rtvec        (pc_rtvec),

    .tcm_sd          (tcm_sd),
    .tcm_ds          (tcm_ds),
    
    .core_wfi        (core_wfi),

    .dbg_irq_r       (dbg_irq_r      ),

    .cmt_dpc         (cmt_dpc        ),
    .cmt_dpc_ena     (cmt_dpc_ena    ),
    .cmt_dcause      (cmt_dcause     ),
    .cmt_dcause_ena  (cmt_dcause_ena ),

    .wr_dcsr_ena     (wr_dcsr_ena    ),
    .wr_dpc_ena      (wr_dpc_ena     ),
    .wr_dscratch_ena (wr_dscratch_ena),



                                     
    .wr_csr_nxt      (wr_csr_nxt    ),
                                     
    .dcsr_r          (dcsr_r         ),
    .dpc_r           (dpc_r          ),
    .dscratch_r      (dscratch_r     ),

    .dbg_mode        (dbg_mode),
    .dbg_halt_r      (dbg_halt_r),
    .dbg_step_r      (dbg_step_r),
    .dbg_ebreakm_r   (dbg_ebreakm_r),
    .dbg_stopcycle   (dbg_stopcycle),

    .core_mhartid            (core_mhartid),  
    .dbg_irq_a               (dbg_irq_a),
    .ext_irq_a               (plic_ext_irq),
    .sft_irq_a               (clint_sft_irq),
    .tmr_irq_a               (clint_tmr_irq),

  `ifdef E203_HAS_ITCM_EXTITF //{
    .ext2itcm_icb_cmd_valid  (ext2itcm_icb_cmd_valid),
    .ext2itcm_icb_cmd_ready  (ext2itcm_icb_cmd_ready),
    .ext2itcm_icb_cmd_addr   (ext2itcm_icb_cmd_addr ),
    .ext2itcm_icb_cmd_read   (ext2itcm_icb_cmd_read ),
    .ext2itcm_icb_cmd_wdata  (ext2itcm_icb_cmd_wdata),
    .ext2itcm_icb_cmd_wmask  (ext2itcm_icb_cmd_wmask),
    
    .ext2itcm_icb_rsp_valid  (ext2itcm_icb_rsp_valid),
    .ext2itcm_icb_rsp_ready  (ext2itcm_icb_rsp_ready),
    .ext2itcm_icb_rsp_err    (ext2itcm_icb_rsp_err  ),
    .ext2itcm_icb_rsp_rdata  (ext2itcm_icb_rsp_rdata),
  `endif//}

  `ifdef E203_HAS_DTCM_EXTITF //{
    .ext2dtcm_icb_cmd_valid  (ext2dtcm_icb_cmd_valid),
    .ext2dtcm_icb_cmd_ready  (ext2dtcm_icb_cmd_ready),
    .ext2dtcm_icb_cmd_addr   (ext2dtcm_icb_cmd_addr ),
    .ext2dtcm_icb_cmd_read   (ext2dtcm_icb_cmd_read ),
    .ext2dtcm_icb_cmd_wdata  (ext2dtcm_icb_cmd_wdata),
    .ext2dtcm_icb_cmd_wmask  (ext2dtcm_icb_cmd_wmask),
    
    .ext2dtcm_icb_rsp_valid  (ext2dtcm_icb_rsp_valid),
    .ext2dtcm_icb_rsp_ready  (ext2dtcm_icb_rsp_ready),
    .ext2dtcm_icb_rsp_err    (ext2dtcm_icb_rsp_err  ),
    .ext2dtcm_icb_rsp_rdata  (ext2dtcm_icb_rsp_rdata),
  `endif//}


    .ppi_icb_cmd_valid     (ppi_icb_cmd_valid),
    .ppi_icb_cmd_ready     (ppi_icb_cmd_ready),
    .ppi_icb_cmd_addr      (ppi_icb_cmd_addr ),
    .ppi_icb_cmd_read      (ppi_icb_cmd_read ),
    .ppi_icb_cmd_wdata     (ppi_icb_cmd_wdata),
    .ppi_icb_cmd_wmask     (ppi_icb_cmd_wmask),
    
    .ppi_icb_rsp_valid     (ppi_icb_rsp_valid),
    .ppi_icb_rsp_ready     (ppi_icb_rsp_ready),
    .ppi_icb_rsp_err       (ppi_icb_rsp_err  ),
    .ppi_icb_rsp_rdata     (ppi_icb_rsp_rdata),

    .plic_icb_cmd_valid     (plic_icb_cmd_valid),
    .plic_icb_cmd_ready     (plic_icb_cmd_ready),
    .plic_icb_cmd_addr      (plic_icb_cmd_addr ),
    .plic_icb_cmd_read      (plic_icb_cmd_read ),
    .plic_icb_cmd_wdata     (plic_icb_cmd_wdata),
    .plic_icb_cmd_wmask     (plic_icb_cmd_wmask),
    
    .plic_icb_rsp_valid     (plic_icb_rsp_valid),
    .plic_icb_rsp_ready     (plic_icb_rsp_ready),
    .plic_icb_rsp_err       (plic_icb_rsp_err  ),
    .plic_icb_rsp_rdata     (plic_icb_rsp_rdata),

    .clint_icb_cmd_valid     (clint_icb_cmd_valid),
    .clint_icb_cmd_ready     (clint_icb_cmd_ready),
    .clint_icb_cmd_addr      (clint_icb_cmd_addr ),
    .clint_icb_cmd_read      (clint_icb_cmd_read ),
    .clint_icb_cmd_wdata     (clint_icb_cmd_wdata),
    .clint_icb_cmd_wmask     (clint_icb_cmd_wmask),
    
    .clint_icb_rsp_valid     (clint_icb_rsp_valid),
    .clint_icb_rsp_ready     (clint_icb_rsp_ready),
    .clint_icb_rsp_err       (clint_icb_rsp_err  ),
    .clint_icb_rsp_rdata     (clint_icb_rsp_rdata),

    .fio_icb_cmd_valid     (fio_icb_cmd_valid),
    .fio_icb_cmd_ready     (fio_icb_cmd_ready),
    .fio_icb_cmd_addr      (fio_icb_cmd_addr ),
    .fio_icb_cmd_read      (fio_icb_cmd_read ),
    .fio_icb_cmd_wdata     (fio_icb_cmd_wdata),
    .fio_icb_cmd_wmask     (fio_icb_cmd_wmask),
    
    .fio_icb_rsp_valid     (fio_icb_rsp_valid),
    .fio_icb_rsp_ready     (fio_icb_rsp_ready),
    .fio_icb_rsp_err       (fio_icb_rsp_err  ),
    .fio_icb_rsp_rdata     (fio_icb_rsp_rdata),

    .mem_icb_cmd_valid  (mem_icb_cmd_valid),
    .mem_icb_cmd_ready  (mem_icb_cmd_ready),
    .mem_icb_cmd_addr   (mem_icb_cmd_addr ),
    .mem_icb_cmd_read   (mem_icb_cmd_read ),
    .mem_icb_cmd_wdata  (mem_icb_cmd_wdata),
    .mem_icb_cmd_wmask  (mem_icb_cmd_wmask),
    
    .mem_icb_rsp_valid  (mem_icb_rsp_valid),
    .mem_icb_rsp_ready  (mem_icb_rsp_ready),
    .mem_icb_rsp_err    (mem_icb_rsp_err  ),
    .mem_icb_rsp_rdata  (mem_icb_rsp_rdata),

    .test_mode     (test_mode), 
    .clk           (hfclk  ),
    .rst_n         (core_rst_n) 
  );

  wire  qspi0_irq; 
  wire  qspi1_irq;
  wire  qspi2_irq;

  wire  uart0_irq;                
  wire  uart1_irq;                

  wire  pwm0_irq_0;
  wire  pwm0_irq_1;
  wire  pwm0_irq_2;
  wire  pwm0_irq_3;

  wire  pwm1_irq_0;
  wire  pwm1_irq_1;
  wire  pwm1_irq_2;
  wire  pwm1_irq_3;

  wire  pwm2_irq_0;
  wire  pwm2_irq_1;
  wire  pwm2_irq_2;
  wire  pwm2_irq_3;

  wire  i2c_mst_irq;

  wire  gpio_irq_0;
  wire  gpio_irq_1;
  wire  gpio_irq_2;
  wire  gpio_irq_3;
  wire  gpio_irq_4;
  wire  gpio_irq_5;
  wire  gpio_irq_6;
  wire  gpio_irq_7;
  wire  gpio_irq_8;
  wire  gpio_irq_9;
  wire  gpio_irq_10;
  wire  gpio_irq_11;
  wire  gpio_irq_12;
  wire  gpio_irq_13;
  wire  gpio_irq_14;
  wire  gpio_irq_15;
  wire  gpio_irq_16;
  wire  gpio_irq_17;
  wire  gpio_irq_18;
  wire  gpio_irq_19;
  wire  gpio_irq_20;
  wire  gpio_irq_21;
  wire  gpio_irq_22;
  wire  gpio_irq_23;
  wire  gpio_irq_24;
  wire  gpio_irq_25;
  wire  gpio_irq_26;
  wire  gpio_irq_27;
  wire  gpio_irq_28;
  wire  gpio_irq_29;
  wire  gpio_irq_30;
  wire  gpio_irq_31;


 e203_subsys_plic u_e203_subsys_plic(
    .plic_icb_cmd_valid     (plic_icb_cmd_valid),
    .plic_icb_cmd_ready     (plic_icb_cmd_ready),
    .plic_icb_cmd_addr      (plic_icb_cmd_addr ),
    .plic_icb_cmd_read      (plic_icb_cmd_read ),
    .plic_icb_cmd_wdata     (plic_icb_cmd_wdata),
    .plic_icb_cmd_wmask     (plic_icb_cmd_wmask),
    
    .plic_icb_rsp_valid     (plic_icb_rsp_valid),
    .plic_icb_rsp_ready     (plic_icb_rsp_ready),
    .plic_icb_rsp_err       (plic_icb_rsp_err  ),
    .plic_icb_rsp_rdata     (plic_icb_rsp_rdata),

    .plic_ext_irq           (plic_ext_irq),

    .wdg_irq_a              (aon_wdg_irq_a),
    .rtc_irq_a              (aon_rtc_irq_a),

    .qspi0_irq              (qspi0_irq  ), 
    .qspi1_irq              (qspi1_irq  ),
    .qspi2_irq              (qspi2_irq  ),
                                        
    .uart0_irq              (uart0_irq  ),                
    .uart1_irq              (uart1_irq  ),                
                                        
    .pwm0_irq_0             (pwm0_irq_0 ),
    .pwm0_irq_1             (pwm0_irq_1 ),
    .pwm0_irq_2             (pwm0_irq_2 ),
    .pwm0_irq_3             (pwm0_irq_3 ),
                                        
    .pwm1_irq_0             (pwm1_irq_0 ),
    .pwm1_irq_1             (pwm1_irq_1 ),
    .pwm1_irq_2             (pwm1_irq_2 ),
    .pwm1_irq_3             (pwm1_irq_3 ),
                                        
    .pwm2_irq_0             (pwm2_irq_0 ),
    .pwm2_irq_1             (pwm2_irq_1 ),
    .pwm2_irq_2             (pwm2_irq_2 ),
    .pwm2_irq_3             (pwm2_irq_3 ),
                                        
    .i2c_mst_irq            (i2c_mst_irq),

    .gpio_irq_0             (gpio_irq_0 ),
    .gpio_irq_1             (gpio_irq_1 ),
    .gpio_irq_2             (gpio_irq_2 ),
    .gpio_irq_3             (gpio_irq_3 ),
    .gpio_irq_4             (gpio_irq_4 ),
    .gpio_irq_5             (gpio_irq_5 ),
    .gpio_irq_6             (gpio_irq_6 ),
    .gpio_irq_7             (gpio_irq_7 ),
    .gpio_irq_8             (gpio_irq_8 ),
    .gpio_irq_9             (gpio_irq_9 ),
    .gpio_irq_10            (gpio_irq_10),
    .gpio_irq_11            (gpio_irq_11),
    .gpio_irq_12            (gpio_irq_12),
    .gpio_irq_13            (gpio_irq_13),
    .gpio_irq_14            (gpio_irq_14),
    .gpio_irq_15            (gpio_irq_15),
    .gpio_irq_16            (gpio_irq_16),
    .gpio_irq_17            (gpio_irq_17),
    .gpio_irq_18            (gpio_irq_18),
    .gpio_irq_19            (gpio_irq_19),
    .gpio_irq_20            (gpio_irq_20),
    .gpio_irq_21            (gpio_irq_21),
    .gpio_irq_22            (gpio_irq_22),
    .gpio_irq_23            (gpio_irq_23),
    .gpio_irq_24            (gpio_irq_24),
    .gpio_irq_25            (gpio_irq_25),
    .gpio_irq_26            (gpio_irq_26),
    .gpio_irq_27            (gpio_irq_27),
    .gpio_irq_28            (gpio_irq_28),
    .gpio_irq_29            (gpio_irq_29),
    .gpio_irq_30            (gpio_irq_30),
    .gpio_irq_31            (gpio_irq_31),

    .clk                    (hfclk  ),
    .rst_n                  (per_rst_n) 
  );

e203_subsys_clint u_e203_subsys_clint(
    .tm_stop                 (tm_stop),

    .clint_icb_cmd_valid     (clint_icb_cmd_valid),
    .clint_icb_cmd_ready     (clint_icb_cmd_ready),
    .clint_icb_cmd_addr      (clint_icb_cmd_addr ),
    .clint_icb_cmd_read      (clint_icb_cmd_read ),
    .clint_icb_cmd_wdata     (clint_icb_cmd_wdata),
    .clint_icb_cmd_wmask     (clint_icb_cmd_wmask),
    
    .clint_icb_rsp_valid     (clint_icb_rsp_valid),
    .clint_icb_rsp_ready     (clint_icb_rsp_ready),
    .clint_icb_rsp_err       (clint_icb_rsp_err  ),
    .clint_icb_rsp_rdata     (clint_icb_rsp_rdata),

    .clint_tmr_irq           (clint_tmr_irq),
    .clint_sft_irq           (clint_sft_irq),

    .aon_rtcToggle_a         (aon_rtcToggle_a),

    .clk           (hfclk  ),
    .rst_n         (per_rst_n) 
  );

  
  wire                     qspi0_ro_icb_cmd_valid;
  wire                     qspi0_ro_icb_cmd_ready;
  wire [32-1:0]            qspi0_ro_icb_cmd_addr; 
  wire                     qspi0_ro_icb_cmd_read; 
  wire [32-1:0]            qspi0_ro_icb_cmd_wdata;
  
  wire                     qspi0_ro_icb_rsp_valid;
  wire                     qspi0_ro_icb_rsp_ready;
  wire [32-1:0]            qspi0_ro_icb_rsp_rdata;

  
  wire                     otp_ro_icb_cmd_valid;
  wire                     otp_ro_icb_cmd_ready;
  wire [32-1:0]            otp_ro_icb_cmd_addr; 
  wire                     otp_ro_icb_cmd_read; 
  wire [32-1:0]            otp_ro_icb_cmd_wdata;
 
  wire                     otp_ro_icb_rsp_valid;
  wire                     otp_ro_icb_rsp_ready;
  wire [32-1:0]            otp_ro_icb_rsp_rdata;


  e203_subsys_perips u_e203_subsys_perips (
    .pllbypass   (pllbypass   ),
    .pll_RESET   (pll_RESET   ),
    .pll_ASLEEP  (pll_ASLEEP  ),
    .pll_OD(pll_OD),
    .pll_M (pll_M ),
    .pll_N (pll_N ),
    .plloutdivby1(plloutdivby1),
    .plloutdiv   (plloutdiv   ), 

    .hfxoscen    (hfxoscen),
    .ppi_icb_cmd_valid     (ppi_icb_cmd_valid),
    .ppi_icb_cmd_ready     (ppi_icb_cmd_ready),
    .ppi_icb_cmd_addr      (ppi_icb_cmd_addr ),
    .ppi_icb_cmd_read      (ppi_icb_cmd_read ),
    .ppi_icb_cmd_wdata     (ppi_icb_cmd_wdata),
    .ppi_icb_cmd_wmask     (ppi_icb_cmd_wmask),
    
    .ppi_icb_rsp_valid     (ppi_icb_rsp_valid),
    .ppi_icb_rsp_ready     (ppi_icb_rsp_ready),
    .ppi_icb_rsp_err       (ppi_icb_rsp_err  ),
    .ppi_icb_rsp_rdata     (ppi_icb_rsp_rdata),

  
    .sysper_icb_cmd_valid  (sysper_icb_cmd_valid),
    .sysper_icb_cmd_ready  (sysper_icb_cmd_ready),
    .sysper_icb_cmd_addr   (sysper_icb_cmd_addr ), 
    .sysper_icb_cmd_read   (sysper_icb_cmd_read ), 
    .sysper_icb_cmd_wdata  (sysper_icb_cmd_wdata),
    .sysper_icb_cmd_wmask  (sysper_icb_cmd_wmask),
                                                
    .sysper_icb_rsp_valid  (sysper_icb_rsp_valid),
    .sysper_icb_rsp_ready  (sysper_icb_rsp_ready),
    .sysper_icb_rsp_err    (sysper_icb_rsp_err  ),
    .sysper_icb_rsp_rdata  (sysper_icb_rsp_rdata),

    .aon_icb_cmd_valid     (aon_icb_cmd_valid),
    .aon_icb_cmd_ready     (aon_icb_cmd_ready),
    .aon_icb_cmd_addr      (aon_icb_cmd_addr ), 
    .aon_icb_cmd_read      (aon_icb_cmd_read ), 
    .aon_icb_cmd_wdata     (aon_icb_cmd_wdata),
                                             
    .aon_icb_rsp_valid     (aon_icb_rsp_valid),
    .aon_icb_rsp_ready     (aon_icb_rsp_ready),
    .aon_icb_rsp_err       (aon_icb_rsp_err  ),
    .aon_icb_rsp_rdata     (aon_icb_rsp_rdata),

`ifdef FAKE_FLASH_MODEL//{
    .qspi0_ro_icb_cmd_valid  (1'b0), 
    .qspi0_ro_icb_cmd_ready  (),
    .qspi0_ro_icb_cmd_addr   (32'b0 ),
    .qspi0_ro_icb_cmd_read   (1'b0 ),
    .qspi0_ro_icb_cmd_wdata  (32'b0),
                             
    .qspi0_ro_icb_rsp_valid  (),
    .qspi0_ro_icb_rsp_ready  (1'b0),
    .qspi0_ro_icb_rsp_rdata  (),
`else//}{
    .qspi0_ro_icb_cmd_valid  (qspi0_ro_icb_cmd_valid), 
    .qspi0_ro_icb_cmd_ready  (qspi0_ro_icb_cmd_ready),
    .qspi0_ro_icb_cmd_addr   (qspi0_ro_icb_cmd_addr ),
    .qspi0_ro_icb_cmd_read   (qspi0_ro_icb_cmd_read ),
    .qspi0_ro_icb_cmd_wdata  (qspi0_ro_icb_cmd_wdata),
                             
    .qspi0_ro_icb_rsp_valid  (qspi0_ro_icb_rsp_valid),
    .qspi0_ro_icb_rsp_ready  (qspi0_ro_icb_rsp_ready),
    .qspi0_ro_icb_rsp_rdata  (qspi0_ro_icb_rsp_rdata),
`endif//}
                           
    .otp_ro_icb_cmd_valid    (otp_ro_icb_cmd_valid  ),
    .otp_ro_icb_cmd_ready    (otp_ro_icb_cmd_ready  ),
    .otp_ro_icb_cmd_addr     (otp_ro_icb_cmd_addr   ),
    .otp_ro_icb_cmd_read     (otp_ro_icb_cmd_read   ),
    .otp_ro_icb_cmd_wdata    (otp_ro_icb_cmd_wdata  ),
                          
    .otp_ro_icb_rsp_valid    (otp_ro_icb_rsp_valid  ),
    .otp_ro_icb_rsp_ready    (otp_ro_icb_rsp_ready  ),
    .otp_ro_icb_rsp_rdata    (otp_ro_icb_rsp_rdata  ),

    .io_pads_gpio_0_i_ival      (io_pads_gpio_0_i_ival),
    .io_pads_gpio_0_o_oval      (gpio_0_o_oval),
    .io_pads_gpio_0_o_oe        (gpio_0_o_oe),
    .io_pads_gpio_0_o_ie        (gpio_0_o_ie),
    .io_pads_gpio_0_o_pue       (gpio_0_o_pue),
    .io_pads_gpio_0_o_ds        (gpio_0_o_ds),
    .io_pads_gpio_1_i_ival      (io_pads_gpio_1_i_ival),
    .io_pads_gpio_1_o_oval      (gpio_1_o_oval),
    .io_pads_gpio_1_o_oe        (gpio_1_o_oe),
    .io_pads_gpio_1_o_ie        (gpio_1_o_ie),
    .io_pads_gpio_1_o_pue       (gpio_1_o_pue),
    .io_pads_gpio_1_o_ds        (gpio_1_o_ds),
    .io_pads_gpio_2_i_ival      (io_pads_gpio_2_i_ival),
    .io_pads_gpio_2_o_oval      (gpio_2_o_oval),
    .io_pads_gpio_2_o_oe        (gpio_2_o_oe),
    .io_pads_gpio_2_o_ie        (gpio_2_o_ie),
    .io_pads_gpio_2_o_pue       (gpio_2_o_pue),
    .io_pads_gpio_2_o_ds        (gpio_2_o_ds),
    .io_pads_gpio_3_i_ival      (io_pads_gpio_3_i_ival),
    .io_pads_gpio_3_o_oval      (gpio_3_o_oval),
    .io_pads_gpio_3_o_oe        (gpio_3_o_oe),
    .io_pads_gpio_3_o_ie        (gpio_3_o_ie),
    .io_pads_gpio_3_o_pue       (gpio_3_o_pue),
    .io_pads_gpio_3_o_ds        (gpio_3_o_ds),
    .io_pads_gpio_4_i_ival      (io_pads_gpio_4_i_ival),
    .io_pads_gpio_4_o_oval      (gpio_4_o_oval),
    .io_pads_gpio_4_o_oe        (gpio_4_o_oe),
    .io_pads_gpio_4_o_ie        (gpio_4_o_ie),
    .io_pads_gpio_4_o_pue       (gpio_4_o_pue),
    .io_pads_gpio_4_o_ds        (gpio_4_o_ds),
    .io_pads_gpio_5_i_ival      (io_pads_gpio_5_i_ival),
    .io_pads_gpio_5_o_oval      (gpio_5_o_oval),
    .io_pads_gpio_5_o_oe        (gpio_5_o_oe),
    .io_pads_gpio_5_o_ie        (gpio_5_o_ie),
    .io_pads_gpio_5_o_pue       (gpio_5_o_pue),
    .io_pads_gpio_5_o_ds        (gpio_5_o_ds),
    .io_pads_gpio_6_i_ival      (io_pads_gpio_6_i_ival),
    .io_pads_gpio_6_o_oval      (gpio_6_o_oval),
    .io_pads_gpio_6_o_oe        (gpio_6_o_oe),
    .io_pads_gpio_6_o_ie        (gpio_6_o_ie),
    .io_pads_gpio_6_o_pue       (gpio_6_o_pue),
    .io_pads_gpio_6_o_ds        (gpio_6_o_ds),
    .io_pads_gpio_7_i_ival      (io_pads_gpio_7_i_ival),
    .io_pads_gpio_7_o_oval      (gpio_7_o_oval),
    .io_pads_gpio_7_o_oe        (gpio_7_o_oe),
    .io_pads_gpio_7_o_ie        (gpio_7_o_ie),
    .io_pads_gpio_7_o_pue       (gpio_7_o_pue),
    .io_pads_gpio_7_o_ds        (gpio_7_o_ds),
    .io_pads_gpio_8_i_ival      (io_pads_gpio_8_i_ival),
    .io_pads_gpio_8_o_oval      (gpio_8_o_oval),
    .io_pads_gpio_8_o_oe        (gpio_8_o_oe),
    .io_pads_gpio_8_o_ie        (gpio_8_o_ie),
    .io_pads_gpio_8_o_pue       (gpio_8_o_pue),
    .io_pads_gpio_8_o_ds        (gpio_8_o_ds),
    .io_pads_gpio_9_i_ival      (io_pads_gpio_9_i_ival),
    .io_pads_gpio_9_o_oval      (gpio_9_o_oval),
    .io_pads_gpio_9_o_oe        (gpio_9_o_oe),
    .io_pads_gpio_9_o_ie        (gpio_9_o_ie),
    .io_pads_gpio_9_o_pue       (gpio_9_o_pue),
    .io_pads_gpio_9_o_ds        (gpio_9_o_ds),
    .io_pads_gpio_10_i_ival     (io_pads_gpio_10_i_ival),
    .io_pads_gpio_10_o_oval     (gpio_10_o_oval),
    .io_pads_gpio_10_o_oe       (gpio_10_o_oe),
    .io_pads_gpio_10_o_ie       (gpio_10_o_ie),
    .io_pads_gpio_10_o_pue      (gpio_10_o_pue),
    .io_pads_gpio_10_o_ds       (gpio_10_o_ds),
    .io_pads_gpio_11_i_ival     (io_pads_gpio_11_i_ival),
    .io_pads_gpio_11_o_oval     (gpio_11_o_oval),
    .io_pads_gpio_11_o_oe       (gpio_11_o_oe),
    .io_pads_gpio_11_o_ie       (gpio_11_o_ie),
    .io_pads_gpio_11_o_pue      (gpio_11_o_pue),
    .io_pads_gpio_11_o_ds       (gpio_11_o_ds),
    .io_pads_gpio_12_i_ival     (io_pads_gpio_12_i_ival),
    .io_pads_gpio_12_o_oval     (gpio_12_o_oval),
    .io_pads_gpio_12_o_oe       (gpio_12_o_oe),
    .io_pads_gpio_12_o_ie       (gpio_12_o_ie),
    .io_pads_gpio_12_o_pue      (gpio_12_o_pue),
    .io_pads_gpio_12_o_ds       (gpio_12_o_ds),
    .io_pads_gpio_13_i_ival     (io_pads_gpio_13_i_ival),
    .io_pads_gpio_13_o_oval     (gpio_13_o_oval),
    .io_pads_gpio_13_o_oe       (gpio_13_o_oe),
    .io_pads_gpio_13_o_ie       (gpio_13_o_ie),
    .io_pads_gpio_13_o_pue      (gpio_13_o_pue),
    .io_pads_gpio_13_o_ds       (gpio_13_o_ds),
    .io_pads_gpio_14_i_ival     (io_pads_gpio_14_i_ival),
    .io_pads_gpio_14_o_oval     (gpio_14_o_oval),
    .io_pads_gpio_14_o_oe       (gpio_14_o_oe),
    .io_pads_gpio_14_o_ie       (gpio_14_o_ie),
    .io_pads_gpio_14_o_pue      (gpio_14_o_pue),
    .io_pads_gpio_14_o_ds       (gpio_14_o_ds),
    .io_pads_gpio_15_i_ival     (io_pads_gpio_15_i_ival),
    .io_pads_gpio_15_o_oval     (gpio_15_o_oval),
    .io_pads_gpio_15_o_oe       (gpio_15_o_oe),
    .io_pads_gpio_15_o_ie       (gpio_15_o_ie),
    .io_pads_gpio_15_o_pue      (gpio_15_o_pue),
    .io_pads_gpio_15_o_ds       (gpio_15_o_ds),
    .io_pads_gpio_16_i_ival     (io_pads_gpio_16_i_ival),
    .io_pads_gpio_16_o_oval     (gpio_16_o_oval),
    .io_pads_gpio_16_o_oe       (gpio_16_o_oe),
    .io_pads_gpio_16_o_ie       (gpio_16_o_ie),
    .io_pads_gpio_16_o_pue      (gpio_16_o_pue),
    .io_pads_gpio_16_o_ds       (gpio_16_o_ds),
    .io_pads_gpio_17_i_ival     (io_pads_gpio_17_i_ival),
    .io_pads_gpio_17_o_oval     (gpio_17_o_oval),
    .io_pads_gpio_17_o_oe       (gpio_17_o_oe),
    .io_pads_gpio_17_o_ie       (gpio_17_o_ie),
    .io_pads_gpio_17_o_pue      (gpio_17_o_pue),
    .io_pads_gpio_17_o_ds       (gpio_17_o_ds),
    .io_pads_gpio_18_i_ival     (io_pads_gpio_18_i_ival),
    .io_pads_gpio_18_o_oval     (gpio_18_o_oval),
    .io_pads_gpio_18_o_oe       (gpio_18_o_oe),
    .io_pads_gpio_18_o_ie       (gpio_18_o_ie),
    .io_pads_gpio_18_o_pue      (gpio_18_o_pue),
    .io_pads_gpio_18_o_ds       (gpio_18_o_ds),
    .io_pads_gpio_19_i_ival     (io_pads_gpio_19_i_ival),
    .io_pads_gpio_19_o_oval     (gpio_19_o_oval),
    .io_pads_gpio_19_o_oe       (gpio_19_o_oe),
    .io_pads_gpio_19_o_ie       (gpio_19_o_ie),
    .io_pads_gpio_19_o_pue      (gpio_19_o_pue),
    .io_pads_gpio_19_o_ds       (gpio_19_o_ds),
    .io_pads_gpio_20_i_ival     (io_pads_gpio_20_i_ival),
    .io_pads_gpio_20_o_oval     (gpio_20_o_oval),
    .io_pads_gpio_20_o_oe       (gpio_20_o_oe),
    .io_pads_gpio_20_o_ie       (gpio_20_o_ie),
    .io_pads_gpio_20_o_pue      (gpio_20_o_pue),
    .io_pads_gpio_20_o_ds       (gpio_20_o_ds),
    .io_pads_gpio_21_i_ival     (io_pads_gpio_21_i_ival),
    .io_pads_gpio_21_o_oval     (gpio_21_o_oval),
    .io_pads_gpio_21_o_oe       (gpio_21_o_oe),
    .io_pads_gpio_21_o_ie       (gpio_21_o_ie),
    .io_pads_gpio_21_o_pue      (gpio_21_o_pue),
    .io_pads_gpio_21_o_ds       (gpio_21_o_ds),
    .io_pads_gpio_22_i_ival     (io_pads_gpio_22_i_ival),
    .io_pads_gpio_22_o_oval     (gpio_22_o_oval),
    .io_pads_gpio_22_o_oe       (gpio_22_o_oe),
    .io_pads_gpio_22_o_ie       (gpio_22_o_ie),
    .io_pads_gpio_22_o_pue      (gpio_22_o_pue),
    .io_pads_gpio_22_o_ds       (gpio_22_o_ds),
    .io_pads_gpio_23_i_ival     (io_pads_gpio_23_i_ival),
    .io_pads_gpio_23_o_oval     (gpio_23_o_oval),
    .io_pads_gpio_23_o_oe       (gpio_23_o_oe),
    .io_pads_gpio_23_o_ie       (gpio_23_o_ie),
    .io_pads_gpio_23_o_pue      (gpio_23_o_pue),
    .io_pads_gpio_23_o_ds       (gpio_23_o_ds),
    .io_pads_gpio_24_i_ival     (io_pads_gpio_24_i_ival),
    .io_pads_gpio_24_o_oval     (gpio_24_o_oval),
    .io_pads_gpio_24_o_oe       (gpio_24_o_oe),
    .io_pads_gpio_24_o_ie       (gpio_24_o_ie),
    .io_pads_gpio_24_o_pue      (gpio_24_o_pue),
    .io_pads_gpio_24_o_ds       (gpio_24_o_ds),
    .io_pads_gpio_25_i_ival     (io_pads_gpio_25_i_ival),
    .io_pads_gpio_25_o_oval     (gpio_25_o_oval),
    .io_pads_gpio_25_o_oe       (gpio_25_o_oe),
    .io_pads_gpio_25_o_ie       (gpio_25_o_ie),
    .io_pads_gpio_25_o_pue      (gpio_25_o_pue),
    .io_pads_gpio_25_o_ds       (gpio_25_o_ds),
    .io_pads_gpio_26_i_ival     (io_pads_gpio_26_i_ival),
    .io_pads_gpio_26_o_oval     (gpio_26_o_oval),
    .io_pads_gpio_26_o_oe       (gpio_26_o_oe),
    .io_pads_gpio_26_o_ie       (gpio_26_o_ie),
    .io_pads_gpio_26_o_pue      (gpio_26_o_pue),
    .io_pads_gpio_26_o_ds       (gpio_26_o_ds),
    .io_pads_gpio_27_i_ival     (io_pads_gpio_27_i_ival),
    .io_pads_gpio_27_o_oval     (gpio_27_o_oval),
    .io_pads_gpio_27_o_oe       (gpio_27_o_oe),
    .io_pads_gpio_27_o_ie       (gpio_27_o_ie),
    .io_pads_gpio_27_o_pue      (gpio_27_o_pue),
    .io_pads_gpio_27_o_ds       (gpio_27_o_ds),
    .io_pads_gpio_28_i_ival     (io_pads_gpio_28_i_ival),
    .io_pads_gpio_28_o_oval     (gpio_28_o_oval),
    .io_pads_gpio_28_o_oe       (gpio_28_o_oe),
    .io_pads_gpio_28_o_ie       (gpio_28_o_ie),
    .io_pads_gpio_28_o_pue      (gpio_28_o_pue),
    .io_pads_gpio_28_o_ds       (gpio_28_o_ds),
    .io_pads_gpio_29_i_ival     (io_pads_gpio_29_i_ival),
    .io_pads_gpio_29_o_oval     (gpio_29_o_oval),
    .io_pads_gpio_29_o_oe       (gpio_29_o_oe),
    .io_pads_gpio_29_o_ie       (gpio_29_o_ie),
    .io_pads_gpio_29_o_pue      (gpio_29_o_pue),
    .io_pads_gpio_29_o_ds       (gpio_29_o_ds),
    .io_pads_gpio_30_i_ival     (io_pads_gpio_30_i_ival),
    .io_pads_gpio_30_o_oval     (gpio_30_o_oval),
    .io_pads_gpio_30_o_oe       (gpio_30_o_oe),
    .io_pads_gpio_30_o_ie       (gpio_30_o_ie),
    .io_pads_gpio_30_o_pue      (gpio_30_o_pue),
    .io_pads_gpio_30_o_ds       (gpio_30_o_ds),
    .io_pads_gpio_31_i_ival     (io_pads_gpio_31_i_ival),
    .io_pads_gpio_31_o_oval     (gpio_31_o_oval),
    .io_pads_gpio_31_o_oe       (gpio_31_o_oe),
    .io_pads_gpio_31_o_ie       (gpio_31_o_ie),
    .io_pads_gpio_31_o_pue      (gpio_31_o_pue),
    .io_pads_gpio_31_o_ds       (gpio_31_o_ds),

    .io_pads_qspi_sck_i_ival    (io_pads_qspi_sck_i_ival    ),
    .io_pads_qspi_sck_o_oval    (io_pads_qspi_sck_o_oval    ),
    .io_pads_qspi_sck_o_oe      (io_pads_qspi_sck_o_oe      ),
    .io_pads_qspi_sck_o_ie      (io_pads_qspi_sck_o_ie      ),
    .io_pads_qspi_sck_o_pue     (io_pads_qspi_sck_o_pue     ),
    .io_pads_qspi_sck_o_ds      (io_pads_qspi_sck_o_ds      ),
    .io_pads_qspi_dq_0_i_ival   (io_pads_qspi_dq_0_i_ival   ),
    .io_pads_qspi_dq_0_o_oval   (io_pads_qspi_dq_0_o_oval   ),
    .io_pads_qspi_dq_0_o_oe     (io_pads_qspi_dq_0_o_oe     ),
    .io_pads_qspi_dq_0_o_ie     (io_pads_qspi_dq_0_o_ie     ),
    .io_pads_qspi_dq_0_o_pue    (io_pads_qspi_dq_0_o_pue    ),
    .io_pads_qspi_dq_0_o_ds     (io_pads_qspi_dq_0_o_ds     ),
    .io_pads_qspi_dq_1_i_ival   (io_pads_qspi_dq_1_i_ival   ),
    .io_pads_qspi_dq_1_o_oval   (io_pads_qspi_dq_1_o_oval   ),
    .io_pads_qspi_dq_1_o_oe     (io_pads_qspi_dq_1_o_oe     ),
    .io_pads_qspi_dq_1_o_ie     (io_pads_qspi_dq_1_o_ie     ),
    .io_pads_qspi_dq_1_o_pue    (io_pads_qspi_dq_1_o_pue    ),
    .io_pads_qspi_dq_1_o_ds     (io_pads_qspi_dq_1_o_ds     ),
    .io_pads_qspi_dq_2_i_ival   (io_pads_qspi_dq_2_i_ival   ),
    .io_pads_qspi_dq_2_o_oval   (io_pads_qspi_dq_2_o_oval   ),
    .io_pads_qspi_dq_2_o_oe     (io_pads_qspi_dq_2_o_oe     ),
    .io_pads_qspi_dq_2_o_ie     (io_pads_qspi_dq_2_o_ie     ),
    .io_pads_qspi_dq_2_o_pue    (io_pads_qspi_dq_2_o_pue    ),
    .io_pads_qspi_dq_2_o_ds     (io_pads_qspi_dq_2_o_ds     ),
    .io_pads_qspi_dq_3_i_ival   (io_pads_qspi_dq_3_i_ival   ),
    .io_pads_qspi_dq_3_o_oval   (io_pads_qspi_dq_3_o_oval   ),
    .io_pads_qspi_dq_3_o_oe     (io_pads_qspi_dq_3_o_oe     ),
    .io_pads_qspi_dq_3_o_ie     (io_pads_qspi_dq_3_o_ie     ),
    .io_pads_qspi_dq_3_o_pue    (io_pads_qspi_dq_3_o_pue    ),
    .io_pads_qspi_dq_3_o_ds     (io_pads_qspi_dq_3_o_ds     ),
    .io_pads_qspi_cs_0_i_ival   (io_pads_qspi_cs_0_i_ival   ),
    .io_pads_qspi_cs_0_o_oval   (io_pads_qspi_cs_0_o_oval   ),
    .io_pads_qspi_cs_0_o_oe     (io_pads_qspi_cs_0_o_oe     ),
    .io_pads_qspi_cs_0_o_ie     (io_pads_qspi_cs_0_o_ie     ),
    .io_pads_qspi_cs_0_o_pue    (io_pads_qspi_cs_0_o_pue    ),
    .io_pads_qspi_cs_0_o_ds     (io_pads_qspi_cs_0_o_ds     ),

    .qspi0_irq              (qspi0_irq  ), 
    .qspi1_irq              (qspi1_irq  ),
    .qspi2_irq              (qspi2_irq  ),
                                        
    .uart0_irq              (uart0_irq  ),                
    .uart1_irq              (uart1_irq  ),                
                                        
    .pwm0_irq_0             (pwm0_irq_0 ),
    .pwm0_irq_1             (pwm0_irq_1 ),
    .pwm0_irq_2             (pwm0_irq_2 ),
    .pwm0_irq_3             (pwm0_irq_3 ),
                                        
    .pwm1_irq_0             (pwm1_irq_0 ),
    .pwm1_irq_1             (pwm1_irq_1 ),
    .pwm1_irq_2             (pwm1_irq_2 ),
    .pwm1_irq_3             (pwm1_irq_3 ),
                                        
    .pwm2_irq_0             (pwm2_irq_0 ),
    .pwm2_irq_1             (pwm2_irq_1 ),
    .pwm2_irq_2             (pwm2_irq_2 ),
    .pwm2_irq_3             (pwm2_irq_3 ),
                                        
    .i2c_mst_irq            (i2c_mst_irq),

    .gpio_irq_0             (gpio_irq_0 ),
    .gpio_irq_1             (gpio_irq_1 ),
    .gpio_irq_2             (gpio_irq_2 ),
    .gpio_irq_3             (gpio_irq_3 ),
    .gpio_irq_4             (gpio_irq_4 ),
    .gpio_irq_5             (gpio_irq_5 ),
    .gpio_irq_6             (gpio_irq_6 ),
    .gpio_irq_7             (gpio_irq_7 ),
    .gpio_irq_8             (gpio_irq_8 ),
    .gpio_irq_9             (gpio_irq_9 ),
    .gpio_irq_10            (gpio_irq_10),
    .gpio_irq_11            (gpio_irq_11),
    .gpio_irq_12            (gpio_irq_12),
    .gpio_irq_13            (gpio_irq_13),
    .gpio_irq_14            (gpio_irq_14),
    .gpio_irq_15            (gpio_irq_15),
    .gpio_irq_16            (gpio_irq_16),
    .gpio_irq_17            (gpio_irq_17),
    .gpio_irq_18            (gpio_irq_18),
    .gpio_irq_19            (gpio_irq_19),
    .gpio_irq_20            (gpio_irq_20),
    .gpio_irq_21            (gpio_irq_21),
    .gpio_irq_22            (gpio_irq_22),
    .gpio_irq_23            (gpio_irq_23),
    .gpio_irq_24            (gpio_irq_24),
    .gpio_irq_25            (gpio_irq_25),
    .gpio_irq_26            (gpio_irq_26),
    .gpio_irq_27            (gpio_irq_27),
    .gpio_irq_28            (gpio_irq_28),
    .gpio_irq_29            (gpio_irq_29),
    .gpio_irq_30            (gpio_irq_30),
    .gpio_irq_31            (gpio_irq_31),

    .clk           (hfclk  ),
    .bus_rst_n     (bus_rst_n), 
    .rst_n         (per_rst_n) 
  );

e203_subsys_mems u_e203_subsys_mems(

    .mem_icb_cmd_valid  (mem_icb_cmd_valid),
    .mem_icb_cmd_ready  (mem_icb_cmd_ready),
    .mem_icb_cmd_addr   (mem_icb_cmd_addr ),
    .mem_icb_cmd_read   (mem_icb_cmd_read ),
    .mem_icb_cmd_wdata  (mem_icb_cmd_wdata),
    .mem_icb_cmd_wmask  (mem_icb_cmd_wmask),
    
    .mem_icb_rsp_valid  (mem_icb_rsp_valid),
    .mem_icb_rsp_ready  (mem_icb_rsp_ready),
    .mem_icb_rsp_err    (mem_icb_rsp_err  ),
    .mem_icb_rsp_rdata  (mem_icb_rsp_rdata),

    .sysmem_icb_cmd_valid  (sysmem_icb_cmd_valid),
    .sysmem_icb_cmd_ready  (sysmem_icb_cmd_ready),
    .sysmem_icb_cmd_addr   (sysmem_icb_cmd_addr ),
    .sysmem_icb_cmd_read   (sysmem_icb_cmd_read ),
    .sysmem_icb_cmd_wdata  (sysmem_icb_cmd_wdata),
    .sysmem_icb_cmd_wmask  (sysmem_icb_cmd_wmask),
    
    .sysmem_icb_rsp_valid  (sysmem_icb_rsp_valid),
    .sysmem_icb_rsp_ready  (sysmem_icb_rsp_ready),
    .sysmem_icb_rsp_err    (sysmem_icb_rsp_err  ),
    .sysmem_icb_rsp_rdata  (sysmem_icb_rsp_rdata),
 
    .qspi0_ro_icb_cmd_valid  (qspi0_ro_icb_cmd_valid), 
    .qspi0_ro_icb_cmd_ready  (qspi0_ro_icb_cmd_ready),
    .qspi0_ro_icb_cmd_addr   (qspi0_ro_icb_cmd_addr ),
    .qspi0_ro_icb_cmd_read   (qspi0_ro_icb_cmd_read ),
    .qspi0_ro_icb_cmd_wdata  (qspi0_ro_icb_cmd_wdata),
                             
    .qspi0_ro_icb_rsp_valid  (qspi0_ro_icb_rsp_valid),
    .qspi0_ro_icb_rsp_ready  (qspi0_ro_icb_rsp_ready),
    .qspi0_ro_icb_rsp_err    (1'b0  ),
    .qspi0_ro_icb_rsp_rdata  (qspi0_ro_icb_rsp_rdata),
                           
    .otp_ro_icb_cmd_valid    (otp_ro_icb_cmd_valid  ),
    .otp_ro_icb_cmd_ready    (otp_ro_icb_cmd_ready  ),
    .otp_ro_icb_cmd_addr     (otp_ro_icb_cmd_addr   ),
    .otp_ro_icb_cmd_read     (otp_ro_icb_cmd_read   ),
    .otp_ro_icb_cmd_wdata    (otp_ro_icb_cmd_wdata  ),
                          
    .otp_ro_icb_rsp_valid    (otp_ro_icb_rsp_valid  ),
    .otp_ro_icb_rsp_ready    (otp_ro_icb_rsp_ready  ),
    .otp_ro_icb_rsp_err      (1'b0    ),
    .otp_ro_icb_rsp_rdata    (otp_ro_icb_rsp_rdata  ),

    .dm_icb_cmd_valid    (dm_icb_cmd_valid  ),
    .dm_icb_cmd_ready    (dm_icb_cmd_ready  ),
    .dm_icb_cmd_addr     (dm_icb_cmd_addr   ),
    .dm_icb_cmd_read     (dm_icb_cmd_read   ),
    .dm_icb_cmd_wdata    (dm_icb_cmd_wdata  ),
     
    .dm_icb_rsp_valid    (dm_icb_rsp_valid  ),
    .dm_icb_rsp_ready    (dm_icb_rsp_ready  ),
    .dm_icb_rsp_rdata    (dm_icb_rsp_rdata  ),

    .clk           (hfclk  ),
    .bus_rst_n     (bus_rst_n), 
    .rst_n         (per_rst_n) 
  );



`ifdef FAKE_FLASH_MODEL//{
fake_qspi0_model_top u_fake_qspi0_model_top(
    .icb_cmd_valid  (qspi0_ro_icb_cmd_valid), 
    .icb_cmd_ready  (qspi0_ro_icb_cmd_ready),
    .icb_cmd_addr   (qspi0_ro_icb_cmd_addr ),
    .icb_cmd_read   (qspi0_ro_icb_cmd_read ),
    .icb_cmd_wdata  (qspi0_ro_icb_cmd_wdata),
                    
    .icb_rsp_valid  (qspi0_ro_icb_rsp_valid),
    .icb_rsp_ready  (qspi0_ro_icb_rsp_ready),
    .icb_rsp_rdata  (qspi0_ro_icb_rsp_rdata),

    .clk            (hfclk    ),
    .rst_n          (bus_rst_n)  
  );
`endif//}


endmodule
