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
                                                                         
                                                                         
                                                                         

module sirv_pwm8_core(
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
  input  [7:0] io_regs_s_write_bits,
  output [7:0] io_regs_s_read,
  input   io_regs_cmp_0_write_valid,
  input  [7:0] io_regs_cmp_0_write_bits,
  output [7:0] io_regs_cmp_0_read,
  input   io_regs_cmp_1_write_valid,
  input  [7:0] io_regs_cmp_1_write_bits,
  output [7:0] io_regs_cmp_1_read,
  input   io_regs_cmp_2_write_valid,
  input  [7:0] io_regs_cmp_2_write_bits,
  output [7:0] io_regs_cmp_2_read,
  input   io_regs_cmp_3_write_valid,
  input  [7:0] io_regs_cmp_3_write_bits,
  output [7:0] io_regs_cmp_3_read,
  input   io_regs_feed_write_valid,
  input  [31:0] io_regs_feed_write_bits,
  output [31:0] io_regs_feed_read,
  input   io_regs_key_write_valid,
  input  [31:0] io_regs_key_write_bits,
  output [31:0] io_regs_key_read,
  output  io_ip_0,
  output  io_ip_1,
  output  io_ip_2,
  output  io_ip_3,
  output  io_gpio_0,
  output  io_gpio_1,
  output  io_gpio_2,
  output  io_gpio_3
);
  wire [3:0] T_178;
  reg [3:0] scale;
  reg [31:0] GEN_21;
  wire [3:0] GEN_0;
  reg [7:0] cmp_0;
  reg [31:0] GEN_22;
  wire [7:0] GEN_1;
  reg [7:0] cmp_1;
  reg [31:0] GEN_23;
  wire [7:0] GEN_2;
  reg [7:0] cmp_2;
  reg [31:0] GEN_24;
  wire [7:0] GEN_3;
  reg [7:0] cmp_3;
  reg [31:0] GEN_25;
  wire [7:0] GEN_4;
  wire  countEn;
  reg [4:0] T_196;
  reg [31:0] GEN_26;
  wire [4:0] GEN_18;
  wire [5:0] T_197;
  reg [17:0] T_199;
  reg [31:0] GEN_27;
  wire  T_200;
  wire [18:0] T_202;
  wire [18:0] GEN_5;
  wire [22:0] T_203;
  wire [32:0] T_207;
  wire [27:0] T_208;
  wire [32:0] GEN_6;
  wire [27:0] GEN_7;
  wire [22:0] T_209;
  wire [7:0] s;
  wire  T_210;
  wire [3:0] T_211;
  reg [3:0] center;
  reg [31:0] GEN_28;
  wire [3:0] GEN_8;
  wire  T_215;
  wire  T_216;
  wire [7:0] T_217;
  wire [7:0] T_218;
  wire  elapsed_0;
  wire  T_220;
  wire  T_221;
  wire [7:0] T_223;
  wire  elapsed_1;
  wire  T_225;
  wire  T_226;
  wire [7:0] T_228;
  wire  elapsed_2;
  wire  T_230;
  wire  T_231;
  wire [7:0] T_233;
  wire  elapsed_3;
  wire [5:0] GEN_19;
  wire [5:0] T_234;
  wire [4:0] T_235;
  wire [18:0] GEN_20;
  wire [18:0] T_239;
  wire [18:0] T_241;
  wire [17:0] T_242;
  wire [22:0] T_243;
  wire [4:0] T_245;
  wire [3:0] T_246;
  wire [22:0] T_247;
  wire  feed;
  wire  T_248;
  reg  zerocmp;
  reg [31:0] GEN_29;
  wire  GEN_9;
  wire  T_252;
  wire  countReset;
  wire [32:0] GEN_10;
  wire [27:0] GEN_11;
  wire  T_255;
  reg  T_259;
  reg [31:0] GEN_30;
  wire  GEN_12;
  wire  T_261;
  wire  T_262;
  wire  T_263;
  reg  T_267;
  reg [31:0] GEN_31;
  wire  GEN_13;
  wire  T_268;
  reg  T_269;
  reg [31:0] GEN_32;
  wire [1:0] T_282;
  wire [1:0] T_283;
  wire [3:0] T_284;
  reg [3:0] ip;
  reg [31:0] GEN_33;
  wire [1:0] T_286;
  wire [1:0] T_287;
  wire [3:0] T_288;
  wire [3:0] T_289;
  wire [3:0] T_290;
  wire [3:0] T_297;
  wire [3:0] T_298;
  wire [3:0] T_299;
  wire [3:0] T_300;
  wire [3:0] T_301;
  wire [3:0] T_304;
  wire [3:0] GEN_14;
  wire [3:0] T_305;
  reg [3:0] gang;
  reg [31:0] GEN_34;
  wire [3:0] GEN_15;
  wire  T_316;
  wire  T_319;
  wire  T_323;
  reg  oneShot;
  reg [31:0] GEN_35;
  wire  GEN_16;
  wire  T_325;
  reg  countAlways;
  reg [31:0] GEN_36;
  wire  GEN_17;
  wire [4:0] T_333;
  wire [8:0] T_334;
  wire [1:0] T_335;
  wire [2:0] T_336;
  wire [11:0] T_337;
  wire [2:0] T_338;
  wire [3:0] T_339;
  wire [7:0] T_340;
  wire [7:0] T_341;
  wire [15:0] T_342;
  wire [19:0] T_343;
  wire [31:0] T_344;
  wire  T_350_0;
  wire  T_350_1;
  wire  T_350_2;
  wire  T_350_3;
  wire  T_352;
  wire  T_353;
  wire  T_354;
  wire  T_355;
  wire [2:0] T_357;
  wire [3:0] T_358;
  wire [3:0] T_359;
  wire [3:0] T_360;
  wire [3:0] T_361;
  wire  T_364_0;
  wire  T_364_1;
  wire  T_364_2;
  wire  T_364_3;
  wire  T_366;
  wire  T_367;
  wire  T_368;
  wire  T_369;
  wire  T_370;
  assign io_regs_cfg_read = T_344;
  assign io_regs_countLo_read = {{9'd0}, T_203};
  assign io_regs_countHi_read = 32'h0;
  assign io_regs_s_read = s;
  assign io_regs_cmp_0_read = cmp_0;
  assign io_regs_cmp_1_read = cmp_1;
  assign io_regs_cmp_2_read = cmp_2;
  assign io_regs_cmp_3_read = cmp_3;
  assign io_regs_feed_read = 32'h0;
  assign io_regs_key_read = 32'h1;
  assign io_ip_0 = T_350_0;
  assign io_ip_1 = T_350_1;
  assign io_ip_2 = T_350_2;
  assign io_ip_3 = T_350_3;
  assign io_gpio_0 = T_364_0;
  assign io_gpio_1 = T_364_1;
  assign io_gpio_2 = T_364_2;
  assign io_gpio_3 = T_364_3;
  assign T_178 = io_regs_cfg_write_bits[3:0];
  assign GEN_0 = io_regs_cfg_write_valid ? T_178 : scale;
  assign GEN_1 = io_regs_cmp_0_write_valid ? io_regs_cmp_0_write_bits : cmp_0;
  assign GEN_2 = io_regs_cmp_1_write_valid ? io_regs_cmp_1_write_bits : cmp_1;
  assign GEN_3 = io_regs_cmp_2_write_valid ? io_regs_cmp_2_write_bits : cmp_2;
  assign GEN_4 = io_regs_cmp_3_write_valid ? io_regs_cmp_3_write_bits : cmp_3;
  assign countEn = T_370;
  assign GEN_18 = {{4'd0}, countEn};
  assign T_197 = T_196 + GEN_18;
  assign T_200 = T_197[5];
  assign T_202 = T_199 + 18'h1;
  assign GEN_5 = T_200 ? T_202 : {{1'd0}, T_199};
  assign T_203 = {T_199,T_196};
  assign T_207 = {1'h0,io_regs_countLo_write_bits};
  assign T_208 = T_207[32:5];
  assign GEN_6 = io_regs_countLo_write_valid ? T_207 : {{27'd0}, T_197};
  assign GEN_7 = io_regs_countLo_write_valid ? T_208 : {{9'd0}, GEN_5};
  assign T_209 = T_203 >> scale;
  assign s = T_209[7:0];
  assign T_210 = s[7];
  assign T_211 = io_regs_cfg_write_bits[19:16];
  assign GEN_8 = io_regs_cfg_write_valid ? T_211 : center;
  assign T_215 = center[0];
  assign T_216 = T_210 & T_215;
  assign T_217 = ~ s;
  assign T_218 = T_216 ? T_217 : s;
  assign elapsed_0 = T_218 >= cmp_0;
  assign T_220 = center[1];
  assign T_221 = T_210 & T_220;
  assign T_223 = T_221 ? T_217 : s;
  assign elapsed_1 = T_223 >= cmp_1;
  assign T_225 = center[2];
  assign T_226 = T_210 & T_225;
  assign T_228 = T_226 ? T_217 : s;
  assign elapsed_2 = T_228 >= cmp_2;
  assign T_230 = center[3];
  assign T_231 = T_210 & T_230;
  assign T_233 = T_231 ? T_217 : s;
  assign elapsed_3 = T_233 >= cmp_3;
  assign GEN_19 = {{1'd0}, T_196};
  assign T_234 = GEN_19 ^ T_197;
  assign T_235 = T_234[5:1];
  assign GEN_20 = {{1'd0}, T_199};
  assign T_239 = GEN_20 ^ T_202;
  assign T_241 = T_200 ? T_239 : 19'h0;
  assign T_242 = T_241[18:1];
  assign T_243 = {T_242,T_235};
  assign T_245 = scale + 4'h8;
  assign T_246 = T_245[3:0];
  assign T_247 = T_243 >> T_246;
  assign feed = T_247[0];
  assign T_248 = io_regs_cfg_write_bits[9];
  assign GEN_9 = io_regs_cfg_write_valid ? T_248 : zerocmp;
  assign T_252 = zerocmp & elapsed_0;
  assign countReset = feed | T_252;
  assign GEN_10 = countReset ? 33'h0 : GEN_6;
  assign GEN_11 = countReset ? 28'h0 : GEN_7;
  assign T_255 = io_regs_cfg_write_bits[10];
  assign GEN_12 = io_regs_cfg_write_valid ? T_255 : T_259;
  assign T_261 = countReset == 1'h0;
  assign T_262 = T_259 & T_261;
  assign T_263 = io_regs_cfg_write_bits[8];
  assign GEN_13 = io_regs_cfg_write_valid ? T_263 : T_267;
  assign T_268 = T_262 | T_267;
  assign T_282 = {T_221,T_216};
  assign T_283 = {T_231,T_226};
  assign T_284 = {T_283,T_282};
  assign T_286 = {elapsed_1,elapsed_0};
  assign T_287 = {elapsed_3,elapsed_2};
  assign T_288 = {T_287,T_286};
  assign T_289 = T_284 & T_288;
  assign T_290 = ~ T_284;
  assign T_297 = T_269 ? 4'hf : 4'h0;
  assign T_298 = T_297 & ip;
  assign T_299 = T_288 | T_298;
  assign T_300 = T_290 & T_299;
  assign T_301 = T_289 | T_300;
  assign T_304 = io_regs_cfg_write_bits[31:28];
  assign GEN_14 = io_regs_cfg_write_valid ? T_304 : T_301;
  assign T_305 = io_regs_cfg_write_bits[27:24];
  assign GEN_15 = io_regs_cfg_write_valid ? T_305 : gang;
  assign T_316 = io_regs_cfg_write_bits[13];
  assign T_319 = T_316 & T_261;
  assign T_323 = io_regs_cfg_write_valid | countReset;
  assign GEN_16 = T_323 ? T_319 : oneShot;
  assign T_325 = io_regs_cfg_write_bits[12];
  assign GEN_17 = io_regs_cfg_write_valid ? T_325 : countAlways;
  assign T_333 = {T_267,4'h0};
  assign T_334 = {T_333,scale};
  assign T_335 = {1'h0,T_259};
  assign T_336 = {T_335,zerocmp};
  assign T_337 = {T_336,T_334};
  assign T_338 = {2'h0,oneShot};
  assign T_339 = {T_338,countAlways};
  assign T_340 = {4'h0,center};
  assign T_341 = {ip,gang};
  assign T_342 = {T_341,T_340};
  assign T_343 = {T_342,T_339};
  assign T_344 = {T_343,T_337};
  assign T_350_0 = T_352;
  assign T_350_1 = T_353;
  assign T_350_2 = T_354;
  assign T_350_3 = T_355;
  assign T_352 = ip[0];
  assign T_353 = ip[1];
  assign T_354 = ip[2];
  assign T_355 = ip[3];
  assign T_357 = ip[3:1];
  assign T_358 = {T_352,T_357};
  assign T_359 = gang & T_358;
  assign T_360 = ~ T_359;
  assign T_361 = ip & T_360;
  assign T_364_0 = T_366;
  assign T_364_1 = T_367;
  assign T_364_2 = T_368;
  assign T_364_3 = T_369;
  assign T_366 = T_361[0];
  assign T_367 = T_361[1];
  assign T_368 = T_361[2];
  assign T_369 = T_361[3];
  assign T_370 = countAlways | oneShot;
  
  always @(posedge clock or posedge reset)
  if(reset) begin
      scale <= 4'b0;
      cmp_0 <= 8'b0;
      cmp_1 <= 8'b0;
      cmp_2 <= 8'b0;
      cmp_3 <= 8'b0;
      T_196 <= 5'b0;
      T_199 <= 18'b0;
      center <= 4'b0;
      zerocmp <= 1'b0;
      T_259 <= 1'b0;
      T_267 <= 1'b0;
      T_269 <= 1'b0;
      ip <= 4'b0;
      gang <= 4'b0;
  end
  else begin
    if (io_regs_cfg_write_valid) begin
      scale <= T_178;
    end
    if (io_regs_cmp_0_write_valid) begin
      cmp_0 <= io_regs_cmp_0_write_bits;
    end
    if (io_regs_cmp_1_write_valid) begin
      cmp_1 <= io_regs_cmp_1_write_bits;
    end
    if (io_regs_cmp_2_write_valid) begin
      cmp_2 <= io_regs_cmp_2_write_bits;
    end
    if (io_regs_cmp_3_write_valid) begin
      cmp_3 <= io_regs_cmp_3_write_bits;
    end
    T_196 <= GEN_10[4:0];
    T_199 <= GEN_11[17:0];
    if (io_regs_cfg_write_valid) begin
      center <= T_211;
    end
    if (io_regs_cfg_write_valid) begin
      zerocmp <= T_248;
    end
    if (io_regs_cfg_write_valid) begin
      T_259 <= T_255;
    end
    if (io_regs_cfg_write_valid) begin
      T_267 <= T_263;
    end
    T_269 <= T_268;
    if (io_regs_cfg_write_valid) begin
      ip <= T_304;
    end else begin
      ip <= T_301;
    end
    if (io_regs_cfg_write_valid) begin
      gang <= T_305;
    end
  end

  always @(posedge clock or posedge reset)
    if (reset) begin
      oneShot <= 1'h0;
    end else begin
      if (T_323) begin
        oneShot <= T_319;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      countAlways <= 1'h0;
    end else begin
      if (io_regs_cfg_write_valid) begin
        countAlways <= T_325;
      end
    end

endmodule
