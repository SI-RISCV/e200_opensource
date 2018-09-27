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
//  The Core module to implement the core portion of the cpu
//
// ====================================================================

`include "e203_defines.v"

module e203_core(
  output[`E203_PC_SIZE-1:0] inspect_pc,

  `ifdef E203_HAS_CSR_EAI//{
  output         eai_csr_valid,
  input          eai_csr_ready,
  output  [31:0] eai_csr_addr,
  output         eai_csr_wr,
  output  [31:0] eai_csr_wdata,
  input   [31:0] eai_csr_rdata,
  `endif//}
  output core_wfi,
  output tm_stop,
  output core_cgstop,
  output tcm_cgstop,

  input  [`E203_PC_SIZE-1:0] pc_rtvec,

  input  [`E203_HART_ID_W-1:0] core_mhartid,
  input  dbg_irq_r,
  input  [`E203_LIRQ_NUM-1:0] lcl_irq_r,
  input  [`E203_EVT_NUM-1:0] evt_r,
  input  ext_irq_r,
  input  sft_irq_r,
  input  tmr_irq_r,

  //////////////////////////////////////////////////////////////
  // From/To debug ctrl module
  output  wr_dcsr_ena    ,
  output  wr_dpc_ena     ,
  output  wr_dscratch_ena,



  output  [32-1:0] wr_csr_nxt    ,

  input  [32-1:0] dcsr_r    ,
  input  [`E203_PC_SIZE-1:0] dpc_r     ,
  input  [32-1:0] dscratch_r,

  output  [`E203_PC_SIZE-1:0] cmt_dpc,
  output  cmt_dpc_ena,
  output  [3-1:0] cmt_dcause,
  output  cmt_dcause_ena,

  input  dbg_mode,
  input  dbg_halt_r,
  input  dbg_step_r,
  input  dbg_ebreakm_r,
  input  dbg_stopcycle,

  `ifdef E203_HAS_ITCM //{
  // The ITCM address region indication signal
  input [`E203_ADDR_SIZE-1:0] itcm_region_indic,
  input  ifu2itcm_holdup,
  //input  ifu2itcm_replay,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // Bus Interface to ITCM, internal protocol called ICB (Internal Chip Bus)
  //    * Bus cmd channel
  output ifu2itcm_icb_cmd_valid, // Handshake valid
  input  ifu2itcm_icb_cmd_ready, // Handshake ready
            // Note: The data on rdata or wdata channel must be naturally
            //       aligned, this is in line with the AXI definition
  output [`E203_ITCM_ADDR_WIDTH-1:0]   ifu2itcm_icb_cmd_addr, // Bus transaction start addr 

  //    * Bus RSP channel
  input  ifu2itcm_icb_rsp_valid, // Response valid 
  output ifu2itcm_icb_rsp_ready, // Response ready
  input  ifu2itcm_icb_rsp_err,   // Response error
            // Note: the RSP rdata is inline with AXI definition
  input  [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_rsp_rdata, 
  `endif//}


  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to Private Peripheral Interface
  input [`E203_ADDR_SIZE-1:0]    ppi_region_indic,
  //
  input                          ppi_icb_enable,
  //    * Bus cmd channel
  output                         ppi_icb_cmd_valid,
  input                          ppi_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   ppi_icb_cmd_addr, 
  output                         ppi_icb_cmd_read, 
  output [`E203_XLEN-1:0]        ppi_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      ppi_icb_cmd_wmask,
  output                         ppi_icb_cmd_lock,
  output                         ppi_icb_cmd_excl,
  output [1:0]                   ppi_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          ppi_icb_rsp_valid,
  output                         ppi_icb_rsp_ready,
  input                          ppi_icb_rsp_err  ,
  input                          ppi_icb_rsp_excl_ok  ,
  input  [`E203_XLEN-1:0]        ppi_icb_rsp_rdata,

  
  input [`E203_ADDR_SIZE-1:0]    clint_region_indic,
  input                          clint_icb_enable,

  output                         clint_icb_cmd_valid,
  input                          clint_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   clint_icb_cmd_addr, 
  output                         clint_icb_cmd_read, 
  output [`E203_XLEN-1:0]        clint_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      clint_icb_cmd_wmask,
  output                         clint_icb_cmd_lock,
  output                         clint_icb_cmd_excl,
  output [1:0]                   clint_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          clint_icb_rsp_valid,
  output                         clint_icb_rsp_ready,
  input                          clint_icb_rsp_err  ,
  input                          clint_icb_rsp_excl_ok  ,
  input  [`E203_XLEN-1:0]        clint_icb_rsp_rdata,

  input [`E203_ADDR_SIZE-1:0]    plic_region_indic,
  input                          plic_icb_enable,

  output                         plic_icb_cmd_valid,
  input                          plic_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   plic_icb_cmd_addr, 
  output                         plic_icb_cmd_read, 
  output [`E203_XLEN-1:0]        plic_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      plic_icb_cmd_wmask,
  output                         plic_icb_cmd_lock,
  output                         plic_icb_cmd_excl,
  output [1:0]                   plic_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          plic_icb_rsp_valid,
  output                         plic_icb_rsp_ready,
  input                          plic_icb_rsp_err  ,
  input                          plic_icb_rsp_excl_ok  ,
  input  [`E203_XLEN-1:0]        plic_icb_rsp_rdata,


  `ifdef E203_HAS_FIO //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to Fast I/O
  input [`E203_ADDR_SIZE-1:0]    fio_region_indic,
  //
  input                          fio_icb_enable,
  //    * Bus cmd channel
  output                         fio_icb_cmd_valid,
  input                          fio_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   fio_icb_cmd_addr, 
  output                         fio_icb_cmd_read, 
  output [`E203_XLEN-1:0]        fio_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      fio_icb_cmd_wmask,
  output                         fio_icb_cmd_lock,
  output                         fio_icb_cmd_excl,
  output [1:0]                   fio_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          fio_icb_rsp_valid,
  output                         fio_icb_rsp_ready,
  input                          fio_icb_rsp_err  ,
  input                          fio_icb_rsp_excl_ok  ,
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
  output                         mem_icb_cmd_lock,
  output                         mem_icb_cmd_excl,
  output [1:0]                   mem_icb_cmd_size,
  output [1:0]                   mem_icb_cmd_burst,
  output [1:0]                   mem_icb_cmd_beat,
  //
  //    * Bus RSP channel
  input                          mem_icb_rsp_valid,
  output                         mem_icb_rsp_ready,
  input                          mem_icb_rsp_err  ,
  input                          mem_icb_rsp_excl_ok  ,
  input  [`E203_XLEN-1:0]        mem_icb_rsp_rdata,
  `endif//}

  `ifdef E203_HAS_ITCM //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to ITCM
  //
  //    * Bus cmd channel
  output                         lsu2itcm_icb_cmd_valid,
  input                          lsu2itcm_icb_cmd_ready,
  output [`E203_ITCM_ADDR_WIDTH-1:0]   lsu2itcm_icb_cmd_addr, 
  output                         lsu2itcm_icb_cmd_read, 
  output [`E203_XLEN-1:0]        lsu2itcm_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      lsu2itcm_icb_cmd_wmask,
  output                         lsu2itcm_icb_cmd_lock,
  output                         lsu2itcm_icb_cmd_excl,
  output [1:0]                   lsu2itcm_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          lsu2itcm_icb_rsp_valid,
  output                         lsu2itcm_icb_rsp_ready,
  input                          lsu2itcm_icb_rsp_err  ,
  input                          lsu2itcm_icb_rsp_excl_ok  ,
  input  [`E203_XLEN-1:0]        lsu2itcm_icb_rsp_rdata,
  `endif//}

    `ifdef E203_HAS_DTCM //{
  input [`E203_ADDR_SIZE-1:0] dtcm_region_indic,
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to DTCM
  //
  //    * Bus cmd channel
  output                         lsu2dtcm_icb_cmd_valid,
  input                          lsu2dtcm_icb_cmd_ready,
  output [`E203_DTCM_ADDR_WIDTH-1:0]   lsu2dtcm_icb_cmd_addr, 
  output                         lsu2dtcm_icb_cmd_read, 
  output [`E203_XLEN-1:0]        lsu2dtcm_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      lsu2dtcm_icb_cmd_wmask,
  output                         lsu2dtcm_icb_cmd_lock,
  output                         lsu2dtcm_icb_cmd_excl,
  output [1:0]                   lsu2dtcm_icb_cmd_size,
  //
  //    * Bus RSP channel
  input                          lsu2dtcm_icb_rsp_valid,
  output                         lsu2dtcm_icb_rsp_ready,
  input                          lsu2dtcm_icb_rsp_err  ,
  input                          lsu2dtcm_icb_rsp_excl_ok,
  input  [`E203_XLEN-1:0]        lsu2dtcm_icb_rsp_rdata,
  `endif//}

  output exu_active,
  output ifu_active,
  output lsu_active,
  output biu_active,

  input  clk_core_ifu,
  input  clk_core_exu,
  input  clk_core_lsu,
  input  clk_core_biu,
  input  clk_aon,

  input test_mode,
  input  rst_n
  );

    `ifdef E203_HAS_MEM_ITF //{
  wire                         ifu2biu_icb_cmd_valid;
  wire                         ifu2biu_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   ifu2biu_icb_cmd_addr; 
  wire                         ifu2biu_icb_rsp_valid;
  wire                         ifu2biu_icb_rsp_ready;
  wire                         ifu2biu_icb_rsp_err  ;
  wire                         ifu2biu_icb_rsp_excl_ok;
  wire [`E203_XLEN-1:0]        ifu2biu_icb_rsp_rdata;
   
  `endif//}




  wire ifu_o_valid;
  wire ifu_o_ready;
  wire [`E203_INSTR_SIZE-1:0] ifu_o_ir;
  wire [`E203_PC_SIZE-1:0] ifu_o_pc;
  wire ifu_o_pc_vld; 
  wire ifu_o_misalgn; 
  wire ifu_o_buserr; 
  wire [`E203_RFIDX_WIDTH-1:0] ifu_o_rs1idx;
  wire [`E203_RFIDX_WIDTH-1:0] ifu_o_rs2idx;
  wire ifu_o_prdt_taken;
  wire ifu_o_muldiv_b2b;

  wire wfi_halt_ifu_req;
  wire wfi_halt_ifu_ack;
  wire pipe_flush_ack;
  wire pipe_flush_req;
  wire [`E203_PC_SIZE-1:0] pipe_flush_add_op1;  
  wire [`E203_PC_SIZE-1:0] pipe_flush_add_op2;  
  `ifdef E203_TIMING_BOOST//}
  wire [`E203_PC_SIZE-1:0] pipe_flush_pc;  
  `endif//}

  wire oitf_empty;
  wire [`E203_XLEN-1:0] rf2ifu_x1;
  wire [`E203_XLEN-1:0] rf2ifu_rs1;
  wire dec2ifu_rden;
  wire dec2ifu_rs1en;
  wire [`E203_RFIDX_WIDTH-1:0] dec2ifu_rdidx;
  wire dec2ifu_mulhsu;
  wire dec2ifu_div   ;
  wire dec2ifu_rem   ;
  wire dec2ifu_divu  ;
  wire dec2ifu_remu  ;


  wire itcm_nohold;

  e203_ifu u_e203_ifu(
    .inspect_pc   (inspect_pc),

    .ifu_active      (ifu_active),
    .pc_rtvec        (pc_rtvec),  

    .itcm_nohold     (itcm_nohold),

  `ifdef E203_HAS_ITCM //{
    .ifu2itcm_holdup (ifu2itcm_holdup),
    //.ifu2itcm_replay (ifu2itcm_replay),

  // The ITCM address region indication signal
    .itcm_region_indic (itcm_region_indic),

    .ifu2itcm_icb_cmd_valid(ifu2itcm_icb_cmd_valid),
    .ifu2itcm_icb_cmd_ready(ifu2itcm_icb_cmd_ready),
    .ifu2itcm_icb_cmd_addr (ifu2itcm_icb_cmd_addr ),
    .ifu2itcm_icb_rsp_valid(ifu2itcm_icb_rsp_valid),
    .ifu2itcm_icb_rsp_ready(ifu2itcm_icb_rsp_ready),
    .ifu2itcm_icb_rsp_err  (ifu2itcm_icb_rsp_err  ),
    .ifu2itcm_icb_rsp_rdata(ifu2itcm_icb_rsp_rdata),
  `endif//}

  `ifdef E203_HAS_MEM_ITF //{
    .ifu2biu_icb_cmd_valid  (ifu2biu_icb_cmd_valid),
    .ifu2biu_icb_cmd_ready  (ifu2biu_icb_cmd_ready),
    .ifu2biu_icb_cmd_addr   (ifu2biu_icb_cmd_addr ),
    
    .ifu2biu_icb_rsp_valid  (ifu2biu_icb_rsp_valid),
    .ifu2biu_icb_rsp_ready  (ifu2biu_icb_rsp_ready),
    .ifu2biu_icb_rsp_err    (ifu2biu_icb_rsp_err  ),
    .ifu2biu_icb_rsp_rdata  (ifu2biu_icb_rsp_rdata),

  `endif//}


    .ifu_o_valid            (ifu_o_valid         ),
    .ifu_o_ready            (ifu_o_ready         ),
    .ifu_o_ir               (ifu_o_ir            ),
    .ifu_o_pc               (ifu_o_pc            ),
    .ifu_o_pc_vld           (ifu_o_pc_vld        ),
    .ifu_o_misalgn          (ifu_o_misalgn       ), 
    .ifu_o_buserr           (ifu_o_buserr        ), 
    .ifu_o_rs1idx           (ifu_o_rs1idx        ),
    .ifu_o_rs2idx           (ifu_o_rs2idx        ),
    .ifu_o_prdt_taken       (ifu_o_prdt_taken    ),
    .ifu_o_muldiv_b2b       (ifu_o_muldiv_b2b    ),

    .ifu_halt_req           (wfi_halt_ifu_req),
    .ifu_halt_ack           (wfi_halt_ifu_ack),
    .pipe_flush_ack         (pipe_flush_ack      ),
    .pipe_flush_req         (pipe_flush_req      ),
    .pipe_flush_add_op1     (pipe_flush_add_op1  ),  
    .pipe_flush_add_op2     (pipe_flush_add_op2  ),  
  `ifdef E203_TIMING_BOOST//}
    .pipe_flush_pc          (pipe_flush_pc),  
  `endif//}

                                 
    .oitf_empty             (oitf_empty   ),
    .rf2ifu_x1              (rf2ifu_x1    ),
    .rf2ifu_rs1             (rf2ifu_rs1   ),
    .dec2ifu_rden           (dec2ifu_rden ),
    .dec2ifu_rs1en          (dec2ifu_rs1en),
    .dec2ifu_rdidx          (dec2ifu_rdidx),
    .dec2ifu_mulhsu         (dec2ifu_mulhsu),
    .dec2ifu_div            (dec2ifu_div   ),
    .dec2ifu_rem            (dec2ifu_rem   ),
    .dec2ifu_divu           (dec2ifu_divu  ),
    .dec2ifu_remu           (dec2ifu_remu  ),

    .clk                    (clk_core_ifu  ),
    .rst_n                  (rst_n         ) 
  );

  

  wire                         lsu_o_valid; 
  wire                         lsu_o_ready; 
  wire [`E203_XLEN-1:0]        lsu_o_wbck_wdat;
  wire [`E203_ITAG_WIDTH -1:0] lsu_o_wbck_itag;
  wire                         lsu_o_wbck_err ; 
  wire                         lsu_o_cmt_buserr ; 
  wire                         lsu_o_cmt_ld;
  wire                         lsu_o_cmt_st;
  wire [`E203_ADDR_SIZE -1:0]  lsu_o_cmt_badaddr;

  wire                         agu_icb_cmd_valid; 
  wire                         agu_icb_cmd_ready; 
  wire [`E203_ADDR_SIZE-1:0]   agu_icb_cmd_addr; 
  wire                         agu_icb_cmd_read;   
  wire [`E203_XLEN-1:0]        agu_icb_cmd_wdata; 
  wire [`E203_XLEN/8-1:0]      agu_icb_cmd_wmask; 
  wire                         agu_icb_cmd_lock;
  wire                         agu_icb_cmd_excl;
  wire [1:0]                   agu_icb_cmd_size;
  wire                         agu_icb_cmd_back2agu; 
  wire                         agu_icb_cmd_usign;
  wire [`E203_ITAG_WIDTH -1:0] agu_icb_cmd_itag;
  wire                         agu_icb_rsp_valid; 
  wire                         agu_icb_rsp_ready; 
  wire                         agu_icb_rsp_err  ; 
  wire                         agu_icb_rsp_excl_ok  ; 
  wire [`E203_XLEN-1:0]        agu_icb_rsp_rdata;

  wire commit_mret;
  wire commit_trap;
  wire excp_active;

  e203_exu u_e203_exu(

  `ifdef E203_HAS_CSR_EAI//{
    .eai_csr_valid (eai_csr_valid),
    .eai_csr_ready (eai_csr_ready),
    .eai_csr_addr  (eai_csr_addr ),
    .eai_csr_wr    (eai_csr_wr   ),
    .eai_csr_wdata (eai_csr_wdata),
    .eai_csr_rdata (eai_csr_rdata),
  `endif//}


    .excp_active            (excp_active),
    .commit_mret            (commit_mret),
    .commit_trap            (commit_trap),
    .test_mode              (test_mode),
    .core_wfi               (core_wfi),
    .tm_stop                (tm_stop),
    .itcm_nohold            (itcm_nohold),
    .core_cgstop            (core_cgstop),
    .tcm_cgstop             (tcm_cgstop),
    .exu_active             (exu_active),

    .core_mhartid           (core_mhartid),
    .dbg_irq_r              (dbg_irq_r),
    .lcl_irq_r              (lcl_irq_r    ),
    .ext_irq_r              (ext_irq_r    ),
    .sft_irq_r              (sft_irq_r    ),
    .tmr_irq_r              (tmr_irq_r    ),
    .evt_r                  (evt_r    ),

    .cmt_dpc                (cmt_dpc        ),
    .cmt_dpc_ena            (cmt_dpc_ena    ),
    .cmt_dcause             (cmt_dcause     ),
    .cmt_dcause_ena         (cmt_dcause_ena ),

    .wr_dcsr_ena     (wr_dcsr_ena    ),
    .wr_dpc_ena      (wr_dpc_ena     ),
    .wr_dscratch_ena (wr_dscratch_ena),


                                     
    .wr_csr_nxt      (wr_csr_nxt    ),
                                     
    .dcsr_r          (dcsr_r         ),
    .dpc_r           (dpc_r          ),
    .dscratch_r      (dscratch_r     ),

    .dbg_mode               (dbg_mode  ),
    .dbg_halt_r             (dbg_halt_r),
    .dbg_step_r             (dbg_step_r),
    .dbg_ebreakm_r          (dbg_ebreakm_r),
    .dbg_stopcycle          (dbg_stopcycle),

    .i_valid                (ifu_o_valid         ),
    .i_ready                (ifu_o_ready         ),
    .i_ir                   (ifu_o_ir            ),
    .i_pc                   (ifu_o_pc            ),
    .i_pc_vld               (ifu_o_pc_vld        ),
    .i_misalgn              (ifu_o_misalgn       ), 
    .i_buserr               (ifu_o_buserr        ), 
    .i_rs1idx               (ifu_o_rs1idx        ),
    .i_rs2idx               (ifu_o_rs2idx        ),
    .i_prdt_taken           (ifu_o_prdt_taken    ),
    .i_muldiv_b2b           (ifu_o_muldiv_b2b    ),

    .wfi_halt_ifu_req       (wfi_halt_ifu_req),
    .wfi_halt_ifu_ack       (wfi_halt_ifu_ack),

    .pipe_flush_ack         (pipe_flush_ack      ),
    .pipe_flush_req         (pipe_flush_req      ),
    .pipe_flush_add_op1     (pipe_flush_add_op1  ),  
    .pipe_flush_add_op2     (pipe_flush_add_op2  ),  
  `ifdef E203_TIMING_BOOST//}
    .pipe_flush_pc          (pipe_flush_pc),  
  `endif//}

    .lsu_o_valid            (lsu_o_valid   ),
    .lsu_o_ready            (lsu_o_ready   ),
    .lsu_o_wbck_wdat        (lsu_o_wbck_wdat    ),
    .lsu_o_wbck_itag        (lsu_o_wbck_itag    ),
    .lsu_o_wbck_err         (lsu_o_wbck_err     ),
    .lsu_o_cmt_buserr       (lsu_o_cmt_buserr     ),
    .lsu_o_cmt_ld           (lsu_o_cmt_ld),
    .lsu_o_cmt_st           (lsu_o_cmt_st),
    .lsu_o_cmt_badaddr      (lsu_o_cmt_badaddr     ),

    .agu_icb_cmd_valid      (agu_icb_cmd_valid   ),
    .agu_icb_cmd_ready      (agu_icb_cmd_ready   ),
    .agu_icb_cmd_addr       (agu_icb_cmd_addr    ),
    .agu_icb_cmd_read       (agu_icb_cmd_read    ),
    .agu_icb_cmd_wdata      (agu_icb_cmd_wdata   ),
    .agu_icb_cmd_wmask      (agu_icb_cmd_wmask   ),
    .agu_icb_cmd_lock       (agu_icb_cmd_lock    ),
    .agu_icb_cmd_excl       (agu_icb_cmd_excl    ),
    .agu_icb_cmd_size       (agu_icb_cmd_size    ),
    .agu_icb_cmd_back2agu   (agu_icb_cmd_back2agu),
    .agu_icb_cmd_usign      (agu_icb_cmd_usign   ),
    .agu_icb_cmd_itag       (agu_icb_cmd_itag    ),
    .agu_icb_rsp_valid      (agu_icb_rsp_valid   ),
    .agu_icb_rsp_ready      (agu_icb_rsp_ready   ),
    .agu_icb_rsp_err        (agu_icb_rsp_err     ),
    .agu_icb_rsp_excl_ok    (agu_icb_rsp_excl_ok ),
    .agu_icb_rsp_rdata      (agu_icb_rsp_rdata   ),

    .oitf_empty             (oitf_empty   ),
    .rf2ifu_x1              (rf2ifu_x1    ),
    .rf2ifu_rs1             (rf2ifu_rs1   ),
    .dec2ifu_rden           (dec2ifu_rden ),
    .dec2ifu_rs1en          (dec2ifu_rs1en),
    .dec2ifu_rdidx          (dec2ifu_rdidx),
    .dec2ifu_mulhsu         (dec2ifu_mulhsu),
    .dec2ifu_div            (dec2ifu_div   ),
    .dec2ifu_rem            (dec2ifu_rem   ),
    .dec2ifu_divu           (dec2ifu_divu  ),
    .dec2ifu_remu           (dec2ifu_remu  ),


    .clk_aon                (clk_aon),
    .clk                    (clk_core_exu),
    .rst_n                  (rst_n  ) 
  );

  wire                         lsu2biu_icb_cmd_valid;
  wire                         lsu2biu_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   lsu2biu_icb_cmd_addr; 
  wire                         lsu2biu_icb_cmd_read; 
  wire [`E203_XLEN-1:0]        lsu2biu_icb_cmd_wdata;
  wire [`E203_XLEN/8-1:0]      lsu2biu_icb_cmd_wmask;
  wire                         lsu2biu_icb_cmd_lock;
  wire                         lsu2biu_icb_cmd_excl;
  wire [1:0]                   lsu2biu_icb_cmd_size;

  wire                         lsu2biu_icb_rsp_valid;
  wire                         lsu2biu_icb_rsp_ready;
  wire                         lsu2biu_icb_rsp_err  ;
  wire                         lsu2biu_icb_rsp_excl_ok;
  wire [`E203_XLEN-1:0]        lsu2biu_icb_rsp_rdata;

  e203_lsu u_e203_lsu(
    .excp_active         (excp_active),
    .commit_mret            (commit_mret),
    .commit_trap         (commit_trap),
    .lsu_active          (lsu_active),
    .lsu_o_valid         (lsu_o_valid   ),
    .lsu_o_ready         (lsu_o_ready   ),
    .lsu_o_wbck_wdat     (lsu_o_wbck_wdat    ),
    .lsu_o_wbck_itag     (lsu_o_wbck_itag    ),
    .lsu_o_wbck_err      (lsu_o_wbck_err     ),
    .lsu_o_cmt_buserr    (lsu_o_cmt_buserr     ),
    .lsu_o_cmt_ld        (lsu_o_cmt_ld),
    .lsu_o_cmt_st        (lsu_o_cmt_st),
    .lsu_o_cmt_badaddr   (lsu_o_cmt_badaddr     ),
                        
    .agu_icb_cmd_valid   (agu_icb_cmd_valid ),
    .agu_icb_cmd_ready   (agu_icb_cmd_ready ),
    .agu_icb_cmd_addr    (agu_icb_cmd_addr  ),
    .agu_icb_cmd_read    (agu_icb_cmd_read  ),
    .agu_icb_cmd_wdata   (agu_icb_cmd_wdata ),
    .agu_icb_cmd_wmask   (agu_icb_cmd_wmask ),
    .agu_icb_cmd_lock    (agu_icb_cmd_lock  ),
    .agu_icb_cmd_excl    (agu_icb_cmd_excl  ),
    .agu_icb_cmd_size    (agu_icb_cmd_size  ),
   
    .agu_icb_cmd_back2agu(agu_icb_cmd_back2agu ),
    .agu_icb_cmd_usign   (agu_icb_cmd_usign),
    .agu_icb_cmd_itag    (agu_icb_cmd_itag),
  
    .agu_icb_rsp_valid   (agu_icb_rsp_valid ),
    .agu_icb_rsp_ready   (agu_icb_rsp_ready ),
    .agu_icb_rsp_err     (agu_icb_rsp_err   ),
    .agu_icb_rsp_excl_ok (agu_icb_rsp_excl_ok),
    .agu_icb_rsp_rdata   (agu_icb_rsp_rdata),



  `ifdef E203_HAS_ITCM //{
    .itcm_region_indic   (itcm_region_indic),
    .itcm_icb_cmd_valid  (lsu2itcm_icb_cmd_valid),
    .itcm_icb_cmd_ready  (lsu2itcm_icb_cmd_ready),
    .itcm_icb_cmd_addr   (lsu2itcm_icb_cmd_addr ),
    .itcm_icb_cmd_read   (lsu2itcm_icb_cmd_read ),
    .itcm_icb_cmd_wdata  (lsu2itcm_icb_cmd_wdata),
    .itcm_icb_cmd_wmask  (lsu2itcm_icb_cmd_wmask),
    .itcm_icb_cmd_lock   (lsu2itcm_icb_cmd_lock ),
    .itcm_icb_cmd_excl   (lsu2itcm_icb_cmd_excl ),
    .itcm_icb_cmd_size   (lsu2itcm_icb_cmd_size ),
     
    .itcm_icb_rsp_valid  (lsu2itcm_icb_rsp_valid),
    .itcm_icb_rsp_ready  (lsu2itcm_icb_rsp_ready),
    .itcm_icb_rsp_err    (lsu2itcm_icb_rsp_err  ),
    .itcm_icb_rsp_excl_ok(lsu2itcm_icb_rsp_excl_ok  ),
    .itcm_icb_rsp_rdata  (lsu2itcm_icb_rsp_rdata),

  `endif//}

  `ifdef E203_HAS_DTCM //{
    .dtcm_region_indic   (dtcm_region_indic),

    .dtcm_icb_cmd_valid  (lsu2dtcm_icb_cmd_valid),
    .dtcm_icb_cmd_ready  (lsu2dtcm_icb_cmd_ready),
    .dtcm_icb_cmd_addr   (lsu2dtcm_icb_cmd_addr ),
    .dtcm_icb_cmd_read   (lsu2dtcm_icb_cmd_read ),
    .dtcm_icb_cmd_wdata  (lsu2dtcm_icb_cmd_wdata),
    .dtcm_icb_cmd_wmask  (lsu2dtcm_icb_cmd_wmask),
    .dtcm_icb_cmd_lock   (lsu2dtcm_icb_cmd_lock ),
    .dtcm_icb_cmd_excl   (lsu2dtcm_icb_cmd_excl ),
    .dtcm_icb_cmd_size   (lsu2dtcm_icb_cmd_size ),
     
    .dtcm_icb_rsp_valid  (lsu2dtcm_icb_rsp_valid),
    .dtcm_icb_rsp_ready  (lsu2dtcm_icb_rsp_ready),
    .dtcm_icb_rsp_err    (lsu2dtcm_icb_rsp_err  ),
    .dtcm_icb_rsp_excl_ok(lsu2dtcm_icb_rsp_excl_ok  ),
    .dtcm_icb_rsp_rdata  (lsu2dtcm_icb_rsp_rdata),

  `endif//}

    .biu_icb_cmd_valid  (lsu2biu_icb_cmd_valid),
    .biu_icb_cmd_ready  (lsu2biu_icb_cmd_ready),
    .biu_icb_cmd_addr   (lsu2biu_icb_cmd_addr ),
    .biu_icb_cmd_read   (lsu2biu_icb_cmd_read ),
    .biu_icb_cmd_wdata  (lsu2biu_icb_cmd_wdata),
    .biu_icb_cmd_wmask  (lsu2biu_icb_cmd_wmask),
    .biu_icb_cmd_lock   (lsu2biu_icb_cmd_lock ),
    .biu_icb_cmd_excl   (lsu2biu_icb_cmd_excl ),
    .biu_icb_cmd_size   (lsu2biu_icb_cmd_size ),
    
    .biu_icb_rsp_valid  (lsu2biu_icb_rsp_valid),
    .biu_icb_rsp_ready  (lsu2biu_icb_rsp_ready),
    .biu_icb_rsp_err    (lsu2biu_icb_rsp_err  ),
    .biu_icb_rsp_excl_ok(lsu2biu_icb_rsp_excl_ok),
    .biu_icb_rsp_rdata  (lsu2biu_icb_rsp_rdata),

    .clk           (clk_core_lsu ),
    .rst_n         (rst_n        ) 
  );


  e203_biu u_e203_biu(


    .biu_active             (biu_active),

    .lsu2biu_icb_cmd_valid  (lsu2biu_icb_cmd_valid),
    .lsu2biu_icb_cmd_ready  (lsu2biu_icb_cmd_ready),
    .lsu2biu_icb_cmd_addr   (lsu2biu_icb_cmd_addr ),
    .lsu2biu_icb_cmd_read   (lsu2biu_icb_cmd_read ),
    .lsu2biu_icb_cmd_wdata  (lsu2biu_icb_cmd_wdata),
    .lsu2biu_icb_cmd_wmask  (lsu2biu_icb_cmd_wmask),
    .lsu2biu_icb_cmd_lock   (lsu2biu_icb_cmd_lock ),
    .lsu2biu_icb_cmd_excl   (lsu2biu_icb_cmd_excl ),
    .lsu2biu_icb_cmd_size   (lsu2biu_icb_cmd_size ),
    .lsu2biu_icb_cmd_burst  (2'b0),
    .lsu2biu_icb_cmd_beat   (2'b0 ),

    .lsu2biu_icb_rsp_valid  (lsu2biu_icb_rsp_valid),
    .lsu2biu_icb_rsp_ready  (lsu2biu_icb_rsp_ready),
    .lsu2biu_icb_rsp_err    (lsu2biu_icb_rsp_err  ),
    .lsu2biu_icb_rsp_excl_ok(lsu2biu_icb_rsp_excl_ok),
    .lsu2biu_icb_rsp_rdata  (lsu2biu_icb_rsp_rdata),

  `ifdef E203_HAS_MEM_ITF //{
    .ifu2biu_icb_cmd_valid  (ifu2biu_icb_cmd_valid),
    .ifu2biu_icb_cmd_ready  (ifu2biu_icb_cmd_ready),
    .ifu2biu_icb_cmd_addr   (ifu2biu_icb_cmd_addr ),
    .ifu2biu_icb_cmd_read   (1'b1 ),
    .ifu2biu_icb_cmd_wdata  (`E203_XLEN'b0),
    .ifu2biu_icb_cmd_wmask  ({`E203_XLEN/8{1'b0}}),
    .ifu2biu_icb_cmd_lock   (1'b0 ),
    .ifu2biu_icb_cmd_excl   (1'b0 ),
    .ifu2biu_icb_cmd_size   (2'b10),
    .ifu2biu_icb_cmd_burst  (2'b0),
    .ifu2biu_icb_cmd_beat   (2'b0),
    
    .ifu2biu_icb_rsp_valid  (ifu2biu_icb_rsp_valid),
    .ifu2biu_icb_rsp_ready  (ifu2biu_icb_rsp_ready),
    .ifu2biu_icb_rsp_err    (ifu2biu_icb_rsp_err  ),
    .ifu2biu_icb_rsp_excl_ok(ifu2biu_icb_rsp_excl_ok),
    .ifu2biu_icb_rsp_rdata  (ifu2biu_icb_rsp_rdata),

  `endif//}

    .ppi_region_indic      (ppi_region_indic ),
    .ppi_icb_enable        (ppi_icb_enable),
    .ppi_icb_cmd_valid     (ppi_icb_cmd_valid),
    .ppi_icb_cmd_ready     (ppi_icb_cmd_ready),
    .ppi_icb_cmd_addr      (ppi_icb_cmd_addr ),
    .ppi_icb_cmd_read      (ppi_icb_cmd_read ),
    .ppi_icb_cmd_wdata     (ppi_icb_cmd_wdata),
    .ppi_icb_cmd_wmask     (ppi_icb_cmd_wmask),
    .ppi_icb_cmd_lock      (ppi_icb_cmd_lock ),
    .ppi_icb_cmd_excl      (ppi_icb_cmd_excl ),
    .ppi_icb_cmd_size      (ppi_icb_cmd_size ),
    .ppi_icb_cmd_burst     (),
    .ppi_icb_cmd_beat      (),
    
    .ppi_icb_rsp_valid     (ppi_icb_rsp_valid),
    .ppi_icb_rsp_ready     (ppi_icb_rsp_ready),
    .ppi_icb_rsp_err       (ppi_icb_rsp_err  ),
    .ppi_icb_rsp_excl_ok   (ppi_icb_rsp_excl_ok),
    .ppi_icb_rsp_rdata     (ppi_icb_rsp_rdata),


    .plic_icb_enable        (plic_icb_enable),
    .plic_region_indic      (plic_region_indic ),
    .plic_icb_cmd_valid     (plic_icb_cmd_valid),
    .plic_icb_cmd_ready     (plic_icb_cmd_ready),
    .plic_icb_cmd_addr      (plic_icb_cmd_addr ),
    .plic_icb_cmd_read      (plic_icb_cmd_read ),
    .plic_icb_cmd_wdata     (plic_icb_cmd_wdata),
    .plic_icb_cmd_wmask     (plic_icb_cmd_wmask),
    .plic_icb_cmd_lock      (plic_icb_cmd_lock ),
    .plic_icb_cmd_excl      (plic_icb_cmd_excl ),
    .plic_icb_cmd_size      (plic_icb_cmd_size ),
    .plic_icb_cmd_burst     (),
    .plic_icb_cmd_beat      (),
    
    .plic_icb_rsp_valid     (plic_icb_rsp_valid),
    .plic_icb_rsp_ready     (plic_icb_rsp_ready),
    .plic_icb_rsp_err       (plic_icb_rsp_err  ),
    .plic_icb_rsp_excl_ok   (plic_icb_rsp_excl_ok),
    .plic_icb_rsp_rdata     (plic_icb_rsp_rdata),

    .clint_icb_enable        (clint_icb_enable),
    .clint_region_indic      (clint_region_indic ),
    .clint_icb_cmd_valid     (clint_icb_cmd_valid),
    .clint_icb_cmd_ready     (clint_icb_cmd_ready),
    .clint_icb_cmd_addr      (clint_icb_cmd_addr ),
    .clint_icb_cmd_read      (clint_icb_cmd_read ),
    .clint_icb_cmd_wdata     (clint_icb_cmd_wdata),
    .clint_icb_cmd_wmask     (clint_icb_cmd_wmask),
    .clint_icb_cmd_lock      (clint_icb_cmd_lock ),
    .clint_icb_cmd_excl      (clint_icb_cmd_excl ),
    .clint_icb_cmd_size      (clint_icb_cmd_size ),
    .clint_icb_cmd_burst     (),
    .clint_icb_cmd_beat      (),
    
    .clint_icb_rsp_valid     (clint_icb_rsp_valid),
    .clint_icb_rsp_ready     (clint_icb_rsp_ready),
    .clint_icb_rsp_err       (clint_icb_rsp_err  ),
    .clint_icb_rsp_excl_ok   (clint_icb_rsp_excl_ok),
    .clint_icb_rsp_rdata     (clint_icb_rsp_rdata),


  `ifdef E203_HAS_FIO //{
    .fio_region_indic      (fio_region_indic ),
    .fio_icb_enable        (fio_icb_enable),
    .fio_icb_cmd_valid     (fio_icb_cmd_valid),
    .fio_icb_cmd_ready     (fio_icb_cmd_ready),
    .fio_icb_cmd_addr      (fio_icb_cmd_addr ),
    .fio_icb_cmd_read      (fio_icb_cmd_read ),
    .fio_icb_cmd_wdata     (fio_icb_cmd_wdata),
    .fio_icb_cmd_wmask     (fio_icb_cmd_wmask),
    .fio_icb_cmd_lock      (fio_icb_cmd_lock ),
    .fio_icb_cmd_excl      (fio_icb_cmd_excl ),
    .fio_icb_cmd_size      (fio_icb_cmd_size ),
    .fio_icb_cmd_burst     (),
    .fio_icb_cmd_beat      (),
    
    .fio_icb_rsp_valid     (fio_icb_rsp_valid),
    .fio_icb_rsp_ready     (fio_icb_rsp_ready),
    .fio_icb_rsp_err       (fio_icb_rsp_err  ),
    .fio_icb_rsp_excl_ok   (fio_icb_rsp_excl_ok  ),
    .fio_icb_rsp_rdata     (fio_icb_rsp_rdata),
  `endif//}

  `ifdef E203_HAS_MEM_ITF //{
    .mem_icb_enable        (mem_icb_enable),
    .mem_icb_cmd_valid     (mem_icb_cmd_valid),
    .mem_icb_cmd_ready     (mem_icb_cmd_ready),
    .mem_icb_cmd_addr      (mem_icb_cmd_addr ),
    .mem_icb_cmd_read      (mem_icb_cmd_read ),
    .mem_icb_cmd_wdata     (mem_icb_cmd_wdata),
    .mem_icb_cmd_wmask     (mem_icb_cmd_wmask),
    .mem_icb_cmd_lock      (mem_icb_cmd_lock ),
    .mem_icb_cmd_excl      (mem_icb_cmd_excl ),
    .mem_icb_cmd_size      (mem_icb_cmd_size ),
    .mem_icb_cmd_burst     (mem_icb_cmd_burst),
    .mem_icb_cmd_beat      (mem_icb_cmd_beat ),
    
    .mem_icb_rsp_valid     (mem_icb_rsp_valid),
    .mem_icb_rsp_ready     (mem_icb_rsp_ready),
    .mem_icb_rsp_err       (mem_icb_rsp_err  ),
    .mem_icb_rsp_excl_ok   (mem_icb_rsp_excl_ok  ),
    .mem_icb_rsp_rdata     (mem_icb_rsp_rdata),
  `endif//}

    .clk                    (clk_core_biu ),
    .rst_n                  (rst_n        ) 
  );



endmodule                                      
                                               
                                               
                                               
