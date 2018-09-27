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
                                                                         
                                                                         
                                                                         

module sirv_spigpioport_2(
  input   clock,
  input   reset,
  input   io_spi_sck,
  output  io_spi_dq_0_i,
  input   io_spi_dq_0_o,
  input   io_spi_dq_0_oe,
  output  io_spi_dq_1_i,
  input   io_spi_dq_1_o,
  input   io_spi_dq_1_oe,
  output  io_spi_dq_2_i,
  input   io_spi_dq_2_o,
  input   io_spi_dq_2_oe,
  output  io_spi_dq_3_i,
  input   io_spi_dq_3_o,
  input   io_spi_dq_3_oe,
  input   io_spi_cs_0,
  input   io_pins_sck_i_ival,
  output  io_pins_sck_o_oval,
  output  io_pins_sck_o_oe,
  output  io_pins_sck_o_ie,
  output  io_pins_sck_o_pue,
  output  io_pins_sck_o_ds,
  input   io_pins_dq_0_i_ival,
  output  io_pins_dq_0_o_oval,
  output  io_pins_dq_0_o_oe,
  output  io_pins_dq_0_o_ie,
  output  io_pins_dq_0_o_pue,
  output  io_pins_dq_0_o_ds,
  input   io_pins_dq_1_i_ival,
  output  io_pins_dq_1_o_oval,
  output  io_pins_dq_1_o_oe,
  output  io_pins_dq_1_o_ie,
  output  io_pins_dq_1_o_pue,
  output  io_pins_dq_1_o_ds,
  input   io_pins_dq_2_i_ival,
  output  io_pins_dq_2_o_oval,
  output  io_pins_dq_2_o_oe,
  output  io_pins_dq_2_o_ie,
  output  io_pins_dq_2_o_pue,
  output  io_pins_dq_2_o_ds,
  input   io_pins_dq_3_i_ival,
  output  io_pins_dq_3_o_oval,
  output  io_pins_dq_3_o_oe,
  output  io_pins_dq_3_o_ie,
  output  io_pins_dq_3_o_pue,
  output  io_pins_dq_3_o_ds,
  input   io_pins_cs_0_i_ival,
  output  io_pins_cs_0_o_oval,
  output  io_pins_cs_0_o_oe,
  output  io_pins_cs_0_o_ie,
  output  io_pins_cs_0_o_pue,
  output  io_pins_cs_0_o_ds
);
  wire  T_267;
  reg  T_271;
  reg [31:0] GEN_0;
  reg  T_272;
  reg [31:0] GEN_1;
  reg  T_273;
  reg [31:0] GEN_2;
  wire  T_274;
  reg  T_278;
  reg [31:0] GEN_3;
  reg  T_279;
  reg [31:0] GEN_4;
  reg  T_280;
  reg [31:0] GEN_5;
  wire  T_281;
  reg  T_285;
  reg [31:0] GEN_6;
  reg  T_286;
  reg [31:0] GEN_7;
  reg  T_287;
  reg [31:0] GEN_8;
  wire  T_288;
  reg  T_292;
  reg [31:0] GEN_9;
  reg  T_293;
  reg [31:0] GEN_10;
  reg  T_294;
  reg [31:0] GEN_11;
  assign io_spi_dq_0_i = T_273;
  assign io_spi_dq_1_i = T_280;
  assign io_spi_dq_2_i = T_287;
  assign io_spi_dq_3_i = T_294;
  assign io_pins_sck_o_oval = io_spi_sck;
  assign io_pins_sck_o_oe = 1'h1;
  assign io_pins_sck_o_ie = 1'h0;
  assign io_pins_sck_o_pue = 1'h0;
  assign io_pins_sck_o_ds = 1'h1;
  assign io_pins_dq_0_o_oval = io_spi_dq_0_o;
  assign io_pins_dq_0_o_oe = io_spi_dq_0_oe;
  assign io_pins_dq_0_o_ie = T_267;
  assign io_pins_dq_0_o_pue = 1'h1;
  assign io_pins_dq_0_o_ds = 1'h1;
  assign io_pins_dq_1_o_oval = io_spi_dq_1_o;
  assign io_pins_dq_1_o_oe = io_spi_dq_1_oe;
  assign io_pins_dq_1_o_ie = T_274;
  assign io_pins_dq_1_o_pue = 1'h1;
  assign io_pins_dq_1_o_ds = 1'h1;
  assign io_pins_dq_2_o_oval = io_spi_dq_2_o;
  assign io_pins_dq_2_o_oe = io_spi_dq_2_oe;
  assign io_pins_dq_2_o_ie = T_281;
  assign io_pins_dq_2_o_pue = 1'h1;
  assign io_pins_dq_2_o_ds = 1'h1;
  assign io_pins_dq_3_o_oval = io_spi_dq_3_o;
  assign io_pins_dq_3_o_oe = io_spi_dq_3_oe;
  assign io_pins_dq_3_o_ie = T_288;
  assign io_pins_dq_3_o_pue = 1'h1;
  assign io_pins_dq_3_o_ds = 1'h1;
  assign io_pins_cs_0_o_oval = io_spi_cs_0;
  assign io_pins_cs_0_o_oe = 1'h1;
  assign io_pins_cs_0_o_ie = 1'h0;
  assign io_pins_cs_0_o_pue = 1'h0;
  assign io_pins_cs_0_o_ds = 1'h1;
  assign T_267 = ~ io_spi_dq_0_oe;
  assign T_274 = ~ io_spi_dq_1_oe;
  assign T_281 = ~ io_spi_dq_2_oe;
  assign T_288 = ~ io_spi_dq_3_oe;

  always @(posedge clock or posedge reset) begin
  if(reset) begin
    T_271 <= 1'b0;
    T_272 <= 1'b0;
    T_273 <= 1'b0;
    T_278 <= 1'b0;
    T_279 <= 1'b0;
    T_280 <= 1'b0;
    T_285 <= 1'b0;
    T_286 <= 1'b0;
    T_287 <= 1'b0;
    T_292 <= 1'b0;
    T_293 <= 1'b0;
    T_294 <= 1'b0;
  end
  else begin
    T_271 <= io_pins_dq_0_i_ival;
    T_272 <= T_271;
    T_273 <= T_272;
    T_278 <= io_pins_dq_1_i_ival;
    T_279 <= T_278;
    T_280 <= T_279;
    T_285 <= io_pins_dq_2_i_ival;
    T_286 <= T_285;
    T_287 <= T_286;
    T_292 <= io_pins_dq_3_i_ival;
    T_293 <= T_292;
    T_294 <= T_293;
  end
  end
endmodule
