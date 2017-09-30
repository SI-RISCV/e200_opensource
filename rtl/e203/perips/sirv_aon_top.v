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
//  The top module of always on domain
//
// ====================================================================
module sirv_aon_top #(
    parameter ASYNC_FF_LEVELS = 2
)(

  input  core_wfi,// The CPU can only be powerred down when it is idle

  input                      i_icb_cmd_valid,
  output                     i_icb_cmd_ready,
  input  [32-1:0]            i_icb_cmd_addr, 
  input                      i_icb_cmd_read, 
  input  [32-1:0]            i_icb_cmd_wdata,
  
  output                     i_icb_rsp_valid,
  input                      i_icb_rsp_ready,
  output [32-1:0]            i_icb_rsp_rdata,

  input   io_pads_aon_erst_n_i_ival,
  output  io_pads_aon_erst_n_o_oval,
  output  io_pads_aon_erst_n_o_oe,
  output  io_pads_aon_erst_n_o_ie,
  output  io_pads_aon_erst_n_o_pue,
  output  io_pads_aon_erst_n_o_ds,
  input   io_pads_aon_lfextclk_i_ival,
  output  io_pads_aon_lfextclk_o_oval,
  output  io_pads_aon_lfextclk_o_oe,
  output  io_pads_aon_lfextclk_o_ie,
  output  io_pads_aon_lfextclk_o_pue,
  output  io_pads_aon_lfextclk_o_ds,
  input   io_pads_aon_pmu_dwakeup_n_i_ival,
  output  io_pads_aon_pmu_dwakeup_n_o_oval,
  output  io_pads_aon_pmu_dwakeup_n_o_oe,
  output  io_pads_aon_pmu_dwakeup_n_o_ie,
  output  io_pads_aon_pmu_dwakeup_n_o_pue,
  output  io_pads_aon_pmu_dwakeup_n_o_ds,
  input   io_pads_aon_pmu_vddpaden_i_ival,
  output  io_pads_aon_pmu_vddpaden_o_oval,
  output  io_pads_aon_pmu_vddpaden_o_oe,
  output  io_pads_aon_pmu_vddpaden_o_ie,
  output  io_pads_aon_pmu_vddpaden_o_pue,
  output  io_pads_aon_pmu_vddpaden_o_ds,

  output  hfclkrst,
  output  corerst,

  output  aon_pmu_tcmshutdw,
  output  aon_pmu_tcmretion,
  output  aon_pmu_moff_isolate,

  output  aon_wdg_irq,
  output  aon_rtc_irq,
  output  aon_rtcToggle,

  input   test_mode,
  input   test_iso_override
);

  wire  lfextclk     = io_pads_aon_lfextclk_i_ival;

  wire  pmu_vddpaden; 

  wire                     synced_icb_cmd_valid;
  wire                     synced_icb_cmd_ready;
  wire [32-1:0]            synced_icb_cmd_addr; 
  wire                     synced_icb_cmd_read; 
  wire [32-1:0]            synced_icb_cmd_wdata;
  
  wire                     synced_icb_rsp_valid;
  wire                     synced_icb_rsp_ready;
  wire [32-1:0]            synced_icb_rsp_rdata;

  localparam CMD_PACK_W = 65;

  wire [CMD_PACK_W-1:0] synced_icb_cmd_pack;
  wire [CMD_PACK_W-1:0] i_icb_cmd_pack;
  
  assign i_icb_cmd_pack = {
          i_icb_cmd_addr, 
          i_icb_cmd_read, 
          i_icb_cmd_wdata};

  assign {synced_icb_cmd_addr, 
          synced_icb_cmd_read, 
          synced_icb_cmd_wdata} = synced_icb_cmd_pack;

  wire crossing_reset;

  sirv_gnrl_cdc_tx   
   # (
     .DW      (32),
     .SYNC_DP (ASYNC_FF_LEVELS) 
   ) u_aon_icb_cdc_tx (
     .o_vld  (i_icb_rsp_valid ), 
     .o_rdy_a(i_icb_rsp_ready ), 
     .o_dat  (i_icb_rsp_rdata ),
     .i_vld  (synced_icb_rsp_valid ),
     .i_rdy  (synced_icb_rsp_ready ),
     .i_dat  (synced_icb_rsp_rdata ),
   
     .clk    (lfextclk),
     .rst_n  (~crossing_reset)
   );
     
   sirv_gnrl_cdc_rx   
      # (
     .DW      (CMD_PACK_W),
     .SYNC_DP (ASYNC_FF_LEVELS) 
   ) u_aon_icb_cdc_rx (
     .i_vld_a(i_icb_cmd_valid), 
     .i_rdy  (i_icb_cmd_ready), 
     .i_dat  (i_icb_cmd_pack),
     .o_vld  (synced_icb_cmd_valid),
     .o_rdy  (synced_icb_cmd_ready),
     .o_dat  (synced_icb_cmd_pack),
   
     .clk    (lfextclk),
     .rst_n  (~crossing_reset)
   );


  wire  io_tl_in_0_a_ready;
  assign  synced_icb_cmd_ready  = io_tl_in_0_a_ready;
  wire  io_tl_in_0_a_valid  = synced_icb_cmd_valid;
  wire  [2:0] io_tl_in_0_a_bits_opcode  = synced_icb_cmd_read ? 3'h4 : 3'h0;
  wire  [2:0] io_tl_in_0_a_bits_param  = 3'b0;
  wire  [2:0] io_tl_in_0_a_bits_size = 3'd2;
  wire  [4:0] io_tl_in_0_a_bits_source  = 5'b0;
  wire  [28:0] io_tl_in_0_a_bits_address  = synced_icb_cmd_addr[28:0];
  wire  [3:0] io_tl_in_0_a_bits_mask  = 4'b1111;
  wire  [31:0] io_tl_in_0_a_bits_data  = synced_icb_cmd_wdata;

  
  wire  io_tl_in_0_d_ready = synced_icb_rsp_ready;

  wire  [2:0] io_tl_in_0_d_bits_opcode;
  wire  [1:0] io_tl_in_0_d_bits_param;
  wire  [2:0] io_tl_in_0_d_bits_size;
  wire  [4:0] io_tl_in_0_d_bits_source;
  wire  io_tl_in_0_d_bits_sink;
  wire  [1:0] io_tl_in_0_d_bits_addr_lo;
  wire  [31:0] io_tl_in_0_d_bits_data;
  wire  io_tl_in_0_d_bits_error;
  wire  io_tl_in_0_d_valid;

  assign  synced_icb_rsp_valid = io_tl_in_0_d_valid;
  assign  synced_icb_rsp_rdata = io_tl_in_0_d_bits_data;

  // Not used
  wire  io_tl_in_0_b_ready = 1'b0;
  wire  io_tl_in_0_b_valid;
  wire  [2:0] io_tl_in_0_b_bits_opcode;
  wire  [1:0] io_tl_in_0_b_bits_param;
  wire  [2:0] io_tl_in_0_b_bits_size;
  wire  [4:0] io_tl_in_0_b_bits_source;
  wire  [28:0] io_tl_in_0_b_bits_address;
  wire  [3:0] io_tl_in_0_b_bits_mask;
  wire  [31:0] io_tl_in_0_b_bits_data;

  // Not used
  wire  io_tl_in_0_c_ready;
  wire  io_tl_in_0_c_valid = 1'b0;
  wire  [2:0] io_tl_in_0_c_bits_opcode = 3'b0;
  wire  [2:0] io_tl_in_0_c_bits_param = 3'b0;
  wire  [2:0] io_tl_in_0_c_bits_size = 3'd2;
  wire  [4:0] io_tl_in_0_c_bits_source = 5'b0;
  wire  [28:0] io_tl_in_0_c_bits_address = 29'b0;
  wire  [31:0] io_tl_in_0_c_bits_data = 32'b0;
  wire  io_tl_in_0_c_bits_error = 1'b0;

  // Not used
  wire  io_tl_in_0_e_ready;
  wire  io_tl_in_0_e_valid = 1'b0;
  wire  io_tl_in_0_e_bits_sink = 1'b0;

