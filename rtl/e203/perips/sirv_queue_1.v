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
                                                                         
                                                                         
                                                                         
module sirv_queue_1(
  input   clock,
  input   reset,
  output  io_enq_ready,
  input   io_enq_valid,
  input  [7:0] io_enq_bits,
  input   io_deq_ready,
  output  io_deq_valid,
  output [7:0] io_deq_bits,
  output [3:0] io_count
);
  reg [7:0] ram [0:7];
  reg [31:0] GEN_0;
  wire [7:0] ram_T_51_data;
  wire [2:0] ram_T_51_addr;
  wire [7:0] ram_T_35_data;
  wire [2:0] ram_T_35_addr;
  wire  ram_T_35_mask;
  wire  ram_T_35_en;
  reg [2:0] T_27;
  reg [31:0] GEN_1;
  reg [2:0] T_29;
  reg [31:0] GEN_2;
  reg  maybe_full;
  reg [31:0] GEN_3;
  wire  ptr_match;
  wire  T_32;
  wire  empty;
  wire  full;
  wire  T_33;
  wire  do_enq;
  wire  T_34;
  wire  do_deq;
  wire [3:0] T_39;
  wire [2:0] T_40;
  wire [2:0] GEN_4;
  wire [3:0] T_44;
  wire [2:0] T_45;
  wire [2:0] GEN_5;
  wire  T_46;
  wire  GEN_6;
  wire  T_48;
  wire  T_50;
  wire [3:0] T_52;
  wire [2:0] ptr_diff;
  wire  T_53;
  wire [3:0] T_54;
  assign io_enq_ready = T_50;
  assign io_deq_valid = T_48;
  assign io_deq_bits = ram_T_51_data;
  assign io_count = T_54;
  assign ram_T_51_addr = T_29;
  assign ram_T_51_data = ram[ram_T_51_addr];
  assign ram_T_35_data = io_enq_bits;
  assign ram_T_35_addr = T_27;
  assign ram_T_35_mask = do_enq;
  assign ram_T_35_en = do_enq;
  assign ptr_match = T_27 == T_29;
  assign T_32 = maybe_full == 1'h0;
  assign empty = ptr_match & T_32;
  assign full = ptr_match & maybe_full;
  assign T_33 = io_enq_ready & io_enq_valid;
  assign do_enq = T_33;
  assign T_34 = io_deq_ready & io_deq_valid;
  assign do_deq = T_34;
  assign T_39 = T_27 + 3'h1;
  assign T_40 = T_39[2:0];
  assign GEN_4 = do_enq ? T_40 : T_27;
  assign T_44 = T_29 + 3'h1;
  assign T_45 = T_44[2:0];
  assign GEN_5 = do_deq ? T_45 : T_29;
  assign T_46 = do_enq != do_deq;
  assign GEN_6 = T_46 ? do_enq : maybe_full;
  assign T_48 = empty == 1'h0;
  assign T_50 = full == 1'h0;
  assign T_52 = T_27 - T_29;
  assign ptr_diff = T_52[2:0];
  assign T_53 = maybe_full & ptr_match;
  assign T_54 = {T_53,ptr_diff};

  always @(posedge clock) begin // The RAM block does not need reset
    if(ram_T_35_en & ram_T_35_mask) begin
      ram[ram_T_35_addr] <= ram_T_35_data;
    end
  end

  always @(posedge clock or posedge reset)
    if (reset) begin
      T_27 <= 3'h0;
    end else begin
      if (do_enq) begin
        T_27 <= T_40;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      T_29 <= 3'h0;
    end else begin
      if (do_deq) begin
        T_29 <= T_45;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      maybe_full <= 1'h0;
    end else begin
      if (T_46) begin
        maybe_full <= do_enq;
      end
    end

endmodule
