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
                                                                         
                                                                         
                                                                         

module sirv_qspi_media_1(
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
  output  io_port_cs_1,
  output  io_port_cs_2,
  output  io_port_cs_3,
  input  [11:0] io_ctrl_sck_div,
  input   io_ctrl_sck_pol,
  input   io_ctrl_sck_pha,
  input  [7:0] io_ctrl_dla_cssck,
  input  [7:0] io_ctrl_dla_sckcs,
  input  [7:0] io_ctrl_dla_intercs,
  input  [7:0] io_ctrl_dla_interxfr,
  input  [1:0] io_ctrl_cs_id,
  input   io_ctrl_cs_dflt_0,
  input   io_ctrl_cs_dflt_1,
  input   io_ctrl_cs_dflt_2,
  input   io_ctrl_cs_dflt_3,
  output  io_link_tx_ready,
  input   io_link_tx_valid,
  input  [7:0] io_link_tx_bits,
  output  io_link_rx_valid,
  output [7:0] io_link_rx_bits,
  input  [7:0] io_link_cnt,
  input  [1:0] io_link_fmt_proto,
  input   io_link_fmt_endian,
  input   io_link_fmt_iodir,
  input   io_link_cs_set,
  input   io_link_cs_clear,
  input   io_link_cs_hold,
  output  io_link_active
);
  wire  phy_clock;
  wire  phy_reset;
  wire  phy_io_port_sck;
  wire  phy_io_port_dq_0_i;
  wire  phy_io_port_dq_0_o;
  wire  phy_io_port_dq_0_oe;
  wire  phy_io_port_dq_1_i;
  wire  phy_io_port_dq_1_o;
  wire  phy_io_port_dq_1_oe;
  wire  phy_io_port_dq_2_i;
  wire  phy_io_port_dq_2_o;
  wire  phy_io_port_dq_2_oe;
  wire  phy_io_port_dq_3_i;
  wire  phy_io_port_dq_3_o;
  wire  phy_io_port_dq_3_oe;
  wire  phy_io_port_cs_0;
  wire  phy_io_port_cs_1;
  wire  phy_io_port_cs_2;
  wire  phy_io_port_cs_3;
  wire [11:0] phy_io_ctrl_sck_div;
  wire  phy_io_ctrl_sck_pol;
  wire  phy_io_ctrl_sck_pha;
  wire [1:0] phy_io_ctrl_fmt_proto;
  wire  phy_io_ctrl_fmt_endian;
  wire  phy_io_ctrl_fmt_iodir;
  wire  phy_io_op_ready;
  wire  phy_io_op_valid;
  wire  phy_io_op_bits_fn;
  wire  phy_io_op_bits_stb;
  wire [7:0] phy_io_op_bits_cnt;
  wire [7:0] phy_io_op_bits_data;
  wire  phy_io_rx_valid;
  wire [7:0] phy_io_rx_bits;
  reg [1:0] cs_id;
  reg [31:0] GEN_5;
  reg  cs_dflt_0;
  reg [31:0] GEN_68;
  reg  cs_dflt_1;
  reg [31:0] GEN_69;
  reg  cs_dflt_2;
  reg [31:0] GEN_70;
  reg  cs_dflt_3;
  reg [31:0] GEN_71;
  reg  cs_set;
  reg [31:0] GEN_72;
  wire [3:0] GEN_66;
  wire [3:0] T_162;
  wire [1:0] T_163;
  wire [1:0] T_164;
  wire [3:0] T_165;
  wire [3:0] T_166;
  wire  T_167;
  wire  T_168;
  wire  T_169;
  wire  T_170;
  wire  cs_active_0;
  wire  cs_active_1;
  wire  cs_active_2;
  wire  cs_active_3;
  wire [1:0] T_184;
  wire [1:0] T_185;
  wire [3:0] T_186;
  wire [1:0] T_187;
  wire [1:0] T_188;
  wire [3:0] T_189;
  wire  cs_update;
  reg  clear;
  reg [31:0] GEN_73;
  reg  cs_assert;
  reg [31:0] GEN_74;
  wire  T_193;
  wire  T_194;
  wire  cs_deassert;
  wire  T_195;
  wire  T_196;
  wire  continuous;
  reg [1:0] state;
  reg [31:0] GEN_75;
  wire  T_200;
  wire [1:0] GEN_0;
  wire [7:0] GEN_1;
  wire [1:0] GEN_2;
  wire  T_202;
  wire  T_204;
  wire [1:0] GEN_3;
  wire  GEN_4;
  wire  GEN_6;
  wire  GEN_7;
  wire [1:0] GEN_8;
  wire [7:0] GEN_9;
  wire [1:0] GEN_10;
  wire  GEN_11;
  wire  GEN_12;
  wire  GEN_13;
  wire  GEN_14;
  wire  T_206;
  wire  T_207;
  wire  GEN_15;
  wire  GEN_16;
  wire  GEN_17;
  wire  GEN_18;
  wire  GEN_19;
  wire  GEN_20;
  wire [7:0] GEN_21;
  wire  GEN_22;
  wire  GEN_23;
  wire  GEN_24;
  wire  GEN_25;
  wire  GEN_26;
  wire  GEN_27;
  wire  T_212;
  wire  T_213;
  wire [7:0] GEN_28;
  wire  GEN_29;
  wire [1:0] GEN_30;
  wire  GEN_31;
  wire  GEN_32;
  wire  GEN_33;
  wire  GEN_34;
  wire [7:0] GEN_35;
  wire [1:0] GEN_36;
  wire  GEN_37;
  wire  GEN_38;
  wire  GEN_39;
  wire  GEN_40;
  wire  GEN_41;
  wire  GEN_42;
  wire  GEN_43;
  wire  GEN_44;
  wire  GEN_45;
  wire  GEN_46;
  wire [1:0] GEN_47;
  wire  T_216;
  wire  T_218;
  wire  T_219;
  wire [1:0] GEN_48;
  wire  GEN_49;
  wire [7:0] GEN_50;
  wire [1:0] GEN_51;
  wire  T_220;
  wire [3:0] GEN_67;
  wire [3:0] T_224;
  wire [3:0] T_228;
  wire  T_229;
  wire  T_230;
  wire  T_231;
  wire  T_232;
  wire  T_240_0;
  wire  T_240_1;
  wire  T_240_2;
  wire  T_240_3;
  wire  GEN_52;
  wire  GEN_53;
  wire  GEN_54;
  wire  GEN_55;
  wire [1:0] GEN_56;
  wire [7:0] GEN_57;
  wire  GEN_58;
  wire  GEN_59;
  wire  GEN_60;
  wire  GEN_61;
  wire  GEN_62;
  wire  GEN_63;
  wire  GEN_64;
  wire [1:0] GEN_65;
  sirv_qspi_physical_1 phy (
    .clock(phy_clock),
    .reset(phy_reset),
    .io_port_sck(phy_io_port_sck),
    .io_port_dq_0_i(phy_io_port_dq_0_i),
    .io_port_dq_0_o(phy_io_port_dq_0_o),
    .io_port_dq_0_oe(phy_io_port_dq_0_oe),
    .io_port_dq_1_i(phy_io_port_dq_1_i),
    .io_port_dq_1_o(phy_io_port_dq_1_o),
    .io_port_dq_1_oe(phy_io_port_dq_1_oe),
    .io_port_dq_2_i(phy_io_port_dq_2_i),
    .io_port_dq_2_o(phy_io_port_dq_2_o),
    .io_port_dq_2_oe(phy_io_port_dq_2_oe),
    .io_port_dq_3_i(phy_io_port_dq_3_i),
    .io_port_dq_3_o(phy_io_port_dq_3_o),
    .io_port_dq_3_oe(phy_io_port_dq_3_oe),
    .io_port_cs_0(phy_io_port_cs_0),
    .io_port_cs_1(phy_io_port_cs_1),
    .io_port_cs_2(phy_io_port_cs_2),
    .io_port_cs_3(phy_io_port_cs_3),
    .io_ctrl_sck_div(phy_io_ctrl_sck_div),
    .io_ctrl_sck_pol(phy_io_ctrl_sck_pol),
    .io_ctrl_sck_pha(phy_io_ctrl_sck_pha),
    .io_ctrl_fmt_proto(phy_io_ctrl_fmt_proto),
    .io_ctrl_fmt_endian(phy_io_ctrl_fmt_endian),
    .io_ctrl_fmt_iodir(phy_io_ctrl_fmt_iodir),
    .io_op_ready(phy_io_op_ready),
    .io_op_valid(phy_io_op_valid),
    .io_op_bits_fn(phy_io_op_bits_fn),
    .io_op_bits_stb(phy_io_op_bits_stb),
    .io_op_bits_cnt(phy_io_op_bits_cnt),
    .io_op_bits_data(phy_io_op_bits_data),
    .io_rx_valid(phy_io_rx_valid),
    .io_rx_bits(phy_io_rx_bits)
  );
  assign io_port_sck = phy_io_port_sck;
  assign io_port_dq_0_o = phy_io_port_dq_0_o;
  assign io_port_dq_0_oe = phy_io_port_dq_0_oe;
  assign io_port_dq_1_o = phy_io_port_dq_1_o;
  assign io_port_dq_1_oe = phy_io_port_dq_1_oe;
  assign io_port_dq_2_o = phy_io_port_dq_2_o;
  assign io_port_dq_2_oe = phy_io_port_dq_2_oe;
  assign io_port_dq_3_o = phy_io_port_dq_3_o;
  assign io_port_dq_3_oe = phy_io_port_dq_3_oe;
  assign io_port_cs_0 = cs_dflt_0;
  assign io_port_cs_1 = cs_dflt_1;
  assign io_port_cs_2 = cs_dflt_2;
  assign io_port_cs_3 = cs_dflt_3;
  assign io_link_tx_ready = GEN_40;
  assign io_link_rx_valid = phy_io_rx_valid;
  assign io_link_rx_bits = phy_io_rx_bits;
  assign io_link_active = cs_assert;
  assign phy_clock = clock;
  assign phy_reset = reset;
  assign phy_io_port_dq_0_i = io_port_dq_0_i;
  assign phy_io_port_dq_1_i = io_port_dq_1_i;
  assign phy_io_port_dq_2_i = io_port_dq_2_i;
  assign phy_io_port_dq_3_i = io_port_dq_3_i;
  assign phy_io_ctrl_sck_div = io_ctrl_sck_div;
  assign phy_io_ctrl_sck_pol = io_ctrl_sck_pol;
  assign phy_io_ctrl_sck_pha = io_ctrl_sck_pha;
  assign phy_io_ctrl_fmt_proto = io_link_fmt_proto;
  assign phy_io_ctrl_fmt_endian = io_link_fmt_endian;
  assign phy_io_ctrl_fmt_iodir = io_link_fmt_iodir;
  assign phy_io_op_valid = GEN_49;
  assign phy_io_op_bits_fn = GEN_37;
  assign phy_io_op_bits_stb = GEN_58;
  assign phy_io_op_bits_cnt = GEN_57;
  assign phy_io_op_bits_data = io_link_tx_bits;
  assign GEN_66 = {{3'd0}, io_link_cs_set};
  assign T_162 = GEN_66 << io_ctrl_cs_id;
  assign T_163 = {io_ctrl_cs_dflt_1,io_ctrl_cs_dflt_0};
  assign T_164 = {io_ctrl_cs_dflt_3,io_ctrl_cs_dflt_2};
  assign T_165 = {T_164,T_163};
  assign T_166 = T_165 ^ T_162;
  assign T_167 = T_166[0];
  assign T_168 = T_166[1];
  assign T_169 = T_166[2];
  assign T_170 = T_166[3];
  assign cs_active_0 = T_167;
  assign cs_active_1 = T_168;
  assign cs_active_2 = T_169;
  assign cs_active_3 = T_170;
  assign T_184 = {cs_active_1,cs_active_0};
  assign T_185 = {cs_active_3,cs_active_2};
  assign T_186 = {T_185,T_184};
  assign T_187 = {cs_dflt_1,cs_dflt_0};
  assign T_188 = {cs_dflt_3,cs_dflt_2};
  assign T_189 = {T_188,T_187};
  assign cs_update = T_186 != T_189;
  assign T_193 = io_link_cs_hold == 1'h0;
  assign T_194 = cs_update & T_193;
  assign cs_deassert = clear | T_194;
  assign T_195 = io_link_cs_clear & cs_assert;
  assign T_196 = clear | T_195;
  assign continuous = io_ctrl_dla_interxfr == 8'h0;
  assign T_200 = 2'h0 == state;
  assign GEN_0 = phy_io_op_ready ? 2'h2 : state;
  assign GEN_1 = cs_deassert ? io_ctrl_dla_sckcs : io_link_cnt;
  assign GEN_2 = cs_deassert ? GEN_0 : state;
  assign T_202 = cs_deassert == 1'h0;
  assign T_204 = phy_io_op_ready & phy_io_op_valid;
  assign GEN_3 = T_204 ? 2'h1 : GEN_2;
  assign GEN_4 = T_202 ? 1'h0 : 1'h1;
  assign GEN_6 = T_202 ? io_link_tx_valid : 1'h1;
  assign GEN_7 = T_202 ? phy_io_op_ready : 1'h0;
  assign GEN_8 = T_202 ? GEN_3 : GEN_2;
  assign GEN_9 = cs_assert ? GEN_1 : io_link_cnt;
  assign GEN_10 = cs_assert ? GEN_8 : state;
  assign GEN_11 = cs_assert ? GEN_4 : 1'h1;
  assign GEN_12 = cs_assert ? T_202 : 1'h0;
  assign GEN_13 = cs_assert ? GEN_6 : 1'h1;
  assign GEN_14 = cs_assert ? GEN_7 : 1'h0;
  assign T_206 = cs_assert == 1'h0;
  assign T_207 = T_206 & io_link_tx_valid;
  assign GEN_15 = phy_io_op_ready ? 1'h1 : cs_assert;
  assign GEN_16 = phy_io_op_ready ? io_link_cs_set : cs_set;
  assign GEN_17 = phy_io_op_ready ? cs_active_0 : cs_dflt_0;
  assign GEN_18 = phy_io_op_ready ? cs_active_1 : cs_dflt_1;
  assign GEN_19 = phy_io_op_ready ? cs_active_2 : cs_dflt_2;
  assign GEN_20 = phy_io_op_ready ? cs_active_3 : cs_dflt_3;
  assign GEN_21 = T_207 ? io_ctrl_dla_cssck : GEN_9;
  assign GEN_22 = T_207 ? GEN_15 : cs_assert;
  assign GEN_23 = T_207 ? GEN_16 : cs_set;
  assign GEN_24 = T_207 ? GEN_17 : cs_dflt_0;
  assign GEN_25 = T_207 ? GEN_18 : cs_dflt_1;
  assign GEN_26 = T_207 ? GEN_19 : cs_dflt_2;
  assign GEN_27 = T_207 ? GEN_20 : cs_dflt_3;
  assign T_212 = io_link_tx_valid == 1'h0;
  assign T_213 = T_206 & T_212;
  assign GEN_28 = T_213 ? 8'h0 : GEN_21;
  assign GEN_29 = T_213 ? 1'h1 : GEN_12;
  assign GEN_30 = T_213 ? io_ctrl_cs_id : cs_id;
  assign GEN_31 = T_213 ? io_ctrl_cs_dflt_0 : GEN_24;
  assign GEN_32 = T_213 ? io_ctrl_cs_dflt_1 : GEN_25;
  assign GEN_33 = T_213 ? io_ctrl_cs_dflt_2 : GEN_26;
  assign GEN_34 = T_213 ? io_ctrl_cs_dflt_3 : GEN_27;
  assign GEN_35 = T_200 ? GEN_28 : io_link_cnt;
  assign GEN_36 = T_200 ? GEN_10 : state;
  assign GEN_37 = T_200 ? GEN_11 : 1'h1;
  assign GEN_38 = T_200 ? GEN_29 : 1'h0;
  assign GEN_39 = T_200 ? GEN_13 : 1'h1;
  assign GEN_40 = T_200 ? GEN_14 : 1'h0;
  assign GEN_41 = T_200 ? GEN_22 : cs_assert;
  assign GEN_42 = T_200 ? GEN_23 : cs_set;
  assign GEN_43 = T_200 ? GEN_31 : cs_dflt_0;
  assign GEN_44 = T_200 ? GEN_32 : cs_dflt_1;
  assign GEN_45 = T_200 ? GEN_33 : cs_dflt_2;
  assign GEN_46 = T_200 ? GEN_34 : cs_dflt_3;
  assign GEN_47 = T_200 ? GEN_30 : cs_id;
  assign T_216 = 2'h1 == state;
  assign T_218 = continuous == 1'h0;
  assign T_219 = phy_io_op_ready | continuous;
  assign GEN_48 = T_219 ? 2'h0 : GEN_36;
  assign GEN_49 = T_216 ? T_218 : GEN_39;
  assign GEN_50 = T_216 ? io_ctrl_dla_interxfr : GEN_35;
  assign GEN_51 = T_216 ? GEN_48 : GEN_36;
  assign T_220 = 2'h2 == state;
  assign GEN_67 = {{3'd0}, cs_set};
  assign T_224 = GEN_67 << cs_id;
  assign T_228 = T_189 ^ T_224;
  assign T_229 = T_228[0];
  assign T_230 = T_228[1];
  assign T_231 = T_228[2];
  assign T_232 = T_228[3];
  assign T_240_0 = T_229;
  assign T_240_1 = T_230;
  assign T_240_2 = T_231;
  assign T_240_3 = T_232;
  assign GEN_52 = phy_io_op_ready ? T_240_0 : GEN_43;
  assign GEN_53 = phy_io_op_ready ? T_240_1 : GEN_44;
  assign GEN_54 = phy_io_op_ready ? T_240_2 : GEN_45;
  assign GEN_55 = phy_io_op_ready ? T_240_3 : GEN_46;
  assign GEN_56 = phy_io_op_ready ? 2'h0 : GEN_51;
  assign GEN_57 = T_220 ? io_ctrl_dla_intercs : GEN_50;
  assign GEN_58 = T_220 ? 1'h1 : GEN_38;
  assign GEN_59 = T_220 ? 1'h0 : GEN_41;
  assign GEN_60 = T_220 ? 1'h0 : T_196;
  assign GEN_61 = T_220 ? GEN_52 : GEN_43;
  assign GEN_62 = T_220 ? GEN_53 : GEN_44;
  assign GEN_63 = T_220 ? GEN_54 : GEN_45;
  assign GEN_64 = T_220 ? GEN_55 : GEN_46;
  assign GEN_65 = T_220 ? GEN_56 : GEN_51;

  always @(posedge clock or posedge reset)
  if(reset) begin
    cs_id     <= 2'b0;
    cs_dflt_0 <= 1'b1;
    cs_dflt_1 <= 1'b1;
    cs_dflt_2 <= 1'b1;
    cs_dflt_3 <= 1'b1;
    cs_set    <= 1'b0;
  end
  else begin//{

    if (T_200) begin
      if (T_213) begin
        cs_id <= io_ctrl_cs_id;
      end
    end
    if (T_220) begin
      if (phy_io_op_ready) begin
        cs_dflt_0 <= T_240_0;
      end else begin
        if (T_200) begin
          if (T_213) begin
            cs_dflt_0 <= io_ctrl_cs_dflt_0;
          end else begin
            if (T_207) begin
              if (phy_io_op_ready) begin
                cs_dflt_0 <= cs_active_0;
              end
            end
          end
        end
      end
    end else begin
      if (T_200) begin
        if (T_213) begin
          cs_dflt_0 <= io_ctrl_cs_dflt_0;
        end else begin
          if (T_207) begin
            if (phy_io_op_ready) begin
              cs_dflt_0 <= cs_active_0;
            end
          end
        end
      end
    end
    if (T_220) begin
      if (phy_io_op_ready) begin
        cs_dflt_1 <= T_240_1;
      end else begin
        if (T_200) begin
          if (T_213) begin
            cs_dflt_1 <= io_ctrl_cs_dflt_1;
          end else begin
            if (T_207) begin
              if (phy_io_op_ready) begin
                cs_dflt_1 <= cs_active_1;
              end
            end
          end
        end
      end
    end else begin
      if (T_200) begin
        if (T_213) begin
          cs_dflt_1 <= io_ctrl_cs_dflt_1;
        end else begin
          if (T_207) begin
            if (phy_io_op_ready) begin
              cs_dflt_1 <= cs_active_1;
            end
          end
        end
      end
    end
    if (T_220) begin
      if (phy_io_op_ready) begin
        cs_dflt_2 <= T_240_2;
      end else begin
        if (T_200) begin
          if (T_213) begin
            cs_dflt_2 <= io_ctrl_cs_dflt_2;
          end else begin
            if (T_207) begin
              if (phy_io_op_ready) begin
                cs_dflt_2 <= cs_active_2;
              end
            end
          end
        end
      end
    end else begin
      if (T_200) begin
        if (T_213) begin
          cs_dflt_2 <= io_ctrl_cs_dflt_2;
        end else begin
          if (T_207) begin
            if (phy_io_op_ready) begin
              cs_dflt_2 <= cs_active_2;
            end
          end
        end
      end
    end
    if (T_220) begin
      if (phy_io_op_ready) begin
        cs_dflt_3 <= T_240_3;
      end else begin
        if (T_200) begin
          if (T_213) begin
            cs_dflt_3 <= io_ctrl_cs_dflt_3;
          end else begin
            if (T_207) begin
              if (phy_io_op_ready) begin
                cs_dflt_3 <= cs_active_3;
              end
            end
          end
        end
      end
    end else begin
      if (T_200) begin
        if (T_213) begin
          cs_dflt_3 <= io_ctrl_cs_dflt_3;
        end else begin
          if (T_207) begin
            if (phy_io_op_ready) begin
              cs_dflt_3 <= cs_active_3;
            end
          end
        end
      end
    end
    if (T_200) begin
      if (T_207) begin
        if (phy_io_op_ready) begin
          cs_set <= io_link_cs_set;
        end
      end
    end

  end//}


  always @(posedge clock or posedge reset)
    if (reset) begin
      clear <= 1'h0;
    end else begin
      if (T_220) begin
        clear <= 1'h0;
      end else begin
        clear <= T_196;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      cs_assert <= 1'h0;
    end else begin
      if (T_220) begin
        cs_assert <= 1'h0;
      end else begin
        if (T_200) begin
          if (T_207) begin
            if (phy_io_op_ready) begin
              cs_assert <= 1'h1;
            end
          end
        end
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      state <= 2'h0;
    end else begin
      if (T_220) begin
        if (phy_io_op_ready) begin
          state <= 2'h0;
        end else begin
          if (T_216) begin
            if (T_219) begin
              state <= 2'h0;
            end else begin
              if (T_200) begin
                if (cs_assert) begin
                  if (T_202) begin
                    if (T_204) begin
                      state <= 2'h1;
                    end else begin
                      if (cs_deassert) begin
                        if (phy_io_op_ready) begin
                          state <= 2'h2;
                        end
                      end
                    end
                  end else begin
                    if (cs_deassert) begin
                      if (phy_io_op_ready) begin
                        state <= 2'h2;
                      end
                    end
                  end
                end
              end
            end
          end else begin
            if (T_200) begin
              if (cs_assert) begin
                if (T_202) begin
                  if (T_204) begin
                    state <= 2'h1;
                  end else begin
                    if (cs_deassert) begin
                      if (phy_io_op_ready) begin
                        state <= 2'h2;
                      end
                    end
                  end
                end else begin
                  if (cs_deassert) begin
                    if (phy_io_op_ready) begin
                      state <= 2'h2;
                    end
                  end
                end
              end
            end
          end
        end
      end else begin
        if (T_216) begin
          if (T_219) begin
            state <= 2'h0;
          end else begin
            if (T_200) begin
              if (cs_assert) begin
                if (T_202) begin
                  if (T_204) begin
                    state <= 2'h1;
                  end else begin
                    state <= GEN_2;
                  end
                end else begin
                  state <= GEN_2;
                end
              end
            end
          end
        end else begin
          if (T_200) begin
            if (cs_assert) begin
              if (T_202) begin
                if (T_204) begin
                  state <= 2'h1;
                end else begin
                  state <= GEN_2;
                end
              end else begin
                state <= GEN_2;
              end
            end
          end
        end
      end
    end

endmodule
