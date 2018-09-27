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
                                                                         
                                                                         
                                                                         
module sirv_LevelGateway(
  input   clock,
  input   reset,
  input   io_interrupt,
  output  io_plic_valid,
  input   io_plic_ready,
  input   io_plic_complete
);
  reg  inFlight;
  reg [31:0] GEN_2;
  wire  T_12;
  wire  GEN_0;
  wire  GEN_1;
  wire  T_16;
  wire  T_17;
  assign io_plic_valid = T_17;
  assign T_12 = io_interrupt & io_plic_ready;
  assign GEN_0 = T_12 ? 1'h1 : inFlight;
  assign GEN_1 = io_plic_complete ? 1'h0 : GEN_0;
  assign T_16 = inFlight == 1'h0;
  assign T_17 = io_interrupt & T_16;

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      inFlight <= 1'h0;
    end else begin
      if (io_plic_complete) begin
        inFlight <= 1'h0;
      end else begin
        if (T_12) begin
          inFlight <= 1'h1;
        end
      end
    end
  end
endmodule

