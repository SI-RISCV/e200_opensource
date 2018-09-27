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
                                                                         
                                                                         
                                                                         
module sirv_ResetCatchAndSync(
  input   clock,
  input   reset,
  input   test_mode,
  output  io_sync_reset
);
  wire  reset_n_catch_reg_clock;
  wire  reset_n_catch_reg_reset;
  wire [2:0] reset_n_catch_reg_io_d;
  wire [2:0] reset_n_catch_reg_io_q;
  wire  reset_n_catch_reg_io_en;
  wire [1:0] T_6;
  wire [2:0] T_7;
  wire  T_8;
  wire  T_9;
  sirv_AsyncResetRegVec_36 reset_n_catch_reg (
    .clock(reset_n_catch_reg_clock),
    .reset(reset_n_catch_reg_reset),
    .io_d(reset_n_catch_reg_io_d),
    .io_q(reset_n_catch_reg_io_q),
    .io_en(reset_n_catch_reg_io_en)
  );
  assign io_sync_reset = test_mode ? reset : T_9;
  assign reset_n_catch_reg_clock = clock;
  assign reset_n_catch_reg_reset = reset;
  assign reset_n_catch_reg_io_d = T_7;
  assign reset_n_catch_reg_io_en = 1'h1;
  assign T_6 = reset_n_catch_reg_io_q[2:1];
  assign T_7 = {1'h1,T_6};
  assign T_8 = reset_n_catch_reg_io_q[0];
  assign T_9 = ~ T_8;
endmodule

