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
//  The top module of the example AXI slave
//
// ====================================================================
module sirv_expl_axi_slv #(
    parameter AW = 32,
    parameter DW = 32 
)(
  input  axi_arvalid,
  output axi_arready,
  input  [AW-1:0] axi_araddr,
  input  [3:0] axi_arcache,
  input  [2:0] axi_arprot,
  input  [1:0] axi_arlock,
  input  [1:0] axi_arburst,
  input  [3:0] axi_arlen,
  input  [2:0] axi_arsize,

  input  axi_awvalid,
  output axi_awready,
  input  [AW-1:0] axi_awaddr,
  input  [3:0] axi_awcache,
  input  [2:0] axi_awprot,
  input  [1:0] axi_awlock,
  input  [1:0] axi_awburst,
  input  [3:0] axi_awlen,
  input  [2:0] axi_awsize,

  output axi_rvalid,
  input  axi_rready,
  output [DW-1:0] axi_rdata,
  output [1:0] axi_rresp,
  output axi_rlast,

  input  axi_wvalid,
  output axi_wready,
  input  [DW-1:0] axi_wdata,
  input  [(DW/8)-1:0] axi_wstrb,
  input  axi_wlast,

  output axi_bvalid,
  input  axi_bready,
  output [1:0] axi_bresp,

  input  clk,  
  input  rst_n
);

  assign axi_rvalid = axi_arvalid;
  assign axi_arready = axi_rready;

  assign axi_rdata = {DW{1'b0}};
  assign axi_rresp = 2'b0;
  assign axi_rlast = 1'b1;

  assign axi_bvalid = axi_wvalid;
  assign axi_wready = axi_bready;
  assign axi_bresp  = 2'b0;

  assign axi_awready = 1'b1;

endmodule
