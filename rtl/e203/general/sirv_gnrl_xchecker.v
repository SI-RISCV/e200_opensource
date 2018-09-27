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
//  Verilog module for X checker
//
// ====================================================================


`ifndef FPGA_SOURCE//{
`ifndef DISABLE_SV_ASSERTION//{
//synopsys translate_off
module sirv_gnrl_xchecker # (
  parameter DW = 32
) (
  input  [DW-1:0] i_dat,
  input clk
);


CHECK_THE_X_VALUE:
  assert property (@(posedge clk) 
                     ((^(i_dat)) !== 1'bx)
                  )
  else $fatal ("\n Error: Oops, detected a X value!!! This should never happen. \n");

endmodule
//synopsys translate_on
`endif//}
`endif//}
