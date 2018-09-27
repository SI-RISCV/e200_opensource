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
//  The module for debug RAM program
//
// ====================================================================

module sirv_debug_ram(
  input  clk,
  input  rst_n,
  input  ram_cs,
  input  ram_rd,
  input  [ 3-1:0] ram_addr, 
  input  [32-1:0] ram_wdat,  
  output [32-1:0] ram_dout  
  );
        
  wire [31:0] debug_ram_r [0:6]; 
  wire [6:0]  ram_wen;


  assign ram_dout = debug_ram_r[ram_addr]; 

  genvar i;
  generate //{
  
      for (i=0; i<7; i=i+1) begin:debug_ram_gen//{
  
            assign ram_wen[i] = ram_cs & (~ram_rd) & (ram_addr == i) ;
            sirv_gnrl_dfflr #(32) ram_dfflr (ram_wen[i], ram_wdat, debug_ram_r[i], clk, rst_n);
  
      end//}
  endgenerate//}

endmodule

