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
                                                                         
                                                                         
                                                                         

module sirv_qspi_media_2(
  input   clock,
  input   reset,
  output  io_port_sck,
  input   io_port_dq_0_i,
  output  io_port_dq_0_o,
  output  io_port_dq_0_oe,
  input   io_port_dq_1_i,
  output  io_port_dq_1_o,
  output  io_port_dq_1_oe,
  input   io_port_dq_2_i,
  output  io_port_dq_2_o,
  output  io_port_dq_2_oe,
  input   io_port_dq_3_i,
  output  io_port_dq_3_o,
  output  io_port_dq_3_oe,
  output  io_port_cs_0,
  input  [11:0] io_ctrl_sck_div,
  input   io_ctrl_sck_pol,
  input   io_ctrl_sck_pha,
  input  [7:0] io_ctrl_dla_cssck,
  input  [7:0] io_ctrl_dla_sckcs,
  input  [7:0] io_ctrl_dla_intercs,
  input  [7:0] io_ctrl_dla_interxfr,
  input   io_ctrl_cs_id,
  input   io_ctrl_cs_dflt_0,
  output  io_link_tx_ready,
  input   io_link_tx_valid,
  input  [7:0] io_link_tx_bits,
  output  io_link_rx_valid,
  output [7:0] io_link_rx_bits,
  input  [7:0] io_link_cnt,
  input  [1:0] io_link_fmt_proto,
  input   io_link_fmt_endian,
  input   io_link_fmt_iodir,
  input   io_link_cs_set,
  input   io_link_cs_clear,
  input   io_link_cs_hold,
  output  io_link_active
);
  wire  phy_clock;
  wire  phy_reset;
  wire  phy_io_port_sck;
  wire  phy_io_port_dq_0_i;
  wire  phy_io_port_dq_0_o;
  wire  phy_io_port_dq_0_oe;
  wire  phy_io_port_dq_1_i;
  wire  phy_io_port_dq_1_o;
  wire  phy_io_port_dq_1_oe;
  wire  phy_io_port_dq_2_i;
  wire  phy_io_port_dq_2_o;
  wire  phy_io_port_dq_2_oe;
  wire  phy_io_port_dq_3_i;
  wire  phy_io_port_dq_3_o;
  wire  phy_io_port_dq_3_oe;
  wire  phy_io_port_cs_0;
  wire [11:0] phy_io_ctrl_sck_div;
  wire  phy_io_ctrl_sck_pol;
  wire  phy_io_ctrl_sck_pha;
  wire [1:0] phy_io_ctrl_fmt_proto;
  wire  phy_io_ctrl_fmt_endian;
  wire  phy_io_ctrl_fmt_iodir;
  wire  phy_io_op_ready;
  wire  phy_io_op_valid;
  wire  phy_io_op_bits_fn;
  wire  phy_io_op_bits_stb;
  wire [7:0] phy_io_op_bits_cnt;
  wire [7:0] phy_io_op_bits_data;
  wire  phy_io_rx_valid;
  wire [7:0] phy_io_rx_bits;
  reg  cs_id;
  reg [31:0] GEN_5;
  reg  cs_dflt_0;
  reg [31:0] GEN_52;
  reg  cs_set;
  reg [31:0] GEN_53;
  wire [1:0] GEN_48;
  wire [1:0] T_162;
  wire [1:0] GEN_49;
  wire [1:0] T_163;
  wire  T_164;
  wire  cs_active_0;
  wire  cs_update;
  reg  clear;
  reg [31:0] GEN_54;
  reg  cs_assert;
  reg [31:0] GEN_55;
  wire  T_175;
  wire  T_176;
  wire  cs_deassert;
  wire  T_177;
  wire  T_178;
  wire  continuous;
  reg [1:0] state;
  reg [31:0] GEN_56;
  wire  T_182;
  wire [1:0] GEN_0;
  wire [7:0] GEN_1;
  wire [1:0] GEN_2;
  wire  T_184;
  wire  T_186;
  wire [1:0] GEN_3;
  wire  GEN_4;
  wire  GEN_6;
  wire  GEN_7;
  wire [1:0] GEN_8;
  wire [7:0] GEN_9;
  wire [1:0] GEN_10;
  wire  GEN_11;
  wire  GEN_12;
  wire  GEN_13;
  wire  GEN_14;
  wire  T_188;
  wire  T_189;
  wire  GEN_15;
  wire  GEN_16;
  wire  GEN_17;
  wire [7:0] GEN_18;
  wire  GEN_19;
  wire  GEN_20;
  wire  GEN_21;
  wire  T_194;
  wire  T_195;
  wire [7:0] GEN_22;
  wire  GEN_23;
  wire  GEN_24;
  wire  GEN_25;
  wire [7:0] GEN_26;
  wire [1:0] GEN_27;
  wire  GEN_28;
  wire  GEN_29;
  wire  GEN_30;
  wire  GEN_31;
  wire  GEN_32;
  wire  GEN_33;
  wire  GEN_34;
  wire  GEN_35;
  wire  T_198;
  wire  T_200;
  wire  T_201;
  wire [1:0] GEN_36;
  wire  GEN_37;
  wire [7:0] GEN_38;
  wire [1:0] GEN_39;
  wire  T_202;
  wire [1:0] GEN_50;
  wire [1:0] T_206;
  wire [1:0] GEN_51;
  wire [1:0] T_207;
  wire  T_208;
  wire  T_213_0;
  wire  GEN_40;
  wire [1:0] GEN_41;
  wire [7:0] GEN_42;
  wire  GEN_43;
  wire  GEN_44;
  wire  GEN_45;
  wire  GEN_46;
  wire [1:0] GEN_47;
  sirv_qspi_physical_2 phy (
    .clock(phy_clock),
    .reset(phy_reset),
    .io_port_sck(phy_io_port_sck),
    .io_port_dq_0_i(phy_io_port_dq_0_i),
    .io_port_dq_0_o(phy_io_port_dq_0_o),
    .io_port_dq_0_oe(phy_io_port_dq_0_oe),
    .io_port_dq_1_i(phy_io_port_dq_1_i),
    .io_port_dq_1_o(phy_io_port_dq_1_o),
    .io_port_dq_1_oe(phy_io_port_dq_1_oe),
    .io_port_dq_2_i(phy_io_port_dq_2_i),
    .io_port_dq_2_o(phy_io_port_dq_2_o),
    .io_port_dq_2_oe(phy_io_port_dq_2_oe),
    .io_port_dq_3_i(phy_io_port_dq_3_i),
    .io_port_dq_3_o(phy_io_port_dq_3_o),
    .io_port_dq_3_oe(phy_io_port_dq_3_oe),
    .io_port_cs_0(phy_io_port_cs_0),
    .io_ctrl_sck_div(phy_io_ctrl_sck_div),
    .io_ctrl_sck_pol(phy_io_ctrl_sck_pol),
    .io_ctrl_sck_pha(phy_io_ctrl_sck_pha),
    .io_ctrl_fmt_proto(phy_io_ctrl_fmt_proto),
    .io_ctrl_fmt_endian(phy_io_ctrl_fmt_endian),
    .io_ctrl_fmt_iodir(phy_io_ctrl_fmt_iodir),
    .io_op_ready(phy_io_op_ready),
    .io_op_valid(phy_io_op_valid),
    .io_op_bits_fn(phy_io_op_bits_fn),
    .io_op_bits_stb(phy_io_op_bits_stb),
    .io_op_bits_cnt(phy_io_op_bits_cnt),
    .io_op_bits_data(phy_io_op_bits_data),
    .io_rx_valid(phy_io_rx_valid),
    .io_rx_bits(phy_io_rx_bits)
  );
  assign io_port_sck = phy_io_port_sck;
  assign io_port_dq_0_o = phy_io_port_dq_0_o;
  assign io_port_dq_0_oe = phy_io_port_dq_0_oe;
  assign io_port_dq_1_o = phy_io_port_dq_1_o;
  assign io_port_dq_1_oe = phy_io_port_dq_1_oe;
  assign io_port_dq_2_o = phy_io_port_dq_2_o;
  assign io_port_dq_2_oe = phy_io_port_dq_2_oe;
  assign io_port_dq_3_o = phy_io_port_dq_3_o;
  assign io_port_dq_3_oe = phy_io_port_dq_3_oe;
  assign io_port_cs_0 = cs_dflt_0;
  assign io_link_tx_ready = GEN_31;
  assign io_link_rx_valid = phy_io_rx_valid;
  assign io_link_rx_bits = phy_io_rx_bits;
  assign io_link_active = cs_assert;
  assign phy_clock = clock;
  assign phy_reset = reset;
  assign phy_io_port_dq_0_i = io_port_dq_0_i;
  assign phy_io_port_dq_1_i = io_port_dq_1_i;
  assign phy_io_port_dq_2_i = io_port_dq_2_i;
  assign phy_io_port_dq_3_i = io_port_dq_3_i;
  assign phy_io_ctrl_sck_div = io_ctrl_sck_div;
  assign phy_io_ctrl_sck_pol = io_ctrl_sck_pol;
  assign phy_io_ctrl_sck_pha = io_ctrl_sck_pha;
  assign phy_io_ctrl_fmt_proto = io_link_fmt_proto;
  assign phy_io_ctrl_fmt_endian = io_link_fmt_endian;
  assign phy_io_ctrl_fmt_iodir = io_link_fmt_iodir;
  assign phy_io_op_valid = GEN_37;
  assign phy_io_op_bits_fn = GEN_28;
  assign phy_io_op_bits_stb = GEN_43;
  assign phy_io_op_bits_cnt = GEN_42;
  assign phy_io_op_bits_data = io_link_tx_bits;
  assign GEN_48 = {{1'd0}, io_link_cs_set};
  assign T_162 = GEN_48 << io_ctrl_cs_id;
  assign GEN_49 = {{1'd0}, io_ctrl_cs_dflt_0};
  assign T_163 = GEN_49 ^ T_162;
  assign T_164 = T_163[0];
  assign cs_active_0 = T_164;
  assign cs_update = cs_active_0 != cs_dflt_0;
  assign T_175 = io_link_cs_hold == 1'h0;
  assign T_176 = cs_update & T_175;
  assign cs_deassert = clear | T_176;
  assign T_177 = io_link_cs_clear & cs_assert;
  assign T_178 = clear | T_177;
  assign continuous = io_ctrl_dla_interxfr == 8'h0;
  assign T_182 = 2'h0 == state;
  assign GEN_0 = phy_io_op_ready ? 2'h2 : state;
  assign GEN_1 = cs_deassert ? io_ctrl_dla_sckcs : io_link_cnt;
  assign GEN_2 = cs_deassert ? GEN_0 : state;
  assign T_184 = cs_deassert == 1'h0;
  assign T_186 = phy_io_op_ready & phy_io_op_valid;
  assign GEN_3 = T_186 ? 2'h1 : GEN_2;
  assign GEN_4 = T_184 ? 1'h0 : 1'h1;
  assign GEN_6 = T_184 ? io_link_tx_valid : 1'h1;
  assign GEN_7 = T_184 ? phy_io_op_ready : 1'h0;
  assign GEN_8 = T_184 ? GEN_3 : GEN_2;
  assign GEN_9 = cs_assert ? GEN_1 : io_link_cnt;
  assign GEN_10 = cs_assert ? GEN_8 : state;
  assign GEN_11 = cs_assert ? GEN_4 : 1'h1;
  assign GEN_12 = cs_assert ? T_184 : 1'h0;
  assign GEN_13 = cs_assert ? GEN_6 : 1'h1;
  assign GEN_14 = cs_assert ? GEN_7 : 1'h0;
  assign T_188 = cs_assert == 1'h0;
  assign T_189 = T_188 & io_link_tx_valid;
  assign GEN_15 = phy_io_op_ready ? 1'h1 : cs_assert;
  assign GEN_16 = phy_io_op_ready ? io_link_cs_set : cs_set;
  assign GEN_17 = phy_io_op_ready ? cs_active_0 : cs_dflt_0;
  assign GEN_18 = T_189 ? io_ctrl_dla_cssck : GEN_9;
  assign GEN_19 = T_189 ? GEN_15 : cs_assert;
  assign GEN_20 = T_189 ? GEN_16 : cs_set;
  assign GEN_21 = T_189 ? GEN_17 : cs_dflt_0;
  assign T_194 = io_link_tx_valid == 1'h0;
  assign T_195 = T_188 & T_194;
  assign GEN_22 = T_195 ? 8'h0 : GEN_18;
  assign GEN_23 = T_195 ? 1'h1 : GEN_12;
  assign GEN_24 = T_195 ? io_ctrl_cs_id : cs_id;
  assign GEN_25 = T_195 ? io_ctrl_cs_dflt_0 : GEN_21;
  assign GEN_26 = T_182 ? GEN_22 : io_link_cnt;
  assign GEN_27 = T_182 ? GEN_10 : state;
  assign GEN_28 = T_182 ? GEN_11 : 1'h1;
  assign GEN_29 = T_182 ? GEN_23 : 1'h0;
  assign GEN_30 = T_182 ? GEN_13 : 1'h1;
  assign GEN_31 = T_182 ? GEN_14 : 1'h0;
  assign GEN_32 = T_182 ? GEN_19 : cs_assert;
  assign GEN_33 = T_182 ? GEN_20 : cs_set;
  assign GEN_34 = T_182 ? GEN_25 : cs_dflt_0;
  assign GEN_35 = T_182 ? GEN_24 : cs_id;
  assign T_198 = 2'h1 == state;
  assign T_200 = continuous == 1'h0;
  assign T_201 = phy_io_op_ready | continuous;
  assign GEN_36 = T_201 ? 2'h0 : GEN_27;
  assign GEN_37 = T_198 ? T_200 : GEN_30;
  assign GEN_38 = T_198 ? io_ctrl_dla_interxfr : GEN_26;
  assign GEN_39 = T_198 ? GEN_36 : GEN_27;
  assign T_202 = 2'h2 == state;
  assign GEN_50 = {{1'd0}, cs_set};
  assign T_206 = GEN_50 << cs_id;
  assign GEN_51 = {{1'd0}, cs_dflt_0};
  assign T_207 = GEN_51 ^ T_206;
  assign T_208 = T_207[0];
  assign T_213_0 = T_208;
  assign GEN_40 = phy_io_op_ready ? T_213_0 : GEN_34;
  assign GEN_41 = phy_io_op_ready ? 2'h0 : GEN_39;
  assign GEN_42 = T_202 ? io_ctrl_dla_intercs : GEN_38;
  assign GEN_43 = T_202 ? 1'h1 : GEN_29;
  assign GEN_44 = T_202 ? 1'h0 : GEN_32;
  assign GEN_45 = T_202 ? 1'h0 : T_178;
  assign GEN_46 = T_202 ? GEN_40 : GEN_34;
  assign GEN_47 = T_202 ? GEN_41 : GEN_39;

  always @(posedge clock or posedge reset)
  if(reset) begin
    cs_id     <= 2'b0;
    cs_dflt_0 <= 1'b1;
    cs_set    <= 1'b0;
  end
  else begin//{

    if (T_182) begin
      if (T_195) begin
        cs_id <= io_ctrl_cs_id;
      end
    end
    if (T_202) begin
      if (phy_io_op_ready) begin
        cs_dflt_0 <= T_213_0;
      end else begin
        if (T_182) begin
          if (T_195) begin
            cs_dflt_0 <= io_ctrl_cs_dflt_0;
          end else begin
            if (T_189) begin
              if (phy_io_op_ready) begin
                cs_dflt_0 <= cs_active_0;
              end
            end
          end
        end
      end
    end else begin
      if (T_182) begin
        if (T_195) begin
          cs_dflt_0 <= io_ctrl_cs_dflt_0;
        end else begin
          if (T_189) begin
            if (phy_io_op_ready) begin
              cs_dflt_0 <= cs_active_0;
            end
          end
        end
      end
    end
    if (T_182) begin
      if (T_189) begin
        if (phy_io_op_ready) begin
          cs_set <= io_link_cs_set;
        end
      end
    end

  end//}


  always @(posedge clock or posedge reset)
    if (reset) begin
      clear <= 1'h0;
    end else begin
      if (T_202) begin
        clear <= 1'h0;
      end else begin
        clear <= T_178;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      cs_assert <= 1'h0;
    end else begin
      if (T_202) begin
        cs_assert <= 1'h0;
      end else begin
        if (T_182) begin
          if (T_189) begin
            if (phy_io_op_ready) begin
              cs_assert <= 1'h1;
            end
          end
        end
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      state <= 2'h0;
    end else begin
      if (T_202) begin
        if (phy_io_op_ready) begin
          state <= 2'h0;
        end else begin
          if (T_198) begin
            if (T_201) begin
              state <= 2'h0;
            end else begin
              if (T_182) begin
                if (cs_assert) begin
                  if (T_184) begin
                    if (T_186) begin
                      state <= 2'h1;
                    end else begin
                      if (cs_deassert) begin
                        if (phy_io_op_ready) begin
                          state <= 2'h2;
                        end
                      end
                    end
                  end else begin
                    if (cs_deassert) begin
                      if (phy_io_op_ready) begin
                        state <= 2'h2;
                      end
                    end
                  end
                end
              end
            end
          end else begin
            if (T_182) begin
              if (cs_assert) begin
                if (T_184) begin
                  if (T_186) begin
                    state <= 2'h1;
                  end else begin
                    if (cs_deassert) begin
                      if (phy_io_op_ready) begin
                        state <= 2'h2;
                      end
                    end
                  end
                end else begin
                  if (cs_deassert) begin
                    if (phy_io_op_ready) begin
                      state <= 2'h2;
                    end
                  end
                end
              end
            end
          end
        end
      end else begin
        if (T_198) begin
          if (T_201) begin
            state <= 2'h0;
          end else begin
            if (T_182) begin
              if (cs_assert) begin
                if (T_184) begin
                  if (T_186) begin
                    state <= 2'h1;
                  end else begin
                    state <= GEN_2;
                  end
                end else begin
                  state <= GEN_2;
                end
              end
            end
          end
        end else begin
          if (T_182) begin
            if (cs_assert) begin
              if (T_184) begin
                if (T_186) begin
                  state <= 2'h1;
                end else begin
                  state <= GEN_2;
                end
              end else begin
                state <= GEN_2;
              end
            end
          end
        end
      end
    end
  
endmodule
