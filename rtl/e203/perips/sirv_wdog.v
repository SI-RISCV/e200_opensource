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
                                                                         
                                                                         
                                                                         

module sirv_wdog(
  input   clock,
  input   reset,
  input   io_regs_cfg_write_valid,
  input  [31:0] io_regs_cfg_write_bits,
  output [31:0] io_regs_cfg_read,
  input   io_regs_countLo_write_valid,
  input  [31:0] io_regs_countLo_write_bits,
  output [31:0] io_regs_countLo_read,
  input   io_regs_countHi_write_valid,
  input  [31:0] io_regs_countHi_write_bits,
  output [31:0] io_regs_countHi_read,
  input   io_regs_s_write_valid,
  input  [15:0] io_regs_s_write_bits,
  output [15:0] io_regs_s_read,
  input   io_regs_cmp_0_write_valid,
  input  [15:0] io_regs_cmp_0_write_bits,
  output [15:0] io_regs_cmp_0_read,
  input   io_regs_feed_write_valid,
  input  [31:0] io_regs_feed_write_bits,
  output [31:0] io_regs_feed_read,
  input   io_regs_key_write_valid,
  input  [31:0] io_regs_key_write_bits,
  output [31:0] io_regs_key_read,
  output  io_ip_0,
  input   io_corerst,
  output  io_rst
);
  wire [3:0] T_138;
  wire  T_139;
  wire  T_140;
  wire  T_141;
  wire  T_142;
  wire  T_143;
  wire  T_145;
  wire  T_147;
  wire  T_148;
  wire  T_149;
  wire  AsyncResetRegVec_2_1_clock;
  wire  AsyncResetRegVec_2_1_reset;
  wire  AsyncResetRegVec_2_1_io_d;
  wire  AsyncResetRegVec_2_1_io_q;
  wire  AsyncResetRegVec_2_1_io_en;
  wire  unlocked;
  wire  T_150;
  reg [3:0] scale;
  reg [31:0] GEN_10;
  wire [3:0] GEN_0;
  wire  T_152;
  reg [15:0] cmp_0;
  reg [31:0] GEN_11;
  wire [15:0] GEN_1;
  reg  T_154;
  reg [31:0] GEN_12;
  reg  T_155;
  reg [31:0] GEN_13;
  wire  T_156;
  wire  AsyncResetRegVec_3_1_clock;
  wire  AsyncResetRegVec_3_1_reset;
  wire  AsyncResetRegVec_3_1_io_d;
  wire  AsyncResetRegVec_3_1_io_q;
  wire  AsyncResetRegVec_3_1_io_en;
  wire  countAlways;
  wire  T_158;
  wire  AsyncResetRegVec_4_1_clock;
  wire  AsyncResetRegVec_4_1_reset;
  wire  AsyncResetRegVec_4_1_io_d;
  wire  AsyncResetRegVec_4_1_io_q;
  wire  AsyncResetRegVec_4_1_io_en;
  wire  countAwake;
  wire  T_161;
  wire  T_162;
  wire  countEn;
  reg [4:0] T_164;
  reg [31:0] GEN_14;
  wire [4:0] GEN_9;
  wire [5:0] T_165;
  reg [25:0] T_167;
  reg [31:0] GEN_15;
  wire  T_168;
  wire [26:0] T_170;
  wire [26:0] GEN_2;
  wire [30:0] T_171;
  wire  T_172;
  wire [32:0] T_174;
  wire [27:0] T_175;
  wire [32:0] GEN_3;
  wire [27:0] GEN_4;
  wire [30:0] T_176;
  wire [15:0] s;
  wire  elapsed_0;
  wire  T_183;
  wire  T_185;
  wire  feed;
  wire  T_186;
  reg  zerocmp;
  reg [31:0] GEN_16;
  wire  GEN_5;
  wire  T_189;
  wire  countReset;
  wire [32:0] GEN_6;
  wire [27:0] GEN_7;
  wire  T_192;
  wire  T_193;
  wire  T_195;
  reg  ip;
  reg [31:0] GEN_17;
  wire  GEN_8;
  wire  T_209;
  wire  AsyncResetRegVec_5_1_clock;
  wire  AsyncResetRegVec_5_1_reset;
  wire  AsyncResetRegVec_5_1_io_d;
  wire  AsyncResetRegVec_5_1_io_q;
  wire  AsyncResetRegVec_5_1_io_en;
  wire  rsten;
  wire [4:0] T_214;
  wire [8:0] T_215;
  wire [2:0] T_217;
  wire [11:0] T_218;
  wire [2:0] T_219;
  wire [3:0] T_220;
  wire [4:0] T_222;
  wire [12:0] T_223;
  wire [16:0] T_224;
  wire [28:0] T_225;
  wire  T_230_0;
  wire  T_234;
  wire  AsyncResetRegVec_6_1_clock;
  wire  AsyncResetRegVec_6_1_reset;
  wire  AsyncResetRegVec_6_1_io_d;
  wire  AsyncResetRegVec_6_1_io_q;
  wire  AsyncResetRegVec_6_1_io_en;
  sirv_AsyncResetRegVec AsyncResetRegVec_2_1 (
    .clock(AsyncResetRegVec_2_1_clock),
    .reset(AsyncResetRegVec_2_1_reset),
    .io_d(AsyncResetRegVec_2_1_io_d),
    .io_q(AsyncResetRegVec_2_1_io_q),
    .io_en(AsyncResetRegVec_2_1_io_en)
  );
  sirv_AsyncResetRegVec AsyncResetRegVec_3_1 (
    .clock(AsyncResetRegVec_3_1_clock),
    .reset(AsyncResetRegVec_3_1_reset),
    .io_d(AsyncResetRegVec_3_1_io_d),
    .io_q(AsyncResetRegVec_3_1_io_q),
    .io_en(AsyncResetRegVec_3_1_io_en)
  );
  sirv_AsyncResetRegVec AsyncResetRegVec_4_1 (
    .clock(AsyncResetRegVec_4_1_clock),
    .reset(AsyncResetRegVec_4_1_reset),
    .io_d(AsyncResetRegVec_4_1_io_d),
    .io_q(AsyncResetRegVec_4_1_io_q),
    .io_en(AsyncResetRegVec_4_1_io_en)
  );
  sirv_AsyncResetRegVec AsyncResetRegVec_5_1 (
    .clock(AsyncResetRegVec_5_1_clock),
    .reset(AsyncResetRegVec_5_1_reset),
    .io_d(AsyncResetRegVec_5_1_io_d),
    .io_q(AsyncResetRegVec_5_1_io_q),
    .io_en(AsyncResetRegVec_5_1_io_en)
  );
  sirv_AsyncResetRegVec AsyncResetRegVec_6_1 (
    .clock(AsyncResetRegVec_6_1_clock),
    .reset(AsyncResetRegVec_6_1_reset),
    .io_d(AsyncResetRegVec_6_1_io_d),
    .io_q(AsyncResetRegVec_6_1_io_q),
    .io_en(AsyncResetRegVec_6_1_io_en)
  );
  assign io_regs_cfg_read = {{3'd0}, T_225};
  assign io_regs_countLo_read = {{1'd0}, T_171};
  assign io_regs_countHi_read = 32'h0;
  assign io_regs_s_read = s;
  assign io_regs_cmp_0_read = cmp_0;
  assign io_regs_feed_read = 32'h0;
  assign io_regs_key_read = {{31'd0}, unlocked};
  assign io_ip_0 = T_230_0;
  assign io_rst = AsyncResetRegVec_6_1_io_q;
  assign T_138 = io_regs_cfg_write_bits[3:0];
  assign T_139 = io_regs_feed_write_valid | io_regs_cmp_0_write_valid;
  assign T_140 = T_139 | io_regs_s_write_valid;
  assign T_141 = T_140 | io_regs_countHi_write_valid;
  assign T_142 = T_141 | io_regs_countLo_write_valid;
  assign T_143 = T_142 | io_regs_cfg_write_valid;
  assign T_145 = io_regs_key_write_bits == 32'h51f15e;
  assign T_147 = T_143 == 1'h0;
  assign T_148 = T_145 & T_147;
  assign T_149 = io_regs_key_write_valid | T_143;
  assign AsyncResetRegVec_2_1_clock = clock;
  assign AsyncResetRegVec_2_1_reset = reset;
  assign AsyncResetRegVec_2_1_io_d = T_148;
  assign AsyncResetRegVec_2_1_io_en = T_149;
  assign unlocked = AsyncResetRegVec_2_1_io_q;
  assign T_150 = io_regs_cfg_write_valid & unlocked;
  assign GEN_0 = T_150 ? T_138 : scale;
  assign T_152 = io_regs_cmp_0_write_valid & unlocked;
  assign GEN_1 = T_152 ? io_regs_cmp_0_write_bits : cmp_0;
  assign T_156 = io_regs_cfg_write_bits[12];
  assign AsyncResetRegVec_3_1_clock = clock;
  assign AsyncResetRegVec_3_1_reset = reset;
  assign AsyncResetRegVec_3_1_io_d = T_156;
  assign AsyncResetRegVec_3_1_io_en = T_150;
  assign countAlways = AsyncResetRegVec_3_1_io_q;
  assign T_158 = io_regs_cfg_write_bits[13];
  assign AsyncResetRegVec_4_1_clock = clock;
  assign AsyncResetRegVec_4_1_reset = reset;
  assign AsyncResetRegVec_4_1_io_d = T_158;
  assign AsyncResetRegVec_4_1_io_en = T_150;
  assign countAwake = AsyncResetRegVec_4_1_io_q;
  assign T_161 = T_155 == 1'h0;
  assign T_162 = countAwake & T_161;
  assign countEn = countAlways | T_162;
  assign GEN_9 = {{4'd0}, countEn};
  assign T_165 = T_164 + GEN_9;
  assign T_168 = T_165[5];
  assign T_170 = T_167 + 26'h1;
  assign GEN_2 = T_168 ? T_170 : {{1'd0}, T_167};
  assign T_171 = {T_167,T_164};
  assign T_172 = io_regs_countLo_write_valid & unlocked;
  assign T_174 = {1'h0,io_regs_countLo_write_bits};
  assign T_175 = T_174[32:5];
  assign GEN_3 = T_172 ? T_174 : {{27'd0}, T_165};
  assign GEN_4 = T_172 ? T_175 : {{1'd0}, GEN_2};
  assign T_176 = T_171 >> scale;
  assign s = T_176[15:0];
  assign elapsed_0 = s >= cmp_0;
  assign T_183 = unlocked & io_regs_feed_write_valid;
  assign T_185 = io_regs_feed_write_bits == 32'hd09f00d;
  assign feed = T_183 & T_185;
  assign T_186 = io_regs_cfg_write_bits[9];
  assign GEN_5 = T_150 ? T_186 : zerocmp;
  assign T_189 = zerocmp & elapsed_0;
  assign countReset = feed | T_189;
  assign GEN_6 = countReset ? 33'h0 : GEN_3;
  assign GEN_7 = countReset ? 28'h0 : GEN_4;
  assign T_192 = io_regs_cfg_write_bits[28];
  assign T_193 = T_192 | elapsed_0;
  assign T_195 = T_150 | elapsed_0;
  assign GEN_8 = T_195 ? T_193 : ip;
  assign T_209 = io_regs_cfg_write_bits[8];
  assign AsyncResetRegVec_5_1_clock = clock;
  assign AsyncResetRegVec_5_1_reset = reset;
  assign AsyncResetRegVec_5_1_io_d = T_209;
  assign AsyncResetRegVec_5_1_io_en = T_150;
  assign rsten = AsyncResetRegVec_5_1_io_q;
  assign T_214 = {rsten,4'h0};
  assign T_215 = {T_214,scale};
  assign T_217 = {2'h0,zerocmp};
  assign T_218 = {T_217,T_215};
  assign T_219 = {2'h0,countAwake};
  assign T_220 = {T_219,countAlways};
  assign T_222 = {ip,4'h0};
  assign T_223 = {T_222,8'h0};
  assign T_224 = {T_223,T_220};
  assign T_225 = {T_224,T_218};
  assign T_230_0 = ip;
  assign T_234 = rsten & elapsed_0;
  assign AsyncResetRegVec_6_1_clock = clock;
  assign AsyncResetRegVec_6_1_reset = reset;
  assign AsyncResetRegVec_6_1_io_d = 1'h1;
  assign AsyncResetRegVec_6_1_io_en = T_234;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_10 = {1{$random}};
  scale = GEN_10[3:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_11 = {1{$random}};
  cmp_0 = GEN_11[15:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_12 = {1{$random}};
  T_154 = GEN_12[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_13 = {1{$random}};
  T_155 = GEN_13[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_14 = {1{$random}};
  T_164 = GEN_14[4:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_15 = {1{$random}};
  T_167 = GEN_15[25:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_16 = {1{$random}};
  zerocmp = GEN_16[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_17 = {1{$random}};
  ip = GEN_17[0:0];
  `endif
  end
`endif
  always @(posedge clock or posedge reset) begin
  if(reset) begin
      scale <= 4'b0;
      cmp_0 <= 16'hFFFF;
      T_154 <= 1'b0;
      T_155 <= 1'b0;
      T_164 <= 5'b0;
      T_167 <= 26'b0;
      zerocmp <= 1'b0;
      ip <= 1'b0;
  end
  else begin
    if (T_150) begin
      scale <= T_138;
    end
    if (T_152) begin
      cmp_0 <= io_regs_cmp_0_write_bits;
    end
    T_154 <= io_corerst;
    T_155 <= T_154;
    T_164 <= GEN_6[4:0];
    T_167 <= GEN_7[25:0];
    if (T_150) begin
      zerocmp <= T_186;
    end
    if (T_195) begin
      ip <= T_193;
    end
  end
  end
endmodule
