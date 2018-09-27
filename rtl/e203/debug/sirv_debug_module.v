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
//  The debug module
//
// ====================================================================

`include "e203_defines.v"

module sirv_debug_module
# (
  parameter SUPPORT_JTAG_DTM = 1,
  parameter ASYNC_FF_LEVELS = 2,
  parameter PC_SIZE = 32,
  parameter HART_NUM = 1,
  parameter HART_ID_W = 1
) (

  output  inspect_jtag_clk,

    // The interface with commit stage
  input   [PC_SIZE-1:0] cmt_dpc,
  input   cmt_dpc_ena,

  input   [3-1:0] cmt_dcause,
  input   cmt_dcause_ena,

  input  dbg_irq_r,

    // The interface with CSR control 
  input  wr_dcsr_ena    ,
  input  wr_dpc_ena     ,
  input  wr_dscratch_ena,



  input  [32-1:0] wr_csr_nxt    ,

  output[32-1:0] dcsr_r    ,
  output[PC_SIZE-1:0] dpc_r     ,
  output[32-1:0] dscratch_r,

  output dbg_mode,
  output dbg_halt_r,
  output dbg_step_r,
  output dbg_ebreakm_r,
  output dbg_stopcycle,


  // The system memory bus interface
  input                      i_icb_cmd_valid,
  output                     i_icb_cmd_ready,
  input  [12-1:0]            i_icb_cmd_addr, 
  input                      i_icb_cmd_read, 
  input  [32-1:0]            i_icb_cmd_wdata,
  
  output                     i_icb_rsp_valid,
  input                      i_icb_rsp_ready,
  output [32-1:0]            i_icb_rsp_rdata,


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

  // To the target hart
  output [HART_NUM-1:0]      o_dbg_irq,
  output [HART_NUM-1:0]      o_ndreset,
  output [HART_NUM-1:0]      o_fullreset,

  input   core_csr_clk,
  input   hfclk,
  input   corerst,

  input   test_mode 
);


  wire dm_rst;
  wire dm_rst_n;

  //This is to reset Debug module's logic, the debug module have same clock domain 
  //  as the main domain, so just use the same reset.
 sirv_ResetCatchAndSync_2 u_dm_ResetCatchAndSync_2_1 (
    .test_mode(test_mode),
    .clock(hfclk),// Use same clock as main domain
    .reset(corerst),
    .io_sync_reset(dm_rst)
  );
  
  assign dm_rst_n = ~dm_rst;

  //This is to reset the JTAG_CLK relevant logics, since the chip does not 
  //  have the JTAG_RST used really, so we need to use the global chip reset to reset
  //  JTAG relevant logics
 wire jtag_TCK;
 wire jtag_reset;

 sirv_ResetCatchAndSync u_jtag_ResetCatchAndSync_3_1 (
    .test_mode(test_mode),
    .clock(jtag_TCK),
    .reset(corerst),
    .io_sync_reset(jtag_reset)
  );


  wire dm_clk = hfclk;// Currently Debug Module have same clock domain as core

  wire jtag_TDI;
  wire jtag_TDO;
  wire jtag_TMS;
  wire jtag_TRST;
  wire jtag_DRV_TDO;

  sirv_jtaggpioport u_jtag_pins (
    .clock(1'b0),
    .reset(1'b1),
    .io_jtag_TCK(jtag_TCK),
    .io_jtag_TMS(jtag_TMS),
    .io_jtag_TDI(jtag_TDI),
    .io_jtag_TDO(jtag_TDO),
    .io_jtag_TRST(jtag_TRST),
    .io_jtag_DRV_TDO(jtag_DRV_TDO),
    .io_pins_TCK_i_ival(io_pads_jtag_TCK_i_ival),
    .io_pins_TCK_o_oval(io_pads_jtag_TCK_o_oval),
    .io_pins_TCK_o_oe(io_pads_jtag_TCK_o_oe),
    .io_pins_TCK_o_ie(io_pads_jtag_TCK_o_ie),
    .io_pins_TCK_o_pue(io_pads_jtag_TCK_o_pue),
    .io_pins_TCK_o_ds(io_pads_jtag_TCK_o_ds),
    .io_pins_TMS_i_ival(io_pads_jtag_TMS_i_ival),
    .io_pins_TMS_o_oval(io_pads_jtag_TMS_o_oval),
    .io_pins_TMS_o_oe(io_pads_jtag_TMS_o_oe),
    .io_pins_TMS_o_ie(io_pads_jtag_TMS_o_ie),
    .io_pins_TMS_o_pue(io_pads_jtag_TMS_o_pue),
    .io_pins_TMS_o_ds(io_pads_jtag_TMS_o_ds),
    .io_pins_TDI_i_ival(io_pads_jtag_TDI_i_ival),
    .io_pins_TDI_o_oval(io_pads_jtag_TDI_o_oval),
    .io_pins_TDI_o_oe(io_pads_jtag_TDI_o_oe),
    .io_pins_TDI_o_ie(io_pads_jtag_TDI_o_ie),
    .io_pins_TDI_o_pue(io_pads_jtag_TDI_o_pue),
    .io_pins_TDI_o_ds(io_pads_jtag_TDI_o_ds),
    .io_pins_TDO_i_ival(io_pads_jtag_TDO_i_ival),
    .io_pins_TDO_o_oval(io_pads_jtag_TDO_o_oval),
    .io_pins_TDO_o_oe(io_pads_jtag_TDO_o_oe),
    .io_pins_TDO_o_ie(io_pads_jtag_TDO_o_ie),
    .io_pins_TDO_o_pue(io_pads_jtag_TDO_o_pue),
    .io_pins_TDO_o_ds(io_pads_jtag_TDO_o_ds),
    .io_pins_TRST_n_i_ival(io_pads_jtag_TRST_n_i_ival),
    .io_pins_TRST_n_o_oval(io_pads_jtag_TRST_n_o_oval),
    .io_pins_TRST_n_o_oe(io_pads_jtag_TRST_n_o_oe),
    .io_pins_TRST_n_o_ie(io_pads_jtag_TRST_n_o_ie),
    .io_pins_TRST_n_o_pue(io_pads_jtag_TRST_n_o_pue),
    .io_pins_TRST_n_o_ds(io_pads_jtag_TRST_n_o_ds)
  );


  sirv_debug_csr # (
          .PC_SIZE(PC_SIZE)
      ) u_sirv_debug_csr (
    .dbg_stopcycle   (dbg_stopcycle  ),
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

    .clk             (core_csr_clk),
    .rst_n           (dm_rst_n ) 
  );



  // The debug bus interface
  wire                     dtm_req_valid;
  wire                     dtm_req_ready;
  wire [41-1 :0]           dtm_req_bits;

  wire                     dtm_resp_valid;
  wire                     dtm_resp_ready;
  wire [36-1 : 0]          dtm_resp_bits;

  generate
    if(SUPPORT_JTAG_DTM == 1) begin: jtag_dtm_gen
      sirv_jtag_dtm # (
          .ASYNC_FF_LEVELS(ASYNC_FF_LEVELS)
      ) u_sirv_jtag_dtm (
                       
        .jtag_TDI           (jtag_TDI      ),
        .jtag_TDO           (jtag_TDO      ),
        .jtag_TCK           (jtag_TCK      ),
        .jtag_TMS           (jtag_TMS      ),
        .jtag_TRST          (jtag_reset    ),
                            
        .jtag_DRV_TDO       (jtag_DRV_TDO  ),
                           
        .dtm_req_valid      (dtm_req_valid ),
        .dtm_req_ready      (dtm_req_ready ),
        .dtm_req_bits       (dtm_req_bits  ),
                          
        .dtm_resp_valid     (dtm_resp_valid),
        .dtm_resp_ready     (dtm_resp_ready),
        .dtm_resp_bits      (dtm_resp_bits )
      );
   end
   else begin: no_jtag_dtm_gen
      assign jtag_TDI  = 1'b0;
      assign jtag_TDO  = 1'b0;
      assign jtag_TCK  = 1'b0;
      assign jtag_TMS  = 1'b0;
      assign jtag_DRV_TDO = 1'b0;
      assign dtm_req_valid = 1'b0;
      assign dtm_req_bits = 41'b0;
      assign dtm_resp_ready = 1'b0;
   end
  endgenerate

  wire                i_dtm_req_valid;
  wire                i_dtm_req_ready;
  wire [41-1 :0]      i_dtm_req_bits;

  wire                i_dtm_resp_valid;
  wire                i_dtm_resp_ready;
  wire [36-1 : 0]     i_dtm_resp_bits;

  sirv_gnrl_cdc_tx   
   # (
     .DW      (36),
     .SYNC_DP (ASYNC_FF_LEVELS) 
   ) u_dm2dtm_cdc_tx (
     .o_vld  (dtm_resp_valid), 
     .o_rdy_a(dtm_resp_ready), 
     .o_dat  (dtm_resp_bits ),
     .i_vld  (i_dtm_resp_valid),
     .i_rdy  (i_dtm_resp_ready),
     .i_dat  (i_dtm_resp_bits ),
   
     .clk    (dm_clk),
     .rst_n  (dm_rst_n)
   );
     
   sirv_gnrl_cdc_rx   
      # (
     .DW      (41),
     .SYNC_DP (ASYNC_FF_LEVELS) 
   ) u_dm2dtm_cdc_rx (
     .i_vld_a(dtm_req_valid), 
     .i_rdy  (dtm_req_ready), 
     .i_dat  (dtm_req_bits ),
     .o_vld  (i_dtm_req_valid),
     .o_rdy  (i_dtm_req_ready),
     .o_dat  (i_dtm_req_bits ),
   
     .clk    (dm_clk),
     .rst_n  (dm_rst_n)
   );

  wire i_dtm_req_hsked = i_dtm_req_valid & i_dtm_req_ready; 

  wire [ 4:0] dtm_req_bits_addr;
  wire [33:0] dtm_req_bits_data;
  wire [ 1:0] dtm_req_bits_op;

  wire [33:0] dtm_resp_bits_data;
  wire [ 1:0] dtm_resp_bits_resp;

  assign dtm_req_bits_addr = i_dtm_req_bits[40:36];
  assign dtm_req_bits_data = i_dtm_req_bits[35:2];
  assign dtm_req_bits_op   = i_dtm_req_bits[1:0];
  assign i_dtm_resp_bits = {dtm_resp_bits_data, dtm_resp_bits_resp};

  // The OP field
  //   0: Ignore data. (nop)
  //   1: Read from address. (read)
  //   2: Read from address. Then write data to address. (write) 
  //   3: Reserved.
  wire dtm_req_rd = (dtm_req_bits_op == 2'd1);
  wire dtm_req_wr = (dtm_req_bits_op == 2'd2);

  wire dtm_req_sel_dbgram   = (dtm_req_bits_addr[4:3] == 2'b0) & (~(dtm_req_bits_addr[2:0] == 3'b111));//0x00-0x06
  wire dtm_req_sel_dmcontrl = (dtm_req_bits_addr == 5'h10);
  wire dtm_req_sel_dminfo   = (dtm_req_bits_addr == 5'h11);
  wire dtm_req_sel_haltstat = (dtm_req_bits_addr == 5'h1C);

  wire [33:0] dminfo_r;
  wire [33:0] dmcontrol_r;

  wire [HART_NUM-1:0] dm_haltnot_r;
  wire [HART_NUM-1:0] dm_debint_r;

  //In the future if it is multi-core, then we need to add the core ID, to support this
  //   text from the debug_spec_v0.11
  //   At the cost of more hardware, this can be resolved in two ways. If
  //   the bus knows an ID for the originator, then the Debug Module can refuse write
  //   accesses to originators that don't match the hart ID set in hartid of dmcontrol.
  //

  // The Resp field
  //   0: The previous operation completed successfully.
  //   1: Reserved.
  //   2: The previous operation failed. The data scanned into dbus in this access
  //      will be ignored. This status is sticky and can be cleared by writing dbusreset in dtmcontrol.
  //   3: The previous operation is still in progress. The data scanned into dbus
  //      in this access will be ignored. 
  wire [31:0] ram_dout;
  assign dtm_resp_bits_data =
            ({34{dtm_req_sel_dbgram  }} & {dmcontrol_r[33:32],ram_dout})
          | ({34{dtm_req_sel_dmcontrl}} & dmcontrol_r)
          | ({34{dtm_req_sel_dminfo  }} & dminfo_r)
          | ({34{dtm_req_sel_haltstat}} & {{34-HART_ID_W{1'b0}},dm_haltnot_r});

  assign dtm_resp_bits_resp = 2'd0;

  wire icb_access_dbgram_ena;

  wire i_dtm_req_condi = dtm_req_sel_dbgram ? (~icb_access_dbgram_ena) : 1'b1;
  assign i_dtm_req_ready    = i_dtm_req_condi & i_dtm_resp_ready;
  assign i_dtm_resp_valid   = i_dtm_req_condi & i_dtm_req_valid;


  // DMINFORdData_reserved0 = 2'h0;
  // DMINFORdData_abussize = 7'h0;
  // DMINFORdData_serialcount = 4'h0;
  // DMINFORdData_access128 = 1'h0;
  // DMINFORdData_access64 = 1'h0;
  // DMINFORdData_access32 = 1'h0;
  // DMINFORdData_access16 = 1'h0;
  // DMINFORdData_accesss8 = 1'h0;
  // DMINFORdData_dramsize = 6'h6;
  // DMINFORdData_haltsum = 1'h0;
  // DMINFORdData_reserved1 = 3'h0;
  // DMINFORdData_authenticated = 1'h1;
  // DMINFORdData_authbusy = 1'h0;
  // DMINFORdData_authtype = 2'h0;
  // DMINFORdData_version = 2'h1;
  assign dminfo_r[33:16] = 18'b0;
  assign dminfo_r[15:10] = 6'h6;
  assign dminfo_r[9:6]   = 4'b0;
  assign dminfo_r[5]     = 1'h1;
  assign dminfo_r[4:2]   = 3'b0;
  assign dminfo_r[1:0]   = 2'h1;


  wire [HART_ID_W-1:0] dm_hartid_r;

  wire [1:0] dm_debint_arr  = {1'b0,dm_debint_r };
  wire [1:0] dm_haltnot_arr = {1'b0,dm_haltnot_r};
  assign dmcontrol_r[33] = dm_debint_arr [dm_hartid_r];
  assign dmcontrol_r[32] = dm_haltnot_arr[dm_hartid_r];
  assign dmcontrol_r[31:12] = 20'b0;
  assign dmcontrol_r[11:2] = {{10-HART_ID_W{1'b0}},dm_hartid_r};
  assign dmcontrol_r[1:0] = 2'b0;

  wire dtm_wr_dmcontrol = dtm_req_sel_dmcontrl & dtm_req_wr;
  wire dtm_wr_dbgram    = dtm_req_sel_dbgram   & dtm_req_wr;

  wire dtm_wr_interrupt_ena = i_dtm_req_hsked & (dtm_wr_dmcontrol | dtm_wr_dbgram) & dtm_req_bits_data[33];//W1
  wire dtm_wr_haltnot_ena   = i_dtm_req_hsked & (dtm_wr_dmcontrol | dtm_wr_dbgram) & (~dtm_req_bits_data[32]);//W0
  wire dtm_wr_hartid_ena    = i_dtm_req_hsked & dtm_wr_dmcontrol;
  wire dtm_wr_dbgram_ena    = i_dtm_req_hsked & dtm_wr_dbgram;

  wire dtm_access_dbgram_ena    = i_dtm_req_hsked & dtm_req_sel_dbgram;

  wire dm_hartid_ena = dtm_wr_hartid_ena;
  wire [HART_ID_W-1:0] dm_hartid_nxt = dtm_req_bits_data[HART_ID_W+2-1:2];
  sirv_gnrl_dfflr #(HART_ID_W) dm_hartid_dfflr (dm_hartid_ena, dm_hartid_nxt, dm_hartid_r, dm_clk, dm_rst_n);


  //////////////////////////////////////////////////////////////
  // Impelement the DM ICB system bus agent
  //   0x100 - 0x2ff Debug Module registers described in Section 7.12.
  //       * Only two registers needed, others are not supported
  //                  cleardebint, at 0x100 
  //                  sethaltnot,  at 0x10c 
  //   0x400 - 0x4ff Up to 256 bytes of Debug RAM. Each unique address species 8 bits.
  //       * Since this is remapped to each core's ITCM, we dont handle it at this module
  //   0x800 - 0x9ff Up to 512 bytes of Debug ROM.
  //    
  //
  wire i_icb_cmd_hsked = i_icb_cmd_valid & i_icb_cmd_ready;
  wire icb_wr_ena = i_icb_cmd_hsked & (~i_icb_cmd_read);
  wire icb_sel_cleardebint = (i_icb_cmd_addr == 12'h100);
  wire icb_sel_sethaltnot  = (i_icb_cmd_addr == 12'h10c);
  wire icb_sel_dbgrom  = (i_icb_cmd_addr[12-1:8] == 4'h8);
  wire icb_sel_dbgram  = (i_icb_cmd_addr[12-1:8] == 4'h4);


  wire icb_wr_cleardebint_ena = icb_wr_ena & icb_sel_cleardebint;
  wire icb_wr_sethaltnot_ena  = icb_wr_ena & icb_sel_sethaltnot ;

  assign icb_access_dbgram_ena = i_icb_cmd_hsked & icb_sel_dbgram;

  wire cleardebint_ena = icb_wr_cleardebint_ena;
  wire [HART_ID_W-1:0] cleardebint_r;
  wire [HART_ID_W-1:0] cleardebint_nxt = i_icb_cmd_wdata[HART_ID_W-1:0];
  sirv_gnrl_dfflr #(HART_ID_W) cleardebint_dfflr (cleardebint_ena, cleardebint_nxt, cleardebint_r, dm_clk, dm_rst_n);

  wire sethaltnot_ena = icb_wr_sethaltnot_ena;
  wire [HART_ID_W-1:0] sethaltnot_r;
  wire [HART_ID_W-1:0] sethaltnot_nxt = i_icb_cmd_wdata[HART_ID_W-1:0];
  sirv_gnrl_dfflr #(HART_ID_W) sethaltnot_dfflr (sethaltnot_ena, sethaltnot_nxt, sethaltnot_r, dm_clk, dm_rst_n);


  assign i_icb_rsp_valid = i_icb_cmd_valid;// Just directly pass back the valid in 0 cycle
  assign i_icb_cmd_ready = i_icb_rsp_ready;

  wire [31:0] rom_dout;

  assign i_icb_rsp_rdata =  
            ({32{icb_sel_cleardebint}} & {{32-HART_ID_W{1'b0}}, cleardebint_r}) 
          | ({32{icb_sel_sethaltnot }} & {{32-HART_ID_W{1'b0}}, sethaltnot_r})
          | ({32{icb_sel_dbgrom  }} & rom_dout) 
          | ({32{icb_sel_dbgram  }} & ram_dout);

   sirv_debug_rom u_sirv_debug_rom (
     .rom_addr (i_icb_cmd_addr[7-1:2]),
     .rom_dout (rom_dout) 
   );
  //sirv_debug_rom_64 u_sirv_debug_rom_64(
  //  .rom_addr (i_icb_cmd_addr[8-1:2]),
  //  .rom_dout (rom_dout) 
  //);

  wire         ram_cs   = dtm_access_dbgram_ena | icb_access_dbgram_ena;
  wire [3-1:0] ram_addr = dtm_access_dbgram_ena ? dtm_req_bits_addr[2:0] : i_icb_cmd_addr[4:2]; 
  wire         ram_rd   = dtm_access_dbgram_ena ? dtm_req_rd             : i_icb_cmd_read; 
  wire [32-1:0]ram_wdat = dtm_access_dbgram_ena ? dtm_req_bits_data[31:0]: i_icb_cmd_wdata;

  sirv_debug_ram u_sirv_debug_ram(
    .clk      (dm_clk),
    .rst_n    (dm_rst_n), 
    .ram_cs   (ram_cs),
    .ram_rd   (ram_rd),
    .ram_addr (ram_addr),
    .ram_wdat (ram_wdat),
    .ram_dout (ram_dout) 
  );

  wire [HART_NUM-1:0] dm_haltnot_set;
  wire [HART_NUM-1:0] dm_haltnot_clr;
  wire [HART_NUM-1:0] dm_haltnot_ena;
  wire [HART_NUM-1:0] dm_haltnot_nxt;

  wire [HART_NUM-1:0] dm_debint_set;
  wire [HART_NUM-1:0] dm_debint_clr;
  wire [HART_NUM-1:0] dm_debint_ena;
  wire [HART_NUM-1:0] dm_debint_nxt;

  genvar i;
  generate
    for(i = 0; i < HART_NUM; i = i+1)//{
    begin:dm_halt_int_gen

        // The haltnot will be set by system bus set its ID to sethaltnot_r
      assign dm_haltnot_set[i] = icb_wr_sethaltnot_ena & (i_icb_cmd_wdata[HART_ID_W-1:0] == i[HART_ID_W-1:0]);
        // The haltnot will be cleared by DTM write 0 to haltnot
      assign dm_haltnot_clr[i] = dtm_wr_haltnot_ena & (dm_hartid_r == i[HART_ID_W-1:0]);
      assign dm_haltnot_ena[i] = dm_haltnot_set[i] | dm_haltnot_clr[i];
      assign dm_haltnot_nxt[i] = dm_haltnot_set[i] | (~dm_haltnot_clr[i]);

      sirv_gnrl_dfflr #(1) dm_haltnot_dfflr (dm_haltnot_ena[i], dm_haltnot_nxt[i], dm_haltnot_r[i], dm_clk, dm_rst_n);

        // The debug intr will be set by DTM write 1 to interrupt
      assign dm_debint_set[i] = dtm_wr_interrupt_ena & (dm_hartid_r == i[HART_ID_W-1:0]);
        // The debug intr will be clear by system bus set its ID to cleardebint_r
      assign dm_debint_clr[i] = icb_wr_cleardebint_ena & (i_icb_cmd_wdata[HART_ID_W-1:0] == i[HART_ID_W-1:0]);
      assign dm_debint_ena[i] = dm_debint_set[i] | dm_debint_clr[i];
      assign dm_debint_nxt[i] = dm_debint_set[i] | (~dm_debint_clr[i]);

      sirv_gnrl_dfflr #(1) dm_debint_dfflr  ( dm_debint_ena[i],  dm_debint_nxt[i],  dm_debint_r[i], dm_clk, dm_rst_n);
    end//}
  endgenerate

  assign o_dbg_irq = dm_debint_r;

 
  assign o_ndreset   = {HART_NUM{1'b0}};
  assign o_fullreset = {HART_NUM{1'b0}};

  assign inspect_jtag_clk = jtag_TCK;

endmodule
