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
                                                                         
                                                                         
                                                                         
module sirv_AsyncResetRegVec_129(
  input   clock,
  input   reset,
  input  [19:0] io_d,
  output [19:0] io_q,
  input   io_en
);
  wire  reg_0_rst;
  wire  reg_0_clk;
  wire  reg_0_en;
  wire  reg_0_q;
  wire  reg_0_d;
  wire  reg_1_rst;
  wire  reg_1_clk;
  wire  reg_1_en;
  wire  reg_1_q;
  wire  reg_1_d;
  wire  reg_2_rst;
  wire  reg_2_clk;
  wire  reg_2_en;
  wire  reg_2_q;
  wire  reg_2_d;
  wire  reg_3_rst;
  wire  reg_3_clk;
  wire  reg_3_en;
  wire  reg_3_q;
  wire  reg_3_d;
  wire  reg_4_rst;
  wire  reg_4_clk;
  wire  reg_4_en;
  wire  reg_4_q;
  wire  reg_4_d;
  wire  reg_5_rst;
  wire  reg_5_clk;
  wire  reg_5_en;
  wire  reg_5_q;
  wire  reg_5_d;
  wire  reg_6_rst;
  wire  reg_6_clk;
  wire  reg_6_en;
  wire  reg_6_q;
  wire  reg_6_d;
  wire  reg_7_rst;
  wire  reg_7_clk;
  wire  reg_7_en;
  wire  reg_7_q;
  wire  reg_7_d;
  wire  reg_8_rst;
  wire  reg_8_clk;
  wire  reg_8_en;
  wire  reg_8_q;
  wire  reg_8_d;
  wire  reg_9_rst;
  wire  reg_9_clk;
  wire  reg_9_en;
  wire  reg_9_q;
  wire  reg_9_d;
  wire  reg_10_rst;
  wire  reg_10_clk;
  wire  reg_10_en;
  wire  reg_10_q;
  wire  reg_10_d;
  wire  reg_11_rst;
  wire  reg_11_clk;
  wire  reg_11_en;
  wire  reg_11_q;
  wire  reg_11_d;
  wire  reg_12_rst;
  wire  reg_12_clk;
  wire  reg_12_en;
  wire  reg_12_q;
  wire  reg_12_d;
  wire  reg_13_rst;
  wire  reg_13_clk;
  wire  reg_13_en;
  wire  reg_13_q;
  wire  reg_13_d;
  wire  reg_14_rst;
  wire  reg_14_clk;
  wire  reg_14_en;
  wire  reg_14_q;
  wire  reg_14_d;
  wire  reg_15_rst;
  wire  reg_15_clk;
  wire  reg_15_en;
  wire  reg_15_q;
  wire  reg_15_d;
  wire  reg_16_rst;
  wire  reg_16_clk;
  wire  reg_16_en;
  wire  reg_16_q;
  wire  reg_16_d;
  wire  reg_17_rst;
  wire  reg_17_clk;
  wire  reg_17_en;
  wire  reg_17_q;
  wire  reg_17_d;
  wire  reg_18_rst;
  wire  reg_18_clk;
  wire  reg_18_en;
  wire  reg_18_q;
  wire  reg_18_d;
  wire  reg_19_rst;
  wire  reg_19_clk;
  wire  reg_19_en;
  wire  reg_19_q;
  wire  reg_19_d;
  wire  T_8;
  wire  T_9;
  wire  T_10;
  wire  T_11;
  wire  T_12;
  wire  T_13;
  wire  T_14;
  wire  T_15;
  wire  T_16;
  wire  T_17;
  wire  T_18;
  wire  T_19;
  wire  T_20;
  wire  T_21;
  wire  T_22;
  wire  T_23;
  wire  T_24;
  wire  T_25;
  wire  T_26;
  wire  T_27;
  wire [1:0] T_28;
  wire [1:0] T_29;
  wire [2:0] T_30;
  wire [4:0] T_31;
  wire [1:0] T_32;
  wire [1:0] T_33;
  wire [2:0] T_34;
  wire [4:0] T_35;
  wire [9:0] T_36;
  wire [1:0] T_37;
  wire [1:0] T_38;
  wire [2:0] T_39;
  wire [4:0] T_40;
  wire [1:0] T_41;
  wire [1:0] T_42;
  wire [2:0] T_43;
  wire [4:0] T_44;
  wire [9:0] T_45;
  wire [19:0] T_46;
  sirv_AsyncResetReg reg_0 (
    .rst(reg_0_rst),
    .clk(reg_0_clk),
    .en(reg_0_en),
    .q(reg_0_q),
    .d(reg_0_d)
  );
  sirv_AsyncResetReg reg_1 (
    .rst(reg_1_rst),
    .clk(reg_1_clk),
    .en(reg_1_en),
    .q(reg_1_q),
    .d(reg_1_d)
  );
  sirv_AsyncResetReg reg_2 (
    .rst(reg_2_rst),
    .clk(reg_2_clk),
    .en(reg_2_en),
    .q(reg_2_q),
    .d(reg_2_d)
  );
  sirv_AsyncResetReg reg_3 (
    .rst(reg_3_rst),
    .clk(reg_3_clk),
    .en(reg_3_en),
    .q(reg_3_q),
    .d(reg_3_d)
  );
  sirv_AsyncResetReg reg_4 (
    .rst(reg_4_rst),
    .clk(reg_4_clk),
    .en(reg_4_en),
    .q(reg_4_q),
    .d(reg_4_d)
  );
  sirv_AsyncResetReg reg_5 (
    .rst(reg_5_rst),
    .clk(reg_5_clk),
    .en(reg_5_en),
    .q(reg_5_q),
    .d(reg_5_d)
  );
  sirv_AsyncResetReg reg_6 (
    .rst(reg_6_rst),
    .clk(reg_6_clk),
    .en(reg_6_en),
    .q(reg_6_q),
    .d(reg_6_d)
  );
  sirv_AsyncResetReg reg_7 (
    .rst(reg_7_rst),
    .clk(reg_7_clk),
    .en(reg_7_en),
    .q(reg_7_q),
    .d(reg_7_d)
  );
  sirv_AsyncResetReg reg_8 (
    .rst(reg_8_rst),
    .clk(reg_8_clk),
    .en(reg_8_en),
    .q(reg_8_q),
    .d(reg_8_d)
  );
  sirv_AsyncResetReg reg_9 (
    .rst(reg_9_rst),
    .clk(reg_9_clk),
    .en(reg_9_en),
    .q(reg_9_q),
    .d(reg_9_d)
  );
  sirv_AsyncResetReg reg_10 (
    .rst(reg_10_rst),
    .clk(reg_10_clk),
    .en(reg_10_en),
    .q(reg_10_q),
    .d(reg_10_d)
  );
  sirv_AsyncResetReg reg_11 (
    .rst(reg_11_rst),
    .clk(reg_11_clk),
    .en(reg_11_en),
    .q(reg_11_q),
    .d(reg_11_d)
  );
  sirv_AsyncResetReg reg_12 (
    .rst(reg_12_rst),
    .clk(reg_12_clk),
    .en(reg_12_en),
    .q(reg_12_q),
    .d(reg_12_d)
  );
  sirv_AsyncResetReg reg_13 (
    .rst(reg_13_rst),
    .clk(reg_13_clk),
    .en(reg_13_en),
    .q(reg_13_q),
    .d(reg_13_d)
  );
  sirv_AsyncResetReg reg_14 (
    .rst(reg_14_rst),
    .clk(reg_14_clk),
    .en(reg_14_en),
    .q(reg_14_q),
    .d(reg_14_d)
  );
  sirv_AsyncResetReg reg_15 (
    .rst(reg_15_rst),
    .clk(reg_15_clk),
    .en(reg_15_en),
    .q(reg_15_q),
    .d(reg_15_d)
  );
  sirv_AsyncResetReg reg_16 (
    .rst(reg_16_rst),
    .clk(reg_16_clk),
    .en(reg_16_en),
    .q(reg_16_q),
    .d(reg_16_d)
  );
  sirv_AsyncResetReg reg_17 (
    .rst(reg_17_rst),
    .clk(reg_17_clk),
    .en(reg_17_en),
    .q(reg_17_q),
    .d(reg_17_d)
  );
  sirv_AsyncResetReg reg_18 (
    .rst(reg_18_rst),
    .clk(reg_18_clk),
    .en(reg_18_en),
    .q(reg_18_q),
    .d(reg_18_d)
  );
  sirv_AsyncResetReg reg_19 (
    .rst(reg_19_rst),
    .clk(reg_19_clk),
    .en(reg_19_en),
    .q(reg_19_q),
    .d(reg_19_d)
  );
  assign io_q = T_46;
  assign reg_0_rst = reset;
  assign reg_0_clk = clock;
  assign reg_0_en = io_en;
  assign reg_0_d = T_8;
  assign reg_1_rst = reset;
  assign reg_1_clk = clock;
  assign reg_1_en = io_en;
  assign reg_1_d = T_9;
  assign reg_2_rst = reset;
  assign reg_2_clk = clock;
  assign reg_2_en = io_en;
  assign reg_2_d = T_10;
  assign reg_3_rst = reset;
  assign reg_3_clk = clock;
  assign reg_3_en = io_en;
  assign reg_3_d = T_11;
  assign reg_4_rst = reset;
  assign reg_4_clk = clock;
  assign reg_4_en = io_en;
  assign reg_4_d = T_12;
  assign reg_5_rst = reset;
  assign reg_5_clk = clock;
  assign reg_5_en = io_en;
  assign reg_5_d = T_13;
  assign reg_6_rst = reset;
  assign reg_6_clk = clock;
  assign reg_6_en = io_en;
  assign reg_6_d = T_14;
  assign reg_7_rst = reset;
  assign reg_7_clk = clock;
  assign reg_7_en = io_en;
  assign reg_7_d = T_15;
  assign reg_8_rst = reset;
  assign reg_8_clk = clock;
  assign reg_8_en = io_en;
  assign reg_8_d = T_16;
  assign reg_9_rst = reset;
  assign reg_9_clk = clock;
  assign reg_9_en = io_en;
  assign reg_9_d = T_17;
  assign reg_10_rst = reset;
  assign reg_10_clk = clock;
  assign reg_10_en = io_en;
  assign reg_10_d = T_18;
  assign reg_11_rst = reset;
  assign reg_11_clk = clock;
  assign reg_11_en = io_en;
  assign reg_11_d = T_19;
  assign reg_12_rst = reset;
  assign reg_12_clk = clock;
  assign reg_12_en = io_en;
  assign reg_12_d = T_20;
  assign reg_13_rst = reset;
  assign reg_13_clk = clock;
  assign reg_13_en = io_en;
  assign reg_13_d = T_21;
  assign reg_14_rst = reset;
  assign reg_14_clk = clock;
  assign reg_14_en = io_en;
  assign reg_14_d = T_22;
  assign reg_15_rst = reset;
  assign reg_15_clk = clock;
  assign reg_15_en = io_en;
  assign reg_15_d = T_23;
  assign reg_16_rst = reset;
  assign reg_16_clk = clock;
  assign reg_16_en = io_en;
  assign reg_16_d = T_24;
  assign reg_17_rst = reset;
  assign reg_17_clk = clock;
  assign reg_17_en = io_en;
  assign reg_17_d = T_25;
  assign reg_18_rst = reset;
  assign reg_18_clk = clock;
  assign reg_18_en = io_en;
  assign reg_18_d = T_26;
  assign reg_19_rst = reset;
  assign reg_19_clk = clock;
  assign reg_19_en = io_en;
  assign reg_19_d = T_27;
  assign T_8 = io_d[0];
  assign T_9 = io_d[1];
  assign T_10 = io_d[2];
  assign T_11 = io_d[3];
  assign T_12 = io_d[4];
  assign T_13 = io_d[5];
  assign T_14 = io_d[6];
  assign T_15 = io_d[7];
  assign T_16 = io_d[8];
  assign T_17 = io_d[9];
  assign T_18 = io_d[10];
  assign T_19 = io_d[11];
  assign T_20 = io_d[12];
  assign T_21 = io_d[13];
  assign T_22 = io_d[14];
  assign T_23 = io_d[15];
  assign T_24 = io_d[16];
  assign T_25 = io_d[17];
  assign T_26 = io_d[18];
  assign T_27 = io_d[19];
  assign T_28 = {reg_1_q,reg_0_q};
  assign T_29 = {reg_4_q,reg_3_q};
  assign T_30 = {T_29,reg_2_q};
  assign T_31 = {T_30,T_28};
  assign T_32 = {reg_6_q,reg_5_q};
  assign T_33 = {reg_9_q,reg_8_q};
  assign T_34 = {T_33,reg_7_q};
  assign T_35 = {T_34,T_32};
  assign T_36 = {T_35,T_31};
  assign T_37 = {reg_11_q,reg_10_q};
  assign T_38 = {reg_14_q,reg_13_q};
  assign T_39 = {T_38,reg_12_q};
  assign T_40 = {T_39,T_37};
  assign T_41 = {reg_16_q,reg_15_q};
  assign T_42 = {reg_19_q,reg_18_q};
  assign T_43 = {T_42,reg_17_q};
  assign T_44 = {T_43,T_41};
  assign T_45 = {T_44,T_40};
  assign T_46 = {T_45,T_36};
endmodule

