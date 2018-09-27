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
                                                                         
                                                                         
                                                                         

module sirv_tlwidthwidget_qspi(
  input   clock,
  input   reset,
  output  io_in_0_a_ready,
  input   io_in_0_a_valid,
  input  [2:0] io_in_0_a_bits_opcode,
  input  [2:0] io_in_0_a_bits_param,
  input  [2:0] io_in_0_a_bits_size,
  input  [1:0] io_in_0_a_bits_source,
  input  [29:0] io_in_0_a_bits_address,
  input  [3:0] io_in_0_a_bits_mask,
  input  [31:0] io_in_0_a_bits_data,
  input   io_in_0_b_ready,
  output  io_in_0_b_valid,
  output [2:0] io_in_0_b_bits_opcode,
  output [1:0] io_in_0_b_bits_param,
  output [2:0] io_in_0_b_bits_size,
  output [1:0] io_in_0_b_bits_source,
  output [29:0] io_in_0_b_bits_address,
  output [3:0] io_in_0_b_bits_mask,
  output [31:0] io_in_0_b_bits_data,
  output  io_in_0_c_ready,
  input   io_in_0_c_valid,
  input  [2:0] io_in_0_c_bits_opcode,
  input  [2:0] io_in_0_c_bits_param,
  input  [2:0] io_in_0_c_bits_size,
  input  [1:0] io_in_0_c_bits_source,
  input  [29:0] io_in_0_c_bits_address,
  input  [31:0] io_in_0_c_bits_data,
  input   io_in_0_c_bits_error,
  input   io_in_0_d_ready,
  output  io_in_0_d_valid,
  output [2:0] io_in_0_d_bits_opcode,
  output [1:0] io_in_0_d_bits_param,
  output [2:0] io_in_0_d_bits_size,
  output [1:0] io_in_0_d_bits_source,
  output  io_in_0_d_bits_sink,
  output [1:0] io_in_0_d_bits_addr_lo,
  output [31:0] io_in_0_d_bits_data,
  output  io_in_0_d_bits_error,
  output  io_in_0_e_ready,
  input   io_in_0_e_valid,
  input   io_in_0_e_bits_sink,
  input   io_out_0_a_ready,
  output  io_out_0_a_valid,
  output [2:0] io_out_0_a_bits_opcode,
  output [2:0] io_out_0_a_bits_param,
  output [2:0] io_out_0_a_bits_size,
  output [1:0] io_out_0_a_bits_source,
  output [29:0] io_out_0_a_bits_address,
  output  io_out_0_a_bits_mask,
  output [7:0] io_out_0_a_bits_data,
  output  io_out_0_b_ready,
  input   io_out_0_b_valid,
  input  [2:0] io_out_0_b_bits_opcode,
  input  [1:0] io_out_0_b_bits_param,
  input  [2:0] io_out_0_b_bits_size,
  input  [1:0] io_out_0_b_bits_source,
  input  [29:0] io_out_0_b_bits_address,
  input   io_out_0_b_bits_mask,
  input  [7:0] io_out_0_b_bits_data,
  input   io_out_0_c_ready,
  output  io_out_0_c_valid,
  output [2:0] io_out_0_c_bits_opcode,
  output [2:0] io_out_0_c_bits_param,
  output [2:0] io_out_0_c_bits_size,
  output [1:0] io_out_0_c_bits_source,
  output [29:0] io_out_0_c_bits_address,
  output [7:0] io_out_0_c_bits_data,
  output  io_out_0_c_bits_error,
  output  io_out_0_d_ready,
  input   io_out_0_d_valid,
  input  [2:0] io_out_0_d_bits_opcode,
  input  [1:0] io_out_0_d_bits_param,
  input  [2:0] io_out_0_d_bits_size,
  input  [1:0] io_out_0_d_bits_source,
  input   io_out_0_d_bits_sink,
  input   io_out_0_d_bits_addr_lo,
  input  [7:0] io_out_0_d_bits_data,
  input   io_out_0_d_bits_error,
  input   io_out_0_e_ready,
  output  io_out_0_e_valid,
  output  io_out_0_e_bits_sink
);
  wire  T_1403;
  wire  Repeater_5_1_clock;
  wire  Repeater_5_1_reset;
  wire  Repeater_5_1_io_repeat;
  wire  Repeater_5_1_io_full;
  wire  Repeater_5_1_io_enq_ready;
  wire  Repeater_5_1_io_enq_valid;
  wire [2:0] Repeater_5_1_io_enq_bits_opcode;
  wire [2:0] Repeater_5_1_io_enq_bits_param;
  wire [2:0] Repeater_5_1_io_enq_bits_size;
  wire [1:0] Repeater_5_1_io_enq_bits_source;
  wire [29:0] Repeater_5_1_io_enq_bits_address;
  wire [3:0] Repeater_5_1_io_enq_bits_mask;
  wire [31:0] Repeater_5_1_io_enq_bits_data;
  wire  Repeater_5_1_io_deq_ready;
  wire  Repeater_5_1_io_deq_valid;
  wire [2:0] Repeater_5_1_io_deq_bits_opcode;
  wire [2:0] Repeater_5_1_io_deq_bits_param;
  wire [2:0] Repeater_5_1_io_deq_bits_size;
  wire [1:0] Repeater_5_1_io_deq_bits_source;
  wire [29:0] Repeater_5_1_io_deq_bits_address;
  wire [3:0] Repeater_5_1_io_deq_bits_mask;
  wire [31:0] Repeater_5_1_io_deq_bits_data;
  wire [7:0] T_1408;
  wire [7:0] T_1409;
  wire [7:0] T_1410;
  wire [7:0] T_1411;
  wire [7:0] T_1419_0;
  wire [7:0] T_1419_1;
  wire [7:0] T_1419_2;
  wire [7:0] T_1419_3;
  wire  T_1426;
  wire  T_1427;
  wire  T_1428;
  wire  T_1429;
  wire  T_1437_0;
  wire  T_1437_1;
  wire  T_1437_2;
  wire  T_1437_3;
  reg [3:0] T_1447;
  reg [31:0] GEN_28;
  wire [8:0] T_1458;
  wire [1:0] T_1459;
  wire [1:0] T_1460;
  wire  T_1463;
  wire  T_1465;
  wire  T_1466;
  wire  T_1468;
  wire  T_1472;
  wire [1:0] T_1473;
  wire [1:0] T_1474;
  wire [3:0] T_1475;
  wire [4:0] GEN_12;
  wire [4:0] T_1476;
  wire [4:0] T_1477;
  wire  T_1482;
  wire [4:0] GEN_2;
  wire [1:0] T_1487;
  wire [1:0] T_1488;
  wire [3:0] T_1489;
  wire [4:0] GEN_13;
  wire [4:0] T_1490;
  wire  T_1492;
  wire  T_1493;
  wire  T_1494;
  wire  T_1495;
  wire  T_1497;
  wire  T_1499;
  wire  T_1501;
  wire  T_1503;
  wire  T_1505;
  wire  T_1506;
  wire  T_1507;
  wire  T_1508;
  reg [23:0] T_1512;
  reg [31:0] GEN_29;
  reg [2:0] T_1514;
  reg [31:0] GEN_30;
  wire [31:0] T_1515;
  wire [3:0] T_1523;
  reg [1:0] T_1527;
  reg [31:0] GEN_31;
  wire [8:0] T_1532;
  wire [1:0] T_1533;
  wire [1:0] T_1534;
  wire  T_1536;
  wire  T_1540;
  wire [23:0] T_1541;
  wire [2:0] T_1542;
  wire [2:0] T_1544;
  wire [1:0] T_1545;
  wire [1:0] GEN_3;
  wire [23:0] GEN_4;
  wire [2:0] GEN_5;
  wire [1:0] GEN_6;
  wire [7:0] T_1547;
  wire [15:0] T_1548;
  wire [31:0] T_1549;
  wire  T_1550;
  wire [3:0] T_1554;
  wire [15:0] T_1555;
  wire [31:0] T_1556;
  wire [1:0] T_1557;
  wire [3:0] T_1558;
  wire [31:0] T_1570_0;
  wire [31:0] T_1570_1;
  wire [31:0] T_1570_2;
  wire [31:0] T_1570_3;
  wire [31:0] T_1570_4;
  wire [31:0] T_1570_5;
  wire [3:0] T_1588_0;
  wire [3:0] T_1588_1;
  wire [3:0] T_1588_2;
  wire [3:0] T_1588_3;
  wire [3:0] T_1588_4;
  wire [3:0] T_1588_5;
  wire  T_1599;
  wire  T_1600;
  wire  T_1601;
  wire [31:0] GEN_0;
  wire [31:0] GEN_7;
  wire [31:0] GEN_8;
  wire [31:0] GEN_9;
  wire [31:0] GEN_10;
  wire [31:0] GEN_11;
  wire [2:0] GEN_1 = 3'b0;
  reg [31:0] GEN_32;
  wire [1:0] GEN_14 = 2'b0;
  reg [31:0] GEN_33;
  wire [2:0] GEN_15 = 3'b0;
  reg [31:0] GEN_34;
  wire [1:0] GEN_16 = 2'b0;
  reg [31:0] GEN_35;
  wire [29:0] GEN_17 = 30'b0;
  reg [31:0] GEN_36;
  wire [3:0] GEN_18 = 4'b0;
  reg [31:0] GEN_37;
  wire [31:0] GEN_19 = 32'b0;
  reg [31:0] GEN_38;
  wire [2:0] GEN_20 = 3'b0;
  reg [31:0] GEN_39;
  wire [2:0] GEN_21 = 3'b0;
  reg [31:0] GEN_40;
  wire [2:0] GEN_22 = 3'b0;
  reg [31:0] GEN_41;
  wire [1:0] GEN_23 = 2'b0;
  reg [31:0] GEN_42;
  wire [29:0] GEN_24 = 30'b0;
  reg [31:0] GEN_43;
  wire [7:0] GEN_25 = 8'b0;
  reg [31:0] GEN_44;
  wire  GEN_26 = 1'b0;
  reg [31:0] GEN_45;
  wire  GEN_27 = 1'b0;
  reg [31:0] GEN_46;
  sirv_tl_repeater_5 Repeater_5_1 (
    .clock(Repeater_5_1_clock),
    .reset(Repeater_5_1_reset),
    .io_repeat(Repeater_5_1_io_repeat),
    .io_full(Repeater_5_1_io_full),
    .io_enq_ready(Repeater_5_1_io_enq_ready),
    .io_enq_valid(Repeater_5_1_io_enq_valid),
    .io_enq_bits_opcode(Repeater_5_1_io_enq_bits_opcode),
    .io_enq_bits_param(Repeater_5_1_io_enq_bits_param),
    .io_enq_bits_size(Repeater_5_1_io_enq_bits_size),
    .io_enq_bits_source(Repeater_5_1_io_enq_bits_source),
    .io_enq_bits_address(Repeater_5_1_io_enq_bits_address),
    .io_enq_bits_mask(Repeater_5_1_io_enq_bits_mask),
    .io_enq_bits_data(Repeater_5_1_io_enq_bits_data),
    .io_deq_ready(Repeater_5_1_io_deq_ready),
    .io_deq_valid(Repeater_5_1_io_deq_valid),
    .io_deq_bits_opcode(Repeater_5_1_io_deq_bits_opcode),
    .io_deq_bits_param(Repeater_5_1_io_deq_bits_param),
    .io_deq_bits_size(Repeater_5_1_io_deq_bits_size),
    .io_deq_bits_source(Repeater_5_1_io_deq_bits_source),
    .io_deq_bits_address(Repeater_5_1_io_deq_bits_address),
    .io_deq_bits_mask(Repeater_5_1_io_deq_bits_mask),
    .io_deq_bits_data(Repeater_5_1_io_deq_bits_data)
  );
  assign io_in_0_a_ready = Repeater_5_1_io_enq_ready;
  assign io_in_0_b_valid = 1'h0;
  assign io_in_0_b_bits_opcode = GEN_1;
  assign io_in_0_b_bits_param = GEN_14;
  assign io_in_0_b_bits_size = GEN_15;
  assign io_in_0_b_bits_source = GEN_16;
  assign io_in_0_b_bits_address = GEN_17;
  assign io_in_0_b_bits_mask = GEN_18;
  assign io_in_0_b_bits_data = GEN_19;
  assign io_in_0_c_ready = 1'h1;
  assign io_in_0_d_valid = T_1601;
  assign io_in_0_d_bits_opcode = io_out_0_d_bits_opcode;
  assign io_in_0_d_bits_param = io_out_0_d_bits_param;
  assign io_in_0_d_bits_size = io_out_0_d_bits_size;
  assign io_in_0_d_bits_source = io_out_0_d_bits_source;
  assign io_in_0_d_bits_sink = io_out_0_d_bits_sink;
  assign io_in_0_d_bits_addr_lo = {{1'd0}, io_out_0_d_bits_addr_lo};
  assign io_in_0_d_bits_data = GEN_0;
  assign io_in_0_d_bits_error = io_out_0_d_bits_error;
  assign io_in_0_e_ready = 1'h1;
  assign io_out_0_a_valid = Repeater_5_1_io_deq_valid;
  assign io_out_0_a_bits_opcode = Repeater_5_1_io_deq_bits_opcode;
  assign io_out_0_a_bits_param = Repeater_5_1_io_deq_bits_param;
  assign io_out_0_a_bits_size = Repeater_5_1_io_deq_bits_size;
  assign io_out_0_a_bits_source = Repeater_5_1_io_deq_bits_source;
  assign io_out_0_a_bits_address = Repeater_5_1_io_deq_bits_address;
  assign io_out_0_a_bits_mask = T_1508;
  assign io_out_0_a_bits_data = 8'h0;
  assign io_out_0_b_ready = 1'h1;
  assign io_out_0_c_valid = 1'h0;
  assign io_out_0_c_bits_opcode = GEN_20;
  assign io_out_0_c_bits_param = GEN_21;
  assign io_out_0_c_bits_size = GEN_22;
  assign io_out_0_c_bits_source = GEN_23;
  assign io_out_0_c_bits_address = GEN_24;
  assign io_out_0_c_bits_data = GEN_25;
  assign io_out_0_c_bits_error = GEN_26;
  assign io_out_0_d_ready = T_1600;
  assign io_out_0_e_valid = 1'h0;
  assign io_out_0_e_bits_sink = GEN_27;
  assign T_1403 = 1'h0;
  assign Repeater_5_1_clock = clock;
  assign Repeater_5_1_reset = reset;
  assign Repeater_5_1_io_repeat = T_1403;
  assign Repeater_5_1_io_enq_valid = io_in_0_a_valid;
  assign Repeater_5_1_io_enq_bits_opcode = io_in_0_a_bits_opcode;
  assign Repeater_5_1_io_enq_bits_param = io_in_0_a_bits_param;
  assign Repeater_5_1_io_enq_bits_size = io_in_0_a_bits_size;
  assign Repeater_5_1_io_enq_bits_source = io_in_0_a_bits_source;
  assign Repeater_5_1_io_enq_bits_address = io_in_0_a_bits_address;
  assign Repeater_5_1_io_enq_bits_mask = io_in_0_a_bits_mask;
  assign Repeater_5_1_io_enq_bits_data = io_in_0_a_bits_data;
  assign Repeater_5_1_io_deq_ready = io_out_0_a_ready;
  assign T_1408 = Repeater_5_1_io_deq_bits_data[7:0];
  assign T_1409 = Repeater_5_1_io_deq_bits_data[15:8];
  assign T_1410 = Repeater_5_1_io_deq_bits_data[23:16];
  assign T_1411 = Repeater_5_1_io_deq_bits_data[31:24];
  assign T_1419_0 = T_1408;
  assign T_1419_1 = T_1409;
  assign T_1419_2 = T_1410;
  assign T_1419_3 = T_1411;
  assign T_1426 = Repeater_5_1_io_deq_bits_mask[0];
  assign T_1427 = Repeater_5_1_io_deq_bits_mask[1];
  assign T_1428 = Repeater_5_1_io_deq_bits_mask[2];
  assign T_1429 = Repeater_5_1_io_deq_bits_mask[3];
  assign T_1437_0 = T_1426;
  assign T_1437_1 = T_1427;
  assign T_1437_2 = T_1428;
  assign T_1437_3 = T_1429;
  assign T_1458 = 9'h3 << Repeater_5_1_io_deq_bits_size;
  assign T_1459 = T_1458[1:0];
  assign T_1460 = ~ T_1459;
  assign T_1463 = T_1460[0];
  assign T_1465 = T_1463 == 1'h0;
  assign T_1466 = T_1460[1];
  assign T_1468 = T_1466 == 1'h0;
  assign T_1472 = T_1447[3];
  assign T_1473 = {T_1465,1'h1};
  assign T_1474 = {T_1465,T_1468};
  assign T_1475 = {T_1474,T_1473};
  assign GEN_12 = {{1'd0}, T_1447};
  assign T_1476 = GEN_12 << 1;
  assign T_1477 = T_1472 ? {{1'd0}, T_1475} : T_1476;
  assign T_1482 = io_out_0_a_ready & io_out_0_a_valid;
  assign GEN_2 = T_1482 ? 5'hf : {{1'd0}, T_1447};
  assign T_1487 = {T_1437_1,T_1437_0};
  assign T_1488 = {T_1437_3,T_1437_2};
  assign T_1489 = {T_1488,T_1487};
  assign GEN_13 = {{1'd0}, T_1489};
  assign T_1490 = GEN_13 & T_1477;
  assign T_1492 = T_1490[0];
  assign T_1493 = T_1490[1];
  assign T_1494 = T_1490[2];
  assign T_1495 = T_1490[3];
  assign T_1497 = T_1492 ? T_1437_0 : 1'h0;
  assign T_1499 = T_1493 ? T_1437_1 : 1'h0;
  assign T_1501 = T_1494 ? T_1437_2 : 1'h0;
  assign T_1503 = T_1495 ? T_1437_3 : 1'h0;
  assign T_1505 = T_1497 | T_1499;
  assign T_1506 = T_1505 | T_1501;
  assign T_1507 = T_1506 | T_1503;
  assign T_1508 = T_1507;
  assign T_1515 = {io_out_0_d_bits_data,T_1512};
  assign T_1523 = {1'h1,T_1514};
  assign T_1532 = 9'h3 << io_out_0_d_bits_size;
  assign T_1533 = T_1532[1:0];
  assign T_1534 = ~ T_1533;
  assign T_1536 = T_1527 == T_1534;
  assign T_1540 = io_out_0_d_ready & io_out_0_d_valid;
  assign T_1541 = T_1515[31:8];
  assign T_1542 = T_1523[3:1];
  assign T_1544 = T_1527 + 2'h1;
  assign T_1545 = T_1544[1:0];
  assign GEN_3 = T_1536 ? 2'h0 : T_1545;
  assign GEN_4 = T_1540 ? T_1541 : T_1512;
  assign GEN_5 = T_1540 ? T_1542 : T_1514;
  assign GEN_6 = T_1540 ? GEN_3 : T_1527;
  assign T_1547 = T_1515[31:24];
  assign T_1548 = {T_1547,T_1547};
  assign T_1549 = {T_1548,T_1548};
  assign T_1550 = T_1523[3];
  assign T_1554 = T_1550 ? 4'hf : 4'h0;
  assign T_1555 = T_1515[31:16];
  assign T_1556 = {T_1555,T_1555};
  assign T_1557 = T_1523[3:2];
  assign T_1558 = {T_1557,T_1557};
  assign T_1570_0 = T_1549;
  assign T_1570_1 = T_1556;
  assign T_1570_2 = T_1515;
  assign T_1570_3 = T_1515;
  assign T_1570_4 = T_1515;
  assign T_1570_5 = T_1515;
  assign T_1588_0 = T_1554;
  assign T_1588_1 = T_1558;
  assign T_1588_2 = T_1523;
  assign T_1588_3 = T_1523;
  assign T_1588_4 = T_1523;
  assign T_1588_5 = T_1523;
  assign T_1599 = T_1536 == 1'h0;
  assign T_1600 = io_in_0_d_ready | T_1599;
  assign T_1601 = io_out_0_d_valid & T_1536;
  assign GEN_0 = GEN_11;
  assign GEN_7 = 3'h1 == io_out_0_d_bits_size ? T_1570_1 : T_1570_0;
  assign GEN_8 = 3'h2 == io_out_0_d_bits_size ? T_1570_2 : GEN_7;
  assign GEN_9 = 3'h3 == io_out_0_d_bits_size ? T_1570_3 : GEN_8;
  assign GEN_10 = 3'h4 == io_out_0_d_bits_size ? T_1570_4 : GEN_9;
  assign GEN_11 = 3'h5 == io_out_0_d_bits_size ? T_1570_5 : GEN_10;

  always @(posedge clock or posedge reset) 
    if (reset) begin
      T_1447 <= 4'hf;
    end else begin
      T_1447 <= GEN_2[3:0];
    end


  always @(posedge clock or posedge reset) 
  if (reset) begin
      T_1512 <= 24'b0;
      T_1514 <= 3'b0;
  end
  else begin
    if (T_1540) begin
      T_1512 <= T_1541;
    end
    if (T_1540) begin
      T_1514 <= T_1542;
    end
  end


  always @(posedge clock or posedge reset) 
    if (reset) begin
      T_1527 <= 2'h0;
    end else begin
      if (T_1540) begin
        if (T_1536) begin
          T_1527 <= 2'h0;
        end else begin
          T_1527 <= T_1545;
        end
      end
    end

endmodule
