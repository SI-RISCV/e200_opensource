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
//  The Commit module to commit instructions or flush pipeline
//
// ====================================================================


`include "e203_defines.v"

module e203_exu_commit(
  output  commit_mret,
  output  commit_trap,
  output  core_wfi,
  output  nonflush_cmt_ena,

  output  excp_active,

  input   amo_wait,

  output  wfi_halt_ifu_req,
  output  wfi_halt_exu_req,
  input   wfi_halt_ifu_ack,
  input   wfi_halt_exu_ack,

  input  dbg_irq_r,
  input  [`E203_LIRQ_NUM-1:0] lcl_irq_r,
  input  ext_irq_r,
  input  sft_irq_r,
  input  tmr_irq_r,
  input  [`E203_EVT_NUM-1:0] evt_r,

  input   status_mie_r,
  input   mtie_r,
  input   msie_r,
  input   meie_r,

  input                      alu_cmt_i_valid,
  output                     alu_cmt_i_ready,
  input  [`E203_PC_SIZE-1:0] alu_cmt_i_pc,  
  input  [`E203_INSTR_SIZE-1:0] alu_cmt_i_instr,  
  input                      alu_cmt_i_pc_vld,  
  input  [`E203_XLEN-1:0]    alu_cmt_i_imm,
  input                      alu_cmt_i_rv32,
    //   The Branch Commit
  input                      alu_cmt_i_bjp,
  input                      alu_cmt_i_wfi,
  input                      alu_cmt_i_fencei,
  input                      alu_cmt_i_mret,
  input                      alu_cmt_i_dret,
  input                      alu_cmt_i_ecall,
  input                      alu_cmt_i_ebreak,
  input                      alu_cmt_i_ifu_misalgn ,
  input                      alu_cmt_i_ifu_buserr ,
  input                      alu_cmt_i_ifu_ilegl ,
  input                      alu_cmt_i_bjp_prdt,// The predicted ture/false  
  input                      alu_cmt_i_bjp_rslv,// The resolved ture/false
    //   The AGU Exception 
  input                      alu_cmt_i_misalgn, // The misalign exception generated
  input                      alu_cmt_i_ld,
  input                      alu_cmt_i_stamo,
  input                      alu_cmt_i_buserr , // The bus-error exception generated
  input [`E203_ADDR_SIZE-1:0]alu_cmt_i_badaddr,
  
  output  [`E203_ADDR_SIZE-1:0] cmt_badaddr,
  output  cmt_badaddr_ena,
  output  [`E203_PC_SIZE-1:0] cmt_epc,
  output  cmt_epc_ena,
  output  [`E203_XLEN-1:0] cmt_cause,
  output  cmt_cause_ena,
  output  cmt_instret_ena,
  output  cmt_status_ena,

  output  [`E203_PC_SIZE-1:0] cmt_dpc,
  output  cmt_dpc_ena,
  output  [3-1:0] cmt_dcause,
  output  cmt_dcause_ena,

  output                     cmt_mret_ena,

  input [`E203_PC_SIZE-1:0]  csr_epc_r,
  input [`E203_PC_SIZE-1:0]  csr_dpc_r,
  input [`E203_XLEN-1:0]     csr_mtvec_r,

  input   dbg_mode,
  input   dbg_halt_r,
  input   dbg_step_r,
  input   dbg_ebreakm_r,


  input   oitf_empty,
  
  input   u_mode,
  input   s_mode,
  input   h_mode,
  input   m_mode,

  output                     longp_excp_i_ready,
  input                      longp_excp_i_valid,
  input                      longp_excp_i_ld,
  input                      longp_excp_i_st,
  input                      longp_excp_i_buserr , // The load/store bus-error exception generated
  input [`E203_ADDR_SIZE-1:0]longp_excp_i_badaddr,
  input                      longp_excp_i_insterr,
  input [`E203_PC_SIZE-1:0]  longp_excp_i_pc,

  //////////////////////////////////////////////////////////////
  // The Flush interface to IFU
  //
  //   To save the gatecount, when we need to flush pipeline with new PC, 
  //     we want to reuse the adder in IFU, so we will not pass flush-PC
  //     to IFU, instead, we pass the flush-pc-adder-op1/op2 to IFU
  //     and IFU will just use its adder to caculate the flush-pc-adder-result
  //
  output  flush_pulse,
       // To cut the combinational loop, we need this flush_req from non-alu source to flush ALU pipeline (e.g., MUL-div statemachine)
  output  flush_req,

  input   pipe_flush_ack,
  output  pipe_flush_req,
  output  [`E203_PC_SIZE-1:0] pipe_flush_add_op1,  
  output  [`E203_PC_SIZE-1:0] pipe_flush_add_op2,  
  `ifdef E203_TIMING_BOOST//}
  output  [`E203_PC_SIZE-1:0] pipe_flush_pc,  
  `endif//}

  input  clk,
  input  rst_n
  );


  wire                      alu_brchmis_flush_ack;
  wire                      alu_brchmis_flush_req;
  wire  [`E203_PC_SIZE-1:0] alu_brchmis_flush_add_op1;  
  wire  [`E203_PC_SIZE-1:0] alu_brchmis_flush_add_op2;
  `ifdef E203_TIMING_BOOST//}
  wire [`E203_PC_SIZE-1:0] alu_brchmis_flush_pc;
  `endif//}
  wire                      alu_brchmis_cmt_i_ready;

  wire                      cmt_dret_ena;

  wire nonalu_excpirq_flush_req_raw;

  e203_exu_branchslv u_e203_exu_branchslv(
    .cmt_i_ready             (alu_brchmis_cmt_i_ready    ),
    .cmt_i_valid             (alu_cmt_i_valid   ),  
    .cmt_i_rv32              (alu_cmt_i_rv32    ),  
    .cmt_i_bjp               (alu_cmt_i_bjp     ),  
    .cmt_i_fencei            (alu_cmt_i_fencei  ),
    .cmt_i_mret              (alu_cmt_i_mret     ),
    .cmt_i_dret              (alu_cmt_i_dret     ),
    .cmt_i_bjp_prdt          (alu_cmt_i_bjp_prdt),
    .cmt_i_bjp_rslv          (alu_cmt_i_bjp_rslv),
    .cmt_i_pc                (alu_cmt_i_pc      ),
    .cmt_i_imm               (alu_cmt_i_imm     ),
                         
    .cmt_mret_ena            (cmt_mret_ena       ),
    .cmt_dret_ena            (cmt_dret_ena       ),
    .cmt_fencei_ena          (),
    .csr_epc_r               (csr_epc_r         ),
    .csr_dpc_r               (csr_dpc_r         ),


    .nonalu_excpirq_flush_req_raw(nonalu_excpirq_flush_req_raw ),
    .brchmis_flush_ack       (alu_brchmis_flush_ack    ),
    .brchmis_flush_req       (alu_brchmis_flush_req    ),
    .brchmis_flush_add_op1   (alu_brchmis_flush_add_op1),  
    .brchmis_flush_add_op2   (alu_brchmis_flush_add_op2),  
  `ifdef E203_TIMING_BOOST//}
    .brchmis_flush_pc        (alu_brchmis_flush_pc),  
  `endif//}

    .clk   (clk  ),
    .rst_n (rst_n)
  );

  wire excpirq_flush_ack;
  wire excpirq_flush_req;
  wire [`E203_PC_SIZE-1:0] excpirq_flush_add_op1;  
  wire [`E203_PC_SIZE-1:0] excpirq_flush_add_op2;
  `ifdef E203_TIMING_BOOST//}
  wire [`E203_PC_SIZE-1:0] excpirq_flush_pc;
  `endif//}
  wire [`E203_XLEN-1:0] excpirq_cause;
  wire alu_excp_cmt_i_ready;

  wire cmt_ena;


  e203_exu_excp u_e203_exu_excp(
    .commit_trap           (commit_trap     ),
    .core_wfi              (core_wfi        ),
    .wfi_halt_ifu_req      (wfi_halt_ifu_req),
    .wfi_halt_exu_req      (wfi_halt_exu_req),
    .wfi_halt_ifu_ack      (wfi_halt_ifu_ack),
    .wfi_halt_exu_ack      (wfi_halt_exu_ack),

    .cmt_badaddr           (cmt_badaddr    ), 
    .cmt_badaddr_ena       (cmt_badaddr_ena),
    .cmt_epc               (cmt_epc        ),
    .cmt_epc_ena           (cmt_epc_ena    ),
    .cmt_cause             (cmt_cause      ),
    .cmt_cause_ena         (cmt_cause_ena  ),
    .cmt_status_ena        (cmt_status_ena ),
                           
    .cmt_dpc               (cmt_dpc        ),
    .cmt_dpc_ena           (cmt_dpc_ena    ),
    .cmt_dcause            (cmt_dcause     ),
    .cmt_dcause_ena        (cmt_dcause_ena ),

    .cmt_dret_ena          (cmt_dret_ena   ),
    .cmt_ena               (cmt_ena        ),

    .alu_excp_i_valid      (alu_cmt_i_valid  ),
    .alu_excp_i_ready      (alu_excp_cmt_i_ready    ),
    .alu_excp_i_misalgn    (alu_cmt_i_misalgn),
    .alu_excp_i_ld         (alu_cmt_i_ld     ),
    .alu_excp_i_stamo      (alu_cmt_i_stamo  ),
    .alu_excp_i_buserr     (alu_cmt_i_buserr ),
    .alu_excp_i_pc         (alu_cmt_i_pc     ),
    .alu_excp_i_instr      (alu_cmt_i_instr  ),
    .alu_excp_i_pc_vld     (alu_cmt_i_pc_vld ),
    .alu_excp_i_badaddr    (alu_cmt_i_badaddr ),
    .alu_excp_i_ecall      (alu_cmt_i_ecall   ),
    .alu_excp_i_ebreak     (alu_cmt_i_ebreak  ),
    .alu_excp_i_wfi        (alu_cmt_i_wfi  ),
    .alu_excp_i_ifu_misalgn(alu_cmt_i_ifu_misalgn),
    .alu_excp_i_ifu_buserr (alu_cmt_i_ifu_buserr ),
    .alu_excp_i_ifu_ilegl  (alu_cmt_i_ifu_ilegl  ),
                         
    .longp_excp_i_ready    (longp_excp_i_ready  ),
    .longp_excp_i_valid    (longp_excp_i_valid  ),
    .longp_excp_i_ld       (longp_excp_i_ld     ),
    .longp_excp_i_st       (longp_excp_i_st     ),
    .longp_excp_i_buserr   (longp_excp_i_buserr ),
    .longp_excp_i_badaddr  (longp_excp_i_badaddr),
    .longp_excp_i_insterr  (longp_excp_i_insterr),
    .longp_excp_i_pc       (longp_excp_i_pc     ),

    .csr_mtvec_r           (csr_mtvec_r       ),

    .dbg_irq_r             (dbg_irq_r),
    .lcl_irq_r             (lcl_irq_r),
    .ext_irq_r             (ext_irq_r),
    .sft_irq_r             (sft_irq_r),
    .tmr_irq_r             (tmr_irq_r),

    .status_mie_r          (status_mie_r),
    .mtie_r                (mtie_r      ),
    .msie_r                (msie_r      ),
    .meie_r                (meie_r      ),


    .dbg_mode              (dbg_mode),
    .dbg_halt_r            (dbg_halt_r),
    .dbg_step_r            (dbg_step_r),
    .dbg_ebreakm_r         (dbg_ebreakm_r),
    .oitf_empty            (oitf_empty),

    .u_mode                (u_mode),
    .s_mode                (s_mode),
    .h_mode                (h_mode),
    .m_mode                (m_mode),

    .excpirq_flush_ack        (excpirq_flush_ack       ),
    .excpirq_flush_req        (excpirq_flush_req       ),
    .nonalu_excpirq_flush_req_raw (nonalu_excpirq_flush_req_raw ),
    .excpirq_flush_add_op1    (excpirq_flush_add_op1),  
    .excpirq_flush_add_op2    (excpirq_flush_add_op2),  
  `ifdef E203_TIMING_BOOST//}
    .excpirq_flush_pc         (excpirq_flush_pc),
  `endif//}

    .excp_active (excp_active),
    .amo_wait (amo_wait),

    .clk   (clk  ),
    .rst_n (rst_n)
  );

 

  assign excpirq_flush_ack = pipe_flush_ack;
  assign alu_brchmis_flush_ack = pipe_flush_ack;

  assign pipe_flush_req = excpirq_flush_req | alu_brchmis_flush_req;
            
  assign alu_cmt_i_ready = alu_excp_cmt_i_ready & alu_brchmis_cmt_i_ready;

  assign pipe_flush_add_op1 = excpirq_flush_req ? excpirq_flush_add_op1 : alu_brchmis_flush_add_op1;  
  assign pipe_flush_add_op2 = excpirq_flush_req ? excpirq_flush_add_op2 : alu_brchmis_flush_add_op2;  
  `ifdef E203_TIMING_BOOST//}
  assign pipe_flush_pc      = excpirq_flush_req ? excpirq_flush_pc : alu_brchmis_flush_pc;  
  `endif//}

  assign cmt_ena = alu_cmt_i_valid & alu_cmt_i_ready;
  assign cmt_instret_ena = cmt_ena & (~alu_brchmis_flush_req);

  // Generate the signal as the real-commit enable (non-flush)
  assign nonflush_cmt_ena = cmt_ena & (~pipe_flush_req);


  assign flush_pulse = pipe_flush_ack & pipe_flush_req;
  assign flush_req   = nonalu_excpirq_flush_req_raw;

  assign commit_mret = cmt_mret_ena;

`ifndef FPGA_SOURCE//{
`ifndef DISABLE_SV_ASSERTION//{
//synopsys translate_off

 `ifndef E203_HAS_LOCKSTEP//{
CHECK_1HOT_FLUSH_HALT:
  assert property (@(posedge clk) disable iff (~rst_n)
                     ($onehot0({wfi_halt_ifu_req,pipe_flush_req}))
                  )
  else $fatal ("\n Error: Oops, detected non-onehot0 value for halt and flush req!!! This should never happen. \n");
 `endif//}

//synopsys translate_on
`endif//}
`endif//}

endmodule                                      
                                               
                                               
                                               
