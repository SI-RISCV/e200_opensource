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
                                                                         
                                                                         
                                                                         

module sirv_flash_qspi(
  input   clock,
  input   reset,
  output  io_port_sck,
  input   io_port_dq_0_i,
  output  io_port_dq_0_o,
  output  io_port_dq_0_oe,
  input   io_port_dq_1_i,
  output  io_port_dq_1_o,
  output  io_port_dq_1_oe,
  input   io_port_dq_2_i,
  output  io_port_dq_2_o,
  output  io_port_dq_2_oe,
  input   io_port_dq_3_i,
  output  io_port_dq_3_o,
  output  io_port_dq_3_oe,
  output  io_port_cs_0,
  output  io_tl_i_0_0,
  output  io_tl_r_0_a_ready,
  input   io_tl_r_0_a_valid,
  input  [2:0] io_tl_r_0_a_bits_opcode,
  input  [2:0] io_tl_r_0_a_bits_param,
  input  [2:0] io_tl_r_0_a_bits_size,
  input  [4:0] io_tl_r_0_a_bits_source,
  input  [28:0] io_tl_r_0_a_bits_address,
  input  [3:0] io_tl_r_0_a_bits_mask,
  input  [31:0] io_tl_r_0_a_bits_data,
  input   io_tl_r_0_b_ready,
  output  io_tl_r_0_b_valid,
  output [2:0] io_tl_r_0_b_bits_opcode,
  output [1:0] io_tl_r_0_b_bits_param,
  output [2:0] io_tl_r_0_b_bits_size,
  output [4:0] io_tl_r_0_b_bits_source,
  output [28:0] io_tl_r_0_b_bits_address,
  output [3:0] io_tl_r_0_b_bits_mask,
  output [31:0] io_tl_r_0_b_bits_data,
  output  io_tl_r_0_c_ready,
  input   io_tl_r_0_c_valid,
  input  [2:0] io_tl_r_0_c_bits_opcode,
  input  [2:0] io_tl_r_0_c_bits_param,
  input  [2:0] io_tl_r_0_c_bits_size,
  input  [4:0] io_tl_r_0_c_bits_source,
  input  [28:0] io_tl_r_0_c_bits_address,
  input  [31:0] io_tl_r_0_c_bits_data,
  input   io_tl_r_0_c_bits_error,
  input   io_tl_r_0_d_ready,
  output  io_tl_r_0_d_valid,
  output [2:0] io_tl_r_0_d_bits_opcode,
  output [1:0] io_tl_r_0_d_bits_param,
  output [2:0] io_tl_r_0_d_bits_size,
  output [4:0] io_tl_r_0_d_bits_source,
  output  io_tl_r_0_d_bits_sink,
  output [1:0] io_tl_r_0_d_bits_addr_lo,
  output [31:0] io_tl_r_0_d_bits_data,
  output  io_tl_r_0_d_bits_error,
  output  io_tl_r_0_e_ready,
  input   io_tl_r_0_e_valid,
  input   io_tl_r_0_e_bits_sink,
  output  io_tl_f_0_a_ready,
  input   io_tl_f_0_a_valid,
  input  [2:0] io_tl_f_0_a_bits_opcode,
  input  [2:0] io_tl_f_0_a_bits_param,
  input  [2:0] io_tl_f_0_a_bits_size,
  input  [6:0] io_tl_f_0_a_bits_source,
  input  [29:0] io_tl_f_0_a_bits_address,
  input   io_tl_f_0_a_bits_mask,
  input  [7:0] io_tl_f_0_a_bits_data,
  input   io_tl_f_0_b_ready,
  output  io_tl_f_0_b_valid,
  output [2:0] io_tl_f_0_b_bits_opcode,
  output [1:0] io_tl_f_0_b_bits_param,
  output [2:0] io_tl_f_0_b_bits_size,
  output [6:0] io_tl_f_0_b_bits_source,
  output [29:0] io_tl_f_0_b_bits_address,
  output  io_tl_f_0_b_bits_mask,
  output [7:0] io_tl_f_0_b_bits_data,
  output  io_tl_f_0_c_ready,
  input   io_tl_f_0_c_valid,
  input  [2:0] io_tl_f_0_c_bits_opcode,
  input  [2:0] io_tl_f_0_c_bits_param,
  input  [2:0] io_tl_f_0_c_bits_size,
  input  [6:0] io_tl_f_0_c_bits_source,
  input  [29:0] io_tl_f_0_c_bits_address,
  input  [7:0] io_tl_f_0_c_bits_data,
  input   io_tl_f_0_c_bits_error,
  input   io_tl_f_0_d_ready,
  output  io_tl_f_0_d_valid,
  output [2:0] io_tl_f_0_d_bits_opcode,
  output [1:0] io_tl_f_0_d_bits_param,
  output [2:0] io_tl_f_0_d_bits_size,
  output [6:0] io_tl_f_0_d_bits_source,
  output  io_tl_f_0_d_bits_sink,
  output  io_tl_f_0_d_bits_addr_lo,
  output [7:0] io_tl_f_0_d_bits_data,
  output  io_tl_f_0_d_bits_error,
  output  io_tl_f_0_e_ready,
  input   io_tl_f_0_e_valid,
  input   io_tl_f_0_e_bits_sink
);
  wire [1:0] T_1840_fmt_proto;
  wire  T_1840_fmt_endian;
  wire  T_1840_fmt_iodir;
  wire [3:0] T_1840_fmt_len;
  wire [11:0] T_1840_sck_div;
  wire  T_1840_sck_pol;
  wire  T_1840_sck_pha;
  wire  T_1840_cs_id;
  wire  T_1840_cs_dflt_0;
  wire [1:0] T_1840_cs_mode;
  wire [7:0] T_1840_dla_cssck;
  wire [7:0] T_1840_dla_sckcs;
  wire [7:0] T_1840_dla_intercs;
  wire [7:0] T_1840_dla_interxfr;
  wire [3:0] T_1840_wm_tx;
  wire [3:0] T_1840_wm_rx;
  reg [1:0] ctrl_fmt_proto;
  reg [31:0] GEN_273;
  reg  ctrl_fmt_endian;
  reg [31:0] GEN_274;
  reg  ctrl_fmt_iodir;
  reg [31:0] GEN_275;
  reg [3:0] ctrl_fmt_len;
  reg [31:0] GEN_276;
  reg [11:0] ctrl_sck_div;
  reg [31:0] GEN_277;
  reg  ctrl_sck_pol;
  reg [31:0] GEN_278;
  reg  ctrl_sck_pha;
  reg [31:0] GEN_279;
  reg  ctrl_cs_id;
  reg [31:0] GEN_280;
  reg  ctrl_cs_dflt_0;
  reg [31:0] GEN_281;
  reg [1:0] ctrl_cs_mode;
  reg [31:0] GEN_282;
  reg [7:0] ctrl_dla_cssck;
  reg [31:0] GEN_283;
  reg [7:0] ctrl_dla_sckcs;
  reg [31:0] GEN_284;
  reg [7:0] ctrl_dla_intercs;
  reg [31:0] GEN_285;
  reg [7:0] ctrl_dla_interxfr;
  reg [31:0] GEN_286;
  reg [3:0] ctrl_wm_tx;
  reg [31:0] GEN_287;
  reg [3:0] ctrl_wm_rx;
  reg [31:0] GEN_288;
  wire  fifo_clock;
  wire  fifo_reset;
  wire [1:0] fifo_io_ctrl_fmt_proto;
  wire  fifo_io_ctrl_fmt_endian;
  wire  fifo_io_ctrl_fmt_iodir;
  wire [3:0] fifo_io_ctrl_fmt_len;
  wire [1:0] fifo_io_ctrl_cs_mode;
  wire [3:0] fifo_io_ctrl_wm_tx;
  wire [3:0] fifo_io_ctrl_wm_rx;
  wire  fifo_io_link_tx_ready;
  wire  fifo_io_link_tx_valid;
  wire [7:0] fifo_io_link_tx_bits;
  wire  fifo_io_link_rx_valid;
  wire [7:0] fifo_io_link_rx_bits;
  wire [7:0] fifo_io_link_cnt;
  wire [1:0] fifo_io_link_fmt_proto;
  wire  fifo_io_link_fmt_endian;
  wire  fifo_io_link_fmt_iodir;
  wire  fifo_io_link_cs_set;
  wire  fifo_io_link_cs_clear;
  wire  fifo_io_link_cs_hold;
  wire  fifo_io_link_active;
  wire  fifo_io_link_lock;
  wire  fifo_io_tx_ready;
  wire  fifo_io_tx_valid;
  wire [7:0] fifo_io_tx_bits;
  wire  fifo_io_rx_ready;
  wire  fifo_io_rx_valid;
  wire [7:0] fifo_io_rx_bits;
  wire  fifo_io_ip_txwm;
  wire  fifo_io_ip_rxwm;
  wire  mac_clock;
  wire  mac_reset;
  wire  mac_io_port_sck;
  wire  mac_io_port_dq_0_i;
  wire  mac_io_port_dq_0_o;
  wire  mac_io_port_dq_0_oe;
  wire  mac_io_port_dq_1_i;
  wire  mac_io_port_dq_1_o;
  wire  mac_io_port_dq_1_oe;
  wire  mac_io_port_dq_2_i;
  wire  mac_io_port_dq_2_o;
  wire  mac_io_port_dq_2_oe;
  wire  mac_io_port_dq_3_i;
  wire  mac_io_port_dq_3_o;
  wire  mac_io_port_dq_3_oe;
  wire  mac_io_port_cs_0;
  wire [11:0] mac_io_ctrl_sck_div;
  wire  mac_io_ctrl_sck_pol;
  wire  mac_io_ctrl_sck_pha;
  wire [7:0] mac_io_ctrl_dla_cssck;
  wire [7:0] mac_io_ctrl_dla_sckcs;
  wire [7:0] mac_io_ctrl_dla_intercs;
  wire [7:0] mac_io_ctrl_dla_interxfr;
  wire  mac_io_ctrl_cs_id;
  wire  mac_io_ctrl_cs_dflt_0;
  wire  mac_io_link_tx_ready;
  wire  mac_io_link_tx_valid;
  wire [7:0] mac_io_link_tx_bits;
  wire  mac_io_link_rx_valid;
  wire [7:0] mac_io_link_rx_bits;
  wire [7:0] mac_io_link_cnt;
  wire [1:0] mac_io_link_fmt_proto;
  wire  mac_io_link_fmt_endian;
  wire  mac_io_link_fmt_iodir;
  wire  mac_io_link_cs_set;
  wire  mac_io_link_cs_clear;
  wire  mac_io_link_cs_hold;
  wire  mac_io_link_active;
  wire  T_1906_txwm;
  wire  T_1906_rxwm;
  wire [1:0] T_1910;
  wire  T_1911;
  wire  T_1912;
  reg  ie_txwm;
  reg [31:0] GEN_289;
  reg  ie_rxwm;
  reg [31:0] GEN_290;
  wire  T_1915;
  wire  T_1916;
  wire  T_1917;
  wire  T_1921;
  wire  T_1924;
  wire  flash_clock;
  wire  flash_reset;
  wire  flash_io_en;
  wire [1:0] flash_io_ctrl_insn_cmd_proto;
  wire [7:0] flash_io_ctrl_insn_cmd_code;
  wire  flash_io_ctrl_insn_cmd_en;
  wire [1:0] flash_io_ctrl_insn_addr_proto;
  wire [2:0] flash_io_ctrl_insn_addr_len;
  wire [7:0] flash_io_ctrl_insn_pad_code;
  wire [3:0] flash_io_ctrl_insn_pad_cnt;
  wire [1:0] flash_io_ctrl_insn_data_proto;
  wire  flash_io_ctrl_fmt_endian;
  wire  flash_io_addr_ready;
  wire  flash_io_addr_valid;
  wire [31:0] flash_io_addr_bits_next;
  wire [31:0] flash_io_addr_bits_hold;
  wire  flash_io_data_ready;
  wire  flash_io_data_valid;
  wire [7:0] flash_io_data_bits;
  wire  flash_io_link_tx_ready;
  wire  flash_io_link_tx_valid;
  wire [7:0] flash_io_link_tx_bits;
  wire  flash_io_link_rx_valid;
  wire [7:0] flash_io_link_rx_bits;
  wire [7:0] flash_io_link_cnt;
  wire [1:0] flash_io_link_fmt_proto;
  wire  flash_io_link_fmt_endian;
  wire  flash_io_link_fmt_iodir;
  wire  flash_io_link_cs_set;
  wire  flash_io_link_cs_clear;
  wire  flash_io_link_cs_hold;
  wire  flash_io_link_active;
  wire  flash_io_link_lock;
  wire  arb_clock;
  wire  arb_reset;
  wire  arb_io_inner_0_tx_ready;
  wire  arb_io_inner_0_tx_valid;
  wire [7:0] arb_io_inner_0_tx_bits;
  wire  arb_io_inner_0_rx_valid;
  wire [7:0] arb_io_inner_0_rx_bits;
  wire [7:0] arb_io_inner_0_cnt;
  wire [1:0] arb_io_inner_0_fmt_proto;
  wire  arb_io_inner_0_fmt_endian;
  wire  arb_io_inner_0_fmt_iodir;
  wire  arb_io_inner_0_cs_set;
  wire  arb_io_inner_0_cs_clear;
  wire  arb_io_inner_0_cs_hold;
  wire  arb_io_inner_0_active;
  wire  arb_io_inner_0_lock;
  wire  arb_io_inner_1_tx_ready;
  wire  arb_io_inner_1_tx_valid;
  wire [7:0] arb_io_inner_1_tx_bits;
  wire  arb_io_inner_1_rx_valid;
  wire [7:0] arb_io_inner_1_rx_bits;
  wire [7:0] arb_io_inner_1_cnt;
  wire [1:0] arb_io_inner_1_fmt_proto;
  wire  arb_io_inner_1_fmt_endian;
  wire  arb_io_inner_1_fmt_iodir;
  wire  arb_io_inner_1_cs_set;
  wire  arb_io_inner_1_cs_clear;
  wire  arb_io_inner_1_cs_hold;
  wire  arb_io_inner_1_active;
  wire  arb_io_inner_1_lock;
  wire  arb_io_outer_tx_ready;
  wire  arb_io_outer_tx_valid;
  wire [7:0] arb_io_outer_tx_bits;
  wire  arb_io_outer_rx_valid;
  wire [7:0] arb_io_outer_rx_bits;
  wire [7:0] arb_io_outer_cnt;
  wire [1:0] arb_io_outer_fmt_proto;
  wire  arb_io_outer_fmt_endian;
  wire  arb_io_outer_fmt_iodir;
  wire  arb_io_outer_cs_set;
  wire  arb_io_outer_cs_clear;
  wire  arb_io_outer_cs_hold;
  wire  arb_io_outer_active;
  wire  arb_io_sel;
  reg [2:0] a_opcode;
  reg [31:0] GEN_291;
  reg [2:0] a_param;
  reg [31:0] GEN_292;
  reg [2:0] a_size;
  reg [31:0] GEN_293;
  reg [6:0] a_source;
  reg [31:0] GEN_294;
  reg [29:0] a_address;
  reg [31:0] GEN_295;
  reg  a_mask;
  reg [31:0] GEN_296;
  reg [7:0] a_data;
  reg [31:0] GEN_297;
  wire  T_1935;
  wire [2:0] GEN_6;
  wire [2:0] GEN_7;
  wire [2:0] GEN_8;
  wire [6:0] GEN_9;
  wire [29:0] GEN_10;
  wire  GEN_11;
  wire [7:0] GEN_12;
  wire [28:0] T_1936;
  wire [28:0] T_1937;
  wire [2:0] T_1949_opcode;
  wire [1:0] T_1949_param;
  wire [2:0] T_1949_size;
  wire [6:0] T_1949_source;
  wire  T_1949_sink;
  wire  T_1949_addr_lo;
  wire [7:0] T_1949_data;
  wire  T_1949_error;
  wire [1:0] T_1973_cmd_proto;
  wire [7:0] T_1973_cmd_code;
  wire  T_1973_cmd_en;
  wire [1:0] T_1973_addr_proto;
  wire [2:0] T_1973_addr_len;
  wire [7:0] T_1973_pad_code;
  wire [3:0] T_1973_pad_cnt;
  wire [1:0] T_1973_data_proto;
  reg [1:0] insn_cmd_proto;
  reg [31:0] GEN_298;
  reg [7:0] insn_cmd_code;
  reg [31:0] GEN_299;
  reg  insn_cmd_en;
  reg [31:0] GEN_300;
  reg [1:0] insn_addr_proto;
  reg [31:0] GEN_301;
  reg [2:0] insn_addr_len;
  reg [31:0] GEN_302;
  reg [7:0] insn_pad_code;
  reg [31:0] GEN_303;
  reg [3:0] insn_pad_cnt;
  reg [31:0] GEN_304;
  reg [1:0] insn_data_proto;
  reg [31:0] GEN_305;
  reg  flash_en;
  reg [31:0] GEN_306;
  wire  T_2005;
  wire  T_2029_ready;
  wire  T_2029_valid;
  wire  T_2029_bits_read;
  wire [9:0] T_2029_bits_index;
  wire [31:0] T_2029_bits_data;
  wire [3:0] T_2029_bits_mask;
  wire [9:0] T_2029_bits_extra;
  wire  T_2046;
  wire [26:0] T_2047;
  wire [1:0] T_2048;
  wire [6:0] T_2049;
  wire [9:0] T_2050;
  wire  T_2068_ready;
  wire  T_2068_valid;
  wire  T_2068_bits_read;
  wire [31:0] T_2068_bits_data;
  wire [9:0] T_2068_bits_extra;
  wire  T_2104_ready;
  wire  T_2104_valid;
  wire  T_2104_bits_read;
  wire [9:0] T_2104_bits_index;
  wire [31:0] T_2104_bits_data;
  wire [3:0] T_2104_bits_mask;
  wire [9:0] T_2104_bits_extra;
  wire [9:0] T_2189;
  wire  T_2191;
  wire [9:0] T_2197;
  wire [9:0] T_2198;
  wire  T_2200;
  wire [9:0] T_2206;
  wire [9:0] T_2207;
  wire  T_2209;
  wire [9:0] T_2215;
  wire [9:0] T_2216;
  wire  T_2218;
  wire [9:0] T_2224;
  wire [9:0] T_2225;
  wire  T_2227;
  wire [9:0] T_2233;
  wire [9:0] T_2234;
  wire  T_2236;
  wire [9:0] T_2242;
  wire [9:0] T_2243;
  wire  T_2245;
  wire [9:0] T_2251;
  wire [9:0] T_2252;
  wire  T_2254;
  wire [9:0] T_2260;
  wire [9:0] T_2261;
  wire  T_2263;
  wire [9:0] T_2269;
  wire [9:0] T_2270;
  wire  T_2272;
  wire [9:0] T_2278;
  wire [9:0] T_2279;
  wire  T_2281;
  wire [9:0] T_2287;
  wire [9:0] T_2288;
  wire  T_2290;
  wire [9:0] T_2296;
  wire [9:0] T_2297;
  wire  T_2299;
  wire [9:0] T_2305;
  wire [9:0] T_2306;
  wire  T_2308;
  wire [9:0] T_2314;
  wire [9:0] T_2315;
  wire  T_2317;
  wire [9:0] T_2323;
  wire [9:0] T_2324;
  wire  T_2326;
  wire  T_2334_0;
  wire  T_2334_1;
  wire  T_2334_2;
  wire  T_2334_3;
  wire  T_2334_4;
  wire  T_2334_5;
  wire  T_2334_6;
  wire  T_2334_7;
  wire  T_2334_8;
  wire  T_2334_9;
  wire  T_2334_10;
  wire  T_2334_11;
  wire  T_2334_12;
  wire  T_2334_13;
  wire  T_2334_14;
  wire  T_2334_15;
  wire  T_2334_16;
  wire  T_2334_17;
  wire  T_2334_18;
  wire  T_2334_19;
  wire  T_2334_20;
  wire  T_2334_21;
  wire  T_2334_22;
  wire  T_2334_23;
  wire  T_2334_24;
  wire  T_2334_25;
  wire  T_2334_26;
  wire  T_2334_27;
  wire  T_2334_28;
  wire  T_2334_29;
  wire  T_2334_30;
  wire  T_2334_31;
  wire  T_2334_32;
  wire  T_2334_33;
  wire  T_2334_34;
  wire  T_2339_0;
  wire  T_2339_1;
  wire  T_2339_2;
  wire  T_2339_3;
  wire  T_2339_4;
  wire  T_2339_5;
  wire  T_2339_6;
  wire  T_2339_7;
  wire  T_2339_8;
  wire  T_2339_9;
  wire  T_2339_10;
  wire  T_2339_11;
  wire  T_2339_12;
  wire  T_2339_13;
  wire  T_2339_14;
  wire  T_2339_15;
  wire  T_2339_16;
  wire  T_2339_17;
  wire  T_2339_18;
  wire  T_2339_19;
  wire  T_2339_20;
  wire  T_2339_21;
  wire  T_2339_22;
  wire  T_2339_23;
  wire  T_2339_24;
  wire  T_2339_25;
  wire  T_2339_26;
  wire  T_2339_27;
  wire  T_2339_28;
  wire  T_2339_29;
  wire  T_2339_30;
  wire  T_2339_31;
  wire  T_2339_32;
  wire  T_2339_33;
  wire  T_2339_34;
  wire  T_2344_0;
  wire  T_2344_1;
  wire  T_2344_2;
  wire  T_2344_3;
  wire  T_2344_4;
  wire  T_2344_5;
  wire  T_2344_6;
  wire  T_2344_7;
  wire  T_2344_8;
  wire  T_2344_9;
  wire  T_2344_10;
  wire  T_2344_11;
  wire  T_2344_12;
  wire  T_2344_13;
  wire  T_2344_14;
  wire  T_2344_15;
  wire  T_2344_16;
  wire  T_2344_17;
  wire  T_2344_18;
  wire  T_2344_19;
  wire  T_2344_20;
  wire  T_2344_21;
  wire  T_2344_22;
  wire  T_2344_23;
  wire  T_2344_24;
  wire  T_2344_25;
  wire  T_2344_26;
  wire  T_2344_27;
  wire  T_2344_28;
  wire  T_2344_29;
  wire  T_2344_30;
  wire  T_2344_31;
  wire  T_2344_32;
  wire  T_2344_33;
  wire  T_2344_34;
  wire  T_2349_0;
  wire  T_2349_1;
  wire  T_2349_2;
  wire  T_2349_3;
  wire  T_2349_4;
  wire  T_2349_5;
  wire  T_2349_6;
  wire  T_2349_7;
  wire  T_2349_8;
  wire  T_2349_9;
  wire  T_2349_10;
  wire  T_2349_11;
  wire  T_2349_12;
  wire  T_2349_13;
  wire  T_2349_14;
  wire  T_2349_15;
  wire  T_2349_16;
  wire  T_2349_17;
  wire  T_2349_18;
  wire  T_2349_19;
  wire  T_2349_20;
  wire  T_2349_21;
  wire  T_2349_22;
  wire  T_2349_23;
  wire  T_2349_24;
  wire  T_2349_25;
  wire  T_2349_26;
  wire  T_2349_27;
  wire  T_2349_28;
  wire  T_2349_29;
  wire  T_2349_30;
  wire  T_2349_31;
  wire  T_2349_32;
  wire  T_2349_33;
  wire  T_2349_34;
  wire  T_2354_0;
  wire  T_2354_1;
  wire  T_2354_2;
  wire  T_2354_3;
  wire  T_2354_4;
  wire  T_2354_5;
  wire  T_2354_6;
  wire  T_2354_7;
  wire  T_2354_8;
  wire  T_2354_9;
  wire  T_2354_10;
  wire  T_2354_11;
  wire  T_2354_12;
  wire  T_2354_13;
  wire  T_2354_14;
  wire  T_2354_15;
  wire  T_2354_16;
  wire  T_2354_17;
  wire  T_2354_18;
  wire  T_2354_19;
  wire  T_2354_20;
  wire  T_2354_21;
  wire  T_2354_22;
  wire  T_2354_23;
  wire  T_2354_24;
  wire  T_2354_25;
  wire  T_2354_26;
  wire  T_2354_27;
  wire  T_2354_28;
  wire  T_2354_29;
  wire  T_2354_30;
  wire  T_2354_31;
  wire  T_2354_32;
  wire  T_2354_33;
  wire  T_2354_34;
  wire  T_2359_0;
  wire  T_2359_1;
  wire  T_2359_2;
  wire  T_2359_3;
  wire  T_2359_4;
  wire  T_2359_5;
  wire  T_2359_6;
  wire  T_2359_7;
  wire  T_2359_8;
  wire  T_2359_9;
  wire  T_2359_10;
  wire  T_2359_11;
  wire  T_2359_12;
  wire  T_2359_13;
  wire  T_2359_14;
  wire  T_2359_15;
  wire  T_2359_16;
  wire  T_2359_17;
  wire  T_2359_18;
  wire  T_2359_19;
  wire  T_2359_20;
  wire  T_2359_21;
  wire  T_2359_22;
  wire  T_2359_23;
  wire  T_2359_24;
  wire  T_2359_25;
  wire  T_2359_26;
  wire  T_2359_27;
  wire  T_2359_28;
  wire  T_2359_29;
  wire  T_2359_30;
  wire  T_2359_31;
  wire  T_2359_32;
  wire  T_2359_33;
  wire  T_2359_34;
  wire  T_2364_0;
  wire  T_2364_1;
  wire  T_2364_2;
  wire  T_2364_3;
  wire  T_2364_4;
  wire  T_2364_5;
  wire  T_2364_6;
  wire  T_2364_7;
  wire  T_2364_8;
  wire  T_2364_9;
  wire  T_2364_10;
  wire  T_2364_11;
  wire  T_2364_12;
  wire  T_2364_13;
  wire  T_2364_14;
  wire  T_2364_15;
  wire  T_2364_16;
  wire  T_2364_17;
  wire  T_2364_18;
  wire  T_2364_19;
  wire  T_2364_20;
  wire  T_2364_21;
  wire  T_2364_22;
  wire  T_2364_23;
  wire  T_2364_24;
  wire  T_2364_25;
  wire  T_2364_26;
  wire  T_2364_27;
  wire  T_2364_28;
  wire  T_2364_29;
  wire  T_2364_30;
  wire  T_2364_31;
  wire  T_2364_32;
  wire  T_2364_33;
  wire  T_2364_34;
  wire  T_2369_0;
  wire  T_2369_1;
  wire  T_2369_2;
  wire  T_2369_3;
  wire  T_2369_4;
  wire  T_2369_5;
  wire  T_2369_6;
  wire  T_2369_7;
  wire  T_2369_8;
  wire  T_2369_9;
  wire  T_2369_10;
  wire  T_2369_11;
  wire  T_2369_12;
  wire  T_2369_13;
  wire  T_2369_14;
  wire  T_2369_15;
  wire  T_2369_16;
  wire  T_2369_17;
  wire  T_2369_18;
  wire  T_2369_19;
  wire  T_2369_20;
  wire  T_2369_21;
  wire  T_2369_22;
  wire  T_2369_23;
  wire  T_2369_24;
  wire  T_2369_25;
  wire  T_2369_26;
  wire  T_2369_27;
  wire  T_2369_28;
  wire  T_2369_29;
  wire  T_2369_30;
  wire  T_2369_31;
  wire  T_2369_32;
  wire  T_2369_33;
  wire  T_2369_34;
  wire  T_2531;
  wire  T_2532;
  wire  T_2533;
  wire  T_2534;
  wire [7:0] T_2538;
  wire [7:0] T_2542;
  wire [7:0] T_2546;
  wire [7:0] T_2550;
  wire [15:0] T_2551;
  wire [15:0] T_2552;
  wire [31:0] T_2553;
  wire [11:0] T_2577;
  wire [11:0] T_2581;
  wire  T_2583;
  wire  T_2596;
  wire [11:0] T_2597;
  wire [11:0] GEN_13;
  wire  T_2617;
  wire  T_2621;
  wire  T_2623;
  wire  T_2636;
  wire  T_2637;
  wire  GEN_14;
  wire [7:0] T_2657;
  wire  T_2659;
  wire [7:0] T_2661;
  wire  T_2663;
  wire  T_2676;
  wire [7:0] T_2677;
  wire [7:0] GEN_15;
  wire [7:0] T_2697;
  wire [7:0] T_2701;
  wire  T_2703;
  wire  T_2716;
  wire [7:0] T_2717;
  wire [7:0] GEN_16;
  wire [23:0] GEN_226;
  wire [23:0] T_2732;
  wire [23:0] GEN_227;
  wire [23:0] T_2736;
  wire  T_2756;
  wire  GEN_17;
  wire  T_2796;
  wire  GEN_18;
  wire [2:0] T_2817;
  wire [2:0] T_2821;
  wire  T_2823;
  wire  T_2836;
  wire [2:0] T_2837;
  wire [2:0] GEN_19;
  wire [3:0] GEN_228;
  wire [3:0] T_2852;
  wire [3:0] GEN_229;
  wire [3:0] T_2856;
  wire [3:0] T_2857;
  wire [3:0] T_2861;
  wire  T_2863;
  wire  T_2876;
  wire [3:0] T_2877;
  wire [3:0] GEN_20;
  wire [7:0] GEN_230;
  wire [7:0] T_2892;
  wire [7:0] GEN_231;
  wire [7:0] T_2896;
  wire [1:0] T_2897;
  wire [1:0] T_2901;
  wire  T_2903;
  wire  T_2916;
  wire [1:0] T_2917;
  wire [1:0] GEN_21;
  wire [9:0] GEN_232;
  wire [9:0] T_2932;
  wire [9:0] GEN_233;
  wire [9:0] T_2936;
  wire [1:0] T_2937;
  wire [1:0] T_2941;
  wire  T_2943;
  wire  T_2956;
  wire [1:0] T_2957;
  wire [1:0] GEN_22;
  wire [11:0] GEN_234;
  wire [11:0] T_2972;
  wire [11:0] GEN_235;
  wire [11:0] T_2976;
  wire [1:0] T_2977;
  wire [1:0] T_2981;
  wire  T_2983;
  wire  T_2996;
  wire [1:0] T_2997;
  wire [1:0] GEN_23;
  wire [13:0] GEN_236;
  wire [13:0] T_3012;
  wire [13:0] GEN_237;
  wire [13:0] T_3016;
  wire  T_3036;
  wire [7:0] GEN_24;
  wire [23:0] GEN_238;
  wire [23:0] T_3052;
  wire [23:0] GEN_239;
  wire [23:0] T_3056;
  wire [7:0] T_3057;
  wire [7:0] T_3061;
  wire  T_3063;
  wire  T_3076;
  wire [7:0] T_3077;
  wire [7:0] GEN_25;
  wire [31:0] GEN_240;
  wire [31:0] T_3092;
  wire [31:0] GEN_241;
  wire [31:0] T_3096;
  wire [3:0] T_3097;
  wire [3:0] T_3101;
  wire  T_3103;
  wire  T_3116;
  wire [3:0] T_3117;
  wire [3:0] GEN_26;
  wire  T_3172;
  wire  T_3177;
  wire  T_3181;
  wire  T_3183;
  wire  T_3197;
  wire [1:0] GEN_242;
  wire [1:0] T_3212;
  wire [1:0] GEN_243;
  wire [1:0] T_3216;
  wire  T_3236;
  wire  GEN_27;
  wire  T_3276;
  wire  GEN_28;
  wire [1:0] GEN_244;
  wire [1:0] T_3292;
  wire [1:0] GEN_245;
  wire [1:0] T_3296;
  wire [1:0] T_3297;
  wire [1:0] T_3301;
  wire  T_3303;
  wire  T_3316;
  wire [1:0] T_3317;
  wire [1:0] GEN_29;
  wire  T_3356;
  wire  GEN_30;
  wire  T_3396;
  wire  GEN_31;
  wire [1:0] GEN_246;
  wire [1:0] T_3412;
  wire [1:0] GEN_247;
  wire [1:0] T_3416;
  wire  T_3436;
  wire [3:0] GEN_32;
  wire  T_3476;
  wire [31:0] GEN_248;
  wire [31:0] T_3572;
  wire  T_3596;
  wire [1:0] GEN_33;
  wire  T_3617;
  wire  T_3621;
  wire  T_3623;
  wire  T_3636;
  wire  T_3637;
  wire  GEN_34;
  wire [2:0] GEN_249;
  wire [2:0] T_3652;
  wire [2:0] GEN_250;
  wire [2:0] T_3656;
  wire  T_3657;
  wire  T_3661;
  wire  T_3663;
  wire  T_3676;
  wire  T_3677;
  wire  GEN_35;
  wire [3:0] GEN_251;
  wire [3:0] T_3692;
  wire [3:0] GEN_252;
  wire [3:0] T_3696;
  wire [3:0] T_3697;
  wire [3:0] T_3701;
  wire  T_3703;
  wire  T_3716;
  wire [3:0] T_3717;
  wire [3:0] GEN_36;
  wire [19:0] GEN_253;
  wire [19:0] T_3732;
  wire [19:0] GEN_254;
  wire [19:0] T_3736;
  wire  T_3756;
  wire [7:0] GEN_37;
  wire  T_3796;
  wire [7:0] GEN_38;
  wire [23:0] GEN_255;
  wire [23:0] T_3812;
  wire [23:0] GEN_256;
  wire [23:0] T_3816;
  wire  T_3832;
  wire [7:0] T_3852;
  wire [30:0] T_3896;
  wire [31:0] GEN_257;
  wire [31:0] T_3932;
  wire [31:0] GEN_258;
  wire [31:0] T_3936;
  wire  T_3956;
  wire  GEN_39;
  wire  T_3978;
  wire  T_3980;
  wire  T_3982;
  wire  T_3983;
  wire  T_3985;
  wire  T_3993;
  wire  T_3995;
  wire  T_3997;
  wire  T_3999;
  wire  T_4001;
  wire  T_4003;
  wire  T_4014;
  wire  T_4015;
  wire  T_4017;
  wire  T_4019;
  wire  T_4020;
  wire  T_4022;
  wire  T_4036;
  wire  T_4037;
  wire  T_4038;
  wire  T_4039;
  wire  T_4041;
  wire  T_4046;
  wire  T_4047;
  wire  T_4048;
  wire  T_4050;
  wire  T_4052;
  wire  T_4053;
  wire  T_4054;
  wire  T_4056;
  wire  T_4058;
  wire  T_4060;
  wire  T_4062;
  wire  T_4064;
  wire  T_4072;
  wire  T_4074;
  wire  T_4076;
  wire  T_4077;
  wire  T_4078;
  wire  T_4079;
  wire  T_4080;
  wire  T_4081;
  wire  T_4082;
  wire  T_4083;
  wire  T_4085;
  wire  T_4093;
  wire  T_4094;
  wire  T_4096;
  wire  T_4098;
  wire  T_4099;
  wire  T_4101;
  wire  T_4143_0;
  wire  T_4143_1;
  wire  T_4143_2;
  wire  T_4143_3;
  wire  T_4143_4;
  wire  T_4143_5;
  wire  T_4143_6;
  wire  T_4143_7;
  wire  T_4143_8;
  wire  T_4143_9;
  wire  T_4143_10;
  wire  T_4143_11;
  wire  T_4143_12;
  wire  T_4143_13;
  wire  T_4143_14;
  wire  T_4143_15;
  wire  T_4143_16;
  wire  T_4143_17;
  wire  T_4143_18;
  wire  T_4143_19;
  wire  T_4143_20;
  wire  T_4143_21;
  wire  T_4143_22;
  wire  T_4143_23;
  wire  T_4143_24;
  wire  T_4143_25;
  wire  T_4143_26;
  wire  T_4143_27;
  wire  T_4143_28;
  wire  T_4143_29;
  wire  T_4143_30;
  wire  T_4143_31;
  wire  T_4181;
  wire  T_4184;
  wire  T_4186;
  wire  T_4196;
  wire  T_4200;
  wire  T_4204;
  wire  T_4216;
  wire  T_4218;
  wire  T_4221;
  wire  T_4223;
  wire  T_4238;
  wire  T_4239;
  wire  T_4240;
  wire  T_4242;
  wire  T_4248;
  wire  T_4249;
  wire  T_4251;
  wire  T_4254;
  wire  T_4255;
  wire  T_4257;
  wire  T_4261;
  wire  T_4265;
  wire  T_4275;
  wire  T_4278;
  wire  T_4279;
  wire  T_4280;
  wire  T_4281;
  wire  T_4282;
  wire  T_4283;
  wire  T_4284;
  wire  T_4286;
  wire  T_4295;
  wire  T_4297;
  wire  T_4300;
  wire  T_4302;
  wire  T_4344_0;
  wire  T_4344_1;
  wire  T_4344_2;
  wire  T_4344_3;
  wire  T_4344_4;
  wire  T_4344_5;
  wire  T_4344_6;
  wire  T_4344_7;
  wire  T_4344_8;
  wire  T_4344_9;
  wire  T_4344_10;
  wire  T_4344_11;
  wire  T_4344_12;
  wire  T_4344_13;
  wire  T_4344_14;
  wire  T_4344_15;
  wire  T_4344_16;
  wire  T_4344_17;
  wire  T_4344_18;
  wire  T_4344_19;
  wire  T_4344_20;
  wire  T_4344_21;
  wire  T_4344_22;
  wire  T_4344_23;
  wire  T_4344_24;
  wire  T_4344_25;
  wire  T_4344_26;
  wire  T_4344_27;
  wire  T_4344_28;
  wire  T_4344_29;
  wire  T_4344_30;
  wire  T_4344_31;
  wire  T_4382;
  wire  T_4385;
  wire  T_4387;
  wire  T_4397;
  wire  T_4401;
  wire  T_4405;
  wire  T_4417;
  wire  T_4419;
  wire  T_4422;
  wire  T_4424;
  wire  T_4439;
  wire  T_4440;
  wire  T_4441;
  wire  T_4443;
  wire  T_4449;
  wire  T_4450;
  wire  T_4452;
  wire  T_4455;
  wire  T_4456;
  wire  T_4458;
  wire  T_4462;
  wire  T_4466;
  wire  T_4476;
  wire  T_4479;
  wire  T_4480;
  wire  T_4481;
  wire  T_4482;
  wire  T_4483;
  wire  T_4484;
  wire  T_4485;
  wire  T_4487;
  wire  T_4496;
  wire  T_4498;
  wire  T_4501;
  wire  T_4503;
  wire  T_4545_0;
  wire  T_4545_1;
  wire  T_4545_2;
  wire  T_4545_3;
  wire  T_4545_4;
  wire  T_4545_5;
  wire  T_4545_6;
  wire  T_4545_7;
  wire  T_4545_8;
  wire  T_4545_9;
  wire  T_4545_10;
  wire  T_4545_11;
  wire  T_4545_12;
  wire  T_4545_13;
  wire  T_4545_14;
  wire  T_4545_15;
  wire  T_4545_16;
  wire  T_4545_17;
  wire  T_4545_18;
  wire  T_4545_19;
  wire  T_4545_20;
  wire  T_4545_21;
  wire  T_4545_22;
  wire  T_4545_23;
  wire  T_4545_24;
  wire  T_4545_25;
  wire  T_4545_26;
  wire  T_4545_27;
  wire  T_4545_28;
  wire  T_4545_29;
  wire  T_4545_30;
  wire  T_4545_31;
  wire  T_4583;
  wire  T_4586;
  wire  T_4588;
  wire  T_4598;
  wire  T_4602;
  wire  T_4606;
  wire  T_4618;
  wire  T_4620;
  wire  T_4623;
  wire  T_4625;
  wire  T_4640;
  wire  T_4641;
  wire  T_4642;
  wire  T_4644;
  wire  T_4650;
  wire  T_4651;
  wire  T_4653;
  wire  T_4656;
  wire  T_4657;
  wire  T_4659;
  wire  T_4663;
  wire  T_4667;
  wire  T_4677;
  wire  T_4680;
  wire  T_4681;
  wire  T_4682;
  wire  T_4683;
  wire  T_4684;
  wire  T_4685;
  wire  T_4686;
  wire  T_4688;
  wire  T_4697;
  wire  T_4699;
  wire  T_4702;
  wire  T_4704;
  wire  T_4746_0;
  wire  T_4746_1;
  wire  T_4746_2;
  wire  T_4746_3;
  wire  T_4746_4;
  wire  T_4746_5;
  wire  T_4746_6;
  wire  T_4746_7;
  wire  T_4746_8;
  wire  T_4746_9;
  wire  T_4746_10;
  wire  T_4746_11;
  wire  T_4746_12;
  wire  T_4746_13;
  wire  T_4746_14;
  wire  T_4746_15;
  wire  T_4746_16;
  wire  T_4746_17;
  wire  T_4746_18;
  wire  T_4746_19;
  wire  T_4746_20;
  wire  T_4746_21;
  wire  T_4746_22;
  wire  T_4746_23;
  wire  T_4746_24;
  wire  T_4746_25;
  wire  T_4746_26;
  wire  T_4746_27;
  wire  T_4746_28;
  wire  T_4746_29;
  wire  T_4746_30;
  wire  T_4746_31;
  wire  T_4781;
  wire  T_4782;
  wire  T_4783;
  wire  T_4784;
  wire  T_4785;
  wire [1:0] T_4791;
  wire [1:0] T_4792;
  wire [2:0] T_4793;
  wire [4:0] T_4794;
  wire  GEN_0;
  wire  GEN_40;
  wire  GEN_41;
  wire  GEN_42;
  wire  GEN_43;
  wire  GEN_44;
  wire  GEN_45;
  wire  GEN_46;
  wire  GEN_47;
  wire  GEN_48;
  wire  GEN_49;
  wire  GEN_50;
  wire  GEN_51;
  wire  GEN_52;
  wire  GEN_53;
  wire  GEN_54;
  wire  GEN_55;
  wire  GEN_56;
  wire  GEN_57;
  wire  GEN_58;
  wire  GEN_59;
  wire  GEN_60;
  wire  GEN_61;
  wire  GEN_62;
  wire  GEN_63;
  wire  GEN_64;
  wire  GEN_65;
  wire  GEN_66;
  wire  GEN_67;
  wire  GEN_68;
  wire  GEN_69;
  wire  GEN_70;
  wire  GEN_1;
  wire  GEN_71;
  wire  GEN_72;
  wire  GEN_73;
  wire  GEN_74;
  wire  GEN_75;
  wire  GEN_76;
  wire  GEN_77;
  wire  GEN_78;
  wire  GEN_79;
  wire  GEN_80;
  wire  GEN_81;
  wire  GEN_82;
  wire  GEN_83;
  wire  GEN_84;
  wire  GEN_85;
  wire  GEN_86;
  wire  GEN_87;
  wire  GEN_88;
  wire  GEN_89;
  wire  GEN_90;
  wire  GEN_91;
  wire  GEN_92;
  wire  GEN_93;
  wire  GEN_94;
  wire  GEN_95;
  wire  GEN_96;
  wire  GEN_97;
  wire  GEN_98;
  wire  GEN_99;
  wire  GEN_100;
  wire  GEN_101;
  wire  T_4811;
  wire  GEN_2;
  wire  GEN_102;
  wire  GEN_103;
  wire  GEN_104;
  wire  GEN_105;
  wire  GEN_106;
  wire  GEN_107;
  wire  GEN_108;
  wire  GEN_109;
  wire  GEN_110;
  wire  GEN_111;
  wire  GEN_112;
  wire  GEN_113;
  wire  GEN_114;
  wire  GEN_115;
  wire  GEN_116;
  wire  GEN_117;
  wire  GEN_118;
  wire  GEN_119;
  wire  GEN_120;
  wire  GEN_121;
  wire  GEN_122;
  wire  GEN_123;
  wire  GEN_124;
  wire  GEN_125;
  wire  GEN_126;
  wire  GEN_127;
  wire  GEN_128;
  wire  GEN_129;
  wire  GEN_130;
  wire  GEN_131;
  wire  GEN_132;
  wire  GEN_3;
  wire  GEN_133;
  wire  GEN_134;
  wire  GEN_135;
  wire  GEN_136;
  wire  GEN_137;
  wire  GEN_138;
  wire  GEN_139;
  wire  GEN_140;
  wire  GEN_141;
  wire  GEN_142;
  wire  GEN_143;
  wire  GEN_144;
  wire  GEN_145;
  wire  GEN_146;
  wire  GEN_147;
  wire  GEN_148;
  wire  GEN_149;
  wire  GEN_150;
  wire  GEN_151;
  wire  GEN_152;
  wire  GEN_153;
  wire  GEN_154;
  wire  GEN_155;
  wire  GEN_156;
  wire  GEN_157;
  wire  GEN_158;
  wire  GEN_159;
  wire  GEN_160;
  wire  GEN_161;
  wire  GEN_162;
  wire  GEN_163;
  wire  T_4814;
  wire  T_4815;
  wire  T_4816;
  wire  T_4817;
  wire  T_4818;
  wire [31:0] T_4820;
  wire [1:0] T_4821;
  wire [3:0] T_4823;
  wire [1:0] T_4824;
  wire [1:0] T_4825;
  wire [3:0] T_4826;
  wire [7:0] T_4827;
  wire [1:0] T_4829;
  wire [3:0] T_4830;
  wire [7:0] T_4834;
  wire [15:0] T_4835;
  wire [1:0] T_4836;
  wire [1:0] T_4837;
  wire [3:0] T_4838;
  wire [1:0] T_4839;
  wire [3:0] T_4841;
  wire [7:0] T_4842;
  wire [1:0] T_4843;
  wire [3:0] T_4845;
  wire [1:0] T_4846;
  wire [3:0] T_4848;
  wire [7:0] T_4849;
  wire [15:0] T_4850;
  wire [31:0] T_4851;
  wire [31:0] T_4852;
  wire  T_4887;
  wire  T_4888;
  wire  T_4889;
  wire  T_4890;
  wire  T_4893;
  wire  T_4894;
  wire  T_4896;
  wire  T_4897;
  wire  T_4898;
  wire  T_4900;
  wire  T_4904;
  wire  T_4906;
  wire  T_4909;
  wire  T_4910;
  wire  T_4916;
  wire  T_4920;
  wire  T_4926;
  wire  T_4969;
  wire  T_4970;
  wire  T_4976;
  wire  T_4980;
  wire  T_4986;
  wire  T_4989;
  wire  T_4990;
  wire  T_4996;
  wire  T_5000;
  wire  T_5006;
  wire  T_5009;
  wire  T_5010;
  wire  T_5016;
  wire  T_5020;
  wire  T_5026;
  wire  T_5089;
  wire  T_5090;
  wire  T_5096;
  wire  T_5100;
  wire  T_5106;
  wire  T_5109;
  wire  T_5110;
  wire  T_5116;
  wire  T_5120;
  wire  T_5126;
  wire  T_5209;
  wire  T_5210;
  wire  T_5216;
  wire  T_5220;
  wire  T_5226;
  wire  T_5249;
  wire  T_5250;
  wire  T_5256;
  wire  T_5260;
  wire  T_5266;
  wire  T_5269;
  wire  T_5270;
  wire  T_5276;
  wire  T_5280;
  wire  T_5286;
  wire  T_5289;
  wire  T_5290;
  wire  T_5296;
  wire  T_5300;
  wire  T_5306;
  wire  T_5309;
  wire  T_5310;
  wire  T_5316;
  wire  T_5320;
  wire  T_5326;
  wire  T_5369;
  wire  T_5370;
  wire  T_5376;
  wire  T_5380;
  wire  T_5386;
  wire  T_5389;
  wire  T_5390;
  wire  T_5396;
  wire  T_5400;
  wire  T_5406;
  wire  T_5449;
  wire  T_5450;
  wire  T_5456;
  wire  T_5460;
  wire  T_5466;
  wire  T_5469;
  wire  T_5470;
  wire  T_5476;
  wire  T_5480;
  wire  T_5486;
  wire  T_5535;
  wire  T_5537;
  wire  T_5539;
  wire  T_5541;
  wire  T_5543;
  wire  T_5545;
  wire  T_5547;
  wire  T_5549;
  wire  T_5555;
  wire  T_5556;
  wire  T_5557;
  wire  T_5558;
  wire  T_5559;
  wire  T_5560;
  wire  T_5561;
  wire  T_5563;
  wire  T_5564;
  wire  T_5565;
  wire  T_5566;
  wire  T_5567;
  wire  T_5568;
  wire  T_5569;
  wire  T_5571;
  wire  T_5572;
  wire  T_5573;
  wire  T_5574;
  wire  T_5575;
  wire  T_5576;
  wire  T_5577;
  wire  T_5579;
  wire  T_5580;
  wire  T_5581;
  wire  T_5582;
  wire  T_5583;
  wire  T_5584;
  wire  T_5585;
  wire  T_5593;
  wire  T_5601;
  wire  T_5609;
  wire  T_5617;
  wire  T_5624;
  wire  T_5625;
  wire  T_5632;
  wire  T_5633;
  wire  T_5640;
  wire  T_5641;
  wire  T_5648;
  wire  T_5649;
  wire  T_5655;
  wire  T_5656;
  wire  T_5657;
  wire  T_5663;
  wire  T_5664;
  wire  T_5665;
  wire  T_5671;
  wire  T_5672;
  wire  T_5673;
  wire  T_5679;
  wire  T_5680;
  wire  T_5681;
  wire  T_5686;
  wire  T_5687;
  wire  T_5688;
  wire  T_5689;
  wire  T_5694;
  wire  T_5695;
  wire  T_5696;
  wire  T_5697;
  wire  T_5702;
  wire  T_5703;
  wire  T_5704;
  wire  T_5705;
  wire  T_5710;
  wire  T_5711;
  wire  T_5712;
  wire  T_5713;
  wire  T_5717;
  wire  T_5718;
  wire  T_5719;
  wire  T_5720;
  wire  T_5721;
  wire  T_5725;
  wire  T_5726;
  wire  T_5727;
  wire  T_5728;
  wire  T_5729;
  wire  T_5733;
  wire  T_5734;
  wire  T_5735;
  wire  T_5736;
  wire  T_5737;
  wire  T_5741;
  wire  T_5742;
  wire  T_5743;
  wire  T_5744;
  wire  T_5745;
  wire  T_5748;
  wire  T_5749;
  wire  T_5750;
  wire  T_5751;
  wire  T_5752;
  wire  T_5753;
  wire  T_5756;
  wire  T_5757;
  wire  T_5758;
  wire  T_5759;
  wire  T_5760;
  wire  T_5761;
  wire  T_5764;
  wire  T_5765;
  wire  T_5766;
  wire  T_5767;
  wire  T_5768;
  wire  T_5769;
  wire  T_5772;
  wire  T_5773;
  wire  T_5774;
  wire  T_5775;
  wire  T_5776;
  wire  T_5777;
  wire  T_5779;
  wire  T_5780;
  wire  T_5781;
  wire  T_5782;
  wire  T_5783;
  wire  T_5784;
  wire  T_5785;
  wire  T_5787;
  wire  T_5788;
  wire  T_5789;
  wire  T_5790;
  wire  T_5791;
  wire  T_5792;
  wire  T_5793;
  wire  T_5795;
  wire  T_5796;
  wire  T_5797;
  wire  T_5798;
  wire  T_5799;
  wire  T_5800;
  wire  T_5801;
  wire  T_5803;
  wire  T_5804;
  wire  T_5805;
  wire  T_5806;
  wire  T_5807;
  wire  T_5808;
  wire  T_5809;
  wire  T_5815;
  wire  T_5817;
  wire  T_5819;
  wire  T_5821;
  wire  T_5823;
  wire  T_5825;
  wire  T_5827;
  wire  T_5829;
  wire  T_5831;
  wire  T_5833;
  wire  T_5835;
  wire  T_5837;
  wire  T_5839;
  wire  T_5841;
  wire  T_5843;
  wire  T_5845;
  wire  T_5851;
  wire  T_5853;
  wire  T_5855;
  wire  T_5857;
  wire  T_5859;
  wire  T_5861;
  wire  T_5863;
  wire  T_5865;
  wire  T_5871;
  wire  T_5872;
  wire  T_5874;
  wire  T_5875;
  wire  T_5877;
  wire  T_5878;
  wire  T_5880;
  wire  T_5881;
  wire  T_5884;
  wire  T_5887;
  wire  T_5890;
  wire  T_5893;
  wire  T_5895;
  wire  T_5896;
  wire  T_5898;
  wire  T_5899;
  wire  T_5901;
  wire  T_5902;
  wire  T_5904;
  wire  T_5905;
  wire  T_5907;
  wire  T_5908;
  wire  T_5909;
  wire  T_5911;
  wire  T_5912;
  wire  T_5913;
  wire  T_5915;
  wire  T_5916;
  wire  T_5917;
  wire  T_5919;
  wire  T_5920;
  wire  T_5921;
  wire  T_5925;
  wire  T_5929;
  wire  T_5933;
  wire  T_5937;
  wire  T_5940;
  wire  T_5941;
  wire  T_5944;
  wire  T_5945;
  wire  T_5948;
  wire  T_5949;
  wire  T_5952;
  wire  T_5953;
  wire  T_5955;
  wire  T_5956;
  wire  T_5957;
  wire  T_5959;
  wire  T_5960;
  wire  T_5961;
  wire  T_5963;
  wire  T_5964;
  wire  T_5965;
  wire  T_5967;
  wire  T_5968;
  wire  T_5969;
  wire  T_5971;
  wire  T_5973;
  wire  T_5975;
  wire  T_5977;
  wire  T_5979;
  wire  T_5981;
  wire  T_5983;
  wire  T_5985;
  wire  T_5987;
  wire  T_5988;
  wire  T_5990;
  wire  T_5991;
  wire  T_5993;
  wire  T_5994;
  wire  T_5996;
  wire  T_5997;
  wire  T_6000;
  wire  T_6003;
  wire  T_6006;
  wire  T_6009;
  wire  T_6011;
  wire  T_6012;
  wire  T_6014;
  wire  T_6015;
  wire  T_6017;
  wire  T_6018;
  wire  T_6020;
  wire  T_6021;
  wire  T_6062_0;
  wire  T_6062_1;
  wire  T_6062_2;
  wire  T_6062_3;
  wire  T_6062_4;
  wire  T_6062_5;
  wire  T_6062_6;
  wire  T_6062_7;
  wire  T_6062_8;
  wire  T_6062_9;
  wire  T_6062_10;
  wire  T_6062_11;
  wire  T_6062_12;
  wire  T_6062_13;
  wire  T_6062_14;
  wire  T_6062_15;
  wire  T_6062_16;
  wire  T_6062_17;
  wire  T_6062_18;
  wire  T_6062_19;
  wire  T_6062_20;
  wire  T_6062_21;
  wire  T_6062_22;
  wire  T_6062_23;
  wire  T_6062_24;
  wire  T_6062_25;
  wire  T_6062_26;
  wire  T_6062_27;
  wire  T_6062_28;
  wire  T_6062_29;
  wire  T_6062_30;
  wire  T_6062_31;
  wire [31:0] T_6133_0;
  wire [31:0] T_6133_1;
  wire [31:0] T_6133_2;
  wire [31:0] T_6133_3;
  wire [31:0] T_6133_4;
  wire [31:0] T_6133_5;
  wire [31:0] T_6133_6;
  wire [31:0] T_6133_7;
  wire [31:0] T_6133_8;
  wire [31:0] T_6133_9;
  wire [31:0] T_6133_10;
  wire [31:0] T_6133_11;
  wire [31:0] T_6133_12;
  wire [31:0] T_6133_13;
  wire [31:0] T_6133_14;
  wire [31:0] T_6133_15;
  wire [31:0] T_6133_16;
  wire [31:0] T_6133_17;
  wire [31:0] T_6133_18;
  wire [31:0] T_6133_19;
  wire [31:0] T_6133_20;
  wire [31:0] T_6133_21;
  wire [31:0] T_6133_22;
  wire [31:0] T_6133_23;
  wire [31:0] T_6133_24;
  wire [31:0] T_6133_25;
  wire [31:0] T_6133_26;
  wire [31:0] T_6133_27;
  wire [31:0] T_6133_28;
  wire [31:0] T_6133_29;
  wire [31:0] T_6133_30;
  wire [31:0] T_6133_31;
  wire  GEN_4;
  wire  GEN_164;
  wire  GEN_165;
  wire  GEN_166;
  wire  GEN_167;
  wire  GEN_168;
  wire  GEN_169;
  wire  GEN_170;
  wire  GEN_171;
  wire  GEN_172;
  wire  GEN_173;
  wire  GEN_174;
  wire  GEN_175;
  wire  GEN_176;
  wire  GEN_177;
  wire  GEN_178;
  wire  GEN_179;
  wire  GEN_180;
  wire  GEN_181;
  wire  GEN_182;
  wire  GEN_183;
  wire  GEN_184;
  wire  GEN_185;
  wire  GEN_186;
  wire  GEN_187;
  wire  GEN_188;
  wire  GEN_189;
  wire  GEN_190;
  wire  GEN_191;
  wire  GEN_192;
  wire  GEN_193;
  wire  GEN_194;
  wire [31:0] GEN_5;
  wire [31:0] GEN_195;
  wire [31:0] GEN_196;
  wire [31:0] GEN_197;
  wire [31:0] GEN_198;
  wire [31:0] GEN_199;
  wire [31:0] GEN_200;
  wire [31:0] GEN_201;
  wire [31:0] GEN_202;
  wire [31:0] GEN_203;
  wire [31:0] GEN_204;
  wire [31:0] GEN_205;
  wire [31:0] GEN_206;
  wire [31:0] GEN_207;
  wire [31:0] GEN_208;
  wire [31:0] GEN_209;
  wire [31:0] GEN_210;
  wire [31:0] GEN_211;
  wire [31:0] GEN_212;
  wire [31:0] GEN_213;
  wire [31:0] GEN_214;
  wire [31:0] GEN_215;
  wire [31:0] GEN_216;
  wire [31:0] GEN_217;
  wire [31:0] GEN_218;
  wire [31:0] GEN_219;
  wire [31:0] GEN_220;
  wire [31:0] GEN_221;
  wire [31:0] GEN_222;
  wire [31:0] GEN_223;
  wire [31:0] GEN_224;
  wire [31:0] GEN_225;
  wire [31:0] T_6170;
  wire [1:0] T_6171;
  wire [4:0] T_6173;
  wire [2:0] T_6174;
  wire [2:0] T_6185_opcode;
  wire [1:0] T_6185_param;
  wire [2:0] T_6185_size;
  wire [4:0] T_6185_source;
  wire  T_6185_sink;
  wire [1:0] T_6185_addr_lo;
  wire [31:0] T_6185_data;
  wire  T_6185_error;
  wire [2:0] GEN_259 = 3'b0;
  reg [31:0] GEN_307;
  wire [1:0] GEN_260 = 2'b0;
  reg [31:0] GEN_308;
  wire [2:0] GEN_261 = 3'b0;
  reg [31:0] GEN_309;
  wire [4:0] GEN_262 = 5'b0;
  reg [31:0] GEN_310;
  wire [28:0] GEN_263 = 29'b0;
  reg [31:0] GEN_311;
  wire [3:0] GEN_264 = 4'b0;
  reg [31:0] GEN_312;
  wire [31:0] GEN_265 = 32'b0;
  reg [31:0] GEN_313;
  wire [2:0] GEN_266 = 3'b0;
  reg [31:0] GEN_314;
  wire [1:0] GEN_267 = 2'b0;
  reg [31:0] GEN_315;
  wire [2:0] GEN_268 = 3'b0;
  reg [31:0] GEN_316;
  wire [6:0] GEN_269 = 7'b0;
  reg [31:0] GEN_317;
  wire [29:0] GEN_270 = 30'b0;
  reg [31:0] GEN_318;
  wire GEN_271 = 1'b0;
  reg [31:0] GEN_319;
  wire [7:0] GEN_272 = 8'b0;
  reg [31:0] GEN_320;
  sirv_qspi_fifo fifo (
    .clock(fifo_clock),
    .reset(fifo_reset),
    .io_ctrl_fmt_proto(fifo_io_ctrl_fmt_proto),
    .io_ctrl_fmt_endian(fifo_io_ctrl_fmt_endian),
    .io_ctrl_fmt_iodir(fifo_io_ctrl_fmt_iodir),
    .io_ctrl_fmt_len(fifo_io_ctrl_fmt_len),
    .io_ctrl_cs_mode(fifo_io_ctrl_cs_mode),
    .io_ctrl_wm_tx(fifo_io_ctrl_wm_tx),
    .io_ctrl_wm_rx(fifo_io_ctrl_wm_rx),
    .io_link_tx_ready(fifo_io_link_tx_ready),
    .io_link_tx_valid(fifo_io_link_tx_valid),
    .io_link_tx_bits(fifo_io_link_tx_bits),
    .io_link_rx_valid(fifo_io_link_rx_valid),
    .io_link_rx_bits(fifo_io_link_rx_bits),
    .io_link_cnt(fifo_io_link_cnt),
    .io_link_fmt_proto(fifo_io_link_fmt_proto),
    .io_link_fmt_endian(fifo_io_link_fmt_endian),
    .io_link_fmt_iodir(fifo_io_link_fmt_iodir),
    .io_link_cs_set(fifo_io_link_cs_set),
    .io_link_cs_clear(fifo_io_link_cs_clear),
    .io_link_cs_hold(fifo_io_link_cs_hold),
    .io_link_active(fifo_io_link_active),
    .io_link_lock(fifo_io_link_lock),
    .io_tx_ready(fifo_io_tx_ready),
    .io_tx_valid(fifo_io_tx_valid),
    .io_tx_bits(fifo_io_tx_bits),
    .io_rx_ready(fifo_io_rx_ready),
    .io_rx_valid(fifo_io_rx_valid),
    .io_rx_bits(fifo_io_rx_bits),
    .io_ip_txwm(fifo_io_ip_txwm),
    .io_ip_rxwm(fifo_io_ip_rxwm)
  );
  sirv_qspi_media mac (
    .clock(mac_clock),
    .reset(mac_reset),
    .io_port_sck(mac_io_port_sck),
    .io_port_dq_0_i(mac_io_port_dq_0_i),
    .io_port_dq_0_o(mac_io_port_dq_0_o),
    .io_port_dq_0_oe(mac_io_port_dq_0_oe),
    .io_port_dq_1_i(mac_io_port_dq_1_i),
    .io_port_dq_1_o(mac_io_port_dq_1_o),
    .io_port_dq_1_oe(mac_io_port_dq_1_oe),
    .io_port_dq_2_i(mac_io_port_dq_2_i),
    .io_port_dq_2_o(mac_io_port_dq_2_o),
    .io_port_dq_2_oe(mac_io_port_dq_2_oe),
    .io_port_dq_3_i(mac_io_port_dq_3_i),
    .io_port_dq_3_o(mac_io_port_dq_3_o),
    .io_port_dq_3_oe(mac_io_port_dq_3_oe),
    .io_port_cs_0(mac_io_port_cs_0),
    .io_ctrl_sck_div(mac_io_ctrl_sck_div),
    .io_ctrl_sck_pol(mac_io_ctrl_sck_pol),
    .io_ctrl_sck_pha(mac_io_ctrl_sck_pha),
    .io_ctrl_dla_cssck(mac_io_ctrl_dla_cssck),
    .io_ctrl_dla_sckcs(mac_io_ctrl_dla_sckcs),
    .io_ctrl_dla_intercs(mac_io_ctrl_dla_intercs),
    .io_ctrl_dla_interxfr(mac_io_ctrl_dla_interxfr),
    .io_ctrl_cs_id(mac_io_ctrl_cs_id),
    .io_ctrl_cs_dflt_0(mac_io_ctrl_cs_dflt_0),
    .io_link_tx_ready(mac_io_link_tx_ready),
    .io_link_tx_valid(mac_io_link_tx_valid),
    .io_link_tx_bits(mac_io_link_tx_bits),
    .io_link_rx_valid(mac_io_link_rx_valid),
    .io_link_rx_bits(mac_io_link_rx_bits),
    .io_link_cnt(mac_io_link_cnt),
    .io_link_fmt_proto(mac_io_link_fmt_proto),
    .io_link_fmt_endian(mac_io_link_fmt_endian),
    .io_link_fmt_iodir(mac_io_link_fmt_iodir),
    .io_link_cs_set(mac_io_link_cs_set),
    .io_link_cs_clear(mac_io_link_cs_clear),
    .io_link_cs_hold(mac_io_link_cs_hold),
    .io_link_active(mac_io_link_active)
  );
  sirv_qspi_flashmap flash (
    .clock(flash_clock),
    .reset(flash_reset),
    .io_en(flash_io_en),
    .io_ctrl_insn_cmd_proto(flash_io_ctrl_insn_cmd_proto),
    .io_ctrl_insn_cmd_code(flash_io_ctrl_insn_cmd_code),
    .io_ctrl_insn_cmd_en(flash_io_ctrl_insn_cmd_en),
    .io_ctrl_insn_addr_proto(flash_io_ctrl_insn_addr_proto),
    .io_ctrl_insn_addr_len(flash_io_ctrl_insn_addr_len),
    .io_ctrl_insn_pad_code(flash_io_ctrl_insn_pad_code),
    .io_ctrl_insn_pad_cnt(flash_io_ctrl_insn_pad_cnt),
    .io_ctrl_insn_data_proto(flash_io_ctrl_insn_data_proto),
    .io_ctrl_fmt_endian(flash_io_ctrl_fmt_endian),
    .io_addr_ready(flash_io_addr_ready),
    .io_addr_valid(flash_io_addr_valid),
    .io_addr_bits_next(flash_io_addr_bits_next),
    .io_addr_bits_hold(flash_io_addr_bits_hold),
    .io_data_ready(flash_io_data_ready),
    .io_data_valid(flash_io_data_valid),
    .io_data_bits(flash_io_data_bits),
    .io_link_tx_ready(flash_io_link_tx_ready),
    .io_link_tx_valid(flash_io_link_tx_valid),
    .io_link_tx_bits(flash_io_link_tx_bits),
    .io_link_rx_valid(flash_io_link_rx_valid),
    .io_link_rx_bits(flash_io_link_rx_bits),
    .io_link_cnt(flash_io_link_cnt),
    .io_link_fmt_proto(flash_io_link_fmt_proto),
    .io_link_fmt_endian(flash_io_link_fmt_endian),
    .io_link_fmt_iodir(flash_io_link_fmt_iodir),
    .io_link_cs_set(flash_io_link_cs_set),
    .io_link_cs_clear(flash_io_link_cs_clear),
    .io_link_cs_hold(flash_io_link_cs_hold),
    .io_link_active(flash_io_link_active),
    .io_link_lock(flash_io_link_lock)
  );
  sirv_qspi_arbiter arb (
    .clock(arb_clock),
    .reset(arb_reset),
    .io_inner_0_tx_ready(arb_io_inner_0_tx_ready),
    .io_inner_0_tx_valid(arb_io_inner_0_tx_valid),
    .io_inner_0_tx_bits(arb_io_inner_0_tx_bits),
    .io_inner_0_rx_valid(arb_io_inner_0_rx_valid),
    .io_inner_0_rx_bits(arb_io_inner_0_rx_bits),
    .io_inner_0_cnt(arb_io_inner_0_cnt),
    .io_inner_0_fmt_proto(arb_io_inner_0_fmt_proto),
    .io_inner_0_fmt_endian(arb_io_inner_0_fmt_endian),
    .io_inner_0_fmt_iodir(arb_io_inner_0_fmt_iodir),
    .io_inner_0_cs_set(arb_io_inner_0_cs_set),
    .io_inner_0_cs_clear(arb_io_inner_0_cs_clear),
    .io_inner_0_cs_hold(arb_io_inner_0_cs_hold),
    .io_inner_0_active(arb_io_inner_0_active),
    .io_inner_0_lock(arb_io_inner_0_lock),
    .io_inner_1_tx_ready(arb_io_inner_1_tx_ready),
    .io_inner_1_tx_valid(arb_io_inner_1_tx_valid),
    .io_inner_1_tx_bits(arb_io_inner_1_tx_bits),
    .io_inner_1_rx_valid(arb_io_inner_1_rx_valid),
    .io_inner_1_rx_bits(arb_io_inner_1_rx_bits),
    .io_inner_1_cnt(arb_io_inner_1_cnt),
    .io_inner_1_fmt_proto(arb_io_inner_1_fmt_proto),
    .io_inner_1_fmt_endian(arb_io_inner_1_fmt_endian),
    .io_inner_1_fmt_iodir(arb_io_inner_1_fmt_iodir),
    .io_inner_1_cs_set(arb_io_inner_1_cs_set),
    .io_inner_1_cs_clear(arb_io_inner_1_cs_clear),
    .io_inner_1_cs_hold(arb_io_inner_1_cs_hold),
    .io_inner_1_active(arb_io_inner_1_active),
    .io_inner_1_lock(arb_io_inner_1_lock),
    .io_outer_tx_ready(arb_io_outer_tx_ready),
    .io_outer_tx_valid(arb_io_outer_tx_valid),
    .io_outer_tx_bits(arb_io_outer_tx_bits),
    .io_outer_rx_valid(arb_io_outer_rx_valid),
    .io_outer_rx_bits(arb_io_outer_rx_bits),
    .io_outer_cnt(arb_io_outer_cnt),
    .io_outer_fmt_proto(arb_io_outer_fmt_proto),
    .io_outer_fmt_endian(arb_io_outer_fmt_endian),
    .io_outer_fmt_iodir(arb_io_outer_fmt_iodir),
    .io_outer_cs_set(arb_io_outer_cs_set),
    .io_outer_cs_clear(arb_io_outer_cs_clear),
    .io_outer_cs_hold(arb_io_outer_cs_hold),
    .io_outer_active(arb_io_outer_active),
    .io_sel(arb_io_sel)
  );
  assign io_port_sck = mac_io_port_sck;
  assign io_port_dq_0_o = mac_io_port_dq_0_o;
  assign io_port_dq_0_oe = mac_io_port_dq_0_oe;
  assign io_port_dq_1_o = mac_io_port_dq_1_o;
  assign io_port_dq_1_oe = mac_io_port_dq_1_oe;
  assign io_port_dq_2_o = mac_io_port_dq_2_o;
  assign io_port_dq_2_oe = mac_io_port_dq_2_oe;
  assign io_port_dq_3_o = mac_io_port_dq_3_o;
  assign io_port_dq_3_oe = mac_io_port_dq_3_oe;
  assign io_port_cs_0 = mac_io_port_cs_0;
  assign io_tl_i_0_0 = T_1917;
  assign io_tl_r_0_a_ready = T_2029_ready;
  assign io_tl_r_0_b_valid = 1'h0;
  assign io_tl_r_0_b_bits_opcode = GEN_259;
  assign io_tl_r_0_b_bits_param = GEN_260;
  assign io_tl_r_0_b_bits_size = GEN_261;
  assign io_tl_r_0_b_bits_source = GEN_262;
  assign io_tl_r_0_b_bits_address = GEN_263;
  assign io_tl_r_0_b_bits_mask = GEN_264;
  assign io_tl_r_0_b_bits_data = GEN_265;
  assign io_tl_r_0_c_ready = 1'h1;
  assign io_tl_r_0_d_valid = T_2068_valid;
  assign io_tl_r_0_d_bits_opcode = {{2'd0}, T_2068_bits_read};
  assign io_tl_r_0_d_bits_param = T_6185_param;
  assign io_tl_r_0_d_bits_size = T_6185_size;
  assign io_tl_r_0_d_bits_source = T_6185_source;
  assign io_tl_r_0_d_bits_sink = T_6185_sink;
  assign io_tl_r_0_d_bits_addr_lo = T_6185_addr_lo;
  assign io_tl_r_0_d_bits_data = T_2068_bits_data;
  assign io_tl_r_0_d_bits_error = T_6185_error;
  assign io_tl_r_0_e_ready = 1'h1;
  assign io_tl_f_0_a_ready = flash_io_addr_ready;
  assign io_tl_f_0_b_valid = 1'h0;
  assign io_tl_f_0_b_bits_opcode = GEN_266;
  assign io_tl_f_0_b_bits_param = GEN_267;
  assign io_tl_f_0_b_bits_size = GEN_268;
  assign io_tl_f_0_b_bits_source = GEN_269;
  assign io_tl_f_0_b_bits_address = GEN_270;
  assign io_tl_f_0_b_bits_mask = GEN_271;
  assign io_tl_f_0_b_bits_data = GEN_272;
  assign io_tl_f_0_c_ready = 1'h1;
  assign io_tl_f_0_d_valid = flash_io_data_valid;
  assign io_tl_f_0_d_bits_opcode = T_1949_opcode;
  assign io_tl_f_0_d_bits_param = T_1949_param;
  assign io_tl_f_0_d_bits_size = T_1949_size;
  assign io_tl_f_0_d_bits_source = T_1949_source;
  assign io_tl_f_0_d_bits_sink = T_1949_sink;
  assign io_tl_f_0_d_bits_addr_lo = T_1949_addr_lo;
  assign io_tl_f_0_d_bits_data = T_1949_data;
  assign io_tl_f_0_d_bits_error = T_1949_error;
  assign io_tl_f_0_e_ready = 1'h1;
  assign T_1840_fmt_proto = 2'h0;
  assign T_1840_fmt_endian = 1'h0;
  assign T_1840_fmt_iodir = 1'h0;
  assign T_1840_fmt_len = 4'h8;
  assign T_1840_sck_div = 12'h3;
  assign T_1840_sck_pol = 1'h0;
  assign T_1840_sck_pha = 1'h0;
  assign T_1840_cs_id = 1'h0;
  assign T_1840_cs_dflt_0 = 1'h1;
  assign T_1840_cs_mode = 2'h0;
  assign T_1840_dla_cssck = 8'h1;
  assign T_1840_dla_sckcs = 8'h1;
  assign T_1840_dla_intercs = 8'h1;
  assign T_1840_dla_interxfr = 8'h0;
  assign T_1840_wm_tx = 4'h0;
  assign T_1840_wm_rx = 4'h0;
  assign fifo_clock = clock;
  assign fifo_reset = reset;
  assign fifo_io_ctrl_fmt_proto = ctrl_fmt_proto;
  assign fifo_io_ctrl_fmt_endian = ctrl_fmt_endian;
  assign fifo_io_ctrl_fmt_iodir = ctrl_fmt_iodir;
  assign fifo_io_ctrl_fmt_len = ctrl_fmt_len;
  assign fifo_io_ctrl_cs_mode = ctrl_cs_mode;
  assign fifo_io_ctrl_wm_tx = ctrl_wm_tx;
  assign fifo_io_ctrl_wm_rx = ctrl_wm_rx;
  assign fifo_io_link_tx_ready = arb_io_inner_1_tx_ready;
  assign fifo_io_link_rx_valid = arb_io_inner_1_rx_valid;
  assign fifo_io_link_rx_bits = arb_io_inner_1_rx_bits;
  assign fifo_io_link_active = arb_io_inner_1_active;
  assign fifo_io_tx_valid = T_3476;
  assign fifo_io_tx_bits = T_2677;
  assign fifo_io_rx_ready = T_3832;
  assign mac_clock = clock;
  assign mac_reset = reset;
  assign mac_io_port_dq_0_i = io_port_dq_0_i;
  assign mac_io_port_dq_1_i = io_port_dq_1_i;
  assign mac_io_port_dq_2_i = io_port_dq_2_i;
  assign mac_io_port_dq_3_i = io_port_dq_3_i;
  assign mac_io_ctrl_sck_div = ctrl_sck_div;
  assign mac_io_ctrl_sck_pol = ctrl_sck_pol;
  assign mac_io_ctrl_sck_pha = ctrl_sck_pha;
  assign mac_io_ctrl_dla_cssck = ctrl_dla_cssck;
  assign mac_io_ctrl_dla_sckcs = ctrl_dla_sckcs;
  assign mac_io_ctrl_dla_intercs = ctrl_dla_intercs;
  assign mac_io_ctrl_dla_interxfr = ctrl_dla_interxfr;
  assign mac_io_ctrl_cs_id = ctrl_cs_id;
  assign mac_io_ctrl_cs_dflt_0 = ctrl_cs_dflt_0;
  assign mac_io_link_tx_valid = arb_io_outer_tx_valid;
  assign mac_io_link_tx_bits = arb_io_outer_tx_bits;
  assign mac_io_link_cnt = arb_io_outer_cnt;
  assign mac_io_link_fmt_proto = arb_io_outer_fmt_proto;
  assign mac_io_link_fmt_endian = arb_io_outer_fmt_endian;
  assign mac_io_link_fmt_iodir = arb_io_outer_fmt_iodir;
  assign mac_io_link_cs_set = arb_io_outer_cs_set;
  assign mac_io_link_cs_clear = arb_io_outer_cs_clear;
  assign mac_io_link_cs_hold = arb_io_outer_cs_hold;
  assign T_1906_txwm = T_1912;
  assign T_1906_rxwm = T_1911;
  assign T_1910 = 2'h0;
  assign T_1911 = T_1910[0];
  assign T_1912 = T_1910[1];
  assign T_1915 = fifo_io_ip_txwm & ie_txwm;
  assign T_1916 = fifo_io_ip_rxwm & ie_rxwm;
  assign T_1917 = T_1915 | T_1916;
  assign T_1921 = fifo_io_tx_ready == 1'h0;
  assign T_1924 = fifo_io_rx_valid == 1'h0;
  assign flash_clock = clock;
  assign flash_reset = reset;
  assign flash_io_en = flash_en;
  assign flash_io_ctrl_insn_cmd_proto = insn_cmd_proto;
  assign flash_io_ctrl_insn_cmd_code = insn_cmd_code;
  assign flash_io_ctrl_insn_cmd_en = insn_cmd_en;
  assign flash_io_ctrl_insn_addr_proto = insn_addr_proto;
  assign flash_io_ctrl_insn_addr_len = insn_addr_len;
  assign flash_io_ctrl_insn_pad_code = insn_pad_code;
  assign flash_io_ctrl_insn_pad_cnt = insn_pad_cnt;
  assign flash_io_ctrl_insn_data_proto = insn_data_proto;
  assign flash_io_ctrl_fmt_endian = ctrl_fmt_endian;
  assign flash_io_addr_valid = io_tl_f_0_a_valid;
  assign flash_io_addr_bits_next = {{3'd0}, T_1936};
  assign flash_io_addr_bits_hold = {{3'd0}, T_1937};
  assign flash_io_data_ready = io_tl_f_0_d_ready;
  assign flash_io_link_tx_ready = arb_io_inner_0_tx_ready;
  assign flash_io_link_rx_valid = arb_io_inner_0_rx_valid;
  assign flash_io_link_rx_bits = arb_io_inner_0_rx_bits;
  assign flash_io_link_active = arb_io_inner_0_active;
  assign arb_clock = clock;
  assign arb_reset = reset;
  assign arb_io_inner_0_tx_valid = flash_io_link_tx_valid;
  assign arb_io_inner_0_tx_bits = flash_io_link_tx_bits;
  assign arb_io_inner_0_cnt = flash_io_link_cnt;
  assign arb_io_inner_0_fmt_proto = flash_io_link_fmt_proto;
  assign arb_io_inner_0_fmt_endian = flash_io_link_fmt_endian;
  assign arb_io_inner_0_fmt_iodir = flash_io_link_fmt_iodir;
  assign arb_io_inner_0_cs_set = flash_io_link_cs_set;
  assign arb_io_inner_0_cs_clear = flash_io_link_cs_clear;
  assign arb_io_inner_0_cs_hold = flash_io_link_cs_hold;
  assign arb_io_inner_0_lock = flash_io_link_lock;
  assign arb_io_inner_1_tx_valid = fifo_io_link_tx_valid;
  assign arb_io_inner_1_tx_bits = fifo_io_link_tx_bits;
  assign arb_io_inner_1_cnt = fifo_io_link_cnt;
  assign arb_io_inner_1_fmt_proto = fifo_io_link_fmt_proto;
  assign arb_io_inner_1_fmt_endian = fifo_io_link_fmt_endian;
  assign arb_io_inner_1_fmt_iodir = fifo_io_link_fmt_iodir;
  assign arb_io_inner_1_cs_set = fifo_io_link_cs_set;
  assign arb_io_inner_1_cs_clear = fifo_io_link_cs_clear;
  assign arb_io_inner_1_cs_hold = fifo_io_link_cs_hold;
  assign arb_io_inner_1_lock = fifo_io_link_lock;
  assign arb_io_outer_tx_ready = mac_io_link_tx_ready;
  assign arb_io_outer_rx_valid = mac_io_link_rx_valid;
  assign arb_io_outer_rx_bits = mac_io_link_rx_bits;
  assign arb_io_outer_active = mac_io_link_active;
  assign arb_io_sel = T_2005;
  assign T_1935 = io_tl_f_0_a_ready & io_tl_f_0_a_valid;
  assign GEN_6 = T_1935 ? io_tl_f_0_a_bits_opcode : a_opcode;
  assign GEN_7 = T_1935 ? io_tl_f_0_a_bits_param : a_param;
  assign GEN_8 = T_1935 ? io_tl_f_0_a_bits_size : a_size;
  assign GEN_9 = T_1935 ? io_tl_f_0_a_bits_source : a_source;
  assign GEN_10 = T_1935 ? io_tl_f_0_a_bits_address : a_address;
  assign GEN_11 = T_1935 ? io_tl_f_0_a_bits_mask : a_mask;
  assign GEN_12 = T_1935 ? io_tl_f_0_a_bits_data : a_data;
  assign T_1936 = io_tl_f_0_a_bits_address[28:0];
  assign T_1937 = a_address[28:0];
  assign T_1949_opcode = 3'h1;
  assign T_1949_param = 2'h0;
  assign T_1949_size = a_size;
  assign T_1949_source = a_source;
  assign T_1949_sink = 1'h0;
  assign T_1949_addr_lo = 1'h0;
  assign T_1949_data = flash_io_data_bits;
  assign T_1949_error = 1'h0;
  assign T_1973_cmd_proto = 2'h0;
  assign T_1973_cmd_code = 8'h3;
  assign T_1973_cmd_en = 1'h1;
  assign T_1973_addr_proto = 2'h0;
  assign T_1973_addr_len = 3'h3;
  assign T_1973_pad_code = 8'h0;
  assign T_1973_pad_cnt = 4'h0;
  assign T_1973_data_proto = 2'h0;
  assign T_2005 = flash_en == 1'h0;
  assign T_2029_ready = T_4815;
  assign T_2029_valid = io_tl_r_0_a_valid;
  assign T_2029_bits_read = T_2046;
  assign T_2029_bits_index = T_2047[9:0];
  assign T_2029_bits_data = io_tl_r_0_a_bits_data;
  assign T_2029_bits_mask = io_tl_r_0_a_bits_mask;
  assign T_2029_bits_extra = T_2050;
  assign T_2046 = io_tl_r_0_a_bits_opcode == 3'h4;
  assign T_2047 = io_tl_r_0_a_bits_address[28:2];
  assign T_2048 = io_tl_r_0_a_bits_address[1:0];
  assign T_2049 = {T_2048,io_tl_r_0_a_bits_source};
  assign T_2050 = {T_2049,io_tl_r_0_a_bits_size};
  assign T_2068_ready = io_tl_r_0_d_ready;
  assign T_2068_valid = T_4818;
  assign T_2068_bits_read = T_2104_bits_read;
  assign T_2068_bits_data = T_6170;
  assign T_2068_bits_extra = T_2104_bits_extra;
  assign T_2104_ready = T_4817;
  assign T_2104_valid = T_4816;
  assign T_2104_bits_read = T_2029_bits_read;
  assign T_2104_bits_index = T_2029_bits_index;
  assign T_2104_bits_data = T_2029_bits_data;
  assign T_2104_bits_mask = T_2029_bits_mask;
  assign T_2104_bits_extra = T_2029_bits_extra;
  assign T_2189 = T_2104_bits_index & 10'h3e0;
  assign T_2191 = T_2189 == 10'h0;
  assign T_2197 = T_2104_bits_index ^ 10'h5;
  assign T_2198 = T_2197 & 10'h3e0;
  assign T_2200 = T_2198 == 10'h0;
  assign T_2206 = T_2104_bits_index ^ 10'ha;
  assign T_2207 = T_2206 & 10'h3e0;
  assign T_2209 = T_2207 == 10'h0;
  assign T_2215 = T_2104_bits_index ^ 10'h18;
  assign T_2216 = T_2215 & 10'h3e0;
  assign T_2218 = T_2216 == 10'h0;
  assign T_2224 = T_2104_bits_index ^ 10'h19;
  assign T_2225 = T_2224 & 10'h3e0;
  assign T_2227 = T_2225 == 10'h0;
  assign T_2233 = T_2104_bits_index ^ 10'h14;
  assign T_2234 = T_2233 & 10'h3e0;
  assign T_2236 = T_2234 == 10'h0;
  assign T_2242 = T_2104_bits_index ^ 10'h1d;
  assign T_2243 = T_2242 & 10'h3e0;
  assign T_2245 = T_2243 == 10'h0;
  assign T_2251 = T_2104_bits_index ^ 10'h1;
  assign T_2252 = T_2251 & 10'h3e0;
  assign T_2254 = T_2252 == 10'h0;
  assign T_2260 = T_2104_bits_index ^ 10'h6;
  assign T_2261 = T_2260 & 10'h3e0;
  assign T_2263 = T_2261 == 10'h0;
  assign T_2269 = T_2104_bits_index ^ 10'h1c;
  assign T_2270 = T_2269 & 10'h3e0;
  assign T_2272 = T_2270 == 10'h0;
  assign T_2278 = T_2104_bits_index ^ 10'h15;
  assign T_2279 = T_2278 & 10'h3e0;
  assign T_2281 = T_2279 == 10'h0;
  assign T_2287 = T_2104_bits_index ^ 10'h12;
  assign T_2288 = T_2287 & 10'h3e0;
  assign T_2290 = T_2288 == 10'h0;
  assign T_2296 = T_2104_bits_index ^ 10'h10;
  assign T_2297 = T_2296 & 10'h3e0;
  assign T_2299 = T_2297 == 10'h0;
  assign T_2305 = T_2104_bits_index ^ 10'hb;
  assign T_2306 = T_2305 & 10'h3e0;
  assign T_2308 = T_2306 == 10'h0;
  assign T_2314 = T_2104_bits_index ^ 10'h13;
  assign T_2315 = T_2314 & 10'h3e0;
  assign T_2317 = T_2315 == 10'h0;
  assign T_2323 = T_2104_bits_index ^ 10'h4;
  assign T_2324 = T_2323 & 10'h3e0;
  assign T_2326 = T_2324 == 10'h0;
  assign T_2334_0 = T_4890;
  assign T_2334_1 = T_4990;
  assign T_2334_2 = T_5535;
  assign T_2334_3 = T_5543;
  assign T_2334_4 = T_5370;
  assign T_2334_5 = T_5561;
  assign T_2334_6 = T_5593;
  assign T_2334_7 = T_5625;
  assign T_2334_8 = T_5657;
  assign T_2334_9 = T_5689;
  assign T_2334_10 = T_5721;
  assign T_2334_11 = T_5753;
  assign T_2334_12 = T_5785;
  assign T_2334_13 = T_5290;
  assign T_2334_14 = T_5815;
  assign T_2334_15 = T_5823;
  assign T_2334_16 = T_5831;
  assign T_2334_17 = T_5839;
  assign T_2334_18 = T_5010;
  assign T_2334_19 = T_5851;
  assign T_2334_20 = T_5859;
  assign T_2334_21 = T_5310;
  assign T_2334_22 = T_5872;
  assign T_2334_23 = T_5884;
  assign T_2334_24 = T_5896;
  assign T_2334_25 = T_5909;
  assign T_2334_26 = T_5925;
  assign T_2334_27 = T_5941;
  assign T_2334_28 = T_5957;
  assign T_2334_29 = T_5971;
  assign T_2334_30 = T_5979;
  assign T_2334_31 = T_5988;
  assign T_2334_32 = T_6000;
  assign T_2334_33 = T_6012;
  assign T_2334_34 = T_4970;
  assign T_2339_0 = T_4896;
  assign T_2339_1 = T_4996;
  assign T_2339_2 = T_5537;
  assign T_2339_3 = T_5545;
  assign T_2339_4 = T_5376;
  assign T_2339_5 = T_5569;
  assign T_2339_6 = T_5601;
  assign T_2339_7 = T_5633;
  assign T_2339_8 = T_5665;
  assign T_2339_9 = T_5697;
  assign T_2339_10 = T_5729;
  assign T_2339_11 = T_5761;
  assign T_2339_12 = T_5793;
  assign T_2339_13 = T_5296;
  assign T_2339_14 = T_5817;
  assign T_2339_15 = T_5825;
  assign T_2339_16 = T_5833;
  assign T_2339_17 = T_5841;
  assign T_2339_18 = T_5016;
  assign T_2339_19 = T_5853;
  assign T_2339_20 = T_5861;
  assign T_2339_21 = T_5316;
  assign T_2339_22 = T_5875;
  assign T_2339_23 = T_5887;
  assign T_2339_24 = T_5899;
  assign T_2339_25 = T_5913;
  assign T_2339_26 = T_5929;
  assign T_2339_27 = T_5945;
  assign T_2339_28 = T_5961;
  assign T_2339_29 = T_5973;
  assign T_2339_30 = T_5981;
  assign T_2339_31 = T_5991;
  assign T_2339_32 = T_6003;
  assign T_2339_33 = T_6015;
  assign T_2339_34 = T_4976;
  assign T_2344_0 = 1'h1;
  assign T_2344_1 = 1'h1;
  assign T_2344_2 = 1'h1;
  assign T_2344_3 = 1'h1;
  assign T_2344_4 = 1'h1;
  assign T_2344_5 = 1'h1;
  assign T_2344_6 = 1'h1;
  assign T_2344_7 = 1'h1;
  assign T_2344_8 = 1'h1;
  assign T_2344_9 = 1'h1;
  assign T_2344_10 = 1'h1;
  assign T_2344_11 = 1'h1;
  assign T_2344_12 = 1'h1;
  assign T_2344_13 = 1'h1;
  assign T_2344_14 = 1'h1;
  assign T_2344_15 = 1'h1;
  assign T_2344_16 = 1'h1;
  assign T_2344_17 = 1'h1;
  assign T_2344_18 = 1'h1;
  assign T_2344_19 = 1'h1;
  assign T_2344_20 = 1'h1;
  assign T_2344_21 = 1'h1;
  assign T_2344_22 = 1'h1;
  assign T_2344_23 = 1'h1;
  assign T_2344_24 = 1'h1;
  assign T_2344_25 = 1'h1;
  assign T_2344_26 = 1'h1;
  assign T_2344_27 = 1'h1;
  assign T_2344_28 = 1'h1;
  assign T_2344_29 = 1'h1;
  assign T_2344_30 = 1'h1;
  assign T_2344_31 = 1'h1;
  assign T_2344_32 = 1'h1;
  assign T_2344_33 = 1'h1;
  assign T_2344_34 = 1'h1;
  assign T_2349_0 = 1'h1;
  assign T_2349_1 = 1'h1;
  assign T_2349_2 = 1'h1;
  assign T_2349_3 = 1'h1;
  assign T_2349_4 = 1'h1;
  assign T_2349_5 = 1'h1;
  assign T_2349_6 = 1'h1;
  assign T_2349_7 = 1'h1;
  assign T_2349_8 = 1'h1;
  assign T_2349_9 = 1'h1;
  assign T_2349_10 = 1'h1;
  assign T_2349_11 = 1'h1;
  assign T_2349_12 = 1'h1;
  assign T_2349_13 = 1'h1;
  assign T_2349_14 = 1'h1;
  assign T_2349_15 = 1'h1;
  assign T_2349_16 = 1'h1;
  assign T_2349_17 = 1'h1;
  assign T_2349_18 = 1'h1;
  assign T_2349_19 = 1'h1;
  assign T_2349_20 = 1'h1;
  assign T_2349_21 = 1'h1;
  assign T_2349_22 = 1'h1;
  assign T_2349_23 = 1'h1;
  assign T_2349_24 = 1'h1;
  assign T_2349_25 = 1'h1;
  assign T_2349_26 = 1'h1;
  assign T_2349_27 = 1'h1;
  assign T_2349_28 = 1'h1;
  assign T_2349_29 = 1'h1;
  assign T_2349_30 = 1'h1;
  assign T_2349_31 = 1'h1;
  assign T_2349_32 = 1'h1;
  assign T_2349_33 = 1'h1;
  assign T_2349_34 = 1'h1;
  assign T_2354_0 = 1'h1;
  assign T_2354_1 = 1'h1;
  assign T_2354_2 = 1'h1;
  assign T_2354_3 = 1'h1;
  assign T_2354_4 = 1'h1;
  assign T_2354_5 = 1'h1;
  assign T_2354_6 = 1'h1;
  assign T_2354_7 = 1'h1;
  assign T_2354_8 = 1'h1;
  assign T_2354_9 = 1'h1;
  assign T_2354_10 = 1'h1;
  assign T_2354_11 = 1'h1;
  assign T_2354_12 = 1'h1;
  assign T_2354_13 = 1'h1;
  assign T_2354_14 = 1'h1;
  assign T_2354_15 = 1'h1;
  assign T_2354_16 = 1'h1;
  assign T_2354_17 = 1'h1;
  assign T_2354_18 = 1'h1;
  assign T_2354_19 = 1'h1;
  assign T_2354_20 = 1'h1;
  assign T_2354_21 = 1'h1;
  assign T_2354_22 = 1'h1;
  assign T_2354_23 = 1'h1;
  assign T_2354_24 = 1'h1;
  assign T_2354_25 = 1'h1;
  assign T_2354_26 = 1'h1;
  assign T_2354_27 = 1'h1;
  assign T_2354_28 = 1'h1;
  assign T_2354_29 = 1'h1;
  assign T_2354_30 = 1'h1;
  assign T_2354_31 = 1'h1;
  assign T_2354_32 = 1'h1;
  assign T_2354_33 = 1'h1;
  assign T_2354_34 = 1'h1;
  assign T_2359_0 = 1'h1;
  assign T_2359_1 = 1'h1;
  assign T_2359_2 = 1'h1;
  assign T_2359_3 = 1'h1;
  assign T_2359_4 = 1'h1;
  assign T_2359_5 = 1'h1;
  assign T_2359_6 = 1'h1;
  assign T_2359_7 = 1'h1;
  assign T_2359_8 = 1'h1;
  assign T_2359_9 = 1'h1;
  assign T_2359_10 = 1'h1;
  assign T_2359_11 = 1'h1;
  assign T_2359_12 = 1'h1;
  assign T_2359_13 = 1'h1;
  assign T_2359_14 = 1'h1;
  assign T_2359_15 = 1'h1;
  assign T_2359_16 = 1'h1;
  assign T_2359_17 = 1'h1;
  assign T_2359_18 = 1'h1;
  assign T_2359_19 = 1'h1;
  assign T_2359_20 = 1'h1;
  assign T_2359_21 = 1'h1;
  assign T_2359_22 = 1'h1;
  assign T_2359_23 = 1'h1;
  assign T_2359_24 = 1'h1;
  assign T_2359_25 = 1'h1;
  assign T_2359_26 = 1'h1;
  assign T_2359_27 = 1'h1;
  assign T_2359_28 = 1'h1;
  assign T_2359_29 = 1'h1;
  assign T_2359_30 = 1'h1;
  assign T_2359_31 = 1'h1;
  assign T_2359_32 = 1'h1;
  assign T_2359_33 = 1'h1;
  assign T_2359_34 = 1'h1;
  assign T_2364_0 = T_4900;
  assign T_2364_1 = T_5000;
  assign T_2364_2 = T_5539;
  assign T_2364_3 = T_5547;
  assign T_2364_4 = T_5380;
  assign T_2364_5 = T_5577;
  assign T_2364_6 = T_5609;
  assign T_2364_7 = T_5641;
  assign T_2364_8 = T_5673;
  assign T_2364_9 = T_5705;
  assign T_2364_10 = T_5737;
  assign T_2364_11 = T_5769;
  assign T_2364_12 = T_5801;
  assign T_2364_13 = T_5300;
  assign T_2364_14 = T_5819;
  assign T_2364_15 = T_5827;
  assign T_2364_16 = T_5835;
  assign T_2364_17 = T_5843;
  assign T_2364_18 = T_5020;
  assign T_2364_19 = T_5855;
  assign T_2364_20 = T_5863;
  assign T_2364_21 = T_5320;
  assign T_2364_22 = T_5878;
  assign T_2364_23 = T_5890;
  assign T_2364_24 = T_5902;
  assign T_2364_25 = T_5917;
  assign T_2364_26 = T_5933;
  assign T_2364_27 = T_5949;
  assign T_2364_28 = T_5965;
  assign T_2364_29 = T_5975;
  assign T_2364_30 = T_5983;
  assign T_2364_31 = T_5994;
  assign T_2364_32 = T_6006;
  assign T_2364_33 = T_6018;
  assign T_2364_34 = T_4980;
  assign T_2369_0 = T_4906;
  assign T_2369_1 = T_5006;
  assign T_2369_2 = T_5541;
  assign T_2369_3 = T_5549;
  assign T_2369_4 = T_5386;
  assign T_2369_5 = T_5585;
  assign T_2369_6 = T_5617;
  assign T_2369_7 = T_5649;
  assign T_2369_8 = T_5681;
  assign T_2369_9 = T_5713;
  assign T_2369_10 = T_5745;
  assign T_2369_11 = T_5777;
  assign T_2369_12 = T_5809;
  assign T_2369_13 = T_5306;
  assign T_2369_14 = T_5821;
  assign T_2369_15 = T_5829;
  assign T_2369_16 = T_5837;
  assign T_2369_17 = T_5845;
  assign T_2369_18 = T_5026;
  assign T_2369_19 = T_5857;
  assign T_2369_20 = T_5865;
  assign T_2369_21 = T_5326;
  assign T_2369_22 = T_5881;
  assign T_2369_23 = T_5893;
  assign T_2369_24 = T_5905;
  assign T_2369_25 = T_5921;
  assign T_2369_26 = T_5937;
  assign T_2369_27 = T_5953;
  assign T_2369_28 = T_5969;
  assign T_2369_29 = T_5977;
  assign T_2369_30 = T_5985;
  assign T_2369_31 = T_5997;
  assign T_2369_32 = T_6009;
  assign T_2369_33 = T_6021;
  assign T_2369_34 = T_4986;
  assign T_2531 = T_2104_bits_mask[0];
  assign T_2532 = T_2104_bits_mask[1];
  assign T_2533 = T_2104_bits_mask[2];
  assign T_2534 = T_2104_bits_mask[3];
  assign T_2538 = T_2531 ? 8'hff : 8'h0;
  assign T_2542 = T_2532 ? 8'hff : 8'h0;
  assign T_2546 = T_2533 ? 8'hff : 8'h0;
  assign T_2550 = T_2534 ? 8'hff : 8'h0;
  assign T_2551 = {T_2542,T_2538};
  assign T_2552 = {T_2550,T_2546};
  assign T_2553 = {T_2552,T_2551};
  assign T_2577 = T_2553[11:0];
  assign T_2581 = ~ T_2577;
  assign T_2583 = T_2581 == 12'h0;
  assign T_2596 = T_2369_0 & T_2583;
  assign T_2597 = T_2104_bits_data[11:0];
  assign GEN_13 = T_2596 ? T_2597 : ctrl_sck_div;
  assign T_2617 = T_2553[0];
  assign T_2621 = ~ T_2617;
  assign T_2623 = T_2621 == 1'h0;
  assign T_2636 = T_2369_1 & T_2623;
  assign T_2637 = T_2104_bits_data[0];
  assign GEN_14 = T_2636 ? T_2637 : ctrl_cs_dflt_0;
  assign T_2657 = T_2553[7:0];
  assign T_2659 = T_2657 != 8'h0;
  assign T_2661 = ~ T_2657;
  assign T_2663 = T_2661 == 8'h0;
  assign T_2676 = T_2369_2 & T_2663;
  assign T_2677 = T_2104_bits_data[7:0];
  assign GEN_15 = T_2676 ? T_2677 : ctrl_dla_cssck;
  assign T_2697 = T_2553[23:16];
  assign T_2701 = ~ T_2697;
  assign T_2703 = T_2701 == 8'h0;
  assign T_2716 = T_2369_3 & T_2703;
  assign T_2717 = T_2104_bits_data[23:16];
  assign GEN_16 = T_2716 ? T_2717 : ctrl_dla_sckcs;
  assign GEN_226 = {{16'd0}, ctrl_dla_sckcs};
  assign T_2732 = GEN_226 << 16;
  assign GEN_227 = {{16'd0}, ctrl_dla_cssck};
  assign T_2736 = GEN_227 | T_2732;
  assign T_2756 = T_2369_4 & T_2623;
  assign GEN_17 = T_2756 ? T_2637 : flash_en;
  assign T_2796 = T_2369_5 & T_2623;
  assign GEN_18 = T_2796 ? T_2637 : insn_cmd_en;
  assign T_2817 = T_2553[3:1];
  assign T_2821 = ~ T_2817;
  assign T_2823 = T_2821 == 3'h0;
  assign T_2836 = T_2369_6 & T_2823;
  assign T_2837 = T_2104_bits_data[3:1];
  assign GEN_19 = T_2836 ? T_2837 : insn_addr_len;
  assign GEN_228 = {{1'd0}, insn_addr_len};
  assign T_2852 = GEN_228 << 1;
  assign GEN_229 = {{3'd0}, insn_cmd_en};
  assign T_2856 = GEN_229 | T_2852;
  assign T_2857 = T_2553[7:4];
  assign T_2861 = ~ T_2857;
  assign T_2863 = T_2861 == 4'h0;
  assign T_2876 = T_2369_7 & T_2863;
  assign T_2877 = T_2104_bits_data[7:4];
  assign GEN_20 = T_2876 ? T_2877 : insn_pad_cnt;
  assign GEN_230 = {{4'd0}, insn_pad_cnt};
  assign T_2892 = GEN_230 << 4;
  assign GEN_231 = {{4'd0}, T_2856};
  assign T_2896 = GEN_231 | T_2892;
  assign T_2897 = T_2553[9:8];
  assign T_2901 = ~ T_2897;
  assign T_2903 = T_2901 == 2'h0;
  assign T_2916 = T_2369_8 & T_2903;
  assign T_2917 = T_2104_bits_data[9:8];
  assign GEN_21 = T_2916 ? T_2917 : insn_cmd_proto;
  assign GEN_232 = {{8'd0}, insn_cmd_proto};
  assign T_2932 = GEN_232 << 8;
  assign GEN_233 = {{2'd0}, T_2896};
  assign T_2936 = GEN_233 | T_2932;
  assign T_2937 = T_2553[11:10];
  assign T_2941 = ~ T_2937;
  assign T_2943 = T_2941 == 2'h0;
  assign T_2956 = T_2369_9 & T_2943;
  assign T_2957 = T_2104_bits_data[11:10];
  assign GEN_22 = T_2956 ? T_2957 : insn_addr_proto;
  assign GEN_234 = {{10'd0}, insn_addr_proto};
  assign T_2972 = GEN_234 << 10;
  assign GEN_235 = {{2'd0}, T_2936};
  assign T_2976 = GEN_235 | T_2972;
  assign T_2977 = T_2553[13:12];
  assign T_2981 = ~ T_2977;
  assign T_2983 = T_2981 == 2'h0;
  assign T_2996 = T_2369_10 & T_2983;
  assign T_2997 = T_2104_bits_data[13:12];
  assign GEN_23 = T_2996 ? T_2997 : insn_data_proto;
  assign GEN_236 = {{12'd0}, insn_data_proto};
  assign T_3012 = GEN_236 << 12;
  assign GEN_237 = {{2'd0}, T_2976};
  assign T_3016 = GEN_237 | T_3012;
  assign T_3036 = T_2369_11 & T_2703;
  assign GEN_24 = T_3036 ? T_2717 : insn_cmd_code;
  assign GEN_238 = {{16'd0}, insn_cmd_code};
  assign T_3052 = GEN_238 << 16;
  assign GEN_239 = {{10'd0}, T_3016};
  assign T_3056 = GEN_239 | T_3052;
  assign T_3057 = T_2553[31:24];
  assign T_3061 = ~ T_3057;
  assign T_3063 = T_3061 == 8'h0;
  assign T_3076 = T_2369_12 & T_3063;
  assign T_3077 = T_2104_bits_data[31:24];
  assign GEN_25 = T_3076 ? T_3077 : insn_pad_code;
  assign GEN_240 = {{24'd0}, insn_pad_code};
  assign T_3092 = GEN_240 << 24;
  assign GEN_241 = {{8'd0}, T_3056};
  assign T_3096 = GEN_241 | T_3092;
  assign T_3097 = T_2553[3:0];
  assign T_3101 = ~ T_3097;
  assign T_3103 = T_3101 == 4'h0;
  assign T_3116 = T_2369_13 & T_3103;
  assign T_3117 = T_2104_bits_data[3:0];
  assign GEN_26 = T_3116 ? T_3117 : ctrl_wm_tx;
  assign T_3172 = fifo_io_ip_txwm;
  assign T_3177 = T_2553[1];
  assign T_3181 = ~ T_3177;
  assign T_3183 = T_3181 == 1'h0;
  assign T_3197 = T_2104_bits_data[1];
  assign GEN_242 = {{1'd0}, fifo_io_ip_rxwm};
  assign T_3212 = GEN_242 << 1;
  assign GEN_243 = {{1'd0}, T_3172};
  assign T_3216 = GEN_243 | T_3212;
  assign T_3236 = T_2369_16 & T_2623;
  assign GEN_27 = T_3236 ? T_2637 : ctrl_sck_pha;
  assign T_3276 = T_2369_17 & T_3183;
  assign GEN_28 = T_3276 ? T_3197 : ctrl_sck_pol;
  assign GEN_244 = {{1'd0}, ctrl_sck_pol};
  assign T_3292 = GEN_244 << 1;
  assign GEN_245 = {{1'd0}, ctrl_sck_pha};
  assign T_3296 = GEN_245 | T_3292;
  assign T_3297 = T_2553[1:0];
  assign T_3301 = ~ T_3297;
  assign T_3303 = T_3301 == 2'h0;
  assign T_3316 = T_2369_18 & T_3303;
  assign T_3317 = T_2104_bits_data[1:0];
  assign GEN_29 = T_3316 ? T_3317 : ctrl_cs_mode;
  assign T_3356 = T_2369_19 & T_2623;
  assign GEN_30 = T_3356 ? T_2637 : ie_txwm;
  assign T_3396 = T_2369_20 & T_3183;
  assign GEN_31 = T_3396 ? T_3197 : ie_rxwm;
  assign GEN_246 = {{1'd0}, ie_rxwm};
  assign T_3412 = GEN_246 << 1;
  assign GEN_247 = {{1'd0}, ie_txwm};
  assign T_3416 = GEN_247 | T_3412;
  assign T_3436 = T_2369_21 & T_3103;
  assign GEN_32 = T_3436 ? T_3117 : ctrl_wm_rx;
  assign T_3476 = T_2369_22 & T_2663;
  assign GEN_248 = {{31'd0}, T_1921};
  assign T_3572 = GEN_248 << 31;
  assign T_3596 = T_2369_25 & T_3303;
  assign GEN_33 = T_3596 ? T_3317 : ctrl_fmt_proto;
  assign T_3617 = T_2553[2];
  assign T_3621 = ~ T_3617;
  assign T_3623 = T_3621 == 1'h0;
  assign T_3636 = T_2369_26 & T_3623;
  assign T_3637 = T_2104_bits_data[2];
  assign GEN_34 = T_3636 ? T_3637 : ctrl_fmt_endian;
  assign GEN_249 = {{2'd0}, ctrl_fmt_endian};
  assign T_3652 = GEN_249 << 2;
  assign GEN_250 = {{1'd0}, ctrl_fmt_proto};
  assign T_3656 = GEN_250 | T_3652;
  assign T_3657 = T_2553[3];
  assign T_3661 = ~ T_3657;
  assign T_3663 = T_3661 == 1'h0;
  assign T_3676 = T_2369_27 & T_3663;
  assign T_3677 = T_2104_bits_data[3];
  assign GEN_35 = T_3676 ? T_3677 : ctrl_fmt_iodir;
  assign GEN_251 = {{3'd0}, ctrl_fmt_iodir};
  assign T_3692 = GEN_251 << 3;
  assign GEN_252 = {{1'd0}, T_3656};
  assign T_3696 = GEN_252 | T_3692;
  assign T_3697 = T_2553[19:16];
  assign T_3701 = ~ T_3697;
  assign T_3703 = T_3701 == 4'h0;
  assign T_3716 = T_2369_28 & T_3703;
  assign T_3717 = T_2104_bits_data[19:16];
  assign GEN_36 = T_3716 ? T_3717 : ctrl_fmt_len;
  assign GEN_253 = {{16'd0}, ctrl_fmt_len};
  assign T_3732 = GEN_253 << 16;
  assign GEN_254 = {{16'd0}, T_3696};
  assign T_3736 = GEN_254 | T_3732;
  assign T_3756 = T_2369_29 & T_2663;
  assign GEN_37 = T_3756 ? T_2677 : ctrl_dla_intercs;
  assign T_3796 = T_2369_30 & T_2703;
  assign GEN_38 = T_3796 ? T_2717 : ctrl_dla_interxfr;
  assign GEN_255 = {{16'd0}, ctrl_dla_interxfr};
  assign T_3812 = GEN_255 << 16;
  assign GEN_256 = {{16'd0}, ctrl_dla_intercs};
  assign T_3816 = GEN_256 | T_3812;
  assign T_3832 = T_2364_31 & T_2659;
  assign T_3852 = fifo_io_rx_bits;
  assign T_3896 = {{23'd0}, T_3852};
  assign GEN_257 = {{31'd0}, T_1924};
  assign T_3932 = GEN_257 << 31;
  assign GEN_258 = {{1'd0}, T_3896};
  assign T_3936 = GEN_258 | T_3932;
  assign T_3956 = T_2369_34 & T_2623;
  assign GEN_39 = T_3956 ? T_2637 : ctrl_cs_id;
  assign T_3978 = T_2191 == 1'h0;
  assign T_3980 = T_3978 | T_2344_0;
  assign T_3982 = T_2254 == 1'h0;
  assign T_3983 = T_2344_17 & T_2344_16;
  assign T_3985 = T_3982 | T_3983;
  assign T_3993 = T_2326 == 1'h0;
  assign T_3995 = T_3993 | T_2344_34;
  assign T_3997 = T_2200 == 1'h0;
  assign T_3999 = T_3997 | T_2344_1;
  assign T_4001 = T_2263 == 1'h0;
  assign T_4003 = T_4001 | T_2344_18;
  assign T_4014 = T_2209 == 1'h0;
  assign T_4015 = T_2344_3 & T_2344_2;
  assign T_4017 = T_4014 | T_4015;
  assign T_4019 = T_2308 == 1'h0;
  assign T_4020 = T_2344_30 & T_2344_29;
  assign T_4022 = T_4019 | T_4020;
  assign T_4036 = T_2299 == 1'h0;
  assign T_4037 = T_2344_28 & T_2344_27;
  assign T_4038 = T_4037 & T_2344_26;
  assign T_4039 = T_4038 & T_2344_25;
  assign T_4041 = T_4036 | T_4039;
  assign T_4046 = T_2290 == 1'h0;
  assign T_4047 = T_2344_24 & T_2344_23;
  assign T_4048 = T_4047 & T_2344_22;
  assign T_4050 = T_4046 | T_4048;
  assign T_4052 = T_2317 == 1'h0;
  assign T_4053 = T_2344_33 & T_2344_32;
  assign T_4054 = T_4053 & T_2344_31;
  assign T_4056 = T_4052 | T_4054;
  assign T_4058 = T_2236 == 1'h0;
  assign T_4060 = T_4058 | T_2344_13;
  assign T_4062 = T_2281 == 1'h0;
  assign T_4064 = T_4062 | T_2344_21;
  assign T_4072 = T_2218 == 1'h0;
  assign T_4074 = T_4072 | T_2344_4;
  assign T_4076 = T_2227 == 1'h0;
  assign T_4077 = T_2344_12 & T_2344_11;
  assign T_4078 = T_4077 & T_2344_10;
  assign T_4079 = T_4078 & T_2344_9;
  assign T_4080 = T_4079 & T_2344_8;
  assign T_4081 = T_4080 & T_2344_7;
  assign T_4082 = T_4081 & T_2344_6;
  assign T_4083 = T_4082 & T_2344_5;
  assign T_4085 = T_4076 | T_4083;
  assign T_4093 = T_2272 == 1'h0;
  assign T_4094 = T_2344_20 & T_2344_19;
  assign T_4096 = T_4093 | T_4094;
  assign T_4098 = T_2245 == 1'h0;
  assign T_4099 = T_2344_15 & T_2344_14;
  assign T_4101 = T_4098 | T_4099;
  assign T_4143_0 = T_3980;
  assign T_4143_1 = T_3985;
  assign T_4143_2 = 1'h1;
  assign T_4143_3 = 1'h1;
  assign T_4143_4 = T_3995;
  assign T_4143_5 = T_3999;
  assign T_4143_6 = T_4003;
  assign T_4143_7 = 1'h1;
  assign T_4143_8 = 1'h1;
  assign T_4143_9 = 1'h1;
  assign T_4143_10 = T_4017;
  assign T_4143_11 = T_4022;
  assign T_4143_12 = 1'h1;
  assign T_4143_13 = 1'h1;
  assign T_4143_14 = 1'h1;
  assign T_4143_15 = 1'h1;
  assign T_4143_16 = T_4041;
  assign T_4143_17 = 1'h1;
  assign T_4143_18 = T_4050;
  assign T_4143_19 = T_4056;
  assign T_4143_20 = T_4060;
  assign T_4143_21 = T_4064;
  assign T_4143_22 = 1'h1;
  assign T_4143_23 = 1'h1;
  assign T_4143_24 = T_4074;
  assign T_4143_25 = T_4085;
  assign T_4143_26 = 1'h1;
  assign T_4143_27 = 1'h1;
  assign T_4143_28 = T_4096;
  assign T_4143_29 = T_4101;
  assign T_4143_30 = 1'h1;
  assign T_4143_31 = 1'h1;
  assign T_4181 = T_3978 | T_2349_0;
  assign T_4184 = T_2349_17 & T_2349_16;
  assign T_4186 = T_3982 | T_4184;
  assign T_4196 = T_3993 | T_2349_34;
  assign T_4200 = T_3997 | T_2349_1;
  assign T_4204 = T_4001 | T_2349_18;
  assign T_4216 = T_2349_3 & T_2349_2;
  assign T_4218 = T_4014 | T_4216;
  assign T_4221 = T_2349_30 & T_2349_29;
  assign T_4223 = T_4019 | T_4221;
  assign T_4238 = T_2349_28 & T_2349_27;
  assign T_4239 = T_4238 & T_2349_26;
  assign T_4240 = T_4239 & T_2349_25;
  assign T_4242 = T_4036 | T_4240;
  assign T_4248 = T_2349_24 & T_2349_23;
  assign T_4249 = T_4248 & T_2349_22;
  assign T_4251 = T_4046 | T_4249;
  assign T_4254 = T_2349_33 & T_2349_32;
  assign T_4255 = T_4254 & T_2349_31;
  assign T_4257 = T_4052 | T_4255;
  assign T_4261 = T_4058 | T_2349_13;
  assign T_4265 = T_4062 | T_2349_21;
  assign T_4275 = T_4072 | T_2349_4;
  assign T_4278 = T_2349_12 & T_2349_11;
  assign T_4279 = T_4278 & T_2349_10;
  assign T_4280 = T_4279 & T_2349_9;
  assign T_4281 = T_4280 & T_2349_8;
  assign T_4282 = T_4281 & T_2349_7;
  assign T_4283 = T_4282 & T_2349_6;
  assign T_4284 = T_4283 & T_2349_5;
  assign T_4286 = T_4076 | T_4284;
  assign T_4295 = T_2349_20 & T_2349_19;
  assign T_4297 = T_4093 | T_4295;
  assign T_4300 = T_2349_15 & T_2349_14;
  assign T_4302 = T_4098 | T_4300;
  assign T_4344_0 = T_4181;
  assign T_4344_1 = T_4186;
  assign T_4344_2 = 1'h1;
  assign T_4344_3 = 1'h1;
  assign T_4344_4 = T_4196;
  assign T_4344_5 = T_4200;
  assign T_4344_6 = T_4204;
  assign T_4344_7 = 1'h1;
  assign T_4344_8 = 1'h1;
  assign T_4344_9 = 1'h1;
  assign T_4344_10 = T_4218;
  assign T_4344_11 = T_4223;
  assign T_4344_12 = 1'h1;
  assign T_4344_13 = 1'h1;
  assign T_4344_14 = 1'h1;
  assign T_4344_15 = 1'h1;
  assign T_4344_16 = T_4242;
  assign T_4344_17 = 1'h1;
  assign T_4344_18 = T_4251;
  assign T_4344_19 = T_4257;
  assign T_4344_20 = T_4261;
  assign T_4344_21 = T_4265;
  assign T_4344_22 = 1'h1;
  assign T_4344_23 = 1'h1;
  assign T_4344_24 = T_4275;
  assign T_4344_25 = T_4286;
  assign T_4344_26 = 1'h1;
  assign T_4344_27 = 1'h1;
  assign T_4344_28 = T_4297;
  assign T_4344_29 = T_4302;
  assign T_4344_30 = 1'h1;
  assign T_4344_31 = 1'h1;
  assign T_4382 = T_3978 | T_2354_0;
  assign T_4385 = T_2354_17 & T_2354_16;
  assign T_4387 = T_3982 | T_4385;
  assign T_4397 = T_3993 | T_2354_34;
  assign T_4401 = T_3997 | T_2354_1;
  assign T_4405 = T_4001 | T_2354_18;
  assign T_4417 = T_2354_3 & T_2354_2;
  assign T_4419 = T_4014 | T_4417;
  assign T_4422 = T_2354_30 & T_2354_29;
  assign T_4424 = T_4019 | T_4422;
  assign T_4439 = T_2354_28 & T_2354_27;
  assign T_4440 = T_4439 & T_2354_26;
  assign T_4441 = T_4440 & T_2354_25;
  assign T_4443 = T_4036 | T_4441;
  assign T_4449 = T_2354_24 & T_2354_23;
  assign T_4450 = T_4449 & T_2354_22;
  assign T_4452 = T_4046 | T_4450;
  assign T_4455 = T_2354_33 & T_2354_32;
  assign T_4456 = T_4455 & T_2354_31;
  assign T_4458 = T_4052 | T_4456;
  assign T_4462 = T_4058 | T_2354_13;
  assign T_4466 = T_4062 | T_2354_21;
  assign T_4476 = T_4072 | T_2354_4;
  assign T_4479 = T_2354_12 & T_2354_11;
  assign T_4480 = T_4479 & T_2354_10;
  assign T_4481 = T_4480 & T_2354_9;
  assign T_4482 = T_4481 & T_2354_8;
  assign T_4483 = T_4482 & T_2354_7;
  assign T_4484 = T_4483 & T_2354_6;
  assign T_4485 = T_4484 & T_2354_5;
  assign T_4487 = T_4076 | T_4485;
  assign T_4496 = T_2354_20 & T_2354_19;
  assign T_4498 = T_4093 | T_4496;
  assign T_4501 = T_2354_15 & T_2354_14;
  assign T_4503 = T_4098 | T_4501;
  assign T_4545_0 = T_4382;
  assign T_4545_1 = T_4387;
  assign T_4545_2 = 1'h1;
  assign T_4545_3 = 1'h1;
  assign T_4545_4 = T_4397;
  assign T_4545_5 = T_4401;
  assign T_4545_6 = T_4405;
  assign T_4545_7 = 1'h1;
  assign T_4545_8 = 1'h1;
  assign T_4545_9 = 1'h1;
  assign T_4545_10 = T_4419;
  assign T_4545_11 = T_4424;
  assign T_4545_12 = 1'h1;
  assign T_4545_13 = 1'h1;
  assign T_4545_14 = 1'h1;
  assign T_4545_15 = 1'h1;
  assign T_4545_16 = T_4443;
  assign T_4545_17 = 1'h1;
  assign T_4545_18 = T_4452;
  assign T_4545_19 = T_4458;
  assign T_4545_20 = T_4462;
  assign T_4545_21 = T_4466;
  assign T_4545_22 = 1'h1;
  assign T_4545_23 = 1'h1;
  assign T_4545_24 = T_4476;
  assign T_4545_25 = T_4487;
  assign T_4545_26 = 1'h1;
  assign T_4545_27 = 1'h1;
  assign T_4545_28 = T_4498;
  assign T_4545_29 = T_4503;
  assign T_4545_30 = 1'h1;
  assign T_4545_31 = 1'h1;
  assign T_4583 = T_3978 | T_2359_0;
  assign T_4586 = T_2359_17 & T_2359_16;
  assign T_4588 = T_3982 | T_4586;
  assign T_4598 = T_3993 | T_2359_34;
  assign T_4602 = T_3997 | T_2359_1;
  assign T_4606 = T_4001 | T_2359_18;
  assign T_4618 = T_2359_3 & T_2359_2;
  assign T_4620 = T_4014 | T_4618;
  assign T_4623 = T_2359_30 & T_2359_29;
  assign T_4625 = T_4019 | T_4623;
  assign T_4640 = T_2359_28 & T_2359_27;
  assign T_4641 = T_4640 & T_2359_26;
  assign T_4642 = T_4641 & T_2359_25;
  assign T_4644 = T_4036 | T_4642;
  assign T_4650 = T_2359_24 & T_2359_23;
  assign T_4651 = T_4650 & T_2359_22;
  assign T_4653 = T_4046 | T_4651;
  assign T_4656 = T_2359_33 & T_2359_32;
  assign T_4657 = T_4656 & T_2359_31;
  assign T_4659 = T_4052 | T_4657;
  assign T_4663 = T_4058 | T_2359_13;
  assign T_4667 = T_4062 | T_2359_21;
  assign T_4677 = T_4072 | T_2359_4;
  assign T_4680 = T_2359_12 & T_2359_11;
  assign T_4681 = T_4680 & T_2359_10;
  assign T_4682 = T_4681 & T_2359_9;
  assign T_4683 = T_4682 & T_2359_8;
  assign T_4684 = T_4683 & T_2359_7;
  assign T_4685 = T_4684 & T_2359_6;
  assign T_4686 = T_4685 & T_2359_5;
  assign T_4688 = T_4076 | T_4686;
  assign T_4697 = T_2359_20 & T_2359_19;
  assign T_4699 = T_4093 | T_4697;
  assign T_4702 = T_2359_15 & T_2359_14;
  assign T_4704 = T_4098 | T_4702;
  assign T_4746_0 = T_4583;
  assign T_4746_1 = T_4588;
  assign T_4746_2 = 1'h1;
  assign T_4746_3 = 1'h1;
  assign T_4746_4 = T_4598;
  assign T_4746_5 = T_4602;
  assign T_4746_6 = T_4606;
  assign T_4746_7 = 1'h1;
  assign T_4746_8 = 1'h1;
  assign T_4746_9 = 1'h1;
  assign T_4746_10 = T_4620;
  assign T_4746_11 = T_4625;
  assign T_4746_12 = 1'h1;
  assign T_4746_13 = 1'h1;
  assign T_4746_14 = 1'h1;
  assign T_4746_15 = 1'h1;
  assign T_4746_16 = T_4644;
  assign T_4746_17 = 1'h1;
  assign T_4746_18 = T_4653;
  assign T_4746_19 = T_4659;
  assign T_4746_20 = T_4663;
  assign T_4746_21 = T_4667;
  assign T_4746_22 = 1'h1;
  assign T_4746_23 = 1'h1;
  assign T_4746_24 = T_4677;
  assign T_4746_25 = T_4688;
  assign T_4746_26 = 1'h1;
  assign T_4746_27 = 1'h1;
  assign T_4746_28 = T_4699;
  assign T_4746_29 = T_4704;
  assign T_4746_30 = 1'h1;
  assign T_4746_31 = 1'h1;
  assign T_4781 = T_2104_bits_index[0];
  assign T_4782 = T_2104_bits_index[1];
  assign T_4783 = T_2104_bits_index[2];
  assign T_4784 = T_2104_bits_index[3];
  assign T_4785 = T_2104_bits_index[4];
  assign T_4791 = {T_4782,T_4781};
  assign T_4792 = {T_4785,T_4784};
  assign T_4793 = {T_4792,T_4783};
  assign T_4794 = {T_4793,T_4791};
  assign GEN_0 = GEN_70;
  assign GEN_40 = 5'h1 == T_4794 ? T_4143_1 : T_4143_0;
  assign GEN_41 = 5'h2 == T_4794 ? T_4143_2 : GEN_40;
  assign GEN_42 = 5'h3 == T_4794 ? T_4143_3 : GEN_41;
  assign GEN_43 = 5'h4 == T_4794 ? T_4143_4 : GEN_42;
  assign GEN_44 = 5'h5 == T_4794 ? T_4143_5 : GEN_43;
  assign GEN_45 = 5'h6 == T_4794 ? T_4143_6 : GEN_44;
  assign GEN_46 = 5'h7 == T_4794 ? T_4143_7 : GEN_45;
  assign GEN_47 = 5'h8 == T_4794 ? T_4143_8 : GEN_46;
  assign GEN_48 = 5'h9 == T_4794 ? T_4143_9 : GEN_47;
  assign GEN_49 = 5'ha == T_4794 ? T_4143_10 : GEN_48;
  assign GEN_50 = 5'hb == T_4794 ? T_4143_11 : GEN_49;
  assign GEN_51 = 5'hc == T_4794 ? T_4143_12 : GEN_50;
  assign GEN_52 = 5'hd == T_4794 ? T_4143_13 : GEN_51;
  assign GEN_53 = 5'he == T_4794 ? T_4143_14 : GEN_52;
  assign GEN_54 = 5'hf == T_4794 ? T_4143_15 : GEN_53;
  assign GEN_55 = 5'h10 == T_4794 ? T_4143_16 : GEN_54;
  assign GEN_56 = 5'h11 == T_4794 ? T_4143_17 : GEN_55;
  assign GEN_57 = 5'h12 == T_4794 ? T_4143_18 : GEN_56;
  assign GEN_58 = 5'h13 == T_4794 ? T_4143_19 : GEN_57;
  assign GEN_59 = 5'h14 == T_4794 ? T_4143_20 : GEN_58;
  assign GEN_60 = 5'h15 == T_4794 ? T_4143_21 : GEN_59;
  assign GEN_61 = 5'h16 == T_4794 ? T_4143_22 : GEN_60;
  assign GEN_62 = 5'h17 == T_4794 ? T_4143_23 : GEN_61;
  assign GEN_63 = 5'h18 == T_4794 ? T_4143_24 : GEN_62;
  assign GEN_64 = 5'h19 == T_4794 ? T_4143_25 : GEN_63;
  assign GEN_65 = 5'h1a == T_4794 ? T_4143_26 : GEN_64;
  assign GEN_66 = 5'h1b == T_4794 ? T_4143_27 : GEN_65;
  assign GEN_67 = 5'h1c == T_4794 ? T_4143_28 : GEN_66;
  assign GEN_68 = 5'h1d == T_4794 ? T_4143_29 : GEN_67;
  assign GEN_69 = 5'h1e == T_4794 ? T_4143_30 : GEN_68;
  assign GEN_70 = 5'h1f == T_4794 ? T_4143_31 : GEN_69;
  assign GEN_1 = GEN_101;
  assign GEN_71 = 5'h1 == T_4794 ? T_4344_1 : T_4344_0;
  assign GEN_72 = 5'h2 == T_4794 ? T_4344_2 : GEN_71;
  assign GEN_73 = 5'h3 == T_4794 ? T_4344_3 : GEN_72;
  assign GEN_74 = 5'h4 == T_4794 ? T_4344_4 : GEN_73;
  assign GEN_75 = 5'h5 == T_4794 ? T_4344_5 : GEN_74;
  assign GEN_76 = 5'h6 == T_4794 ? T_4344_6 : GEN_75;
  assign GEN_77 = 5'h7 == T_4794 ? T_4344_7 : GEN_76;
  assign GEN_78 = 5'h8 == T_4794 ? T_4344_8 : GEN_77;
  assign GEN_79 = 5'h9 == T_4794 ? T_4344_9 : GEN_78;
  assign GEN_80 = 5'ha == T_4794 ? T_4344_10 : GEN_79;
  assign GEN_81 = 5'hb == T_4794 ? T_4344_11 : GEN_80;
  assign GEN_82 = 5'hc == T_4794 ? T_4344_12 : GEN_81;
  assign GEN_83 = 5'hd == T_4794 ? T_4344_13 : GEN_82;
  assign GEN_84 = 5'he == T_4794 ? T_4344_14 : GEN_83;
  assign GEN_85 = 5'hf == T_4794 ? T_4344_15 : GEN_84;
  assign GEN_86 = 5'h10 == T_4794 ? T_4344_16 : GEN_85;
  assign GEN_87 = 5'h11 == T_4794 ? T_4344_17 : GEN_86;
  assign GEN_88 = 5'h12 == T_4794 ? T_4344_18 : GEN_87;
  assign GEN_89 = 5'h13 == T_4794 ? T_4344_19 : GEN_88;
  assign GEN_90 = 5'h14 == T_4794 ? T_4344_20 : GEN_89;
  assign GEN_91 = 5'h15 == T_4794 ? T_4344_21 : GEN_90;
  assign GEN_92 = 5'h16 == T_4794 ? T_4344_22 : GEN_91;
  assign GEN_93 = 5'h17 == T_4794 ? T_4344_23 : GEN_92;
  assign GEN_94 = 5'h18 == T_4794 ? T_4344_24 : GEN_93;
  assign GEN_95 = 5'h19 == T_4794 ? T_4344_25 : GEN_94;
  assign GEN_96 = 5'h1a == T_4794 ? T_4344_26 : GEN_95;
  assign GEN_97 = 5'h1b == T_4794 ? T_4344_27 : GEN_96;
  assign GEN_98 = 5'h1c == T_4794 ? T_4344_28 : GEN_97;
  assign GEN_99 = 5'h1d == T_4794 ? T_4344_29 : GEN_98;
  assign GEN_100 = 5'h1e == T_4794 ? T_4344_30 : GEN_99;
  assign GEN_101 = 5'h1f == T_4794 ? T_4344_31 : GEN_100;
  assign T_4811 = T_2104_bits_read ? GEN_0 : GEN_1;
  assign GEN_2 = GEN_132;
  assign GEN_102 = 5'h1 == T_4794 ? T_4545_1 : T_4545_0;
  assign GEN_103 = 5'h2 == T_4794 ? T_4545_2 : GEN_102;
  assign GEN_104 = 5'h3 == T_4794 ? T_4545_3 : GEN_103;
  assign GEN_105 = 5'h4 == T_4794 ? T_4545_4 : GEN_104;
  assign GEN_106 = 5'h5 == T_4794 ? T_4545_5 : GEN_105;
  assign GEN_107 = 5'h6 == T_4794 ? T_4545_6 : GEN_106;
  assign GEN_108 = 5'h7 == T_4794 ? T_4545_7 : GEN_107;
  assign GEN_109 = 5'h8 == T_4794 ? T_4545_8 : GEN_108;
  assign GEN_110 = 5'h9 == T_4794 ? T_4545_9 : GEN_109;
  assign GEN_111 = 5'ha == T_4794 ? T_4545_10 : GEN_110;
  assign GEN_112 = 5'hb == T_4794 ? T_4545_11 : GEN_111;
  assign GEN_113 = 5'hc == T_4794 ? T_4545_12 : GEN_112;
  assign GEN_114 = 5'hd == T_4794 ? T_4545_13 : GEN_113;
  assign GEN_115 = 5'he == T_4794 ? T_4545_14 : GEN_114;
  assign GEN_116 = 5'hf == T_4794 ? T_4545_15 : GEN_115;
  assign GEN_117 = 5'h10 == T_4794 ? T_4545_16 : GEN_116;
  assign GEN_118 = 5'h11 == T_4794 ? T_4545_17 : GEN_117;
  assign GEN_119 = 5'h12 == T_4794 ? T_4545_18 : GEN_118;
  assign GEN_120 = 5'h13 == T_4794 ? T_4545_19 : GEN_119;
  assign GEN_121 = 5'h14 == T_4794 ? T_4545_20 : GEN_120;
  assign GEN_122 = 5'h15 == T_4794 ? T_4545_21 : GEN_121;
  assign GEN_123 = 5'h16 == T_4794 ? T_4545_22 : GEN_122;
  assign GEN_124 = 5'h17 == T_4794 ? T_4545_23 : GEN_123;
  assign GEN_125 = 5'h18 == T_4794 ? T_4545_24 : GEN_124;
  assign GEN_126 = 5'h19 == T_4794 ? T_4545_25 : GEN_125;
  assign GEN_127 = 5'h1a == T_4794 ? T_4545_26 : GEN_126;
  assign GEN_128 = 5'h1b == T_4794 ? T_4545_27 : GEN_127;
  assign GEN_129 = 5'h1c == T_4794 ? T_4545_28 : GEN_128;
  assign GEN_130 = 5'h1d == T_4794 ? T_4545_29 : GEN_129;
  assign GEN_131 = 5'h1e == T_4794 ? T_4545_30 : GEN_130;
  assign GEN_132 = 5'h1f == T_4794 ? T_4545_31 : GEN_131;
  assign GEN_3 = GEN_163;
  assign GEN_133 = 5'h1 == T_4794 ? T_4746_1 : T_4746_0;
  assign GEN_134 = 5'h2 == T_4794 ? T_4746_2 : GEN_133;
  assign GEN_135 = 5'h3 == T_4794 ? T_4746_3 : GEN_134;
  assign GEN_136 = 5'h4 == T_4794 ? T_4746_4 : GEN_135;
  assign GEN_137 = 5'h5 == T_4794 ? T_4746_5 : GEN_136;
  assign GEN_138 = 5'h6 == T_4794 ? T_4746_6 : GEN_137;
  assign GEN_139 = 5'h7 == T_4794 ? T_4746_7 : GEN_138;
  assign GEN_140 = 5'h8 == T_4794 ? T_4746_8 : GEN_139;
  assign GEN_141 = 5'h9 == T_4794 ? T_4746_9 : GEN_140;
  assign GEN_142 = 5'ha == T_4794 ? T_4746_10 : GEN_141;
  assign GEN_143 = 5'hb == T_4794 ? T_4746_11 : GEN_142;
  assign GEN_144 = 5'hc == T_4794 ? T_4746_12 : GEN_143;
  assign GEN_145 = 5'hd == T_4794 ? T_4746_13 : GEN_144;
  assign GEN_146 = 5'he == T_4794 ? T_4746_14 : GEN_145;
  assign GEN_147 = 5'hf == T_4794 ? T_4746_15 : GEN_146;
  assign GEN_148 = 5'h10 == T_4794 ? T_4746_16 : GEN_147;
  assign GEN_149 = 5'h11 == T_4794 ? T_4746_17 : GEN_148;
  assign GEN_150 = 5'h12 == T_4794 ? T_4746_18 : GEN_149;
  assign GEN_151 = 5'h13 == T_4794 ? T_4746_19 : GEN_150;
  assign GEN_152 = 5'h14 == T_4794 ? T_4746_20 : GEN_151;
  assign GEN_153 = 5'h15 == T_4794 ? T_4746_21 : GEN_152;
  assign GEN_154 = 5'h16 == T_4794 ? T_4746_22 : GEN_153;
  assign GEN_155 = 5'h17 == T_4794 ? T_4746_23 : GEN_154;
  assign GEN_156 = 5'h18 == T_4794 ? T_4746_24 : GEN_155;
  assign GEN_157 = 5'h19 == T_4794 ? T_4746_25 : GEN_156;
  assign GEN_158 = 5'h1a == T_4794 ? T_4746_26 : GEN_157;
  assign GEN_159 = 5'h1b == T_4794 ? T_4746_27 : GEN_158;
  assign GEN_160 = 5'h1c == T_4794 ? T_4746_28 : GEN_159;
  assign GEN_161 = 5'h1d == T_4794 ? T_4746_29 : GEN_160;
  assign GEN_162 = 5'h1e == T_4794 ? T_4746_30 : GEN_161;
  assign GEN_163 = 5'h1f == T_4794 ? T_4746_31 : GEN_162;
  assign T_4814 = T_2104_bits_read ? GEN_2 : GEN_3;
  assign T_4815 = T_2104_ready & T_4811;
  assign T_4816 = T_2029_valid & T_4811;
  assign T_4817 = T_2068_ready & T_4814;
  assign T_4818 = T_2104_valid & T_4814;
  assign T_4820 = 32'h1 << T_4794;
  assign T_4821 = {T_2254,T_2191};
  assign T_4823 = {2'h3,T_4821};
  assign T_4824 = {T_2200,T_2326};
  assign T_4825 = {1'h1,T_2263};
  assign T_4826 = {T_4825,T_4824};
  assign T_4827 = {T_4826,T_4823};
  assign T_4829 = {T_2308,T_2209};
  assign T_4830 = {T_4829,2'h3};
  assign T_4834 = {4'hf,T_4830};
  assign T_4835 = {T_4834,T_4827};
  assign T_4836 = {1'h1,T_2299};
  assign T_4837 = {T_2317,T_2290};
  assign T_4838 = {T_4837,T_4836};
  assign T_4839 = {T_2281,T_2236};
  assign T_4841 = {2'h3,T_4839};
  assign T_4842 = {T_4841,T_4838};
  assign T_4843 = {T_2227,T_2218};
  assign T_4845 = {2'h3,T_4843};
  assign T_4846 = {T_2245,T_2272};
  assign T_4848 = {2'h3,T_4846};
  assign T_4849 = {T_4848,T_4845};
  assign T_4850 = {T_4849,T_4842};
  assign T_4851 = {T_4850,T_4835};
  assign T_4852 = T_4820 & T_4851;
  assign T_4887 = T_2029_valid & T_2104_ready;
  assign T_4888 = T_4887 & T_2104_bits_read;
  assign T_4889 = T_4852[0];
  assign T_4890 = T_4888 & T_4889;
  assign T_4893 = T_2104_bits_read == 1'h0;
  assign T_4894 = T_4887 & T_4893;
  assign T_4896 = T_4894 & T_4889;
  assign T_4897 = T_2104_valid & T_2068_ready;
  assign T_4898 = T_4897 & T_2104_bits_read;
  assign T_4900 = T_4898 & T_4889;
  assign T_4904 = T_4897 & T_4893;
  assign T_4906 = T_4904 & T_4889;
  assign T_4909 = T_4852[1];
  assign T_4910 = T_4888 & T_4909;
  assign T_4916 = T_4894 & T_4909;
  assign T_4920 = T_4898 & T_4909;
  assign T_4926 = T_4904 & T_4909;
  assign T_4969 = T_4852[4];
  assign T_4970 = T_4888 & T_4969;
  assign T_4976 = T_4894 & T_4969;
  assign T_4980 = T_4898 & T_4969;
  assign T_4986 = T_4904 & T_4969;
  assign T_4989 = T_4852[5];
  assign T_4990 = T_4888 & T_4989;
  assign T_4996 = T_4894 & T_4989;
  assign T_5000 = T_4898 & T_4989;
  assign T_5006 = T_4904 & T_4989;
  assign T_5009 = T_4852[6];
  assign T_5010 = T_4888 & T_5009;
  assign T_5016 = T_4894 & T_5009;
  assign T_5020 = T_4898 & T_5009;
  assign T_5026 = T_4904 & T_5009;
  assign T_5089 = T_4852[10];
  assign T_5090 = T_4888 & T_5089;
  assign T_5096 = T_4894 & T_5089;
  assign T_5100 = T_4898 & T_5089;
  assign T_5106 = T_4904 & T_5089;
  assign T_5109 = T_4852[11];
  assign T_5110 = T_4888 & T_5109;
  assign T_5116 = T_4894 & T_5109;
  assign T_5120 = T_4898 & T_5109;
  assign T_5126 = T_4904 & T_5109;
  assign T_5209 = T_4852[16];
  assign T_5210 = T_4888 & T_5209;
  assign T_5216 = T_4894 & T_5209;
  assign T_5220 = T_4898 & T_5209;
  assign T_5226 = T_4904 & T_5209;
  assign T_5249 = T_4852[18];
  assign T_5250 = T_4888 & T_5249;
  assign T_5256 = T_4894 & T_5249;
  assign T_5260 = T_4898 & T_5249;
  assign T_5266 = T_4904 & T_5249;
  assign T_5269 = T_4852[19];
  assign T_5270 = T_4888 & T_5269;
  assign T_5276 = T_4894 & T_5269;
  assign T_5280 = T_4898 & T_5269;
  assign T_5286 = T_4904 & T_5269;
  assign T_5289 = T_4852[20];
  assign T_5290 = T_4888 & T_5289;
  assign T_5296 = T_4894 & T_5289;
  assign T_5300 = T_4898 & T_5289;
  assign T_5306 = T_4904 & T_5289;
  assign T_5309 = T_4852[21];
  assign T_5310 = T_4888 & T_5309;
  assign T_5316 = T_4894 & T_5309;
  assign T_5320 = T_4898 & T_5309;
  assign T_5326 = T_4904 & T_5309;
  assign T_5369 = T_4852[24];
  assign T_5370 = T_4888 & T_5369;
  assign T_5376 = T_4894 & T_5369;
  assign T_5380 = T_4898 & T_5369;
  assign T_5386 = T_4904 & T_5369;
  assign T_5389 = T_4852[25];
  assign T_5390 = T_4888 & T_5389;
  assign T_5396 = T_4894 & T_5389;
  assign T_5400 = T_4898 & T_5389;
  assign T_5406 = T_4904 & T_5389;
  assign T_5449 = T_4852[28];
  assign T_5450 = T_4888 & T_5449;
  assign T_5456 = T_4894 & T_5449;
  assign T_5460 = T_4898 & T_5449;
  assign T_5466 = T_4904 & T_5449;
  assign T_5469 = T_4852[29];
  assign T_5470 = T_4888 & T_5469;
  assign T_5476 = T_4894 & T_5469;
  assign T_5480 = T_4898 & T_5469;
  assign T_5486 = T_4904 & T_5469;
  assign T_5535 = T_5090 & T_2344_3;
  assign T_5537 = T_5096 & T_2349_3;
  assign T_5539 = T_5100 & T_2354_3;
  assign T_5541 = T_5106 & T_2359_3;
  assign T_5543 = T_5090 & T_2344_2;
  assign T_5545 = T_5096 & T_2349_2;
  assign T_5547 = T_5100 & T_2354_2;
  assign T_5549 = T_5106 & T_2359_2;
  assign T_5555 = T_5390 & T_2344_12;
  assign T_5556 = T_5555 & T_2344_11;
  assign T_5557 = T_5556 & T_2344_10;
  assign T_5558 = T_5557 & T_2344_9;
  assign T_5559 = T_5558 & T_2344_8;
  assign T_5560 = T_5559 & T_2344_7;
  assign T_5561 = T_5560 & T_2344_6;
  assign T_5563 = T_5396 & T_2349_12;
  assign T_5564 = T_5563 & T_2349_11;
  assign T_5565 = T_5564 & T_2349_10;
  assign T_5566 = T_5565 & T_2349_9;
  assign T_5567 = T_5566 & T_2349_8;
  assign T_5568 = T_5567 & T_2349_7;
  assign T_5569 = T_5568 & T_2349_6;
  assign T_5571 = T_5400 & T_2354_12;
  assign T_5572 = T_5571 & T_2354_11;
  assign T_5573 = T_5572 & T_2354_10;
  assign T_5574 = T_5573 & T_2354_9;
  assign T_5575 = T_5574 & T_2354_8;
  assign T_5576 = T_5575 & T_2354_7;
  assign T_5577 = T_5576 & T_2354_6;
  assign T_5579 = T_5406 & T_2359_12;
  assign T_5580 = T_5579 & T_2359_11;
  assign T_5581 = T_5580 & T_2359_10;
  assign T_5582 = T_5581 & T_2359_9;
  assign T_5583 = T_5582 & T_2359_8;
  assign T_5584 = T_5583 & T_2359_7;
  assign T_5585 = T_5584 & T_2359_6;
  assign T_5593 = T_5560 & T_2344_5;
  assign T_5601 = T_5568 & T_2349_5;
  assign T_5609 = T_5576 & T_2354_5;
  assign T_5617 = T_5584 & T_2359_5;
  assign T_5624 = T_5559 & T_2344_6;
  assign T_5625 = T_5624 & T_2344_5;
  assign T_5632 = T_5567 & T_2349_6;
  assign T_5633 = T_5632 & T_2349_5;
  assign T_5640 = T_5575 & T_2354_6;
  assign T_5641 = T_5640 & T_2354_5;
  assign T_5648 = T_5583 & T_2359_6;
  assign T_5649 = T_5648 & T_2359_5;
  assign T_5655 = T_5558 & T_2344_7;
  assign T_5656 = T_5655 & T_2344_6;
  assign T_5657 = T_5656 & T_2344_5;
  assign T_5663 = T_5566 & T_2349_7;
  assign T_5664 = T_5663 & T_2349_6;
  assign T_5665 = T_5664 & T_2349_5;
  assign T_5671 = T_5574 & T_2354_7;
  assign T_5672 = T_5671 & T_2354_6;
  assign T_5673 = T_5672 & T_2354_5;
  assign T_5679 = T_5582 & T_2359_7;
  assign T_5680 = T_5679 & T_2359_6;
  assign T_5681 = T_5680 & T_2359_5;
  assign T_5686 = T_5557 & T_2344_8;
  assign T_5687 = T_5686 & T_2344_7;
  assign T_5688 = T_5687 & T_2344_6;
  assign T_5689 = T_5688 & T_2344_5;
  assign T_5694 = T_5565 & T_2349_8;
  assign T_5695 = T_5694 & T_2349_7;
  assign T_5696 = T_5695 & T_2349_6;
  assign T_5697 = T_5696 & T_2349_5;
  assign T_5702 = T_5573 & T_2354_8;
  assign T_5703 = T_5702 & T_2354_7;
  assign T_5704 = T_5703 & T_2354_6;
  assign T_5705 = T_5704 & T_2354_5;
  assign T_5710 = T_5581 & T_2359_8;
  assign T_5711 = T_5710 & T_2359_7;
  assign T_5712 = T_5711 & T_2359_6;
  assign T_5713 = T_5712 & T_2359_5;
  assign T_5717 = T_5556 & T_2344_9;
  assign T_5718 = T_5717 & T_2344_8;
  assign T_5719 = T_5718 & T_2344_7;
  assign T_5720 = T_5719 & T_2344_6;
  assign T_5721 = T_5720 & T_2344_5;
  assign T_5725 = T_5564 & T_2349_9;
  assign T_5726 = T_5725 & T_2349_8;
  assign T_5727 = T_5726 & T_2349_7;
  assign T_5728 = T_5727 & T_2349_6;
  assign T_5729 = T_5728 & T_2349_5;
  assign T_5733 = T_5572 & T_2354_9;
  assign T_5734 = T_5733 & T_2354_8;
  assign T_5735 = T_5734 & T_2354_7;
  assign T_5736 = T_5735 & T_2354_6;
  assign T_5737 = T_5736 & T_2354_5;
  assign T_5741 = T_5580 & T_2359_9;
  assign T_5742 = T_5741 & T_2359_8;
  assign T_5743 = T_5742 & T_2359_7;
  assign T_5744 = T_5743 & T_2359_6;
  assign T_5745 = T_5744 & T_2359_5;
  assign T_5748 = T_5555 & T_2344_10;
  assign T_5749 = T_5748 & T_2344_9;
  assign T_5750 = T_5749 & T_2344_8;
  assign T_5751 = T_5750 & T_2344_7;
  assign T_5752 = T_5751 & T_2344_6;
  assign T_5753 = T_5752 & T_2344_5;
  assign T_5756 = T_5563 & T_2349_10;
  assign T_5757 = T_5756 & T_2349_9;
  assign T_5758 = T_5757 & T_2349_8;
  assign T_5759 = T_5758 & T_2349_7;
  assign T_5760 = T_5759 & T_2349_6;
  assign T_5761 = T_5760 & T_2349_5;
  assign T_5764 = T_5571 & T_2354_10;
  assign T_5765 = T_5764 & T_2354_9;
  assign T_5766 = T_5765 & T_2354_8;
  assign T_5767 = T_5766 & T_2354_7;
  assign T_5768 = T_5767 & T_2354_6;
  assign T_5769 = T_5768 & T_2354_5;
  assign T_5772 = T_5579 & T_2359_10;
  assign T_5773 = T_5772 & T_2359_9;
  assign T_5774 = T_5773 & T_2359_8;
  assign T_5775 = T_5774 & T_2359_7;
  assign T_5776 = T_5775 & T_2359_6;
  assign T_5777 = T_5776 & T_2359_5;
  assign T_5779 = T_5390 & T_2344_11;
  assign T_5780 = T_5779 & T_2344_10;
  assign T_5781 = T_5780 & T_2344_9;
  assign T_5782 = T_5781 & T_2344_8;
  assign T_5783 = T_5782 & T_2344_7;
  assign T_5784 = T_5783 & T_2344_6;
  assign T_5785 = T_5784 & T_2344_5;
  assign T_5787 = T_5396 & T_2349_11;
  assign T_5788 = T_5787 & T_2349_10;
  assign T_5789 = T_5788 & T_2349_9;
  assign T_5790 = T_5789 & T_2349_8;
  assign T_5791 = T_5790 & T_2349_7;
  assign T_5792 = T_5791 & T_2349_6;
  assign T_5793 = T_5792 & T_2349_5;
  assign T_5795 = T_5400 & T_2354_11;
  assign T_5796 = T_5795 & T_2354_10;
  assign T_5797 = T_5796 & T_2354_9;
  assign T_5798 = T_5797 & T_2354_8;
  assign T_5799 = T_5798 & T_2354_7;
  assign T_5800 = T_5799 & T_2354_6;
  assign T_5801 = T_5800 & T_2354_5;
  assign T_5803 = T_5406 & T_2359_11;
  assign T_5804 = T_5803 & T_2359_10;
  assign T_5805 = T_5804 & T_2359_9;
  assign T_5806 = T_5805 & T_2359_8;
  assign T_5807 = T_5806 & T_2359_7;
  assign T_5808 = T_5807 & T_2359_6;
  assign T_5809 = T_5808 & T_2359_5;
  assign T_5815 = T_5470 & T_2344_15;
  assign T_5817 = T_5476 & T_2349_15;
  assign T_5819 = T_5480 & T_2354_15;
  assign T_5821 = T_5486 & T_2359_15;
  assign T_5823 = T_5470 & T_2344_14;
  assign T_5825 = T_5476 & T_2349_14;
  assign T_5827 = T_5480 & T_2354_14;
  assign T_5829 = T_5486 & T_2359_14;
  assign T_5831 = T_4910 & T_2344_17;
  assign T_5833 = T_4916 & T_2349_17;
  assign T_5835 = T_4920 & T_2354_17;
  assign T_5837 = T_4926 & T_2359_17;
  assign T_5839 = T_4910 & T_2344_16;
  assign T_5841 = T_4916 & T_2349_16;
  assign T_5843 = T_4920 & T_2354_16;
  assign T_5845 = T_4926 & T_2359_16;
  assign T_5851 = T_5450 & T_2344_20;
  assign T_5853 = T_5456 & T_2349_20;
  assign T_5855 = T_5460 & T_2354_20;
  assign T_5857 = T_5466 & T_2359_20;
  assign T_5859 = T_5450 & T_2344_19;
  assign T_5861 = T_5456 & T_2349_19;
  assign T_5863 = T_5460 & T_2354_19;
  assign T_5865 = T_5466 & T_2359_19;
  assign T_5871 = T_5250 & T_2344_24;
  assign T_5872 = T_5871 & T_2344_23;
  assign T_5874 = T_5256 & T_2349_24;
  assign T_5875 = T_5874 & T_2349_23;
  assign T_5877 = T_5260 & T_2354_24;
  assign T_5878 = T_5877 & T_2354_23;
  assign T_5880 = T_5266 & T_2359_24;
  assign T_5881 = T_5880 & T_2359_23;
  assign T_5884 = T_5871 & T_2344_22;
  assign T_5887 = T_5874 & T_2349_22;
  assign T_5890 = T_5877 & T_2354_22;
  assign T_5893 = T_5880 & T_2359_22;
  assign T_5895 = T_5250 & T_2344_23;
  assign T_5896 = T_5895 & T_2344_22;
  assign T_5898 = T_5256 & T_2349_23;
  assign T_5899 = T_5898 & T_2349_22;
  assign T_5901 = T_5260 & T_2354_23;
  assign T_5902 = T_5901 & T_2354_22;
  assign T_5904 = T_5266 & T_2359_23;
  assign T_5905 = T_5904 & T_2359_22;
  assign T_5907 = T_5210 & T_2344_28;
  assign T_5908 = T_5907 & T_2344_27;
  assign T_5909 = T_5908 & T_2344_26;
  assign T_5911 = T_5216 & T_2349_28;
  assign T_5912 = T_5911 & T_2349_27;
  assign T_5913 = T_5912 & T_2349_26;
  assign T_5915 = T_5220 & T_2354_28;
  assign T_5916 = T_5915 & T_2354_27;
  assign T_5917 = T_5916 & T_2354_26;
  assign T_5919 = T_5226 & T_2359_28;
  assign T_5920 = T_5919 & T_2359_27;
  assign T_5921 = T_5920 & T_2359_26;
  assign T_5925 = T_5908 & T_2344_25;
  assign T_5929 = T_5912 & T_2349_25;
  assign T_5933 = T_5916 & T_2354_25;
  assign T_5937 = T_5920 & T_2359_25;
  assign T_5940 = T_5907 & T_2344_26;
  assign T_5941 = T_5940 & T_2344_25;
  assign T_5944 = T_5911 & T_2349_26;
  assign T_5945 = T_5944 & T_2349_25;
  assign T_5948 = T_5915 & T_2354_26;
  assign T_5949 = T_5948 & T_2354_25;
  assign T_5952 = T_5919 & T_2359_26;
  assign T_5953 = T_5952 & T_2359_25;
  assign T_5955 = T_5210 & T_2344_27;
  assign T_5956 = T_5955 & T_2344_26;
  assign T_5957 = T_5956 & T_2344_25;
  assign T_5959 = T_5216 & T_2349_27;
  assign T_5960 = T_5959 & T_2349_26;
  assign T_5961 = T_5960 & T_2349_25;
  assign T_5963 = T_5220 & T_2354_27;
  assign T_5964 = T_5963 & T_2354_26;
  assign T_5965 = T_5964 & T_2354_25;
  assign T_5967 = T_5226 & T_2359_27;
  assign T_5968 = T_5967 & T_2359_26;
  assign T_5969 = T_5968 & T_2359_25;
  assign T_5971 = T_5110 & T_2344_30;
  assign T_5973 = T_5116 & T_2349_30;
  assign T_5975 = T_5120 & T_2354_30;
  assign T_5977 = T_5126 & T_2359_30;
  assign T_5979 = T_5110 & T_2344_29;
  assign T_5981 = T_5116 & T_2349_29;
  assign T_5983 = T_5120 & T_2354_29;
  assign T_5985 = T_5126 & T_2359_29;
  assign T_5987 = T_5270 & T_2344_33;
  assign T_5988 = T_5987 & T_2344_32;
  assign T_5990 = T_5276 & T_2349_33;
  assign T_5991 = T_5990 & T_2349_32;
  assign T_5993 = T_5280 & T_2354_33;
  assign T_5994 = T_5993 & T_2354_32;
  assign T_5996 = T_5286 & T_2359_33;
  assign T_5997 = T_5996 & T_2359_32;
  assign T_6000 = T_5987 & T_2344_31;
  assign T_6003 = T_5990 & T_2349_31;
  assign T_6006 = T_5993 & T_2354_31;
  assign T_6009 = T_5996 & T_2359_31;
  assign T_6011 = T_5270 & T_2344_32;
  assign T_6012 = T_6011 & T_2344_31;
  assign T_6014 = T_5276 & T_2349_32;
  assign T_6015 = T_6014 & T_2349_31;
  assign T_6017 = T_5280 & T_2354_32;
  assign T_6018 = T_6017 & T_2354_31;
  assign T_6020 = T_5286 & T_2359_32;
  assign T_6021 = T_6020 & T_2359_31;
  assign T_6062_0 = T_2191;
  assign T_6062_1 = T_2254;
  assign T_6062_2 = 1'h1;
  assign T_6062_3 = 1'h1;
  assign T_6062_4 = T_2326;
  assign T_6062_5 = T_2200;
  assign T_6062_6 = T_2263;
  assign T_6062_7 = 1'h1;
  assign T_6062_8 = 1'h1;
  assign T_6062_9 = 1'h1;
  assign T_6062_10 = T_2209;
  assign T_6062_11 = T_2308;
  assign T_6062_12 = 1'h1;
  assign T_6062_13 = 1'h1;
  assign T_6062_14 = 1'h1;
  assign T_6062_15 = 1'h1;
  assign T_6062_16 = T_2299;
  assign T_6062_17 = 1'h1;
  assign T_6062_18 = T_2290;
  assign T_6062_19 = T_2317;
  assign T_6062_20 = T_2236;
  assign T_6062_21 = T_2281;
  assign T_6062_22 = 1'h1;
  assign T_6062_23 = 1'h1;
  assign T_6062_24 = T_2218;
  assign T_6062_25 = T_2227;
  assign T_6062_26 = 1'h1;
  assign T_6062_27 = 1'h1;
  assign T_6062_28 = T_2272;
  assign T_6062_29 = T_2245;
  assign T_6062_30 = 1'h1;
  assign T_6062_31 = 1'h1;
  assign T_6133_0 = {{20'd0}, ctrl_sck_div};
  assign T_6133_1 = {{30'd0}, T_3296};
  assign T_6133_2 = 32'h0;
  assign T_6133_3 = 32'h0;
  assign T_6133_4 = {{31'd0}, ctrl_cs_id};
  assign T_6133_5 = {{31'd0}, ctrl_cs_dflt_0};
  assign T_6133_6 = {{30'd0}, ctrl_cs_mode};
  assign T_6133_7 = 32'h0;
  assign T_6133_8 = 32'h0;
  assign T_6133_9 = 32'h0;
  assign T_6133_10 = {{8'd0}, T_2736};
  assign T_6133_11 = {{8'd0}, T_3816};
  assign T_6133_12 = 32'h0;
  assign T_6133_13 = 32'h0;
  assign T_6133_14 = 32'h0;
  assign T_6133_15 = 32'h0;
  assign T_6133_16 = {{12'd0}, T_3736};
  assign T_6133_17 = 32'h0;
  assign T_6133_18 = T_3572;
  assign T_6133_19 = T_3936;
  assign T_6133_20 = {{28'd0}, ctrl_wm_tx};
  assign T_6133_21 = {{28'd0}, ctrl_wm_rx};
  assign T_6133_22 = 32'h0;
  assign T_6133_23 = 32'h0;
  assign T_6133_24 = {{31'd0}, flash_en};
  assign T_6133_25 = T_3096;
  assign T_6133_26 = 32'h0;
  assign T_6133_27 = 32'h0;
  assign T_6133_28 = {{30'd0}, T_3416};
  assign T_6133_29 = {{30'd0}, T_3216};
  assign T_6133_30 = 32'h0;
  assign T_6133_31 = 32'h0;
  assign GEN_4 = GEN_194;
  assign GEN_164 = 5'h1 == T_4794 ? T_6062_1 : T_6062_0;
  assign GEN_165 = 5'h2 == T_4794 ? T_6062_2 : GEN_164;
  assign GEN_166 = 5'h3 == T_4794 ? T_6062_3 : GEN_165;
  assign GEN_167 = 5'h4 == T_4794 ? T_6062_4 : GEN_166;
  assign GEN_168 = 5'h5 == T_4794 ? T_6062_5 : GEN_167;
  assign GEN_169 = 5'h6 == T_4794 ? T_6062_6 : GEN_168;
  assign GEN_170 = 5'h7 == T_4794 ? T_6062_7 : GEN_169;
  assign GEN_171 = 5'h8 == T_4794 ? T_6062_8 : GEN_170;
  assign GEN_172 = 5'h9 == T_4794 ? T_6062_9 : GEN_171;
  assign GEN_173 = 5'ha == T_4794 ? T_6062_10 : GEN_172;
  assign GEN_174 = 5'hb == T_4794 ? T_6062_11 : GEN_173;
  assign GEN_175 = 5'hc == T_4794 ? T_6062_12 : GEN_174;
  assign GEN_176 = 5'hd == T_4794 ? T_6062_13 : GEN_175;
  assign GEN_177 = 5'he == T_4794 ? T_6062_14 : GEN_176;
  assign GEN_178 = 5'hf == T_4794 ? T_6062_15 : GEN_177;
  assign GEN_179 = 5'h10 == T_4794 ? T_6062_16 : GEN_178;
  assign GEN_180 = 5'h11 == T_4794 ? T_6062_17 : GEN_179;
  assign GEN_181 = 5'h12 == T_4794 ? T_6062_18 : GEN_180;
  assign GEN_182 = 5'h13 == T_4794 ? T_6062_19 : GEN_181;
  assign GEN_183 = 5'h14 == T_4794 ? T_6062_20 : GEN_182;
  assign GEN_184 = 5'h15 == T_4794 ? T_6062_21 : GEN_183;
  assign GEN_185 = 5'h16 == T_4794 ? T_6062_22 : GEN_184;
  assign GEN_186 = 5'h17 == T_4794 ? T_6062_23 : GEN_185;
  assign GEN_187 = 5'h18 == T_4794 ? T_6062_24 : GEN_186;
  assign GEN_188 = 5'h19 == T_4794 ? T_6062_25 : GEN_187;
  assign GEN_189 = 5'h1a == T_4794 ? T_6062_26 : GEN_188;
  assign GEN_190 = 5'h1b == T_4794 ? T_6062_27 : GEN_189;
  assign GEN_191 = 5'h1c == T_4794 ? T_6062_28 : GEN_190;
  assign GEN_192 = 5'h1d == T_4794 ? T_6062_29 : GEN_191;
  assign GEN_193 = 5'h1e == T_4794 ? T_6062_30 : GEN_192;
  assign GEN_194 = 5'h1f == T_4794 ? T_6062_31 : GEN_193;
  assign GEN_5 = GEN_225;
  assign GEN_195 = 5'h1 == T_4794 ? T_6133_1 : T_6133_0;
  assign GEN_196 = 5'h2 == T_4794 ? T_6133_2 : GEN_195;
  assign GEN_197 = 5'h3 == T_4794 ? T_6133_3 : GEN_196;
  assign GEN_198 = 5'h4 == T_4794 ? T_6133_4 : GEN_197;
  assign GEN_199 = 5'h5 == T_4794 ? T_6133_5 : GEN_198;
  assign GEN_200 = 5'h6 == T_4794 ? T_6133_6 : GEN_199;
  assign GEN_201 = 5'h7 == T_4794 ? T_6133_7 : GEN_200;
  assign GEN_202 = 5'h8 == T_4794 ? T_6133_8 : GEN_201;
  assign GEN_203 = 5'h9 == T_4794 ? T_6133_9 : GEN_202;
  assign GEN_204 = 5'ha == T_4794 ? T_6133_10 : GEN_203;
  assign GEN_205 = 5'hb == T_4794 ? T_6133_11 : GEN_204;
  assign GEN_206 = 5'hc == T_4794 ? T_6133_12 : GEN_205;
  assign GEN_207 = 5'hd == T_4794 ? T_6133_13 : GEN_206;
  assign GEN_208 = 5'he == T_4794 ? T_6133_14 : GEN_207;
  assign GEN_209 = 5'hf == T_4794 ? T_6133_15 : GEN_208;
  assign GEN_210 = 5'h10 == T_4794 ? T_6133_16 : GEN_209;
  assign GEN_211 = 5'h11 == T_4794 ? T_6133_17 : GEN_210;
  assign GEN_212 = 5'h12 == T_4794 ? T_6133_18 : GEN_211;
  assign GEN_213 = 5'h13 == T_4794 ? T_6133_19 : GEN_212;
  assign GEN_214 = 5'h14 == T_4794 ? T_6133_20 : GEN_213;
  assign GEN_215 = 5'h15 == T_4794 ? T_6133_21 : GEN_214;
  assign GEN_216 = 5'h16 == T_4794 ? T_6133_22 : GEN_215;
  assign GEN_217 = 5'h17 == T_4794 ? T_6133_23 : GEN_216;
  assign GEN_218 = 5'h18 == T_4794 ? T_6133_24 : GEN_217;
  assign GEN_219 = 5'h19 == T_4794 ? T_6133_25 : GEN_218;
  assign GEN_220 = 5'h1a == T_4794 ? T_6133_26 : GEN_219;
  assign GEN_221 = 5'h1b == T_4794 ? T_6133_27 : GEN_220;
  assign GEN_222 = 5'h1c == T_4794 ? T_6133_28 : GEN_221;
  assign GEN_223 = 5'h1d == T_4794 ? T_6133_29 : GEN_222;
  assign GEN_224 = 5'h1e == T_4794 ? T_6133_30 : GEN_223;
  assign GEN_225 = 5'h1f == T_4794 ? T_6133_31 : GEN_224;
  assign T_6170 = GEN_4 ? GEN_5 : 32'h0;
  assign T_6171 = T_2068_bits_extra[9:8];
  assign T_6173 = T_2068_bits_extra[7:3];
  assign T_6174 = T_2068_bits_extra[2:0];
  assign T_6185_opcode = 3'h0;
  assign T_6185_param = 2'h0;
  assign T_6185_size = T_6174;
  assign T_6185_source = T_6173;
  assign T_6185_sink = 1'h0;
  assign T_6185_addr_lo = T_6171;
  assign T_6185_data = 32'h0;
  assign T_6185_error = 1'h0;

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_fmt_proto <= T_1840_fmt_proto;
    end else begin
      if (T_3596) begin
        ctrl_fmt_proto <= T_3317;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_fmt_endian <= T_1840_fmt_endian;
    end else begin
      if (T_3636) begin
        ctrl_fmt_endian <= T_3637;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_fmt_iodir <= T_1840_fmt_iodir;
    end else begin
      if (T_3676) begin
        ctrl_fmt_iodir <= T_3677;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_fmt_len <= T_1840_fmt_len;
    end else begin
      if (T_3716) begin
        ctrl_fmt_len <= T_3717;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_sck_div <= T_1840_sck_div;
    end else begin
      if (T_2596) begin
        ctrl_sck_div <= T_2597;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_sck_pol <= T_1840_sck_pol;
    end else begin
      if (T_3276) begin
        ctrl_sck_pol <= T_3197;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_sck_pha <= T_1840_sck_pha;
    end else begin
      if (T_3236) begin
        ctrl_sck_pha <= T_2637;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_cs_id <= T_1840_cs_id;
    end else begin
      if (T_3956) begin
        ctrl_cs_id <= T_2637;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_cs_dflt_0 <= T_1840_cs_dflt_0;
    end else begin
      if (T_2636) begin
        ctrl_cs_dflt_0 <= T_2637;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_cs_mode <= T_1840_cs_mode;
    end else begin
      if (T_3316) begin
        ctrl_cs_mode <= T_3317;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_dla_cssck <= T_1840_dla_cssck;
    end else begin
      if (T_2676) begin
        ctrl_dla_cssck <= T_2677;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_dla_sckcs <= T_1840_dla_sckcs;
    end else begin
      if (T_2716) begin
        ctrl_dla_sckcs <= T_2717;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_dla_intercs <= T_1840_dla_intercs;
    end else begin
      if (T_3756) begin
        ctrl_dla_intercs <= T_2677;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_dla_interxfr <= T_1840_dla_interxfr;
    end else begin
      if (T_3796) begin
        ctrl_dla_interxfr <= T_2717;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_wm_tx <= T_1840_wm_tx;
    end else begin
      if (T_3116) begin
        ctrl_wm_tx <= T_3117;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ctrl_wm_rx <= T_1840_wm_rx;
    end else begin
      if (T_3436) begin
        ctrl_wm_rx <= T_3117;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ie_txwm <= T_1906_txwm;
    end else begin
      if (T_3356) begin
        ie_txwm <= T_2637;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ie_rxwm <= T_1906_rxwm;
    end else begin
      if (T_3396) begin
        ie_rxwm <= T_3197;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      insn_cmd_proto <= T_1973_cmd_proto;
    end else begin
      if (T_2916) begin
        insn_cmd_proto <= T_2917;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      insn_cmd_code <= T_1973_cmd_code;
    end else begin
      if (T_3036) begin
        insn_cmd_code <= T_2717;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      insn_cmd_en <= T_1973_cmd_en;
    end else begin
      if (T_2796) begin
        insn_cmd_en <= T_2637;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      insn_addr_proto <= T_1973_addr_proto;
    end else begin
      if (T_2956) begin
        insn_addr_proto <= T_2957;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      insn_addr_len <= T_1973_addr_len;
    end else begin
      if (T_2836) begin
        insn_addr_len <= T_2837;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      insn_pad_code <= T_1973_pad_code;
    end else begin
      if (T_3076) begin
        insn_pad_code <= T_3077;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      insn_pad_cnt <= T_1973_pad_cnt;
    end else begin
      if (T_2876) begin
        insn_pad_cnt <= T_2877;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      insn_data_proto <= T_1973_data_proto;
    end else begin
      if (T_2996) begin
        insn_data_proto <= T_2997;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      flash_en <= 1'h1;
    end else begin
      if (T_2756) begin
        flash_en <= T_2637;
      end
    end

  always @(posedge clock or posedge reset) begin
  if(reset) begin
    a_opcode <= 3'b0;
    a_param <= 3'b0;
    a_size <= 3'b0;
    a_source <= 7'b0;
    a_address <= 30'b0;
    a_mask <= 1'b0;
    a_data <= 8'b0;
  end
  else begin

    if (T_1935) begin
      a_opcode <= io_tl_f_0_a_bits_opcode;
    end
    if (T_1935) begin
      a_param <= io_tl_f_0_a_bits_param;
    end
    if (T_1935) begin
      a_size <= io_tl_f_0_a_bits_size;
    end
    if (T_1935) begin
      a_source <= io_tl_f_0_a_bits_source;
    end
    if (T_1935) begin
      a_address <= io_tl_f_0_a_bits_address;
    end
    if (T_1935) begin
      a_mask <= io_tl_f_0_a_bits_mask;
    end
    if (T_1935) begin
      a_data <= io_tl_f_0_a_bits_data;
    end
  end

  end

endmodule
