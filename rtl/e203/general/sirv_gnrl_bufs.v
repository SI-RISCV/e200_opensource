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
//  Some of the basic functions like pipeline stage and buffers
//
// ====================================================================

module sirv_gnrl_pipe_stage # (
  // When the depth is 1, the ready signal may relevant to next stage's ready, hence become logic
  // chains. Use CUT_READY to control it
  parameter CUT_READY = 0,
  parameter DP = 1,
  parameter DW = 32
) (
  input           i_vld, 
  output          i_rdy, 
  input  [DW-1:0] i_dat,
  output          o_vld, 
  input           o_rdy, 
  output [DW-1:0] o_dat,

  input           clk,
  input           rst_n
);

  genvar i;
  generate //{

  if(DP == 0) begin: dp_eq_0//{ pass through

      assign o_vld = i_vld;
      assign i_rdy = o_rdy;
      assign o_dat = i_dat;

  end//}
  else begin: dp_gt_0//{

      wire vld_set;
      wire vld_clr;
      wire vld_ena;
      wire vld_r;
      wire vld_nxt;

      // The valid will be set when input handshaked
      assign vld_set = i_vld & i_rdy;
      // The valid will be clr when output handshaked
      assign vld_clr = o_vld & o_rdy;

      assign vld_ena = vld_set | vld_clr;
      assign vld_nxt = vld_set | (~vld_clr);

      sirv_gnrl_dfflr #(1) vld_dfflr (vld_ena, vld_nxt, vld_r, clk, rst_n);

      assign o_vld = vld_r;

      sirv_gnrl_dffl #(DW) dat_dfflr (vld_set, i_dat, o_dat, clk);

      if(CUT_READY == 1) begin:cut_ready//{
          // If cut ready, then only accept when stage is not full
          assign i_rdy = (~vld_r);
      end//}
      else begin:no_cut_ready//{
          // If not cut ready, then can accept when stage is not full or it is popping 
          assign i_rdy = (~vld_r) | vld_clr;
      end//}
  end//}
  endgenerate//}


endmodule 

// ===========================================================================
//
// Description:
//  Syncer to sync async signal to synced as general module
//
// ===========================================================================

module sirv_gnrl_sync # (
  parameter DP = 2,
  parameter DW = 32
) (
  input  [DW-1:0] din_a,
  output [DW-1:0] dout,

  input           rst_n, 
  input           clk 
);

  wire [DW-1:0] sync_dat [DP-1:0];
    
  genvar i;

  generate 
    for(i=0;i<DP;i=i+1) begin:sync_gen
      if(i==0) begin:i_is_0
        sirv_gnrl_dffr #(DW) sync_dffr(din_a,         sync_dat[0], clk, rst_n);
      end
      else begin:i_is_not_0
        sirv_gnrl_dffr #(DW) sync_dffr(sync_dat[i-1], sync_dat[i], clk, rst_n);
      end
    end
  endgenerate

  assign dout = sync_dat[DP-1];
  
endmodule
// ===========================================================================
//
// Description:
//  Verilog module for round-robin arbitration
//
// ===========================================================================


// ====================================================================
// Description:
//  Verilog module sirv_gnrl cdc rx to receive the async handshake interface 
//
// ====================================================================
//
module sirv_gnrl_cdc_rx
# (
  parameter DW = 32,
  parameter SYNC_DP = 2
) (
  // The 4-phases handshake interface at in-side
  //     There are 4 steps required for a full transaction. 
  //         (1) The i_vld is asserted high 
  //         (2) The i_rdy is asserted high
  //         (3) The i_vld is asserted low 
  //         (4) The i_rdy is asserted low
  input  i_vld_a, 
  output i_rdy, 
  input  [DW-1:0] i_dat,
  // The regular handshake interface at out-side
  //         Just the regular handshake o_vld & o_rdy like AXI
  output o_vld, 
  input  o_rdy, 
  output [DW-1:0] o_dat,

  input  clk,
  input  rst_n 
);

wire i_vld_sync;
// Sync the async signal first
sirv_gnrl_sync #(.DP(SYNC_DP), .DW(1)) u_i_vld_sync (
     .clk   (clk),
     .rst_n (rst_n),
     .din_a (i_vld_a),
     .dout  (i_vld_sync)
    );

