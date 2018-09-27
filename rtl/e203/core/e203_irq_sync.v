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
// Designer   : Bob Hu
//
// Description:
//  The IRQ and Event Sync module
//
// ====================================================================

`include "e203_defines.v"

module e203_irq_sync #(
  parameter MASTER = 1 
) (
  input  clk,    
  input  rst_n,   

  input  ext_irq_a,
  input  sft_irq_a,
  input  tmr_irq_a,
  input  dbg_irq_a,

  output ext_irq_r,
  output sft_irq_r,
  output tmr_irq_r,
  output dbg_irq_r 
);
generate 
  if(MASTER == 1) begin:master_gen
      `ifndef E203_HAS_LOCKSTEP//{
      `ifdef E203_IRQ_NEED_SYNC//{
      sirv_gnrl_sync # (
        .DP(`E203_ASYNC_FF_LEVELS),
        .DW(1)
      ) u_dbg_irq_sync(
          .din_a    (dbg_irq_a),
          .dout     (dbg_irq_r),
          .clk      (clk  ),
          .rst_n    (rst_n) 
      );
      
      
      sirv_gnrl_sync # (
        .DP(`E203_ASYNC_FF_LEVELS),
        .DW(1)
      ) u_ext_irq_sync(
          .din_a    (ext_irq_a),
          .dout     (ext_irq_r),
          .clk      (clk  ),
          .rst_n    (rst_n) 
      );
      
      sirv_gnrl_sync # (
        .DP(`E203_ASYNC_FF_LEVELS),
        .DW(1)
      ) u_sft_irq_sync(
          .din_a    (sft_irq_a),
          .dout     (sft_irq_r),
          .clk      (clk  ),
          .rst_n    (rst_n) 
      );
      
      sirv_gnrl_sync # (
        .DP(`E203_ASYNC_FF_LEVELS),
        .DW(1)
      ) u_tmr_irq_sync(
          .din_a    (tmr_irq_a),
          .dout     (tmr_irq_r),
          .clk      (clk  ),
          .rst_n    (rst_n) 
      );
      `else//}{
        assign ext_irq_r = ext_irq_a;
        assign sft_irq_r = sft_irq_a;
        assign tmr_irq_r = tmr_irq_a;
        assign dbg_irq_r = dbg_irq_a;
      `endif//}
      `endif//}
      
      
  end
  else begin:slave_gen
         // Just pass through for slave in lockstep mode
     assign ext_irq_r = ext_irq_a;
     assign sft_irq_r = sft_irq_a;
     assign tmr_irq_r = tmr_irq_a;
     assign dbg_irq_r = dbg_irq_a;
   
  end
endgenerate


endmodule

