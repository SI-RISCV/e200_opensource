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
// Designer   : Bob Hu
//
// Description:
//  The EXU module to implement entire Execution Stage
//
// ====================================================================

`include "e203_defines.v"

module e203_exu(
  output commit_mret,
  output commit_trap,
  output exu_active,
  output excp_active,

  output core_wfi,
  output tm_stop,
  output itcm_nohold,
  output core_cgstop,
  output tcm_cgstop,

  input  [`E203_HART_ID_W-1:0] core_mhartid,
  input  dbg_irq_r,
  input  [`E203_LIRQ_NUM-1:0] lcl_irq_r,
  input  [`E203_EVT_NUM-1:0] evt_r,
  input  ext_irq_r,
  input  sft_irq_r,
  input  tmr_irq_r,

  //////////////////////////////////////////////////////////////
  // From/To debug ctrl module
  output  [`E203_PC_SIZE-1:0] cmt_dpc,
  output  cmt_dpc_ena,
  output  [3-1:0] cmt_dcause,
  output  cmt_dcause_ena,

  output wr_dcsr_ena    ,
  output wr_dpc_ena     ,
  output wr_dscratch_ena,



  output [`E203_XLEN-1:0] wr_csr_nxt    ,

  input [`E203_XLEN-1:0] dcsr_r    ,
  input [`E203_PC_SIZE-1:0] dpc_r     ,
  input [`E203_XLEN-1:0] dscratch_r,

  input  dbg_mode,
  input  dbg_halt_r,
  input  dbg_step_r,
  input  dbg_ebreakm_r,
  input  dbg_stopcycle,


  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The IFU IR stage to EXU interface
  input  i_valid, // Handshake signals with EXU stage
  output i_ready,
  input  [`E203_INSTR_SIZE-1:0] i_ir,// The instruction register
  input  [`E203_PC_SIZE-1:0] i_pc,   // The PC register along with
  input  i_pc_vld,
  input  i_misalgn,              // The fetch misalign
  input  i_buserr,               // The fetch bus error
  input  i_prdt_taken,               
  input  i_muldiv_b2b,               
  input  [`E203_RFIDX_WIDTH-1:0] i_rs1idx,   // The RS1 index
  input  [`E203_RFIDX_WIDTH-1:0] i_rs2idx,   // The RS2 index



  //////////////////////////////////////////////////////////////
  // The Flush interface to IFU
  //
  //   To save the gatecount, when we need to flush pipeline with new PC, 
  //     we want to reuse the adder in IFU, so we will not pass flush-PC
  //     to IFU, instead, we pass the flush-pc-adder-op1/op2 to IFU
  //     and IFU will just use its adder to caculate the flush-pc-adder-result
  //
  input   pipe_flush_ack,
  output  pipe_flush_req,
  output  [`E203_PC_SIZE-1:0] pipe_flush_add_op1,  
  output  [`E203_PC_SIZE-1:0] pipe_flush_add_op2,  
  `ifdef E203_TIMING_BOOST//}
  output  [`E203_PC_SIZE-1:0] pipe_flush_pc,  
  `endif//}

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The LSU Write-Back Interface
  input  lsu_o_valid, // Handshake valid
  output lsu_o_ready, // Handshake ready
  input  [`E203_XLEN-1:0] lsu_o_wbck_wdat,
  input  [`E203_ITAG_WIDTH -1:0] lsu_o_wbck_itag,
  input  lsu_o_wbck_err , 
  input  lsu_o_cmt_ld,
  input  lsu_o_cmt_st,
  input  [`E203_ADDR_SIZE -1:0] lsu_o_cmt_badaddr,
  input  lsu_o_cmt_buserr , // The bus-error exception generated

  output wfi_halt_ifu_req,
  input  wfi_halt_ifu_ack,

  output oitf_empty,
  output [`E203_XLEN-1:0] rf2ifu_x1,
  output [`E203_XLEN-1:0] rf2ifu_rs1,
  output dec2ifu_rden,
  output dec2ifu_rs1en,
  output [`E203_RFIDX_WIDTH-1:0] dec2ifu_rdidx,
  output dec2ifu_mulhsu,
  output dec2ifu_div   ,
  output dec2ifu_rem   ,
  output dec2ifu_divu  ,
  output dec2ifu_remu  ,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The AGU ICB Interface to LSU-ctrl
  //    * Bus cmd channel
  output                         agu_icb_cmd_valid, // Handshake valid
  input                          agu_icb_cmd_ready, // Handshake ready
  output [`E203_ADDR_SIZE-1:0]   agu_icb_cmd_addr, // Bus transaction start addr 
  output                         agu_icb_cmd_read,   // Read or write
  output [`E203_XLEN-1:0]        agu_icb_cmd_wdata, 
  output [`E203_XLEN/8-1:0]      agu_icb_cmd_wmask, 
  output                         agu_icb_cmd_lock,
  output                         agu_icb_cmd_excl,
  output [1:0]                   agu_icb_cmd_size,
           // Several additional side channel signals
           //   Indicate LSU-ctrl module to
           //     return the ICB response channel back to AGU
           //     this is only used by AMO or unaligned load/store 1st uop
           //     to return the response
  output                         agu_icb_cmd_back2agu, 
           //   Sign extension or not
  output                         agu_icb_cmd_usign,
  output [`E203_ITAG_WIDTH -1:0] agu_icb_cmd_itag,

  //    * Bus RSP channel
  input                          agu_icb_rsp_valid, // Response valid 
  output                         agu_icb_rsp_ready, // Response ready
  input                          agu_icb_rsp_err  , // Response error
  input                          agu_icb_rsp_excl_ok,
  input  [`E203_XLEN-1:0]        agu_icb_rsp_rdata,

  `ifdef E203_HAS_CSR_EAI//{
  output         eai_csr_valid,
  input          eai_csr_ready,
  output  [31:0] eai_csr_addr,
  output         eai_csr_wr,
  output  [31:0] eai_csr_wdata,
  input   [31:0] eai_csr_rdata,
  `endif//}




  input  test_mode,
  input  clk_aon,
  input  clk,
  input  rst_n
  );


  //////////////////////////////////////////////////////////////
  // Instantiate the Regfile
  wire [`E203_XLEN-1:0] rf_rs1;
  wire [`E203_XLEN-1:0] rf_rs2;

  wire rf_wbck_ena;
  wire [`E203_XLEN-1:0] rf_wbck_wdat;
  wire [`E203_RFIDX_WIDTH-1:0] rf_wbck_rdidx;


  e203_exu_regfile u_e203_exu_regfile(
    .read_src1_idx (i_rs1idx ),
    .read_src2_idx (i_rs2idx ),
    .read_src1_dat (rf_rs1),
    .read_src2_dat (rf_rs2),
    
    .x1_r          (rf2ifu_x1),
                    
    .wbck_dest_wen (rf_wbck_ena),
    .wbck_dest_idx (rf_wbck_rdidx),
    .wbck_dest_dat (rf_wbck_wdat),
                                 
    .test_mode     (test_mode),
    .clk           (clk          ),
    .rst_n         (rst_n        ) 
  );

  wire dec_rs1en;
  wire dec_rs2en;


  
  //////////////////////////////////////////////////////////////
  // Instantiate the Decode
  wire [`E203_DECINFO_WIDTH-1:0]  dec_info;
  wire [`E203_XLEN-1:0] dec_imm;
  wire [`E203_PC_SIZE-1:0] dec_pc;
  wire dec_rs1x0;
  wire dec_rs2x0;
  wire dec_rdwen;
  wire [`E203_RFIDX_WIDTH-1:0] dec_rdidx;
  wire dec_misalgn;
  wire dec_buserr;
  wire dec_ilegl;


  //////////////////////////////////////////////////////////////
  // The Decoded Info-Bus
  e203_exu_decode u_e203_exu_decode (
    .dbg_mode     (dbg_mode),

    .i_instr      (i_ir    ),
    .i_pc         (i_pc    ),
    .i_misalgn    (i_misalgn),
    .i_buserr     (i_buserr ),
    .i_prdt_taken (i_prdt_taken), 
    .i_muldiv_b2b (i_muldiv_b2b), 
      
    .dec_rv32  (),
    .dec_bjp   (),
    .dec_jal   (),
    .dec_jalr  (),
    .dec_bxx   (),
    .dec_jalr_rs1idx(),
    .dec_bjp_imm(),

    .dec_mulhsu  (dec2ifu_mulhsu),
    .dec_mul     (),
    .dec_div     (dec2ifu_div   ),
    .dec_rem     (dec2ifu_rem   ),
    .dec_divu    (dec2ifu_divu  ),
    .dec_remu    (dec2ifu_remu  ),

    


    .dec_info  (dec_info ),
    .dec_rs1x0 (dec_rs1x0),
    .dec_rs2x0 (dec_rs2x0),
    .dec_rs1en (dec_rs1en),
    .dec_rs2en (dec_rs2en),
    .dec_rdwen (dec_rdwen),
    .dec_rs1idx(),
    .dec_rs2idx(),
    .dec_misalgn(dec_misalgn),
    .dec_buserr (dec_buserr ),
    .dec_ilegl  (dec_ilegl),
    .dec_rdidx (dec_rdidx),
    .dec_pc    (dec_pc),
    .dec_imm   (dec_imm)
  );

  //////////////////////////////////////////////////////////////
  // Instantiate the Dispatch
  wire disp_alu_valid; 
  wire disp_alu_ready; 
  wire disp_alu_longpipe;
  wire [`E203_ITAG_WIDTH-1:0] disp_alu_itag;
  wire [`E203_XLEN-1:0] disp_alu_rs1;
  wire [`E203_XLEN-1:0] disp_alu_rs2;
  wire [`E203_XLEN-1:0] disp_alu_imm;
  wire [`E203_DECINFO_WIDTH-1:0]  disp_alu_info;  
  wire [`E203_PC_SIZE-1:0] disp_alu_pc;
  wire [`E203_RFIDX_WIDTH-1:0] disp_alu_rdidx;
  wire disp_alu_rdwen;
  wire disp_alu_ilegl;
  wire disp_alu_misalgn;
  wire disp_alu_buserr;

  wire [`E203_ITAG_WIDTH-1:0] disp_oitf_ptr;
  wire disp_oitf_ready;

  wire  disp_oitf_rs1fpu;
  wire  disp_oitf_rs2fpu;
  wire  disp_oitf_rs3fpu;
  wire  disp_oitf_rdfpu;
  wire  [`E203_RFIDX_WIDTH-1:0] disp_oitf_rs1idx;
  wire  [`E203_RFIDX_WIDTH-1:0] disp_oitf_rs2idx;
  wire  [`E203_RFIDX_WIDTH-1:0] disp_oitf_rs3idx;
  wire  [`E203_RFIDX_WIDTH-1:0] disp_oitf_rdidx;
  wire  disp_oitf_rs1en;
  wire  disp_oitf_rs2en;
  wire  disp_oitf_rs3en;
  wire  disp_oitf_rdwen;
  wire  [`E203_PC_SIZE-1:0] disp_oitf_pc;

  wire oitfrd_match_disprs1;
  wire oitfrd_match_disprs2;
  wire oitfrd_match_disprs3;
  wire oitfrd_match_disprd;

  wire disp_oitf_ena;

  wire wfi_halt_exu_req;
  wire wfi_halt_exu_ack;

  wire amo_wait;

  e203_exu_disp u_e203_exu_disp(
    .wfi_halt_exu_req    (wfi_halt_exu_req),
    .wfi_halt_exu_ack    (wfi_halt_exu_ack),
    .oitf_empty          (oitf_empty),

    .amo_wait            (amo_wait),

    .disp_i_valid        (i_valid         ),
    .disp_i_ready        (i_ready         ),
                                       
    .disp_i_rs1x0        (dec_rs1x0       ),
    .disp_i_rs2x0        (dec_rs2x0       ),
    .disp_i_rs1en        (dec_rs1en       ),
    .disp_i_rs2en        (dec_rs2en       ),
    .disp_i_rs1idx       (i_rs1idx      ),
    .disp_i_rs2idx       (i_rs2idx      ),
    .disp_i_rdwen        (dec_rdwen       ),
    .disp_i_rdidx        (dec_rdidx       ),
    .disp_i_info         (dec_info        ),
    .disp_i_rs1          (rf_rs1          ),
    .disp_i_rs2          (rf_rs2          ),
    .disp_i_imm          (dec_imm        ),
    .disp_i_pc           (dec_pc         ),
    .disp_i_misalgn      (dec_misalgn    ),
    .disp_i_buserr       (dec_buserr     ),
    .disp_i_ilegl        (dec_ilegl      ),


    .disp_o_alu_valid    (disp_alu_valid   ),
    .disp_o_alu_ready    (disp_alu_ready   ),
    .disp_o_alu_longpipe (disp_alu_longpipe),
    .disp_o_alu_itag     (disp_alu_itag    ),
    .disp_o_alu_rs1      (disp_alu_rs1     ),
    .disp_o_alu_rs2      (disp_alu_rs2     ),
    .disp_o_alu_rdwen    (disp_alu_rdwen    ),
    .disp_o_alu_rdidx    (disp_alu_rdidx   ),
    .disp_o_alu_info     (disp_alu_info    ),
    .disp_o_alu_pc       (disp_alu_pc      ),
    .disp_o_alu_imm      (disp_alu_imm     ),
    .disp_o_alu_misalgn  (disp_alu_misalgn    ),
    .disp_o_alu_buserr   (disp_alu_buserr     ),
    .disp_o_alu_ilegl    (disp_alu_ilegl      ),

    .disp_oitf_ena       (disp_oitf_ena    ),
    .disp_oitf_ptr       (disp_oitf_ptr    ),
    .disp_oitf_ready     (disp_oitf_ready  ),

    .disp_oitf_rs1en     (disp_oitf_rs1en),
    .disp_oitf_rs2en     (disp_oitf_rs2en),
    .disp_oitf_rs3en     (disp_oitf_rs3en),
    .disp_oitf_rdwen     (disp_oitf_rdwen ),
    .disp_oitf_rs1idx    (disp_oitf_rs1idx),
    .disp_oitf_rs2idx    (disp_oitf_rs2idx),
    .disp_oitf_rs3idx    (disp_oitf_rs3idx),
    .disp_oitf_rdidx     (disp_oitf_rdidx ),
    .disp_oitf_rs1fpu    (disp_oitf_rs1fpu),
    .disp_oitf_rs2fpu    (disp_oitf_rs2fpu),
    .disp_oitf_rs3fpu    (disp_oitf_rs3fpu),
    .disp_oitf_rdfpu     (disp_oitf_rdfpu),
    .disp_oitf_pc        (disp_oitf_pc),

  
    .oitfrd_match_disprs1(oitfrd_match_disprs1),
    .oitfrd_match_disprs2(oitfrd_match_disprs2),
    .oitfrd_match_disprs3(oitfrd_match_disprs3),
    .oitfrd_match_disprd (oitfrd_match_disprd ),
    
    .clk                 (clk  ),
    .rst_n               (rst_n) 
  );

  //////////////////////////////////////////////////////////////
  // Instantiate the OITF
  wire oitf_ret_ena;
  wire [`E203_ITAG_WIDTH-1:0] oitf_ret_ptr;
  wire [`E203_RFIDX_WIDTH-1:0] oitf_ret_rdidx;
  wire [`E203_PC_SIZE-1:0] oitf_ret_pc;
  wire oitf_ret_rdwen;
  wire oitf_ret_rdfpu;


  e203_exu_oitf u_e203_exu_oitf(
    .dis_ready            (disp_oitf_ready),
    .dis_ena              (disp_oitf_ena  ),
    .ret_ena              (oitf_ret_ena  ),

    .dis_ptr              (disp_oitf_ptr  ),

    .ret_ptr              (oitf_ret_ptr  ),
    .ret_rdidx            (oitf_ret_rdidx),
    .ret_rdwen            (oitf_ret_rdwen),
    .ret_rdfpu            (oitf_ret_rdfpu),
    .ret_pc               (oitf_ret_pc),

    .disp_i_rs1en         (disp_oitf_rs1en),
    .disp_i_rs2en         (disp_oitf_rs2en),
    .disp_i_rs3en         (disp_oitf_rs3en),
    .disp_i_rdwen         (disp_oitf_rdwen ),
    .disp_i_rs1idx        (disp_oitf_rs1idx),
    .disp_i_rs2idx        (disp_oitf_rs2idx),
    .disp_i_rs3idx        (disp_oitf_rs3idx),
    .disp_i_rdidx         (disp_oitf_rdidx ),
    .disp_i_rs1fpu        (disp_oitf_rs1fpu),
    .disp_i_rs2fpu        (disp_oitf_rs2fpu),
    .disp_i_rs3fpu        (disp_oitf_rs3fpu),
    .disp_i_rdfpu         (disp_oitf_rdfpu ),
    .disp_i_pc            (disp_oitf_pc ),

    .oitfrd_match_disprs1 (oitfrd_match_disprs1),
    .oitfrd_match_disprs2 (oitfrd_match_disprs2),
    .oitfrd_match_disprs3 (oitfrd_match_disprs3),
    .oitfrd_match_disprd  (oitfrd_match_disprd ),

    .oitf_empty           (oitf_empty    ),

    .clk                  (clk           ),
    .rst_n                (rst_n         ) 
  );

  //////////////////////////////////////////////////////////////
  // Instantiate the ALU
  wire alu_wbck_o_valid;
  wire alu_wbck_o_ready;
  wire [`E203_XLEN-1:0] alu_wbck_o_wdat;
  wire [`E203_RFIDX_WIDTH-1:0] alu_wbck_o_rdidx;

  wire alu_cmt_valid;
  wire alu_cmt_ready;
  wire alu_cmt_pc_vld;
  wire [`E203_PC_SIZE-1:0] alu_cmt_pc;
  wire [`E203_INSTR_SIZE-1:0] alu_cmt_instr;
  wire [`E203_XLEN-1:0]    alu_cmt_imm;
  wire alu_cmt_rv32;
  wire alu_cmt_bjp;
  wire alu_cmt_mret;
  wire alu_cmt_dret;
  wire alu_cmt_ecall;
  wire alu_cmt_ebreak;
  wire alu_cmt_wfi;
  wire alu_cmt_fencei;
  wire alu_cmt_ifu_misalgn;
  wire alu_cmt_ifu_buserr;
  wire alu_cmt_ifu_ilegl;
  wire alu_cmt_bjp_prdt;
  wire alu_cmt_bjp_rslv;
  wire alu_cmt_misalgn;
  wire alu_cmt_ld;
  wire alu_cmt_stamo;
  wire alu_cmt_buserr;
  wire [`E203_ADDR_SIZE-1:0] alu_cmt_badaddr;


  wire csr_ena;
  wire csr_wr_en;
  wire csr_rd_en;
  wire [12-1:0] csr_idx;

  wire [`E203_XLEN-1:0] read_csr_dat;
  wire [`E203_XLEN-1:0] wbck_csr_dat;

  wire flush_pulse;
  wire flush_req;

  wire nonflush_cmt_ena;


  wire eai_xs_off;

  wire csr_access_ilgl;

  wire mdv_nob2b;


  e203_exu_alu u_e203_exu_alu(


  `ifdef E203_HAS_CSR_EAI//{
    .eai_csr_valid (eai_csr_valid),
    .eai_csr_ready (eai_csr_ready),
    .eai_csr_addr  (eai_csr_addr ),
    .eai_csr_wr    (eai_csr_wr   ),
    .eai_csr_wdata (eai_csr_wdata),
    .eai_csr_rdata (eai_csr_rdata),
  `endif//}
    .csr_access_ilgl     (csr_access_ilgl),
    .nonflush_cmt_ena    (nonflush_cmt_ena),

    .i_valid             (disp_alu_valid   ),
    .i_ready             (disp_alu_ready   ),
    .i_longpipe          (disp_alu_longpipe),
    .i_itag              (disp_alu_itag    ),
    .i_rs1               (disp_alu_rs1     ),
    .i_rs2               (disp_alu_rs2     ),
    .eai_xs_off          (eai_xs_off),
    .i_rdwen             (disp_alu_rdwen   ),
    .i_rdidx             (disp_alu_rdidx   ),
    .i_info              (disp_alu_info    ),
    .i_pc                (i_pc    ),
    .i_pc_vld            (i_pc_vld),
    .i_instr             (i_ir    ),
    .i_imm               (disp_alu_imm     ),
    .i_misalgn           (disp_alu_misalgn    ),
    .i_buserr            (disp_alu_buserr     ),
    .i_ilegl             (disp_alu_ilegl      ),

    .flush_pulse         (flush_pulse    ),
    .flush_req           (flush_req      ),

    .oitf_empty          (oitf_empty),
    .amo_wait            (amo_wait),

    .cmt_o_valid         (alu_cmt_valid      ),
    .cmt_o_ready         (alu_cmt_ready      ),
    .cmt_o_pc_vld        (alu_cmt_pc_vld     ),
    .cmt_o_pc            (alu_cmt_pc         ),
    .cmt_o_instr         (alu_cmt_instr      ),
    .cmt_o_imm           (alu_cmt_imm        ),
    .cmt_o_rv32          (alu_cmt_rv32       ),
    .cmt_o_bjp           (alu_cmt_bjp        ),
    .cmt_o_dret          (alu_cmt_dret        ),
    .cmt_o_mret          (alu_cmt_mret        ),
    .cmt_o_ecall         (alu_cmt_ecall      ),
    .cmt_o_ebreak        (alu_cmt_ebreak     ),
    .cmt_o_fencei        (alu_cmt_fencei     ),
    .cmt_o_wfi           (alu_cmt_wfi        ),
    .cmt_o_ifu_misalgn   (alu_cmt_ifu_misalgn),
    .cmt_o_ifu_buserr    (alu_cmt_ifu_buserr ),
    .cmt_o_ifu_ilegl     (alu_cmt_ifu_ilegl  ),
    .cmt_o_bjp_prdt      (alu_cmt_bjp_prdt   ),
    .cmt_o_bjp_rslv      (alu_cmt_bjp_rslv   ),
    .cmt_o_misalgn       (alu_cmt_misalgn),
    .cmt_o_ld            (alu_cmt_ld),
    .cmt_o_stamo         (alu_cmt_stamo),
    .cmt_o_buserr        (alu_cmt_buserr),
    .cmt_o_badaddr       (alu_cmt_badaddr),

    .wbck_o_valid        (alu_wbck_o_valid ), 
    .wbck_o_ready        (alu_wbck_o_ready ),
    .wbck_o_wdat         (alu_wbck_o_wdat  ),
    .wbck_o_rdidx        (alu_wbck_o_rdidx ),

    .csr_ena             (csr_ena),
    .csr_idx             (csr_idx),
    .csr_rd_en           (csr_rd_en),
    .csr_wr_en           (csr_wr_en),
    .read_csr_dat        (read_csr_dat),
    .wbck_csr_dat        (wbck_csr_dat),

    .agu_icb_cmd_valid   (agu_icb_cmd_valid ),
    .agu_icb_cmd_ready   (agu_icb_cmd_ready ),
    .agu_icb_cmd_addr    (agu_icb_cmd_addr ),
    .agu_icb_cmd_read    (agu_icb_cmd_read   ),
    .agu_icb_cmd_wdata   (agu_icb_cmd_wdata ),
    .agu_icb_cmd_wmask   (agu_icb_cmd_wmask ),
    .agu_icb_cmd_lock    (agu_icb_cmd_lock),
    .agu_icb_cmd_excl    (agu_icb_cmd_excl),
    .agu_icb_cmd_size    (agu_icb_cmd_size),
   
    .agu_icb_cmd_back2agu(agu_icb_cmd_back2agu ),
    .agu_icb_cmd_usign   (agu_icb_cmd_usign),
    .agu_icb_cmd_itag    (agu_icb_cmd_itag),
  
    .agu_icb_rsp_valid   (agu_icb_rsp_valid ),
    .agu_icb_rsp_ready   (agu_icb_rsp_ready ),
    .agu_icb_rsp_err     (agu_icb_rsp_err   ),
    .agu_icb_rsp_excl_ok (agu_icb_rsp_excl_ok),
    .agu_icb_rsp_rdata   (agu_icb_rsp_rdata),

    


    .mdv_nob2b         (mdv_nob2b),

    .clk                 (clk          ),
    .rst_n               (rst_n        ) 
  );

  //////////////////////////////////////////////////////////////
  // Instantiate the Long-pipe Write-Back
  wire longp_wbck_o_valid;
  wire longp_wbck_o_ready;
  wire [`E203_FLEN-1:0] longp_wbck_o_wdat;
  wire [`E203_RFIDX_WIDTH-1:0] longp_wbck_o_rdidx;
  wire longp_wbck_o_rdfpu;
  wire [4:0] longp_wbck_o_flags;

  wire longp_excp_o_ready;
  wire longp_excp_o_valid;
  wire longp_excp_o_ld;
  wire longp_excp_o_st;
  wire longp_excp_o_buserr ;
  wire[`E203_ADDR_SIZE-1:0]longp_excp_o_badaddr;
  wire longp_excp_o_insterr;
  wire[`E203_PC_SIZE-1:0]longp_excp_o_pc;

  e203_exu_longpwbck u_e203_exu_longpwbck(

    .lsu_wbck_i_valid   (lsu_o_valid ),
    .lsu_wbck_i_ready   (lsu_o_ready ),
    .lsu_wbck_i_wdat    (lsu_o_wbck_wdat  ),
    .lsu_wbck_i_itag    (lsu_o_wbck_itag  ),
    .lsu_wbck_i_err     (lsu_o_wbck_err   ),
    .lsu_cmt_i_ld       (lsu_o_cmt_ld     ),
    .lsu_cmt_i_st       (lsu_o_cmt_st     ),
    .lsu_cmt_i_badaddr  (lsu_o_cmt_badaddr),
    .lsu_cmt_i_buserr   (lsu_o_cmt_buserr ),

    .longp_wbck_o_valid   (longp_wbck_o_valid ), 
    .longp_wbck_o_ready   (longp_wbck_o_ready ),
    .longp_wbck_o_wdat    (longp_wbck_o_wdat  ),
    .longp_wbck_o_rdidx   (longp_wbck_o_rdidx ),
    .longp_wbck_o_rdfpu   (longp_wbck_o_rdfpu ),
    .longp_wbck_o_flags   (longp_wbck_o_flags ),

    .longp_excp_o_ready   (longp_excp_o_ready  ),
    .longp_excp_o_valid   (longp_excp_o_valid  ),
    .longp_excp_o_ld      (longp_excp_o_ld     ),
    .longp_excp_o_st      (longp_excp_o_st     ),
    .longp_excp_o_buserr  (longp_excp_o_buserr ),
    .longp_excp_o_badaddr (longp_excp_o_badaddr),
    .longp_excp_o_insterr (longp_excp_o_insterr),
    .longp_excp_o_pc      (longp_excp_o_pc),

    .oitf_ret_rdidx      (oitf_ret_rdidx),
    .oitf_ret_rdwen      (oitf_ret_rdwen),
    .oitf_ret_rdfpu      (oitf_ret_rdfpu),
    .oitf_ret_pc         (oitf_ret_pc),
    .oitf_empty          (oitf_empty    ),
    .oitf_ret_ptr        (oitf_ret_ptr  ),
    .oitf_ret_ena        (oitf_ret_ena  ),
    



    .clk                 (clk          ),
    .rst_n               (rst_n        ) 
  );


  //////////////////////////////////////////////////////////////
  // Instantiate the Final Write-Back
  e203_exu_wbck u_e203_exu_wbck(

    .alu_wbck_i_valid   (alu_wbck_o_valid ), 
    .alu_wbck_i_ready   (alu_wbck_o_ready ),
    .alu_wbck_i_wdat    (alu_wbck_o_wdat  ),
    .alu_wbck_i_rdidx   (alu_wbck_o_rdidx ),
                         
    .longp_wbck_i_valid (longp_wbck_o_valid ), 
    .longp_wbck_i_ready (longp_wbck_o_ready ),
    .longp_wbck_i_wdat  (longp_wbck_o_wdat  ),
    .longp_wbck_i_rdidx (longp_wbck_o_rdidx ),
    .longp_wbck_i_rdfpu (longp_wbck_o_rdfpu ),
    .longp_wbck_i_flags (longp_wbck_o_flags ),

    .rf_wbck_o_ena      (rf_wbck_ena    ),
    .rf_wbck_o_wdat     (rf_wbck_wdat   ),
    .rf_wbck_o_rdidx    (rf_wbck_rdidx  ),
       

    .clk                 (clk          ),
    .rst_n               (rst_n        ) 
  );

  //////////////////////////////////////////////////////////////
  // Instantiate the Commit
  wire [`E203_ADDR_SIZE-1:0] cmt_badaddr;
  wire cmt_badaddr_ena;
  wire [`E203_PC_SIZE-1:0] cmt_epc;
  wire cmt_epc_ena;
  wire [`E203_XLEN-1:0] cmt_cause;
  wire cmt_cause_ena;
  wire cmt_instret_ena;
  wire cmt_status_ena;

  wire                      cmt_mret_ena;

  wire [`E203_PC_SIZE-1:0]  csr_epc_r;
  wire [`E203_PC_SIZE-1:0]  csr_dpc_r;
  wire [`E203_XLEN-1:0]     csr_mtvec_r;

  wire u_mode;
  wire s_mode;
  wire h_mode;
  wire m_mode;

  wire status_mie_r;
  wire mtie_r;
  wire msie_r;
  wire meie_r;



  e203_exu_commit u_e203_exu_commit(
    .commit_mret         (commit_mret),
    .commit_trap         (commit_trap),
    .core_wfi            (core_wfi        ),
    .nonflush_cmt_ena    (nonflush_cmt_ena),

    .excp_active         (excp_active),

    .amo_wait            (amo_wait     ),

    .wfi_halt_exu_req    (wfi_halt_exu_req),
    .wfi_halt_exu_ack    (wfi_halt_exu_ack),
    .wfi_halt_ifu_req    (wfi_halt_ifu_req),
    .wfi_halt_ifu_ack    (wfi_halt_ifu_ack),

    .dbg_irq_r               (dbg_irq_r),
    .lcl_irq_r               (lcl_irq_r),
    .ext_irq_r               (ext_irq_r),
    .sft_irq_r               (sft_irq_r),
    .tmr_irq_r               (tmr_irq_r),
    .evt_r                   (evt_r    ),

    .status_mie_r            (status_mie_r),
    .mtie_r                  (mtie_r      ),
    .msie_r                  (msie_r      ),
    .meie_r                  (meie_r      ),

    .alu_cmt_i_valid         (alu_cmt_valid      ),
    .alu_cmt_i_ready         (alu_cmt_ready      ),
    .alu_cmt_i_pc            (alu_cmt_pc         ),
    .alu_cmt_i_instr         (alu_cmt_instr      ),
    .alu_cmt_i_pc_vld        (alu_cmt_pc_vld     ),
    .alu_cmt_i_imm           (alu_cmt_imm        ),
    .alu_cmt_i_rv32          (alu_cmt_rv32       ),
    .alu_cmt_i_bjp           (alu_cmt_bjp        ),
    .alu_cmt_i_mret          (alu_cmt_mret        ),
    .alu_cmt_i_dret          (alu_cmt_dret        ),
    .alu_cmt_i_ecall         (alu_cmt_ecall      ),
    .alu_cmt_i_ebreak        (alu_cmt_ebreak     ),
    .alu_cmt_i_fencei        (alu_cmt_fencei     ),
    .alu_cmt_i_wfi           (alu_cmt_wfi     ),
    .alu_cmt_i_ifu_misalgn   (alu_cmt_ifu_misalgn),
    .alu_cmt_i_ifu_buserr    (alu_cmt_ifu_buserr ),
    .alu_cmt_i_ifu_ilegl     (alu_cmt_ifu_ilegl  ),
    .alu_cmt_i_bjp_prdt      (alu_cmt_bjp_prdt   ),
    .alu_cmt_i_bjp_rslv      (alu_cmt_bjp_rslv   ),
    .alu_cmt_i_misalgn       (alu_cmt_misalgn),
    .alu_cmt_i_ld            (alu_cmt_ld),
    .alu_cmt_i_stamo         (alu_cmt_stamo),
    .alu_cmt_i_buserr        (alu_cmt_buserr),
    .alu_cmt_i_badaddr       (alu_cmt_badaddr),


    .longp_excp_i_ready    (longp_excp_o_ready  ),
    .longp_excp_i_valid    (longp_excp_o_valid  ),
    .longp_excp_i_ld       (longp_excp_o_ld     ),
    .longp_excp_i_st       (longp_excp_o_st     ),
    .longp_excp_i_buserr   (longp_excp_o_buserr ),
    .longp_excp_i_badaddr  (longp_excp_o_badaddr),
    .longp_excp_i_insterr  (longp_excp_o_insterr),
    .longp_excp_i_pc       (longp_excp_o_pc     ),

    .dbg_mode              (dbg_mode),
    .dbg_halt_r            (dbg_halt_r),
    .dbg_step_r            (dbg_step_r),
    .dbg_ebreakm_r         (dbg_ebreakm_r),


    .oitf_empty            (oitf_empty),
    .u_mode                (u_mode),
    .s_mode                (s_mode),
    .h_mode                (h_mode),
    .m_mode                (m_mode),

    .cmt_badaddr           (cmt_badaddr    ), 
    .cmt_badaddr_ena       (cmt_badaddr_ena),
    .cmt_epc               (cmt_epc        ),
    .cmt_epc_ena           (cmt_epc_ena    ),
    .cmt_cause             (cmt_cause      ),
    .cmt_cause_ena         (cmt_cause_ena  ),
    .cmt_instret_ena       (cmt_instret_ena  ),
    .cmt_status_ena        (cmt_status_ena  ),
                           
    .cmt_dpc               (cmt_dpc        ),
    .cmt_dpc_ena           (cmt_dpc_ena    ),
    .cmt_dcause            (cmt_dcause     ),
    .cmt_dcause_ena        (cmt_dcause_ena ),

    .cmt_mret_ena            (cmt_mret_ena     ),
    .csr_epc_r               (csr_epc_r       ),
    .csr_dpc_r               (csr_dpc_r       ),
    .csr_mtvec_r             (csr_mtvec_r     ),

    .flush_pulse             (flush_pulse    ),
    .flush_req           (flush_req      ),

    .pipe_flush_ack          (pipe_flush_ack    ),
    .pipe_flush_req          (pipe_flush_req    ),
    .pipe_flush_add_op1      (pipe_flush_add_op1),  
    .pipe_flush_add_op2      (pipe_flush_add_op2),  
  `ifdef E203_TIMING_BOOST//}
    .pipe_flush_pc           (pipe_flush_pc),  
  `endif//}

    .clk                     (clk          ),
    .rst_n                   (rst_n        ) 
  );

    
    // The Decode to IFU read-en used for the branch dependency check
    //   only need to check the integer regfile, so here we need to exclude
    //   the FPU condition out
  assign dec2ifu_rden  = disp_oitf_rdwen & (~disp_oitf_rdfpu); 
  assign dec2ifu_rs1en = disp_oitf_rs1en & (~disp_oitf_rs1fpu);
  assign dec2ifu_rdidx = dec_rdidx;
  assign rf2ifu_rs1    = rf_rs1;




  e203_exu_csr u_e203_exu_csr(
    .csr_access_ilgl     (csr_access_ilgl),
    .eai_xs_off          (eai_xs_off),
    .nonflush_cmt_ena    (nonflush_cmt_ena),
    .tm_stop             (tm_stop),
    .itcm_nohold         (itcm_nohold),
    .mdv_nob2b           (mdv_nob2b),
    .core_cgstop         (core_cgstop),
    .tcm_cgstop          (tcm_cgstop ),
    .csr_ena             (csr_ena),
    .csr_idx             (csr_idx),
    .csr_rd_en           (csr_rd_en),
    .csr_wr_en           (csr_wr_en),
    .read_csr_dat        (read_csr_dat),
    .wbck_csr_dat        (wbck_csr_dat),
   
    .cmt_badaddr           (cmt_badaddr    ), 
    .cmt_badaddr_ena       (cmt_badaddr_ena),
    .cmt_epc               (cmt_epc        ),
    .cmt_epc_ena           (cmt_epc_ena    ),
    .cmt_cause             (cmt_cause      ),
    .cmt_cause_ena         (cmt_cause_ena  ),
    .cmt_instret_ena       (cmt_instret_ena  ),
    .cmt_status_ena        (cmt_status_ena ),

    .cmt_mret_ena  (cmt_mret_ena     ),
    .csr_epc_r     (csr_epc_r       ),
    .csr_dpc_r     (csr_dpc_r       ),
    .csr_mtvec_r   (csr_mtvec_r     ),

    .wr_dcsr_ena     (wr_dcsr_ena    ),
    .wr_dpc_ena      (wr_dpc_ena     ),
    .wr_dscratch_ena (wr_dscratch_ena),

                                     
    .wr_csr_nxt      (wr_csr_nxt    ),
                                     
    .dcsr_r          (dcsr_r         ),
    .dpc_r           (dpc_r          ),
    .dscratch_r      (dscratch_r     ),
                                    
    .dbg_mode       (dbg_mode       ),
    .dbg_stopcycle  (dbg_stopcycle),

    .u_mode        (u_mode),
    .s_mode        (s_mode),
    .h_mode        (h_mode),
    .m_mode        (m_mode),

    .core_mhartid  (core_mhartid),

    .status_mie_r  (status_mie_r),
    .mtie_r        (mtie_r      ),
    .msie_r        (msie_r      ),
    .meie_r        (meie_r      ),

    .ext_irq_r     (ext_irq_r),
    .sft_irq_r     (sft_irq_r),
    .tmr_irq_r     (tmr_irq_r),

    .clk_aon       (clk_aon      ),
    .clk           (clk          ),
    .rst_n         (rst_n        ) 
  );

  assign exu_active = (~oitf_empty) | i_valid | excp_active;


endmodule                                      
                                               
                                               
                                               
