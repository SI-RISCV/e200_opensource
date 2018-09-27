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
//  The Reset Sync module to implement reset control
//
// ====================================================================

`include "e203_defines.v"

module e203_subsys_hclkgen_rstsync (
  input  clk,        // clock
  input  rst_n_a,      // async reset
  input  test_mode,  // test mode 

  output rst_n 

);

localparam RST_SYNC_LEVEL = `E203_ASYNC_FF_LEVELS;

reg [RST_SYNC_LEVEL-1:0] rst_sync_r; 

always @(posedge clk or negedge rst_n_a)
begin:rst_sync_PROC
  if(rst_n_a == 1'b0)
    begin
      rst_sync_r[RST_SYNC_LEVEL-1:0] <= {RST_SYNC_LEVEL{1'b0}};
    end
  else
    begin
      rst_sync_r[RST_SYNC_LEVEL-1:0] <= {rst_sync_r[RST_SYNC_LEVEL-2:0],1'b1};
    end
end

assign rst_n = test_mode ? rst_n_a : rst_sync_r[`E203_ASYNC_FF_LEVELS-1];

endmodule

