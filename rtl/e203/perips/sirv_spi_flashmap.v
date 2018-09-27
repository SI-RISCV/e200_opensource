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
                                                                         
                                                                         
                                                                         

module sirv_qspi_flashmap(
  input   clock,
  input   reset,
  input   io_en,
  input  [1:0] io_ctrl_insn_cmd_proto,
  input  [7:0] io_ctrl_insn_cmd_code,
  input   io_ctrl_insn_cmd_en,
  input  [1:0] io_ctrl_insn_addr_proto,
  input  [2:0] io_ctrl_insn_addr_len,
  input  [7:0] io_ctrl_insn_pad_code,
  input  [3:0] io_ctrl_insn_pad_cnt,
  input  [1:0] io_ctrl_insn_data_proto,
  input   io_ctrl_fmt_endian,
  output  io_addr_ready,
  input   io_addr_valid,
  input  [31:0] io_addr_bits_next,
  input  [31:0] io_addr_bits_hold,
  input   io_data_ready,
  output  io_data_valid,
  output [7:0] io_data_bits,
  input   io_link_tx_ready,
  output  io_link_tx_valid,
  output [7:0] io_link_tx_bits,
  input   io_link_rx_valid,
  input  [7:0] io_link_rx_bits,
  output [7:0] io_link_cnt,
  output [1:0] io_link_fmt_proto,
  output  io_link_fmt_endian,
  output  io_link_fmt_iodir,
  output  io_link_cs_set,
  output  io_link_cs_clear,
  output  io_link_cs_hold,
  input   io_link_active,
  output  io_link_lock
);
  wire [32:0] T_110;
  wire [31:0] addr;
  wire  T_111;
  wire  merge;
  wire  T_113;
  wire  T_114;
  wire  T_115;
  wire [3:0] T_120;
  wire [2:0] T_122;
  wire [1:0] T_124;
  wire [3:0] GEN_46;
  wire [3:0] T_126;
  wire [3:0] GEN_47;
  wire [3:0] T_127;
  wire [3:0] T_128;
  reg [3:0] cnt;
  reg [31:0] GEN_5;
  wire  cnt_en;
  wire  cnt_cmp_0;
  wire  cnt_cmp_1;
  wire  cnt_cmp_2;
  wire  cnt_cmp_3;
  wire  cnt_cmp_4;
  wire  cnt_last;
  wire  cnt_done;
  wire  T_143;
  wire  T_144;
  wire [4:0] T_146;
  wire [3:0] T_147;
  wire [3:0] GEN_0;
  wire  GEN_1;
  wire [3:0] GEN_2;
  reg [2:0] state;
  reg [31:0] GEN_9;
  wire  T_149;
  wire [2:0] GEN_3;
  wire  T_153;
  wire [2:0] T_154;
  wire [2:0] GEN_4;
  wire [2:0] GEN_6;
  wire  GEN_7;
  wire  T_157;
  wire  GEN_8;
  wire [2:0] GEN_10;
  wire  GEN_11;
  wire  GEN_12;
  wire  T_160;
  wire  GEN_13;
  wire  GEN_14;
  wire [7:0] GEN_15;
  wire  GEN_16;
  wire  GEN_17;
  wire  GEN_18;
  wire [2:0] GEN_19;
  wire  GEN_20;
  wire  GEN_21;
  wire  GEN_22;
  wire [7:0] GEN_23;
  wire  T_163;
  wire [2:0] GEN_24;
  wire [3:0] GEN_25;
  wire [1:0] GEN_26;
  wire [2:0] GEN_28;
  wire [3:0] GEN_29;
  wire  T_164;
  wire [7:0] T_165;
  wire [7:0] T_166;
  wire [7:0] T_167;
  wire [7:0] T_168;
  wire [7:0] T_170;
  wire [7:0] T_172;
  wire [7:0] T_174;
  wire [7:0] T_176;
  wire [7:0] T_178;
  wire [7:0] T_179;
  wire [7:0] T_180;
  wire [7:0] T_181;
  wire [2:0] GEN_30;
  wire [7:0] GEN_31;
  wire [2:0] GEN_33;
  wire  T_183;
  wire [2:0] GEN_34;
  wire [3:0] GEN_35;
  wire [7:0] GEN_36;
  wire [2:0] GEN_37;
  wire  T_184;
  wire [2:0] GEN_38;
  wire [1:0] GEN_39;
  wire  GEN_40;
  wire [2:0] GEN_41;
  wire  T_185;
  wire  T_187;
  wire [2:0] GEN_42;
  wire  GEN_43;
  wire  GEN_44;
  wire [2:0] GEN_45;
  assign io_addr_ready = GEN_18;
  assign io_data_valid = GEN_44;
  assign io_data_bits = GEN_23;
  assign io_link_tx_valid = GEN_43;
  assign io_link_tx_bits = GEN_36;
  assign io_link_cnt = {{4'd0}, GEN_35};
  assign io_link_fmt_proto = GEN_39;
  assign io_link_fmt_endian = io_ctrl_fmt_endian;
  assign io_link_fmt_iodir = GEN_40;
  assign io_link_cs_set = 1'h1;
  assign io_link_cs_clear = GEN_20;
  assign io_link_cs_hold = 1'h1;
  assign io_link_lock = GEN_21;
  assign T_110 = io_addr_bits_hold + 32'h1;
  assign addr = T_110[31:0];
  assign T_111 = io_addr_bits_next == addr;
  assign merge = io_link_active & T_111;
  assign T_113 = 2'h0 == io_link_fmt_proto;
  assign T_114 = 2'h1 == io_link_fmt_proto;
  assign T_115 = 2'h2 == io_link_fmt_proto;
  assign T_120 = T_113 ? 4'h8 : 4'h0;
  assign T_122 = T_114 ? 3'h4 : 3'h0;
  assign T_124 = T_115 ? 2'h2 : 2'h0;
  assign GEN_46 = {{1'd0}, T_122};
  assign T_126 = T_120 | GEN_46;
  assign GEN_47 = {{2'd0}, T_124};
  assign T_127 = T_126 | GEN_47;
  assign T_128 = T_127;
  assign cnt_en = T_164;
  assign cnt_cmp_0 = cnt == 4'h0;
  assign cnt_cmp_1 = cnt == 4'h1;
  assign cnt_cmp_2 = cnt == 4'h2;
  assign cnt_cmp_3 = cnt == 4'h3;
  assign cnt_cmp_4 = cnt == 4'h4;
  assign cnt_last = cnt_cmp_1 & io_link_tx_ready;
  assign cnt_done = cnt_last | cnt_cmp_0;
  assign T_143 = cnt_cmp_0 == 1'h0;
  assign T_144 = io_link_tx_ready & io_link_tx_valid;
  assign T_146 = cnt - 4'h1;
  assign T_147 = T_146[3:0];
  assign GEN_0 = T_144 ? T_147 : cnt;
  assign GEN_1 = cnt_en ? T_143 : 1'h1;
  assign GEN_2 = cnt_en ? GEN_0 : cnt;
  assign T_149 = 3'h0 == state;
  assign GEN_3 = merge ? 3'h4 : state;
  assign T_153 = merge == 1'h0;
  assign T_154 = io_ctrl_insn_cmd_en ? 3'h1 : 3'h2;
  assign GEN_4 = T_153 ? T_154 : GEN_3;
  assign GEN_6 = io_addr_valid ? GEN_4 : state;
  assign GEN_7 = io_addr_valid ? T_153 : 1'h0;
  assign T_157 = io_addr_valid == 1'h0;
  assign GEN_8 = T_157 ? 1'h0 : 1'h1;
  assign GEN_10 = io_en ? GEN_6 : state;
  assign GEN_11 = io_en ? GEN_7 : 1'h0;
  assign GEN_12 = io_en ? GEN_8 : 1'h1;
  assign T_160 = io_en == 1'h0;
  assign GEN_13 = T_160 ? io_addr_valid : 1'h0;
  assign GEN_14 = T_160 ? io_data_ready : io_en;
  assign GEN_15 = T_160 ? 8'h0 : io_link_rx_bits;
  assign GEN_16 = T_160 ? 1'h0 : GEN_12;
  assign GEN_17 = T_149 ? 1'h0 : GEN_1;
  assign GEN_18 = T_149 ? GEN_14 : 1'h0;
  assign GEN_19 = T_149 ? GEN_10 : state;
  assign GEN_20 = T_149 ? GEN_11 : 1'h0;
  assign GEN_21 = T_149 ? GEN_16 : 1'h1;
  assign GEN_22 = T_149 ? GEN_13 : 1'h0;
  assign GEN_23 = T_149 ? GEN_15 : io_link_rx_bits;
  assign T_163 = 3'h1 == state;
  assign GEN_24 = io_link_tx_ready ? 3'h2 : GEN_19;
  assign GEN_25 = io_link_tx_ready ? {{1'd0}, io_ctrl_insn_addr_len} : GEN_2;
  assign GEN_26 = T_163 ? io_ctrl_insn_cmd_proto : io_ctrl_insn_addr_proto;
  assign GEN_28 = T_163 ? GEN_24 : GEN_19;
  assign GEN_29 = T_163 ? GEN_25 : GEN_2;
  assign T_164 = 3'h2 == state;
  assign T_165 = io_addr_bits_hold[7:0];
  assign T_166 = io_addr_bits_hold[15:8];
  assign T_167 = io_addr_bits_hold[23:16];
  assign T_168 = io_addr_bits_hold[31:24];
  assign T_170 = cnt_cmp_1 ? T_165 : 8'h0;
  assign T_172 = cnt_cmp_2 ? T_166 : 8'h0;
  assign T_174 = cnt_cmp_3 ? T_167 : 8'h0;
  assign T_176 = cnt_cmp_4 ? T_168 : 8'h0;
  assign T_178 = T_170 | T_172;
  assign T_179 = T_178 | T_174;
  assign T_180 = T_179 | T_176;
  assign T_181 = T_180;
  assign GEN_30 = cnt_done ? 3'h3 : GEN_28;
  assign GEN_31 = T_164 ? T_181 : io_ctrl_insn_cmd_code;
  assign GEN_33 = T_164 ? GEN_30 : GEN_28;
  assign T_183 = 3'h3 == state;
  assign GEN_34 = io_link_tx_ready ? 3'h4 : GEN_33;
  assign GEN_35 = T_183 ? io_ctrl_insn_pad_cnt : T_128;
  assign GEN_36 = T_183 ? io_ctrl_insn_pad_code : GEN_31;
  assign GEN_37 = T_183 ? GEN_34 : GEN_33;
  assign T_184 = 3'h4 == state;
  assign GEN_38 = io_link_tx_ready ? 3'h5 : GEN_37;
  assign GEN_39 = T_184 ? io_ctrl_insn_data_proto : GEN_26;
  assign GEN_40 = T_184 ? 1'h0 : 1'h1;
  assign GEN_41 = T_184 ? GEN_38 : GEN_37;
  assign T_185 = 3'h5 == state;
  assign T_187 = io_data_ready & io_data_valid;
  assign GEN_42 = T_187 ? 3'h0 : GEN_41;
  assign GEN_43 = T_185 ? 1'h0 : GEN_17;
  assign GEN_44 = T_185 ? io_link_rx_valid : GEN_22;
  assign GEN_45 = T_185 ? GEN_42 : GEN_41;

  always @(posedge clock or posedge reset)
  if (reset) begin
     cnt <= 4'b0;
  end
  else begin
    if (T_163) begin
      if (io_link_tx_ready) begin
        cnt <= {{1'd0}, io_ctrl_insn_addr_len};
      end else begin
        if (cnt_en) begin
          if (T_144) begin
            cnt <= T_147;
          end
        end
      end
    end else begin
      if (cnt_en) begin
        if (T_144) begin
          cnt <= T_147;
        end
      end
    end
  end

  always @(posedge clock or posedge reset)
    if (reset) begin
      state <= 3'h0;
    end else begin
      if (T_185) begin
        if (T_187) begin
          state <= 3'h0;
        end else begin
          if (T_184) begin
            if (io_link_tx_ready) begin
              state <= 3'h5;
            end else begin
              if (T_183) begin
                if (io_link_tx_ready) begin
                  state <= 3'h4;
                end else begin
                  if (T_164) begin
                    if (cnt_done) begin
                      state <= 3'h3;
                    end else begin
                      if (T_163) begin
                        if (io_link_tx_ready) begin
                          state <= 3'h2;
                        end else begin
                          if (T_149) begin
                            if (io_en) begin
                              if (io_addr_valid) begin
                                if (T_153) begin
                                  if (io_ctrl_insn_cmd_en) begin
                                    state <= 3'h1;
                                  end else begin
                                    state <= 3'h2;
                                  end
                                end else begin
                                  if (merge) begin
                                    state <= 3'h4;
                                  end
                                end
                              end
                            end
                          end
                        end
                      end else begin
                        if (T_149) begin
                          if (io_en) begin
                            if (io_addr_valid) begin
                              if (T_153) begin
                                if (io_ctrl_insn_cmd_en) begin
                                  state <= 3'h1;
                                end else begin
                                  state <= 3'h2;
                                end
                              end else begin
                                if (merge) begin
                                  state <= 3'h4;
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end else begin
                    if (T_163) begin
                      if (io_link_tx_ready) begin
                        state <= 3'h2;
                      end else begin
                        if (T_149) begin
                          if (io_en) begin
                            if (io_addr_valid) begin
                              if (T_153) begin
                                if (io_ctrl_insn_cmd_en) begin
                                  state <= 3'h1;
                                end else begin
                                  state <= 3'h2;
                                end
                              end else begin
                                if (merge) begin
                                  state <= 3'h4;
                                end
                              end
                            end
                          end
                        end
                      end
                    end else begin
                      if (T_149) begin
                        if (io_en) begin
                          if (io_addr_valid) begin
                            if (T_153) begin
                              if (io_ctrl_insn_cmd_en) begin
                                state <= 3'h1;
                              end else begin
                                state <= 3'h2;
                              end
                            end else begin
                              if (merge) begin
                                state <= 3'h4;
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end else begin
                if (T_164) begin
                  if (cnt_done) begin
                    state <= 3'h3;
                  end else begin
                    if (T_163) begin
                      if (io_link_tx_ready) begin
                        state <= 3'h2;
                      end else begin
                        state <= GEN_19;
                      end
                    end else begin
                      state <= GEN_19;
                    end
                  end
                end else begin
                  if (T_163) begin
                    if (io_link_tx_ready) begin
                      state <= 3'h2;
                    end else begin
                      state <= GEN_19;
                    end
                  end else begin
                    state <= GEN_19;
                  end
                end
              end
            end
          end else begin
            if (T_183) begin
              if (io_link_tx_ready) begin
                state <= 3'h4;
              end else begin
                if (T_164) begin
                  if (cnt_done) begin
                    state <= 3'h3;
                  end else begin
                    state <= GEN_28;
                  end
                end else begin
                  state <= GEN_28;
                end
              end
            end else begin
              if (T_164) begin
                if (cnt_done) begin
                  state <= 3'h3;
                end else begin
                  state <= GEN_28;
                end
              end else begin
                state <= GEN_28;
              end
            end
          end
        end
      end else begin
        if (T_184) begin
          if (io_link_tx_ready) begin
            state <= 3'h5;
          end else begin
            if (T_183) begin
              if (io_link_tx_ready) begin
                state <= 3'h4;
              end else begin
                state <= GEN_33;
              end
            end else begin
              state <= GEN_33;
            end
          end
        end else begin
          if (T_183) begin
            if (io_link_tx_ready) begin
              state <= 3'h4;
            end else begin
              state <= GEN_33;
            end
          end else begin
            state <= GEN_33;
          end
        end
      end
    end

endmodule