sirv_aon_wrapper u_sirv_aon_wrapper(
  .core_wfi                         (core_wfi),

  .crossing_reset                   (crossing_reset),

  .io_in_0_a_ready                  (io_tl_in_0_a_ready                  ),
  .io_in_0_a_valid                  (io_tl_in_0_a_valid                  ),
  .io_in_0_a_bits_opcode            (io_tl_in_0_a_bits_opcode            ),
  .io_in_0_a_bits_param             (io_tl_in_0_a_bits_param             ),
  .io_in_0_a_bits_size              (io_tl_in_0_a_bits_size              ),
  .io_in_0_a_bits_source            (io_tl_in_0_a_bits_source            ),
  .io_in_0_a_bits_address           (io_tl_in_0_a_bits_address           ),
  .io_in_0_a_bits_mask              (io_tl_in_0_a_bits_mask              ),
  .io_in_0_a_bits_data              (io_tl_in_0_a_bits_data              ),
  .io_in_0_b_ready                  (io_tl_in_0_b_ready                  ),
  .io_in_0_b_valid                  (io_tl_in_0_b_valid                  ),
  .io_in_0_b_bits_opcode            (io_tl_in_0_b_bits_opcode            ),
  .io_in_0_b_bits_param             (io_tl_in_0_b_bits_param             ),
  .io_in_0_b_bits_size              (io_tl_in_0_b_bits_size              ),
  .io_in_0_b_bits_source            (io_tl_in_0_b_bits_source            ),
  .io_in_0_b_bits_address           (io_tl_in_0_b_bits_address           ),
  .io_in_0_b_bits_mask              (io_tl_in_0_b_bits_mask              ),
  .io_in_0_b_bits_data              (io_tl_in_0_b_bits_data              ),
  .io_in_0_c_ready                  (io_tl_in_0_c_ready                  ),
  .io_in_0_c_valid                  (io_tl_in_0_c_valid                  ),
  .io_in_0_c_bits_opcode            (io_tl_in_0_c_bits_opcode            ),
  .io_in_0_c_bits_param             (io_tl_in_0_c_bits_param             ),
  .io_in_0_c_bits_size              (io_tl_in_0_c_bits_size              ),
  .io_in_0_c_bits_source            (io_tl_in_0_c_bits_source            ),
  .io_in_0_c_bits_address           (io_tl_in_0_c_bits_address           ),
  .io_in_0_c_bits_data              (io_tl_in_0_c_bits_data              ),
  .io_in_0_c_bits_error             (io_tl_in_0_c_bits_error             ),
  .io_in_0_d_ready                  (io_tl_in_0_d_ready                  ),
  .io_in_0_d_valid                  (io_tl_in_0_d_valid                  ),
  .io_in_0_d_bits_opcode            (io_tl_in_0_d_bits_opcode            ),
  .io_in_0_d_bits_param             (io_tl_in_0_d_bits_param             ),
  .io_in_0_d_bits_size              (io_tl_in_0_d_bits_size              ),
  .io_in_0_d_bits_source            (io_tl_in_0_d_bits_source            ),
  .io_in_0_d_bits_sink              (io_tl_in_0_d_bits_sink              ),
  .io_in_0_d_bits_addr_lo           (io_tl_in_0_d_bits_addr_lo           ),
  .io_in_0_d_bits_data              (io_tl_in_0_d_bits_data              ),
  .io_in_0_d_bits_error             (io_tl_in_0_d_bits_error             ),
  .io_in_0_e_ready                  (io_tl_in_0_e_ready                  ),
  .io_in_0_e_valid                  (io_tl_in_0_e_valid                  ),
  .io_in_0_e_bits_sink              (io_tl_in_0_e_bits_sink              ),

  .io_ip_0_0 (aon_wdg_irq),
  .io_ip_0_1 (aon_rtc_irq),

  .io_pads_erst_n_i_ival       (io_pads_aon_erst_n_i_ival       ),
  .io_pads_erst_n_o_oval       (io_pads_aon_erst_n_o_oval       ),
  .io_pads_erst_n_o_oe         (io_pads_aon_erst_n_o_oe         ),
  .io_pads_erst_n_o_ie         (io_pads_aon_erst_n_o_ie         ),
  .io_pads_erst_n_o_pue        (io_pads_aon_erst_n_o_pue        ),
  .io_pads_erst_n_o_ds         (io_pads_aon_erst_n_o_ds         ),
  .io_pads_lfextclk_i_ival     (io_pads_aon_lfextclk_i_ival     ),
  .io_pads_lfextclk_o_oval     (io_pads_aon_lfextclk_o_oval     ),
  .io_pads_lfextclk_o_oe       (io_pads_aon_lfextclk_o_oe       ),
  .io_pads_lfextclk_o_ie       (io_pads_aon_lfextclk_o_ie       ),
  .io_pads_lfextclk_o_pue      (io_pads_aon_lfextclk_o_pue      ),
  .io_pads_lfextclk_o_ds       (io_pads_aon_lfextclk_o_ds       ),
  .io_pads_pmu_dwakeup_n_i_ival(io_pads_aon_pmu_dwakeup_n_i_ival),
  .io_pads_pmu_dwakeup_n_o_oval(io_pads_aon_pmu_dwakeup_n_o_oval),
  .io_pads_pmu_dwakeup_n_o_oe  (io_pads_aon_pmu_dwakeup_n_o_oe  ),
  .io_pads_pmu_dwakeup_n_o_ie  (io_pads_aon_pmu_dwakeup_n_o_ie  ),
  .io_pads_pmu_dwakeup_n_o_pue (io_pads_aon_pmu_dwakeup_n_o_pue ),
  .io_pads_pmu_dwakeup_n_o_ds  (io_pads_aon_pmu_dwakeup_n_o_ds  ),
  .io_pads_pmu_vddpaden_i_ival (io_pads_aon_pmu_vddpaden_i_ival ),
  .io_pads_pmu_vddpaden_o_oval (io_pads_aon_pmu_vddpaden_o_oval ),
  .io_pads_pmu_vddpaden_o_oe   (io_pads_aon_pmu_vddpaden_o_oe   ),
  .io_pads_pmu_vddpaden_o_ie   (io_pads_aon_pmu_vddpaden_o_ie   ),
  .io_pads_pmu_vddpaden_o_pue  (io_pads_aon_pmu_vddpaden_o_pue  ),
  .io_pads_pmu_vddpaden_o_ds   (io_pads_aon_pmu_vddpaden_o_ds   ),

  .io_pmu_tcmshutdw(aon_pmu_tcmshutdw),
  .io_pmu_tcmretion(aon_pmu_tcmretion),
  .io_pmu_moff_isolate(aon_pmu_moff_isolate),
  .io_rsts_hfclkrst(hfclkrst),
  .io_rsts_corerst (corerst ),
  .io_rtc (aon_rtcToggle),

  .test_mode        (test_mode        ),
  .test_iso_override(test_iso_override)
);


endmodule
