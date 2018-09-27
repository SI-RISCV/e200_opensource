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
                                                                         
                                                                         
                                                                         

module sirv_queue(
  input   clock,
  input   reset,
  output  io_enq_ready,
  input   io_enq_valid,
  input   io_enq_bits_read,
  input  [9:0] io_enq_bits_index,
  input  [31:0] io_enq_bits_data,
  input  [3:0] io_enq_bits_mask,
  input  [9:0] io_enq_bits_extra,
  input   io_deq_ready,
  output  io_deq_valid,
  output  io_deq_bits_read,
  output [9:0] io_deq_bits_index,
  output [31:0] io_deq_bits_data,
  output [3:0] io_deq_bits_mask,
  output [9:0] io_deq_bits_extra,
  output  io_count
);
  reg  ram_read [0:0];
  reg [31:0] GEN_0;
  wire  ram_read_T_83_data;
  wire  ram_read_T_83_addr;
  wire  ram_read_T_69_data;
  wire  ram_read_T_69_addr;
  wire  ram_read_T_69_mask;
  wire  ram_read_T_69_en;
  reg [9:0] ram_index [0:0];
  reg [31:0] GEN_1;
  wire [9:0] ram_index_T_83_data;
  wire  ram_index_T_83_addr;
  wire [9:0] ram_index_T_69_data;
  wire  ram_index_T_69_addr;
  wire  ram_index_T_69_mask;
  wire  ram_index_T_69_en;
  reg [31:0] ram_data [0:0];
  reg [31:0] GEN_2;
  wire [31:0] ram_data_T_83_data;
  wire  ram_data_T_83_addr;
  wire [31:0] ram_data_T_69_data;
  wire  ram_data_T_69_addr;
  wire  ram_data_T_69_mask;
  wire  ram_data_T_69_en;
  reg [3:0] ram_mask [0:0];
  reg [31:0] GEN_3;
  wire [3:0] ram_mask_T_83_data;
  wire  ram_mask_T_83_addr;
  wire [3:0] ram_mask_T_69_data;
  wire  ram_mask_T_69_addr;
  wire  ram_mask_T_69_mask;
  wire  ram_mask_T_69_en;
  reg [9:0] ram_extra [0:0];
  reg [31:0] GEN_4;
  wire [9:0] ram_extra_T_83_data;
  wire  ram_extra_T_83_addr;
  wire [9:0] ram_extra_T_69_data;
  wire  ram_extra_T_69_addr;
  wire  ram_extra_T_69_mask;
  wire  ram_extra_T_69_en;
  reg  maybe_full;
  reg [31:0] GEN_5;
  wire  T_65;
  wire  T_66;
  wire  do_enq;
  wire  T_67;
  wire  do_deq;
  wire  T_77;
  wire  GEN_8;
  wire  T_79;
  wire  GEN_9;
  wire [1:0] T_90;
  wire  ptr_diff;
  wire [1:0] T_92;
  assign io_enq_ready = GEN_9;
  assign io_deq_valid = T_79;
  assign io_deq_bits_read = ram_read_T_83_data;
  assign io_deq_bits_index = ram_index_T_83_data;
  assign io_deq_bits_data = ram_data_T_83_data;
  assign io_deq_bits_mask = ram_mask_T_83_data;
  assign io_deq_bits_extra = ram_extra_T_83_data;
  assign io_count = T_92[0];
  assign ram_read_T_83_addr = 1'h0;
  assign ram_read_T_83_data = ram_read[ram_read_T_83_addr];
  assign ram_read_T_69_data = io_enq_bits_read;
  assign ram_read_T_69_addr = 1'h0;
  assign ram_read_T_69_mask = do_enq;
  assign ram_read_T_69_en = do_enq;
  assign ram_index_T_83_addr = 1'h0;
  assign ram_index_T_83_data = ram_index[ram_index_T_83_addr];
  assign ram_index_T_69_data = io_enq_bits_index;
  assign ram_index_T_69_addr = 1'h0;
  assign ram_index_T_69_mask = do_enq;
  assign ram_index_T_69_en = do_enq;
  assign ram_data_T_83_addr = 1'h0;
  assign ram_data_T_83_data = ram_data[ram_data_T_83_addr];
  assign ram_data_T_69_data = io_enq_bits_data;
  assign ram_data_T_69_addr = 1'h0;
  assign ram_data_T_69_mask = do_enq;
  assign ram_data_T_69_en = do_enq;
  assign ram_mask_T_83_addr = 1'h0;
  assign ram_mask_T_83_data = ram_mask[ram_mask_T_83_addr];
  assign ram_mask_T_69_data = io_enq_bits_mask;
  assign ram_mask_T_69_addr = 1'h0;
  assign ram_mask_T_69_mask = do_enq;
  assign ram_mask_T_69_en = do_enq;
  assign ram_extra_T_83_addr = 1'h0;
  assign ram_extra_T_83_data = ram_extra[ram_extra_T_83_addr];
  assign ram_extra_T_69_data = io_enq_bits_extra;
  assign ram_extra_T_69_addr = 1'h0;
  assign ram_extra_T_69_mask = do_enq;
  assign ram_extra_T_69_en = do_enq;
  assign T_65 = maybe_full == 1'h0;
  assign T_66 = io_enq_ready & io_enq_valid;
  assign do_enq = T_66;
  assign T_67 = io_deq_ready & io_deq_valid;
  assign do_deq = T_67;
  assign T_77 = do_enq != do_deq;
  assign GEN_8 = T_77 ? do_enq : maybe_full;
  assign T_79 = T_65 == 1'h0;
  assign GEN_9 = io_deq_ready ? 1'h1 : T_65;
  assign T_90 = 1'h0 - 1'h0;
  assign ptr_diff = T_90[0:0];
  assign T_92 = {maybe_full,ptr_diff};

  always @(posedge clock) begin// The ram block does not need reset
    if(ram_read_T_69_en & ram_read_T_69_mask) begin
      ram_read[ram_read_T_69_addr] <= ram_read_T_69_data;
    end
    if(ram_index_T_69_en & ram_index_T_69_mask) begin
      ram_index[ram_index_T_69_addr] <= ram_index_T_69_data;
    end
    if(ram_data_T_69_en & ram_data_T_69_mask) begin
      ram_data[ram_data_T_69_addr] <= ram_data_T_69_data;
    end
    if(ram_mask_T_69_en & ram_mask_T_69_mask) begin
      ram_mask[ram_mask_T_69_addr] <= ram_mask_T_69_data;
    end
    if(ram_extra_T_69_en & ram_extra_T_69_mask) begin
      ram_extra[ram_extra_T_69_addr] <= ram_extra_T_69_data;
    end
  end

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      maybe_full <= 1'h0;
    end else begin
      if (T_77) begin
        maybe_full <= do_enq;
      end
    end
  end
endmodule
