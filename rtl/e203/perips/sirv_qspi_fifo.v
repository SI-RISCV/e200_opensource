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
                                                                         
                                                                         
                                                                         

module sirv_qspi_fifo(
  input   clock,
  input   reset,
  input  [1:0] io_ctrl_fmt_proto,
  input   io_ctrl_fmt_endian,
  input   io_ctrl_fmt_iodir,
  input  [3:0] io_ctrl_fmt_len,
  input  [1:0] io_ctrl_cs_mode,
  input  [3:0] io_ctrl_wm_tx,
  input  [3:0] io_ctrl_wm_rx,
  input   io_link_tx_ready,
  output  io_link_tx_valid,
  output [7:0] io_link_tx_bits,
  input   io_link_rx_valid,
  input  [7:0] io_link_rx_bits,
  output [7:0] io_link_cnt,
  output [1:0] io_link_fmt_proto,
  output  io_link_fmt_endian,
  output  io_link_fmt_iodir,
  output  io_link_cs_set,
  output  io_link_cs_clear,
  output  io_link_cs_hold,
  input   io_link_active,
  output  io_link_lock,
  output  io_tx_ready,
  input   io_tx_valid,
  input  [7:0] io_tx_bits,
  input   io_rx_ready,
  output  io_rx_valid,
  output [7:0] io_rx_bits,
  output  io_ip_txwm,
  output  io_ip_rxwm
);
  wire  txq_clock;
  wire  txq_reset;
  wire  txq_io_enq_ready;
  wire  txq_io_enq_valid;
  wire [7:0] txq_io_enq_bits;
  wire  txq_io_deq_ready;
  wire  txq_io_deq_valid;
  wire [7:0] txq_io_deq_bits;
  wire [3:0] txq_io_count;
  wire  rxq_clock;
  wire  rxq_reset;
  wire  rxq_io_enq_ready;
  wire  rxq_io_enq_valid;
  wire [7:0] rxq_io_enq_bits;
  wire  rxq_io_deq_ready;
  wire  rxq_io_deq_valid;
  wire [7:0] rxq_io_deq_bits;
  wire [3:0] rxq_io_count;
  wire  fire_tx;
  reg  rxen;
  reg [31:0] GEN_5;
  wire  T_94;
  wire  GEN_0;
  wire  T_96;
  wire  GEN_1;
  wire  T_97;
  wire  T_98;
  wire  T_99;
  wire [2:0] T_101;
  wire [1:0] T_102;
  wire [3:0] T_104;
  wire [2:0] T_106;
  wire [1:0] T_108;
  wire [3:0] GEN_2;
  wire [3:0] T_110;
  wire [3:0] GEN_3;
  wire [3:0] T_111;
  wire [3:0] cnt_quot;
  wire  T_112;
  wire [1:0] T_115;
  wire  T_117;
  wire [2:0] T_118;
  wire  T_120;
  wire  T_123;
  wire  T_126;
  wire  T_129;
  wire  T_131;
  wire  T_132;
  wire  cnt_rmdr;
  wire [3:0] GEN_4;
  wire [4:0] T_133;
  wire [3:0] T_134;
  reg [1:0] cs_mode;
  reg [31:0] GEN_6;
  wire  cs_mode_hold;
  wire  cs_mode_off;
  wire  cs_update;
  wire  T_135;
  wire  cs_clear;
  wire  T_138;
  wire  T_139;
  wire  T_140;
  wire  T_142;
  wire  T_143;
  wire  T_144;
  sirv_queue_1 txq (
    .clock(txq_clock),
    .reset(txq_reset),
    .io_enq_ready(txq_io_enq_ready),
    .io_enq_valid(txq_io_enq_valid),
    .io_enq_bits(txq_io_enq_bits),
    .io_deq_ready(txq_io_deq_ready),
    .io_deq_valid(txq_io_deq_valid),
    .io_deq_bits(txq_io_deq_bits),
    .io_count(txq_io_count)
  );
  sirv_queue_1 rxq (
    .clock(rxq_clock),
    .reset(rxq_reset),
    .io_enq_ready(rxq_io_enq_ready),
    .io_enq_valid(rxq_io_enq_valid),
    .io_enq_bits(rxq_io_enq_bits),
    .io_deq_ready(rxq_io_deq_ready),
    .io_deq_valid(rxq_io_deq_valid),
    .io_deq_bits(rxq_io_deq_bits),
    .io_count(rxq_io_count)
  );
  assign io_link_tx_valid = txq_io_deq_valid;
  assign io_link_tx_bits = txq_io_deq_bits;
  assign io_link_cnt = {{4'd0}, T_134};
  assign io_link_fmt_proto = io_ctrl_fmt_proto;
  assign io_link_fmt_endian = io_ctrl_fmt_endian;
  assign io_link_fmt_iodir = io_ctrl_fmt_iodir;
  assign io_link_cs_set = T_138;
  assign io_link_cs_clear = T_140;
  assign io_link_cs_hold = 1'h0;
  assign io_link_lock = T_142;
  assign io_tx_ready = txq_io_enq_ready;
  assign io_rx_valid = rxq_io_deq_valid;
  assign io_rx_bits = rxq_io_deq_bits;
  assign io_ip_txwm = T_143;
  assign io_ip_rxwm = T_144;
  assign txq_clock = clock;
  assign txq_reset = reset;
  assign txq_io_enq_valid = io_tx_valid;
  assign txq_io_enq_bits = io_tx_bits;
  assign txq_io_deq_ready = io_link_tx_ready;
  assign rxq_clock = clock;
  assign rxq_reset = reset;
  assign rxq_io_enq_valid = T_94;
  assign rxq_io_enq_bits = io_link_rx_bits;
  assign rxq_io_deq_ready = io_rx_ready;
  assign fire_tx = io_link_tx_ready & io_link_tx_valid;
  assign T_94 = io_link_rx_valid & rxen;
  assign GEN_0 = io_link_rx_valid ? 1'h0 : rxen;
  assign T_96 = io_link_fmt_iodir == 1'h0;
  assign GEN_1 = fire_tx ? T_96 : GEN_0;
  assign T_97 = 2'h0 == io_link_fmt_proto;
  assign T_98 = 2'h1 == io_link_fmt_proto;
  assign T_99 = 2'h2 == io_link_fmt_proto;
  assign T_101 = io_ctrl_fmt_len[3:1];
  assign T_102 = io_ctrl_fmt_len[3:2];
  assign T_104 = T_97 ? io_ctrl_fmt_len : 4'h0;
  assign T_106 = T_98 ? T_101 : 3'h0;
  assign T_108 = T_99 ? T_102 : 2'h0;
  assign GEN_2 = {{1'd0}, T_106};
  assign T_110 = T_104 | GEN_2;
  assign GEN_3 = {{2'd0}, T_108};
  assign T_111 = T_110 | GEN_3;
  assign cnt_quot = T_111;
  assign T_112 = io_ctrl_fmt_len[0];
  assign T_115 = io_ctrl_fmt_len[1:0];
  assign T_117 = T_115 != 2'h0;
  assign T_118 = io_ctrl_fmt_len[2:0];
  assign T_120 = T_118 != 3'h0;
  assign T_123 = T_97 ? T_112 : 1'h0;
  assign T_126 = T_98 ? T_117 : 1'h0;
  assign T_129 = T_99 ? T_120 : 1'h0;
  assign T_131 = T_123 | T_126;
  assign T_132 = T_131 | T_129;
  assign cnt_rmdr = T_132;
  assign GEN_4 = {{3'd0}, cnt_rmdr};
  assign T_133 = cnt_quot + GEN_4;
  assign T_134 = T_133[3:0];
  assign cs_mode_hold = cs_mode == 2'h2;
  assign cs_mode_off = cs_mode == 2'h3;
  assign cs_update = cs_mode != io_ctrl_cs_mode;
  assign T_135 = cs_mode_hold | cs_mode_off;
  assign cs_clear = T_135 == 1'h0;
  assign T_138 = cs_mode_off == 1'h0;
  assign T_139 = fire_tx & cs_clear;
  assign T_140 = cs_update | T_139;
  assign T_142 = io_link_tx_valid | rxen;
  assign T_143 = txq_io_count < io_ctrl_wm_tx;
  assign T_144 = rxq_io_count > io_ctrl_wm_rx;

  always @(posedge clock or posedge reset)
    if (reset) begin
      rxen <= 1'h0;
    end else begin
      if (fire_tx) begin
        rxen <= T_96;
      end else begin
        if (io_link_rx_valid) begin
          rxen <= 1'h0;
        end
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      cs_mode <= 2'h0;
    end else begin
      cs_mode <= io_ctrl_cs_mode;
    end

endmodule
