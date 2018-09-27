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
                                                                         
                                                                         
                                                                         

module sirv_qspi_physical_1(
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
  input  [1:0] io_ctrl_fmt_proto,
  input   io_ctrl_fmt_endian,
  input   io_ctrl_fmt_iodir,
  output  io_op_ready,
  input   io_op_valid,
  input   io_op_bits_fn,
  input   io_op_bits_stb,
  input  [7:0] io_op_bits_cnt,
  input  [7:0] io_op_bits_data,
  output  io_rx_valid,
  output [7:0] io_rx_bits
);
  reg [11:0] ctrl_sck_div;
  reg [31:0] GEN_2;
  reg  ctrl_sck_pol;
  reg [31:0] GEN_31;
  reg  ctrl_sck_pha;
  reg [31:0] GEN_52;
  reg [1:0] ctrl_fmt_proto;
  reg [31:0] GEN_67;
  reg  ctrl_fmt_endian;
  reg [31:0] GEN_68;
  reg  ctrl_fmt_iodir;
  reg [31:0] GEN_69;
  wire  proto_0;
  wire  proto_1;
  wire  proto_2;
  wire  accept;
  wire  sample;
  wire  setup;
  wire  last;
  reg  setup_d;
  reg [31:0] GEN_70;
  reg  T_119;
  reg [31:0] GEN_71;
  reg  T_120;
  reg [31:0] GEN_72;
  reg  sample_d;
  reg [31:0] GEN_73;
  reg  T_122;
  reg [31:0] GEN_74;
  reg  T_123;
  reg [31:0] GEN_75;
  reg  last_d;
  reg [31:0] GEN_76;
  reg [7:0] scnt;
  reg [31:0] GEN_77;
  reg [11:0] tcnt;
  reg [31:0] GEN_78;
  wire  stop;
  wire  beat;
  wire [11:0] T_127;
  wire [12:0] T_129;
  wire [11:0] decr;
  wire  sched;
  wire [11:0] T_130;
  reg  sck;
  reg [31:0] GEN_79;
  reg  cref;
  reg [31:0] GEN_80;
  wire  cinv;
  wire [1:0] T_133;
  wire [1:0] T_134;
  wire [3:0] rxd;
  wire  samples_0;
  wire [1:0] samples_1;
  reg [7:0] buffer;
  reg [31:0] GEN_81;
  wire  T_135;
  wire  T_136;
  wire  T_137;
  wire  T_138;
  wire  T_139;
  wire  T_140;
  wire  T_141;
  wire  T_142;
  wire  T_143;
  wire [1:0] T_144;
  wire [1:0] T_145;
  wire [3:0] T_146;
  wire [1:0] T_147;
  wire [1:0] T_148;
  wire [3:0] T_149;
  wire [7:0] T_150;
  wire [7:0] buffer_in;
  wire  T_151;
  wire  shift;
  wire [6:0] T_152;
  wire [6:0] T_153;
  wire [6:0] T_154;
  wire  T_155;
  wire  T_157;
  wire [7:0] T_158;
  wire [5:0] T_159;
  wire [5:0] T_160;
  wire [5:0] T_161;
  wire [1:0] T_162;
  wire [1:0] T_163;
  wire [7:0] T_164;
  wire [3:0] T_165;
  wire [3:0] T_166;
  wire [3:0] T_167;
  wire [3:0] T_169;
  wire [7:0] T_170;
  wire [7:0] T_172;
  wire [7:0] T_174;
  wire [7:0] T_176;
  wire [7:0] T_178;
  wire [7:0] T_179;
  wire [7:0] T_180;
  reg [3:0] txd;
  reg [31:0] GEN_82;
  wire [3:0] T_182;
  wire [3:0] txd_in;
  wire [1:0] T_184;
  wire  txd_sel_0;
  wire  txd_sel_1;
  wire  txd_sel_2;
  wire  txd_shf_0;
  wire [1:0] txd_shf_1;
  wire  T_186;
  wire [1:0] T_188;
  wire [3:0] T_190;
  wire [1:0] GEN_65;
  wire [1:0] T_192;
  wire [3:0] GEN_66;
  wire [3:0] T_193;
  wire [3:0] T_194;
  wire [3:0] GEN_0;
  wire  T_195;
  wire  T_196;
  wire  txen_1;
  wire  txen_0;
  wire  T_208_0;
  wire  T_208_1;
  wire  T_208_2;
  wire  T_208_3;
  wire  T_215;
  wire  T_216;
  wire  T_217;
  wire  T_218;
  reg  done;
  reg [31:0] GEN_83;
  wire  T_221;
  wire  T_222;
  wire  T_224;
  wire  T_225;
  wire  T_226;
  wire  T_227;
  wire  T_228;
  wire  T_229;
  wire  T_230;
  wire [1:0] T_231;
  wire [1:0] T_232;
  wire [3:0] T_233;
  wire [1:0] T_234;
  wire [1:0] T_235;
  wire [3:0] T_236;
  wire [7:0] T_237;
  wire [7:0] T_238;
  reg  xfr;
  reg [31:0] GEN_84;
  wire  GEN_1;
  wire  T_243;
  wire  T_245;
  wire  T_246;
  wire  GEN_3;
  wire  GEN_4;
  wire  GEN_5;
  wire [11:0] GEN_6;
  wire  GEN_7;
  wire  GEN_8;
  wire  GEN_9;
  wire  GEN_10;
  wire [11:0] GEN_11;
  wire  GEN_12;
  wire  GEN_13;
  wire  GEN_14;
  wire  GEN_15;
  wire [11:0] GEN_16;
  wire  T_252;
  wire  T_253;
  wire  T_254;
  wire  T_257;
  wire  GEN_17;
  wire  GEN_18;
  wire  GEN_19;
  wire  GEN_20;
  wire  GEN_21;
  wire  GEN_22;
  wire  GEN_23;
  wire  T_260;
  wire [1:0] GEN_24;
  wire  GEN_25;
  wire  GEN_26;
  wire  T_263;
  wire  T_266;
  wire [7:0] GEN_27;
  wire  GEN_28;
  wire  GEN_29;
  wire  GEN_30;
  wire  GEN_32;
  wire [11:0] GEN_33;
  wire  GEN_34;
  wire  GEN_35;
  wire  GEN_36;
  wire [11:0] GEN_37;
  wire  GEN_38;
  wire  GEN_39;
  wire [11:0] GEN_40;
  wire [1:0] GEN_41;
  wire  GEN_42;
  wire  GEN_43;
  wire  GEN_44;
  wire [7:0] GEN_45;
  wire  GEN_46;
  wire  GEN_47;
  wire  GEN_48;
  wire [11:0] GEN_49;
  wire  GEN_50;
  wire  GEN_51;
  wire [11:0] GEN_53;
  wire [1:0] GEN_54;
  wire  GEN_55;
  wire  GEN_56;
  wire  GEN_57;
  wire [7:0] GEN_58;
  wire  GEN_59;
  wire  GEN_60;
  wire  GEN_61;
  wire [11:0] GEN_62;
  wire  GEN_63;
  wire  GEN_64;
  assign io_port_sck = sck;
  assign io_port_dq_0_o = T_215;
  assign io_port_dq_0_oe = txen_0;
  assign io_port_dq_1_o = T_216;
  assign io_port_dq_1_oe = txen_1;
  assign io_port_dq_2_o = T_217;
  assign io_port_dq_2_oe = T_196;
  assign io_port_dq_3_o = T_218;
  assign io_port_dq_3_oe = io_port_dq_2_oe;
  assign io_port_cs_0 = T_208_0;
  assign io_port_cs_1 = T_208_1;
  assign io_port_cs_2 = T_208_2;
  assign io_port_cs_3 = T_208_3;
  assign io_op_ready = T_260;
  assign io_rx_valid = done;
  assign io_rx_bits = T_238;
  assign proto_0 = 2'h0 == ctrl_fmt_proto;
  assign proto_1 = 2'h1 == ctrl_fmt_proto;
  assign proto_2 = 2'h2 == ctrl_fmt_proto;
  assign accept = GEN_21;
  assign sample = GEN_14;
  assign setup = GEN_60;
  assign last = GEN_20;
  assign stop = scnt == 8'h0;
  assign beat = tcnt == 12'h0;
  assign T_127 = beat ? {{4'd0}, scnt} : tcnt;
  assign T_129 = T_127 - 12'h1;
  assign decr = T_129[11:0];
  assign sched = GEN_1;
  assign T_130 = sched ? ctrl_sck_div : decr;
  assign cinv = ctrl_sck_pha ^ ctrl_sck_pol;
  assign T_133 = {io_port_dq_1_i,io_port_dq_0_i};
  assign T_134 = {io_port_dq_3_i,io_port_dq_2_i};
  assign rxd = {T_134,T_133};
  assign samples_0 = rxd[1];
  assign samples_1 = rxd[1:0];
  assign T_135 = io_ctrl_fmt_endian == 1'h0;
  assign T_136 = io_op_bits_data[0];
  assign T_137 = io_op_bits_data[1];
  assign T_138 = io_op_bits_data[2];
  assign T_139 = io_op_bits_data[3];
  assign T_140 = io_op_bits_data[4];
  assign T_141 = io_op_bits_data[5];
  assign T_142 = io_op_bits_data[6];
  assign T_143 = io_op_bits_data[7];
  assign T_144 = {T_142,T_143};
  assign T_145 = {T_140,T_141};
  assign T_146 = {T_145,T_144};
  assign T_147 = {T_138,T_139};
  assign T_148 = {T_136,T_137};
  assign T_149 = {T_148,T_147};
  assign T_150 = {T_149,T_146};
  assign buffer_in = T_135 ? io_op_bits_data : T_150;
  assign T_151 = sample_d & stop;
  assign shift = setup_d | T_151;
  assign T_152 = buffer[6:0];
  assign T_153 = buffer[7:1];
  assign T_154 = shift ? T_152 : T_153;
  assign T_155 = buffer[0];
  assign T_157 = sample_d ? samples_0 : T_155;
  assign T_158 = {T_154,T_157};
  assign T_159 = buffer[5:0];
  assign T_160 = buffer[7:2];
  assign T_161 = shift ? T_159 : T_160;
  assign T_162 = buffer[1:0];
  assign T_163 = sample_d ? samples_1 : T_162;
  assign T_164 = {T_161,T_163};
  assign T_165 = buffer[3:0];
  assign T_166 = buffer[7:4];
  assign T_167 = shift ? T_165 : T_166;
  assign T_169 = sample_d ? rxd : T_165;
  assign T_170 = {T_167,T_169};
  assign T_172 = proto_0 ? T_158 : 8'h0;
  assign T_174 = proto_1 ? T_164 : 8'h0;
  assign T_176 = proto_2 ? T_170 : 8'h0;
  assign T_178 = T_172 | T_174;
  assign T_179 = T_178 | T_176;
  assign T_180 = T_179;
  assign T_182 = buffer_in[7:4];
  assign txd_in = accept ? T_182 : T_166;
  assign T_184 = accept ? io_ctrl_fmt_proto : ctrl_fmt_proto;
  assign txd_sel_0 = 2'h0 == T_184;
  assign txd_sel_1 = 2'h1 == T_184;
  assign txd_sel_2 = 2'h2 == T_184;
  assign txd_shf_0 = txd_in[3];
  assign txd_shf_1 = txd_in[3:2];
  assign T_186 = txd_sel_0 ? txd_shf_0 : 1'h0;
  assign T_188 = txd_sel_1 ? txd_shf_1 : 2'h0;
  assign T_190 = txd_sel_2 ? txd_in : 4'h0;
  assign GEN_65 = {{1'd0}, T_186};
  assign T_192 = GEN_65 | T_188;
  assign GEN_66 = {{2'd0}, T_192};
  assign T_193 = GEN_66 | T_190;
  assign T_194 = T_193;
  assign GEN_0 = setup ? T_194 : txd;
  assign T_195 = proto_1 & ctrl_fmt_iodir;
  assign T_196 = proto_2 & ctrl_fmt_iodir;
  assign txen_1 = T_195 | T_196;
  assign txen_0 = proto_0 | txen_1;
  assign T_208_0 = 1'h1;
  assign T_208_1 = 1'h1;
  assign T_208_2 = 1'h1;
  assign T_208_3 = 1'h1;
  assign T_215 = txd[0];
  assign T_216 = txd[1];
  assign T_217 = txd[2];
  assign T_218 = txd[3];
  assign T_221 = done | last_d;
  assign T_222 = ctrl_fmt_endian == 1'h0;
  assign T_224 = buffer[1];
  assign T_225 = buffer[2];
  assign T_226 = buffer[3];
  assign T_227 = buffer[4];
  assign T_228 = buffer[5];
  assign T_229 = buffer[6];
  assign T_230 = buffer[7];
  assign T_231 = {T_229,T_230};
  assign T_232 = {T_227,T_228};
  assign T_233 = {T_232,T_231};
  assign T_234 = {T_225,T_226};
  assign T_235 = {T_155,T_224};
  assign T_236 = {T_235,T_234};
  assign T_237 = {T_236,T_233};
  assign T_238 = T_222 ? buffer : T_237;
  assign GEN_1 = stop ? 1'h1 : beat;
  assign T_243 = stop == 1'h0;
  assign T_245 = cref == 1'h0;
  assign T_246 = cref ^ cinv;
  assign GEN_3 = xfr ? T_246 : sck;
  assign GEN_4 = xfr ? cref : 1'h0;
  assign GEN_5 = xfr ? T_245 : 1'h0;
  assign GEN_6 = T_245 ? decr : {{4'd0}, scnt};
  assign GEN_7 = beat ? T_245 : cref;
  assign GEN_8 = beat ? GEN_3 : sck;
  assign GEN_9 = beat ? GEN_4 : 1'h0;
  assign GEN_10 = beat ? GEN_5 : 1'h0;
  assign GEN_11 = beat ? GEN_6 : {{4'd0}, scnt};
  assign GEN_12 = T_243 ? GEN_7 : cref;
  assign GEN_13 = T_243 ? GEN_8 : sck;
  assign GEN_14 = T_243 ? GEN_9 : 1'h0;
  assign GEN_15 = T_243 ? GEN_10 : 1'h0;
  assign GEN_16 = T_243 ? GEN_11 : {{4'd0}, scnt};
  assign T_252 = scnt == 8'h1;
  assign T_253 = beat & cref;
  assign T_254 = T_253 & xfr;
  assign T_257 = beat & T_245;
  assign GEN_17 = T_257 ? 1'h1 : stop;
  assign GEN_18 = T_257 ? 1'h0 : GEN_15;
  assign GEN_19 = T_257 ? ctrl_sck_pol : GEN_13;
  assign GEN_20 = T_252 ? T_254 : 1'h0;
  assign GEN_21 = T_252 ? GEN_17 : stop;
  assign GEN_22 = T_252 ? GEN_18 : GEN_15;
  assign GEN_23 = T_252 ? GEN_19 : GEN_13;
  assign T_260 = accept & done;
  assign GEN_24 = io_op_bits_stb ? io_ctrl_fmt_proto : ctrl_fmt_proto;
  assign GEN_25 = io_op_bits_stb ? io_ctrl_fmt_endian : ctrl_fmt_endian;
  assign GEN_26 = io_op_bits_stb ? io_ctrl_fmt_iodir : ctrl_fmt_iodir;
  assign T_263 = 1'h0 == io_op_bits_fn;
  assign T_266 = io_op_bits_cnt == 8'h0;
  assign GEN_27 = T_263 ? buffer_in : T_180;
  assign GEN_28 = T_263 ? cinv : GEN_23;
  assign GEN_29 = T_263 ? 1'h1 : GEN_22;
  assign GEN_30 = T_263 ? T_266 : T_221;
  assign GEN_32 = io_op_bits_stb ? io_ctrl_sck_pol : GEN_28;
  assign GEN_33 = io_op_bits_stb ? io_ctrl_sck_div : ctrl_sck_div;
  assign GEN_34 = io_op_bits_stb ? io_ctrl_sck_pol : ctrl_sck_pol;
  assign GEN_35 = io_op_bits_stb ? io_ctrl_sck_pha : ctrl_sck_pha;
  assign GEN_36 = io_op_bits_fn ? GEN_32 : GEN_28;
  assign GEN_37 = io_op_bits_fn ? GEN_33 : ctrl_sck_div;
  assign GEN_38 = io_op_bits_fn ? GEN_34 : ctrl_sck_pol;
  assign GEN_39 = io_op_bits_fn ? GEN_35 : ctrl_sck_pha;
  assign GEN_40 = io_op_valid ? {{4'd0}, io_op_bits_cnt} : GEN_16;
  assign GEN_41 = io_op_valid ? GEN_24 : ctrl_fmt_proto;
  assign GEN_42 = io_op_valid ? GEN_25 : ctrl_fmt_endian;
  assign GEN_43 = io_op_valid ? GEN_26 : ctrl_fmt_iodir;
  assign GEN_44 = io_op_valid ? T_263 : xfr;
  assign GEN_45 = io_op_valid ? GEN_27 : T_180;
  assign GEN_46 = io_op_valid ? GEN_36 : GEN_23;
  assign GEN_47 = io_op_valid ? GEN_29 : GEN_22;
  assign GEN_48 = io_op_valid ? GEN_30 : T_221;
  assign GEN_49 = io_op_valid ? GEN_37 : ctrl_sck_div;
  assign GEN_50 = io_op_valid ? GEN_38 : ctrl_sck_pol;
  assign GEN_51 = io_op_valid ? GEN_39 : ctrl_sck_pha;
  assign GEN_53 = T_260 ? GEN_40 : GEN_16;
  assign GEN_54 = T_260 ? GEN_41 : ctrl_fmt_proto;
  assign GEN_55 = T_260 ? GEN_42 : ctrl_fmt_endian;
  assign GEN_56 = T_260 ? GEN_43 : ctrl_fmt_iodir;
  assign GEN_57 = T_260 ? GEN_44 : xfr;
  assign GEN_58 = T_260 ? GEN_45 : T_180;
  assign GEN_59 = T_260 ? GEN_46 : GEN_23;
  assign GEN_60 = T_260 ? GEN_47 : GEN_22;
  assign GEN_61 = T_260 ? GEN_48 : T_221;
  assign GEN_62 = T_260 ? GEN_49 : ctrl_sck_div;
  assign GEN_63 = T_260 ? GEN_50 : ctrl_sck_pol;
  assign GEN_64 = T_260 ? GEN_51 : ctrl_sck_pha;

  always @(posedge clock or posedge reset)
  if (reset) begin
    ctrl_sck_div <= 12'b0;
    ctrl_sck_pol <= 1'b0;
    ctrl_sck_pha <= 1'b0;
    ctrl_fmt_proto <= 2'b0;
    ctrl_fmt_endian <= 1'b0;
    ctrl_fmt_iodir <= 1'b0;
    setup_d <= 1'b0;
    tcnt <= 12'b0;
    sck <= 1'b0;
    buffer <= 8'b0;
    xfr <= 1'b0;
  end
  else begin
    if (T_260) begin
      if (io_op_valid) begin
        if (io_op_bits_fn) begin
          if (io_op_bits_stb) begin
            ctrl_sck_div <= io_ctrl_sck_div;
          end
        end
      end
    end
    if (T_260) begin
      if (io_op_valid) begin
        if (io_op_bits_fn) begin
          if (io_op_bits_stb) begin
            ctrl_sck_pol <= io_ctrl_sck_pol;
          end
        end
      end
    end
    if (T_260) begin
      if (io_op_valid) begin
        if (io_op_bits_fn) begin
          if (io_op_bits_stb) begin
            ctrl_sck_pha <= io_ctrl_sck_pha;
          end
        end
      end
    end
    if (T_260) begin
      if (io_op_valid) begin
        if (io_op_bits_stb) begin
          ctrl_fmt_proto <= io_ctrl_fmt_proto;
        end
      end
    end
    if (T_260) begin
      if (io_op_valid) begin
        if (io_op_bits_stb) begin
          ctrl_fmt_endian <= io_ctrl_fmt_endian;
        end
      end
    end
    if (T_260) begin
      if (io_op_valid) begin
        if (io_op_bits_stb) begin
          ctrl_fmt_iodir <= io_ctrl_fmt_iodir;
        end
      end
    end
    setup_d <= setup;




    if (sched) begin
      tcnt <= ctrl_sck_div;
    end else begin
      tcnt <= decr;
    end
    if (T_260) begin
      if (io_op_valid) begin
        if (io_op_bits_fn) begin
          if (io_op_bits_stb) begin
            sck <= io_ctrl_sck_pol;
          end else begin
            if (T_263) begin
              sck <= cinv;
            end else begin
              if (T_252) begin
                if (T_257) begin
                  sck <= ctrl_sck_pol;
                end else begin
                  if (T_243) begin
                    if (beat) begin
                      if (xfr) begin
                        sck <= T_246;
                      end
                    end
                  end
                end
              end else begin
                if (T_243) begin
                  if (beat) begin
                    if (xfr) begin
                      sck <= T_246;
                    end
                  end
                end
              end
            end
          end
        end else begin
          if (T_263) begin
            sck <= cinv;
          end else begin
            if (T_252) begin
              if (T_257) begin
                sck <= ctrl_sck_pol;
              end else begin
                if (T_243) begin
                  if (beat) begin
                    if (xfr) begin
                      sck <= T_246;
                    end
                  end
                end
              end
            end else begin
              if (T_243) begin
                if (beat) begin
                  if (xfr) begin
                    sck <= T_246;
                  end
                end
              end
            end
          end
        end
      end else begin
        if (T_252) begin
          if (T_257) begin
            sck <= ctrl_sck_pol;
          end else begin
            sck <= GEN_13;
          end
        end else begin
          sck <= GEN_13;
        end
      end
    end else begin
      if (T_252) begin
        if (T_257) begin
          sck <= ctrl_sck_pol;
        end else begin
          sck <= GEN_13;
        end
      end else begin
        sck <= GEN_13;
      end
    end



    if (T_260) begin
      if (io_op_valid) begin
        if (T_263) begin
          if (T_135) begin
            buffer <= io_op_bits_data;
          end else begin
            buffer <= T_150;
          end
        end else begin
          buffer <= T_180;
        end
      end else begin
        buffer <= T_180;
      end
    end else begin
      buffer <= T_180;
    end
    
    if (T_260) begin
      if (io_op_valid) begin
        xfr <= T_263;
      end
    end

  end


  always @(posedge clock or posedge reset)
    if (reset) begin
      cref <= 1'h1;
    end else begin
      if (T_243) begin
        if (beat) begin
          cref <= T_245;
        end
      end
    end


  always @(posedge clock or posedge reset)
    if (reset) begin
      txd <= 4'h0;
    end else begin
      if (setup) begin
        txd <= T_194;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      done <= 1'h1;
    end else begin
      if (T_260) begin
        if (io_op_valid) begin
          if (T_263) begin
            done <= T_266;
          end else begin
            done <= T_221;
          end
        end else begin
          done <= T_221;
        end
      end else begin
        done <= T_221;
      end
    end



  always @(posedge clock or posedge reset)
    if (reset) begin
      T_119 <= 1'h0;
    end else begin
      T_119 <= sample;
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      T_120 <= 1'h0;
    end else begin
      T_120 <= T_119;
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sample_d <= 1'h0;
    end else begin
      sample_d <= T_120;
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      T_122 <= 1'h0;
    end else begin
      T_122 <= last;
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      T_123 <= 1'h0;
    end else begin
      T_123 <= T_122;
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      last_d <= 1'h0;
    end else begin
      last_d <= T_123;
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      scnt <= 8'h0;
    end else begin
      scnt <= GEN_53[7:0];
    end

endmodule
