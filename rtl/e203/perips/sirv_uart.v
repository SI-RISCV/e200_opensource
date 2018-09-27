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
                                                                         
                                                                         
                                                                         

module sirv_uart(
  input   clock,
  input   reset,
  output  io_interrupts_0_0,
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
  output  io_port_txd,
  input   io_port_rxd
);
  wire  txm_clock;
  wire  txm_reset;
  wire  txm_io_en;
  wire  txm_io_in_ready;
  wire  txm_io_in_valid;
  wire [7:0] txm_io_in_bits;
  wire  txm_io_out;
  wire [15:0] txm_io_div;
  wire  txm_io_nstop;
  wire  txq_clock;
  wire  txq_reset;
  wire  txq_io_enq_ready;
  wire  txq_io_enq_valid;
  wire [7:0] txq_io_enq_bits;
  wire  txq_io_deq_ready;
  wire  txq_io_deq_valid;
  wire [7:0] txq_io_deq_bits;
  wire [3:0] txq_io_count;
  wire  rxm_clock;
  wire  rxm_reset;
  wire  rxm_io_en;
  wire  rxm_io_in;
  wire  rxm_io_out_valid;
  wire [7:0] rxm_io_out_bits;
  wire [15:0] rxm_io_div;
  wire  rxq_clock;
  wire  rxq_reset;
  wire  rxq_io_enq_ready;
  wire  rxq_io_enq_valid;
  wire [7:0] rxq_io_enq_bits;
  wire  rxq_io_deq_ready;
  wire  rxq_io_deq_valid;
  wire [7:0] rxq_io_deq_bits;
  wire [3:0] rxq_io_count;
  reg [15:0] div;
  reg [31:0] GEN_76;
  reg  txen;
  reg [31:0] GEN_77;
  reg  rxen;
  reg [31:0] GEN_78;
  reg [3:0] txwm;
  reg [31:0] GEN_79;
  reg [3:0] rxwm;
  reg [31:0] GEN_80;
  reg  nstop;
  reg [31:0] GEN_81;
  wire  T_902_rxwm;
  wire  T_902_txwm;
  wire [1:0] T_906;
  wire  T_907;
  wire  T_908;
  reg  ie_rxwm;
  reg [31:0] GEN_82;
  reg  ie_txwm;
  reg [31:0] GEN_83;
  wire  ip_rxwm;
  wire  ip_txwm;
  wire  T_916;
  wire  T_917;
  wire  T_918;
  wire  T_919;
  wire  T_920;
  wire  T_924;
  wire  T_927;
  wire  T_951_ready;
  wire  T_951_valid;
  wire  T_951_bits_read;
  wire [9:0] T_951_bits_index;
  wire [31:0] T_951_bits_data;
  wire [3:0] T_951_bits_mask;
  wire [9:0] T_951_bits_extra;
  wire  T_968;
  wire [26:0] T_969;
  wire [1:0] T_970;
  wire [6:0] T_971;
  wire [9:0] T_972;
  wire  T_990_ready;
  wire  T_990_valid;
  wire  T_990_bits_read;
  wire [31:0] T_990_bits_data;
  wire [9:0] T_990_bits_extra;
  wire  T_1026_ready;
  wire  T_1026_valid;
  wire  T_1026_bits_read;
  wire [9:0] T_1026_bits_index;
  wire [31:0] T_1026_bits_data;
  wire [3:0] T_1026_bits_mask;
  wire [9:0] T_1026_bits_extra;
  wire [9:0] T_1063;
  wire  T_1065;
  wire [9:0] T_1071;
  wire [9:0] T_1072;
  wire  T_1074;
  wire [9:0] T_1080;
  wire [9:0] T_1081;
  wire  T_1083;
  wire [9:0] T_1089;
  wire [9:0] T_1090;
  wire  T_1092;
  wire [9:0] T_1098;
  wire [9:0] T_1099;
  wire  T_1101;
  wire [9:0] T_1107;
  wire [9:0] T_1108;
  wire  T_1110;
  wire [9:0] T_1116;
  wire [9:0] T_1117;
  wire  T_1119;
  wire  T_1127_0;
  wire  T_1127_1;
  wire  T_1127_2;
  wire  T_1127_3;
  wire  T_1127_4;
  wire  T_1127_5;
  wire  T_1127_6;
  wire  T_1127_7;
  wire  T_1127_8;
  wire  T_1127_9;
  wire  T_1127_10;
  wire  T_1127_11;
  wire  T_1127_12;
  wire  T_1127_13;
  wire  T_1127_14;
  wire  T_1127_15;
  wire  T_1132_0;
  wire  T_1132_1;
  wire  T_1132_2;
  wire  T_1132_3;
  wire  T_1132_4;
  wire  T_1132_5;
  wire  T_1132_6;
  wire  T_1132_7;
  wire  T_1132_8;
  wire  T_1132_9;
  wire  T_1132_10;
  wire  T_1132_11;
  wire  T_1132_12;
  wire  T_1132_13;
  wire  T_1132_14;
  wire  T_1132_15;
  wire  T_1137_0;
  wire  T_1137_1;
  wire  T_1137_2;
  wire  T_1137_3;
  wire  T_1137_4;
  wire  T_1137_5;
  wire  T_1137_6;
  wire  T_1137_7;
  wire  T_1137_8;
  wire  T_1137_9;
  wire  T_1137_10;
  wire  T_1137_11;
  wire  T_1137_12;
  wire  T_1137_13;
  wire  T_1137_14;
  wire  T_1137_15;
  wire  T_1142_0;
  wire  T_1142_1;
  wire  T_1142_2;
  wire  T_1142_3;
  wire  T_1142_4;
  wire  T_1142_5;
  wire  T_1142_6;
  wire  T_1142_7;
  wire  T_1142_8;
  wire  T_1142_9;
  wire  T_1142_10;
  wire  T_1142_11;
  wire  T_1142_12;
  wire  T_1142_13;
  wire  T_1142_14;
  wire  T_1142_15;
  wire  T_1147_0;
  wire  T_1147_1;
  wire  T_1147_2;
  wire  T_1147_3;
  wire  T_1147_4;
  wire  T_1147_5;
  wire  T_1147_6;
  wire  T_1147_7;
  wire  T_1147_8;
  wire  T_1147_9;
  wire  T_1147_10;
  wire  T_1147_11;
  wire  T_1147_12;
  wire  T_1147_13;
  wire  T_1147_14;
  wire  T_1147_15;
  wire  T_1152_0;
  wire  T_1152_1;
  wire  T_1152_2;
  wire  T_1152_3;
  wire  T_1152_4;
  wire  T_1152_5;
  wire  T_1152_6;
  wire  T_1152_7;
  wire  T_1152_8;
  wire  T_1152_9;
  wire  T_1152_10;
  wire  T_1152_11;
  wire  T_1152_12;
  wire  T_1152_13;
  wire  T_1152_14;
  wire  T_1152_15;
  wire  T_1157_0;
  wire  T_1157_1;
  wire  T_1157_2;
  wire  T_1157_3;
  wire  T_1157_4;
  wire  T_1157_5;
  wire  T_1157_6;
  wire  T_1157_7;
  wire  T_1157_8;
  wire  T_1157_9;
  wire  T_1157_10;
  wire  T_1157_11;
  wire  T_1157_12;
  wire  T_1157_13;
  wire  T_1157_14;
  wire  T_1157_15;
  wire  T_1162_0;
  wire  T_1162_1;
  wire  T_1162_2;
  wire  T_1162_3;
  wire  T_1162_4;
  wire  T_1162_5;
  wire  T_1162_6;
  wire  T_1162_7;
  wire  T_1162_8;
  wire  T_1162_9;
  wire  T_1162_10;
  wire  T_1162_11;
  wire  T_1162_12;
  wire  T_1162_13;
  wire  T_1162_14;
  wire  T_1162_15;
  wire  T_1204;
  wire  T_1205;
  wire  T_1206;
  wire  T_1207;
  wire [7:0] T_1211;
  wire [7:0] T_1215;
  wire [7:0] T_1219;
  wire [7:0] T_1223;
  wire [15:0] T_1224;
  wire [15:0] T_1225;
  wire [31:0] T_1226;
  wire [7:0] T_1250;
  wire  T_1252;
  wire [7:0] T_1254;
  wire  T_1256;
  wire  T_1269;
  wire [7:0] T_1270;
  wire [31:0] GEN_56;
  wire [31:0] T_1365;
  wire  T_1370;
  wire  T_1374;
  wire  T_1376;
  wire  T_1390;
  wire  T_1410;
  wire  T_1414;
  wire  T_1416;
  wire  T_1430;
  wire [1:0] GEN_57;
  wire [1:0] T_1445;
  wire [1:0] GEN_58;
  wire [1:0] T_1449;
  wire  T_1465;
  wire [7:0] T_1485;
  wire [30:0] T_1529;
  wire [31:0] GEN_59;
  wire [31:0] T_1565;
  wire [31:0] GEN_60;
  wire [31:0] T_1569;
  wire [15:0] T_1570;
  wire [15:0] T_1574;
  wire  T_1576;
  wire  T_1589;
  wire [15:0] T_1590;
  wire [15:0] GEN_6;
  wire  T_1629;
  wire  GEN_7;
  wire  T_1669;
  wire  GEN_8;
  wire [1:0] GEN_61;
  wire [1:0] T_1685;
  wire [1:0] GEN_62;
  wire [1:0] T_1689;
  wire [3:0] T_1690;
  wire [3:0] T_1694;
  wire  T_1696;
  wire  T_1709;
  wire [3:0] T_1710;
  wire [3:0] GEN_9;
  wire [19:0] GEN_63;
  wire [19:0] T_1725;
  wire [19:0] GEN_64;
  wire [19:0] T_1729;
  wire  T_1749;
  wire  GEN_10;
  wire  T_1789;
  wire [3:0] GEN_11;
  wire [19:0] GEN_65;
  wire [19:0] T_1805;
  wire [19:0] GEN_66;
  wire [19:0] T_1809;
  wire  T_1829;
  wire  GEN_12;
  wire  T_1869;
  wire  GEN_13;
  wire [1:0] GEN_67;
  wire [1:0] T_1885;
  wire [1:0] GEN_68;
  wire [1:0] T_1889;
  wire  T_1891;
  wire  T_1892;
  wire  T_1893;
  wire  T_1895;
  wire  T_1897;
  wire  T_1898;
  wire  T_1899;
  wire  T_1901;
  wire  T_1903;
  wire  T_1904;
  wire  T_1905;
  wire  T_1907;
  wire  T_1909;
  wire  T_1910;
  wire  T_1912;
  wire  T_1914;
  wire  T_1915;
  wire  T_1917;
  wire  T_1919;
  wire  T_1920;
  wire  T_1922;
  wire  T_1924;
  wire  T_1926;
  wire  T_1941_0;
  wire  T_1941_1;
  wire  T_1941_2;
  wire  T_1941_3;
  wire  T_1941_4;
  wire  T_1941_5;
  wire  T_1941_6;
  wire  T_1941_7;
  wire  T_1954;
  wire  T_1955;
  wire  T_1957;
  wire  T_1960;
  wire  T_1961;
  wire  T_1963;
  wire  T_1966;
  wire  T_1967;
  wire  T_1969;
  wire  T_1972;
  wire  T_1974;
  wire  T_1977;
  wire  T_1979;
  wire  T_1982;
  wire  T_1984;
  wire  T_1988;
  wire  T_2003_0;
  wire  T_2003_1;
  wire  T_2003_2;
  wire  T_2003_3;
  wire  T_2003_4;
  wire  T_2003_5;
  wire  T_2003_6;
  wire  T_2003_7;
  wire  T_2016;
  wire  T_2017;
  wire  T_2019;
  wire  T_2022;
  wire  T_2023;
  wire  T_2025;
  wire  T_2028;
  wire  T_2029;
  wire  T_2031;
  wire  T_2034;
  wire  T_2036;
  wire  T_2039;
  wire  T_2041;
  wire  T_2044;
  wire  T_2046;
  wire  T_2050;
  wire  T_2065_0;
  wire  T_2065_1;
  wire  T_2065_2;
  wire  T_2065_3;
  wire  T_2065_4;
  wire  T_2065_5;
  wire  T_2065_6;
  wire  T_2065_7;
  wire  T_2078;
  wire  T_2079;
  wire  T_2081;
  wire  T_2084;
  wire  T_2085;
  wire  T_2087;
  wire  T_2090;
  wire  T_2091;
  wire  T_2093;
  wire  T_2096;
  wire  T_2098;
  wire  T_2101;
  wire  T_2103;
  wire  T_2106;
  wire  T_2108;
  wire  T_2112;
  wire  T_2127_0;
  wire  T_2127_1;
  wire  T_2127_2;
  wire  T_2127_3;
  wire  T_2127_4;
  wire  T_2127_5;
  wire  T_2127_6;
  wire  T_2127_7;
  wire  T_2138;
  wire  T_2139;
  wire  T_2140;
  wire [1:0] T_2148;
  wire [2:0] T_2149;
  wire  GEN_0;
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
  wire  T_2164;
  wire  GEN_2;
  wire  GEN_28;
  wire  GEN_29;
  wire  GEN_30;
  wire  GEN_31;
  wire  GEN_32;
  wire  GEN_33;
  wire  GEN_34;
  wire  GEN_3;
  wire  GEN_35;
  wire  GEN_36;
  wire  GEN_37;
  wire  GEN_38;
  wire  GEN_39;
  wire  GEN_40;
  wire  GEN_41;
  wire  T_2167;
  wire  T_2168;
  wire  T_2169;
  wire  T_2170;
  wire  T_2171;
  wire [7:0] T_2173;
  wire [1:0] T_2174;
  wire [1:0] T_2175;
  wire [3:0] T_2176;
  wire [1:0] T_2177;
  wire [1:0] T_2178;
  wire [3:0] T_2179;
  wire [7:0] T_2180;
  wire [7:0] T_2181;
  wire  T_2192;
  wire  T_2193;
  wire  T_2194;
  wire  T_2195;
  wire  T_2198;
  wire  T_2199;
  wire  T_2201;
  wire  T_2202;
  wire  T_2203;
  wire  T_2205;
  wire  T_2209;
  wire  T_2211;
  wire  T_2214;
  wire  T_2215;
  wire  T_2221;
  wire  T_2225;
  wire  T_2231;
  wire  T_2234;
  wire  T_2235;
  wire  T_2241;
  wire  T_2245;
  wire  T_2251;
  wire  T_2254;
  wire  T_2255;
  wire  T_2261;
  wire  T_2265;
  wire  T_2271;
  wire  T_2274;
  wire  T_2275;
  wire  T_2281;
  wire  T_2285;
  wire  T_2291;
  wire  T_2294;
  wire  T_2295;
  wire  T_2301;
  wire  T_2305;
  wire  T_2311;
  wire  T_2314;
  wire  T_2315;
  wire  T_2321;
  wire  T_2325;
  wire  T_2331;
  wire  T_2352;
  wire  T_2353;
  wire  T_2355;
  wire  T_2356;
  wire  T_2358;
  wire  T_2359;
  wire  T_2361;
  wire  T_2362;
  wire  T_2365;
  wire  T_2368;
  wire  T_2371;
  wire  T_2374;
  wire  T_2376;
  wire  T_2377;
  wire  T_2379;
  wire  T_2380;
  wire  T_2382;
  wire  T_2383;
  wire  T_2385;
  wire  T_2386;
  wire  T_2388;
  wire  T_2390;
  wire  T_2392;
  wire  T_2394;
  wire  T_2396;
  wire  T_2398;
  wire  T_2400;
  wire  T_2402;
  wire  T_2404;
  wire  T_2405;
  wire  T_2407;
  wire  T_2408;
  wire  T_2410;
  wire  T_2411;
  wire  T_2413;
  wire  T_2414;
  wire  T_2417;
  wire  T_2420;
  wire  T_2423;
  wire  T_2426;
  wire  T_2428;
  wire  T_2429;
  wire  T_2431;
  wire  T_2432;
  wire  T_2434;
  wire  T_2435;
  wire  T_2437;
  wire  T_2438;
  wire  T_2444;
  wire  T_2445;
  wire  T_2447;
  wire  T_2448;
  wire  T_2450;
  wire  T_2451;
  wire  T_2453;
  wire  T_2454;
  wire  T_2457;
  wire  T_2460;
  wire  T_2463;
  wire  T_2466;
  wire  T_2468;
  wire  T_2469;
  wire  T_2471;
  wire  T_2472;
  wire  T_2474;
  wire  T_2475;
  wire  T_2477;
  wire  T_2478;
  wire  T_2480;
  wire  T_2482;
  wire  T_2484;
  wire  T_2486;
  wire  T_2488;
  wire  T_2490;
  wire  T_2492;
  wire  T_2494;
  wire  T_2496;
  wire  T_2498;
  wire  T_2500;
  wire  T_2502;
  wire  T_2504;
  wire  T_2506;
  wire  T_2508;
  wire  T_2510;
  wire  T_2523_0;
  wire  T_2523_1;
  wire  T_2523_2;
  wire  T_2523_3;
  wire  T_2523_4;
  wire  T_2523_5;
  wire  T_2523_6;
  wire  T_2523_7;
  wire [31:0] T_2546_0;
  wire [31:0] T_2546_1;
  wire [31:0] T_2546_2;
  wire [31:0] T_2546_3;
  wire [31:0] T_2546_4;
  wire [31:0] T_2546_5;
  wire [31:0] T_2546_6;
  wire [31:0] T_2546_7;
  wire  GEN_4;
  wire  GEN_42;
  wire  GEN_43;
  wire  GEN_44;
  wire  GEN_45;
  wire  GEN_46;
  wire  GEN_47;
  wire  GEN_48;
  wire [31:0] GEN_5;
  wire [31:0] GEN_49;
  wire [31:0] GEN_50;
  wire [31:0] GEN_51;
  wire [31:0] GEN_52;
  wire [31:0] GEN_53;
  wire [31:0] GEN_54;
  wire [31:0] GEN_55;
  wire [31:0] T_2559;
  wire [1:0] T_2560;
  wire [4:0] T_2562;
  wire [2:0] T_2563;
  wire [2:0] T_2574_opcode;
  wire [1:0] T_2574_param;
  wire [2:0] T_2574_size;
  wire [4:0] T_2574_source;
  wire  T_2574_sink;
  wire [1:0] T_2574_addr_lo;
  wire [31:0] T_2574_data;
  wire  T_2574_error;
  wire [2:0] GEN_69 = 3'b0;
  wire [1:0] GEN_70 = 2'b0;
  wire [2:0] GEN_71 = 3'b0;
  wire [4:0] GEN_72 = 5'b0;
  wire [28:0] GEN_73 = 29'b0;
  wire [3:0] GEN_74 = 4'b0;
  wire [31:0] GEN_75 = 32'b0;
  sirv_uarttx u_txm (
    .clock(txm_clock),
    .reset(txm_reset),
    .io_en(txm_io_en),
    .io_in_ready(txm_io_in_ready),
    .io_in_valid(txm_io_in_valid),
    .io_in_bits(txm_io_in_bits),
    .io_out(txm_io_out),
    .io_div(txm_io_div),
    .io_nstop(txm_io_nstop)
  );
  sirv_queue_1 u_txq (
    .clock(txq_clock),
    .reset(txq_reset),
    .io_enq_ready(txq_io_enq_ready),
    .io_enq_valid(txq_io_enq_valid),
    .io_enq_bits(txq_io_enq_bits),
    .io_deq_ready(txq_io_deq_ready),
    .io_deq_valid(txq_io_deq_valid),
    .io_deq_bits(txq_io_deq_bits),
    .io_count(txq_io_count)
  );
  sirv_uartrx u_rxm (
    .clock(rxm_clock),
    .reset(rxm_reset),
    .io_en(rxm_io_en),
    .io_in(rxm_io_in),
    .io_out_valid(rxm_io_out_valid),
    .io_out_bits(rxm_io_out_bits),
    .io_div(rxm_io_div)
  );
  sirv_queue_1 u_rxq (
    .clock(rxq_clock),
    .reset(rxq_reset),
    .io_enq_ready(rxq_io_enq_ready),
    .io_enq_valid(rxq_io_enq_valid),
    .io_enq_bits(rxq_io_enq_bits),
    .io_deq_ready(rxq_io_deq_ready),
    .io_deq_valid(rxq_io_deq_valid),
    .io_deq_bits(rxq_io_deq_bits),
    .io_count(rxq_io_count)
  );
  assign io_interrupts_0_0 = T_920;
  assign io_in_0_a_ready = T_951_ready;
  assign io_in_0_b_valid = 1'h0;
  assign io_in_0_b_bits_opcode = GEN_69;
  assign io_in_0_b_bits_param = GEN_70;
  assign io_in_0_b_bits_size = GEN_71;
  assign io_in_0_b_bits_source = GEN_72;
  assign io_in_0_b_bits_address = GEN_73;
  assign io_in_0_b_bits_mask = GEN_74;
  assign io_in_0_b_bits_data = GEN_75;
  assign io_in_0_c_ready = 1'h1;
  assign io_in_0_d_valid = T_990_valid;
  assign io_in_0_d_bits_opcode = {{2'd0}, T_990_bits_read};
  assign io_in_0_d_bits_param = T_2574_param;
  assign io_in_0_d_bits_size = T_2574_size;
  assign io_in_0_d_bits_source = T_2574_source;
  assign io_in_0_d_bits_sink = T_2574_sink;
  assign io_in_0_d_bits_addr_lo = T_2574_addr_lo;
  assign io_in_0_d_bits_data = T_990_bits_data;
  assign io_in_0_d_bits_error = T_2574_error;
  assign io_in_0_e_ready = 1'h1;
  assign io_port_txd = txm_io_out;
  assign txm_clock = clock;
  assign txm_reset = reset;
  assign txm_io_en = txen;
  assign txm_io_in_valid = txq_io_deq_valid;
  assign txm_io_in_bits = txq_io_deq_bits;
  assign txm_io_div = div;
  assign txm_io_nstop = nstop;
  assign txq_clock = clock;
  assign txq_reset = reset;
  assign txq_io_enq_valid = T_1269;
  assign txq_io_enq_bits = T_1270;
  assign txq_io_deq_ready = txm_io_in_ready;
  assign rxm_clock = clock;
  assign rxm_reset = reset;
  assign rxm_io_en = rxen;
  assign rxm_io_in = io_port_rxd;
  assign rxm_io_div = div;
  assign rxq_clock = clock;
  assign rxq_reset = reset;
  assign rxq_io_enq_valid = rxm_io_out_valid;
  assign rxq_io_enq_bits = rxm_io_out_bits;
  assign rxq_io_deq_ready = T_1465;
  assign T_902_rxwm = T_908;
  assign T_902_txwm = T_907;
  assign T_906 = 2'h0;
  assign T_907 = T_906[0];
  assign T_908 = T_906[1];
  assign ip_rxwm = T_917;
  assign ip_txwm = T_916;
  assign T_916 = txq_io_count < txwm;
  assign T_917 = rxq_io_count > rxwm;
  assign T_918 = ip_txwm & ie_txwm;
  assign T_919 = ip_rxwm & ie_rxwm;
  assign T_920 = T_918 | T_919;
  assign T_924 = txq_io_enq_ready == 1'h0;
  assign T_927 = rxq_io_deq_valid == 1'h0;
  assign T_951_ready = T_2168;
  assign T_951_valid = io_in_0_a_valid;
  assign T_951_bits_read = T_968;
  assign T_951_bits_index = T_969[9:0];
  assign T_951_bits_data = io_in_0_a_bits_data;
  assign T_951_bits_mask = io_in_0_a_bits_mask;
  assign T_951_bits_extra = T_972;
  assign T_968 = io_in_0_a_bits_opcode == 3'h4;
  assign T_969 = io_in_0_a_bits_address[28:2];
  assign T_970 = io_in_0_a_bits_address[1:0];
  assign T_971 = {T_970,io_in_0_a_bits_source};
  assign T_972 = {T_971,io_in_0_a_bits_size};
  assign T_990_ready = io_in_0_d_ready;
  assign T_990_valid = T_2171;
  assign T_990_bits_read = T_1026_bits_read;
  assign T_990_bits_data = T_2559;
  assign T_990_bits_extra = T_1026_bits_extra;
  assign T_1026_ready = T_2170;
  assign T_1026_valid = T_2169;
  assign T_1026_bits_read = T_951_bits_read;
  assign T_1026_bits_index = T_951_bits_index;
  assign T_1026_bits_data = T_951_bits_data;
  assign T_1026_bits_mask = T_951_bits_mask;
  assign T_1026_bits_extra = T_951_bits_extra;
  assign T_1063 = T_1026_bits_index & 10'h3f8;
  assign T_1065 = T_1063 == 10'h0;
  assign T_1071 = T_1026_bits_index ^ 10'h5;
  assign T_1072 = T_1071 & 10'h3f8;
  assign T_1074 = T_1072 == 10'h0;
  assign T_1080 = T_1026_bits_index ^ 10'h1;
  assign T_1081 = T_1080 & 10'h3f8;
  assign T_1083 = T_1081 == 10'h0;
  assign T_1089 = T_1026_bits_index ^ 10'h6;
  assign T_1090 = T_1089 & 10'h3f8;
  assign T_1092 = T_1090 == 10'h0;
  assign T_1098 = T_1026_bits_index ^ 10'h2;
  assign T_1099 = T_1098 & 10'h3f8;
  assign T_1101 = T_1099 == 10'h0;
  assign T_1107 = T_1026_bits_index ^ 10'h3;
  assign T_1108 = T_1107 & 10'h3f8;
  assign T_1110 = T_1108 == 10'h0;
  assign T_1116 = T_1026_bits_index ^ 10'h4;
  assign T_1117 = T_1116 & 10'h3f8;
  assign T_1119 = T_1117 == 10'h0;
  assign T_1127_0 = T_2353;
  assign T_1127_1 = T_2365;
  assign T_1127_2 = T_2377;
  assign T_1127_3 = T_2388;
  assign T_1127_4 = T_2396;
  assign T_1127_5 = T_2405;
  assign T_1127_6 = T_2417;
  assign T_1127_7 = T_2429;
  assign T_1127_8 = T_2315;
  assign T_1127_9 = T_2445;
  assign T_1127_10 = T_2457;
  assign T_1127_11 = T_2469;
  assign T_1127_12 = T_2480;
  assign T_1127_13 = T_2488;
  assign T_1127_14 = T_2496;
  assign T_1127_15 = T_2504;
  assign T_1132_0 = T_2356;
  assign T_1132_1 = T_2368;
  assign T_1132_2 = T_2380;
  assign T_1132_3 = T_2390;
  assign T_1132_4 = T_2398;
  assign T_1132_5 = T_2408;
  assign T_1132_6 = T_2420;
  assign T_1132_7 = T_2432;
  assign T_1132_8 = T_2321;
  assign T_1132_9 = T_2448;
  assign T_1132_10 = T_2460;
  assign T_1132_11 = T_2472;
  assign T_1132_12 = T_2482;
  assign T_1132_13 = T_2490;
  assign T_1132_14 = T_2498;
  assign T_1132_15 = T_2506;
  assign T_1137_0 = 1'h1;
  assign T_1137_1 = 1'h1;
  assign T_1137_2 = 1'h1;
  assign T_1137_3 = 1'h1;
  assign T_1137_4 = 1'h1;
  assign T_1137_5 = 1'h1;
  assign T_1137_6 = 1'h1;
  assign T_1137_7 = 1'h1;
  assign T_1137_8 = 1'h1;
  assign T_1137_9 = 1'h1;
  assign T_1137_10 = 1'h1;
  assign T_1137_11 = 1'h1;
  assign T_1137_12 = 1'h1;
  assign T_1137_13 = 1'h1;
  assign T_1137_14 = 1'h1;
  assign T_1137_15 = 1'h1;
  assign T_1142_0 = 1'h1;
  assign T_1142_1 = 1'h1;
  assign T_1142_2 = 1'h1;
  assign T_1142_3 = 1'h1;
  assign T_1142_4 = 1'h1;
  assign T_1142_5 = 1'h1;
  assign T_1142_6 = 1'h1;
  assign T_1142_7 = 1'h1;
  assign T_1142_8 = 1'h1;
  assign T_1142_9 = 1'h1;
  assign T_1142_10 = 1'h1;
  assign T_1142_11 = 1'h1;
  assign T_1142_12 = 1'h1;
  assign T_1142_13 = 1'h1;
  assign T_1142_14 = 1'h1;
  assign T_1142_15 = 1'h1;
  assign T_1147_0 = 1'h1;
  assign T_1147_1 = 1'h1;
  assign T_1147_2 = 1'h1;
  assign T_1147_3 = 1'h1;
  assign T_1147_4 = 1'h1;
  assign T_1147_5 = 1'h1;
  assign T_1147_6 = 1'h1;
  assign T_1147_7 = 1'h1;
  assign T_1147_8 = 1'h1;
  assign T_1147_9 = 1'h1;
  assign T_1147_10 = 1'h1;
  assign T_1147_11 = 1'h1;
  assign T_1147_12 = 1'h1;
  assign T_1147_13 = 1'h1;
  assign T_1147_14 = 1'h1;
  assign T_1147_15 = 1'h1;
  assign T_1152_0 = 1'h1;
  assign T_1152_1 = 1'h1;
  assign T_1152_2 = 1'h1;
  assign T_1152_3 = 1'h1;
  assign T_1152_4 = 1'h1;
  assign T_1152_5 = 1'h1;
  assign T_1152_6 = 1'h1;
  assign T_1152_7 = 1'h1;
  assign T_1152_8 = 1'h1;
  assign T_1152_9 = 1'h1;
  assign T_1152_10 = 1'h1;
  assign T_1152_11 = 1'h1;
  assign T_1152_12 = 1'h1;
  assign T_1152_13 = 1'h1;
  assign T_1152_14 = 1'h1;
  assign T_1152_15 = 1'h1;
  assign T_1157_0 = T_2359;
  assign T_1157_1 = T_2371;
  assign T_1157_2 = T_2383;
  assign T_1157_3 = T_2392;
  assign T_1157_4 = T_2400;
  assign T_1157_5 = T_2411;
  assign T_1157_6 = T_2423;
  assign T_1157_7 = T_2435;
  assign T_1157_8 = T_2325;
  assign T_1157_9 = T_2451;
  assign T_1157_10 = T_2463;
  assign T_1157_11 = T_2475;
  assign T_1157_12 = T_2484;
  assign T_1157_13 = T_2492;
  assign T_1157_14 = T_2500;
  assign T_1157_15 = T_2508;
  assign T_1162_0 = T_2362;
  assign T_1162_1 = T_2374;
  assign T_1162_2 = T_2386;
  assign T_1162_3 = T_2394;
  assign T_1162_4 = T_2402;
  assign T_1162_5 = T_2414;
  assign T_1162_6 = T_2426;
  assign T_1162_7 = T_2438;
  assign T_1162_8 = T_2331;
  assign T_1162_9 = T_2454;
  assign T_1162_10 = T_2466;
  assign T_1162_11 = T_2478;
  assign T_1162_12 = T_2486;
  assign T_1162_13 = T_2494;
  assign T_1162_14 = T_2502;
  assign T_1162_15 = T_2510;
  assign T_1204 = T_1026_bits_mask[0];
  assign T_1205 = T_1026_bits_mask[1];
  assign T_1206 = T_1026_bits_mask[2];
  assign T_1207 = T_1026_bits_mask[3];
  assign T_1211 = T_1204 ? 8'hff : 8'h0;
  assign T_1215 = T_1205 ? 8'hff : 8'h0;
  assign T_1219 = T_1206 ? 8'hff : 8'h0;
  assign T_1223 = T_1207 ? 8'hff : 8'h0;
  assign T_1224 = {T_1215,T_1211};
  assign T_1225 = {T_1223,T_1219};
  assign T_1226 = {T_1225,T_1224};
  assign T_1250 = T_1226[7:0];
  assign T_1252 = T_1250 != 8'h0;
  assign T_1254 = ~ T_1250;
  assign T_1256 = T_1254 == 8'h0;
  assign T_1269 = T_1162_0 & T_1256;
  assign T_1270 = T_1026_bits_data[7:0];
  assign GEN_56 = {{31'd0}, T_924};
  assign T_1365 = GEN_56 << 31;
  assign T_1370 = T_1226[0];
  assign T_1374 = ~ T_1370;
  assign T_1376 = T_1374 == 1'h0;
  assign T_1390 = T_1026_bits_data[0];
  assign T_1410 = T_1226[1];
  assign T_1414 = ~ T_1410;
  assign T_1416 = T_1414 == 1'h0;
  assign T_1430 = T_1026_bits_data[1];
  assign GEN_57 = {{1'd0}, ip_rxwm};
  assign T_1445 = GEN_57 << 1;
  assign GEN_58 = {{1'd0}, ip_txwm};
  assign T_1449 = GEN_58 | T_1445;
  assign T_1465 = T_1157_5 & T_1252;
  assign T_1485 = rxq_io_deq_bits;
  assign T_1529 = {{23'd0}, T_1485};
  assign GEN_59 = {{31'd0}, T_927};
  assign T_1565 = GEN_59 << 31;
  assign GEN_60 = {{1'd0}, T_1529};
  assign T_1569 = GEN_60 | T_1565;
  assign T_1570 = T_1226[15:0];
  assign T_1574 = ~ T_1570;
  assign T_1576 = T_1574 == 16'h0;
  assign T_1589 = T_1162_8 & T_1576;
  assign T_1590 = T_1026_bits_data[15:0];
  assign GEN_6 = T_1589 ? T_1590 : div;
  assign T_1629 = T_1162_9 & T_1376;
  assign GEN_7 = T_1629 ? T_1390 : txen;
  assign T_1669 = T_1162_10 & T_1416;
  assign GEN_8 = T_1669 ? T_1430 : nstop;
  assign GEN_61 = {{1'd0}, nstop};
  assign T_1685 = GEN_61 << 1;
  assign GEN_62 = {{1'd0}, txen};
  assign T_1689 = GEN_62 | T_1685;
  assign T_1690 = T_1226[19:16];
  assign T_1694 = ~ T_1690;
  assign T_1696 = T_1694 == 4'h0;
  assign T_1709 = T_1162_11 & T_1696;
  assign T_1710 = T_1026_bits_data[19:16];
  assign GEN_9 = T_1709 ? T_1710 : txwm;
  assign GEN_63 = {{16'd0}, txwm};
  assign T_1725 = GEN_63 << 16;
  assign GEN_64 = {{18'd0}, T_1689};
  assign T_1729 = GEN_64 | T_1725;
  assign T_1749 = T_1162_12 & T_1376;
  assign GEN_10 = T_1749 ? T_1390 : rxen;
  assign T_1789 = T_1162_13 & T_1696;
  assign GEN_11 = T_1789 ? T_1710 : rxwm;
  assign GEN_65 = {{16'd0}, rxwm};
  assign T_1805 = GEN_65 << 16;
  assign GEN_66 = {{19'd0}, rxen};
  assign T_1809 = GEN_66 | T_1805;
  assign T_1829 = T_1162_14 & T_1376;
  assign GEN_12 = T_1829 ? T_1390 : ie_txwm;
  assign T_1869 = T_1162_15 & T_1416;
  assign GEN_13 = T_1869 ? T_1430 : ie_rxwm;
  assign GEN_67 = {{1'd0}, ie_rxwm};
  assign T_1885 = GEN_67 << 1;
  assign GEN_68 = {{1'd0}, ie_txwm};
  assign T_1889 = GEN_68 | T_1885;
  assign T_1891 = T_1065 == 1'h0;
  assign T_1892 = T_1137_2 & T_1137_1;
  assign T_1893 = T_1892 & T_1137_0;
  assign T_1895 = T_1891 | T_1893;
  assign T_1897 = T_1083 == 1'h0;
  assign T_1898 = T_1137_7 & T_1137_6;
  assign T_1899 = T_1898 & T_1137_5;
  assign T_1901 = T_1897 | T_1899;
  assign T_1903 = T_1101 == 1'h0;
  assign T_1904 = T_1137_11 & T_1137_10;
  assign T_1905 = T_1904 & T_1137_9;
  assign T_1907 = T_1903 | T_1905;
  assign T_1909 = T_1110 == 1'h0;
  assign T_1910 = T_1137_13 & T_1137_12;
  assign T_1912 = T_1909 | T_1910;
  assign T_1914 = T_1119 == 1'h0;
  assign T_1915 = T_1137_15 & T_1137_14;
  assign T_1917 = T_1914 | T_1915;
  assign T_1919 = T_1074 == 1'h0;
  assign T_1920 = T_1137_4 & T_1137_3;
  assign T_1922 = T_1919 | T_1920;
  assign T_1924 = T_1092 == 1'h0;
  assign T_1926 = T_1924 | T_1137_8;
  assign T_1941_0 = T_1895;
  assign T_1941_1 = T_1901;
  assign T_1941_2 = T_1907;
  assign T_1941_3 = T_1912;
  assign T_1941_4 = T_1917;
  assign T_1941_5 = T_1922;
  assign T_1941_6 = T_1926;
  assign T_1941_7 = 1'h1;
  assign T_1954 = T_1142_2 & T_1142_1;
  assign T_1955 = T_1954 & T_1142_0;
  assign T_1957 = T_1891 | T_1955;
  assign T_1960 = T_1142_7 & T_1142_6;
  assign T_1961 = T_1960 & T_1142_5;
  assign T_1963 = T_1897 | T_1961;
  assign T_1966 = T_1142_11 & T_1142_10;
  assign T_1967 = T_1966 & T_1142_9;
  assign T_1969 = T_1903 | T_1967;
  assign T_1972 = T_1142_13 & T_1142_12;
  assign T_1974 = T_1909 | T_1972;
  assign T_1977 = T_1142_15 & T_1142_14;
  assign T_1979 = T_1914 | T_1977;
  assign T_1982 = T_1142_4 & T_1142_3;
  assign T_1984 = T_1919 | T_1982;
  assign T_1988 = T_1924 | T_1142_8;
  assign T_2003_0 = T_1957;
  assign T_2003_1 = T_1963;
  assign T_2003_2 = T_1969;
  assign T_2003_3 = T_1974;
  assign T_2003_4 = T_1979;
  assign T_2003_5 = T_1984;
  assign T_2003_6 = T_1988;
  assign T_2003_7 = 1'h1;
  assign T_2016 = T_1147_2 & T_1147_1;
  assign T_2017 = T_2016 & T_1147_0;
  assign T_2019 = T_1891 | T_2017;
  assign T_2022 = T_1147_7 & T_1147_6;
  assign T_2023 = T_2022 & T_1147_5;
  assign T_2025 = T_1897 | T_2023;
  assign T_2028 = T_1147_11 & T_1147_10;
  assign T_2029 = T_2028 & T_1147_9;
  assign T_2031 = T_1903 | T_2029;
  assign T_2034 = T_1147_13 & T_1147_12;
  assign T_2036 = T_1909 | T_2034;
  assign T_2039 = T_1147_15 & T_1147_14;
  assign T_2041 = T_1914 | T_2039;
  assign T_2044 = T_1147_4 & T_1147_3;
  assign T_2046 = T_1919 | T_2044;
  assign T_2050 = T_1924 | T_1147_8;
  assign T_2065_0 = T_2019;
  assign T_2065_1 = T_2025;
  assign T_2065_2 = T_2031;
  assign T_2065_3 = T_2036;
  assign T_2065_4 = T_2041;
  assign T_2065_5 = T_2046;
  assign T_2065_6 = T_2050;
  assign T_2065_7 = 1'h1;
  assign T_2078 = T_1152_2 & T_1152_1;
  assign T_2079 = T_2078 & T_1152_0;
  assign T_2081 = T_1891 | T_2079;
  assign T_2084 = T_1152_7 & T_1152_6;
  assign T_2085 = T_2084 & T_1152_5;
  assign T_2087 = T_1897 | T_2085;
  assign T_2090 = T_1152_11 & T_1152_10;
  assign T_2091 = T_2090 & T_1152_9;
  assign T_2093 = T_1903 | T_2091;
  assign T_2096 = T_1152_13 & T_1152_12;
  assign T_2098 = T_1909 | T_2096;
  assign T_2101 = T_1152_15 & T_1152_14;
  assign T_2103 = T_1914 | T_2101;
  assign T_2106 = T_1152_4 & T_1152_3;
  assign T_2108 = T_1919 | T_2106;
  assign T_2112 = T_1924 | T_1152_8;
  assign T_2127_0 = T_2081;
  assign T_2127_1 = T_2087;
  assign T_2127_2 = T_2093;
  assign T_2127_3 = T_2098;
  assign T_2127_4 = T_2103;
  assign T_2127_5 = T_2108;
  assign T_2127_6 = T_2112;
  assign T_2127_7 = 1'h1;
  assign T_2138 = T_1026_bits_index[0];
  assign T_2139 = T_1026_bits_index[1];
  assign T_2140 = T_1026_bits_index[2];
  assign T_2148 = {T_2140,T_2139};
  assign T_2149 = {T_2148,T_2138};
  assign GEN_0 = GEN_20;
  assign GEN_14 = 3'h1 == T_2149 ? T_1941_1 : T_1941_0;
  assign GEN_15 = 3'h2 == T_2149 ? T_1941_2 : GEN_14;
  assign GEN_16 = 3'h3 == T_2149 ? T_1941_3 : GEN_15;
  assign GEN_17 = 3'h4 == T_2149 ? T_1941_4 : GEN_16;
  assign GEN_18 = 3'h5 == T_2149 ? T_1941_5 : GEN_17;
  assign GEN_19 = 3'h6 == T_2149 ? T_1941_6 : GEN_18;
  assign GEN_20 = 3'h7 == T_2149 ? T_1941_7 : GEN_19;
  assign GEN_1 = GEN_27;
  assign GEN_21 = 3'h1 == T_2149 ? T_2003_1 : T_2003_0;
  assign GEN_22 = 3'h2 == T_2149 ? T_2003_2 : GEN_21;
  assign GEN_23 = 3'h3 == T_2149 ? T_2003_3 : GEN_22;
  assign GEN_24 = 3'h4 == T_2149 ? T_2003_4 : GEN_23;
  assign GEN_25 = 3'h5 == T_2149 ? T_2003_5 : GEN_24;
  assign GEN_26 = 3'h6 == T_2149 ? T_2003_6 : GEN_25;
  assign GEN_27 = 3'h7 == T_2149 ? T_2003_7 : GEN_26;
  assign T_2164 = T_1026_bits_read ? GEN_0 : GEN_1;
  assign GEN_2 = GEN_34;
  assign GEN_28 = 3'h1 == T_2149 ? T_2065_1 : T_2065_0;
  assign GEN_29 = 3'h2 == T_2149 ? T_2065_2 : GEN_28;
  assign GEN_30 = 3'h3 == T_2149 ? T_2065_3 : GEN_29;
  assign GEN_31 = 3'h4 == T_2149 ? T_2065_4 : GEN_30;
  assign GEN_32 = 3'h5 == T_2149 ? T_2065_5 : GEN_31;
  assign GEN_33 = 3'h6 == T_2149 ? T_2065_6 : GEN_32;
  assign GEN_34 = 3'h7 == T_2149 ? T_2065_7 : GEN_33;
  assign GEN_3 = GEN_41;
  assign GEN_35 = 3'h1 == T_2149 ? T_2127_1 : T_2127_0;
  assign GEN_36 = 3'h2 == T_2149 ? T_2127_2 : GEN_35;
  assign GEN_37 = 3'h3 == T_2149 ? T_2127_3 : GEN_36;
  assign GEN_38 = 3'h4 == T_2149 ? T_2127_4 : GEN_37;
  assign GEN_39 = 3'h5 == T_2149 ? T_2127_5 : GEN_38;
  assign GEN_40 = 3'h6 == T_2149 ? T_2127_6 : GEN_39;
  assign GEN_41 = 3'h7 == T_2149 ? T_2127_7 : GEN_40;
  assign T_2167 = T_1026_bits_read ? GEN_2 : GEN_3;
  assign T_2168 = T_1026_ready & T_2164;
  assign T_2169 = T_951_valid & T_2164;
  assign T_2170 = T_990_ready & T_2167;
  assign T_2171 = T_1026_valid & T_2167;
  assign T_2173 = 8'h1 << T_2149;
  assign T_2174 = {T_1083,T_1065};
  assign T_2175 = {T_1110,T_1101};
  assign T_2176 = {T_2175,T_2174};
  assign T_2177 = {T_1074,T_1119};
  assign T_2178 = {1'h1,T_1092};
  assign T_2179 = {T_2178,T_2177};
  assign T_2180 = {T_2179,T_2176};
  assign T_2181 = T_2173 & T_2180;
  assign T_2192 = T_951_valid & T_1026_ready;
  assign T_2193 = T_2192 & T_1026_bits_read;
  assign T_2194 = T_2181[0];
  assign T_2195 = T_2193 & T_2194;
  assign T_2198 = T_1026_bits_read == 1'h0;
  assign T_2199 = T_2192 & T_2198;
  assign T_2201 = T_2199 & T_2194;
  assign T_2202 = T_1026_valid & T_990_ready;
  assign T_2203 = T_2202 & T_1026_bits_read;
  assign T_2205 = T_2203 & T_2194;
  assign T_2209 = T_2202 & T_2198;
  assign T_2211 = T_2209 & T_2194;
  assign T_2214 = T_2181[1];
  assign T_2215 = T_2193 & T_2214;
  assign T_2221 = T_2199 & T_2214;
  assign T_2225 = T_2203 & T_2214;
  assign T_2231 = T_2209 & T_2214;
  assign T_2234 = T_2181[2];
  assign T_2235 = T_2193 & T_2234;
  assign T_2241 = T_2199 & T_2234;
  assign T_2245 = T_2203 & T_2234;
  assign T_2251 = T_2209 & T_2234;
  assign T_2254 = T_2181[3];
  assign T_2255 = T_2193 & T_2254;
  assign T_2261 = T_2199 & T_2254;
  assign T_2265 = T_2203 & T_2254;
  assign T_2271 = T_2209 & T_2254;
  assign T_2274 = T_2181[4];
  assign T_2275 = T_2193 & T_2274;
  assign T_2281 = T_2199 & T_2274;
  assign T_2285 = T_2203 & T_2274;
  assign T_2291 = T_2209 & T_2274;
  assign T_2294 = T_2181[5];
  assign T_2295 = T_2193 & T_2294;
  assign T_2301 = T_2199 & T_2294;
  assign T_2305 = T_2203 & T_2294;
  assign T_2311 = T_2209 & T_2294;
  assign T_2314 = T_2181[6];
  assign T_2315 = T_2193 & T_2314;
  assign T_2321 = T_2199 & T_2314;
  assign T_2325 = T_2203 & T_2314;
  assign T_2331 = T_2209 & T_2314;
  assign T_2352 = T_2195 & T_1137_2;
  assign T_2353 = T_2352 & T_1137_1;
  assign T_2355 = T_2201 & T_1142_2;
  assign T_2356 = T_2355 & T_1142_1;
  assign T_2358 = T_2205 & T_1147_2;
  assign T_2359 = T_2358 & T_1147_1;
  assign T_2361 = T_2211 & T_1152_2;
  assign T_2362 = T_2361 & T_1152_1;
  assign T_2365 = T_2352 & T_1137_0;
  assign T_2368 = T_2355 & T_1142_0;
  assign T_2371 = T_2358 & T_1147_0;
  assign T_2374 = T_2361 & T_1152_0;
  assign T_2376 = T_2195 & T_1137_1;
  assign T_2377 = T_2376 & T_1137_0;
  assign T_2379 = T_2201 & T_1142_1;
  assign T_2380 = T_2379 & T_1142_0;
  assign T_2382 = T_2205 & T_1147_1;
  assign T_2383 = T_2382 & T_1147_0;
  assign T_2385 = T_2211 & T_1152_1;
  assign T_2386 = T_2385 & T_1152_0;
  assign T_2388 = T_2295 & T_1137_4;
  assign T_2390 = T_2301 & T_1142_4;
  assign T_2392 = T_2305 & T_1147_4;
  assign T_2394 = T_2311 & T_1152_4;
  assign T_2396 = T_2295 & T_1137_3;
  assign T_2398 = T_2301 & T_1142_3;
  assign T_2400 = T_2305 & T_1147_3;
  assign T_2402 = T_2311 & T_1152_3;
  assign T_2404 = T_2215 & T_1137_7;
  assign T_2405 = T_2404 & T_1137_6;
  assign T_2407 = T_2221 & T_1142_7;
  assign T_2408 = T_2407 & T_1142_6;
  assign T_2410 = T_2225 & T_1147_7;
  assign T_2411 = T_2410 & T_1147_6;
  assign T_2413 = T_2231 & T_1152_7;
  assign T_2414 = T_2413 & T_1152_6;
  assign T_2417 = T_2404 & T_1137_5;
  assign T_2420 = T_2407 & T_1142_5;
  assign T_2423 = T_2410 & T_1147_5;
  assign T_2426 = T_2413 & T_1152_5;
  assign T_2428 = T_2215 & T_1137_6;
  assign T_2429 = T_2428 & T_1137_5;
  assign T_2431 = T_2221 & T_1142_6;
  assign T_2432 = T_2431 & T_1142_5;
  assign T_2434 = T_2225 & T_1147_6;
  assign T_2435 = T_2434 & T_1147_5;
  assign T_2437 = T_2231 & T_1152_6;
  assign T_2438 = T_2437 & T_1152_5;
  assign T_2444 = T_2235 & T_1137_11;
  assign T_2445 = T_2444 & T_1137_10;
  assign T_2447 = T_2241 & T_1142_11;
  assign T_2448 = T_2447 & T_1142_10;
  assign T_2450 = T_2245 & T_1147_11;
  assign T_2451 = T_2450 & T_1147_10;
  assign T_2453 = T_2251 & T_1152_11;
  assign T_2454 = T_2453 & T_1152_10;
  assign T_2457 = T_2444 & T_1137_9;
  assign T_2460 = T_2447 & T_1142_9;
  assign T_2463 = T_2450 & T_1147_9;
  assign T_2466 = T_2453 & T_1152_9;
  assign T_2468 = T_2235 & T_1137_10;
  assign T_2469 = T_2468 & T_1137_9;
  assign T_2471 = T_2241 & T_1142_10;
  assign T_2472 = T_2471 & T_1142_9;
  assign T_2474 = T_2245 & T_1147_10;
  assign T_2475 = T_2474 & T_1147_9;
  assign T_2477 = T_2251 & T_1152_10;
  assign T_2478 = T_2477 & T_1152_9;
  assign T_2480 = T_2255 & T_1137_13;
  assign T_2482 = T_2261 & T_1142_13;
  assign T_2484 = T_2265 & T_1147_13;
  assign T_2486 = T_2271 & T_1152_13;
  assign T_2488 = T_2255 & T_1137_12;
  assign T_2490 = T_2261 & T_1142_12;
  assign T_2492 = T_2265 & T_1147_12;
  assign T_2494 = T_2271 & T_1152_12;
  assign T_2496 = T_2275 & T_1137_15;
  assign T_2498 = T_2281 & T_1142_15;
  assign T_2500 = T_2285 & T_1147_15;
  assign T_2502 = T_2291 & T_1152_15;
  assign T_2504 = T_2275 & T_1137_14;
  assign T_2506 = T_2281 & T_1142_14;
  assign T_2508 = T_2285 & T_1147_14;
  assign T_2510 = T_2291 & T_1152_14;
  assign T_2523_0 = T_1065;
  assign T_2523_1 = T_1083;
  assign T_2523_2 = T_1101;
  assign T_2523_3 = T_1110;
  assign T_2523_4 = T_1119;
  assign T_2523_5 = T_1074;
  assign T_2523_6 = T_1092;
  assign T_2523_7 = 1'h1;
  assign T_2546_0 = T_1365;
  assign T_2546_1 = T_1569;
  assign T_2546_2 = {{12'd0}, T_1729};
  assign T_2546_3 = {{12'd0}, T_1809};
  assign T_2546_4 = {{30'd0}, T_1889};
  assign T_2546_5 = {{30'd0}, T_1449};
  assign T_2546_6 = {{16'd0}, div};
  assign T_2546_7 = 32'h0;
  assign GEN_4 = GEN_48;
  assign GEN_42 = 3'h1 == T_2149 ? T_2523_1 : T_2523_0;
  assign GEN_43 = 3'h2 == T_2149 ? T_2523_2 : GEN_42;
  assign GEN_44 = 3'h3 == T_2149 ? T_2523_3 : GEN_43;
  assign GEN_45 = 3'h4 == T_2149 ? T_2523_4 : GEN_44;
  assign GEN_46 = 3'h5 == T_2149 ? T_2523_5 : GEN_45;
  assign GEN_47 = 3'h6 == T_2149 ? T_2523_6 : GEN_46;
  assign GEN_48 = 3'h7 == T_2149 ? T_2523_7 : GEN_47;
  assign GEN_5 = GEN_55;
  assign GEN_49 = 3'h1 == T_2149 ? T_2546_1 : T_2546_0;
  assign GEN_50 = 3'h2 == T_2149 ? T_2546_2 : GEN_49;
  assign GEN_51 = 3'h3 == T_2149 ? T_2546_3 : GEN_50;
  assign GEN_52 = 3'h4 == T_2149 ? T_2546_4 : GEN_51;
  assign GEN_53 = 3'h5 == T_2149 ? T_2546_5 : GEN_52;
  assign GEN_54 = 3'h6 == T_2149 ? T_2546_6 : GEN_53;
  assign GEN_55 = 3'h7 == T_2149 ? T_2546_7 : GEN_54;
  assign T_2559 = GEN_4 ? GEN_5 : 32'h0;
  assign T_2560 = T_990_bits_extra[9:8];
  assign T_2562 = T_990_bits_extra[7:3];
  assign T_2563 = T_990_bits_extra[2:0];
  assign T_2574_opcode = 3'h0;
  assign T_2574_param = 2'h0;
  assign T_2574_size = T_2563;
  assign T_2574_source = T_2562;
  assign T_2574_sink = 1'h0;
  assign T_2574_addr_lo = T_2560;
  assign T_2574_data = 32'h0;
  assign T_2574_error = 1'h0;

  always @(posedge clock or posedge reset)
    if (reset) begin
      div <= 16'h21e;
    end else begin
      if (T_1589) begin
        div <= T_1590;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      txen <= 1'h0;
    end else begin
      if (T_1629) begin
        txen <= T_1390;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      rxen <= 1'h0;
    end else begin
      if (T_1749) begin
        rxen <= T_1390;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      txwm <= 4'h0;
    end else begin
      if (T_1709) begin
        txwm <= T_1710;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      rxwm <= 4'h0;
    end else begin
      if (T_1789) begin
        rxwm <= T_1710;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      nstop <= 1'h0;
    end else begin
      if (T_1669) begin
        nstop <= T_1430;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ie_rxwm <= T_902_rxwm;
    end else begin
      if (T_1869) begin
        ie_rxwm <= T_1430;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      ie_txwm <= T_902_txwm;
    end else begin
      if (T_1829) begin
        ie_txwm <= T_1390;
      end
    end

endmodule
