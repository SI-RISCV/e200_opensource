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
//  The top level module of plic
//
// ====================================================================

module sirv_plic_top(
  input   clk,
  input   rst_n,

  input                      i_icb_cmd_valid,
  output                     i_icb_cmd_ready,
  input  [32-1:0]            i_icb_cmd_addr, 
  input                      i_icb_cmd_read, 
  input  [32-1:0]            i_icb_cmd_wdata,
  
  output                     i_icb_rsp_valid,
  input                      i_icb_rsp_ready,
  output [32-1:0]            i_icb_rsp_rdata,

  input   io_devices_0_0,
  input   io_devices_0_1,
  input   io_devices_0_2,
  input   io_devices_0_3,
  input   io_devices_0_4,
  input   io_devices_0_5,
  input   io_devices_0_6,
  input   io_devices_0_7,
  input   io_devices_0_8,
  input   io_devices_0_9,
  input   io_devices_0_10,
  input   io_devices_0_11,
  input   io_devices_0_12,
  input   io_devices_0_13,
  input   io_devices_0_14,
  input   io_devices_0_15,
  input   io_devices_0_16,
  input   io_devices_0_17,
  input   io_devices_0_18,
  input   io_devices_0_19,
  input   io_devices_0_20,
  input   io_devices_0_21,
  input   io_devices_0_22,
  input   io_devices_0_23,
  input   io_devices_0_24,
  input   io_devices_0_25,
  input   io_devices_0_26,
  input   io_devices_0_27,
  input   io_devices_0_28,
  input   io_devices_0_29,
  input   io_devices_0_30,
  input   io_devices_0_31,
  input   io_devices_0_32,
  input   io_devices_0_33,
  input   io_devices_0_34,
  input   io_devices_0_35,
  input   io_devices_0_36,
  input   io_devices_0_37,
  input   io_devices_0_38,
  input   io_devices_0_39,
  input   io_devices_0_40,
  input   io_devices_0_41,
  input   io_devices_0_42,
  input   io_devices_0_43,
  input   io_devices_0_44,
  input   io_devices_0_45,
  input   io_devices_0_46,
  input   io_devices_0_47,
  input   io_devices_0_48,
  input   io_devices_0_49,
  input   io_devices_0_50,
  input   io_devices_0_51,
  output  io_harts_0_0
);

wire plic_irq;
assign io_harts_0_0 = plic_irq;

localparam PLIC_IRQ_NUM = 53;// The number can be enlarged as long as not larger than 1024
wire [PLIC_IRQ_NUM-1:0] plic_irq_i = { 
                  io_devices_0_51  ,
                  io_devices_0_50  ,

                  io_devices_0_49  ,
                  io_devices_0_48  ,
                  io_devices_0_47  ,
                  io_devices_0_46  ,
                  io_devices_0_45  ,
                  io_devices_0_44  ,
                  io_devices_0_43  ,
                  io_devices_0_42  ,
                  io_devices_0_41  ,
                  io_devices_0_40  ,

                  io_devices_0_39  ,
                  io_devices_0_38  ,
                  io_devices_0_37  ,
                  io_devices_0_36  ,
                  io_devices_0_35  ,
                  io_devices_0_34  ,
                  io_devices_0_33  ,
                  io_devices_0_32  ,
                  io_devices_0_31  ,
                  io_devices_0_30  ,

                  io_devices_0_29  ,
                  io_devices_0_28  ,
                  io_devices_0_27  ,
                  io_devices_0_26  ,
                  io_devices_0_25  ,
                  io_devices_0_24  ,
                  io_devices_0_23  ,
                  io_devices_0_22  ,
                  io_devices_0_21  ,
                  io_devices_0_20  ,

                  io_devices_0_19  ,
                  io_devices_0_18  ,
                  io_devices_0_17  ,
                  io_devices_0_16  ,
                  io_devices_0_15  ,
                  io_devices_0_14  ,
                  io_devices_0_13  ,
                  io_devices_0_12  ,
                  io_devices_0_11  ,
                  io_devices_0_10  ,

                  io_devices_0_9  ,
                  io_devices_0_8  ,
                  io_devices_0_7  ,
                  io_devices_0_6  ,
                  io_devices_0_5  ,
                  io_devices_0_4  ,
                  io_devices_0_3  ,
                  io_devices_0_2  ,
                  io_devices_0_1  ,
                  io_devices_0_0  ,

                  1'b0 };// The IRQ0 must be tied to zero


sirv_plic_man #(
    .PLIC_PRIO_WIDTH   (3),
    .PLIC_IRQ_NUM      (PLIC_IRQ_NUM),
    .PLIC_IRQ_NUM_LOG2 (6),
    .PLIC_ICB_RSP_FLOP (1),
    .PLIC_IRQ_I_FLOP   (1),
    .PLIC_IRQ_O_FLOP   (1) 
) u_sirv_plic_man(
    .clk              (clk            ),      
    .rst_n            (rst_n          ),

    .icb_cmd_valid  (i_icb_cmd_valid),
    .icb_cmd_addr   (i_icb_cmd_addr[24-1:0] ),
    .icb_cmd_read   (i_icb_cmd_read ),
    .icb_cmd_wdata  (i_icb_cmd_wdata),
    .icb_rsp_ready  (i_icb_rsp_ready),
                    
    .icb_rsp_valid  (i_icb_rsp_valid),
    .icb_cmd_ready  (i_icb_cmd_ready),
    .icb_rsp_rdata  (i_icb_rsp_rdata),

    .plic_irq_i (plic_irq_i),
    .plic_irq_o (plic_irq   ) 
);


endmodule
