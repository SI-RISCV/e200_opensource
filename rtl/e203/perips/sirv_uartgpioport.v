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
                                                                         
                                                                         
                                                                         
module sirv_uartgpioport(
  input   clock,
  input   reset,
  input   io_uart_txd,
  output  io_uart_rxd,
  input   io_pins_rxd_i_ival,
  output  io_pins_rxd_o_oval,
  output  io_pins_rxd_o_oe,
  output  io_pins_rxd_o_ie,
  output  io_pins_rxd_o_pue,
  output  io_pins_rxd_o_ds,
  input   io_pins_txd_i_ival,
  output  io_pins_txd_o_oval,
  output  io_pins_txd_o_oe,
  output  io_pins_txd_o_ie,
  output  io_pins_txd_o_pue,
  output  io_pins_txd_o_ds
);
  assign io_uart_rxd = io_pins_rxd_i_ival;
  assign io_pins_rxd_o_oval = 1'h0;
  assign io_pins_rxd_o_oe = 1'h0;
  assign io_pins_rxd_o_ie = 1'h1;
  assign io_pins_rxd_o_pue = 1'h0;
  assign io_pins_rxd_o_ds = 1'h0;
  assign io_pins_txd_o_oval = io_uart_txd;
  assign io_pins_txd_o_oe = 1'h1;
  assign io_pins_txd_o_ie = 1'h0;
  assign io_pins_txd_o_pue = 1'h0;
  assign io_pins_txd_o_ds = 1'h0;
endmodule

