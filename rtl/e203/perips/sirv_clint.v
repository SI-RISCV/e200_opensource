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
                                                                         
                                                                         
                                                                         

module sirv_clint(
  input   clock,
  input   reset,
  output  io_in_0_a_ready,
  input   io_in_0_a_valid,
  input  [2:0] io_in_0_a_bits_opcode,
  input  [2:0] io_in_0_a_bits_param,
  input  [2:0] io_in_0_a_bits_size,
  input  [4:0] io_in_0_a_bits_source,
  input  [25:0] io_in_0_a_bits_address,
  input  [3:0] io_in_0_a_bits_mask,
  input  [31:0] io_in_0_a_bits_data,
  input   io_in_0_b_ready,
  output  io_in_0_b_valid,
  output [2:0] io_in_0_b_bits_opcode,
  output [1:0] io_in_0_b_bits_param,
  output [2:0] io_in_0_b_bits_size,
  output [4:0] io_in_0_b_bits_source,
  output [25:0] io_in_0_b_bits_address,
  output [3:0] io_in_0_b_bits_mask,
  output [31:0] io_in_0_b_bits_data,
  output  io_in_0_c_ready,
  input   io_in_0_c_valid,
  input  [2:0] io_in_0_c_bits_opcode,
  input  [2:0] io_in_0_c_bits_param,
  input  [2:0] io_in_0_c_bits_size,
  input  [4:0] io_in_0_c_bits_source,
  input  [25:0] io_in_0_c_bits_address,
  input  [31:0] io_in_0_c_bits_data,
  input   io_in_0_c_bits_error,
  input   io_in_0_d_ready,
  output  io_in_0_d_valid,
  output [2:0] io_in_0_d_bits_opcode,
  output [1:0] io_in_0_d_bits_param,
  output [2:0] io_in_0_d_bits_size,
  output [4:0] io_in_0_d_bits_source,
  output  io_in_0_d_bits_sink,
  output [1:0] io_in_0_d_bits_addr_lo,
  output [31:0] io_in_0_d_bits_data,
  output  io_in_0_d_bits_error,
  output  io_in_0_e_ready,
  input   io_in_0_e_valid,
  input   io_in_0_e_bits_sink,
  output  io_tiles_0_mtip,
  output  io_tiles_0_msip,
  input   io_rtcTick
);
  reg [31:0] time_0;
  reg [31:0] GEN_62;
  reg [31:0] time_1;
  reg [31:0] GEN_63;
  wire [63:0] T_904;
  wire [64:0] T_906;
  wire [63:0] T_907;
  wire [31:0] T_909;
  wire [63:0] GEN_6;
  wire [31:0] GEN_7;
  reg [31:0] timecmp_0_0;
  reg [31:0] GEN_64;
  reg [31:0] timecmp_0_1;
  reg [31:0] GEN_65;
  reg  ipi_0;
  reg [31:0] GEN_66;
  wire [63:0] T_915;
  wire  T_916;
  wire  T_940_ready;
  wire  T_940_valid;
  wire  T_940_bits_read;
  wire [13:0] T_940_bits_index;
  wire [31:0] T_940_bits_data;
  wire [3:0] T_940_bits_mask;
  wire [9:0] T_940_bits_extra;
  wire  T_957;
  wire [23:0] T_958;
  wire [1:0] T_959;
  wire [6:0] T_960;
  wire [9:0] T_961;
  wire  T_979_ready;
  wire  T_979_valid;
  wire  T_979_bits_read;
  wire [31:0] T_979_bits_data;
  wire [9:0] T_979_bits_extra;
  wire  T_1015_ready;
  wire  T_1015_valid;
  wire  T_1015_bits_read;
  wire [13:0] T_1015_bits_index;
  wire [31:0] T_1015_bits_data;
  wire [3:0] T_1015_bits_mask;
  wire [9:0] T_1015_bits_extra;
  wire  T_1058_0;
  wire  T_1058_1;
  wire  T_1058_2;
  wire  T_1058_3;
  wire  T_1058_4;
  wire  T_1063_0;
  wire  T_1063_1;
  wire  T_1063_2;
  wire  T_1063_3;
  wire  T_1063_4;
  wire  T_1068_0;
  wire  T_1068_1;
  wire  T_1068_2;
  wire  T_1068_3;
  wire  T_1068_4;
  wire  T_1073_0;
  wire  T_1073_1;
  wire  T_1073_2;
  wire  T_1073_3;
  wire  T_1073_4;
  wire  T_1078_0;
  wire  T_1078_1;
  wire  T_1078_2;
  wire  T_1078_3;
  wire  T_1078_4;
  wire  T_1083_0;
  wire  T_1083_1;
  wire  T_1083_2;
  wire  T_1083_3;
  wire  T_1083_4;
  wire  T_1088_0;
  wire  T_1088_1;
  wire  T_1088_2;
  wire  T_1088_3;
  wire  T_1088_4;
  wire  T_1093_0;
  wire  T_1093_1;
  wire  T_1093_2;
  wire  T_1093_3;
  wire  T_1093_4;
  wire  T_1135;
  wire  T_1136;
  wire  T_1137;
  wire  T_1138;
  wire [7:0] T_1142;
  wire [7:0] T_1146;
  wire [7:0] T_1150;
  wire [7:0] T_1154;
  wire [15:0] T_1155;
  wire [15:0] T_1156;
  wire [31:0] T_1157;
  wire [31:0] T_1185;
  wire  T_1187;
  wire  T_1200;
  wire [31:0] GEN_8;
  wire [31:0] T_1219;
  wire  T_1240;
  wire [31:0] GEN_9;
  wire  T_1280;
  wire [63:0] GEN_10;
  wire  T_1320;
  wire [31:0] GEN_11;
  wire  T_1360;
  wire [31:0] GEN_12;
  wire  T_1421_0;
  wire  T_1421_1;
  wire  T_1421_2;
  wire  T_1421_3;
  wire  T_1421_4;
  wire  T_1421_5;
  wire  T_1421_6;
  wire  T_1421_7;
  wire  T_1472_0;
  wire  T_1472_1;
  wire  T_1472_2;
  wire  T_1472_3;
  wire  T_1472_4;
  wire  T_1472_5;
  wire  T_1472_6;
  wire  T_1472_7;
  wire  T_1523_0;
  wire  T_1523_1;
  wire  T_1523_2;
  wire  T_1523_3;
  wire  T_1523_4;
  wire  T_1523_5;
  wire  T_1523_6;
  wire  T_1523_7;
  wire  T_1574_0;
  wire  T_1574_1;
  wire  T_1574_2;
  wire  T_1574_3;
  wire  T_1574_4;
  wire  T_1574_5;
  wire  T_1574_6;
  wire  T_1574_7;
  wire  T_1585;
  wire  T_1586;
  wire  T_1597;
  wire [1:0] T_1599;
  wire [2:0] T_1600;
  wire  GEN_0;
  wire  GEN_13;
  wire  GEN_14;
  wire  GEN_15;
  wire  GEN_16;
  wire  GEN_17;
  wire  GEN_18;
  wire  GEN_19;
  wire  GEN_1;
  wire  GEN_20;
  wire  GEN_21;
  wire  GEN_22;
  wire  GEN_23;
  wire  GEN_24;
  wire  GEN_25;
  wire  GEN_26;
  wire  T_1619;
  wire  GEN_2;
  wire  GEN_27;
  wire  GEN_28;
  wire  GEN_29;
  wire  GEN_30;
  wire  GEN_31;
  wire  GEN_32;
  wire  GEN_33;
  wire  GEN_3;
  wire  GEN_34;
  wire  GEN_35;
  wire  GEN_36;
  wire  GEN_37;
  wire  GEN_38;
  wire  GEN_39;
  wire  GEN_40;
  wire  T_1622;
  wire  T_1623;
  wire  T_1624;
  wire  T_1625;
  wire  T_1626;
  wire [7:0] T_1628;
  wire  T_1647;
  wire  T_1648;
  wire  T_1649;
  wire  T_1650;
  wire  T_1653;
  wire  T_1654;
  wire  T_1656;
  wire  T_1657;
  wire  T_1658;
  wire  T_1660;
  wire  T_1664;
  wire  T_1666;
  wire  T_1689;
  wire  T_1690;
  wire  T_1696;
  wire  T_1700;
  wire  T_1706;
  wire  T_1709;
  wire  T_1710;
  wire  T_1716;
  wire  T_1720;
  wire  T_1726;
  wire  T_1729;
  wire  T_1730;
  wire  T_1736;
  wire  T_1740;
  wire  T_1746;
  wire  T_1749;
  wire  T_1750;
  wire  T_1756;
  wire  T_1760;
  wire  T_1766;
  wire  T_1838_0;
  wire  T_1838_1;
  wire  T_1838_2;
  wire  T_1838_3;
  wire  T_1838_4;
  wire  T_1838_5;
  wire  T_1838_6;
  wire  T_1838_7;
  wire [31:0] T_1861_0;
  wire [31:0] T_1861_1;
  wire [31:0] T_1861_2;
  wire [31:0] T_1861_3;
  wire [31:0] T_1861_4;
  wire [31:0] T_1861_5;
  wire [31:0] T_1861_6;
  wire [31:0] T_1861_7;
  wire  GEN_4;
  wire  GEN_41;
  wire  GEN_42;
  wire  GEN_43;
  wire  GEN_44;
  wire  GEN_45;
  wire  GEN_46;
  wire  GEN_47;
  wire [31:0] GEN_5;
  wire [31:0] GEN_48;
  wire [31:0] GEN_49;
  wire [31:0] GEN_50;
  wire [31:0] GEN_51;
  wire [31:0] GEN_52;
  wire [31:0] GEN_53;
  wire [31:0] GEN_54;
  wire [31:0] T_1874;
  wire [1:0] T_1875;
  wire [4:0] T_1877;
  wire [2:0] T_1878;
  wire [2:0] T_1889_opcode;
  wire [1:0] T_1889_param;
  wire [2:0] T_1889_size;
  wire [4:0] T_1889_source;
  wire  T_1889_sink;
  wire [1:0] T_1889_addr_lo;
  wire [31:0] T_1889_data;
  wire  T_1889_error;
  wire [2:0] GEN_55 = 3'b0;
  reg [31:0] GEN_67;
  wire [1:0] GEN_56 = 2'b0;
  reg [31:0] GEN_68;
  wire [2:0] GEN_57 = 3'b0;
  reg [31:0] GEN_69;
  wire [4:0] GEN_58 = 5'b0;
  reg [31:0] GEN_70;
  wire [25:0] GEN_59 = 26'b0;
  reg [31:0] GEN_71;
  wire [3:0] GEN_60 = 4'b0;
  reg [31:0] GEN_72;
  wire [31:0] GEN_61 = 32'b0;
  reg [31:0] GEN_73;
  assign io_in_0_a_ready = T_940_ready;
  assign io_in_0_b_valid = 1'h0;
  assign io_in_0_b_bits_opcode = GEN_55;
  assign io_in_0_b_bits_param = GEN_56;
  assign io_in_0_b_bits_size = GEN_57;
  assign io_in_0_b_bits_source = GEN_58;
  assign io_in_0_b_bits_address = GEN_59;
  assign io_in_0_b_bits_mask = GEN_60;
  assign io_in_0_b_bits_data = GEN_61;
  assign io_in_0_c_ready = 1'h1;
  assign io_in_0_d_valid = T_979_valid;
  assign io_in_0_d_bits_opcode = {{2'd0}, T_979_bits_read};
  assign io_in_0_d_bits_param = T_1889_param;
  assign io_in_0_d_bits_size = T_1889_size;
  assign io_in_0_d_bits_source = T_1889_source;
  assign io_in_0_d_bits_sink = T_1889_sink;
  assign io_in_0_d_bits_addr_lo = T_1889_addr_lo;
  assign io_in_0_d_bits_data = T_979_bits_data;
  assign io_in_0_d_bits_error = T_1889_error;
  assign io_in_0_e_ready = 1'h1;
  assign io_tiles_0_mtip = T_916;
  assign io_tiles_0_msip = ipi_0;
  assign T_904 = {time_1,time_0};
  assign T_906 = T_904 + 64'h1;
  assign T_907 = T_906[63:0];
  assign T_909 = T_907[63:32];
  assign GEN_6 = io_rtcTick ? T_907 : {{32'd0}, time_0};
  assign GEN_7 = io_rtcTick ? T_909 : time_1;
  assign T_915 = {timecmp_0_1,timecmp_0_0};
  assign T_916 = T_904 >= T_915;
  assign T_940_ready = T_1623;
  assign T_940_valid = io_in_0_a_valid;
  assign T_940_bits_read = T_957;
  assign T_940_bits_index = T_958[13:0];
  assign T_940_bits_data = io_in_0_a_bits_data;
  assign T_940_bits_mask = io_in_0_a_bits_mask;
  assign T_940_bits_extra = T_961;
  assign T_957 = io_in_0_a_bits_opcode == 3'h4;
  assign T_958 = io_in_0_a_bits_address[25:2];
  assign T_959 = io_in_0_a_bits_address[1:0];
  assign T_960 = {T_959,io_in_0_a_bits_source};
  assign T_961 = {T_960,io_in_0_a_bits_size};
  assign T_979_ready = io_in_0_d_ready;
  assign T_979_valid = T_1626;
  assign T_979_bits_read = T_1015_bits_read;
  assign T_979_bits_data = T_1874;
  assign T_979_bits_extra = T_1015_bits_extra;
  assign T_1015_ready = T_1625;
  assign T_1015_valid = T_1624;
  assign T_1015_bits_read = T_940_bits_read;
  assign T_1015_bits_index = T_940_bits_index;
  assign T_1015_bits_data = T_940_bits_data;
  assign T_1015_bits_mask = T_940_bits_mask;
  assign T_1015_bits_extra = T_940_bits_extra;
  assign T_1058_0 = T_1650;
  assign T_1058_1 = T_1750;
  assign T_1058_2 = T_1690;
  assign T_1058_3 = T_1710;
  assign T_1058_4 = T_1730;
  assign T_1063_0 = T_1656;
  assign T_1063_1 = T_1756;
  assign T_1063_2 = T_1696;
  assign T_1063_3 = T_1716;
  assign T_1063_4 = T_1736;
  assign T_1068_0 = 1'h1;
  assign T_1068_1 = 1'h1;
  assign T_1068_2 = 1'h1;
  assign T_1068_3 = 1'h1;
  assign T_1068_4 = 1'h1;
  assign T_1073_0 = 1'h1;
  assign T_1073_1 = 1'h1;
  assign T_1073_2 = 1'h1;
  assign T_1073_3 = 1'h1;
  assign T_1073_4 = 1'h1;
  assign T_1078_0 = 1'h1;
  assign T_1078_1 = 1'h1;
  assign T_1078_2 = 1'h1;
  assign T_1078_3 = 1'h1;
  assign T_1078_4 = 1'h1;
  assign T_1083_0 = 1'h1;
  assign T_1083_1 = 1'h1;
  assign T_1083_2 = 1'h1;
  assign T_1083_3 = 1'h1;
  assign T_1083_4 = 1'h1;
  assign T_1088_0 = T_1660;
  assign T_1088_1 = T_1760;
  assign T_1088_2 = T_1700;
  assign T_1088_3 = T_1720;
  assign T_1088_4 = T_1740;
  assign T_1093_0 = T_1666;
  assign T_1093_1 = T_1766;
  assign T_1093_2 = T_1706;
  assign T_1093_3 = T_1726;
  assign T_1093_4 = T_1746;
  assign T_1135 = T_1015_bits_mask[0];
  assign T_1136 = T_1015_bits_mask[1];
  assign T_1137 = T_1015_bits_mask[2];
  assign T_1138 = T_1015_bits_mask[3];
  assign T_1142 = T_1135 ? 8'hff : 8'h0;
  assign T_1146 = T_1136 ? 8'hff : 8'h0;
  assign T_1150 = T_1137 ? 8'hff : 8'h0;
  assign T_1154 = T_1138 ? 8'hff : 8'h0;
  assign T_1155 = {T_1146,T_1142};
  assign T_1156 = {T_1154,T_1150};
  assign T_1157 = {T_1156,T_1155};
  assign T_1185 = ~ T_1157;
  assign T_1187 = T_1185 == 32'h0;
  assign T_1200 = T_1093_0 & T_1187;
  assign GEN_8 = T_1200 ? T_1015_bits_data : {{31'd0}, ipi_0};
  assign T_1219 = {{31'd0}, ipi_0};
  assign T_1240 = T_1093_1 & T_1187;
  assign GEN_9 = T_1240 ? T_1015_bits_data : timecmp_0_1;
  assign T_1280 = T_1093_2 & T_1187;
  assign GEN_10 = T_1280 ? {{32'd0}, T_1015_bits_data} : GEN_6;
  assign T_1320 = T_1093_3 & T_1187;
  assign GEN_11 = T_1320 ? T_1015_bits_data : GEN_7;
  assign T_1360 = T_1093_4 & T_1187;
  assign GEN_12 = T_1360 ? T_1015_bits_data : timecmp_0_0;
  assign T_1421_0 = T_1068_0;
  assign T_1421_1 = 1'h1;
  assign T_1421_2 = T_1068_2;
  assign T_1421_3 = T_1068_3;
  assign T_1421_4 = T_1068_4;
  assign T_1421_5 = T_1068_1;
  assign T_1421_6 = 1'h1;
  assign T_1421_7 = 1'h1;
  assign T_1472_0 = T_1073_0;
  assign T_1472_1 = 1'h1;
  assign T_1472_2 = T_1073_2;
  assign T_1472_3 = T_1073_3;
  assign T_1472_4 = T_1073_4;
  assign T_1472_5 = T_1073_1;
  assign T_1472_6 = 1'h1;
  assign T_1472_7 = 1'h1;
  assign T_1523_0 = T_1078_0;
  assign T_1523_1 = 1'h1;
  assign T_1523_2 = T_1078_2;
  assign T_1523_3 = T_1078_3;
  assign T_1523_4 = T_1078_4;
  assign T_1523_5 = T_1078_1;
  assign T_1523_6 = 1'h1;
  assign T_1523_7 = 1'h1;
  assign T_1574_0 = T_1083_0;
  assign T_1574_1 = 1'h1;
  assign T_1574_2 = T_1083_2;
  assign T_1574_3 = T_1083_3;
  assign T_1574_4 = T_1083_4;
  assign T_1574_5 = T_1083_1;
  assign T_1574_6 = 1'h1;
  assign T_1574_7 = 1'h1;
  assign T_1585 = T_1015_bits_index[0];
  assign T_1586 = T_1015_bits_index[1];
  assign T_1597 = T_1015_bits_index[12];
  assign T_1599 = {T_1597,T_1586};
  assign T_1600 = {T_1599,T_1585};
  assign GEN_0 = GEN_19;
  assign GEN_13 = 3'h1 == T_1600 ? T_1421_1 : T_1421_0;
  assign GEN_14 = 3'h2 == T_1600 ? T_1421_2 : GEN_13;
  assign GEN_15 = 3'h3 == T_1600 ? T_1421_3 : GEN_14;
  assign GEN_16 = 3'h4 == T_1600 ? T_1421_4 : GEN_15;
  assign GEN_17 = 3'h5 == T_1600 ? T_1421_5 : GEN_16;
  assign GEN_18 = 3'h6 == T_1600 ? T_1421_6 : GEN_17;
  assign GEN_19 = 3'h7 == T_1600 ? T_1421_7 : GEN_18;
  assign GEN_1 = GEN_26;
  assign GEN_20 = 3'h1 == T_1600 ? T_1472_1 : T_1472_0;
  assign GEN_21 = 3'h2 == T_1600 ? T_1472_2 : GEN_20;
  assign GEN_22 = 3'h3 == T_1600 ? T_1472_3 : GEN_21;
  assign GEN_23 = 3'h4 == T_1600 ? T_1472_4 : GEN_22;
  assign GEN_24 = 3'h5 == T_1600 ? T_1472_5 : GEN_23;
  assign GEN_25 = 3'h6 == T_1600 ? T_1472_6 : GEN_24;
  assign GEN_26 = 3'h7 == T_1600 ? T_1472_7 : GEN_25;
  assign T_1619 = T_1015_bits_read ? GEN_0 : GEN_1;
  assign GEN_2 = GEN_33;
  assign GEN_27 = 3'h1 == T_1600 ? T_1523_1 : T_1523_0;
  assign GEN_28 = 3'h2 == T_1600 ? T_1523_2 : GEN_27;
  assign GEN_29 = 3'h3 == T_1600 ? T_1523_3 : GEN_28;
  assign GEN_30 = 3'h4 == T_1600 ? T_1523_4 : GEN_29;
  assign GEN_31 = 3'h5 == T_1600 ? T_1523_5 : GEN_30;
  assign GEN_32 = 3'h6 == T_1600 ? T_1523_6 : GEN_31;
  assign GEN_33 = 3'h7 == T_1600 ? T_1523_7 : GEN_32;
  assign GEN_3 = GEN_40;
  assign GEN_34 = 3'h1 == T_1600 ? T_1574_1 : T_1574_0;
  assign GEN_35 = 3'h2 == T_1600 ? T_1574_2 : GEN_34;
  assign GEN_36 = 3'h3 == T_1600 ? T_1574_3 : GEN_35;
  assign GEN_37 = 3'h4 == T_1600 ? T_1574_4 : GEN_36;
  assign GEN_38 = 3'h5 == T_1600 ? T_1574_5 : GEN_37;
  assign GEN_39 = 3'h6 == T_1600 ? T_1574_6 : GEN_38;
  assign GEN_40 = 3'h7 == T_1600 ? T_1574_7 : GEN_39;
  assign T_1622 = T_1015_bits_read ? GEN_2 : GEN_3;
  assign T_1623 = T_1015_ready & T_1619;
  assign T_1624 = T_940_valid & T_1619;
  assign T_1625 = T_979_ready & T_1622;
  assign T_1626 = T_1015_valid & T_1622;
  assign T_1628 = 8'h1 << T_1600;
  assign T_1647 = T_940_valid & T_1015_ready;
  assign T_1648 = T_1647 & T_1015_bits_read;
  assign T_1649 = T_1628[0];
  assign T_1650 = T_1648 & T_1649;
  assign T_1653 = T_1015_bits_read == 1'h0;
  assign T_1654 = T_1647 & T_1653;
  assign T_1656 = T_1654 & T_1649;
  assign T_1657 = T_1015_valid & T_979_ready;
  assign T_1658 = T_1657 & T_1015_bits_read;
  assign T_1660 = T_1658 & T_1649;
  assign T_1664 = T_1657 & T_1653;
  assign T_1666 = T_1664 & T_1649;
  assign T_1689 = T_1628[2];
  assign T_1690 = T_1648 & T_1689;
  assign T_1696 = T_1654 & T_1689;
  assign T_1700 = T_1658 & T_1689;
  assign T_1706 = T_1664 & T_1689;
  assign T_1709 = T_1628[3];
  assign T_1710 = T_1648 & T_1709;
  assign T_1716 = T_1654 & T_1709;
  assign T_1720 = T_1658 & T_1709;
  assign T_1726 = T_1664 & T_1709;
  assign T_1729 = T_1628[4];
  assign T_1730 = T_1648 & T_1729;
  assign T_1736 = T_1654 & T_1729;
  assign T_1740 = T_1658 & T_1729;
  assign T_1746 = T_1664 & T_1729;
  assign T_1749 = T_1628[5];
  assign T_1750 = T_1648 & T_1749;
  assign T_1756 = T_1654 & T_1749;
  assign T_1760 = T_1658 & T_1749;
  assign T_1766 = T_1664 & T_1749;
  assign T_1838_0 = 1'h1;
  assign T_1838_1 = 1'h1;
  assign T_1838_2 = 1'h1;
  assign T_1838_3 = 1'h1;
  assign T_1838_4 = 1'h1;
  assign T_1838_5 = 1'h1;
  assign T_1838_6 = 1'h1;
  assign T_1838_7 = 1'h1;
  assign T_1861_0 = T_1219;
  assign T_1861_1 = 32'h0;
  assign T_1861_2 = time_0;
  assign T_1861_3 = time_1;
  assign T_1861_4 = timecmp_0_0;
  assign T_1861_5 = timecmp_0_1;
  assign T_1861_6 = 32'h0;
  assign T_1861_7 = 32'h0;
  assign GEN_4 = GEN_47;
  assign GEN_41 = 3'h1 == T_1600 ? T_1838_1 : T_1838_0;
  assign GEN_42 = 3'h2 == T_1600 ? T_1838_2 : GEN_41;
  assign GEN_43 = 3'h3 == T_1600 ? T_1838_3 : GEN_42;
  assign GEN_44 = 3'h4 == T_1600 ? T_1838_4 : GEN_43;
  assign GEN_45 = 3'h5 == T_1600 ? T_1838_5 : GEN_44;
  assign GEN_46 = 3'h6 == T_1600 ? T_1838_6 : GEN_45;
  assign GEN_47 = 3'h7 == T_1600 ? T_1838_7 : GEN_46;
  assign GEN_5 = GEN_54;
  assign GEN_48 = 3'h1 == T_1600 ? T_1861_1 : T_1861_0;
  assign GEN_49 = 3'h2 == T_1600 ? T_1861_2 : GEN_48;
  assign GEN_50 = 3'h3 == T_1600 ? T_1861_3 : GEN_49;
  assign GEN_51 = 3'h4 == T_1600 ? T_1861_4 : GEN_50;
  assign GEN_52 = 3'h5 == T_1600 ? T_1861_5 : GEN_51;
  assign GEN_53 = 3'h6 == T_1600 ? T_1861_6 : GEN_52;
  assign GEN_54 = 3'h7 == T_1600 ? T_1861_7 : GEN_53;
  assign T_1874 = GEN_4 ? GEN_5 : 32'h0;
  assign T_1875 = T_979_bits_extra[9:8];
  assign T_1877 = T_979_bits_extra[7:3];
  assign T_1878 = T_979_bits_extra[2:0];
  assign T_1889_opcode = 3'h0;
  assign T_1889_param = 2'h0;
  assign T_1889_size = T_1878;
  assign T_1889_source = T_1877;
  assign T_1889_sink = 1'h0;
  assign T_1889_addr_lo = T_1875;
  assign T_1889_data = 32'h0;
  assign T_1889_error = 1'h0;

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      time_0 <= 32'h0;
    end else begin
      time_0 <= GEN_10[31:0];
    end
  end

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      time_1 <= 32'h0;
    end else begin
      if (T_1320) begin
        time_1 <= T_1015_bits_data;
      end else begin
        if (io_rtcTick) begin
          time_1 <= T_909;
        end
      end
    end
  end


  always @(posedge clock or posedge reset) begin
    if (reset) begin
      timecmp_0_0 <= 32'hFFFF_FFFF;
    end
    else if (T_1360) begin
      timecmp_0_0 <= T_1015_bits_data;
    end
  end


  always @(posedge clock or posedge reset) begin
    if (reset) begin
      timecmp_0_1 <= 32'hFFFF_FFFF;
    end
    else if (T_1240) begin
      timecmp_0_1 <= T_1015_bits_data;
    end
  end


  always @(posedge clock or posedge reset) begin
    if (reset) begin
      ipi_0 <= 1'h0;
    end else begin
      ipi_0 <= GEN_8[0];
    end
  end

endmodule
