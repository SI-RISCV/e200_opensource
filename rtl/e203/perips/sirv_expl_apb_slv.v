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
//  The top module of the example APB slave
//
// ====================================================================
module sirv_expl_apb_slv #(
    parameter AW = 32,
    parameter DW = 32 
)(
  input  [AW-1:0] apb_paddr,
  input           apb_pwrite,
  input           apb_pselx,
  input           apb_penable,
  input  [DW-1:0] apb_pwdata,
  output [DW-1:0] apb_prdata,

  input  clk,  
  input  rst_n
);

  assign apb_prdata = {DW{1'b0}};

endmodule