wire i_vld_sync_r;
sirv_gnrl_dffr #(1) i_vld_sync_dffr(i_vld_sync, i_vld_sync_r, clk, rst_n);
wire i_vld_sync_nedge = (~i_vld_sync) & i_vld_sync_r;

wire buf_rdy;
wire i_rdy_r;
// Because it is a 4-phases handshake, so 
//   The i_rdy is set (assert to high) when the buf is ready (can save data) and incoming valid detected
//   The i_rdy is clear when i_vld neg-edge is detected
wire i_rdy_set = buf_rdy & i_vld_sync & (~i_rdy_r);
wire i_rdy_clr = i_vld_sync_nedge;
wire i_rdy_ena = i_rdy_set |   i_rdy_clr;
wire i_rdy_nxt = i_rdy_set | (~i_rdy_clr);
sirv_gnrl_dfflr #(1) i_rdy_dfflr(i_rdy_ena, i_rdy_nxt, i_rdy_r, clk, rst_n);
assign i_rdy = i_rdy_r;


wire buf_vld_r;
wire [DW-1:0] buf_dat_r;

// The buf is loaded with data when i_rdy is set high (i.e., 
//   when the buf is ready (can save data) and incoming valid detected
wire buf_dat_ena = i_rdy_set;
sirv_gnrl_dfflr #(DW) buf_dat_dfflr(buf_dat_ena, i_dat, buf_dat_r, clk, rst_n);

// The buf_vld is set when the buf is loaded with data
wire buf_vld_set = buf_dat_ena;
// The buf_vld is clr when the buf is handshaked at the out-end
wire buf_vld_clr = o_vld & o_rdy;
wire buf_vld_ena = buf_vld_set | buf_vld_clr;
wire buf_vld_nxt = buf_vld_set | (~buf_vld_clr);
sirv_gnrl_dfflr #(1) buf_vld_dfflr(buf_vld_ena, buf_vld_nxt, buf_vld_r, clk, rst_n);
// The buf is ready when the buf is empty
assign buf_rdy = (~buf_vld_r);

assign o_vld = buf_vld_r;
assign o_dat = buf_dat_r;

endmodule 

// ===========================================================================
//
// Description:
//  Verilog module sirv_gnrl cdc tx to transmit the async handshake interface 
//
// ===========================================================================
// Configuration-dependent macro definitions
//
module sirv_gnrl_cdc_tx
# (
  parameter DW = 32,
  parameter SYNC_DP = 2
) (
  // The regular handshake interface at in-side
  //         Just the regular handshake o_vld & o_rdy like AXI
  input  i_vld, 
  output i_rdy, 
  input  [DW-1:0] i_dat,

  // The 4-phases handshake interface at out-side
  //     There are 4 steps required for a full transaction. 
  //         (1) The i_vld is asserted high 
  //         (2) The i_rdy is asserted high
  //         (3) The i_vld is asserted low 
  //         (4) The i_rdy is asserted low
  output o_vld, 
  input  o_rdy_a, 
  output [DW-1:0] o_dat,

  input  clk,
  input  rst_n 
);

wire o_rdy_sync;

// Sync the async signal first
sirv_gnrl_sync #(
    .DP(SYNC_DP), 
    .DW(1)
) u_o_rdy_sync (
         .clk   (clk),
         .rst_n (rst_n),
         .din_a (o_rdy_a),
         .dout  (o_rdy_sync)
        );

wire vld_r;
wire [DW-1:0] dat_r;

// Valid set when it is handshaked
wire vld_set = i_vld & i_rdy;
// Valid clr when the TX o_rdy is high
wire vld_clr = o_vld & o_rdy_sync;
wire vld_ena = vld_set | vld_clr;
wire vld_nxt = vld_set | (~vld_clr);
sirv_gnrl_dfflr #(1) vld_dfflr(vld_ena, vld_nxt, vld_r, clk, rst_n);
// The data buf is only loaded when the vld is set 
sirv_gnrl_dfflr #(DW) dat_dfflr(vld_set, i_dat, dat_r, clk, rst_n);

        // Detect the neg-edge
wire o_rdy_sync_r;
sirv_gnrl_dffr #(1) o_rdy_sync_dffr(o_rdy_sync, o_rdy_sync_r, clk, rst_n);
wire o_rdy_nedge = (~o_rdy_sync) & o_rdy_sync_r;

