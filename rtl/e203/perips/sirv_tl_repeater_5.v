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
                                                                         
                                                                         
                                                                         

module sirv_tl_repeater_5(
  input   clock,
  input   reset,
  input   io_repeat,
  output  io_full,
  output  io_enq_ready,
  input   io_enq_valid,
  input  [2:0] io_enq_bits_opcode,
  input  [2:0] io_enq_bits_param,
  input  [2:0] io_enq_bits_size,
  input  [1:0] io_enq_bits_source,
  input  [29:0] io_enq_bits_address,
  input  [3:0] io_enq_bits_mask,
  input  [31:0] io_enq_bits_data,
  input   io_deq_ready,
  output  io_deq_valid,
  output [2:0] io_deq_bits_opcode,
  output [2:0] io_deq_bits_param,
  output [2:0] io_deq_bits_size,
  output [1:0] io_deq_bits_source,
  output [29:0] io_deq_bits_address,
  output [3:0] io_deq_bits_mask,
  output [31:0] io_deq_bits_data
);
  reg  full;
  reg [31:0] GEN_9;
  reg [2:0] saved_opcode;
  reg [31:0] GEN_10;
  reg [2:0] saved_param;
  reg [31:0] GEN_11;
  reg [2:0] saved_size;
  reg [31:0] GEN_12;
  reg [1:0] saved_source;
  reg [31:0] GEN_13;
  reg [29:0] saved_address;
  reg [31:0] GEN_14;
  reg [3:0] saved_mask;
  reg [31:0] GEN_15;
  reg [31:0] saved_data;
  reg [31:0] GEN_16;
  wire  T_77;
  wire  T_79;
  wire  T_80;
  wire [2:0] T_81_opcode;
  wire [2:0] T_81_param;
  wire [2:0] T_81_size;
  wire [1:0] T_81_source;
  wire [29:0] T_81_address;
  wire [3:0] T_81_mask;
  wire [31:0] T_81_data;
  wire  T_89;
  wire  T_90;
  wire  GEN_0;
  wire [2:0] GEN_1;
  wire [2:0] GEN_2;
  wire [2:0] GEN_3;
  wire [1:0] GEN_4;
  wire [29:0] GEN_5;
  wire [3:0] GEN_6;
  wire [31:0] GEN_7;
  wire  T_92;
  wire  T_94;
  wire  T_95;
  wire  GEN_8;
  assign io_full = full;
  assign io_enq_ready = T_80;
  assign io_deq_valid = T_77;
  assign io_deq_bits_opcode = T_81_opcode;
  assign io_deq_bits_param = T_81_param;
  assign io_deq_bits_size = T_81_size;
  assign io_deq_bits_source = T_81_source;
  assign io_deq_bits_address = T_81_address;
  assign io_deq_bits_mask = T_81_mask;
  assign io_deq_bits_data = T_81_data;
  assign T_77 = io_enq_valid | full;
  assign T_79 = full == 1'h0;
  assign T_80 = io_deq_ready & T_79;
  assign T_81_opcode = full ? saved_opcode : io_enq_bits_opcode;
  assign T_81_param = full ? saved_param : io_enq_bits_param;
  assign T_81_size = full ? saved_size : io_enq_bits_size;
  assign T_81_source = full ? saved_source : io_enq_bits_source;
  assign T_81_address = full ? saved_address : io_enq_bits_address;
  assign T_81_mask = full ? saved_mask : io_enq_bits_mask;
  assign T_81_data = full ? saved_data : io_enq_bits_data;
  assign T_89 = io_enq_ready & io_enq_valid;
  assign T_90 = T_89 & io_repeat;
  assign GEN_0 = T_90 ? 1'h1 : full;
  assign GEN_1 = T_90 ? io_enq_bits_opcode : saved_opcode;
  assign GEN_2 = T_90 ? io_enq_bits_param : saved_param;
  assign GEN_3 = T_90 ? io_enq_bits_size : saved_size;
  assign GEN_4 = T_90 ? io_enq_bits_source : saved_source;
  assign GEN_5 = T_90 ? io_enq_bits_address : saved_address;
  assign GEN_6 = T_90 ? io_enq_bits_mask : saved_mask;
  assign GEN_7 = T_90 ? io_enq_bits_data : saved_data;
  assign T_92 = io_deq_ready & io_deq_valid;
  assign T_94 = io_repeat == 1'h0;
  assign T_95 = T_92 & T_94;
  assign GEN_8 = T_95 ? 1'h0 : GEN_0;

  always @(posedge clock or posedge reset)
    if (reset) begin
      full <= 1'h0;
    end else begin
      if (T_95) begin
        full <= 1'h0;
      end else begin
        if (T_90) begin
          full <= 1'h1;
        end
      end
    end


  always @(posedge clock or posedge reset)
  if (reset) begin
    saved_opcode  <= 3'b0;
    saved_param   <= 3'b0;
    saved_size    <= 3'b0;
    saved_source  <= 2'b0;
    saved_address <= 30'b0;
    saved_mask    <= 4'b0;
    saved_data    <= 32'b0;
  end
  else begin
    if (T_90) begin
      saved_opcode <= io_enq_bits_opcode;
    end
    if (T_90) begin
      saved_param <= io_enq_bits_param;
    end
    if (T_90) begin
      saved_size <= io_enq_bits_size;
    end
    if (T_90) begin
      saved_source <= io_enq_bits_source;
    end
    if (T_90) begin
      saved_address <= io_enq_bits_address;
    end
    if (T_90) begin
      saved_mask <= io_enq_bits_mask;
    end
    if (T_90) begin
      saved_data <= io_enq_bits_data;
    end
  end

endmodule
