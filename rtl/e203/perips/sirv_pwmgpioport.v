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
                                                                         
                                                                         
                                                                         
module sirv_pwmgpioport(
  input   clock,
  input   reset,
  input   io_pwm_port_0,
  input   io_pwm_port_1,
  input   io_pwm_port_2,
  input   io_pwm_port_3,
  input   io_pins_pwm_0_i_ival,
  output  io_pins_pwm_0_o_oval,
  output  io_pins_pwm_0_o_oe,
  output  io_pins_pwm_0_o_ie,
  output  io_pins_pwm_0_o_pue,
  output  io_pins_pwm_0_o_ds,
  input   io_pins_pwm_1_i_ival,
  output  io_pins_pwm_1_o_oval,
  output  io_pins_pwm_1_o_oe,
  output  io_pins_pwm_1_o_ie,
  output  io_pins_pwm_1_o_pue,
  output  io_pins_pwm_1_o_ds,
  input   io_pins_pwm_2_i_ival,
  output  io_pins_pwm_2_o_oval,
  output  io_pins_pwm_2_o_oe,
  output  io_pins_pwm_2_o_ie,
  output  io_pins_pwm_2_o_pue,
  output  io_pins_pwm_2_o_ds,
  input   io_pins_pwm_3_i_ival,
  output  io_pins_pwm_3_o_oval,
  output  io_pins_pwm_3_o_oe,
  output  io_pins_pwm_3_o_ie,
  output  io_pins_pwm_3_o_pue,
  output  io_pins_pwm_3_o_ds
);
  wire [1:0] T_108;
  wire [1:0] T_109;
  wire [3:0] T_110;
  wire  T_114;
  wire  T_115;
  wire  T_116;
  wire  T_117;
  assign io_pins_pwm_0_o_oval = T_114;
  assign io_pins_pwm_0_o_oe = 1'h1;
  assign io_pins_pwm_0_o_ie = 1'h0;
  assign io_pins_pwm_0_o_pue = 1'h0;
  assign io_pins_pwm_0_o_ds = 1'h0;
  assign io_pins_pwm_1_o_oval = T_115;
  assign io_pins_pwm_1_o_oe = 1'h1;
  assign io_pins_pwm_1_o_ie = 1'h0;
  assign io_pins_pwm_1_o_pue = 1'h0;
  assign io_pins_pwm_1_o_ds = 1'h0;
  assign io_pins_pwm_2_o_oval = T_116;
  assign io_pins_pwm_2_o_oe = 1'h1;
  assign io_pins_pwm_2_o_ie = 1'h0;
  assign io_pins_pwm_2_o_pue = 1'h0;
  assign io_pins_pwm_2_o_ds = 1'h0;
  assign io_pins_pwm_3_o_oval = T_117;
  assign io_pins_pwm_3_o_oe = 1'h1;
  assign io_pins_pwm_3_o_ie = 1'h0;
  assign io_pins_pwm_3_o_pue = 1'h0;
  assign io_pins_pwm_3_o_ds = 1'h0;
  assign T_108 = {io_pwm_port_1,io_pwm_port_0};
  assign T_109 = {io_pwm_port_3,io_pwm_port_2};
  assign T_110 = {T_109,T_108};
  assign T_114 = T_110[0];
  assign T_115 = T_110[1];
  assign T_116 = T_110[2];
  assign T_117 = T_110[3];
endmodule

