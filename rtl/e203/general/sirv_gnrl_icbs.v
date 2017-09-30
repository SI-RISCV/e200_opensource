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
//  All of the general modules for ICB relevant functions
//
// ====================================================================



// ===========================================================================
//
// Description:
//  The module to handle the ICB bus arbitration
//
// ===========================================================================

module sirv_gnrl_icb_arbt # (
  parameter AW = 32,
  parameter DW = 64,
  parameter USR_W = 1,
  parameter ARBT_SCHEME = 0,//0: priority based; 1: rrobin
  // The number of outstanding transactions supported
  parameter FIFO_OUTS_NUM = 1,
  parameter FIFO_CUT_READY = 0,
  // ARBT_NUM=4 ICB ports, so 2 bits for port id
  parameter ARBT_NUM = 4,
  parameter ALLOW_0CYCL_RSP = 1,
  parameter ARBT_PTR_W = 2
) (
  output             o_icb_cmd_valid, 
  input              o_icb_cmd_ready, 
  output [1-1:0]     o_icb_cmd_read, 
  output [AW-1:0]    o_icb_cmd_addr, 
  output [DW-1:0]    o_icb_cmd_wdata, 
  output [DW/8-1:0]  o_icb_cmd_wmask,
  output [2-1:0]     o_icb_cmd_burst, 
  output [2-1:0]     o_icb_cmd_beat, 
  output             o_icb_cmd_lock,
  output             o_icb_cmd_excl,
  output [1:0]       o_icb_cmd_size,
  output [USR_W-1:0] o_icb_cmd_usr,

  input              o_icb_rsp_valid, 
  output             o_icb_rsp_ready, 
  input              o_icb_rsp_err,
  input              o_icb_rsp_excl_ok,
  input  [DW-1:0]    o_icb_rsp_rdata, 
  input  [USR_W-1:0] o_icb_rsp_usr, 
  
  output [ARBT_NUM*1-1:0]     i_bus_icb_cmd_ready, 
  input  [ARBT_NUM*1-1:0]     i_bus_icb_cmd_valid, 
  input  [ARBT_NUM*1-1:0]     i_bus_icb_cmd_read, 
  input  [ARBT_NUM*AW-1:0]    i_bus_icb_cmd_addr, 
  input  [ARBT_NUM*DW-1:0]    i_bus_icb_cmd_wdata, 
  input  [ARBT_NUM*DW/8-1:0]  i_bus_icb_cmd_wmask,
  input  [ARBT_NUM*2-1:0]     i_bus_icb_cmd_burst,
  input  [ARBT_NUM*2-1:0]     i_bus_icb_cmd_beat ,
  input  [ARBT_NUM*1-1:0]     i_bus_icb_cmd_lock ,
  input  [ARBT_NUM*1-1:0]     i_bus_icb_cmd_excl ,
  input  [ARBT_NUM*2-1:0]     i_bus_icb_cmd_size ,
  input  [ARBT_NUM*USR_W-1:0] i_bus_icb_cmd_usr  ,

  output [ARBT_NUM*1-1:0]     i_bus_icb_rsp_valid, 
  input  [ARBT_NUM*1-1:0]     i_bus_icb_rsp_ready, 
  output [ARBT_NUM*1-1:0]     i_bus_icb_rsp_err,
  output [ARBT_NUM*1-1:0]     i_bus_icb_rsp_excl_ok,
  output [ARBT_NUM*DW-1:0]    i_bus_icb_rsp_rdata, 
  output [ARBT_NUM*USR_W-1:0] i_bus_icb_rsp_usr, 

  input  clk,  
  input  rst_n
  );


integer j;
wire [ARBT_NUM-1:0] i_bus_icb_cmd_grt_vec; 
wire [ARBT_NUM-1:0] i_bus_icb_cmd_sel; 
wire o_icb_cmd_valid_real; 
wire o_icb_cmd_ready_real; 

wire [1-1:0]    i_icb_cmd_read [ARBT_NUM-1:0]; 
wire [AW-1:0]   i_icb_cmd_addr [ARBT_NUM-1:0]; 
wire [DW-1:0]   i_icb_cmd_wdata[ARBT_NUM-1:0]; 
wire [DW/8-1:0] i_icb_cmd_wmask[ARBT_NUM-1:0];
wire [2-1:0]    i_icb_cmd_burst[ARBT_NUM-1:0];
wire [2-1:0]    i_icb_cmd_beat [ARBT_NUM-1:0];
wire [1-1:0]    i_icb_cmd_lock [ARBT_NUM-1:0];
wire [1-1:0]    i_icb_cmd_excl [ARBT_NUM-1:0];
wire [2-1:0]    i_icb_cmd_size [ARBT_NUM-1:0];
wire [USR_W-1:0]i_icb_cmd_usr  [ARBT_NUM-1:0];

reg [1-1:0]    sel_o_icb_cmd_read; 
reg [AW-1:0]   sel_o_icb_cmd_addr; 
reg [DW-1:0]   sel_o_icb_cmd_wdata; 
reg [DW/8-1:0] sel_o_icb_cmd_wmask;
reg [2-1:0]    sel_o_icb_cmd_burst;
reg [2-1:0]    sel_o_icb_cmd_beat ;
reg [1-1:0]    sel_o_icb_cmd_lock ;
reg [1-1:0]    sel_o_icb_cmd_excl ;
reg [2-1:0]    sel_o_icb_cmd_size ;
reg [USR_W-1:0]sel_o_icb_cmd_usr  ;

wire o_icb_rsp_ready_pre; 
wire o_icb_rsp_valid_pre;

wire rspid_fifo_bypass;
wire rspid_fifo_wen;
wire rspid_fifo_ren;

wire [ARBT_PTR_W-1:0] i_icb_rsp_port_id;

wire rspid_fifo_i_valid;
wire rspid_fifo_o_valid;
wire rspid_fifo_i_ready;
wire rspid_fifo_o_ready;
wire [ARBT_PTR_W-1:0] rspid_fifo_rdat;
wire [ARBT_PTR_W-1:0] rspid_fifo_wdat;

wire rspid_fifo_full;       
wire rspid_fifo_empty;       
reg [ARBT_PTR_W-1:0] i_arbt_indic_id;

wire i_icb_cmd_ready_pre;
wire i_icb_cmd_valid_pre;

wire arbt_ena;
    
wire [ARBT_PTR_W-1:0] o_icb_rsp_port_id;

