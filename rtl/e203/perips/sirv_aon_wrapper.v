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
                                                                         
                                                                         
                                                                         

module sirv_aon_wrapper(

  output inspect_mode,
  output inspect_por_rst,
  output inspect_32k_clk,
  input inspect_pc_29b, 
  input inspect_dbg_irq,
  output  [32-1:0] pc_rtvec,

  output aon_iso,
  output jtagpwd_iso,
  output crossing_clock,
  output crossing_reset,

  output  io_in_0_a_ready,
  input   io_in_0_a_valid,
  input  [2:0] io_in_0_a_bits_opcode,
  input  [2:0] io_in_0_a_bits_param,
  input  [2:0] io_in_0_a_bits_size,
  input  [4:0] io_in_0_a_bits_source,
  input  [28:0] io_in_0_a_bits_address,
  input  [3:0] io_in_0_a_bits_mask,
  input  [31:0] io_in_0_a_bits_data,
  input   io_in_0_b_ready,
  output  io_in_0_b_valid,
  output [2:0] io_in_0_b_bits_opcode,
  output [1:0] io_in_0_b_bits_param,
  output [2:0] io_in_0_b_bits_size,
  output [4:0] io_in_0_b_bits_source,
  output [28:0] io_in_0_b_bits_address,
  output [3:0] io_in_0_b_bits_mask,
  output [31:0] io_in_0_b_bits_data,
  output  io_in_0_c_ready,
  input   io_in_0_c_valid,
  input  [2:0] io_in_0_c_bits_opcode,
  input  [2:0] io_in_0_c_bits_param,
  input  [2:0] io_in_0_c_bits_size,
  input  [4:0] io_in_0_c_bits_source,
  input  [28:0] io_in_0_c_bits_address,
  input  [31:0] io_in_0_c_bits_data,
  input   io_in_0_c_bits_error,
  input   io_in_0_d_ready,
  output  io_in_0_d_valid,
  output [2:0] io_in_0_d_bits_opcode,
  output [1:0] io_in_0_d_bits_param,
  output [2:0] io_in_0_d_bits_size,
  output [4:0] io_in_0_d_bits_source,
  output  io_in_0_d_bits_sink,
  output [1:0] io_in_0_d_bits_addr_lo,
  output [31:0] io_in_0_d_bits_data,
  output  io_in_0_d_bits_error,
  output  io_in_0_e_ready,
  input   io_in_0_e_valid,
  input   io_in_0_e_bits_sink,

  output  io_ip_0_0,
  output  io_ip_0_1,

  input   io_pads_erst_n_i_ival,
  output  io_pads_erst_n_o_oval,
  output  io_pads_erst_n_o_oe,
  output  io_pads_erst_n_o_ie,
  output  io_pads_erst_n_o_pue,
  output  io_pads_erst_n_o_ds,
  input   io_pads_lfextclk_i_ival,
  output  io_pads_lfextclk_o_oval,
  output  io_pads_lfextclk_o_oe,
  output  io_pads_lfextclk_o_ie,
  output  io_pads_lfextclk_o_pue,
  output  io_pads_lfextclk_o_ds,
  input   io_pads_dbgmode0_n_i_ival,
  input   io_pads_dbgmode1_n_i_ival,
  input   io_pads_dbgmode2_n_i_ival,
  input   io_pads_jtagpwd_n_i_ival,
  output  io_pads_jtagpwd_n_o_oval,
  output  io_pads_jtagpwd_n_o_oe,
  output  io_pads_jtagpwd_n_o_ie,
  output  io_pads_jtagpwd_n_o_pue,
  output  io_pads_jtagpwd_n_o_ds,
  input   io_pads_bootrom_n_i_ival,
  output  io_pads_bootrom_n_o_oval,
  output  io_pads_bootrom_n_o_oe,
  output  io_pads_bootrom_n_o_ie,
  output  io_pads_bootrom_n_o_pue,
  output  io_pads_bootrom_n_o_ds,
  input   io_pads_pmu_dwakeup_n_i_ival,
  output  io_pads_pmu_dwakeup_n_o_oval,
  output  io_pads_pmu_dwakeup_n_o_oe,
  output  io_pads_pmu_dwakeup_n_o_ie,
  output  io_pads_pmu_dwakeup_n_o_pue,
  output  io_pads_pmu_dwakeup_n_o_ds,
  input   io_pads_pmu_vddpaden_i_ival,
  output  io_pads_pmu_vddpaden_o_oval,
  output  io_pads_pmu_vddpaden_o_oe,
  output  io_pads_pmu_vddpaden_o_ie,
  output  io_pads_pmu_vddpaden_o_pue,
  output  io_pads_pmu_vddpaden_o_ds,
  input   io_pads_pmu_padrst_i_ival,
  output  io_pads_pmu_padrst_o_oval,
  output  io_pads_pmu_padrst_o_oe,
  output  io_pads_pmu_padrst_o_ie,
  output  io_pads_pmu_padrst_o_pue,
  output  io_pads_pmu_padrst_o_ds,
  output  io_rsts_hfclkrst,
  output  io_rsts_corerst,
  output  io_rtc,

  output  aon_reset,

  input   test_mode,
  input   test_iso_override

);
  wire  aon_io_dbgmode0_n;
  wire  aon_io_dbgmode1_n;
  wire  aon_io_dbgmode2_n;
  wire  aon_clock;
  wire  aon_io_interrupts_0_0;
  wire  aon_io_interrupts_0_1;
  wire  aon_io_moff_hfclkrst;
  wire  aon_io_moff_corerst;
  wire  aon_io_wdog_rst;
  wire  aon_io_lfclk;
  wire  aon_io_pmu_vddpaden;
  wire  aon_io_pmu_padrst;
  wire  aon_io_pmu_dwakeup;
  wire  aon_io_jtagpwd;
  wire  aon_io_bootrom;
  wire  aon_io_lfextclk;
  wire  aon_io_resetCauses_wdogrst;
  wire  aon_io_resetCauses_erst;
  wire  aon_io_resetCauses_porrst;
  wire  erst;
  wire  T_1411;
  wire  aonrst_catch_clock;
  wire  aonrst_catch_reset;
  wire  aonrst_catch_io_sync_reset;
  wire  T_1412;
  wire  T_1413;
  wire  ResetCatchAndSync_1_1_clock;
  wire  ResetCatchAndSync_1_1_reset;
  wire  ResetCatchAndSync_1_1_io_sync_reset;
  wire  bootrom_deglitch_clock;
  wire  bootrom_deglitch_reset;
  wire  bootrom_deglitch_io_d;
  wire  bootrom_deglitch_io_q;
  wire  jtagpwd_deglitch_clock;
  wire  jtagpwd_deglitch_reset;
  wire  jtagpwd_deglitch_io_d;
  wire  jtagpwd_deglitch_io_q;
  wire  dwakeup_deglitch_clock;
  wire  dwakeup_deglitch_reset;
  wire  dwakeup_deglitch_io_d;
  wire  dwakeup_deglitch_io_q;
  wire  T_1420;

  sirv_aon u_sirv_aon (
    .clock(aon_clock),
    .reset(aon_reset),
    .io_interrupts_0_0(aon_io_interrupts_0_0),
    .io_interrupts_0_1(aon_io_interrupts_0_1),
    .io_in_0_a_ready       (io_in_0_a_ready),
    .io_in_0_a_valid       (io_in_0_a_valid),
    .io_in_0_a_bits_opcode (io_in_0_a_bits_opcode),
    .io_in_0_a_bits_param  (io_in_0_a_bits_param),
    .io_in_0_a_bits_size   (io_in_0_a_bits_size),
    .io_in_0_a_bits_source (io_in_0_a_bits_source),
    .io_in_0_a_bits_address(io_in_0_a_bits_address),
    .io_in_0_a_bits_mask   (io_in_0_a_bits_mask),
    .io_in_0_a_bits_data   (io_in_0_a_bits_data),
    .io_in_0_b_ready       (io_in_0_b_ready),
    .io_in_0_b_valid       (io_in_0_b_valid),
    .io_in_0_b_bits_opcode (io_in_0_b_bits_opcode),
    .io_in_0_b_bits_param  (io_in_0_b_bits_param),
    .io_in_0_b_bits_size   (io_in_0_b_bits_size),
    .io_in_0_b_bits_source (io_in_0_b_bits_source),
    .io_in_0_b_bits_address(io_in_0_b_bits_address),
    .io_in_0_b_bits_mask   (io_in_0_b_bits_mask),
    .io_in_0_b_bits_data   (io_in_0_b_bits_data),
    .io_in_0_c_ready       (io_in_0_c_ready),
    .io_in_0_c_valid       (io_in_0_c_valid),
    .io_in_0_c_bits_opcode (io_in_0_c_bits_opcode),
    .io_in_0_c_bits_param  (io_in_0_c_bits_param),
    .io_in_0_c_bits_size   (io_in_0_c_bits_size),
    .io_in_0_c_bits_source (io_in_0_c_bits_source),
    .io_in_0_c_bits_address(io_in_0_c_bits_address),
    .io_in_0_c_bits_data   (io_in_0_c_bits_data),
    .io_in_0_c_bits_error  (io_in_0_c_bits_error),
    .io_in_0_d_ready       (io_in_0_d_ready),
    .io_in_0_d_valid       (io_in_0_d_valid),
    .io_in_0_d_bits_opcode (io_in_0_d_bits_opcode),
    .io_in_0_d_bits_param  (io_in_0_d_bits_param),
    .io_in_0_d_bits_size   (io_in_0_d_bits_size),
    .io_in_0_d_bits_source (io_in_0_d_bits_source),
    .io_in_0_d_bits_sink   (io_in_0_d_bits_sink),
    .io_in_0_d_bits_addr_lo(io_in_0_d_bits_addr_lo),
    .io_in_0_d_bits_data   (io_in_0_d_bits_data),
    .io_in_0_d_bits_error  (io_in_0_d_bits_error),
    .io_in_0_e_ready       (io_in_0_e_ready),
    .io_in_0_e_valid       (io_in_0_e_valid),
    .io_in_0_e_bits_sink   (io_in_0_e_bits_sink),
    .io_moff_hfclkrst(aon_io_moff_hfclkrst),
    .io_moff_corerst(aon_io_moff_corerst),
    .io_wdog_rst(aon_io_wdog_rst),
    .io_lfclk(aon_io_lfclk),
    .io_pmu_vddpaden (aon_io_pmu_vddpaden),
    .io_pmu_padrst   (aon_io_pmu_padrst),
    .io_pmu_dwakeup(aon_io_pmu_dwakeup),
    .io_lfextclk(aon_io_lfextclk),
    .io_resetCauses_wdogrst(aon_io_resetCauses_wdogrst),
    .io_resetCauses_erst(aon_io_resetCauses_erst),
    .io_resetCauses_porrst(aon_io_resetCauses_porrst),
    .erst(erst),
    .test_mode(test_mode) 
  );
  sirv_ResetCatchAndSync aonrst_catch (
    .test_mode(test_mode),
    .clock(aonrst_catch_clock),
    .reset(aonrst_catch_reset),
    .io_sync_reset(aonrst_catch_io_sync_reset)
  );
    // This is the cross reset to reset the CDC logics between the Aon and MOFF to make sure
    //   there is no any pending transactions
  sirv_ResetCatchAndSync ResetCatchAndSync_1_1 (
    .test_mode(test_mode),
    .clock(ResetCatchAndSync_1_1_clock),
    .reset(ResetCatchAndSync_1_1_reset),
    .io_sync_reset(ResetCatchAndSync_1_1_io_sync_reset)
  );
  assign crossing_clock = aon_io_lfclk;
  assign crossing_reset = ResetCatchAndSync_1_1_io_sync_reset;

  sirv_DeglitchShiftRegister jtagpwd_deglitch (
    .clock(jtagpwd_deglitch_clock),
    .reset(jtagpwd_deglitch_reset),
    .io_d(jtagpwd_deglitch_io_d),
    .io_q(jtagpwd_deglitch_io_q)
  );

  sirv_DeglitchShiftRegister bootrom_deglitch (
    .clock(bootrom_deglitch_clock),
    .reset(bootrom_deglitch_reset),
    .io_d(bootrom_deglitch_io_d),
    .io_q(bootrom_deglitch_io_q)
  );


  sirv_DeglitchShiftRegister dwakeup_deglitch (
    .clock(dwakeup_deglitch_clock),
    .reset(dwakeup_deglitch_reset),
    .io_d(dwakeup_deglitch_io_d),
    .io_q(dwakeup_deglitch_io_q)
  );
  assign io_ip_0_0 = aon_io_interrupts_0_0;
  assign io_ip_0_1 = aon_io_interrupts_0_1;
  assign io_pads_erst_n_o_oval = 1'h0;
  assign io_pads_erst_n_o_oe = 1'h0;
  assign io_pads_erst_n_o_ie = 1'h1;
  assign io_pads_erst_n_o_pue = 1'h1;
  assign io_pads_erst_n_o_ds = 1'h0;
  assign io_pads_lfextclk_o_oval = 1'h0;
  assign io_pads_lfextclk_o_oe = 1'h0;
  assign io_pads_lfextclk_o_ie = 1'h1;
  assign io_pads_lfextclk_o_pue = 1'h1;
  assign io_pads_lfextclk_o_ds = 1'h0;
  assign io_pads_pmu_dwakeup_n_o_oval = 1'h0;
  assign io_pads_pmu_dwakeup_n_o_oe = 1'h0;
  assign io_pads_pmu_dwakeup_n_o_ie = 1'h1;
  assign io_pads_pmu_dwakeup_n_o_pue = 1'h1;
  assign io_pads_pmu_dwakeup_n_o_ds = 1'h0;
    // Since the jtagpwd_n is an input, so we just tie the output relevant signals to 0
  assign io_pads_jtagpwd_n_o_oval = 1'h0;
  assign io_pads_jtagpwd_n_o_oe = 1'h0;
  assign io_pads_jtagpwd_n_o_ie = 1'h1;
  assign io_pads_jtagpwd_n_o_pue = 1'h1;
  assign io_pads_jtagpwd_n_o_ds = 1'h0;
    // Since the bootrom_n is an input, so we just tie the output relevant signals to 0
  assign io_pads_bootrom_n_o_oval = 1'h0;
  assign io_pads_bootrom_n_o_oe = 1'h0;
  assign io_pads_bootrom_n_o_ie = 1'h1;
  assign io_pads_bootrom_n_o_pue = 1'h1;
  assign io_pads_bootrom_n_o_ds = 1'h0;
    // We reuse these two pads to monitor internal key signals in functional mode 
  wire isl_inspect_pc_29b  = aon_iso ? 1'b0 : inspect_pc_29b       ;// From main domain
  wire isl_inspect_dbg_irq = aon_iso ? 1'b0 : inspect_dbg_irq      ;// From main domain

  assign inspect_mode = ({aon_io_dbgmode2_n,aon_io_dbgmode1_n,aon_io_dbgmode0_n} == 3'b000);
  assign {io_pads_pmu_vddpaden_o_oval, io_pads_pmu_padrst_o_oval} =
        inspect_mode ? {isl_inspect_pc_29b, isl_inspect_dbg_irq} 
                     : {aon_io_pmu_vddpaden, aon_io_pmu_padrst} ;
  assign io_pads_pmu_vddpaden_o_oe = 1'h1;
  assign io_pads_pmu_vddpaden_o_ie = 1'h0;
  assign io_pads_pmu_vddpaden_o_pue = 1'h0;
  assign io_pads_pmu_vddpaden_o_ds = 1'h0;
  assign io_pads_pmu_padrst_o_oe = 1'h1;
  assign io_pads_pmu_padrst_o_ie = 1'h0;
  assign io_pads_pmu_padrst_o_pue = 1'h0;
  assign io_pads_pmu_padrst_o_ds = 1'h0;
  assign io_rsts_hfclkrst = aon_io_moff_hfclkrst;
  assign io_rsts_corerst = aon_io_moff_corerst;
  assign aon_clock = aon_io_lfclk;
  assign aon_reset = aonrst_catch_io_sync_reset;
  assign aon_io_pmu_dwakeup = dwakeup_deglitch_io_q;
  assign aon_io_jtagpwd   = jtagpwd_deglitch_io_q;
  assign aon_io_bootrom   = bootrom_deglitch_io_q;
  // Since these are just the debug model signals, we cannot really sync it in case the sync clock is not even working
  assign aon_io_dbgmode0_n  = io_pads_dbgmode0_n_i_ival;
  assign aon_io_dbgmode1_n  = io_pads_dbgmode1_n_i_ival;
  assign aon_io_dbgmode2_n  = io_pads_dbgmode2_n_i_ival;
  assign aon_io_lfextclk = T_1411;
  assign aon_io_resetCauses_wdogrst = aon_io_wdog_rst;
  assign aon_io_resetCauses_erst = erst;

  wire porrst_n;

  sirv_aon_porrst u_aon_porrst (.porrst_n(porrst_n));
  assign inspect_por_rst = porrst_n;

  wire porrst = ~porrst_n;
  assign aon_io_resetCauses_porrst = porrst;
  
  assign inspect_32k_clk = aon_io_lfextclk;


  assign erst = ~ io_pads_erst_n_i_ival;
  assign T_1411 = io_pads_lfextclk_i_ival;
  assign aonrst_catch_clock = aon_io_lfclk;
  assign aonrst_catch_reset = T_1412;
  assign T_1412 = erst | aon_io_wdog_rst | porrst;
  assign T_1413 = aon_io_moff_corerst | aon_reset;
  assign ResetCatchAndSync_1_1_clock = aon_io_lfclk;
    // This is the cross reset to reset the CDC logics between the Aon and MOFF to make sure
    //   there is no any pending transactions
  assign ResetCatchAndSync_1_1_reset = T_1413;
  assign dwakeup_deglitch_clock = aon_io_lfclk;
  assign dwakeup_deglitch_reset = 1'b1;
  assign dwakeup_deglitch_io_d = T_1420;
  assign T_1420 = ~ io_pads_pmu_dwakeup_n_i_ival;
  assign jtagpwd_deglitch_clock = aon_io_lfclk;
  assign jtagpwd_deglitch_reset = 1'b1;
  assign jtagpwd_deglitch_io_d = (~io_pads_jtagpwd_n_i_ival);
  assign bootrom_deglitch_clock = aon_io_lfclk;
  assign bootrom_deglitch_reset = 1'b1;
  assign bootrom_deglitch_io_d = (~io_pads_bootrom_n_i_ival);


  //The toggle is generated by the low speed clock divide by 2
  wire io_rtc_nxt = ~io_rtc;
  wire aon_rst_n = ~aon_reset;
  sirv_gnrl_dffr #(1) io_rtc_dffr (io_rtc_nxt, io_rtc, aon_clock, aon_rst_n);

  // Since the Aon module need to handle the path from the MOFF domain, which
  //   maybe powered down, so we need to have the isolation cells here
  //   it can be handled by UPF flow, but we can also add them mannually here
  // The inputs from MOFF to aon domain need to be isolated
  // The outputs does not need to be isolated
  //      In DFT mode the isolate control siganls should be disabled
  assign aon_iso = test_mode ? test_iso_override : aon_io_moff_corerst;// We use this corerst signal as the isolation
  assign jtagpwd_iso = test_mode ? test_iso_override : aon_io_jtagpwd;// 
  //
  //
  //
  //  This signal will be passed to the main domain, since this is kind of pad selected signal
  //    we dont need to sync them in main domain, just directly use it
  assign pc_rtvec = aon_io_bootrom ? 32'h0000_1000 : 
      // This is the external QSPI flash base address 
                                     32'h2000_0000;

endmodule
