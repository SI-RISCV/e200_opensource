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
                                                                         
                                                                         
                                                                         

module sirv_qspi_arbiter(
  input   clock,
  input   reset,
  output  io_inner_0_tx_ready,
  input   io_inner_0_tx_valid,
  input  [7:0] io_inner_0_tx_bits,
  output  io_inner_0_rx_valid,
  output [7:0] io_inner_0_rx_bits,
  input  [7:0] io_inner_0_cnt,
  input  [1:0] io_inner_0_fmt_proto,
  input   io_inner_0_fmt_endian,
  input   io_inner_0_fmt_iodir,
  input   io_inner_0_cs_set,
  input   io_inner_0_cs_clear,
  input   io_inner_0_cs_hold,
  output  io_inner_0_active,
  input   io_inner_0_lock,
  output  io_inner_1_tx_ready,
  input   io_inner_1_tx_valid,
  input  [7:0] io_inner_1_tx_bits,
  output  io_inner_1_rx_valid,
  output [7:0] io_inner_1_rx_bits,
  input  [7:0] io_inner_1_cnt,
  input  [1:0] io_inner_1_fmt_proto,
  input   io_inner_1_fmt_endian,
  input   io_inner_1_fmt_iodir,
  input   io_inner_1_cs_set,
  input   io_inner_1_cs_clear,
  input   io_inner_1_cs_hold,
  output  io_inner_1_active,
  input   io_inner_1_lock,
  input   io_outer_tx_ready,
  output  io_outer_tx_valid,
  output [7:0] io_outer_tx_bits,
  input   io_outer_rx_valid,
  input  [7:0] io_outer_rx_bits,
  output [7:0] io_outer_cnt,
  output [1:0] io_outer_fmt_proto,
  output  io_outer_fmt_endian,
  output  io_outer_fmt_iodir,
  output  io_outer_cs_set,
  output  io_outer_cs_clear,
  output  io_outer_cs_hold,
  input   io_outer_active,
  input   io_sel
);
  wire  T_335_0;
  wire  T_335_1;
  reg  sel_0;
  reg [31:0] GEN_4;
  reg  sel_1;
  reg [31:0] GEN_5;
  wire  T_346;
  wire  T_349;
  wire  T_351;
  wire  T_352;
  wire [7:0] T_354;
  wire [7:0] T_356;
  wire [7:0] T_358;
  wire [7:0] T_359;
  wire [7:0] T_361;
  wire [7:0] T_363;
  wire [7:0] T_365;
  wire [7:0] T_366;
  wire [2:0] T_367;
  wire [3:0] T_368;
  wire [3:0] T_370;
  wire [2:0] T_371;
  wire [3:0] T_372;
  wire [3:0] T_374;
  wire [3:0] T_379;
  wire [1:0] T_384_proto;
  wire  T_384_endian;
  wire  T_384_iodir;
  wire  T_388;
  wire  T_389;
  wire [1:0] T_390;
  wire [1:0] T_391;
  wire [2:0] T_392;
  wire [2:0] T_394;
  wire [1:0] T_395;
  wire [2:0] T_396;
  wire [2:0] T_398;
  wire [2:0] T_406;
  wire  T_414_set;
  wire  T_414_clear;
  wire  T_414_hold;
  wire  T_421;
  wire  T_422;
  wire  T_423;
  wire  T_424;
  wire  T_425;
  wire  T_426;
  wire  T_427;
  wire  T_428;
  wire  T_429;
  wire  T_431;
  wire  nsel_0;
  wire  nsel_1;
  wire  T_445;
  wire  T_448;
  wire  T_450;
  wire  lock;
  wire  T_452;
  wire [1:0] T_453;
  wire [1:0] T_454;
  wire  T_455;
  wire  GEN_0;
  wire  GEN_1;
  wire  GEN_2;
  wire  GEN_3;
  assign io_inner_0_tx_ready = T_424;
  assign io_inner_0_rx_valid = T_425;
  assign io_inner_0_rx_bits = io_outer_rx_bits;
  assign io_inner_0_active = T_426;
  assign io_inner_1_tx_ready = T_427;
  assign io_inner_1_rx_valid = T_428;
  assign io_inner_1_rx_bits = io_outer_rx_bits;
  assign io_inner_1_active = T_429;
  assign io_outer_tx_valid = T_352;
  assign io_outer_tx_bits = T_359;
  assign io_outer_cnt = T_366;
  assign io_outer_fmt_proto = T_384_proto;
  assign io_outer_fmt_endian = T_384_endian;
  assign io_outer_fmt_iodir = T_384_iodir;
  assign io_outer_cs_set = T_414_set;
  assign io_outer_cs_clear = GEN_3;
  assign io_outer_cs_hold = T_414_hold;
  assign T_335_0 = 1'h1;
  assign T_335_1 = 1'h0;
  assign T_346 = sel_0 ? io_inner_0_tx_valid : 1'h0;
  assign T_349 = sel_1 ? io_inner_1_tx_valid : 1'h0;
  assign T_351 = T_346 | T_349;
  assign T_352 = T_351;
  assign T_354 = sel_0 ? io_inner_0_tx_bits : 8'h0;
  assign T_356 = sel_1 ? io_inner_1_tx_bits : 8'h0;
  assign T_358 = T_354 | T_356;
  assign T_359 = T_358;
  assign T_361 = sel_0 ? io_inner_0_cnt : 8'h0;
  assign T_363 = sel_1 ? io_inner_1_cnt : 8'h0;
  assign T_365 = T_361 | T_363;
  assign T_366 = T_365;
  assign T_367 = {io_inner_0_fmt_proto,io_inner_0_fmt_endian};
  assign T_368 = {T_367,io_inner_0_fmt_iodir};
  assign T_370 = sel_0 ? T_368 : 4'h0;
  assign T_371 = {io_inner_1_fmt_proto,io_inner_1_fmt_endian};
  assign T_372 = {T_371,io_inner_1_fmt_iodir};
  assign T_374 = sel_1 ? T_372 : 4'h0;
  assign T_379 = T_370 | T_374;
  assign T_384_proto = T_390;
  assign T_384_endian = T_389;
  assign T_384_iodir = T_388;
  assign T_388 = T_379[0];
  assign T_389 = T_379[1];
  assign T_390 = T_379[3:2];
  assign T_391 = {io_inner_0_cs_set,io_inner_0_cs_clear};
  assign T_392 = {T_391,io_inner_0_cs_hold};
  assign T_394 = sel_0 ? T_392 : 3'h0;
  assign T_395 = {io_inner_1_cs_set,io_inner_1_cs_clear};
  assign T_396 = {T_395,io_inner_1_cs_hold};
  assign T_398 = sel_1 ? T_396 : 3'h0;
  assign T_406 = T_394 | T_398;
  assign T_414_set = T_423;
  assign T_414_clear = T_422;
  assign T_414_hold = T_421;
  assign T_421 = T_406[0];
  assign T_422 = T_406[1];
  assign T_423 = T_406[2];
  assign T_424 = io_outer_tx_ready & sel_0;
  assign T_425 = io_outer_rx_valid & sel_0;
  assign T_426 = io_outer_active & sel_0;
  assign T_427 = io_outer_tx_ready & sel_1;
  assign T_428 = io_outer_rx_valid & sel_1;
  assign T_429 = io_outer_active & sel_1;
  assign T_431 = io_sel == 1'h0;
  assign nsel_0 = T_431;
  assign nsel_1 = io_sel;
  assign T_445 = sel_0 ? io_inner_0_lock : 1'h0;
  assign T_448 = sel_1 ? io_inner_1_lock : 1'h0;
  assign T_450 = T_445 | T_448;
  assign lock = T_450;
  assign T_452 = lock == 1'h0;
  assign T_453 = {sel_1,sel_0};
  assign T_454 = {nsel_1,nsel_0};
  assign T_455 = T_453 != T_454;
  assign GEN_0 = T_455 ? 1'h1 : T_414_clear;
  assign GEN_1 = T_452 ? nsel_0 : sel_0;
  assign GEN_2 = T_452 ? nsel_1 : sel_1;
  assign GEN_3 = T_452 ? GEN_0 : T_414_clear;

  always @(posedge clock or posedge reset)
    if (reset) begin
      sel_0 <= T_335_0;
    end else begin
      if (T_452) begin
        sel_0 <= nsel_0;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sel_1 <= T_335_1;
    end else begin
      if (T_452) begin
        sel_1 <= nsel_1;
      end
    end
  
endmodule