genvar i;
generate //{
  if(ARBT_NUM == 1) begin:arbt_num_eq_1_gen// {
    assign i_bus_icb_cmd_ready = o_icb_cmd_ready    ;
    assign o_icb_cmd_valid     = i_bus_icb_cmd_valid;
    assign o_icb_cmd_read      = i_bus_icb_cmd_read ;
    assign o_icb_cmd_addr      = i_bus_icb_cmd_addr ;
    assign o_icb_cmd_wdata     = i_bus_icb_cmd_wdata;
    assign o_icb_cmd_wmask     = i_bus_icb_cmd_wmask;
    assign o_icb_cmd_burst     = i_bus_icb_cmd_burst;
    assign o_icb_cmd_beat      = i_bus_icb_cmd_beat ;
    assign o_icb_cmd_lock      = i_bus_icb_cmd_lock ;
    assign o_icb_cmd_excl      = i_bus_icb_cmd_excl ;
    assign o_icb_cmd_size      = i_bus_icb_cmd_size ;
    assign o_icb_cmd_usr       = i_bus_icb_cmd_usr  ;
                               
    assign o_icb_rsp_ready     = i_bus_icb_rsp_ready;
    assign i_bus_icb_rsp_valid = o_icb_rsp_valid    ;
    assign i_bus_icb_rsp_err   = o_icb_rsp_err      ;
    assign i_bus_icb_rsp_excl_ok   = o_icb_rsp_excl_ok      ;
    assign i_bus_icb_rsp_rdata = o_icb_rsp_rdata    ;
    assign i_bus_icb_rsp_usr   = o_icb_rsp_usr      ;

  end//}
  else begin:arbt_num_gt_1_gen//{

    assign o_icb_cmd_valid = o_icb_cmd_valid_real & (~rspid_fifo_full);
    assign o_icb_cmd_ready_real = o_icb_cmd_ready & (~rspid_fifo_full); 
    // Distract the icb from the bus declared ports

    for(i = 0; i < ARBT_NUM; i = i+1)//{
    begin:icb_distract_gen
      assign i_icb_cmd_read [i] = i_bus_icb_cmd_read [(i+1)*1     -1 : i*1     ];
      assign i_icb_cmd_addr [i] = i_bus_icb_cmd_addr [(i+1)*AW    -1 : i*AW    ];
      assign i_icb_cmd_wdata[i] = i_bus_icb_cmd_wdata[(i+1)*DW    -1 : i*DW    ];
      assign i_icb_cmd_wmask[i] = i_bus_icb_cmd_wmask[(i+1)*(DW/8)-1 : i*(DW/8)];
      assign i_icb_cmd_burst[i] = i_bus_icb_cmd_burst[(i+1)*2     -1 : i*2     ];
      assign i_icb_cmd_beat [i] = i_bus_icb_cmd_beat [(i+1)*2     -1 : i*2     ];
      assign i_icb_cmd_lock [i] = i_bus_icb_cmd_lock [(i+1)*1     -1 : i*1     ];
      assign i_icb_cmd_excl [i] = i_bus_icb_cmd_excl [(i+1)*1     -1 : i*1     ];
      assign i_icb_cmd_size [i] = i_bus_icb_cmd_size [(i+1)*2     -1 : i*2     ];
      assign i_icb_cmd_usr  [i] = i_bus_icb_cmd_usr  [(i+1)*USR_W -1 : i*USR_W ];

      assign i_bus_icb_cmd_ready[i] = i_bus_icb_cmd_grt_vec[i] & o_icb_cmd_ready_real;
      assign i_bus_icb_rsp_valid[i] = o_icb_rsp_valid_pre & (o_icb_rsp_port_id == i); 
    end//}

    if(ARBT_SCHEME == 0) begin:priorty_arbt//{
      wire arbt_ena = 1'b0;//No use
      for(i = 0; i < ARBT_NUM; i = i+1)//{
      begin:priroty_grt_vec_gen
        if(i==0) begin: i_is_0
          assign i_bus_icb_cmd_grt_vec[i] =  1'b1;
        end
        else begin:i_is_not_0
          assign i_bus_icb_cmd_grt_vec[i] =  ~(|i_bus_icb_cmd_valid[i-1:0]);
        end
        assign i_bus_icb_cmd_sel[i] = i_bus_icb_cmd_grt_vec[i] & i_bus_icb_cmd_valid[i];
      end//}
    end//}
    
    if(ARBT_SCHEME == 1) begin:rrobin_arbt//{
      assign arbt_ena = o_icb_cmd_valid & o_icb_cmd_ready; 
      sirv_gnrl_rrobin # (
          .ARBT_NUM(ARBT_NUM)
      )u_sirv_gnrl_rrobin(
        .grt_vec  (i_bus_icb_cmd_grt_vec),  
        .req_vec  (i_bus_icb_cmd_valid),  
        .arbt_ena (arbt_ena),   
        .clk      (clk),
        .rst_n    (rst_n)
      );
      assign i_bus_icb_cmd_sel = i_bus_icb_cmd_grt_vec;
    end//}


    always @ (*) begin : sel_o_apb_cmd_ready_PROC
      sel_o_icb_cmd_read  = {1   {1'b0}};
      sel_o_icb_cmd_addr  = {AW  {1'b0}};
      sel_o_icb_cmd_wdata = {DW  {1'b0}};
      sel_o_icb_cmd_wmask = {DW/8{1'b0}};
      sel_o_icb_cmd_burst = {2   {1'b0}};
      sel_o_icb_cmd_beat  = {2   {1'b0}};
      sel_o_icb_cmd_lock  = {1   {1'b0}};
      sel_o_icb_cmd_excl  = {1   {1'b0}};
      sel_o_icb_cmd_size  = {2   {1'b0}};
      sel_o_icb_cmd_usr   = {USR_W{1'b0}};
      for(j = 0; j < ARBT_NUM; j = j+1) begin//{
        sel_o_icb_cmd_read  = sel_o_icb_cmd_read  | ({1    {i_bus_icb_cmd_sel[j]}} & i_icb_cmd_read [j]);
        sel_o_icb_cmd_addr  = sel_o_icb_cmd_addr  | ({AW   {i_bus_icb_cmd_sel[j]}} & i_icb_cmd_addr [j]);
        sel_o_icb_cmd_wdata = sel_o_icb_cmd_wdata | ({DW   {i_bus_icb_cmd_sel[j]}} & i_icb_cmd_wdata[j]);
        sel_o_icb_cmd_wmask = sel_o_icb_cmd_wmask | ({DW/8 {i_bus_icb_cmd_sel[j]}} & i_icb_cmd_wmask[j]);
        sel_o_icb_cmd_burst = sel_o_icb_cmd_burst | ({2    {i_bus_icb_cmd_sel[j]}} & i_icb_cmd_burst[j]);
        sel_o_icb_cmd_beat  = sel_o_icb_cmd_beat  | ({2    {i_bus_icb_cmd_sel[j]}} & i_icb_cmd_beat [j]);
        sel_o_icb_cmd_lock  = sel_o_icb_cmd_lock  | ({1    {i_bus_icb_cmd_sel[j]}} & i_icb_cmd_lock [j]);
        sel_o_icb_cmd_excl  = sel_o_icb_cmd_excl  | ({1    {i_bus_icb_cmd_sel[j]}} & i_icb_cmd_excl [j]);
        sel_o_icb_cmd_size  = sel_o_icb_cmd_size  | ({2    {i_bus_icb_cmd_sel[j]}} & i_icb_cmd_size [j]);
        sel_o_icb_cmd_usr   = sel_o_icb_cmd_usr   | ({USR_W{i_bus_icb_cmd_sel[j]}} & i_icb_cmd_usr  [j]);
      end//}
    end
    assign o_icb_cmd_valid_real = |i_bus_icb_cmd_valid; 

    always @ (*) begin : i_arbt_indic_id_PROC
      i_arbt_indic_id = {ARBT_PTR_W{1'b0}};
      for(j = 0; j < ARBT_NUM; j = j+1) begin//{
        i_arbt_indic_id = i_arbt_indic_id | {ARBT_PTR_W{i_bus_icb_cmd_sel[j]}} & $unsigned(j);
      end//}
    end

    assign rspid_fifo_wen = o_icb_cmd_valid & o_icb_cmd_ready;
    assign rspid_fifo_ren = o_icb_rsp_valid & o_icb_rsp_ready;

    
    if(ALLOW_0CYCL_RSP == 1) begin: allow_0rsp
        assign rspid_fifo_bypass = rspid_fifo_empty & rspid_fifo_wen & rspid_fifo_ren;
        assign o_icb_rsp_port_id = rspid_fifo_empty ? rspid_fifo_wdat : rspid_fifo_rdat;
        // We dont need this empty qualifications because we allow the 0 cyle response
        assign o_icb_rsp_valid_pre = o_icb_rsp_valid;
        assign o_icb_rsp_ready     = o_icb_rsp_ready_pre;
    end
    else begin: no_allow_0rsp
        assign rspid_fifo_bypass   = 1'b0;
        assign o_icb_rsp_port_id   = rspid_fifo_empty ? {ARBT_PTR_W{1'b0}} : rspid_fifo_rdat;
        assign o_icb_rsp_valid_pre = (~rspid_fifo_empty) & o_icb_rsp_valid;
        assign o_icb_rsp_ready     = (~rspid_fifo_empty) & o_icb_rsp_ready_pre;
    end

    assign rspid_fifo_i_valid = rspid_fifo_wen & (~rspid_fifo_bypass);
    assign rspid_fifo_full    = (~rspid_fifo_i_ready);
    assign rspid_fifo_o_ready = rspid_fifo_ren & (~rspid_fifo_bypass);
    assign rspid_fifo_empty   = (~rspid_fifo_o_valid);

    assign rspid_fifo_wdat   = i_arbt_indic_id;
 
    if(FIFO_OUTS_NUM == 1) begin:dp_1//{
      sirv_gnrl_pipe_stage # (
        .CUT_READY (FIFO_CUT_READY),
        .DP  (1),
        .DW  (ARBT_PTR_W)
      ) u_sirv_gnrl_rspid_fifo (
        .i_vld(rspid_fifo_i_valid),
        .i_rdy(rspid_fifo_i_ready),
        .i_dat(rspid_fifo_wdat ),
        .o_vld(rspid_fifo_o_valid),
        .o_rdy(rspid_fifo_o_ready),  
        .o_dat(rspid_fifo_rdat ),  
        .clk  (clk),
        .rst_n(rst_n)
      );

    end//}
    else begin: dp_gt1//{
      sirv_gnrl_fifo # (
        .CUT_READY (FIFO_CUT_READY),
        .MSKO      (0),
        .DP  (FIFO_OUTS_NUM),
        .DW  (ARBT_PTR_W)
      ) u_sirv_gnrl_rspid_fifo (
        .i_vld(rspid_fifo_i_valid),
        .i_rdy(rspid_fifo_i_ready),
        .i_dat(rspid_fifo_wdat ),
        .o_vld(rspid_fifo_o_valid),
        .o_rdy(rspid_fifo_o_ready),  
        .o_dat(rspid_fifo_rdat ),  
      
        .clk  (clk),
        .rst_n(rst_n)
      );
    end//}

    assign o_icb_cmd_read  = sel_o_icb_cmd_read ; 
    assign o_icb_cmd_addr  = sel_o_icb_cmd_addr ; 
    assign o_icb_cmd_wdata = sel_o_icb_cmd_wdata; 
    assign o_icb_cmd_wmask = sel_o_icb_cmd_wmask;
    assign o_icb_cmd_burst = sel_o_icb_cmd_burst;
    assign o_icb_cmd_beat  = sel_o_icb_cmd_beat ;
    assign o_icb_cmd_lock  = sel_o_icb_cmd_lock ;
    assign o_icb_cmd_excl  = sel_o_icb_cmd_excl ;
    assign o_icb_cmd_size  = sel_o_icb_cmd_size ;
    assign o_icb_cmd_usr   = sel_o_icb_cmd_usr  ;

    assign o_icb_rsp_ready_pre = i_bus_icb_rsp_ready[o_icb_rsp_port_id]; 



    assign i_bus_icb_rsp_err     = {ARBT_NUM{o_icb_rsp_err  }};  
    assign i_bus_icb_rsp_excl_ok = {ARBT_NUM{o_icb_rsp_excl_ok}};  
    assign i_bus_icb_rsp_rdata   = {ARBT_NUM{o_icb_rsp_rdata}}; 
    assign i_bus_icb_rsp_usr     = {ARBT_NUM{o_icb_rsp_usr}}; 
  end//}
  endgenerate //}

endmodule

// ===========================================================================
//
// Description:
//  The module to handle the ICB bus buffer stages
//
// ===========================================================================

module sirv_gnrl_icb_buffer # (
  parameter OUTS_CNT_W = 1,
  parameter AW = 32,
  parameter DW = 32,
  parameter CMD_CUT_READY = 0,
  parameter RSP_CUT_READY = 0,
  parameter CMD_DP = 0,
  parameter RSP_DP = 0,
  parameter USR_W = 1
) (
  output             icb_buffer_active,

  input              i_icb_cmd_valid, 
  output             i_icb_cmd_ready, 
  input  [1-1:0]     i_icb_cmd_read, 
  input  [AW-1:0]    i_icb_cmd_addr, 
  input  [DW-1:0]    i_icb_cmd_wdata, 
  input  [DW/8-1:0]  i_icb_cmd_wmask,
  input              i_icb_cmd_lock,
  input              i_icb_cmd_excl,
  input  [1:0]       i_icb_cmd_size,
  input  [1:0]       i_icb_cmd_burst,
  input  [1:0]       i_icb_cmd_beat,
  input  [USR_W-1:0] i_icb_cmd_usr,

  output             i_icb_rsp_valid, 
  input              i_icb_rsp_ready, 
  output             i_icb_rsp_err,
  output             i_icb_rsp_excl_ok,
  output [DW-1:0]    i_icb_rsp_rdata, 
  output [USR_W-1:0] i_icb_rsp_usr,
  
  output             o_icb_cmd_valid, 
  input              o_icb_cmd_ready, 
  output [1-1:0]     o_icb_cmd_read, 
  output [AW-1:0]    o_icb_cmd_addr, 
  output [DW-1:0]    o_icb_cmd_wdata, 
  output [DW/8-1:0]  o_icb_cmd_wmask,
  output             o_icb_cmd_lock,
  output             o_icb_cmd_excl,
  output [1:0]       o_icb_cmd_size,
  output [1:0]       o_icb_cmd_burst,
  output [1:0]       o_icb_cmd_beat,
  output [USR_W-1:0] o_icb_cmd_usr,

  input              o_icb_rsp_valid, 
  output             o_icb_rsp_ready, 
  input              o_icb_rsp_err,
  input              o_icb_rsp_excl_ok,
  input  [DW-1:0]    o_icb_rsp_rdata, 
  input  [USR_W-1:0] o_icb_rsp_usr,

  input  clk,  
  input  rst_n
  );

  localparam CMD_PACK_W = (1+AW+DW+(DW/8)+1+1+2+2+2+USR_W);

  wire [CMD_PACK_W-1:0] cmd_fifo_i_dat = {
                                 i_icb_cmd_read, 
                                 i_icb_cmd_addr, 
                                 i_icb_cmd_wdata, 
                                 i_icb_cmd_wmask,
                                 i_icb_cmd_lock,
                                 i_icb_cmd_excl,
                                 i_icb_cmd_size,
                                 i_icb_cmd_burst,
                                 i_icb_cmd_beat,
                                 i_icb_cmd_usr};

  wire [CMD_PACK_W-1:0] cmd_fifo_o_dat;

  assign {
                                 o_icb_cmd_read, 
                                 o_icb_cmd_addr, 
                                 o_icb_cmd_wdata, 
                                 o_icb_cmd_wmask,
                                 o_icb_cmd_lock,
                                 o_icb_cmd_excl,
                                 o_icb_cmd_size,
                                 o_icb_cmd_burst,
                                 o_icb_cmd_beat,
                                 o_icb_cmd_usr} = cmd_fifo_o_dat;
  sirv_gnrl_fifo # (
    .CUT_READY (CMD_CUT_READY),
    .MSKO      (0),
    .DP  (CMD_DP),
    .DW  (CMD_PACK_W)
  ) u_sirv_gnrl_cmd_fifo (
    .i_vld(i_icb_cmd_valid),
    .i_rdy(i_icb_cmd_ready),
    .i_dat(cmd_fifo_i_dat ),
    .o_vld(o_icb_cmd_valid),
    .o_rdy(o_icb_cmd_ready),  
    .o_dat(cmd_fifo_o_dat ),  
  
    .clk  (clk),
    .rst_n(rst_n)
  );


  localparam RSP_PACK_W = (2+DW+USR_W);
  wire [RSP_PACK_W-1:0] rsp_fifo_i_dat = {
                                 o_icb_rsp_err,
                                 o_icb_rsp_excl_ok,
                                 o_icb_rsp_rdata, 
                                 o_icb_rsp_usr};

  wire [RSP_PACK_W-1:0] rsp_fifo_o_dat;

  assign {
                                 i_icb_rsp_err,
                                 i_icb_rsp_excl_ok,
                                 i_icb_rsp_rdata, 
                                 i_icb_rsp_usr} = rsp_fifo_o_dat;
  sirv_gnrl_fifo # (
    .CUT_READY (RSP_CUT_READY),
    .MSKO      (0),
    .DP  (RSP_DP),
    .DW  (RSP_PACK_W)
  ) u_sirv_gnrl_rsp_fifo (
    .i_vld(o_icb_rsp_valid),
    .i_rdy(o_icb_rsp_ready),
    .i_dat(rsp_fifo_i_dat ),
    .o_vld(i_icb_rsp_valid),
    .o_rdy(i_icb_rsp_ready),  
    .o_dat(rsp_fifo_o_dat ),  
  
    .clk  (clk),
    .rst_n(rst_n)
  );

  wire outs_cnt_inc = i_icb_cmd_valid & i_icb_cmd_ready;
  wire outs_cnt_dec = i_icb_rsp_valid & i_icb_rsp_ready;
     // If meanwhile no or have set and clear, then no changes
  wire outs_cnt_ena = outs_cnt_inc ^ outs_cnt_dec;
     // If only inc or only dec
  wire outs_cnt_r;
  wire outs_cnt_nxt = outs_cnt_inc ? (outs_cnt_r + 1'b1) : (outs_cnt_r - 1'b1);
  sirv_gnrl_dfflr #(OUTS_CNT_W) outs_cnt_dfflr (outs_cnt_ena, outs_cnt_nxt, outs_cnt_r, clk, rst_n);

  assign icb_buffer_active = i_icb_cmd_valid | (~(outs_cnt_r == {OUTS_CNT_W{1'b0}}));

endmodule

// ===========================================================================
//
// Description:
//  The module to handle the ICB bus width conversion from 32bits to 64bits
//
// ===========================================================================

module sirv_gnrl_icb_n2w # (
  parameter AW = 32,
  parameter USR_W = 1,
  parameter FIFO_OUTS_NUM = 8,
  parameter FIFO_CUT_READY = 0,
  parameter X_W = 32,
  parameter Y_W = 64
) (
  input              i_icb_cmd_valid, 
  output             i_icb_cmd_ready, 
  input  [1-1:0]     i_icb_cmd_read, 
  input  [AW-1:0]    i_icb_cmd_addr, 
  input  [X_W-1:0]   i_icb_cmd_wdata, 
  input  [X_W/8-1:0] i_icb_cmd_wmask,
  input              i_icb_cmd_lock,
  input              i_icb_cmd_excl,
  input  [1:0]       i_icb_cmd_size,
  input  [1:0]       i_icb_cmd_burst,
  input  [1:0]       i_icb_cmd_beat,
  input  [USR_W-1:0] i_icb_cmd_usr,

  output             i_icb_rsp_valid, 
  input              i_icb_rsp_ready, 
  output             i_icb_rsp_err,
  output             i_icb_rsp_excl_ok,
  output [X_W-1:0]   i_icb_rsp_rdata, 
  output [USR_W-1:0] i_icb_rsp_usr,
  
  output             o_icb_cmd_valid, 
  input              o_icb_cmd_ready, 
  output [1-1:0]     o_icb_cmd_read, 
  output [AW-1:0]    o_icb_cmd_addr, 
  output [Y_W-1:0]   o_icb_cmd_wdata, 
  output [Y_W/8-1:0] o_icb_cmd_wmask,
  output             o_icb_cmd_lock,
  output             o_icb_cmd_excl,
  output [1:0]       o_icb_cmd_size,
  output [1:0]       o_icb_cmd_burst,
  output [1:0]       o_icb_cmd_beat,
  output [USR_W-1:0] o_icb_cmd_usr,

  input              o_icb_rsp_valid, 
  output             o_icb_rsp_ready, 
  input              o_icb_rsp_err,
  input              o_icb_rsp_excl_ok,
  input  [Y_W-1:0]   o_icb_rsp_rdata, 
  input  [USR_W-1:0] o_icb_rsp_usr,

  input  clk,  
  input  rst_n
  );


    wire cmd_y_lo_hi;
    wire rsp_y_lo_hi;
        
    wire n2w_fifo_wen = i_icb_cmd_valid & i_icb_cmd_ready;
    wire n2w_fifo_ren = i_icb_rsp_valid & i_icb_rsp_ready;

    wire n2w_fifo_i_ready;
    wire n2w_fifo_i_valid = n2w_fifo_wen;
    wire n2w_fifo_full    = (~n2w_fifo_i_ready);
    wire n2w_fifo_o_valid ;
    wire n2w_fifo_o_ready = n2w_fifo_ren;
    wire n2w_fifo_empty   = (~n2w_fifo_o_valid);

  generate
    if(FIFO_OUTS_NUM == 1) begin:fifo_dp_1//{
      sirv_gnrl_pipe_stage # (
        .CUT_READY (FIFO_CUT_READY),
        .DP  (1),
        .DW  (1)
      ) u_sirv_gnrl_n2w_fifo (
        .i_vld(n2w_fifo_i_valid),
        .i_rdy(n2w_fifo_i_ready),
        .i_dat(cmd_y_lo_hi ),
        .o_vld(n2w_fifo_o_valid),
        .o_rdy(n2w_fifo_o_ready),  
        .o_dat(rsp_y_lo_hi ),  
      
        .clk  (clk),
        .rst_n(rst_n)
      );

    end//}
    else begin: fifo_dp_gt_1//{
      sirv_gnrl_fifo # (
        .CUT_READY (FIFO_CUT_READY),
        .MSKO      (0),
        .DP  (FIFO_OUTS_NUM),
        .DW  (1)
      ) u_sirv_gnrl_n2w_fifo (
        .i_vld(n2w_fifo_i_valid),
        .i_rdy(n2w_fifo_i_ready),
        .i_dat(cmd_y_lo_hi ),
        .o_vld(n2w_fifo_o_valid),
        .o_rdy(n2w_fifo_o_ready),  
        .o_dat(rsp_y_lo_hi ),  
      
        .clk  (clk),
        .rst_n(rst_n)
      );
    end//}
  endgenerate



  generate
    if(X_W == 32) begin: x_w_32//{
      if(Y_W == 64) begin: y_w_64//{
        assign cmd_y_lo_hi = i_icb_cmd_addr[2]; 
      end//}
    end//}
  endgenerate

  assign o_icb_cmd_valid = (~n2w_fifo_full) & i_icb_cmd_valid; 
  assign i_icb_cmd_ready = (~n2w_fifo_full) & o_icb_cmd_ready; 
  assign o_icb_cmd_read  = i_icb_cmd_read ;
  assign o_icb_cmd_addr  = i_icb_cmd_addr ;
  assign o_icb_cmd_lock  = i_icb_cmd_lock ;
  assign o_icb_cmd_excl  = i_icb_cmd_excl ;
  assign o_icb_cmd_size  = i_icb_cmd_size ;
  assign o_icb_cmd_burst = i_icb_cmd_burst;
  assign o_icb_cmd_beat  = i_icb_cmd_beat ;
  assign o_icb_cmd_usr   = i_icb_cmd_usr  ;

  assign o_icb_cmd_wdata = {i_icb_cmd_wdata,i_icb_cmd_wdata};
  assign o_icb_cmd_wmask = cmd_y_lo_hi ?  {i_icb_cmd_wmask,  {X_W/8{1'b0}}} : {  {X_W/8{1'b0}},i_icb_cmd_wmask};

  assign i_icb_rsp_valid = o_icb_rsp_valid ;
  assign i_icb_rsp_err   = o_icb_rsp_err   ;
  assign i_icb_rsp_excl_ok   = o_icb_rsp_excl_ok   ;
  assign i_icb_rsp_rdata = rsp_y_lo_hi ?  o_icb_rsp_rdata[Y_W-1:X_W] : o_icb_rsp_rdata[X_W-1:0] ;
  assign i_icb_rsp_usr   = o_icb_rsp_usr   ;
  assign o_icb_rsp_ready = i_icb_rsp_ready;  

endmodule

// ===========================================================================
//
// Description:
//  The module to handle the ICB bus de-mux
//
// ===========================================================================

module sirv_gnrl_icb_splt # (
  parameter AW = 32,
  parameter DW = 64,
  // The number of outstanding supported
  parameter FIFO_OUTS_NUM = 8,
  parameter FIFO_CUT_READY = 0,
  // SPLT_NUM=4 ports, so 2 bits for port id
  parameter SPLT_NUM = 4,
  parameter SPLT_PTR_1HOT = 0,
  parameter SPLT_PTR_W = 2,
  parameter ALLOW_DIFF = 1,
  parameter ALLOW_0CYCL_RSP = 1,
  parameter USR_W = 1 
) (
  input  [SPLT_NUM-1:0] i_icb_splt_indic,        

  input  i_icb_cmd_valid, 
  output i_icb_cmd_ready, 
  input  [1-1:0]    i_icb_cmd_read, 
  input  [AW-1:0]   i_icb_cmd_addr, 
  input  [DW-1:0]   i_icb_cmd_wdata, 
  input  [DW/8-1:0] i_icb_cmd_wmask,
  input  [1:0]      i_icb_cmd_burst,
  input  [1:0]      i_icb_cmd_beat,
  input             i_icb_cmd_lock,
  input             i_icb_cmd_excl,
  input  [1:0]      i_icb_cmd_size,
  input  [USR_W-1:0]i_icb_cmd_usr,

  output i_icb_rsp_valid, 
  input  i_icb_rsp_ready, 
  output i_icb_rsp_err,
  output i_icb_rsp_excl_ok,
  output [DW-1:0] i_icb_rsp_rdata, 
  output [USR_W-1:0] i_icb_rsp_usr, 
  
  input  [SPLT_NUM*1-1:0]    o_bus_icb_cmd_ready, 
  output [SPLT_NUM*1-1:0]    o_bus_icb_cmd_valid, 
  output [SPLT_NUM*1-1:0]    o_bus_icb_cmd_read, 
  output [SPLT_NUM*AW-1:0]   o_bus_icb_cmd_addr, 
  output [SPLT_NUM*DW-1:0]   o_bus_icb_cmd_wdata, 
  output [SPLT_NUM*DW/8-1:0] o_bus_icb_cmd_wmask,
  output [SPLT_NUM*2-1:0]    o_bus_icb_cmd_burst,
  output [SPLT_NUM*2-1:0]    o_bus_icb_cmd_beat,
  output [SPLT_NUM*1-1:0]    o_bus_icb_cmd_lock,
  output [SPLT_NUM*1-1:0]    o_bus_icb_cmd_excl,
  output [SPLT_NUM*2-1:0]    o_bus_icb_cmd_size,
  output [SPLT_NUM*USR_W-1:0]o_bus_icb_cmd_usr,

  input  [SPLT_NUM*1-1:0]  o_bus_icb_rsp_valid, 
  output [SPLT_NUM*1-1:0]  o_bus_icb_rsp_ready, 
  input  [SPLT_NUM*1-1:0]  o_bus_icb_rsp_err,
  input  [SPLT_NUM*1-1:0]  o_bus_icb_rsp_excl_ok,
  input  [SPLT_NUM*DW-1:0] o_bus_icb_rsp_rdata, 
  input  [SPLT_NUM*USR_W-1:0] o_bus_icb_rsp_usr, 

  input  clk,  
  input  rst_n
  );


integer j;

wire [SPLT_NUM-1:0] o_icb_cmd_valid; 
wire [SPLT_NUM-1:0] o_icb_cmd_ready; 

wire [1-1:0]    o_icb_cmd_read [SPLT_NUM-1:0]; 
wire [AW-1:0]   o_icb_cmd_addr [SPLT_NUM-1:0]; 
wire [DW-1:0]   o_icb_cmd_wdata[SPLT_NUM-1:0]; 
wire [DW/8-1:0] o_icb_cmd_wmask[SPLT_NUM-1:0];
wire [1:0]      o_icb_cmd_burst[SPLT_NUM-1:0];
wire [1:0]      o_icb_cmd_beat [SPLT_NUM-1:0];
wire            o_icb_cmd_lock [SPLT_NUM-1:0];
wire            o_icb_cmd_excl [SPLT_NUM-1:0];
wire [1:0]      o_icb_cmd_size [SPLT_NUM-1:0];
wire [USR_W-1:0]o_icb_cmd_usr  [SPLT_NUM-1:0];

wire [SPLT_NUM-1:0] o_icb_rsp_valid; 
wire [SPLT_NUM-1:0] o_icb_rsp_ready; 
wire [SPLT_NUM-1:0] o_icb_rsp_err  ;
wire [SPLT_NUM-1:0] o_icb_rsp_excl_ok  ;
wire [DW-1:0] o_icb_rsp_rdata  [SPLT_NUM-1:0];
wire [USR_W-1:0] o_icb_rsp_usr [SPLT_NUM-1:0];

reg sel_o_apb_cmd_ready;

wire rspid_fifo_bypass;
wire rspid_fifo_wen;
wire rspid_fifo_ren;

wire [SPLT_PTR_W-1:0] o_icb_rsp_port_id;

wire rspid_fifo_i_valid;
wire rspid_fifo_o_valid;
wire rspid_fifo_i_ready;
wire rspid_fifo_o_ready;
wire [SPLT_PTR_W-1:0] rspid_fifo_rdat;
wire [SPLT_PTR_W-1:0] rspid_fifo_wdat;

wire rspid_fifo_full;       
wire rspid_fifo_empty;       
reg [SPLT_PTR_W-1:0] i_splt_indic_id;

wire i_icb_cmd_ready_pre;
wire i_icb_cmd_valid_pre;
    
wire i_icb_rsp_ready_pre; 
wire i_icb_rsp_valid_pre;


genvar i;
generate //{
  if(SPLT_NUM == 1) begin:splt_num_eq_1_gen// {
    assign i_icb_cmd_ready     = o_bus_icb_cmd_ready; 
    assign o_bus_icb_cmd_valid = i_icb_cmd_valid; 
    assign o_bus_icb_cmd_read  = i_icb_cmd_read ; 
    assign o_bus_icb_cmd_addr  = i_icb_cmd_addr ; 
    assign o_bus_icb_cmd_wdata = i_icb_cmd_wdata; 
    assign o_bus_icb_cmd_wmask = i_icb_cmd_wmask;
    assign o_bus_icb_cmd_burst = i_icb_cmd_burst;
    assign o_bus_icb_cmd_beat  = i_icb_cmd_beat ;
    assign o_bus_icb_cmd_lock  = i_icb_cmd_lock ;
    assign o_bus_icb_cmd_excl  = i_icb_cmd_excl ;
    assign o_bus_icb_cmd_size  = i_icb_cmd_size ;
    assign o_bus_icb_cmd_usr   = i_icb_cmd_usr  ;

    assign o_bus_icb_rsp_ready = i_icb_rsp_ready; 
    assign i_icb_rsp_valid     = o_bus_icb_rsp_valid; 
    assign i_icb_rsp_err       = o_bus_icb_rsp_err  ;
    assign i_icb_rsp_excl_ok   = o_bus_icb_rsp_excl_ok  ;
    assign i_icb_rsp_rdata     = o_bus_icb_rsp_rdata;
    assign i_icb_rsp_usr       = o_bus_icb_rsp_usr;

  end//}
  else begin:splt_num_gt_1_gen//{

    for(i = 0; i < SPLT_NUM; i = i+1)//{
    begin:icb_distract_gen
      assign o_icb_cmd_ready[i]                             = o_bus_icb_cmd_ready[(i+1)*1     -1 : (i)*1     ]; 
      assign o_bus_icb_cmd_valid[(i+1)*1     -1 : i*1     ] = o_icb_cmd_valid[i];
      assign o_bus_icb_cmd_read [(i+1)*1     -1 : i*1     ] = o_icb_cmd_read [i];
      assign o_bus_icb_cmd_addr [(i+1)*AW    -1 : i*AW    ] = o_icb_cmd_addr [i];
      assign o_bus_icb_cmd_wdata[(i+1)*DW    -1 : i*DW    ] = o_icb_cmd_wdata[i];
      assign o_bus_icb_cmd_wmask[(i+1)*(DW/8)-1 : i*(DW/8)] = o_icb_cmd_wmask[i];
      assign o_bus_icb_cmd_burst[(i+1)*2     -1 : i*2     ] = o_icb_cmd_burst[i];
      assign o_bus_icb_cmd_beat [(i+1)*2     -1 : i*2     ] = o_icb_cmd_beat [i];
      assign o_bus_icb_cmd_lock [(i+1)*1     -1 : i*1     ] = o_icb_cmd_lock [i];
      assign o_bus_icb_cmd_excl [(i+1)*1     -1 : i*1     ] = o_icb_cmd_excl [i];
      assign o_bus_icb_cmd_size [(i+1)*2     -1 : i*2     ] = o_icb_cmd_size [i];
      assign o_bus_icb_cmd_usr  [(i+1)*USR_W -1 : i*USR_W ] = o_icb_cmd_usr  [i];

      assign o_bus_icb_rsp_ready[(i+1)*1-1 :i*1 ] = o_icb_rsp_ready[i]; 
      assign o_icb_rsp_valid[i]                   = o_bus_icb_rsp_valid[(i+1)*1-1 :i*1 ]; 
      assign o_icb_rsp_err  [i]                   = o_bus_icb_rsp_err  [(i+1)*1-1 :i*1 ];
      assign o_icb_rsp_excl_ok  [i]               = o_bus_icb_rsp_excl_ok  [(i+1)*1-1 :i*1 ];
      assign o_icb_rsp_rdata[i]                   = o_bus_icb_rsp_rdata[(i+1)*DW-1:i*DW];
      assign o_icb_rsp_usr  [i]                   = o_bus_icb_rsp_usr  [(i+1)*USR_W-1:i*USR_W];
    end//}

    ///////////////////////
    // Input ICB will be accepted when
    // (*) The targeted icb have "ready" asserted
    // (*) The FIFO is not full
    
    always @ (*) begin : sel_o_apb_cmd_ready_PROC
      sel_o_apb_cmd_ready = 1'b0;
      for(j = 0; j < SPLT_NUM; j = j+1) begin//{
        sel_o_apb_cmd_ready = sel_o_apb_cmd_ready | (i_icb_splt_indic[j] & o_icb_cmd_ready[j]);
      end//}
    end

    assign i_icb_cmd_ready_pre = sel_o_apb_cmd_ready;

    if(ALLOW_DIFF == 1) begin:allow_diff// {
       assign i_icb_cmd_valid_pre = i_icb_cmd_valid     & (~rspid_fifo_full);
       assign i_icb_cmd_ready     = i_icb_cmd_ready_pre & (~rspid_fifo_full);
    end
    else begin:not_allow_diff
       // The next transaction can only be issued if there is no any outstanding 
       //   transactions to different targets
       wire cmd_diff_branch = (~rspid_fifo_empty) & (~(rspid_fifo_wdat == rspid_fifo_rdat));
       assign i_icb_cmd_valid_pre = i_icb_cmd_valid     & (~cmd_diff_branch) & (~rspid_fifo_full);
       assign i_icb_cmd_ready     = i_icb_cmd_ready_pre & (~cmd_diff_branch) & (~rspid_fifo_full);
    end
    
    if(SPLT_PTR_1HOT == 1) begin:ptr_1hot// {
       always @ (*) begin : i_splt_indic_id_PROC
         i_splt_indic_id = i_icb_splt_indic;
       end
    end
    else begin:ptr_not_1hot//}{
       always @ (*) begin : i_splt_indic_id_PROC
         i_splt_indic_id = {SPLT_PTR_W{1'b0}};
         for(j = 0; j < SPLT_NUM; j = j+1) begin//{
           i_splt_indic_id = i_splt_indic_id | ({SPLT_PTR_W{i_icb_splt_indic[j]}} & $unsigned(j));
         end//}
       end
    end//}
        
    assign rspid_fifo_wen = i_icb_cmd_valid & i_icb_cmd_ready;
    assign rspid_fifo_ren = i_icb_rsp_valid & i_icb_rsp_ready;

    if(ALLOW_0CYCL_RSP == 1) begin: allow_0rsp
        assign rspid_fifo_bypass = rspid_fifo_empty & rspid_fifo_wen & rspid_fifo_ren;
        assign o_icb_rsp_port_id = rspid_fifo_empty ? rspid_fifo_wdat : rspid_fifo_rdat;
        // We dont need this empty qualifications because we allow the 0 cyle response
        assign i_icb_rsp_valid     = i_icb_rsp_valid_pre;
        assign i_icb_rsp_ready_pre = i_icb_rsp_ready;
    end
    else begin: no_allow_0rsp
        assign rspid_fifo_bypass = 1'b0;
        assign o_icb_rsp_port_id = rspid_fifo_empty ? {SPLT_PTR_W{1'b0}} : rspid_fifo_rdat;
        assign i_icb_rsp_valid     = (~rspid_fifo_empty) & i_icb_rsp_valid_pre;
        assign i_icb_rsp_ready_pre = (~rspid_fifo_empty) & i_icb_rsp_ready;
    end

    assign rspid_fifo_i_valid = rspid_fifo_wen & (~rspid_fifo_bypass);
    assign rspid_fifo_full    = (~rspid_fifo_i_ready);
    assign rspid_fifo_o_ready = rspid_fifo_ren & (~rspid_fifo_bypass);
    assign rspid_fifo_empty   = (~rspid_fifo_o_valid);

    assign rspid_fifo_wdat   = i_splt_indic_id;
 
    if(FIFO_OUTS_NUM == 1) begin:fifo_dp_1//{
      sirv_gnrl_pipe_stage # (
        .CUT_READY (FIFO_CUT_READY),
        .DP  (1),
        .DW  (SPLT_PTR_W)
      ) u_sirv_gnrl_rspid_fifo (
        .i_vld(rspid_fifo_i_valid),
        .i_rdy(rspid_fifo_i_ready),
        .i_dat(rspid_fifo_wdat ),
        .o_vld(rspid_fifo_o_valid),
        .o_rdy(rspid_fifo_o_ready),  
        .o_dat(rspid_fifo_rdat ),  
      
        .clk  (clk),
        .rst_n(rst_n)
      );

    end//}
    else begin: fifo_dp_gt_1//{
      sirv_gnrl_fifo # (
        .CUT_READY (FIFO_CUT_READY),
        .MSKO      (0),
        .DP  (FIFO_OUTS_NUM),
        .DW  (SPLT_PTR_W)
      ) u_sirv_gnrl_rspid_fifo (
        .i_vld(rspid_fifo_i_valid),
        .i_rdy(rspid_fifo_i_ready),
        .i_dat(rspid_fifo_wdat ),
        .o_vld(rspid_fifo_o_valid),
        .o_rdy(rspid_fifo_o_ready),  
        .o_dat(rspid_fifo_rdat ),  
      
        .clk  (clk),
        .rst_n(rst_n)
      );
    end//}

    ///////////////////////
    // 
    for(i = 0; i < SPLT_NUM; i = i+1)//{
    begin:o_icb_cmd_valid_gen
      assign o_icb_cmd_valid[i] = i_icb_splt_indic[i] & i_icb_cmd_valid_pre;         
      assign o_icb_cmd_read [i] = i_icb_cmd_read ;
      assign o_icb_cmd_addr [i] = i_icb_cmd_addr ;
      assign o_icb_cmd_wdata[i] = i_icb_cmd_wdata;
      assign o_icb_cmd_wmask[i] = i_icb_cmd_wmask;
      assign o_icb_cmd_burst[i] = i_icb_cmd_burst;
      assign o_icb_cmd_beat [i] = i_icb_cmd_beat ;
      assign o_icb_cmd_lock [i] = i_icb_cmd_lock ;
      assign o_icb_cmd_excl [i] = i_icb_cmd_excl ;
      assign o_icb_cmd_size [i] = i_icb_cmd_size ;
      assign o_icb_cmd_usr  [i] = i_icb_cmd_usr  ;
    end//}
    //
    
    ///////////////////////
    // 
    //
    if(SPLT_PTR_1HOT == 1) begin:ptr_1hot_rsp// {

        for(i = 0; i < SPLT_NUM; i = i+1)//{
        begin:o_icb_rsp_ready_gen
          assign o_icb_rsp_ready[i] = (o_icb_rsp_port_id[i] & i_icb_rsp_ready_pre);
        end//}
        //
        assign i_icb_rsp_valid_pre = |(o_icb_rsp_valid & o_icb_rsp_port_id);


        reg sel_i_icb_rsp_err;
        reg sel_i_icb_rsp_excl_ok;
        reg [DW-1:0] sel_i_icb_rsp_rdata; 
        reg [USR_W-1:0] sel_i_icb_rsp_usr; 

        always @ (*) begin : sel_icb_rsp_PROC
          sel_i_icb_rsp_err   = 1'b0;
          sel_i_icb_rsp_excl_ok   = 1'b0;
          sel_i_icb_rsp_rdata = {DW   {1'b0}};
          sel_i_icb_rsp_usr   = {USR_W{1'b0}};
          for(j = 0; j < SPLT_NUM; j = j+1) begin//{
            sel_i_icb_rsp_err     = sel_i_icb_rsp_err     | (       o_icb_rsp_port_id[j]   & o_icb_rsp_err[j]);
            sel_i_icb_rsp_excl_ok = sel_i_icb_rsp_excl_ok | (       o_icb_rsp_port_id[j]   & o_icb_rsp_excl_ok[j]);
            sel_i_icb_rsp_rdata   = sel_i_icb_rsp_rdata   | ({DW   {o_icb_rsp_port_id[j]}} & o_icb_rsp_rdata[j]);
            sel_i_icb_rsp_usr     = sel_i_icb_rsp_usr     | ({USR_W{o_icb_rsp_port_id[j]}} & o_icb_rsp_usr[j]);
          end//}
        end

        assign i_icb_rsp_err   = sel_i_icb_rsp_err  ;
        assign i_icb_rsp_excl_ok   = sel_i_icb_rsp_excl_ok  ;
        assign i_icb_rsp_rdata = sel_i_icb_rsp_rdata;
        assign i_icb_rsp_usr   = sel_i_icb_rsp_usr  ;

    end
    else begin:ptr_not_1hot_rsp//}{

        for(i = 0; i < SPLT_NUM; i = i+1)//{
        begin:o_icb_rsp_ready_gen
          assign o_icb_rsp_ready[i] = (o_icb_rsp_port_id == i) & i_icb_rsp_ready_pre;
        end//}
        //
        assign i_icb_rsp_valid_pre = o_icb_rsp_valid[o_icb_rsp_port_id]; 


        assign i_icb_rsp_err     = o_icb_rsp_err    [o_icb_rsp_port_id]; 
        assign i_icb_rsp_excl_ok = o_icb_rsp_excl_ok[o_icb_rsp_port_id]; 
        assign i_icb_rsp_rdata   = o_icb_rsp_rdata  [o_icb_rsp_port_id]; 
        assign i_icb_rsp_usr     = o_icb_rsp_usr    [o_icb_rsp_port_id]; 
    end//}
    
  end//}
  endgenerate //}

endmodule

