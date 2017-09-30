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
//  The Subsystem-TOP module to implement CPU and some closely coupled devices
//
// ====================================================================


`include "e203_defines.v"

module e203_subsys_top(
  input  hfclk, 
  output hfclkrst,

  input  [`E203_PC_SIZE-1:0] pc_rtvec,

  input  io_pads_aon_erst_n_i_ival,
  output io_pads_aon_erst_n_o_oval,
  output io_pads_aon_erst_n_o_oe,
  output io_pads_aon_erst_n_o_ie,
  output io_pads_aon_erst_n_o_pue,
  output io_pads_aon_erst_n_o_ds,
  input  io_pads_aon_lfextclk_i_ival,
  output io_pads_aon_lfextclk_o_oval,
  output io_pads_aon_lfextclk_o_oe,
  output io_pads_aon_lfextclk_o_ie,
  output io_pads_aon_lfextclk_o_pue,
  output io_pads_aon_lfextclk_o_ds,
  input  io_pads_aon_pmu_dwakeup_n_i_ival,
  output io_pads_aon_pmu_dwakeup_n_o_oval,
  output io_pads_aon_pmu_dwakeup_n_o_oe,
  output io_pads_aon_pmu_dwakeup_n_o_ie,
  output io_pads_aon_pmu_dwakeup_n_o_pue,
  output io_pads_aon_pmu_dwakeup_n_o_ds,
  input  io_pads_aon_pmu_vddpaden_i_ival,
  output io_pads_aon_pmu_vddpaden_o_oval,
  output io_pads_aon_pmu_vddpaden_o_oe,
  output io_pads_aon_pmu_vddpaden_o_ie,
  output io_pads_aon_pmu_vddpaden_o_pue,
  output io_pads_aon_pmu_vddpaden_o_ds,

  input  [`E203_HART_ID_W-1:0] core_mhartid,  
    
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

  input   io_pads_jtag_TCK_i_ival,
  output  io_pads_jtag_TCK_o_oval,
  output  io_pads_jtag_TCK_o_oe,
  output  io_pads_jtag_TCK_o_ie,
  output  io_pads_jtag_TCK_o_pue,
  output  io_pads_jtag_TCK_o_ds,
  input   io_pads_jtag_TMS_i_ival,
  output  io_pads_jtag_TMS_o_oval,
  output  io_pads_jtag_TMS_o_oe,
  output  io_pads_jtag_TMS_o_ie,
  output  io_pads_jtag_TMS_o_pue,
  output  io_pads_jtag_TMS_o_ds,
  input   io_pads_jtag_TDI_i_ival,
  output  io_pads_jtag_TDI_o_oval,
  output  io_pads_jtag_TDI_o_oe,
  output  io_pads_jtag_TDI_o_ie,
  output  io_pads_jtag_TDI_o_pue,
  output  io_pads_jtag_TDI_o_ds,
  input   io_pads_jtag_TDO_i_ival,
  output  io_pads_jtag_TDO_o_oval,
  output  io_pads_jtag_TDO_o_oe,
  output  io_pads_jtag_TDO_o_ie,
  output  io_pads_jtag_TDO_o_pue,
  output  io_pads_jtag_TDO_o_ds,
  input   io_pads_jtag_TRST_n_i_ival,
  output  io_pads_jtag_TRST_n_o_oval,
  output  io_pads_jtag_TRST_n_o_oe,
  output  io_pads_jtag_TRST_n_o_ie,
  output  io_pads_jtag_TRST_n_o_pue,
  output  io_pads_jtag_TRST_n_o_ds,

  input  test_iso_override,
  input  test_mode 
  );

  wire  aon_pmu_tcmretion;
  wire  aon_pmu_tcmshutdw;

  ///////////////////////////////////////
  wire [`E203_HART_NUM-1:0] dbg_irq;

  wire  [`E203_PC_SIZE-1:0] cmt_dpc;
  wire  cmt_dpc_ena;

  wire  [3-1:0] cmt_dcause;
  wire  cmt_dcause_ena;

  wire  dbg_irq_r;

  wire  wr_dcsr_ena;
  wire  wr_dpc_ena ;
  wire  wr_dscratch_ena;

  wire  [32-1:0] wr_csr_nxt;



  wire  [32-1:0] dcsr_r    ;
  wire  [`E203_PC_SIZE-1:0] dpc_r     ;
  wire  [32-1:0] dscratch_r;

  wire  dbg_mode;
  wire  dbg_halt_r;
  wire  dbg_step_r;
  wire  dbg_ebreakm_r;
  wire  dbg_stopcycle;


  wire  tcm_ds = aon_pmu_tcmretion;
  wire  tcm_sd = aon_pmu_tcmshutdw;


  wire                          dm_icb_cmd_valid;
  wire                          dm_icb_cmd_ready;
  wire  [`E203_ADDR_SIZE-1:0]   dm_icb_cmd_addr; 
  wire                          dm_icb_cmd_read; 
  wire  [`E203_XLEN-1:0]        dm_icb_cmd_wdata;
  //
  wire                          dm_icb_rsp_valid;
  wire                          dm_icb_rsp_ready;
  wire  [`E203_XLEN-1:0]        dm_icb_rsp_rdata;

  wire  aon_wdg_irq_a   ;
  wire  aon_rtc_irq_a   ;
  wire  aon_rtcToggle_a ;
  wire  aon_pmu_moff_isolate;

  wire                          aon_icb_cmd_valid;
  wire                          aon_icb_cmd_ready;
  wire  [`E203_ADDR_SIZE-1:0]   aon_icb_cmd_addr; 
  wire                          aon_icb_cmd_read; 
  wire  [`E203_XLEN-1:0]        aon_icb_cmd_wdata;
  //
  wire                          aon_icb_rsp_valid;
  wire                          aon_icb_rsp_ready;
  wire  [`E203_XLEN-1:0]        aon_icb_rsp_rdata;

  wire main_reset;
  wire jtag_reset;
  wire core_wfi;

  e203_subsys_main  u_e203_subsys_main(
    .pc_rtvec        (pc_rtvec),

    .tcm_ds          (tcm_ds),
    .tcm_sd          (tcm_sd),

    .core_wfi        (core_wfi),

    .dbg_irq_r       (dbg_irq_r      ),

    .cmt_dpc         (cmt_dpc        ),
    .cmt_dpc_ena     (cmt_dpc_ena    ),
    .cmt_dcause      (cmt_dcause     ),
    .cmt_dcause_ena  (cmt_dcause_ena ),

    .wr_dcsr_ena     (wr_dcsr_ena    ),
    .wr_dpc_ena      (wr_dpc_ena     ),
    .wr_dscratch_ena (wr_dscratch_ena),
                                     
    .wr_csr_nxt      (wr_csr_nxt     ),
                                     


    .dcsr_r          (dcsr_r         ),
    .dpc_r           (dpc_r          ),
    .dscratch_r      (dscratch_r     ),

    .dbg_mode        (dbg_mode),
    .dbg_halt_r      (dbg_halt_r),
    .dbg_step_r      (dbg_step_r),
    .dbg_ebreakm_r   (dbg_ebreakm_r),
    .dbg_stopcycle   (dbg_stopcycle),


    .core_mhartid            (core_mhartid),  
    .dbg_irq_a               (dbg_irq[0]),
    
    .aon_wdg_irq_a           (aon_wdg_irq_a     ),      
    .aon_rtc_irq_a           (aon_rtc_irq_a     ),
    .aon_rtcToggle_a         (aon_rtcToggle_a   ),
                             
    .aon_icb_cmd_valid       (aon_icb_cmd_valid ),
    .aon_icb_cmd_ready       (aon_icb_cmd_ready ),
    .aon_icb_cmd_addr        (aon_icb_cmd_addr  ),
    .aon_icb_cmd_read        (aon_icb_cmd_read  ),
    .aon_icb_cmd_wdata       (aon_icb_cmd_wdata ),
                            
    .aon_icb_rsp_valid       (aon_icb_rsp_valid ),
    .aon_icb_rsp_ready       (aon_icb_rsp_ready ),
    .aon_icb_rsp_err         (1'b0   ),
    .aon_icb_rsp_rdata       (aon_icb_rsp_rdata ),

    .dm_icb_cmd_valid         (dm_icb_cmd_valid),
    .dm_icb_cmd_ready         (dm_icb_cmd_ready),
    .dm_icb_cmd_addr          (dm_icb_cmd_addr ),
    .dm_icb_cmd_read          (dm_icb_cmd_read ),
    .dm_icb_cmd_wdata         (dm_icb_cmd_wdata),
    
    .dm_icb_rsp_valid         (dm_icb_rsp_valid),
    .dm_icb_rsp_ready         (dm_icb_rsp_ready),
    .dm_icb_rsp_rdata         (dm_icb_rsp_rdata),

    .io_pads_gpio_0_i_ival           (io_pads_gpio_0_i_ival),
    .io_pads_gpio_0_o_oval           (io_pads_gpio_0_o_oval),
    .io_pads_gpio_0_o_oe             (io_pads_gpio_0_o_oe),
    .io_pads_gpio_0_o_ie             (io_pads_gpio_0_o_ie),
    .io_pads_gpio_0_o_pue            (io_pads_gpio_0_o_pue),
    .io_pads_gpio_0_o_ds             (io_pads_gpio_0_o_ds),
    .io_pads_gpio_1_i_ival           (io_pads_gpio_1_i_ival),
    .io_pads_gpio_1_o_oval           (io_pads_gpio_1_o_oval),
    .io_pads_gpio_1_o_oe             (io_pads_gpio_1_o_oe),
    .io_pads_gpio_1_o_ie             (io_pads_gpio_1_o_ie),
    .io_pads_gpio_1_o_pue            (io_pads_gpio_1_o_pue),
    .io_pads_gpio_1_o_ds             (io_pads_gpio_1_o_ds),
    .io_pads_gpio_2_i_ival           (io_pads_gpio_2_i_ival),
    .io_pads_gpio_2_o_oval           (io_pads_gpio_2_o_oval),
    .io_pads_gpio_2_o_oe             (io_pads_gpio_2_o_oe),
    .io_pads_gpio_2_o_ie             (io_pads_gpio_2_o_ie),
    .io_pads_gpio_2_o_pue            (io_pads_gpio_2_o_pue),
    .io_pads_gpio_2_o_ds             (io_pads_gpio_2_o_ds),
    .io_pads_gpio_3_i_ival           (io_pads_gpio_3_i_ival),
    .io_pads_gpio_3_o_oval           (io_pads_gpio_3_o_oval),
    .io_pads_gpio_3_o_oe             (io_pads_gpio_3_o_oe),
    .io_pads_gpio_3_o_ie             (io_pads_gpio_3_o_ie),
    .io_pads_gpio_3_o_pue            (io_pads_gpio_3_o_pue),
    .io_pads_gpio_3_o_ds             (io_pads_gpio_3_o_ds),
    .io_pads_gpio_4_i_ival           (io_pads_gpio_4_i_ival),
    .io_pads_gpio_4_o_oval           (io_pads_gpio_4_o_oval),
    .io_pads_gpio_4_o_oe             (io_pads_gpio_4_o_oe),
    .io_pads_gpio_4_o_ie             (io_pads_gpio_4_o_ie),
    .io_pads_gpio_4_o_pue            (io_pads_gpio_4_o_pue),
    .io_pads_gpio_4_o_ds             (io_pads_gpio_4_o_ds),
    .io_pads_gpio_5_i_ival           (io_pads_gpio_5_i_ival),
    .io_pads_gpio_5_o_oval           (io_pads_gpio_5_o_oval),
    .io_pads_gpio_5_o_oe             (io_pads_gpio_5_o_oe),
    .io_pads_gpio_5_o_ie             (io_pads_gpio_5_o_ie),
    .io_pads_gpio_5_o_pue            (io_pads_gpio_5_o_pue),
    .io_pads_gpio_5_o_ds             (io_pads_gpio_5_o_ds),
    .io_pads_gpio_6_i_ival           (io_pads_gpio_6_i_ival),
    .io_pads_gpio_6_o_oval           (io_pads_gpio_6_o_oval),
    .io_pads_gpio_6_o_oe             (io_pads_gpio_6_o_oe),
    .io_pads_gpio_6_o_ie             (io_pads_gpio_6_o_ie),
    .io_pads_gpio_6_o_pue            (io_pads_gpio_6_o_pue),
    .io_pads_gpio_6_o_ds             (io_pads_gpio_6_o_ds),
    .io_pads_gpio_7_i_ival           (io_pads_gpio_7_i_ival),
    .io_pads_gpio_7_o_oval           (io_pads_gpio_7_o_oval),
    .io_pads_gpio_7_o_oe             (io_pads_gpio_7_o_oe),
    .io_pads_gpio_7_o_ie             (io_pads_gpio_7_o_ie),
    .io_pads_gpio_7_o_pue            (io_pads_gpio_7_o_pue),
    .io_pads_gpio_7_o_ds             (io_pads_gpio_7_o_ds),
    .io_pads_gpio_8_i_ival           (io_pads_gpio_8_i_ival),
    .io_pads_gpio_8_o_oval           (io_pads_gpio_8_o_oval),
    .io_pads_gpio_8_o_oe             (io_pads_gpio_8_o_oe),
    .io_pads_gpio_8_o_ie             (io_pads_gpio_8_o_ie),
    .io_pads_gpio_8_o_pue            (io_pads_gpio_8_o_pue),
    .io_pads_gpio_8_o_ds             (io_pads_gpio_8_o_ds),
    .io_pads_gpio_9_i_ival           (io_pads_gpio_9_i_ival),
    .io_pads_gpio_9_o_oval           (io_pads_gpio_9_o_oval),
    .io_pads_gpio_9_o_oe             (io_pads_gpio_9_o_oe),
    .io_pads_gpio_9_o_ie             (io_pads_gpio_9_o_ie),
    .io_pads_gpio_9_o_pue            (io_pads_gpio_9_o_pue),
    .io_pads_gpio_9_o_ds             (io_pads_gpio_9_o_ds),
    .io_pads_gpio_10_i_ival          (io_pads_gpio_10_i_ival),
    .io_pads_gpio_10_o_oval          (io_pads_gpio_10_o_oval),
    .io_pads_gpio_10_o_oe            (io_pads_gpio_10_o_oe),
    .io_pads_gpio_10_o_ie            (io_pads_gpio_10_o_ie),
    .io_pads_gpio_10_o_pue           (io_pads_gpio_10_o_pue),
    .io_pads_gpio_10_o_ds            (io_pads_gpio_10_o_ds),
    .io_pads_gpio_11_i_ival          (io_pads_gpio_11_i_ival),
    .io_pads_gpio_11_o_oval          (io_pads_gpio_11_o_oval),
    .io_pads_gpio_11_o_oe            (io_pads_gpio_11_o_oe),
    .io_pads_gpio_11_o_ie            (io_pads_gpio_11_o_ie),
    .io_pads_gpio_11_o_pue           (io_pads_gpio_11_o_pue),
    .io_pads_gpio_11_o_ds            (io_pads_gpio_11_o_ds),
    .io_pads_gpio_12_i_ival          (io_pads_gpio_12_i_ival),
    .io_pads_gpio_12_o_oval          (io_pads_gpio_12_o_oval),
    .io_pads_gpio_12_o_oe            (io_pads_gpio_12_o_oe),
    .io_pads_gpio_12_o_ie            (io_pads_gpio_12_o_ie),
    .io_pads_gpio_12_o_pue           (io_pads_gpio_12_o_pue),
    .io_pads_gpio_12_o_ds            (io_pads_gpio_12_o_ds),
    .io_pads_gpio_13_i_ival          (io_pads_gpio_13_i_ival),
    .io_pads_gpio_13_o_oval          (io_pads_gpio_13_o_oval),
    .io_pads_gpio_13_o_oe            (io_pads_gpio_13_o_oe),
    .io_pads_gpio_13_o_ie            (io_pads_gpio_13_o_ie),
    .io_pads_gpio_13_o_pue           (io_pads_gpio_13_o_pue),
    .io_pads_gpio_13_o_ds            (io_pads_gpio_13_o_ds),
    .io_pads_gpio_14_i_ival          (io_pads_gpio_14_i_ival),
    .io_pads_gpio_14_o_oval          (io_pads_gpio_14_o_oval),
    .io_pads_gpio_14_o_oe            (io_pads_gpio_14_o_oe),
    .io_pads_gpio_14_o_ie            (io_pads_gpio_14_o_ie),
    .io_pads_gpio_14_o_pue           (io_pads_gpio_14_o_pue),
    .io_pads_gpio_14_o_ds            (io_pads_gpio_14_o_ds),
    .io_pads_gpio_15_i_ival          (io_pads_gpio_15_i_ival),
    .io_pads_gpio_15_o_oval          (io_pads_gpio_15_o_oval),
    .io_pads_gpio_15_o_oe            (io_pads_gpio_15_o_oe),
    .io_pads_gpio_15_o_ie            (io_pads_gpio_15_o_ie),
    .io_pads_gpio_15_o_pue           (io_pads_gpio_15_o_pue),
    .io_pads_gpio_15_o_ds            (io_pads_gpio_15_o_ds),
    .io_pads_gpio_16_i_ival          (io_pads_gpio_16_i_ival),
    .io_pads_gpio_16_o_oval          (io_pads_gpio_16_o_oval),
    .io_pads_gpio_16_o_oe            (io_pads_gpio_16_o_oe),
    .io_pads_gpio_16_o_ie            (io_pads_gpio_16_o_ie),
    .io_pads_gpio_16_o_pue           (io_pads_gpio_16_o_pue),
    .io_pads_gpio_16_o_ds            (io_pads_gpio_16_o_ds),
    .io_pads_gpio_17_i_ival          (io_pads_gpio_17_i_ival),
    .io_pads_gpio_17_o_oval          (io_pads_gpio_17_o_oval),
    .io_pads_gpio_17_o_oe            (io_pads_gpio_17_o_oe),
    .io_pads_gpio_17_o_ie            (io_pads_gpio_17_o_ie),
    .io_pads_gpio_17_o_pue           (io_pads_gpio_17_o_pue),
    .io_pads_gpio_17_o_ds            (io_pads_gpio_17_o_ds),
    .io_pads_gpio_18_i_ival          (io_pads_gpio_18_i_ival),
    .io_pads_gpio_18_o_oval          (io_pads_gpio_18_o_oval),
    .io_pads_gpio_18_o_oe            (io_pads_gpio_18_o_oe),
    .io_pads_gpio_18_o_ie            (io_pads_gpio_18_o_ie),
    .io_pads_gpio_18_o_pue           (io_pads_gpio_18_o_pue),
    .io_pads_gpio_18_o_ds            (io_pads_gpio_18_o_ds),
    .io_pads_gpio_19_i_ival          (io_pads_gpio_19_i_ival),
    .io_pads_gpio_19_o_oval          (io_pads_gpio_19_o_oval),
    .io_pads_gpio_19_o_oe            (io_pads_gpio_19_o_oe),
    .io_pads_gpio_19_o_ie            (io_pads_gpio_19_o_ie),
    .io_pads_gpio_19_o_pue           (io_pads_gpio_19_o_pue),
    .io_pads_gpio_19_o_ds            (io_pads_gpio_19_o_ds),
    .io_pads_gpio_20_i_ival          (io_pads_gpio_20_i_ival),
    .io_pads_gpio_20_o_oval          (io_pads_gpio_20_o_oval),
    .io_pads_gpio_20_o_oe            (io_pads_gpio_20_o_oe),
    .io_pads_gpio_20_o_ie            (io_pads_gpio_20_o_ie),
    .io_pads_gpio_20_o_pue           (io_pads_gpio_20_o_pue),
    .io_pads_gpio_20_o_ds            (io_pads_gpio_20_o_ds),
    .io_pads_gpio_21_i_ival          (io_pads_gpio_21_i_ival),
    .io_pads_gpio_21_o_oval          (io_pads_gpio_21_o_oval),
    .io_pads_gpio_21_o_oe            (io_pads_gpio_21_o_oe),
    .io_pads_gpio_21_o_ie            (io_pads_gpio_21_o_ie),
    .io_pads_gpio_21_o_pue           (io_pads_gpio_21_o_pue),
    .io_pads_gpio_21_o_ds            (io_pads_gpio_21_o_ds),
    .io_pads_gpio_22_i_ival          (io_pads_gpio_22_i_ival),
    .io_pads_gpio_22_o_oval          (io_pads_gpio_22_o_oval),
    .io_pads_gpio_22_o_oe            (io_pads_gpio_22_o_oe),
    .io_pads_gpio_22_o_ie            (io_pads_gpio_22_o_ie),
    .io_pads_gpio_22_o_pue           (io_pads_gpio_22_o_pue),
    .io_pads_gpio_22_o_ds            (io_pads_gpio_22_o_ds),
    .io_pads_gpio_23_i_ival          (io_pads_gpio_23_i_ival),
    .io_pads_gpio_23_o_oval          (io_pads_gpio_23_o_oval),
    .io_pads_gpio_23_o_oe            (io_pads_gpio_23_o_oe),
    .io_pads_gpio_23_o_ie            (io_pads_gpio_23_o_ie),
    .io_pads_gpio_23_o_pue           (io_pads_gpio_23_o_pue),
    .io_pads_gpio_23_o_ds            (io_pads_gpio_23_o_ds),
    .io_pads_gpio_24_i_ival          (io_pads_gpio_24_i_ival),
    .io_pads_gpio_24_o_oval          (io_pads_gpio_24_o_oval),
    .io_pads_gpio_24_o_oe            (io_pads_gpio_24_o_oe),
    .io_pads_gpio_24_o_ie            (io_pads_gpio_24_o_ie),
    .io_pads_gpio_24_o_pue           (io_pads_gpio_24_o_pue),
    .io_pads_gpio_24_o_ds            (io_pads_gpio_24_o_ds),
    .io_pads_gpio_25_i_ival          (io_pads_gpio_25_i_ival),
    .io_pads_gpio_25_o_oval          (io_pads_gpio_25_o_oval),
    .io_pads_gpio_25_o_oe            (io_pads_gpio_25_o_oe),
    .io_pads_gpio_25_o_ie            (io_pads_gpio_25_o_ie),
    .io_pads_gpio_25_o_pue           (io_pads_gpio_25_o_pue),
    .io_pads_gpio_25_o_ds            (io_pads_gpio_25_o_ds),
    .io_pads_gpio_26_i_ival          (io_pads_gpio_26_i_ival),
    .io_pads_gpio_26_o_oval          (io_pads_gpio_26_o_oval),
    .io_pads_gpio_26_o_oe            (io_pads_gpio_26_o_oe),
    .io_pads_gpio_26_o_ie            (io_pads_gpio_26_o_ie),
    .io_pads_gpio_26_o_pue           (io_pads_gpio_26_o_pue),
    .io_pads_gpio_26_o_ds            (io_pads_gpio_26_o_ds),
    .io_pads_gpio_27_i_ival          (io_pads_gpio_27_i_ival),
    .io_pads_gpio_27_o_oval          (io_pads_gpio_27_o_oval),
    .io_pads_gpio_27_o_oe            (io_pads_gpio_27_o_oe),
    .io_pads_gpio_27_o_ie            (io_pads_gpio_27_o_ie),
    .io_pads_gpio_27_o_pue           (io_pads_gpio_27_o_pue),
    .io_pads_gpio_27_o_ds            (io_pads_gpio_27_o_ds),
    .io_pads_gpio_28_i_ival          (io_pads_gpio_28_i_ival),
    .io_pads_gpio_28_o_oval          (io_pads_gpio_28_o_oval),
    .io_pads_gpio_28_o_oe            (io_pads_gpio_28_o_oe),
    .io_pads_gpio_28_o_ie            (io_pads_gpio_28_o_ie),
    .io_pads_gpio_28_o_pue           (io_pads_gpio_28_o_pue),
    .io_pads_gpio_28_o_ds            (io_pads_gpio_28_o_ds),
    .io_pads_gpio_29_i_ival          (io_pads_gpio_29_i_ival),
    .io_pads_gpio_29_o_oval          (io_pads_gpio_29_o_oval),
    .io_pads_gpio_29_o_oe            (io_pads_gpio_29_o_oe),
    .io_pads_gpio_29_o_ie            (io_pads_gpio_29_o_ie),
    .io_pads_gpio_29_o_pue           (io_pads_gpio_29_o_pue),
    .io_pads_gpio_29_o_ds            (io_pads_gpio_29_o_ds),
    .io_pads_gpio_30_i_ival          (io_pads_gpio_30_i_ival),
    .io_pads_gpio_30_o_oval          (io_pads_gpio_30_o_oval),
    .io_pads_gpio_30_o_oe            (io_pads_gpio_30_o_oe),
    .io_pads_gpio_30_o_ie            (io_pads_gpio_30_o_ie),
    .io_pads_gpio_30_o_pue           (io_pads_gpio_30_o_pue),
    .io_pads_gpio_30_o_ds            (io_pads_gpio_30_o_ds),
    .io_pads_gpio_31_i_ival          (io_pads_gpio_31_i_ival),
    .io_pads_gpio_31_o_oval          (io_pads_gpio_31_o_oval),
    .io_pads_gpio_31_o_oe            (io_pads_gpio_31_o_oe),
    .io_pads_gpio_31_o_ie            (io_pads_gpio_31_o_ie),
    .io_pads_gpio_31_o_pue           (io_pads_gpio_31_o_pue),
    .io_pads_gpio_31_o_ds            (io_pads_gpio_31_o_ds),

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


    .sysper_icb_cmd_valid     (sysper_icb_cmd_valid),
    .sysper_icb_cmd_ready     (sysper_icb_cmd_ready),
    .sysper_icb_cmd_addr      (sysper_icb_cmd_addr ),
    .sysper_icb_cmd_read      (sysper_icb_cmd_read ),
    .sysper_icb_cmd_wdata     (sysper_icb_cmd_wdata),
    .sysper_icb_cmd_wmask     (sysper_icb_cmd_wmask),
    
    .sysper_icb_rsp_valid     (sysper_icb_rsp_valid),
    .sysper_icb_rsp_ready     (sysper_icb_rsp_ready),
    .sysper_icb_rsp_err       (sysper_icb_rsp_err  ),
    .sysper_icb_rsp_rdata     (sysper_icb_rsp_rdata),

    .sysfio_icb_cmd_valid     (sysfio_icb_cmd_valid),
    .sysfio_icb_cmd_ready     (sysfio_icb_cmd_ready),
    .sysfio_icb_cmd_addr      (sysfio_icb_cmd_addr ),
    .sysfio_icb_cmd_read      (sysfio_icb_cmd_read ),
    .sysfio_icb_cmd_wdata     (sysfio_icb_cmd_wdata),
    .sysfio_icb_cmd_wmask     (sysfio_icb_cmd_wmask),
    
    .sysfio_icb_rsp_valid     (sysfio_icb_rsp_valid),
    .sysfio_icb_rsp_ready     (sysfio_icb_rsp_ready),
    .sysfio_icb_rsp_err       (sysfio_icb_rsp_err  ),
    .sysfio_icb_rsp_rdata     (sysfio_icb_rsp_rdata),



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

    .test_mode     (test_mode), 
    .clk           (hfclk  ),
    .rst_n         (~main_reset)
  );

  //We need to add DM individual power domain, hence need power up reset for it individually
  wire dm_pu_reset = 1'b0;
  wire dm_reset = test_mode ? io_pads_aon_erst_n_i_ival : 
                  (main_reset | dm_pu_reset); 

  sirv_debug_module # (
    `ifdef E203_DEBUG_HAS_JTAG //{
      .SUPPORT_JTAG_DTM (1),
    `else//}{
      .SUPPORT_JTAG_DTM (0),
    `endif//}
      .ASYNC_FF_LEVELS (`E203_ASYNC_FF_LEVELS),
      .HART_NUM (`E203_HART_NUM),
      .PC_SIZE  (`E203_PC_SIZE),
      .HART_ID_W(`E203_HART_ID_W) 
    ) u_sirv_debug_module(

    .dbg_irq_r       (dbg_irq_r      ),

    .cmt_dpc         (cmt_dpc        ),
    .cmt_dpc_ena     (cmt_dpc_ena    ),
    .cmt_dcause      (cmt_dcause     ),
    .cmt_dcause_ena  (cmt_dcause_ena ),

    .wr_dcsr_ena     (wr_dcsr_ena    ),
    .wr_dpc_ena      (wr_dpc_ena     ),
    .wr_dscratch_ena (wr_dscratch_ena),
                                     
    .wr_csr_nxt      (wr_csr_nxt     ),
                                     

    .dcsr_r          (dcsr_r         ),
    .dpc_r           (dpc_r          ),
    .dscratch_r      (dscratch_r     ),

    .dbg_mode        (dbg_mode),
    .dbg_halt_r      (dbg_halt_r),
    .dbg_step_r      (dbg_step_r),
    .dbg_ebreakm_r   (dbg_ebreakm_r),
    .dbg_stopcycle   (dbg_stopcycle),

    .io_pads_jtag_TCK_i_ival     (io_pads_jtag_TCK_i_ival    ),
    .io_pads_jtag_TCK_o_oval     (io_pads_jtag_TCK_o_oval    ),
    .io_pads_jtag_TCK_o_oe       (io_pads_jtag_TCK_o_oe      ),
    .io_pads_jtag_TCK_o_ie       (io_pads_jtag_TCK_o_ie      ),
    .io_pads_jtag_TCK_o_pue      (io_pads_jtag_TCK_o_pue     ),
    .io_pads_jtag_TCK_o_ds       (io_pads_jtag_TCK_o_ds      ),
    .io_pads_jtag_TMS_i_ival     (io_pads_jtag_TMS_i_ival    ),
    .io_pads_jtag_TMS_o_oval     (io_pads_jtag_TMS_o_oval    ),
    .io_pads_jtag_TMS_o_oe       (io_pads_jtag_TMS_o_oe      ),
    .io_pads_jtag_TMS_o_ie       (io_pads_jtag_TMS_o_ie      ),
    .io_pads_jtag_TMS_o_pue      (io_pads_jtag_TMS_o_pue     ),
    .io_pads_jtag_TMS_o_ds       (io_pads_jtag_TMS_o_ds      ),
    .io_pads_jtag_TDI_i_ival     (io_pads_jtag_TDI_i_ival    ),
    .io_pads_jtag_TDI_o_oval     (io_pads_jtag_TDI_o_oval    ),
    .io_pads_jtag_TDI_o_oe       (io_pads_jtag_TDI_o_oe      ),
    .io_pads_jtag_TDI_o_ie       (io_pads_jtag_TDI_o_ie      ),
    .io_pads_jtag_TDI_o_pue      (io_pads_jtag_TDI_o_pue     ),
    .io_pads_jtag_TDI_o_ds       (io_pads_jtag_TDI_o_ds      ),
    .io_pads_jtag_TDO_i_ival     (io_pads_jtag_TDO_i_ival    ),
    .io_pads_jtag_TDO_o_oval     (io_pads_jtag_TDO_o_oval    ),
    .io_pads_jtag_TDO_o_oe       (io_pads_jtag_TDO_o_oe      ),
    .io_pads_jtag_TDO_o_ie       (io_pads_jtag_TDO_o_ie      ),
    .io_pads_jtag_TDO_o_pue      (io_pads_jtag_TDO_o_pue     ),
    .io_pads_jtag_TDO_o_ds       (io_pads_jtag_TDO_o_ds      ),
    .io_pads_jtag_TRST_n_i_ival  (io_pads_jtag_TRST_n_i_ival ),
    .io_pads_jtag_TRST_n_o_oval  (io_pads_jtag_TRST_n_o_oval ),
    .io_pads_jtag_TRST_n_o_oe    (io_pads_jtag_TRST_n_o_oe   ),
    .io_pads_jtag_TRST_n_o_ie    (io_pads_jtag_TRST_n_o_ie   ),
    .io_pads_jtag_TRST_n_o_pue   (io_pads_jtag_TRST_n_o_pue  ),
    .io_pads_jtag_TRST_n_o_ds    (io_pads_jtag_TRST_n_o_ds   ),

    .jtag_reset              (jtag_reset),

    .i_icb_cmd_valid         (dm_icb_cmd_valid),
    .i_icb_cmd_ready         (dm_icb_cmd_ready),
    .i_icb_cmd_addr          (dm_icb_cmd_addr[11:0] ),
    .i_icb_cmd_read          (dm_icb_cmd_read ),
    .i_icb_cmd_wdata         (dm_icb_cmd_wdata),
    
    .i_icb_rsp_valid         (dm_icb_rsp_valid),
    .i_icb_rsp_ready         (dm_icb_rsp_ready),
    .i_icb_rsp_rdata         (dm_icb_rsp_rdata),

    .o_dbg_irq               (dbg_irq),
    .o_ndreset               (),
    .o_fullreset             (),

    .core_clk        (hfclk),
    .dm_clk          (hfclk),
    .dm_rst_n        (~dm_reset) 
  );

  wire corerst;

  sirv_aon_top u_sirv_aon_top(
    .core_wfi                (core_wfi),

    .i_icb_cmd_valid         (aon_icb_cmd_valid),
    .i_icb_cmd_ready         (aon_icb_cmd_ready),
    .i_icb_cmd_addr          (aon_icb_cmd_addr ),
    .i_icb_cmd_read          (aon_icb_cmd_read ),
    .i_icb_cmd_wdata         (aon_icb_cmd_wdata),
    
    .i_icb_rsp_valid         (aon_icb_rsp_valid),
    .i_icb_rsp_ready         (aon_icb_rsp_ready),
    .i_icb_rsp_rdata         (aon_icb_rsp_rdata),

    .aon_wdg_irq             (aon_wdg_irq_a     ),      
    .aon_rtc_irq             (aon_rtc_irq_a     ),
    .aon_rtcToggle           (aon_rtcToggle_a   ),

    .aon_pmu_moff_isolate    (aon_pmu_moff_isolate),
    .test_mode               (test_mode           ),
    .test_iso_override       (test_iso_override   ),

    .io_pads_aon_erst_n_i_ival        (io_pads_aon_erst_n_i_ival       ), 
    .io_pads_aon_erst_n_o_oval        (io_pads_aon_erst_n_o_oval       ),
    .io_pads_aon_erst_n_o_oe          (io_pads_aon_erst_n_o_oe         ),
    .io_pads_aon_erst_n_o_ie          (io_pads_aon_erst_n_o_ie         ),
    .io_pads_aon_erst_n_o_pue         (io_pads_aon_erst_n_o_pue        ),
    .io_pads_aon_erst_n_o_ds          (io_pads_aon_erst_n_o_ds         ),
    .io_pads_aon_lfextclk_i_ival      (io_pads_aon_lfextclk_i_ival     ),
    .io_pads_aon_lfextclk_o_oval      (io_pads_aon_lfextclk_o_oval     ),
    .io_pads_aon_lfextclk_o_oe        (io_pads_aon_lfextclk_o_oe       ),
    .io_pads_aon_lfextclk_o_ie        (io_pads_aon_lfextclk_o_ie       ),
    .io_pads_aon_lfextclk_o_pue       (io_pads_aon_lfextclk_o_pue      ),
    .io_pads_aon_lfextclk_o_ds        (io_pads_aon_lfextclk_o_ds       ),
    .io_pads_aon_pmu_dwakeup_n_i_ival (io_pads_aon_pmu_dwakeup_n_i_ival),
    .io_pads_aon_pmu_dwakeup_n_o_oval (io_pads_aon_pmu_dwakeup_n_o_oval),
    .io_pads_aon_pmu_dwakeup_n_o_oe   (io_pads_aon_pmu_dwakeup_n_o_oe  ),
    .io_pads_aon_pmu_dwakeup_n_o_ie   (io_pads_aon_pmu_dwakeup_n_o_ie  ),
    .io_pads_aon_pmu_dwakeup_n_o_pue  (io_pads_aon_pmu_dwakeup_n_o_pue ),
    .io_pads_aon_pmu_dwakeup_n_o_ds   (io_pads_aon_pmu_dwakeup_n_o_ds  ),
    .io_pads_aon_pmu_vddpaden_i_ival  (io_pads_aon_pmu_vddpaden_i_ival ),
    .io_pads_aon_pmu_vddpaden_o_oval  (io_pads_aon_pmu_vddpaden_o_oval ),
    .io_pads_aon_pmu_vddpaden_o_oe    (io_pads_aon_pmu_vddpaden_o_oe   ),
    .io_pads_aon_pmu_vddpaden_o_ie    (io_pads_aon_pmu_vddpaden_o_ie   ),
    .io_pads_aon_pmu_vddpaden_o_pue   (io_pads_aon_pmu_vddpaden_o_pue  ),
    .io_pads_aon_pmu_vddpaden_o_ds    (io_pads_aon_pmu_vddpaden_o_ds   ),
    .aon_pmu_tcmretion                (aon_pmu_tcmretion),
    .aon_pmu_tcmshutdw                (aon_pmu_tcmshutdw),


    .hfclkrst      (hfclkrst),
    .corerst       (corerst)
  );

 sirv_ResetCatchAndSync_2 u_main_ResetCatchAndSync_2_1 (
    .test_mode(test_mode),
    .clock(hfclk),
    .reset(corerst),
    .io_sync_reset(main_reset)
  );

 wire jtag_TCK = io_pads_jtag_TCK_i_ival;

 sirv_ResetCatchAndSync u_jtag_ResetCatchAndSync_3_1 (
    .test_mode(test_mode),
    .clock(jtag_TCK),
    .reset(corerst),
    .io_sync_reset(jtag_reset)
  );


endmodule
