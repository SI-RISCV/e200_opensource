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
                                                                         
                                                                         
                                                                         

module sirv_rtc(
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
  input  [31:0] io_regs_s_write_bits,
  output [31:0] io_regs_s_read,
  input   io_regs_cmp_0_write_valid,
  input  [31:0] io_regs_cmp_0_write_bits,
  output [31:0] io_regs_cmp_0_read,
  input   io_regs_feed_write_valid,
  input  [31:0] io_regs_feed_write_bits,
  output [31:0] io_regs_feed_read,
  input   io_regs_key_write_valid,
  input  [31:0] io_regs_key_write_bits,
  output [31:0] io_regs_key_read,
  output  io_ip_0
);
  wire [3:0] T_134;
  reg [3:0] scale;
  reg [31:0] GEN_7;
  wire [3:0] GEN_0;
  reg [31:0] cmp_0;
  reg [31:0] GEN_8;
  wire [31:0] GEN_1;
  wire  T_141;
  wire  AsyncResetRegVec_1_clock;
  wire  AsyncResetRegVec_1_reset;
  wire  AsyncResetRegVec_1_io_d;
  wire  AsyncResetRegVec_1_io_q;
  wire  AsyncResetRegVec_1_io_en;
  wire  countAlways;
  reg [5:0] T_145;
  reg [31:0] GEN_10;
  wire [5:0] GEN_9;
  wire [6:0] T_146;
  reg [41:0] T_148;
  reg [63:0] GEN_11;
  wire  T_149;
  wire [42:0] T_151;
  wire [42:0] GEN_2;
  wire [47:0] T_152;
  wire [15:0] T_155;
  wire [47:0] T_156;
  wire [41:0] T_157;
  wire [47:0] GEN_3;
  wire [42:0] GEN_4;
  wire [31:0] T_160;
  wire [63:0] T_161;
  wire [57:0] T_162;
  wire [63:0] GEN_5;
  wire [57:0] GEN_6;
  wire [47:0] T_163;
  wire [31:0] s;
  wire  elapsed_0;
  reg  ip;
  reg [31:0] GEN_12;
  wire [8:0] T_191;
  wire [11:0] T_194;
  wire [3:0] T_196;
  wire [4:0] T_198;
  wire [12:0] T_199;
  wire [16:0] T_200;
  wire [28:0] T_201;
  wire  T_207_0;
  sirv_AsyncResetRegVec AsyncResetRegVec_1 (
    .clock(AsyncResetRegVec_1_clock),
    .reset(AsyncResetRegVec_1_reset),
    .io_d(AsyncResetRegVec_1_io_d),
    .io_q(AsyncResetRegVec_1_io_q),
    .io_en(AsyncResetRegVec_1_io_en)
  );
  assign io_regs_cfg_read = {{3'd0}, T_201};
  assign io_regs_countLo_read = T_152[31:0];
  assign io_regs_countHi_read = {{16'd0}, T_155};
  assign io_regs_s_read = s;
  assign io_regs_cmp_0_read = cmp_0;
  assign io_regs_feed_read = 32'h0;
  assign io_regs_key_read = 32'h1;
  assign io_ip_0 = T_207_0;
  assign T_134 = io_regs_cfg_write_bits[3:0];
  assign GEN_0 = io_regs_cfg_write_valid ? T_134 : scale;
  assign GEN_1 = io_regs_cmp_0_write_valid ? io_regs_cmp_0_write_bits : cmp_0;
  assign T_141 = io_regs_cfg_write_bits[12];
  assign AsyncResetRegVec_1_clock = clock;
  assign AsyncResetRegVec_1_reset = reset;
  assign AsyncResetRegVec_1_io_d = T_141;
  assign AsyncResetRegVec_1_io_en = io_regs_cfg_write_valid;
  assign countAlways = AsyncResetRegVec_1_io_q;
  assign GEN_9 = {{5'd0}, countAlways};
  assign T_146 = T_145 + GEN_9;
  assign T_149 = T_146[6];
  assign T_151 = T_148 + 42'h1;
  assign GEN_2 = T_149 ? T_151 : {{1'd0}, T_148};
  assign T_152 = {T_148,T_145};
  assign T_155 = T_152[47:32];
  assign T_156 = {T_155,io_regs_countLo_write_bits};
  assign T_157 = T_156[47:6];
  assign GEN_3 = io_regs_countLo_write_valid ? T_156 : {{41'd0}, T_146};
  assign GEN_4 = io_regs_countLo_write_valid ? {{1'd0}, T_157} : GEN_2;
  assign T_160 = T_152[31:0];
  assign T_161 = {io_regs_countHi_write_bits,T_160};
  assign T_162 = T_161[63:6];
  assign GEN_5 = io_regs_countHi_write_valid ? T_161 : {{16'd0}, GEN_3};
  assign GEN_6 = io_regs_countHi_write_valid ? T_162 : {{15'd0}, GEN_4};
  assign T_163 = T_152 >> scale;
  assign s = T_163[31:0];
  assign elapsed_0 = s >= cmp_0;
  assign T_191 = {5'h0,scale};
  assign T_194 = {3'h0,T_191};
  assign T_196 = {3'h0,countAlways};
  assign T_198 = {ip,4'h0};
  assign T_199 = {T_198,8'h0};
  assign T_200 = {T_199,T_196};
  assign T_201 = {T_200,T_194};
  assign T_207_0 = ip;

  always @(posedge clock or posedge reset) begin
  if(reset) begin
      scale <= 4'b0;
      cmp_0 <= 32'hFFFF_FFFF;
      T_145 <= 6'b0;
      T_148 <= 42'b0;
      ip <= 1'b0;
  end
  else begin
    if (io_regs_cfg_write_valid) begin
      scale <= T_134;
    end
    if (io_regs_cmp_0_write_valid) begin
      cmp_0 <= io_regs_cmp_0_write_bits;
    end
    T_145 <= GEN_5[5:0];
    T_148 <= GEN_6[41:0];
    ip <= elapsed_0;
  end
  end
endmodule
