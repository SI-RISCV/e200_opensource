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
//  The module to handle the different exceptions
//
// ====================================================================
`include "e203_defines.v"


module e203_exu_excp(
  output  commit_trap,
  output  core_wfi,
  output  wfi_halt_ifu_req,
  output  wfi_halt_exu_req,
  input   wfi_halt_ifu_ack,
  input   wfi_halt_exu_ack,

  input   amo_wait,

  output  alu_excp_i_ready,
  input   alu_excp_i_valid       ,
  input   alu_excp_i_ld          ,
  input   alu_excp_i_stamo       ,
  input   alu_excp_i_misalgn     ,
  input   alu_excp_i_buserr ,
  input   alu_excp_i_ecall ,
  input   alu_excp_i_ebreak ,
  input   alu_excp_i_wfi ,
  input   alu_excp_i_ifu_misalgn ,
  input   alu_excp_i_ifu_buserr ,
  input   alu_excp_i_ifu_ilegl ,
  input   [`E203_ADDR_SIZE-1:0] alu_excp_i_badaddr,
  input   [`E203_PC_SIZE-1:0] alu_excp_i_pc,
  input   [`E203_INSTR_SIZE-1:0] alu_excp_i_instr,
  input   alu_excp_i_pc_vld,
  
  output  longp_excp_i_ready,
  input   longp_excp_i_valid,
  input   longp_excp_i_ld,
  input   longp_excp_i_st,// 1: load, 0: store
  input   longp_excp_i_buserr , // The load/store bus-error exception generated
  input   longp_excp_i_insterr, 
  input   [`E203_ADDR_SIZE-1:0] longp_excp_i_badaddr,
  input   [`E203_PC_SIZE-1:0] longp_excp_i_pc,

  input   excpirq_flush_ack,
  output  excpirq_flush_req,
  output  nonalu_excpirq_flush_req_raw,
  output  [`E203_PC_SIZE-1:0] excpirq_flush_add_op1,  
  output  [`E203_PC_SIZE-1:0] excpirq_flush_add_op2,  
  `ifdef E203_TIMING_BOOST//}
  output  [`E203_PC_SIZE-1:0] excpirq_flush_pc,  
  `endif//}

  input   [`E203_XLEN-1:0] csr_mtvec_r,
  input   cmt_dret_ena,
  input   cmt_ena,

  output  [`E203_ADDR_SIZE-1:0] cmt_badaddr,
  output  [`E203_PC_SIZE-1:0] cmt_epc,
  output  [`E203_XLEN-1:0] cmt_cause,
  output  cmt_badaddr_ena,
  output  cmt_epc_ena,
  output  cmt_cause_ena,
  output  cmt_status_ena,

  output  [`E203_PC_SIZE-1:0] cmt_dpc,
  output  cmt_dpc_ena,
  output  [3-1:0] cmt_dcause,
  output  cmt_dcause_ena,


  input   dbg_irq_r,
  input   [`E203_LIRQ_NUM-1:0] lcl_irq_r,
  input   ext_irq_r,
  input   sft_irq_r,
  input   tmr_irq_r,

  input   status_mie_r,
  input   mtie_r,
  input   msie_r,
  input   meie_r,

  input   dbg_mode,
  input   dbg_halt_r,
  input   dbg_step_r,
  input   dbg_ebreakm_r,


  input   oitf_empty,

  input   u_mode,
  input   s_mode,
  input   h_mode,
  input   m_mode,

  output  excp_active,

  input   clk,
  input   rst_n
  );

  ////////////////////////////////////////////////////////////////////////////
  // Because the core's clock may be gated when it is idle, we need to check
  //  if the interrupts is coming, and generate an active indication, and use
  //  this active signal to turn on core's clock
  wire irq_req_active;
  wire nonalu_dbg_entry_req_raw;

  assign excp_active = irq_req_active | nonalu_dbg_entry_req_raw;


  ////////////////////////////////////////////////////////////////////////////
  // WFI flag generation
  //
  wire wfi_req_hsked = (wfi_halt_ifu_req & wfi_halt_ifu_ack & wfi_halt_exu_req & wfi_halt_exu_ack)
                          ;
     // The wfi_flag will be set if there is a new WFI instruction halt req handshaked
  wire wfi_flag_set = wfi_req_hsked;
     // The wfi_flag will be cleared if there is interrupt pending, or debug entry request
  wire wfi_irq_req;
  wire dbg_entry_req;
  wire wfi_flag_r;
  wire wfi_flag_clr = (wfi_irq_req | dbg_entry_req);// & wfi_flag_r;// Here we cannot use this flag_r
  wire wfi_flag_ena = wfi_flag_set | wfi_flag_clr;
     // If meanwhile set and clear, then clear preempt
  wire wfi_flag_nxt = wfi_flag_set & (~wfi_flag_clr);
  sirv_gnrl_dfflr #(1) wfi_flag_dfflr (wfi_flag_ena, wfi_flag_nxt, wfi_flag_r, clk, rst_n);
  assign core_wfi = wfi_flag_r & (~wfi_flag_clr);

     // The wfi_halt_req will be set if there is a new WFI instruction committed
           // And note in debug mode WFI is treated as nop
  wire wfi_cmt_ena = alu_excp_i_wfi & cmt_ena;
  wire wfi_halt_req_set = wfi_cmt_ena & (~dbg_mode);
     // The wfi_halt_req will be cleared same as wfi_flag_r
  wire wfi_halt_req_clr = wfi_flag_clr;
  wire wfi_halt_req_ena = wfi_halt_req_set | wfi_halt_req_clr;
     // If meanwhile set and clear, then clear preempt
  wire wfi_halt_req_nxt = wfi_halt_req_set & (~wfi_halt_req_clr);
  wire wfi_halt_req_r;
  sirv_gnrl_dfflr #(1) wfi_halt_req_dfflr (wfi_halt_req_ena, wfi_halt_req_nxt, wfi_halt_req_r, clk, rst_n);
    // In order to make sure the flush to IFU and halt to IFU is not asserte at same cycle
    //   we use the clr signal here to qualify it
  assign wfi_halt_ifu_req = (wfi_halt_req_r & (~wfi_halt_req_clr))
                            ;
    // To cut the comb loops, we dont use the clr signal here to qualify, 
    //   the outcome is the halt-to-exu will be deasserted 1 cycle later than to-IFU
    //   but it doesnt matter much.
  assign wfi_halt_exu_req = wfi_halt_req_r 
                            ;





  wire irq_req;
  wire longp_need_flush;
  wire alu_need_flush;
  wire dbg_ebrk_req;
  wire dbg_trig_req;

  ////////////////////////////////////////////////////////////////////////////
  // The Exception generate included several cases, priority from top to down
  //   *** Long-pipe triggered exception
  //       ---- Must wait the PC vld 
  //   *** DebugMode-entry triggered exception (included ALU ebreakm)
  //       ---- Must wait the OITF empty and PC vld 
  //   *** IRQ triggered exception
  //       ---- Must wait the OITF empty and PC vld 
  //   *** ALU triggered exception (excluded the ebreakm into debug-mode)  
  //       ---- Must wait the OITF empty 
  
  // Exclude the pc_vld for longp, to just always make sure the longp can always accepted
  wire longp_excp_flush_req = longp_need_flush ;
  assign longp_excp_i_ready = excpirq_flush_ack;

  //   ^^^ Below we qualified the pc_vld signal to IRQ and Debug-entry req, why? 
  //       -- The Asyn-precise-excp (include IRQ and Debug-entry exception) 
  //            need to use the next upcoming (not yet commited) instruction's PC
  //            for the mepc value, so we must wait next valid instruction coming
  //            and use its PC.
  //       -- The pc_vld indicate is just used to indicate next instruction's valid
  //            PC value.
  //   ^^^ Then the questions are coming, is there a possible that there is no pc_vld
  //         comes forever? and then this async-precise-exception never
  //         get served, and then become a deadlock?
  //       -- It should not be. Becuase:
  //            The IFU is always actively fetching next instructions, never stop,
  //            so ideally it will always provide next valid instructions as
  //            long as the Ifetch-path (bus to external memory or ITCM) is not hang 
  //            (no bus response returned).
  //            ^^^ Then if there possible the Ifetch-path is hang? For examples:
  //                  -- The Ifetched external memory does not provide response because of the External IRQ is not
  //                       accepted by core.
  //                          ** How could it be? This should not happen, otherwise it is a SoC bug.
  //

  wire dbg_entry_flush_req  = dbg_entry_req & oitf_empty & alu_excp_i_pc_vld & (~longp_need_flush);
  wire alu_excp_i_ready4dbg = (excpirq_flush_ack & oitf_empty & alu_excp_i_pc_vld & (~longp_need_flush));

  wire irq_flush_req        = irq_req & oitf_empty & alu_excp_i_pc_vld
                              & (~dbg_entry_req)
                              & (~longp_need_flush);

  wire alu_excp_flush_req   = alu_excp_i_valid & alu_need_flush & oitf_empty 
                              & (~irq_req)
                              & (~dbg_entry_req)
                              & (~longp_need_flush);

  wire nonalu_dbg_entry_req;
  wire alu_excp_i_ready4nondbg =  alu_need_flush ? 
                                (excpirq_flush_ack & oitf_empty & (~irq_req) & (~nonalu_dbg_entry_req) & (~longp_need_flush))
                              : (  // The other higher priorty flush will override ALU commit
                                     (~irq_req)
                                   & (~nonalu_dbg_entry_req)
                                   & (~longp_need_flush)
                                );

  wire alu_ebreakm_flush_req_novld;
  wire alu_dbgtrig_flush_req_novld; 
  assign alu_excp_i_ready =  (alu_ebreakm_flush_req_novld | alu_dbgtrig_flush_req_novld) ? alu_excp_i_ready4dbg : alu_excp_i_ready4nondbg;




  assign excpirq_flush_req  = longp_excp_flush_req | dbg_entry_flush_req | irq_flush_req | alu_excp_flush_req;
  wire   all_excp_flush_req = longp_excp_flush_req | alu_excp_flush_req;

  assign nonalu_excpirq_flush_req_raw = 
             longp_need_flush | 
             nonalu_dbg_entry_req_raw |
             irq_req          ;


  wire excpirq_taken_ena = excpirq_flush_req & excpirq_flush_ack;
  assign commit_trap     = excpirq_taken_ena;

  wire excp_taken_ena      = all_excp_flush_req  & excpirq_taken_ena;
  wire irq_taken_ena       = irq_flush_req       & excpirq_taken_ena;
  wire dbg_entry_taken_ena = dbg_entry_flush_req & excpirq_taken_ena;

  assign excpirq_flush_add_op1 = dbg_entry_flush_req ? `E203_PC_SIZE'h800 : (all_excp_flush_req & dbg_mode) ? `E203_PC_SIZE'h808 : csr_mtvec_r;
  assign excpirq_flush_add_op2 = dbg_entry_flush_req ? `E203_PC_SIZE'h0   : (all_excp_flush_req & dbg_mode) ? `E203_PC_SIZE'h0   : `E203_PC_SIZE'b0; 
  `ifdef E203_TIMING_BOOST//}
  assign excpirq_flush_pc = dbg_entry_flush_req ? `E203_PC_SIZE'h800 : (all_excp_flush_req & dbg_mode) ? `E203_PC_SIZE'h808 : csr_mtvec_r;
  `endif//}

  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  // The Long-pipe triggered Exception 
  //                 
  assign longp_need_flush = longp_excp_i_valid;// The longp come to excp
                                             //   module always ask for excepiton

  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  // The DebugMode-entry triggered Exception 
  //

  wire step_req_r;
  wire alu_ebreakm_flush_req; 
  wire alu_dbgtrig_flush_req; 

  // The priority from top to down
                              // dbg_trig_req ? 3'd2 : 
                              // dbg_ebrk_req ? 3'd1 : 
                              // dbg_irq_req  ? 3'd3 : 
                              // dbg_step_req ? 3'd4 :
                              // dbg_halt_req ? 3'd5 : 
        // Since the step_req_r is last cycle generated indicated, means last instruction is single-step
        //   and it have been commited in non debug-mode, and then this cyclc step_req_r is the of the highest priority
  wire   dbg_step_req = step_req_r;
  assign dbg_trig_req = alu_dbgtrig_flush_req & (~step_req_r);
  assign dbg_ebrk_req = alu_ebreakm_flush_req & (~alu_dbgtrig_flush_req) & (~step_req_r);
  wire   dbg_irq_req  = dbg_irq_r  & (~alu_ebreakm_flush_req) & (~alu_dbgtrig_flush_req) & (~step_req_r);
  wire   nonalu_dbg_irq_req  = dbg_irq_r & (~step_req_r);
        // The step have higher priority, and will preempt the halt
  wire   dbg_halt_req = dbg_halt_r & (~dbg_irq_r) & (~alu_ebreakm_flush_req) & (~alu_dbgtrig_flush_req) & (~step_req_r) & (~dbg_step_r);
  wire   nonalu_dbg_halt_req = dbg_halt_r & (~dbg_irq_r) & (~step_req_r) & (~dbg_step_r);
  
  // The debug-step request will be set when currently the step_r is high, and one 
  //   instruction (in non debug_mode) have been executed
  // The step request will be clear when 
  //   core enter into the debug-mode 
  wire step_req_set = (~dbg_mode) & dbg_step_r & cmt_ena & (~dbg_entry_taken_ena);
  wire step_req_clr = dbg_entry_taken_ena;
  wire step_req_ena = step_req_set | step_req_clr;
  wire step_req_nxt = step_req_set | (~step_req_clr);
  sirv_gnrl_dfflr #(1) step_req_dfflr (step_req_ena, step_req_nxt, step_req_r, clk, rst_n);

      // The debug-mode will mask off the debug-mode-entry
  wire dbg_entry_mask  = dbg_mode;
  assign dbg_entry_req = (~dbg_entry_mask) & (
                  // Why do we put a AMO_wait here, because the AMO instructions 
                  //   is atomic, we must wait it to complete its all atomic operations
                  //   and during wait cycles irq must be masked, otherwise the irq_req
                  //   will block ALU commit (including AMO) and cause a deadlock
                  //   
                  // Note: Only the async irq and halt and trig need to have this amo_wait to check
                  //   others are sync event, no need to check with this
                                              (dbg_irq_req & (~amo_wait))
                                            | (dbg_halt_req & (~amo_wait))
                                            | dbg_step_req
                                            | (dbg_trig_req & (~amo_wait))
                                            | dbg_ebrk_req
                                            );
  assign nonalu_dbg_entry_req = (~dbg_entry_mask) & (
                                              (nonalu_dbg_irq_req & (~amo_wait))
                                            | (nonalu_dbg_halt_req & (~amo_wait))
                                            | dbg_step_req
                                            //| (dbg_trig_req & (~amo_wait))
                                            //| dbg_ebrk_req
                                            );
  assign nonalu_dbg_entry_req_raw = (~dbg_entry_mask) & (
                                              dbg_irq_r 
                                            | dbg_halt_r
                                            | step_req_r
                                            //| dbg_trig_req
                                            //| dbg_ebrk_req
                                            );

  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  // The IRQ triggered Exception 
  //
    // The debug mode will mask off the interrupts
    // The single-step mode will mask off the interrupts
  wire irq_mask  = dbg_mode | dbg_step_r | (~status_mie_r) 
                  // Why do we put a AMO_wait here, because the AMO instructions 
                  //   is atomic, we must wait it to complete its all atomic operations
                  //   and during wait cycles irq must be masked, otherwise the irq_req
                  //   will block ALU commit (including AMO) and cause a deadlock
                  // Dont need to worry about the clock gating issue, if amo_wait,
                  //   then defefinitely the ALU is active, and clock on
                   | amo_wait;
  wire wfi_irq_mask  = dbg_mode | dbg_step_r;
                  // Why dont we put amo_wait here, because this is for IRQ to wake
                  //   up the core from sleep mode, the core was in sleep mode, then 
                  //   means there is no chance for it to still executing the AMO instructions
                  //   with oustanding uops, so we dont need to worry about it.
  wire irq_req_raw   = ( 
                                    //(|lcl_irq_r) // not support this now
                                    (ext_irq_r & meie_r) 
                                  | (sft_irq_r & msie_r) 
                                  | (tmr_irq_r & mtie_r)
                                  );
  assign irq_req     = (~irq_mask) & irq_req_raw;
  assign wfi_irq_req = (~wfi_irq_mask) & irq_req_raw;

  assign irq_req_active = wfi_flag_r ? wfi_irq_req : irq_req; 

  wire [`E203_XLEN-1:0] irq_cause;

  assign irq_cause[31] = 1'b1;
  assign irq_cause[30:4] = 27'b0;
  assign irq_cause[3:0]  =  (sft_irq_r & msie_r) ? 4'd3  :  // 3  Machine software interrupt
                            (tmr_irq_r & mtie_r) ? 4'd7  :  // 7  Machine timer interrupt
                            (ext_irq_r & meie_r) ? 4'd11 :  // 11 Machine external interrupt
                                        4'b0;

  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  // The ALU triggered Exception 

  // The ebreak instruction will generated regular exception when the ebreakm
  //    bit of DCSR reg is not set
  wire alu_excp_i_ebreak4excp = (alu_excp_i_ebreak & ((~dbg_ebreakm_r) | dbg_mode))
                                ;
  // The ebreak instruction will enter into the debug-mode when the ebreakm
  //    bit of DCSR reg is set
  wire alu_excp_i_ebreak4dbg = alu_excp_i_ebreak 
                               & (~alu_need_flush)// override by other alu exceptions
                               & dbg_ebreakm_r 
                               & (~dbg_mode);//Not in debug mode

  assign alu_ebreakm_flush_req = alu_excp_i_valid & alu_excp_i_ebreak4dbg;
  assign alu_ebreakm_flush_req_novld = alu_excp_i_ebreak4dbg;
    `ifndef E203_SUPPORT_TRIGM//{
    // We dont support the HW Trigger Module yet
  assign alu_dbgtrig_flush_req_novld = 1'b0;
  assign alu_dbgtrig_flush_req = 1'b0;
    `endif

  assign alu_need_flush = 
            ( alu_excp_i_misalgn 
            | alu_excp_i_buserr 
            | alu_excp_i_ebreak4excp
            | alu_excp_i_ecall
            | alu_excp_i_ifu_misalgn  
            | alu_excp_i_ifu_buserr  
            | alu_excp_i_ifu_ilegl  
            );


  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
  // Update the CSRs (Mcause, .etc)

  wire longp_excp_flush_req_ld = longp_excp_flush_req & longp_excp_i_ld;
  wire longp_excp_flush_req_st = longp_excp_flush_req & longp_excp_i_st;

  wire longp_excp_flush_req_insterr = longp_excp_flush_req & longp_excp_i_insterr;

  wire alu_excp_flush_req_ld    = alu_excp_flush_req & alu_excp_i_ld;
  wire alu_excp_flush_req_stamo = alu_excp_flush_req & alu_excp_i_stamo;

  wire alu_excp_flush_req_ebreak      = (alu_excp_flush_req & alu_excp_i_ebreak4excp);
  wire alu_excp_flush_req_ecall       = (alu_excp_flush_req & alu_excp_i_ecall);
  wire alu_excp_flush_req_ifu_misalgn = (alu_excp_flush_req & alu_excp_i_ifu_misalgn);
  wire alu_excp_flush_req_ifu_buserr  = (alu_excp_flush_req & alu_excp_i_ifu_buserr);
  wire alu_excp_flush_req_ifu_ilegl   = (alu_excp_flush_req & alu_excp_i_ifu_ilegl);

  wire alu_excp_flush_req_ld_misalgn    = (alu_excp_flush_req_ld    & alu_excp_i_misalgn);// ALU load misalign
  wire alu_excp_flush_req_ld_buserr     = (alu_excp_flush_req_ld    & alu_excp_i_buserr);// ALU load bus error
  wire alu_excp_flush_req_stamo_misalgn = (alu_excp_flush_req_stamo & alu_excp_i_misalgn);// ALU store/AMO misalign
  wire alu_excp_flush_req_stamo_buserr  = (alu_excp_flush_req_stamo & alu_excp_i_buserr);// ALU store/AMO bus error
  wire longp_excp_flush_req_ld_buserr   = (longp_excp_flush_req_ld  & longp_excp_i_buserr);// Longpipe load bus error
  wire longp_excp_flush_req_st_buserr   = (longp_excp_flush_req_st  & longp_excp_i_buserr);// Longpipe store bus error

  wire excp_flush_by_alu_agu = 
                     alu_excp_flush_req_ld_misalgn    
                   | alu_excp_flush_req_ld_buserr     
                   | alu_excp_flush_req_stamo_misalgn 
                   | alu_excp_flush_req_stamo_buserr;

  wire excp_flush_by_longp_ldst = 
                     longp_excp_flush_req_ld_buserr   
                   | longp_excp_flush_req_st_buserr;


  wire [`E203_XLEN-1:0] excp_cause;
  assign excp_cause[31:5] = 27'b0;
  assign excp_cause[4:0]  = 
      alu_excp_flush_req_ifu_misalgn? 5'd0 //Instruction address misaligned
    : alu_excp_flush_req_ifu_buserr ? 5'd1 //Instruction access fault
    : alu_excp_flush_req_ifu_ilegl  ? 5'd2 //Illegal instruction
    : alu_excp_flush_req_ebreak     ? 5'd3 //Breakpoint
    : alu_excp_flush_req_ld_misalgn ? 5'd4 //load address misalign
    : (longp_excp_flush_req_ld_buserr | alu_excp_flush_req_ld_buserr) ? 5'd5 //load access fault
    : alu_excp_flush_req_stamo_misalgn ? 5'd6 //Store/AMO address misalign
    : (longp_excp_flush_req_st_buserr | alu_excp_flush_req_stamo_buserr) ? 5'd7 //Store/AMO access fault
    : (alu_excp_flush_req_ecall & u_mode) ? 5'd8 //Environment call from U-mode
    : (alu_excp_flush_req_ecall & s_mode) ? 5'd9 //Environment call from S-mode
    : (alu_excp_flush_req_ecall & h_mode) ? 5'd10 //Environment call from H-mode
    : (alu_excp_flush_req_ecall & m_mode) ? 5'd11 //Environment call from M-mode
    : longp_excp_flush_req_insterr ? 5'd16// This only happened for the EAI long instructions actually  
    : 5'h1F;//Otherwise a reserved value

  // mbadaddr is an XLEN-bit read-write register formatted as shown in Figure 3.21. When 
  //    * a hardware breakpoint is triggered,
  //    * an instruction-fetch address-misaligned or access exception
  //    * load  address-misaligned or access exception
  //    * store address-misaligned or access exception
  //   occurs, mbadaddr is written with the faulting address. 
  // In Priv SPEC v1.10, the mbadaddr have been replaced to mtval, and added following points:
  //    * On an illegal instruction trap, mtval is written with the first XLEN bits of the faulting 
  //        instruction . 
  //    * For other exceptions, mtval is set to zero, but a future standard may redefine mtval's
  //        setting for other exceptions.
  //
  wire excp_flush_req_ld_misalgn = alu_excp_flush_req_ld_misalgn;
  wire excp_flush_req_ld_buserr  = alu_excp_flush_req_ld_buserr | longp_excp_flush_req_ld_buserr;
    
  //wire cmt_badaddr_update = all_excp_flush_req & 
  //          (  
  //            alu_excp_flush_req_ebreak      
  //          | alu_excp_flush_req_ifu_misalgn 
  //          | alu_excp_flush_req_ifu_buserr  
  //          | excp_flush_by_alu_agu 
  //          | excp_flush_by_longp_ldst);
            // Per Priv Spec v1.10, all trap need to update this register
            //  * When a trap is taken into M-mode, mtval is written with exception-specific
            //     information to assist software in handling the trap.
  wire cmt_badaddr_update = excpirq_flush_req;

  assign cmt_badaddr = excp_flush_by_longp_ldst ? longp_excp_i_badaddr :
                       excp_flush_by_alu_agu    ? alu_excp_i_badaddr :
                       (alu_excp_flush_req_ebreak      
                        | alu_excp_flush_req_ifu_misalgn 
                        | alu_excp_flush_req_ifu_buserr) ? alu_excp_i_pc :
                       alu_excp_flush_req_ifu_ilegl ? alu_excp_i_instr :
                            `E203_ADDR_SIZE'b0;

  // We use the exact PC of long-instruction when exception happened, but 
  //   to note since the later instruction may already commited, so long-pipe
  //   excpetion is async-imprecise exceptions
  assign cmt_epc = longp_excp_i_valid ? longp_excp_i_pc : alu_excp_i_pc;

  assign cmt_cause = excp_taken_ena ? excp_cause : irq_cause;

     // Any trap include exception and irq (exclude dbg_irq) will update mstatus register
            // In the debug mode, epc/cause/status/badaddr will not update badaddr
  assign cmt_epc_ena     = (~dbg_mode) & (excp_taken_ena | irq_taken_ena);
  assign cmt_cause_ena   = cmt_epc_ena;
  assign cmt_status_ena  = cmt_epc_ena;
  assign cmt_badaddr_ena = cmt_epc_ena & cmt_badaddr_update;

  assign cmt_dpc = alu_excp_i_pc;// The ALU PC is the current next commiting PC (not yet commited)
  assign cmt_dpc_ena = dbg_entry_taken_ena;

  wire cmt_dcause_set = dbg_entry_taken_ena;
  wire cmt_dcause_clr = cmt_dret_ena;
  wire [2:0] set_dcause_nxt = 
                              dbg_trig_req ? 3'd2 : 
                              dbg_ebrk_req ? 3'd1 : 
                              dbg_irq_req  ? 3'd3 : 
                              dbg_step_req ? 3'd4 :
                              dbg_halt_req ? 3'd5 : 
                                             3'd0;

  assign cmt_dcause_ena = cmt_dcause_set | cmt_dcause_clr;
  assign cmt_dcause = cmt_dcause_set ? set_dcause_nxt : 3'd0;

endmodule                                      
                                               
                                               
                                               