// Not-ready indication
wire nrdy_r;
// Not-ready is set when the vld_r is set
wire nrdy_set = vld_set;
// Not-ready is clr when the o_rdy neg-edge is detected
wire nrdy_clr = o_rdy_nedge;
wire nrdy_ena = nrdy_set | nrdy_clr;
wire nrdy_nxt = nrdy_set | (~nrdy_clr);
sirv_gnrl_dfflr #(1) buf_nrdy_dfflr(nrdy_ena, nrdy_nxt, nrdy_r, clk, rst_n);

//  The output valid
assign o_vld = vld_r;
//  The output data
assign o_dat = dat_r;

// The input is ready when the  Not-ready indication is low or under clearing
assign i_rdy = (~nrdy_r) | nrdy_clr;

endmodule 

//=====================================================================
//
// Description:
//  Verilog module as bypass buffer
//
// ====================================================================

module sirv_gnrl_bypbuf # (
  parameter DP = 8,
  parameter DW = 32
) (
  input           i_vld,
  output          i_rdy,
  input  [DW-1:0] i_dat,

  output          o_vld,
  input           o_rdy,
  output [DW-1:0] o_dat,

  input           clk,
  input           rst_n
);


  wire          fifo_i_vld;
  wire          fifo_i_rdy;
  wire [DW-1:0] fifo_i_dat;
  
  wire          fifo_o_vld;
  wire          fifo_o_rdy;
  wire [DW-1:0] fifo_o_dat;
  
  sirv_gnrl_fifo # (
       .DP(DP),
       .DW(DW),
       .CUT_READY(1) 
  ) u_bypbuf_fifo(
    .i_vld   (fifo_i_vld),
    .i_rdy   (fifo_i_rdy),
    .i_dat   (fifo_i_dat),
    .o_vld   (fifo_o_vld),
    .o_rdy   (fifo_o_rdy),
    .o_dat   (fifo_o_dat),
    .clk     (clk  ),
    .rst_n   (rst_n)
  );
  
   // This module is a super-weapon for timing fix,
   // but it is tricky, think it harder when you are reading, or contact Bob Hu
  
  assign i_rdy = fifo_i_rdy;
  
  // The FIFO is bypassed when:
  //   * fifo is empty, and o_rdy is high
  wire byp = i_vld & o_rdy & (~fifo_o_vld);

  // FIFO o-ready just use the o_rdy
  assign fifo_o_rdy = o_rdy;
  
  // The output is valid if FIFO or input have valid
  assign o_vld = fifo_o_vld | i_vld;

  // The output data select the FIFO as high priority
  assign o_dat = fifo_o_vld ? fifo_o_dat : i_dat;

  assign fifo_i_dat  = i_dat; 

  // Only pass to FIFO i-valid if FIFO is not bypassed
  assign fifo_i_vld = i_vld & (~byp);


endmodule 

//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The general sync FIFO module
//
// ====================================================================

module sirv_gnrl_fifo # (
  // When the depth is 1, the ready signal may relevant to next stage's ready, hence become logic
  // chains. Use CUT_READY to control it
  // When fifo depth is 1, the fifo is a signle stage
       // if CUT_READY is set, then the back-pressure ready signal will be cut
       //      off, and it can only pass 1 data every 2 cycles
  // When fifo depth is > 1, then it is actually a really fifo
       //      The CUT_READY parameter have no impact to any logics
  parameter CUT_READY = 0,
  parameter MSKO = 0,// Mask out the data with valid or not
  parameter DP   = 8,// FIFO depth
  parameter DW   = 32// FIFO width
) (

  input           i_vld, 
  output          i_rdy, 
  input  [DW-1:0] i_dat,
  output          o_vld, 
  input           o_rdy, 
  output [DW-1:0] o_dat,

  input           clk,
  input           rst_n
);

