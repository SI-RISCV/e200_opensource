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
                                                                         
                                                                         
                                                                         
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The wrapper with some glue logics for PLIC 
//
// ====================================================================


`include "e203_defines.v"


module e203_subsys_plic(
  input                          plic_icb_cmd_valid,
  output                         plic_icb_cmd_ready,
  input  [`E203_ADDR_SIZE-1:0]   plic_icb_cmd_addr, 
  input                          plic_icb_cmd_read, 
  input  [`E203_XLEN-1:0]        plic_icb_cmd_wdata,
  input  [`E203_XLEN/8-1:0]      plic_icb_cmd_wmask,
  //
  output                         plic_icb_rsp_valid,
  input                          plic_icb_rsp_ready,
  output                         plic_icb_rsp_err,
  output [`E203_XLEN-1:0]        plic_icb_rsp_rdata,

  output plic_ext_irq,

  input  wdg_irq_a,
  input  rtc_irq_a,

  input  qspi0_irq, 
  input  qspi1_irq,
  input  qspi2_irq,

  input  uart0_irq,                
  input  uart1_irq,                

  input  pwm0_irq_0,
  input  pwm0_irq_1,
  input  pwm0_irq_2,
  input  pwm0_irq_3,

  input  pwm1_irq_0,
  input  pwm1_irq_1,
  input  pwm1_irq_2,
  input  pwm1_irq_3,

  input  pwm2_irq_0,
  input  pwm2_irq_1,
  input  pwm2_irq_2,
  input  pwm2_irq_3,

  input  i2c_mst_irq,

  input  gpio_irq_0,
  input  gpio_irq_1,
  input  gpio_irq_2,
  input  gpio_irq_3,
  input  gpio_irq_4,
  input  gpio_irq_5,
  input  gpio_irq_6,
  input  gpio_irq_7,
  input  gpio_irq_8,
  input  gpio_irq_9,
  input  gpio_irq_10,
  input  gpio_irq_11,
  input  gpio_irq_12,
  input  gpio_irq_13,
  input  gpio_irq_14,
  input  gpio_irq_15,
  input  gpio_irq_16,
  input  gpio_irq_17,
  input  gpio_irq_18,
  input  gpio_irq_19,
  input  gpio_irq_20,
  input  gpio_irq_21,
  input  gpio_irq_22,
  input  gpio_irq_23,
  input  gpio_irq_24,
  input  gpio_irq_25,
  input  gpio_irq_26,
  input  gpio_irq_27,
  input  gpio_irq_28,
  input  gpio_irq_29,
  input  gpio_irq_30,
  input  gpio_irq_31,

  input  clk,
  input  rst_n
  );

  assign plic_icb_rsp_err     = 1'b0;

  wire  wdg_irq_r;
  wire  rtc_irq_r;

  sirv_gnrl_sync # (
  .DP(`E203_ASYNC_FF_LEVELS),
  .DW(1)
  ) u_rtc_irq_sync(
      .din_a    (rtc_irq_a),
      .dout     (rtc_irq_r),
      .clk      (clk  ),
      .rst_n    (rst_n) 
  );

  sirv_gnrl_sync # (
  .DP(`E203_ASYNC_FF_LEVELS),
  .DW(1)
  ) u_wdg_irq_sync(
      .din_a    (wdg_irq_a),
      .dout     (wdg_irq_r),
      .clk      (clk  ),
      .rst_n    (rst_n) 
  );

  wire plic_irq_i_0  = wdg_irq_r;
  wire plic_irq_i_1  = rtc_irq_r;
  wire plic_irq_i_2  = uart0_irq;
  wire plic_irq_i_3  = uart1_irq;
  wire plic_irq_i_4  = qspi0_irq;
  wire plic_irq_i_5  = qspi1_irq;   
  wire plic_irq_i_6  = qspi2_irq;   
  wire plic_irq_i_7  = gpio_irq_0 ; 
  wire plic_irq_i_8  = gpio_irq_1 ; 
  wire plic_irq_i_9  = gpio_irq_2 ; 
  wire plic_irq_i_10 = gpio_irq_3 ; 
  wire plic_irq_i_11 = gpio_irq_4 ; 
  wire plic_irq_i_12 = gpio_irq_5 ; 
  wire plic_irq_i_13 = gpio_irq_6 ; 
  wire plic_irq_i_14 = gpio_irq_7 ; 
  wire plic_irq_i_15 = gpio_irq_8 ; 
  wire plic_irq_i_16 = gpio_irq_9 ; 
  wire plic_irq_i_17 = gpio_irq_10; 
  wire plic_irq_i_18 = gpio_irq_11; 
  wire plic_irq_i_19 = gpio_irq_12; 
  wire plic_irq_i_20 = gpio_irq_13; 
  wire plic_irq_i_21 = gpio_irq_14; 
  wire plic_irq_i_22 = gpio_irq_15; 
  wire plic_irq_i_23 = gpio_irq_16; 
  wire plic_irq_i_24 = gpio_irq_17; 
  wire plic_irq_i_25 = gpio_irq_18; 
  wire plic_irq_i_26 = gpio_irq_19; 
  wire plic_irq_i_27 = gpio_irq_20; 
  wire plic_irq_i_28 = gpio_irq_21; 
  wire plic_irq_i_29 = gpio_irq_22; 
  wire plic_irq_i_30 = gpio_irq_23; 
  wire plic_irq_i_31 = gpio_irq_24; 
  wire plic_irq_i_32 = gpio_irq_25; 
  wire plic_irq_i_33 = gpio_irq_26; 
  wire plic_irq_i_34 = gpio_irq_27; 
  wire plic_irq_i_35 = gpio_irq_28; 
  wire plic_irq_i_36 = gpio_irq_29; 
  wire plic_irq_i_37 = gpio_irq_30; 
  wire plic_irq_i_38 = gpio_irq_31; 
  wire plic_irq_i_39 = pwm0_irq_0;
  wire plic_irq_i_40 = pwm0_irq_1;
  wire plic_irq_i_41 = pwm0_irq_2;
  wire plic_irq_i_42 = pwm0_irq_3;
  wire plic_irq_i_43 = pwm1_irq_0;
  wire plic_irq_i_44 = pwm1_irq_1;
  wire plic_irq_i_45 = pwm1_irq_2;
  wire plic_irq_i_46 = pwm1_irq_3;
  wire plic_irq_i_47 = pwm2_irq_0;
  wire plic_irq_i_48 = pwm2_irq_1;
  wire plic_irq_i_49 = pwm2_irq_2;
  wire plic_irq_i_50 = pwm2_irq_3;
  wire plic_irq_i_51 = i2c_mst_irq;
                         

  sirv_plic_top u_sirv_plic_top(
    .clk             (clk   ),
    .rst_n           (rst_n ),
  
    .i_icb_cmd_valid (plic_icb_cmd_valid),
    .i_icb_cmd_ready (plic_icb_cmd_ready),
    .i_icb_cmd_addr  (plic_icb_cmd_addr ),
    .i_icb_cmd_read  (plic_icb_cmd_read ),
    .i_icb_cmd_wdata (plic_icb_cmd_wdata),
    
    .i_icb_rsp_valid (plic_icb_rsp_valid),
    .i_icb_rsp_ready (plic_icb_rsp_ready),
    .i_icb_rsp_rdata (plic_icb_rsp_rdata),
  
    .io_devices_0_0  (plic_irq_i_0 ),
    .io_devices_0_1  (plic_irq_i_1 ),
    .io_devices_0_2  (plic_irq_i_2 ),
    .io_devices_0_3  (plic_irq_i_3 ),
    .io_devices_0_4  (plic_irq_i_4 ),
    .io_devices_0_5  (plic_irq_i_5 ),
    .io_devices_0_6  (plic_irq_i_6 ),
    .io_devices_0_7  (plic_irq_i_7 ),
    .io_devices_0_8  (plic_irq_i_8 ),
    .io_devices_0_9  (plic_irq_i_9 ),
    .io_devices_0_10 (plic_irq_i_10),
    .io_devices_0_11 (plic_irq_i_11),
    .io_devices_0_12 (plic_irq_i_12),
    .io_devices_0_13 (plic_irq_i_13),
    .io_devices_0_14 (plic_irq_i_14),
    .io_devices_0_15 (plic_irq_i_15),
    .io_devices_0_16 (plic_irq_i_16),
    .io_devices_0_17 (plic_irq_i_17),
    .io_devices_0_18 (plic_irq_i_18),
    .io_devices_0_19 (plic_irq_i_19),
    .io_devices_0_20 (plic_irq_i_20),
    .io_devices_0_21 (plic_irq_i_21),
    .io_devices_0_22 (plic_irq_i_22),
    .io_devices_0_23 (plic_irq_i_23),
    .io_devices_0_24 (plic_irq_i_24),
    .io_devices_0_25 (plic_irq_i_25),
    .io_devices_0_26 (plic_irq_i_26),
    .io_devices_0_27 (plic_irq_i_27),
    .io_devices_0_28 (plic_irq_i_28),
    .io_devices_0_29 (plic_irq_i_29),
    .io_devices_0_30 (plic_irq_i_30),
    .io_devices_0_31 (plic_irq_i_31),
    .io_devices_0_32 (plic_irq_i_32),
    .io_devices_0_33 (plic_irq_i_33),
    .io_devices_0_34 (plic_irq_i_34),
    .io_devices_0_35 (plic_irq_i_35),
    .io_devices_0_36 (plic_irq_i_36),
    .io_devices_0_37 (plic_irq_i_37),
    .io_devices_0_38 (plic_irq_i_38),
    .io_devices_0_39 (plic_irq_i_39),
    .io_devices_0_40 (plic_irq_i_40),
    .io_devices_0_41 (plic_irq_i_41),
    .io_devices_0_42 (plic_irq_i_42),
    .io_devices_0_43 (plic_irq_i_43),
    .io_devices_0_44 (plic_irq_i_44),
    .io_devices_0_45 (plic_irq_i_45),
    .io_devices_0_46 (plic_irq_i_46),
    .io_devices_0_47 (plic_irq_i_47),
    .io_devices_0_48 (plic_irq_i_48),
    .io_devices_0_49 (plic_irq_i_49),
    .io_devices_0_50 (plic_irq_i_50),
    .io_devices_0_51 (plic_irq_i_51),
    .io_harts_0_0    (plic_ext_irq ) 
  );

  endmodule

