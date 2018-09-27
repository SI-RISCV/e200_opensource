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
                                                                         
                                                                         
                                                                         

module sirv_pwm8(
  input   clock,
  input   reset,
  output  io_interrupts_0_0,
  output  io_interrupts_0_1,
  output  io_interrupts_0_2,
  output  io_interrupts_0_3,
  output  io_in_0_a_ready,
  input   io_in_0_a_valid,
  input  [2:0] io_in_0_a_bits_opcode,
  input  [2:0] io_in_0_a_bits_param,
  input  [2:0] io_in_0_a_bits_size,
  input  [4:0] io_in_0_a_bits_source,
  input  [28:0] io_in_0_a_bits_address,
  input  [3:0] io_in_0_a_bits_mask,
  input  [31:0] io_in_0_a_bits_data,
  input   io_in_0_b_ready,
  output  io_in_0_b_valid,
  output [2:0] io_in_0_b_bits_opcode,
  output [1:0] io_in_0_b_bits_param,
  output [2:0] io_in_0_b_bits_size,
  output [4:0] io_in_0_b_bits_source,
  output [28:0] io_in_0_b_bits_address,
  output [3:0] io_in_0_b_bits_mask,
  output [31:0] io_in_0_b_bits_data,
  output  io_in_0_c_ready,
  input   io_in_0_c_valid,
  input  [2:0] io_in_0_c_bits_opcode,
  input  [2:0] io_in_0_c_bits_param,
  input  [2:0] io_in_0_c_bits_size,
  input  [4:0] io_in_0_c_bits_source,
  input  [28:0] io_in_0_c_bits_address,
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
  output  io_gpio_0,
  output  io_gpio_1,
  output  io_gpio_2,
  output  io_gpio_3
);
  wire  pwm_clock;
  wire  pwm_reset;
  wire  pwm_io_regs_cfg_write_valid;
  wire [31:0] pwm_io_regs_cfg_write_bits;
  wire [31:0] pwm_io_regs_cfg_read;
  wire  pwm_io_regs_countLo_write_valid;
  wire [31:0] pwm_io_regs_countLo_write_bits;
  wire [31:0] pwm_io_regs_countLo_read;
  wire  pwm_io_regs_countHi_write_valid;
  wire [31:0] pwm_io_regs_countHi_write_bits;
  wire [31:0] pwm_io_regs_countHi_read;
  wire  pwm_io_regs_s_write_valid;
  wire [7:0] pwm_io_regs_s_write_bits;
  wire [7:0] pwm_io_regs_s_read;
  wire  pwm_io_regs_cmp_0_write_valid;
  wire [7:0] pwm_io_regs_cmp_0_write_bits;
  wire [7:0] pwm_io_regs_cmp_0_read;
  wire  pwm_io_regs_cmp_1_write_valid;
  wire [7:0] pwm_io_regs_cmp_1_write_bits;
  wire [7:0] pwm_io_regs_cmp_1_read;
  wire  pwm_io_regs_cmp_2_write_valid;
  wire [7:0] pwm_io_regs_cmp_2_write_bits;
  wire [7:0] pwm_io_regs_cmp_2_read;
  wire  pwm_io_regs_cmp_3_write_valid;
  wire [7:0] pwm_io_regs_cmp_3_write_bits;
  wire [7:0] pwm_io_regs_cmp_3_read;
  wire  pwm_io_regs_feed_write_valid;
  wire [31:0] pwm_io_regs_feed_write_bits;
  wire [31:0] pwm_io_regs_feed_read;
  wire  pwm_io_regs_key_write_valid;
  wire [31:0] pwm_io_regs_key_write_bits;
  wire [31:0] pwm_io_regs_key_read;
  wire  pwm_io_ip_0;
  wire  pwm_io_ip_1;
  wire  pwm_io_ip_2;
  wire  pwm_io_ip_3;
  wire  pwm_io_gpio_0;
  wire  pwm_io_gpio_1;
  wire  pwm_io_gpio_2;
  wire  pwm_io_gpio_3;
  wire  T_912_ready;
  wire  T_912_valid;
  wire  T_912_bits_read;
  wire [9:0] T_912_bits_index;
  wire [31:0] T_912_bits_data;
  wire [3:0] T_912_bits_mask;
  wire [9:0] T_912_bits_extra;
  wire  T_929;
  wire [26:0] T_930;
  wire [1:0] T_931;
  wire [6:0] T_932;
  wire [9:0] T_933;
  wire  T_951_ready;
  wire  T_951_valid;
  wire  T_951_bits_read;
  wire [31:0] T_951_bits_data;
  wire [9:0] T_951_bits_extra;
  wire  T_987_ready;
  wire  T_987_valid;
  wire  T_987_bits_read;
  wire [9:0] T_987_bits_index;
  wire [31:0] T_987_bits_data;
  wire [3:0] T_987_bits_mask;
  wire [9:0] T_987_bits_extra;
  wire [9:0] T_1040;
  wire  T_1042;
  wire [9:0] T_1048;
  wire [9:0] T_1049;
  wire  T_1051;
  wire [9:0] T_1057;
  wire [9:0] T_1058;
  wire  T_1060;
  wire [9:0] T_1066;
  wire [9:0] T_1067;
  wire  T_1069;
  wire [9:0] T_1075;
  wire [9:0] T_1076;
  wire  T_1078;
  wire [9:0] T_1084;
  wire [9:0] T_1085;
  wire  T_1087;
  wire [9:0] T_1093;
  wire [9:0] T_1094;
  wire  T_1096;
  wire [9:0] T_1102;
  wire [9:0] T_1103;
  wire  T_1105;
  wire [9:0] T_1111;
  wire [9:0] T_1112;
  wire  T_1114;
  wire [9:0] T_1120;
  wire [9:0] T_1121;
  wire  T_1123;
  wire  T_1131_0;
  wire  T_1131_1;
  wire  T_1131_2;
  wire  T_1131_3;
  wire  T_1131_4;
  wire  T_1131_5;
  wire  T_1131_6;
  wire  T_1131_7;
  wire  T_1131_8;
  wire  T_1131_9;
  wire  T_1136_0;
  wire  T_1136_1;
  wire  T_1136_2;
  wire  T_1136_3;
  wire  T_1136_4;
  wire  T_1136_5;
  wire  T_1136_6;
  wire  T_1136_7;
  wire  T_1136_8;
  wire  T_1136_9;
  wire  T_1141_0;
  wire  T_1141_1;
  wire  T_1141_2;
  wire  T_1141_3;
  wire  T_1141_4;
  wire  T_1141_5;
  wire  T_1141_6;
  wire  T_1141_7;
  wire  T_1141_8;
  wire  T_1141_9;
  wire  T_1146_0;
  wire  T_1146_1;
  wire  T_1146_2;
  wire  T_1146_3;
  wire  T_1146_4;
  wire  T_1146_5;
  wire  T_1146_6;
  wire  T_1146_7;
  wire  T_1146_8;
  wire  T_1146_9;
  wire  T_1151_0;
  wire  T_1151_1;
  wire  T_1151_2;
  wire  T_1151_3;
  wire  T_1151_4;
  wire  T_1151_5;
  wire  T_1151_6;
  wire  T_1151_7;
  wire  T_1151_8;
  wire  T_1151_9;
  wire  T_1156_0;
  wire  T_1156_1;
  wire  T_1156_2;
  wire  T_1156_3;
  wire  T_1156_4;
  wire  T_1156_5;
  wire  T_1156_6;
  wire  T_1156_7;
  wire  T_1156_8;
  wire  T_1156_9;
  wire  T_1161_0;
  wire  T_1161_1;
  wire  T_1161_2;
  wire  T_1161_3;
  wire  T_1161_4;
  wire  T_1161_5;
  wire  T_1161_6;
  wire  T_1161_7;
  wire  T_1161_8;
  wire  T_1161_9;
  wire  T_1166_0;
  wire  T_1166_1;
  wire  T_1166_2;
  wire  T_1166_3;
  wire  T_1166_4;
  wire  T_1166_5;
  wire  T_1166_6;
  wire  T_1166_7;
  wire  T_1166_8;
  wire  T_1166_9;
  wire  T_1248;
  wire  T_1249;
  wire  T_1250;
  wire  T_1251;
  wire [7:0] T_1255;
  wire [7:0] T_1259;
  wire [7:0] T_1263;
  wire [7:0] T_1267;
  wire [15:0] T_1268;
  wire [15:0] T_1269;
  wire [31:0] T_1270;
  wire [31:0] T_1298;
  wire  T_1300;
  wire  T_1313;
  wire [31:0] T_1329;
  wire [7:0] T_1334;
  wire [7:0] T_1338;
  wire  T_1340;
  wire  T_1353;
  wire [7:0] T_1354;
  wire [7:0] T_1369;
  wire  T_1393;
  wire [31:0] T_1409;
  wire  T_1433;
  wire [7:0] T_1449;
  wire  T_1473;
  wire [31:0] T_1489;
  wire  T_1513;
  wire [31:0] T_1529;
  wire  T_1553;
  wire [31:0] T_1569;
  wire  T_1593;
  wire [7:0] T_1609;
  wire  T_1633;
  wire [7:0] T_1649;
  wire  T_1673;
  wire [7:0] T_1689;
  wire  T_1695;
  wire  T_1697;
  wire  T_1702;
  wire  T_1704;
  wire  T_1706;
  wire  T_1708;
  wire  T_1710;
  wire  T_1712;
  wire  T_1717;
  wire  T_1719;
  wire  T_1721;
  wire  T_1723;
  wire  T_1725;
  wire  T_1727;
  wire  T_1729;
  wire  T_1731;
  wire  T_1733;
  wire  T_1735;
  wire  T_1737;
  wire  T_1739;
  wire  T_1771_0;
  wire  T_1771_1;
  wire  T_1771_2;
  wire  T_1771_3;
  wire  T_1771_4;
  wire  T_1771_5;
  wire  T_1771_6;
  wire  T_1771_7;
  wire  T_1771_8;
  wire  T_1771_9;
  wire  T_1771_10;
  wire  T_1771_11;
  wire  T_1771_12;
  wire  T_1771_13;
  wire  T_1771_14;
  wire  T_1771_15;
  wire  T_1793;
  wire  T_1800;
  wire  T_1804;
  wire  T_1808;
  wire  T_1815;
  wire  T_1819;
  wire  T_1823;
  wire  T_1827;
  wire  T_1831;
  wire  T_1835;
  wire  T_1867_0;
  wire  T_1867_1;
  wire  T_1867_2;
  wire  T_1867_3;
  wire  T_1867_4;
  wire  T_1867_5;
  wire  T_1867_6;
  wire  T_1867_7;
  wire  T_1867_8;
  wire  T_1867_9;
  wire  T_1867_10;
  wire  T_1867_11;
  wire  T_1867_12;
  wire  T_1867_13;
  wire  T_1867_14;
  wire  T_1867_15;
  wire  T_1889;
  wire  T_1896;
  wire  T_1900;
  wire  T_1904;
  wire  T_1911;
  wire  T_1915;
  wire  T_1919;
  wire  T_1923;
  wire  T_1927;
  wire  T_1931;
  wire  T_1963_0;
  wire  T_1963_1;
  wire  T_1963_2;
  wire  T_1963_3;
  wire  T_1963_4;
  wire  T_1963_5;
  wire  T_1963_6;
  wire  T_1963_7;
  wire  T_1963_8;
  wire  T_1963_9;
  wire  T_1963_10;
  wire  T_1963_11;
  wire  T_1963_12;
  wire  T_1963_13;
  wire  T_1963_14;
  wire  T_1963_15;
  wire  T_1985;
  wire  T_1992;
  wire  T_1996;
  wire  T_2000;
  wire  T_2007;
  wire  T_2011;
  wire  T_2015;
  wire  T_2019;
  wire  T_2023;
  wire  T_2027;
  wire  T_2059_0;
  wire  T_2059_1;
  wire  T_2059_2;
  wire  T_2059_3;
  wire  T_2059_4;
  wire  T_2059_5;
  wire  T_2059_6;
  wire  T_2059_7;
  wire  T_2059_8;
  wire  T_2059_9;
  wire  T_2059_10;
  wire  T_2059_11;
  wire  T_2059_12;
  wire  T_2059_13;
  wire  T_2059_14;
  wire  T_2059_15;
  wire  T_2078;
  wire  T_2079;
  wire  T_2080;
  wire  T_2081;
  wire [1:0] T_2088;
  wire [1:0] T_2089;
  wire [3:0] T_2090;
  wire  GEN_0;
  wire  GEN_6;
  wire  GEN_7;
  wire  GEN_8;
  wire  GEN_9;
  wire  GEN_10;
  wire  GEN_11;
  wire  GEN_12;
  wire  GEN_13;
  wire  GEN_14;
  wire  GEN_15;
  wire  GEN_16;
  wire  GEN_17;
  wire  GEN_18;
  wire  GEN_19;
  wire  GEN_20;
  wire  GEN_1;
  wire  GEN_21;
  wire  GEN_22;
  wire  GEN_23;
  wire  GEN_24;
  wire  GEN_25;
  wire  GEN_26;
  wire  GEN_27;
  wire  GEN_28;
  wire  GEN_29;
  wire  GEN_30;
  wire  GEN_31;
  wire  GEN_32;
  wire  GEN_33;
  wire  GEN_34;
  wire  GEN_35;
  wire  T_2106;
  wire  GEN_2;
  wire  GEN_36;
  wire  GEN_37;
  wire  GEN_38;
  wire  GEN_39;
  wire  GEN_40;
  wire  GEN_41;
  wire  GEN_42;
  wire  GEN_43;
  wire  GEN_44;
  wire  GEN_45;
  wire  GEN_46;
  wire  GEN_47;
  wire  GEN_48;
  wire  GEN_49;
  wire  GEN_50;
  wire  GEN_3;
  wire  GEN_51;
  wire  GEN_52;
  wire  GEN_53;
  wire  GEN_54;
  wire  GEN_55;
  wire  GEN_56;
  wire  GEN_57;
  wire  GEN_58;
  wire  GEN_59;
  wire  GEN_60;
  wire  GEN_61;
  wire  GEN_62;
  wire  GEN_63;
  wire  GEN_64;
  wire  GEN_65;
  wire  T_2109;
  wire  T_2110;
  wire  T_2111;
  wire  T_2112;
  wire  T_2113;
  wire [15:0] T_2115;
  wire [1:0] T_2116;
  wire [1:0] T_2117;
  wire [3:0] T_2118;
  wire [1:0] T_2119;
  wire [1:0] T_2120;
  wire [3:0] T_2121;
  wire [7:0] T_2122;
  wire [1:0] T_2123;
  wire [1:0] T_2124;
  wire [3:0] T_2125;
  wire [7:0] T_2129;
  wire [15:0] T_2130;
  wire [15:0] T_2131;
  wire  T_2150;
  wire  T_2151;
  wire  T_2152;
  wire  T_2153;
  wire  T_2156;
  wire  T_2157;
  wire  T_2159;
  wire  T_2160;
  wire  T_2161;
  wire  T_2163;
  wire  T_2167;
  wire  T_2169;
  wire  T_2192;
  wire  T_2193;
  wire  T_2199;
  wire  T_2203;
  wire  T_2209;
  wire  T_2212;
  wire  T_2213;
  wire  T_2219;
  wire  T_2223;
  wire  T_2229;
  wire  T_2232;
  wire  T_2233;
  wire  T_2239;
  wire  T_2243;
  wire  T_2249;
  wire  T_2272;
  wire  T_2273;
  wire  T_2279;
  wire  T_2283;
  wire  T_2289;
  wire  T_2292;
  wire  T_2293;
  wire  T_2299;
  wire  T_2303;
  wire  T_2309;
  wire  T_2312;
  wire  T_2313;
  wire  T_2319;
  wire  T_2323;
  wire  T_2329;
  wire  T_2332;
  wire  T_2333;
  wire  T_2339;
  wire  T_2343;
  wire  T_2349;
  wire  T_2352;
  wire  T_2353;
  wire  T_2359;
  wire  T_2363;
  wire  T_2369;
  wire  T_2372;
  wire  T_2373;
  wire  T_2379;
  wire  T_2383;
  wire  T_2389;
  wire  T_2529_0;
  wire  T_2529_1;
  wire  T_2529_2;
  wire  T_2529_3;
  wire  T_2529_4;
  wire  T_2529_5;
  wire  T_2529_6;
  wire  T_2529_7;
  wire  T_2529_8;
  wire  T_2529_9;
  wire  T_2529_10;
  wire  T_2529_11;
  wire  T_2529_12;
  wire  T_2529_13;
  wire  T_2529_14;
  wire  T_2529_15;
  wire [31:0] T_2568_0;
  wire [31:0] T_2568_1;
  wire [31:0] T_2568_2;
  wire [31:0] T_2568_3;
  wire [31:0] T_2568_4;
  wire [31:0] T_2568_5;
  wire [31:0] T_2568_6;
  wire [31:0] T_2568_7;
  wire [31:0] T_2568_8;
  wire [31:0] T_2568_9;
  wire [31:0] T_2568_10;
  wire [31:0] T_2568_11;
  wire [31:0] T_2568_12;
  wire [31:0] T_2568_13;
  wire [31:0] T_2568_14;
  wire [31:0] T_2568_15;
  wire  GEN_4;
  wire  GEN_66;
  wire  GEN_67;
  wire  GEN_68;
  wire  GEN_69;
  wire  GEN_70;
  wire  GEN_71;
  wire  GEN_72;
  wire  GEN_73;
  wire  GEN_74;
  wire  GEN_75;
  wire  GEN_76;
  wire  GEN_77;
  wire  GEN_78;
  wire  GEN_79;
  wire  GEN_80;
  wire [31:0] GEN_5;
  wire [31:0] GEN_81;
  wire [31:0] GEN_82;
  wire [31:0] GEN_83;
  wire [31:0] GEN_84;
  wire [31:0] GEN_85;
  wire [31:0] GEN_86;
  wire [31:0] GEN_87;
  wire [31:0] GEN_88;
  wire [31:0] GEN_89;
  wire [31:0] GEN_90;
  wire [31:0] GEN_91;
  wire [31:0] GEN_92;
  wire [31:0] GEN_93;
  wire [31:0] GEN_94;
  wire [31:0] GEN_95;
  wire [31:0] T_2589;
  wire [1:0] T_2590;
  wire [4:0] T_2592;
  wire [2:0] T_2593;
  wire [2:0] T_2604_opcode;
  wire [1:0] T_2604_param;
  wire [2:0] T_2604_size;
  wire [4:0] T_2604_source;
  wire  T_2604_sink;
  wire [1:0] T_2604_addr_lo;
  wire [31:0] T_2604_data;
  wire  T_2604_error;
  wire [2:0] GEN_96 = 3'b0;
  reg [31:0] GEN_103;
  wire [1:0] GEN_97 = 2'b0;
  reg [31:0] GEN_104;
  wire [2:0] GEN_98 = 3'b0;
  reg [31:0] GEN_105;
  wire [4:0] GEN_99 = 5'b0;
  reg [31:0] GEN_106;
  wire [28:0] GEN_100 = 29'b0;
  reg [31:0] GEN_107;
  wire [3:0] GEN_101 = 4'b0;
  reg [31:0] GEN_108;
  wire [31:0] GEN_102 = 32'b0;
  reg [31:0] GEN_109;
  sirv_pwm8_core pwm (
    .clock(pwm_clock),
    .reset(pwm_reset),
    .io_regs_cfg_write_valid(pwm_io_regs_cfg_write_valid),
    .io_regs_cfg_write_bits(pwm_io_regs_cfg_write_bits),
    .io_regs_cfg_read(pwm_io_regs_cfg_read),
    .io_regs_countLo_write_valid(pwm_io_regs_countLo_write_valid),
    .io_regs_countLo_write_bits(pwm_io_regs_countLo_write_bits),
    .io_regs_countLo_read(pwm_io_regs_countLo_read),
    .io_regs_countHi_write_valid(pwm_io_regs_countHi_write_valid),
    .io_regs_countHi_write_bits(pwm_io_regs_countHi_write_bits),
    .io_regs_countHi_read(pwm_io_regs_countHi_read),
    .io_regs_s_write_valid(pwm_io_regs_s_write_valid),
    .io_regs_s_write_bits(pwm_io_regs_s_write_bits),
    .io_regs_s_read(pwm_io_regs_s_read),
    .io_regs_cmp_0_write_valid(pwm_io_regs_cmp_0_write_valid),
    .io_regs_cmp_0_write_bits(pwm_io_regs_cmp_0_write_bits),
    .io_regs_cmp_0_read(pwm_io_regs_cmp_0_read),
    .io_regs_cmp_1_write_valid(pwm_io_regs_cmp_1_write_valid),
    .io_regs_cmp_1_write_bits(pwm_io_regs_cmp_1_write_bits),
    .io_regs_cmp_1_read(pwm_io_regs_cmp_1_read),
    .io_regs_cmp_2_write_valid(pwm_io_regs_cmp_2_write_valid),
    .io_regs_cmp_2_write_bits(pwm_io_regs_cmp_2_write_bits),
    .io_regs_cmp_2_read(pwm_io_regs_cmp_2_read),
    .io_regs_cmp_3_write_valid(pwm_io_regs_cmp_3_write_valid),
    .io_regs_cmp_3_write_bits(pwm_io_regs_cmp_3_write_bits),
    .io_regs_cmp_3_read(pwm_io_regs_cmp_3_read),
    .io_regs_feed_write_valid(pwm_io_regs_feed_write_valid),
    .io_regs_feed_write_bits(pwm_io_regs_feed_write_bits),
    .io_regs_feed_read(pwm_io_regs_feed_read),
    .io_regs_key_write_valid(pwm_io_regs_key_write_valid),
    .io_regs_key_write_bits(pwm_io_regs_key_write_bits),
    .io_regs_key_read(pwm_io_regs_key_read),
    .io_ip_0(pwm_io_ip_0),
    .io_ip_1(pwm_io_ip_1),
    .io_ip_2(pwm_io_ip_2),
    .io_ip_3(pwm_io_ip_3),
    .io_gpio_0(pwm_io_gpio_0),
    .io_gpio_1(pwm_io_gpio_1),
    .io_gpio_2(pwm_io_gpio_2),
    .io_gpio_3(pwm_io_gpio_3)
  );
  assign io_interrupts_0_0 = pwm_io_ip_0;
  assign io_interrupts_0_1 = pwm_io_ip_1;
  assign io_interrupts_0_2 = pwm_io_ip_2;
  assign io_interrupts_0_3 = pwm_io_ip_3;
  assign io_in_0_a_ready = T_912_ready;
  assign io_in_0_b_valid = 1'h0;
  assign io_in_0_b_bits_opcode = GEN_96;
  assign io_in_0_b_bits_param = GEN_97;
  assign io_in_0_b_bits_size = GEN_98;
  assign io_in_0_b_bits_source = GEN_99;
  assign io_in_0_b_bits_address = GEN_100;
  assign io_in_0_b_bits_mask = GEN_101;
  assign io_in_0_b_bits_data = GEN_102;
  assign io_in_0_c_ready = 1'h1;
  assign io_in_0_d_valid = T_951_valid;
  assign io_in_0_d_bits_opcode = {{2'd0}, T_951_bits_read};
  assign io_in_0_d_bits_param = T_2604_param;
  assign io_in_0_d_bits_size = T_2604_size;
  assign io_in_0_d_bits_source = T_2604_source;
  assign io_in_0_d_bits_sink = T_2604_sink;
  assign io_in_0_d_bits_addr_lo = T_2604_addr_lo;
  assign io_in_0_d_bits_data = T_951_bits_data;
  assign io_in_0_d_bits_error = T_2604_error;
  assign io_in_0_e_ready = 1'h1;
  assign io_gpio_0 = pwm_io_gpio_0;
  assign io_gpio_1 = pwm_io_gpio_1;
  assign io_gpio_2 = pwm_io_gpio_2;
  assign io_gpio_3 = pwm_io_gpio_3;
  assign pwm_clock = clock;
  assign pwm_reset = reset;
  assign pwm_io_regs_cfg_write_valid = T_1313;
  assign pwm_io_regs_cfg_write_bits = T_987_bits_data;
  assign pwm_io_regs_countLo_write_valid = T_1473;
  assign pwm_io_regs_countLo_write_bits = T_987_bits_data;
  assign pwm_io_regs_countHi_write_valid = T_1553;
  assign pwm_io_regs_countHi_write_bits = T_987_bits_data;
  assign pwm_io_regs_s_write_valid = T_1673;
  assign pwm_io_regs_s_write_bits = T_1354;
  assign pwm_io_regs_cmp_0_write_valid = T_1633;
  assign pwm_io_regs_cmp_0_write_bits = T_1354;
  assign pwm_io_regs_cmp_1_write_valid = T_1433;
  assign pwm_io_regs_cmp_1_write_bits = T_1354;
  assign pwm_io_regs_cmp_2_write_valid = T_1353;
  assign pwm_io_regs_cmp_2_write_bits = T_1354;
  assign pwm_io_regs_cmp_3_write_valid = T_1593;
  assign pwm_io_regs_cmp_3_write_bits = T_1354;
  assign pwm_io_regs_feed_write_valid = T_1393;
  assign pwm_io_regs_feed_write_bits = T_987_bits_data;
  assign pwm_io_regs_key_write_valid = T_1513;
  assign pwm_io_regs_key_write_bits = T_987_bits_data;
  assign T_912_ready = T_2110;
  assign T_912_valid = io_in_0_a_valid;
  assign T_912_bits_read = T_929;
  assign T_912_bits_index = T_930[9:0];
  assign T_912_bits_data = io_in_0_a_bits_data;
  assign T_912_bits_mask = io_in_0_a_bits_mask;
  assign T_912_bits_extra = T_933;
  assign T_929 = io_in_0_a_bits_opcode == 3'h4;
  assign T_930 = io_in_0_a_bits_address[28:2];
  assign T_931 = io_in_0_a_bits_address[1:0];
  assign T_932 = {T_931,io_in_0_a_bits_source};
  assign T_933 = {T_932,io_in_0_a_bits_size};
  assign T_951_ready = io_in_0_d_ready;
  assign T_951_valid = T_2113;
  assign T_951_bits_read = T_987_bits_read;
  assign T_951_bits_data = T_2589;
  assign T_951_bits_extra = T_987_bits_extra;
  assign T_987_ready = T_2112;
  assign T_987_valid = T_2111;
  assign T_987_bits_read = T_912_bits_read;
  assign T_987_bits_index = T_912_bits_index;
  assign T_987_bits_data = T_912_bits_data;
  assign T_987_bits_mask = T_912_bits_mask;
  assign T_987_bits_extra = T_912_bits_extra;
  assign T_1040 = T_987_bits_index & 10'h3f0;
  assign T_1042 = T_1040 == 10'h0;
  assign T_1048 = T_987_bits_index ^ 10'ha;
  assign T_1049 = T_1048 & 10'h3f0;
  assign T_1051 = T_1049 == 10'h0;
  assign T_1057 = T_987_bits_index ^ 10'h6;
  assign T_1058 = T_1057 & 10'h3f0;
  assign T_1060 = T_1058 == 10'h0;
  assign T_1066 = T_987_bits_index ^ 10'h9;
  assign T_1067 = T_1066 & 10'h3f0;
  assign T_1069 = T_1067 == 10'h0;
  assign T_1075 = T_987_bits_index ^ 10'h2;
  assign T_1076 = T_1075 & 10'h3f0;
  assign T_1078 = T_1076 == 10'h0;
  assign T_1084 = T_987_bits_index ^ 10'h7;
  assign T_1085 = T_1084 & 10'h3f0;
  assign T_1087 = T_1085 == 10'h0;
  assign T_1093 = T_987_bits_index ^ 10'h3;
  assign T_1094 = T_1093 & 10'h3f0;
  assign T_1096 = T_1094 == 10'h0;
  assign T_1102 = T_987_bits_index ^ 10'hb;
  assign T_1103 = T_1102 & 10'h3f0;
  assign T_1105 = T_1103 == 10'h0;
  assign T_1111 = T_987_bits_index ^ 10'h8;
  assign T_1112 = T_1111 & 10'h3f0;
  assign T_1114 = T_1112 == 10'h0;
  assign T_1120 = T_987_bits_index ^ 10'h4;
  assign T_1121 = T_1120 & 10'h3f0;
  assign T_1123 = T_1121 == 10'h0;
  assign T_1131_0 = T_2153;
  assign T_1131_1 = T_2353;
  assign T_1131_2 = T_2273;
  assign T_1131_3 = T_2333;
  assign T_1131_4 = T_2193;
  assign T_1131_5 = T_2293;
  assign T_1131_6 = T_2213;
  assign T_1131_7 = T_2373;
  assign T_1131_8 = T_2313;
  assign T_1131_9 = T_2233;
  assign T_1136_0 = T_2159;
  assign T_1136_1 = T_2359;
  assign T_1136_2 = T_2279;
  assign T_1136_3 = T_2339;
  assign T_1136_4 = T_2199;
  assign T_1136_5 = T_2299;
  assign T_1136_6 = T_2219;
  assign T_1136_7 = T_2379;
  assign T_1136_8 = T_2319;
  assign T_1136_9 = T_2239;
  assign T_1141_0 = 1'h1;
  assign T_1141_1 = 1'h1;
  assign T_1141_2 = 1'h1;
  assign T_1141_3 = 1'h1;
  assign T_1141_4 = 1'h1;
  assign T_1141_5 = 1'h1;
  assign T_1141_6 = 1'h1;
  assign T_1141_7 = 1'h1;
  assign T_1141_8 = 1'h1;
  assign T_1141_9 = 1'h1;
  assign T_1146_0 = 1'h1;
  assign T_1146_1 = 1'h1;
  assign T_1146_2 = 1'h1;
  assign T_1146_3 = 1'h1;
  assign T_1146_4 = 1'h1;
  assign T_1146_5 = 1'h1;
  assign T_1146_6 = 1'h1;
  assign T_1146_7 = 1'h1;
  assign T_1146_8 = 1'h1;
  assign T_1146_9 = 1'h1;
  assign T_1151_0 = 1'h1;
  assign T_1151_1 = 1'h1;
  assign T_1151_2 = 1'h1;
  assign T_1151_3 = 1'h1;
  assign T_1151_4 = 1'h1;
  assign T_1151_5 = 1'h1;
  assign T_1151_6 = 1'h1;
  assign T_1151_7 = 1'h1;
  assign T_1151_8 = 1'h1;
  assign T_1151_9 = 1'h1;
  assign T_1156_0 = 1'h1;
  assign T_1156_1 = 1'h1;
  assign T_1156_2 = 1'h1;
  assign T_1156_3 = 1'h1;
  assign T_1156_4 = 1'h1;
  assign T_1156_5 = 1'h1;
  assign T_1156_6 = 1'h1;
  assign T_1156_7 = 1'h1;
  assign T_1156_8 = 1'h1;
  assign T_1156_9 = 1'h1;
  assign T_1161_0 = T_2163;
  assign T_1161_1 = T_2363;
  assign T_1161_2 = T_2283;
  assign T_1161_3 = T_2343;
  assign T_1161_4 = T_2203;
  assign T_1161_5 = T_2303;
  assign T_1161_6 = T_2223;
  assign T_1161_7 = T_2383;
  assign T_1161_8 = T_2323;
  assign T_1161_9 = T_2243;
  assign T_1166_0 = T_2169;
  assign T_1166_1 = T_2369;
  assign T_1166_2 = T_2289;
  assign T_1166_3 = T_2349;
  assign T_1166_4 = T_2209;
  assign T_1166_5 = T_2309;
  assign T_1166_6 = T_2229;
  assign T_1166_7 = T_2389;
  assign T_1166_8 = T_2329;
  assign T_1166_9 = T_2249;
  assign T_1248 = T_987_bits_mask[0];
  assign T_1249 = T_987_bits_mask[1];
  assign T_1250 = T_987_bits_mask[2];
  assign T_1251 = T_987_bits_mask[3];
  assign T_1255 = T_1248 ? 8'hff : 8'h0;
  assign T_1259 = T_1249 ? 8'hff : 8'h0;
  assign T_1263 = T_1250 ? 8'hff : 8'h0;
  assign T_1267 = T_1251 ? 8'hff : 8'h0;
  assign T_1268 = {T_1259,T_1255};
  assign T_1269 = {T_1267,T_1263};
  assign T_1270 = {T_1269,T_1268};
  assign T_1298 = ~ T_1270;
  assign T_1300 = T_1298 == 32'h0;
  assign T_1313 = T_1166_0 & T_1300;
  assign T_1329 = pwm_io_regs_cfg_read;
  assign T_1334 = T_1270[7:0];
  assign T_1338 = ~ T_1334;
  assign T_1340 = T_1338 == 8'h0;
  assign T_1353 = T_1166_1 & T_1340;
  assign T_1354 = T_987_bits_data[7:0];
  assign T_1369 = pwm_io_regs_cmp_2_read;
  assign T_1393 = T_1166_2 & T_1300;
  assign T_1409 = pwm_io_regs_feed_read;
  assign T_1433 = T_1166_3 & T_1340;
  assign T_1449 = pwm_io_regs_cmp_1_read;
  assign T_1473 = T_1166_4 & T_1300;
  assign T_1489 = pwm_io_regs_countLo_read;
  assign T_1513 = T_1166_5 & T_1300;
  assign T_1529 = pwm_io_regs_key_read;
  assign T_1553 = T_1166_6 & T_1300;
  assign T_1569 = pwm_io_regs_countHi_read;
  assign T_1593 = T_1166_7 & T_1340;
  assign T_1609 = pwm_io_regs_cmp_3_read;
  assign T_1633 = T_1166_8 & T_1340;
  assign T_1649 = pwm_io_regs_cmp_0_read;
  assign T_1673 = T_1166_9 & T_1340;
  assign T_1689 = pwm_io_regs_s_read;
  assign T_1695 = T_1042 == 1'h0;
  assign T_1697 = T_1695 | T_1141_0;
  assign T_1702 = T_1078 == 1'h0;
  assign T_1704 = T_1702 | T_1141_4;
  assign T_1706 = T_1096 == 1'h0;
  assign T_1708 = T_1706 | T_1141_6;
  assign T_1710 = T_1123 == 1'h0;
  assign T_1712 = T_1710 | T_1141_9;
  assign T_1717 = T_1060 == 1'h0;
  assign T_1719 = T_1717 | T_1141_2;
  assign T_1721 = T_1087 == 1'h0;
  assign T_1723 = T_1721 | T_1141_5;
  assign T_1725 = T_1114 == 1'h0;
  assign T_1727 = T_1725 | T_1141_8;
  assign T_1729 = T_1069 == 1'h0;
  assign T_1731 = T_1729 | T_1141_3;
  assign T_1733 = T_1051 == 1'h0;
  assign T_1735 = T_1733 | T_1141_1;
  assign T_1737 = T_1105 == 1'h0;
  assign T_1739 = T_1737 | T_1141_7;
  assign T_1771_0 = T_1697;
  assign T_1771_1 = 1'h1;
  assign T_1771_2 = T_1704;
  assign T_1771_3 = T_1708;
  assign T_1771_4 = T_1712;
  assign T_1771_5 = 1'h1;
  assign T_1771_6 = T_1719;
  assign T_1771_7 = T_1723;
  assign T_1771_8 = T_1727;
  assign T_1771_9 = T_1731;
  assign T_1771_10 = T_1735;
  assign T_1771_11 = T_1739;
  assign T_1771_12 = 1'h1;
  assign T_1771_13 = 1'h1;
  assign T_1771_14 = 1'h1;
  assign T_1771_15 = 1'h1;
  assign T_1793 = T_1695 | T_1146_0;
  assign T_1800 = T_1702 | T_1146_4;
  assign T_1804 = T_1706 | T_1146_6;
  assign T_1808 = T_1710 | T_1146_9;
  assign T_1815 = T_1717 | T_1146_2;
  assign T_1819 = T_1721 | T_1146_5;
  assign T_1823 = T_1725 | T_1146_8;
  assign T_1827 = T_1729 | T_1146_3;
  assign T_1831 = T_1733 | T_1146_1;
  assign T_1835 = T_1737 | T_1146_7;
  assign T_1867_0 = T_1793;
  assign T_1867_1 = 1'h1;
  assign T_1867_2 = T_1800;
  assign T_1867_3 = T_1804;
  assign T_1867_4 = T_1808;
  assign T_1867_5 = 1'h1;
  assign T_1867_6 = T_1815;
  assign T_1867_7 = T_1819;
  assign T_1867_8 = T_1823;
  assign T_1867_9 = T_1827;
  assign T_1867_10 = T_1831;
  assign T_1867_11 = T_1835;
  assign T_1867_12 = 1'h1;
  assign T_1867_13 = 1'h1;
  assign T_1867_14 = 1'h1;
  assign T_1867_15 = 1'h1;
  assign T_1889 = T_1695 | T_1151_0;
  assign T_1896 = T_1702 | T_1151_4;
  assign T_1900 = T_1706 | T_1151_6;
  assign T_1904 = T_1710 | T_1151_9;
  assign T_1911 = T_1717 | T_1151_2;
  assign T_1915 = T_1721 | T_1151_5;
  assign T_1919 = T_1725 | T_1151_8;
  assign T_1923 = T_1729 | T_1151_3;
  assign T_1927 = T_1733 | T_1151_1;
  assign T_1931 = T_1737 | T_1151_7;
  assign T_1963_0 = T_1889;
  assign T_1963_1 = 1'h1;
  assign T_1963_2 = T_1896;
  assign T_1963_3 = T_1900;
  assign T_1963_4 = T_1904;
  assign T_1963_5 = 1'h1;
  assign T_1963_6 = T_1911;
  assign T_1963_7 = T_1915;
  assign T_1963_8 = T_1919;
  assign T_1963_9 = T_1923;
  assign T_1963_10 = T_1927;
  assign T_1963_11 = T_1931;
  assign T_1963_12 = 1'h1;
  assign T_1963_13 = 1'h1;
  assign T_1963_14 = 1'h1;
  assign T_1963_15 = 1'h1;
  assign T_1985 = T_1695 | T_1156_0;
  assign T_1992 = T_1702 | T_1156_4;
  assign T_1996 = T_1706 | T_1156_6;
  assign T_2000 = T_1710 | T_1156_9;
  assign T_2007 = T_1717 | T_1156_2;
  assign T_2011 = T_1721 | T_1156_5;
  assign T_2015 = T_1725 | T_1156_8;
  assign T_2019 = T_1729 | T_1156_3;
  assign T_2023 = T_1733 | T_1156_1;
  assign T_2027 = T_1737 | T_1156_7;
  assign T_2059_0 = T_1985;
  assign T_2059_1 = 1'h1;
  assign T_2059_2 = T_1992;
  assign T_2059_3 = T_1996;
  assign T_2059_4 = T_2000;
  assign T_2059_5 = 1'h1;
  assign T_2059_6 = T_2007;
  assign T_2059_7 = T_2011;
  assign T_2059_8 = T_2015;
  assign T_2059_9 = T_2019;
  assign T_2059_10 = T_2023;
  assign T_2059_11 = T_2027;
  assign T_2059_12 = 1'h1;
  assign T_2059_13 = 1'h1;
  assign T_2059_14 = 1'h1;
  assign T_2059_15 = 1'h1;
  assign T_2078 = T_987_bits_index[0];
  assign T_2079 = T_987_bits_index[1];
  assign T_2080 = T_987_bits_index[2];
  assign T_2081 = T_987_bits_index[3];
  assign T_2088 = {T_2079,T_2078};
  assign T_2089 = {T_2081,T_2080};
  assign T_2090 = {T_2089,T_2088};
  assign GEN_0 = GEN_20;
  assign GEN_6 = 4'h1 == T_2090 ? T_1771_1 : T_1771_0;
  assign GEN_7 = 4'h2 == T_2090 ? T_1771_2 : GEN_6;
  assign GEN_8 = 4'h3 == T_2090 ? T_1771_3 : GEN_7;
  assign GEN_9 = 4'h4 == T_2090 ? T_1771_4 : GEN_8;
  assign GEN_10 = 4'h5 == T_2090 ? T_1771_5 : GEN_9;
  assign GEN_11 = 4'h6 == T_2090 ? T_1771_6 : GEN_10;
  assign GEN_12 = 4'h7 == T_2090 ? T_1771_7 : GEN_11;
  assign GEN_13 = 4'h8 == T_2090 ? T_1771_8 : GEN_12;
  assign GEN_14 = 4'h9 == T_2090 ? T_1771_9 : GEN_13;
  assign GEN_15 = 4'ha == T_2090 ? T_1771_10 : GEN_14;
  assign GEN_16 = 4'hb == T_2090 ? T_1771_11 : GEN_15;
  assign GEN_17 = 4'hc == T_2090 ? T_1771_12 : GEN_16;
  assign GEN_18 = 4'hd == T_2090 ? T_1771_13 : GEN_17;
  assign GEN_19 = 4'he == T_2090 ? T_1771_14 : GEN_18;
  assign GEN_20 = 4'hf == T_2090 ? T_1771_15 : GEN_19;
  assign GEN_1 = GEN_35;
  assign GEN_21 = 4'h1 == T_2090 ? T_1867_1 : T_1867_0;
  assign GEN_22 = 4'h2 == T_2090 ? T_1867_2 : GEN_21;
  assign GEN_23 = 4'h3 == T_2090 ? T_1867_3 : GEN_22;
  assign GEN_24 = 4'h4 == T_2090 ? T_1867_4 : GEN_23;
  assign GEN_25 = 4'h5 == T_2090 ? T_1867_5 : GEN_24;
  assign GEN_26 = 4'h6 == T_2090 ? T_1867_6 : GEN_25;
  assign GEN_27 = 4'h7 == T_2090 ? T_1867_7 : GEN_26;
  assign GEN_28 = 4'h8 == T_2090 ? T_1867_8 : GEN_27;
  assign GEN_29 = 4'h9 == T_2090 ? T_1867_9 : GEN_28;
  assign GEN_30 = 4'ha == T_2090 ? T_1867_10 : GEN_29;
  assign GEN_31 = 4'hb == T_2090 ? T_1867_11 : GEN_30;
  assign GEN_32 = 4'hc == T_2090 ? T_1867_12 : GEN_31;
  assign GEN_33 = 4'hd == T_2090 ? T_1867_13 : GEN_32;
  assign GEN_34 = 4'he == T_2090 ? T_1867_14 : GEN_33;
  assign GEN_35 = 4'hf == T_2090 ? T_1867_15 : GEN_34;
  assign T_2106 = T_987_bits_read ? GEN_0 : GEN_1;
  assign GEN_2 = GEN_50;
  assign GEN_36 = 4'h1 == T_2090 ? T_1963_1 : T_1963_0;
  assign GEN_37 = 4'h2 == T_2090 ? T_1963_2 : GEN_36;
  assign GEN_38 = 4'h3 == T_2090 ? T_1963_3 : GEN_37;
  assign GEN_39 = 4'h4 == T_2090 ? T_1963_4 : GEN_38;
  assign GEN_40 = 4'h5 == T_2090 ? T_1963_5 : GEN_39;
  assign GEN_41 = 4'h6 == T_2090 ? T_1963_6 : GEN_40;
  assign GEN_42 = 4'h7 == T_2090 ? T_1963_7 : GEN_41;
  assign GEN_43 = 4'h8 == T_2090 ? T_1963_8 : GEN_42;
  assign GEN_44 = 4'h9 == T_2090 ? T_1963_9 : GEN_43;
  assign GEN_45 = 4'ha == T_2090 ? T_1963_10 : GEN_44;
  assign GEN_46 = 4'hb == T_2090 ? T_1963_11 : GEN_45;
  assign GEN_47 = 4'hc == T_2090 ? T_1963_12 : GEN_46;
  assign GEN_48 = 4'hd == T_2090 ? T_1963_13 : GEN_47;
  assign GEN_49 = 4'he == T_2090 ? T_1963_14 : GEN_48;
  assign GEN_50 = 4'hf == T_2090 ? T_1963_15 : GEN_49;
  assign GEN_3 = GEN_65;
  assign GEN_51 = 4'h1 == T_2090 ? T_2059_1 : T_2059_0;
  assign GEN_52 = 4'h2 == T_2090 ? T_2059_2 : GEN_51;
  assign GEN_53 = 4'h3 == T_2090 ? T_2059_3 : GEN_52;
  assign GEN_54 = 4'h4 == T_2090 ? T_2059_4 : GEN_53;
  assign GEN_55 = 4'h5 == T_2090 ? T_2059_5 : GEN_54;
  assign GEN_56 = 4'h6 == T_2090 ? T_2059_6 : GEN_55;
  assign GEN_57 = 4'h7 == T_2090 ? T_2059_7 : GEN_56;
  assign GEN_58 = 4'h8 == T_2090 ? T_2059_8 : GEN_57;
  assign GEN_59 = 4'h9 == T_2090 ? T_2059_9 : GEN_58;
  assign GEN_60 = 4'ha == T_2090 ? T_2059_10 : GEN_59;
  assign GEN_61 = 4'hb == T_2090 ? T_2059_11 : GEN_60;
  assign GEN_62 = 4'hc == T_2090 ? T_2059_12 : GEN_61;
  assign GEN_63 = 4'hd == T_2090 ? T_2059_13 : GEN_62;
  assign GEN_64 = 4'he == T_2090 ? T_2059_14 : GEN_63;
  assign GEN_65 = 4'hf == T_2090 ? T_2059_15 : GEN_64;
  assign T_2109 = T_987_bits_read ? GEN_2 : GEN_3;
  assign T_2110 = T_987_ready & T_2106;
  assign T_2111 = T_912_valid & T_2106;
  assign T_2112 = T_951_ready & T_2109;
  assign T_2113 = T_987_valid & T_2109;
  assign T_2115 = 16'h1 << T_2090;
  assign T_2116 = {1'h1,T_1042};
  assign T_2117 = {T_1096,T_1078};
  assign T_2118 = {T_2117,T_2116};
  assign T_2119 = {1'h1,T_1123};
  assign T_2120 = {T_1087,T_1060};
  assign T_2121 = {T_2120,T_2119};
  assign T_2122 = {T_2121,T_2118};
  assign T_2123 = {T_1069,T_1114};
  assign T_2124 = {T_1105,T_1051};
  assign T_2125 = {T_2124,T_2123};
  assign T_2129 = {4'hf,T_2125};
  assign T_2130 = {T_2129,T_2122};
  assign T_2131 = T_2115 & T_2130;
  assign T_2150 = T_912_valid & T_987_ready;
  assign T_2151 = T_2150 & T_987_bits_read;
  assign T_2152 = T_2131[0];
  assign T_2153 = T_2151 & T_2152;
  assign T_2156 = T_987_bits_read == 1'h0;
  assign T_2157 = T_2150 & T_2156;
  assign T_2159 = T_2157 & T_2152;
  assign T_2160 = T_987_valid & T_951_ready;
  assign T_2161 = T_2160 & T_987_bits_read;
  assign T_2163 = T_2161 & T_2152;
  assign T_2167 = T_2160 & T_2156;
  assign T_2169 = T_2167 & T_2152;
  assign T_2192 = T_2131[2];
  assign T_2193 = T_2151 & T_2192;
  assign T_2199 = T_2157 & T_2192;
  assign T_2203 = T_2161 & T_2192;
  assign T_2209 = T_2167 & T_2192;
  assign T_2212 = T_2131[3];
  assign T_2213 = T_2151 & T_2212;
  assign T_2219 = T_2157 & T_2212;
  assign T_2223 = T_2161 & T_2212;
  assign T_2229 = T_2167 & T_2212;
  assign T_2232 = T_2131[4];
  assign T_2233 = T_2151 & T_2232;
  assign T_2239 = T_2157 & T_2232;
  assign T_2243 = T_2161 & T_2232;
  assign T_2249 = T_2167 & T_2232;
  assign T_2272 = T_2131[6];
  assign T_2273 = T_2151 & T_2272;
  assign T_2279 = T_2157 & T_2272;
  assign T_2283 = T_2161 & T_2272;
  assign T_2289 = T_2167 & T_2272;
  assign T_2292 = T_2131[7];
  assign T_2293 = T_2151 & T_2292;
  assign T_2299 = T_2157 & T_2292;
  assign T_2303 = T_2161 & T_2292;
  assign T_2309 = T_2167 & T_2292;
  assign T_2312 = T_2131[8];
  assign T_2313 = T_2151 & T_2312;
  assign T_2319 = T_2157 & T_2312;
  assign T_2323 = T_2161 & T_2312;
  assign T_2329 = T_2167 & T_2312;
  assign T_2332 = T_2131[9];
  assign T_2333 = T_2151 & T_2332;
  assign T_2339 = T_2157 & T_2332;
  assign T_2343 = T_2161 & T_2332;
  assign T_2349 = T_2167 & T_2332;
  assign T_2352 = T_2131[10];
  assign T_2353 = T_2151 & T_2352;
  assign T_2359 = T_2157 & T_2352;
  assign T_2363 = T_2161 & T_2352;
  assign T_2369 = T_2167 & T_2352;
  assign T_2372 = T_2131[11];
  assign T_2373 = T_2151 & T_2372;
  assign T_2379 = T_2157 & T_2372;
  assign T_2383 = T_2161 & T_2372;
  assign T_2389 = T_2167 & T_2372;
  assign T_2529_0 = T_1042;
  assign T_2529_1 = 1'h1;
  assign T_2529_2 = T_1078;
  assign T_2529_3 = T_1096;
  assign T_2529_4 = T_1123;
  assign T_2529_5 = 1'h1;
  assign T_2529_6 = T_1060;
  assign T_2529_7 = T_1087;
  assign T_2529_8 = T_1114;
  assign T_2529_9 = T_1069;
  assign T_2529_10 = T_1051;
  assign T_2529_11 = T_1105;
  assign T_2529_12 = 1'h1;
  assign T_2529_13 = 1'h1;
  assign T_2529_14 = 1'h1;
  assign T_2529_15 = 1'h1;
  assign T_2568_0 = T_1329;
  assign T_2568_1 = 32'h0;
  assign T_2568_2 = T_1489;
  assign T_2568_3 = T_1569;
  assign T_2568_4 = {{24'd0}, T_1689};
  assign T_2568_5 = 32'h0;
  assign T_2568_6 = T_1409;
  assign T_2568_7 = T_1529;
  assign T_2568_8 = {{24'd0}, T_1649};
  assign T_2568_9 = {{24'd0}, T_1449};
  assign T_2568_10 = {{24'd0}, T_1369};
  assign T_2568_11 = {{24'd0}, T_1609};
  assign T_2568_12 = 32'h0;
  assign T_2568_13 = 32'h0;
  assign T_2568_14 = 32'h0;
  assign T_2568_15 = 32'h0;
  assign GEN_4 = GEN_80;
  assign GEN_66 = 4'h1 == T_2090 ? T_2529_1 : T_2529_0;
  assign GEN_67 = 4'h2 == T_2090 ? T_2529_2 : GEN_66;
  assign GEN_68 = 4'h3 == T_2090 ? T_2529_3 : GEN_67;
  assign GEN_69 = 4'h4 == T_2090 ? T_2529_4 : GEN_68;
  assign GEN_70 = 4'h5 == T_2090 ? T_2529_5 : GEN_69;
  assign GEN_71 = 4'h6 == T_2090 ? T_2529_6 : GEN_70;
  assign GEN_72 = 4'h7 == T_2090 ? T_2529_7 : GEN_71;
  assign GEN_73 = 4'h8 == T_2090 ? T_2529_8 : GEN_72;
  assign GEN_74 = 4'h9 == T_2090 ? T_2529_9 : GEN_73;
  assign GEN_75 = 4'ha == T_2090 ? T_2529_10 : GEN_74;
  assign GEN_76 = 4'hb == T_2090 ? T_2529_11 : GEN_75;
  assign GEN_77 = 4'hc == T_2090 ? T_2529_12 : GEN_76;
  assign GEN_78 = 4'hd == T_2090 ? T_2529_13 : GEN_77;
  assign GEN_79 = 4'he == T_2090 ? T_2529_14 : GEN_78;
  assign GEN_80 = 4'hf == T_2090 ? T_2529_15 : GEN_79;
  assign GEN_5 = GEN_95;
  assign GEN_81 = 4'h1 == T_2090 ? T_2568_1 : T_2568_0;
  assign GEN_82 = 4'h2 == T_2090 ? T_2568_2 : GEN_81;
  assign GEN_83 = 4'h3 == T_2090 ? T_2568_3 : GEN_82;
  assign GEN_84 = 4'h4 == T_2090 ? T_2568_4 : GEN_83;
  assign GEN_85 = 4'h5 == T_2090 ? T_2568_5 : GEN_84;
  assign GEN_86 = 4'h6 == T_2090 ? T_2568_6 : GEN_85;
  assign GEN_87 = 4'h7 == T_2090 ? T_2568_7 : GEN_86;
  assign GEN_88 = 4'h8 == T_2090 ? T_2568_8 : GEN_87;
  assign GEN_89 = 4'h9 == T_2090 ? T_2568_9 : GEN_88;
  assign GEN_90 = 4'ha == T_2090 ? T_2568_10 : GEN_89;
  assign GEN_91 = 4'hb == T_2090 ? T_2568_11 : GEN_90;
  assign GEN_92 = 4'hc == T_2090 ? T_2568_12 : GEN_91;
  assign GEN_93 = 4'hd == T_2090 ? T_2568_13 : GEN_92;
  assign GEN_94 = 4'he == T_2090 ? T_2568_14 : GEN_93;
  assign GEN_95 = 4'hf == T_2090 ? T_2568_15 : GEN_94;
  assign T_2589 = GEN_4 ? GEN_5 : 32'h0;
  assign T_2590 = T_951_bits_extra[9:8];
  assign T_2592 = T_951_bits_extra[7:3];
  assign T_2593 = T_951_bits_extra[2:0];
  assign T_2604_opcode = 3'h0;
  assign T_2604_param = 2'h0;
  assign T_2604_size = T_2593;
  assign T_2604_source = T_2592;
  assign T_2604_sink = 1'h0;
  assign T_2604_addr_lo = T_2590;
  assign T_2604_data = 32'h0;
  assign T_2604_error = 1'h0;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_103 = {1{$random}};
  GEN_96 = GEN_103[2:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_104 = {1{$random}};
  GEN_97 = GEN_104[1:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_105 = {1{$random}};
  GEN_98 = GEN_105[2:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_106 = {1{$random}};
  GEN_99 = GEN_106[4:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_107 = {1{$random}};
  GEN_100 = GEN_107[28:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_108 = {1{$random}};
  GEN_101 = GEN_108[3:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_109 = {1{$random}};
  GEN_102 = GEN_109[31:0];
  `endif
  end
`endif
endmodule