genvar i;
generate //{

  if(DP == 0) begin: dp_eq1//{ pass through when it is 0 entries

     assign o_vld = i_vld;
     assign i_rdy = o_rdy;
     assign o_dat = i_dat;

  end//}
  else begin: dp_gt0//{

    // FIFO registers
    wire [DW-1:0] fifo_rf_r [DP-1:0];
    wire [DP-1:0] fifo_rf_en;

    // read/write enable
    wire wen = i_vld & i_rdy;
    wire ren = o_vld & o_rdy;
    
    ////////////////
    ///////// Read-Pointer and Write-Pointer
    wire [DP-1:0] rptr_vec_nxt; 
    wire [DP-1:0] rptr_vec_r;
    wire [DP-1:0] wptr_vec_nxt; 
    wire [DP-1:0] wptr_vec_r;

    if(DP == 1) begin:rptr_dp_1
      assign rptr_vec_nxt = 1'b1; 
    end
    else begin:rptr_dp_not_1
      assign rptr_vec_nxt = 
          rptr_vec_r[DP-1] ? {{DP-1{1'b0}}, 1'b1} :
                          (rptr_vec_r << 1);
    end

    if(DP == 1) begin:wptr_dp_1
      assign wptr_vec_nxt = 1'b1; 
    end
    else begin:wptr_dp_not_1
      assign wptr_vec_nxt =
          wptr_vec_r[DP-1] ? {{DP-1{1'b0}}, 1'b1} :
                          (wptr_vec_r << 1);
    end

    sirv_gnrl_dfflrs #(1)    rptr_vec_0_dfflrs  (ren, rptr_vec_nxt[0]     , rptr_vec_r[0]     , clk, rst_n);
    sirv_gnrl_dfflrs #(1)    wptr_vec_0_dfflrs  (wen, wptr_vec_nxt[0]     , wptr_vec_r[0]     , clk, rst_n);
    if(DP > 1) begin:dp_gt1
    sirv_gnrl_dfflr  #(DP-1) rptr_vec_31_dfflr  (ren, rptr_vec_nxt[DP-1:1], rptr_vec_r[DP-1:1], clk, rst_n);
    sirv_gnrl_dfflr  #(DP-1) wptr_vec_31_dfflr  (wen, wptr_vec_nxt[DP-1:1], wptr_vec_r[DP-1:1], clk, rst_n);
    end

    ////////////////
    ///////// Vec register to easy full and empty and the o_vld generation with flop-clean
    wire [DP:0] i_vec;
    wire [DP:0] o_vec;
    wire [DP:0] vec_nxt; 
    wire [DP:0] vec_r;

    wire vec_en = (ren ^ wen );
    assign vec_nxt = wen ? {vec_r[DP-1:0], 1'b1} : (vec_r >> 1);  
    
    sirv_gnrl_dfflrs #(1)  vec_0_dfflrs     (vec_en, vec_nxt[0]     , vec_r[0]     ,     clk, rst_n);
    sirv_gnrl_dfflr  #(DP) vec_31_dfflr     (vec_en, vec_nxt[DP:1], vec_r[DP:1],     clk, rst_n);
    
    assign i_vec = {1'b0,vec_r[DP:1]};
    assign o_vec = {1'b0,vec_r[DP:1]};

    if(DP == 1) begin:cut_dp_eq1//{
        if(CUT_READY == 1) begin:cut_ready//{
          // If cut ready, then only accept when fifo is not full
          assign i_rdy = (~i_vec[DP-1]);
        end//}
        else begin:no_cut_ready//{
          // If not cut ready, then can accept when fifo is not full or it is popping 
          assign i_rdy = (~i_vec[DP-1]) | ren;
        end//}
    end//}
    else begin : no_cut_dp_gt1//}{
      assign i_rdy = (~i_vec[DP-1]);
    end//}


    ///////// write fifo
    for (i=0; i<DP; i=i+1) begin:fifo_rf//{
      assign fifo_rf_en[i] = wen & wptr_vec_r[i];
      // Write the FIFO registers
      sirv_gnrl_dffl  #(DW) fifo_rf_dffl (fifo_rf_en[i], i_dat, fifo_rf_r[i], clk);
    end//}

    /////////One-Hot Mux as the read path
    integer j;
    reg [DW-1:0] mux_rdat;
    always @*
    begin : rd_port_PROC//{
      mux_rdat = {DW{1'b0}};
      for(j=0; j<DP; j=j+1) begin
        mux_rdat = mux_rdat | ({DW{rptr_vec_r[j]}} & fifo_rf_r[j]);
      end
    end//}
    
    if(MSKO == 1) begin:mask_output//{
        // Mask the data with valid since the FIFO register is not reset and as X 
        assign o_dat = {DW{o_vld}} & mux_rdat;
    end//}
    else begin:no_mask_output//{
        // Not Mask the data with valid since no care with X for datapth
        assign o_dat = mux_rdat;
    end//}
    
    // o_vld as flop-clean
    assign o_vld = (o_vec[0]);
    
  end//}
endgenerate//}

endmodule 

