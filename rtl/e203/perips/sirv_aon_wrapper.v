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
                                                                         
                                                                         
                                                                         

module sirv_aon_wrapper(
  input  core_wfi,// The CPU can only be powerred down when it is idle

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
  output  io_pmu_tcmshutdw,
  output  io_pmu_tcmretion,
  output  io_pmu_moff_isolate,
  output  io_rsts_hfclkrst,
  output  io_rsts_corerst,
  output  io_rtc,

  input   test_mode,
  input   test_iso_override

);
  wire  aon_clock;
  wire  aon_reset;
  wire  aon_io_interrupts_0_0;
  wire  aon_io_interrupts_0_1;
  wire  aon_io_moff_hfclkrst;
  wire  aon_io_moff_corerst;
  wire  aon_io_wdog_rst;
  wire  aon_io_lfclk;
  wire  aon_io_pmu_vddpaden;
  wire  aon_io_pmu_dwakeup;
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
  wire  dwakeup_deglitch_clock;
  wire  dwakeup_deglitch_reset;
  wire  dwakeup_deglitch_io_d;
  wire  dwakeup_deglitch_io_q;
  wire  T_1420;
  sirv_aon u_sirv_aon (
    .clock(aon_clock),
    .reset(aon_reset),
    .core_wfi (core_wfi),
    .io_interrupts_0_0(aon_io_interrupts_0_0),
    .io_interrupts_0_1(aon_io_interrupts_0_1),
    .io_in_0_a_ready(io_in_0_a_ready),
    .io_in_0_a_valid(io_in_0_a_valid),
    .io_in_0_a_bits_opcode(io_in_0_a_bits_opcode),
    .io_in_0_a_bits_param(io_in_0_a_bits_param),
    .io_in_0_a_bits_size(io_in_0_a_bits_size),
    .io_in_0_a_bits_source(io_in_0_a_bits_source),
    .io_in_0_a_bits_address(io_in_0_a_bits_address),
    .io_in_0_a_bits_mask(io_in_0_a_bits_mask),
    .io_in_0_a_bits_data(io_in_0_a_bits_data),
    .io_in_0_b_ready(io_in_0_b_ready),
    .io_in_0_b_valid(io_in_0_b_valid),
    .io_in_0_b_bits_opcode(io_in_0_b_bits_opcode),
    .io_in_0_b_bits_param(io_in_0_b_bits_param),
    .io_in_0_b_bits_size(io_in_0_b_bits_size),
    .io_in_0_b_bits_source(io_in_0_b_bits_source),
    .io_in_0_b_bits_address(io_in_0_b_bits_address),
    .io_in_0_b_bits_mask(io_in_0_b_bits_mask),
    .io_in_0_b_bits_data(io_in_0_b_bits_data),
    .io_in_0_c_ready(io_in_0_c_ready),
    .io_in_0_c_valid(io_in_0_c_valid),
    .io_in_0_c_bits_opcode(io_in_0_c_bits_opcode),
    .io_in_0_c_bits_param(io_in_0_c_bits_param),
    .io_in_0_c_bits_size(io_in_0_c_bits_size),
    .io_in_0_c_bits_source(io_in_0_c_bits_source),
    .io_in_0_c_bits_address(io_in_0_c_bits_address),
    .io_in_0_c_bits_data(io_in_0_c_bits_data),
    .io_in_0_c_bits_error(io_in_0_c_bits_error),
    .io_in_0_d_ready(io_in_0_d_ready),
    .io_in_0_d_valid(io_in_0_d_valid),
    .io_in_0_d_bits_opcode(io_in_0_d_bits_opcode),
    .io_in_0_d_bits_param(io_in_0_d_bits_param),
    .io_in_0_d_bits_size(io_in_0_d_bits_size),
    .io_in_0_d_bits_source(io_in_0_d_bits_source),
    .io_in_0_d_bits_sink(io_in_0_d_bits_sink),
    .io_in_0_d_bits_addr_lo(io_in_0_d_bits_addr_lo),
    .io_in_0_d_bits_data(io_in_0_d_bits_data),
    .io_in_0_d_bits_error(io_in_0_d_bits_error),
    .io_in_0_e_ready(io_in_0_e_ready),
    .io_in_0_e_valid(io_in_0_e_valid),
    .io_in_0_e_bits_sink(io_in_0_e_bits_sink),
    .io_moff_hfclkrst(aon_io_moff_hfclkrst),
    .io_moff_corerst(aon_io_moff_corerst),
    .io_wdog_rst(aon_io_wdog_rst),
    .io_lfclk(aon_io_lfclk),
    .io_pmu_vddpaden (aon_io_pmu_vddpaden),
    .io_pmu_tcmshutdw(io_pmu_tcmshutdw),
    .io_pmu_tcmretion(io_pmu_tcmretion),
    .io_pmu_dwakeup(aon_io_pmu_dwakeup),
    .io_pmu_moff_isolate(io_pmu_moff_isolate),
    .io_lfextclk(aon_io_lfextclk),
    .io_resetCauses_wdogrst(aon_io_resetCauses_wdogrst),
    .io_resetCauses_erst(aon_io_resetCauses_erst),
    .io_resetCauses_porrst(aon_io_resetCauses_porrst),
    .erst(erst),
    .test_mode(test_mode),
    .test_iso_override(test_iso_override) 
  );
  sirv_ResetCatchAndSync aonrst_catch (
    .test_mode(test_mode),
    .clock(aonrst_catch_clock),
    .reset(aonrst_catch_reset),
    .io_sync_reset(aonrst_catch_io_sync_reset)
  );
  sirv_ResetCatchAndSync ResetCatchAndSync_1_1 (
    .test_mode(test_mode),
    .clock(ResetCatchAndSync_1_1_clock),
    .reset(ResetCatchAndSync_1_1_reset),
    .io_sync_reset(ResetCatchAndSync_1_1_io_sync_reset)
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
  assign io_pads_pmu_vddpaden_o_oval = aon_io_pmu_vddpaden;
  assign io_pads_pmu_vddpaden_o_oe = 1'h1;
  assign io_pads_pmu_vddpaden_o_ie = 1'h0;
  assign io_pads_pmu_vddpaden_o_pue = 1'h0;
  assign io_pads_pmu_vddpaden_o_ds = 1'h0;
  assign io_rsts_hfclkrst = aon_io_moff_hfclkrst;
  assign io_rsts_corerst = aon_io_moff_corerst;
  assign aon_clock = aon_io_lfclk;
  assign aon_reset = aonrst_catch_io_sync_reset;
  assign aon_io_pmu_dwakeup = dwakeup_deglitch_io_q;
  assign aon_io_lfextclk = T_1411;
  assign aon_io_resetCauses_wdogrst = aon_io_wdog_rst;
  assign aon_io_resetCauses_erst = erst;
  assign aon_io_resetCauses_porrst = 1'h0;
  assign erst = ~ io_pads_erst_n_i_ival;
  assign T_1411 = $unsigned(io_pads_lfextclk_i_ival);
  assign aonrst_catch_clock = aon_io_lfclk;
  assign aonrst_catch_reset = T_1412;
  assign T_1412 = erst | aon_io_wdog_rst;
  assign T_1413 = aon_io_moff_corerst | aon_reset;
  assign ResetCatchAndSync_1_1_clock = aon_io_lfclk;
  assign ResetCatchAndSync_1_1_reset = T_1413;
  assign dwakeup_deglitch_clock = aon_io_lfclk;
  assign dwakeup_deglitch_reset = 1'b1;
  assign dwakeup_deglitch_io_d = T_1420;
  assign T_1420 = ~ io_pads_pmu_dwakeup_n_i_ival;

  assign crossing_reset = ResetCatchAndSync_1_1_io_sync_reset;

  //The toggle is generated by the low speed clock divide by 2
  wire io_rtc_nxt = ~io_rtc;
  wire aon_rst_n = ~aon_reset;
  sirv_gnrl_dffr #(1) io_rtc_dffr (io_rtc_nxt, io_rtc, aon_clock, aon_rst_n);

endmodule
