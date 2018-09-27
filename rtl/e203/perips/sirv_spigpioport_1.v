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
                                                                         
                                                                         
                                                                         
module sirv_spigpioport_1(
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
  wire  T_270;
  wire  T_273;
  wire  T_276;
  assign io_spi_dq_0_i = io_pins_dq_0_i_ival;
  assign io_spi_dq_1_i = io_pins_dq_1_i_ival;
  assign io_spi_dq_2_i = io_pins_dq_2_i_ival;
  assign io_spi_dq_3_i = io_pins_dq_3_i_ival;
  assign io_pins_sck_o_oval = io_spi_sck;
  assign io_pins_sck_o_oe = 1'h1;
  assign io_pins_sck_o_ie = 1'h0;
  assign io_pins_sck_o_pue = 1'h0;
  assign io_pins_sck_o_ds = 1'h0;
  assign io_pins_dq_0_o_oval = io_spi_dq_0_o;
  assign io_pins_dq_0_o_oe = io_spi_dq_0_oe;
  assign io_pins_dq_0_o_ie = T_267;
  assign io_pins_dq_0_o_pue = 1'h1;
  assign io_pins_dq_0_o_ds = 1'h0;
  assign io_pins_dq_1_o_oval = io_spi_dq_1_o;
  assign io_pins_dq_1_o_oe = io_spi_dq_1_oe;
  assign io_pins_dq_1_o_ie = T_270;
  assign io_pins_dq_1_o_pue = 1'h1;
  assign io_pins_dq_1_o_ds = 1'h0;
  assign io_pins_dq_2_o_oval = io_spi_dq_2_o;
  assign io_pins_dq_2_o_oe = io_spi_dq_2_oe;
  assign io_pins_dq_2_o_ie = T_273;
  assign io_pins_dq_2_o_pue = 1'h1;
  assign io_pins_dq_2_o_ds = 1'h0;
  assign io_pins_dq_3_o_oval = io_spi_dq_3_o;
  assign io_pins_dq_3_o_oe = io_spi_dq_3_oe;
  assign io_pins_dq_3_o_ie = T_276;
  assign io_pins_dq_3_o_pue = 1'h1;
  assign io_pins_dq_3_o_ds = 1'h0;
  assign io_pins_cs_0_o_oval = io_spi_cs_0;
  assign io_pins_cs_0_o_oe = 1'h1;
  assign io_pins_cs_0_o_ie = 1'h0;
  assign io_pins_cs_0_o_pue = 1'h0;
  assign io_pins_cs_0_o_ds = 1'h0;
  assign T_267 = ~ io_spi_dq_0_oe;
  assign T_270 = ~ io_spi_dq_1_oe;
  assign T_273 = ~ io_spi_dq_2_oe;
  assign T_276 = ~ io_spi_dq_3_oe;
endmodule

