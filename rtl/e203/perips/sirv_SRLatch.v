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
                                                                         
                                                                         
                                                                         
module sirv_SRLatch (
  input set,
  input reset,
  output q
);

  reg latch;

  // synopsys async_set_reset "set"
  // synopsys one_hot "set, reset"
  always @(set or reset)
  begin
    if (set)
      latch <= 1'b1;
    else if (reset)
      latch <= 1'b0;
  end

  assign q = latch;

endmodule
