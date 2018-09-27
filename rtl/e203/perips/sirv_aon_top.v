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
//  The top module of always on domain
//
// ====================================================================
module sirv_aon_top #(
    parameter ASYNC_FF_LEVELS = 2
)(

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
  input   io_pads_aon_pmu_padrst_i_ival,
  output  io_pads_aon_pmu_padrst_o_oval,
  output  io_pads_aon_pmu_padrst_o_oe,
  output  io_pads_aon_pmu_padrst_o_ie,
  output  io_pads_aon_pmu_padrst_o_pue,
  output  io_pads_aon_pmu_padrst_o_ds,

  input   io_pads_dbgmode0_n_i_ival,
  input   io_pads_dbgmode1_n_i_ival,
  input   io_pads_dbgmode2_n_i_ival,
  input   io_pads_bootrom_n_i_ival,
  output  io_pads_bootrom_n_o_oval,
  output  io_pads_bootrom_n_o_oe,
  output  io_pads_bootrom_n_o_ie,
  output  io_pads_bootrom_n_o_pue,
  output  io_pads_bootrom_n_o_ds,
  input   io_pads_jtagpwd_n_i_ival,
  output  io_pads_jtagpwd_n_o_oval,
  output  io_pads_jtagpwd_n_o_oe,
  output  io_pads_jtagpwd_n_o_ie,
  output  io_pads_jtagpwd_n_o_pue,
  output  io_pads_jtagpwd_n_o_ds,

  output  hfclkrst,
  output  corerst,

  output  jtagpwd_iso,


  output inspect_mode,
  output inspect_por_rst,
  output inspect_32k_clk,
  input  inspect_pc_29b, 
  input  inspect_dbg_irq,

  output  [32-1:0] pc_rtvec,

  output  aon_wdg_irq,
  output  aon_rtc_irq,
  output  aon_rtcToggle,

  input   lfextclk,
  output  lfxoscen,

  input   test_mode,
  input   test_iso_override
);

  // Since the Aon module need to handle the path from the MOFF domain, which
  //   maybe powered down, so we need to have the isolation cells here
  //   it can be handled by UPF flow, but we can also add them mannually here
  // The inputs from MOFF to aon domain need to be isolated
  // The outputs does not need to be isolated
  wire          isl_icb_cmd_valid;
  wire          isl_icb_cmd_ready;
  wire [32-1:0] isl_icb_cmd_addr; 
  wire          isl_icb_cmd_read; 
  wire [32-1:0] isl_icb_cmd_wdata;
  
  wire          isl_icb_rsp_valid;
  wire          isl_icb_rsp_ready;
  wire [32-1:0] isl_icb_rsp_rdata;

  wire aon_iso;

  assign  isl_icb_cmd_valid = aon_iso ?  1'b0 : i_icb_cmd_valid;
  assign  isl_icb_cmd_addr  = aon_iso ? 32'b0 : i_icb_cmd_addr ; 
  assign  isl_icb_cmd_read  = aon_iso ?  1'b0 : i_icb_cmd_read ; 
  assign  isl_icb_cmd_wdata = aon_iso ? 32'b0 : i_icb_cmd_wdata;
  assign  isl_icb_rsp_ready = aon_iso ?  1'b0 : i_icb_rsp_ready;
  
  assign i_icb_rsp_valid = isl_icb_rsp_valid;
  assign i_icb_cmd_ready = isl_icb_cmd_ready;
  assign i_icb_rsp_rdata = isl_icb_rsp_rdata;

  wire                     synced_icb_cmd_valid;
  wire                     synced_icb_cmd_ready;
  wire [32-1:0]            synced_icb_cmd_addr; 
  wire                     synced_icb_cmd_read; 
  wire [32-1:0]            synced_icb_cmd_wdata;
  
  wire                     synced_icb_rsp_valid;
  wire                     synced_icb_rsp_ready;
  wire [32-1:0]            synced_icb_rsp_rdata;

  wire                     lclkgen_icb_cmd_valid;
  wire                     lclkgen_icb_cmd_ready;
  wire [15-1:0]            lclkgen_icb_cmd_addr; 
  wire                     lclkgen_icb_cmd_read; 
  wire [32-1:0]            lclkgen_icb_cmd_wdata;
  
  wire                     lclkgen_icb_rsp_valid;
  wire                     lclkgen_icb_rsp_ready;
  wire [32-1:0]            lclkgen_icb_rsp_rdata;

  wire                     aon_icb_cmd_valid;
  wire                     aon_icb_cmd_ready;
  wire [15-1:0]            aon_icb_cmd_addr; 
  wire                     aon_icb_cmd_read; 
  wire [32-1:0]            aon_icb_cmd_wdata;
  
  wire                     aon_icb_rsp_valid;
  wire                     aon_icb_rsp_ready;
  wire [32-1:0]            aon_icb_rsp_rdata;

  localparam CMD_PACK_W = 65;

  wire [CMD_PACK_W-1:0] synced_icb_cmd_pack;
  wire [CMD_PACK_W-1:0] isl_icb_cmd_pack;
  
  assign isl_icb_cmd_pack = {
          isl_icb_cmd_addr, 
          isl_icb_cmd_read, 
          isl_icb_cmd_wdata};

  assign {synced_icb_cmd_addr, 
          synced_icb_cmd_read, 
          synced_icb_cmd_wdata} = synced_icb_cmd_pack;

  wire crossing_clock;
  wire crossing_reset;

  wire crossing_reset_n = ~crossing_reset;


  sirv_gnrl_cdc_tx   
   # (
     .DW      (32),
     .SYNC_DP (ASYNC_FF_LEVELS) 
   ) u_aon_icb_cdc_tx (
     .o_vld  (isl_icb_rsp_valid ), 
     .o_rdy_a(isl_icb_rsp_ready ), 
     .o_dat  (isl_icb_rsp_rdata ),
     .i_vld  (synced_icb_rsp_valid ),
     .i_rdy  (synced_icb_rsp_ready ),
     .i_dat  (synced_icb_rsp_rdata ),
   
     .clk    (crossing_clock),
     .rst_n  (crossing_reset_n)
   );
     
   sirv_gnrl_cdc_rx   
      # (
     .DW      (CMD_PACK_W),
     .SYNC_DP (ASYNC_FF_LEVELS) 
   ) u_aon_icb_cdc_rx (
     .i_vld_a(isl_icb_cmd_valid), 
     .i_rdy  (isl_icb_cmd_ready), 
     .i_dat  (isl_icb_cmd_pack),
     .o_vld  (synced_icb_cmd_valid),
     .o_rdy  (synced_icb_cmd_ready),
     .o_dat  (synced_icb_cmd_pack),
   
     .clk    (crossing_clock),
     .rst_n  (crossing_reset_n)
   );



  sirv_icb1to2_bus # (
  .ICB_FIFO_DP        (0),//Pass through
  .ICB_FIFO_CUT_READY (1),// 

  .AW                   (15),
  .DW                   (32),
  .SPLT_FIFO_OUTS_NUM   (1),// Allow 1 oustanding
  .SPLT_FIFO_CUT_READY  (1),// Always cut ready
  //  * LCLKGEN       : 0x200 -- 0x2FF
  .O0_BASE_ADDR       (15'h200),       
  .O0_BASE_REGION_LSB (8) 
  )u_aon_1to2_icb(

    .i_icb_cmd_valid  (synced_icb_cmd_valid),
    .i_icb_cmd_ready  (synced_icb_cmd_ready),
    .i_icb_cmd_addr   (synced_icb_cmd_addr[14:0] ),
    .i_icb_cmd_read   (synced_icb_cmd_read ),
    .i_icb_cmd_wdata  (synced_icb_cmd_wdata),
    .i_icb_cmd_wmask  (4'hF),
    .i_icb_cmd_lock   (1'b0),
    .i_icb_cmd_excl   (1'b0 ),
    .i_icb_cmd_size   (2'b0 ),
    .i_icb_cmd_burst  (2'b0 ),
    .i_icb_cmd_beat   (2'b0 ),
    
    .i_icb_rsp_valid  (synced_icb_rsp_valid),
    .i_icb_rsp_ready  (synced_icb_rsp_ready),
    .i_icb_rsp_err    (),
    .i_icb_rsp_excl_ok(),
    .i_icb_rsp_rdata  (synced_icb_rsp_rdata),
    
  //  * LCLKGEN 
        //
    .o0_icb_cmd_valid  (lclkgen_icb_cmd_valid),
    .o0_icb_cmd_ready  (lclkgen_icb_cmd_ready),
    .o0_icb_cmd_addr   (lclkgen_icb_cmd_addr ),
    .o0_icb_cmd_read   (lclkgen_icb_cmd_read ),
    .o0_icb_cmd_wdata  (lclkgen_icb_cmd_wdata),
    .o0_icb_cmd_wmask  (),
    .o0_icb_cmd_lock   (),
    .o0_icb_cmd_excl   (),
    .o0_icb_cmd_size   (),
    .o0_icb_cmd_burst  (),
    .o0_icb_cmd_beat   (),
    
    .o0_icb_rsp_valid  (lclkgen_icb_rsp_valid),
    .o0_icb_rsp_ready  (lclkgen_icb_rsp_ready),
    .o0_icb_rsp_err    (1'b0),
    .o0_icb_rsp_excl_ok(1'b0  ),
    .o0_icb_rsp_rdata  (lclkgen_icb_rsp_rdata),

  //  * AON      
    .o1_icb_cmd_valid  (aon_icb_cmd_valid),
    .o1_icb_cmd_ready  (aon_icb_cmd_ready),
    .o1_icb_cmd_addr   (aon_icb_cmd_addr ),
    .o1_icb_cmd_read   (aon_icb_cmd_read ),
    .o1_icb_cmd_wdata  (aon_icb_cmd_wdata),
    .o1_icb_cmd_wmask  (),
    .o1_icb_cmd_lock   (),
    .o1_icb_cmd_excl   (),
    .o1_icb_cmd_size   (),
    .o1_icb_cmd_burst  (),
    .o1_icb_cmd_beat   (),
    
    .o1_icb_rsp_valid  (aon_icb_rsp_valid),
    .o1_icb_rsp_ready  (aon_icb_rsp_ready),
    .o1_icb_rsp_err    (1'b0  ),
    .o1_icb_rsp_excl_ok(1'b0  ),
    .o1_icb_rsp_rdata  (aon_icb_rsp_rdata),

    .clk         (crossing_clock),
    .rst_n       (crossing_reset_n) 
  );

  wire aon_reset;
  wire aon_reset_n = ~aon_reset;

  sirv_aon_lclkgen_regs u_aon_lclkgen_regs(
    .clk         (crossing_clock),// Crossing clock is actually the aon_clk
    .rst_n       (aon_reset_n),// Here we need to use the aon_rst rather than the crossing reset

    .lfxoscen    (lfxoscen    ),

    .i_icb_cmd_valid(lclkgen_icb_cmd_valid),
    .i_icb_cmd_ready(lclkgen_icb_cmd_ready),
    .i_icb_cmd_addr (lclkgen_icb_cmd_addr[7:0]), 
    .i_icb_cmd_read (lclkgen_icb_cmd_read ), 
    .i_icb_cmd_wdata(lclkgen_icb_cmd_wdata),
                     
    .i_icb_rsp_valid(lclkgen_icb_rsp_valid),
    .i_icb_rsp_ready(lclkgen_icb_rsp_ready),
    .i_icb_rsp_rdata(lclkgen_icb_rsp_rdata)
  );


  wire  io_tl_in_0_a_ready;
  assign  aon_icb_cmd_ready  = io_tl_in_0_a_ready;
  wire  io_tl_in_0_a_valid  = aon_icb_cmd_valid;
  wire  [2:0] io_tl_in_0_a_bits_opcode  = aon_icb_cmd_read ? 3'h4 : 3'h0;
  wire  [2:0] io_tl_in_0_a_bits_param  = 3'b0;
  wire  [2:0] io_tl_in_0_a_bits_size = 3'd2;
  wire  [4:0] io_tl_in_0_a_bits_source  = 5'b0;
  wire  [28:0] io_tl_in_0_a_bits_address  = {14'b0,aon_icb_cmd_addr[14:0]};
  wire  [3:0] io_tl_in_0_a_bits_mask  = 4'b1111;
  wire  [31:0] io_tl_in_0_a_bits_data  = aon_icb_cmd_wdata;

  
  wire  io_tl_in_0_d_ready = aon_icb_rsp_ready;

  wire  [2:0] io_tl_in_0_d_bits_opcode;
  wire  [1:0] io_tl_in_0_d_bits_param;
  wire  [2:0] io_tl_in_0_d_bits_size;
  wire  [4:0] io_tl_in_0_d_bits_source;
  wire  io_tl_in_0_d_bits_sink;
  wire  [1:0] io_tl_in_0_d_bits_addr_lo;
  wire  [31:0] io_tl_in_0_d_bits_data;
  wire  io_tl_in_0_d_bits_error;
  wire  io_tl_in_0_d_valid;

  assign  aon_icb_rsp_valid = io_tl_in_0_d_valid;
  assign  aon_icb_rsp_rdata = io_tl_in_0_d_bits_data;

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

  .aon_reset                        (aon_reset),
  .aon_iso                          (aon_iso),
  .jtagpwd_iso                      (jtagpwd_iso),
  .crossing_clock                   (crossing_clock),
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
  .io_pads_lfextclk_i_ival     (lfextclk     ),
  .io_pads_lfextclk_o_oval     (),
  .io_pads_lfextclk_o_oe       (),
  .io_pads_lfextclk_o_ie       (),
  .io_pads_lfextclk_o_pue      (),
  .io_pads_lfextclk_o_ds       (),
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
  .io_pads_pmu_padrst_i_ival (io_pads_aon_pmu_padrst_i_ival ),
  .io_pads_pmu_padrst_o_oval (io_pads_aon_pmu_padrst_o_oval ),
  .io_pads_pmu_padrst_o_oe   (io_pads_aon_pmu_padrst_o_oe   ),
  .io_pads_pmu_padrst_o_ie   (io_pads_aon_pmu_padrst_o_ie   ),
  .io_pads_pmu_padrst_o_pue  (io_pads_aon_pmu_padrst_o_pue  ),
  .io_pads_pmu_padrst_o_ds   (io_pads_aon_pmu_padrst_o_ds   ),

    .io_pads_jtagpwd_n_i_ival       (io_pads_jtagpwd_n_i_ival),
    .io_pads_jtagpwd_n_o_oval       (io_pads_jtagpwd_n_o_oval),
    .io_pads_jtagpwd_n_o_oe         (io_pads_jtagpwd_n_o_oe  ),
    .io_pads_jtagpwd_n_o_ie         (io_pads_jtagpwd_n_o_ie  ),
    .io_pads_jtagpwd_n_o_pue        (io_pads_jtagpwd_n_o_pue ),
    .io_pads_jtagpwd_n_o_ds         (io_pads_jtagpwd_n_o_ds  ),

    .io_pads_bootrom_n_i_ival       (io_pads_bootrom_n_i_ival),
    .io_pads_bootrom_n_o_oval       (io_pads_bootrom_n_o_oval),
    .io_pads_bootrom_n_o_oe         (io_pads_bootrom_n_o_oe  ),
    .io_pads_bootrom_n_o_ie         (io_pads_bootrom_n_o_ie  ),
    .io_pads_bootrom_n_o_pue        (io_pads_bootrom_n_o_pue ),
    .io_pads_bootrom_n_o_ds         (io_pads_bootrom_n_o_ds  ),

    .io_pads_dbgmode0_n_i_ival       (io_pads_dbgmode0_n_i_ival),
    .io_pads_dbgmode1_n_i_ival       (io_pads_dbgmode1_n_i_ival),
    .io_pads_dbgmode2_n_i_ival       (io_pads_dbgmode2_n_i_ival),

    .inspect_mode            (inspect_mode     ), 
    .inspect_pc_29b          (inspect_pc_29b   ), 
    .inspect_por_rst         (inspect_por_rst  ), 
    .inspect_32k_clk         (inspect_32k_clk  ), 
    .inspect_dbg_irq         (inspect_dbg_irq  ),


  .pc_rtvec (pc_rtvec),

  .io_rsts_hfclkrst(hfclkrst),
  .io_rsts_corerst (corerst ),
  .io_rtc (aon_rtcToggle),

  .test_mode        (test_mode        ),
  .test_iso_override(test_iso_override)
);


endmodule
