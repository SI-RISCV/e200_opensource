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
//  The gltch free clock mux
//
// ====================================================================

`include "e203_defines.v"


module e203_subsys_gfcm(
  input test_mode,
  input clk0_rst_n,
  input clk1_rst_n,
  input sel1    ,
  input clk0    ,
  input clk1    ,
  output clkout   
  );

  wire clk0_sel = ~sel1;
  wire clk1_sel = sel1;

  localparam SYNC_LEVEL = 3;

  wire clk0_sync_in;

  reg [SYNC_LEVEL-1:0] clk0_sync_r; 
  
  always @(posedge clk0 or negedge clk0_rst_n)
  begin:clk0_sync_PROC
    if(clk0_rst_n == 1'b0)
      begin
        clk0_sync_r[SYNC_LEVEL-1:0] <= {SYNC_LEVEL{1'b0}};
      end
    else
      begin
        clk0_sync_r[SYNC_LEVEL-1:0] <= {clk0_sync_r[SYNC_LEVEL-2:0],clk0_sync_in};
      end
  end

  wire clk1_sync_in;

  reg [SYNC_LEVEL-1:0] clk1_sync_r; 
  
  always @(posedge clk1 or negedge clk1_rst_n)
  begin:clk1_sync_PROC
    if(clk1_rst_n == 1'b0)
      begin
        clk1_sync_r[SYNC_LEVEL-1:0] <= {SYNC_LEVEL{1'b0}};
      end
    else
      begin
        clk1_sync_r[SYNC_LEVEL-1:0] <= {clk1_sync_r[SYNC_LEVEL-2:0],clk1_sync_in};
      end
  end


  assign clk0_sync_in = (~clk1_sync_r[SYNC_LEVEL-1]) & clk0_sel; 
  assign clk1_sync_in = (~clk0_sync_r[SYNC_LEVEL-1]) & clk1_sel; 

  wire clk0_gated;
  wire clk1_gated;


  wire clk0_gate_en = clk0_sync_r[1];

  e203_clkgate u_clk0_clkgate(
    .clk_in   (clk0        ),
    .test_mode(test_mode  ),
    .clock_en (clk0_gate_en),
    .clk_out  (clk0_gated)
  );

  
  wire clk1_gate_en = clk1_sync_r[1];

  e203_clkgate u_clk1_clkgate(
    .clk_in   (clk1        ),
    .test_mode(test_mode  ),
    .clock_en (clk1_gate_en),
    .clk_out  (clk1_gated)
  );

  assign clkout = clk0_gated | clk1_gated;


endmodule

