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
//  This module to implement the extended CSR
//    current this is an empty module, user can hack it 
//    become a real one if they want
//
//
// ====================================================================
`include "e203_defines.v"

`ifdef E203_HAS_CSR_EAI//{
module e203_extend_csr(

  // The Handshake Interface 
  input          eai_csr_valid,
  output         eai_csr_ready,

  input   [31:0] eai_csr_addr,
  input          eai_csr_wr,
  input   [31:0] eai_csr_wdata,
  output  [31:0] eai_csr_rdata,

  input  clk,
  input  rst_n
  );

  assign eai_csr_ready = 1'b1;
  assign eai_csr_rdata = 32'b0;


endmodule
`endif//}
