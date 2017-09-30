 /*                                                                      
 Copyright 2017 Silicon Integrated Microelectronics, Inc.                
                                                                         
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
//--        _______   ___
//--       (   ____/ /__/
//--        \ \     __
//--     ____\ \   / /
//--    /_______\ /_/   MICROELECTRONICS
//--
//=====================================================================
// Designer   : Bob Hu
//
// Description:
//  The Reset Ctrl module to implement reset control
//
// ====================================================================

`include "e203_defines.v"

module e203_reset_ctrl (
  input  clk,        // clock
  input  rst_n,      // async reset
  input  test_mode,  // test mode 
  
  // The core's clk and rst
  output rst_core,

  // The ITCM/DTCM clk and rst
  `ifdef E203_HAS_ITCM
  output rst_itcm,
  `endif
  `ifdef E203_HAS_ITCM
  output rst_dtcm,
  `endif

  // The Top always on clk and rst
  output rst_aon 

);

reg [`E203_ASYNC_FF_LEVELS-1:0] rst_sync_r; 

always @(posedge clk or negedge rst_n)
begin:rst_sync_PROC
  if(rst_n == 1'b0)
    begin
      rst_sync_r[`E203_ASYNC_FF_LEVELS-1:0] <= 1'b0;
    end
  else
    begin
      rst_sync_r[`E203_ASYNC_FF_LEVELS-1:0] <= {rst_sync_r[`E203_ASYNC_FF_LEVELS-2:0],1'b1};
    end
end

wire rst_sync_n = test_mode ? rst_n : rst_sync_r[`E203_ASYNC_FF_LEVELS-1];

  // The core's clk and rst
assign rst_core = rst_sync_n;

  // The ITCM/DTCM clk and rst
  `ifdef E203_HAS_ITCM
assign rst_itcm = rst_sync_n;
  `endif
  `ifdef E203_HAS_ITCM
assign rst_dtcm = rst_sync_n;
  `endif

  // The Top always on clk and rst
assign rst_aon = rst_sync_n;

endmodule

