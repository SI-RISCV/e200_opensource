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
                                                                         
                                                                         
                                                                         

module sirv_tlfragmenter_qspi_1(
  input   clock,
  input   reset,
  output  io_in_0_a_ready,
  input   io_in_0_a_valid,
  input  [2:0] io_in_0_a_bits_opcode,
  input  [2:0] io_in_0_a_bits_param,
  input  [2:0] io_in_0_a_bits_size,
  input  [1:0] io_in_0_a_bits_source,
  input  [29:0] io_in_0_a_bits_address,
  input   io_in_0_a_bits_mask,
  input  [7:0] io_in_0_a_bits_data,
  input   io_in_0_b_ready,
  output  io_in_0_b_valid,
  output [2:0] io_in_0_b_bits_opcode,
  output [1:0] io_in_0_b_bits_param,
  output [2:0] io_in_0_b_bits_size,
  output [1:0] io_in_0_b_bits_source,
  output [29:0] io_in_0_b_bits_address,
  output  io_in_0_b_bits_mask,
  output [7:0] io_in_0_b_bits_data,
  output  io_in_0_c_ready,
  input   io_in_0_c_valid,
  input  [2:0] io_in_0_c_bits_opcode,
  input  [2:0] io_in_0_c_bits_param,
  input  [2:0] io_in_0_c_bits_size,
  input  [1:0] io_in_0_c_bits_source,
  input  [29:0] io_in_0_c_bits_address,
  input  [7:0] io_in_0_c_bits_data,
  input   io_in_0_c_bits_error,
  input   io_in_0_d_ready,
  output  io_in_0_d_valid,
  output [2:0] io_in_0_d_bits_opcode,
  output [1:0] io_in_0_d_bits_param,
  output [2:0] io_in_0_d_bits_size,
  output [1:0] io_in_0_d_bits_source,
  output  io_in_0_d_bits_sink,
  output  io_in_0_d_bits_addr_lo,
  output [7:0] io_in_0_d_bits_data,
  output  io_in_0_d_bits_error,
  output  io_in_0_e_ready,
  input   io_in_0_e_valid,
  input   io_in_0_e_bits_sink,
  input   io_out_0_a_ready,
  output  io_out_0_a_valid,
  output [2:0] io_out_0_a_bits_opcode,
  output [2:0] io_out_0_a_bits_param,
  output [2:0] io_out_0_a_bits_size,
  output [6:0] io_out_0_a_bits_source,
  output [29:0] io_out_0_a_bits_address,
  output  io_out_0_a_bits_mask,
  output [7:0] io_out_0_a_bits_data,
  output  io_out_0_b_ready,
  input   io_out_0_b_valid,
  input  [2:0] io_out_0_b_bits_opcode,
  input  [1:0] io_out_0_b_bits_param,
  input  [2:0] io_out_0_b_bits_size,
  input  [6:0] io_out_0_b_bits_source,
  input  [29:0] io_out_0_b_bits_address,
  input   io_out_0_b_bits_mask,
  input  [7:0] io_out_0_b_bits_data,
  input   io_out_0_c_ready,
  output  io_out_0_c_valid,
  output [2:0] io_out_0_c_bits_opcode,
  output [2:0] io_out_0_c_bits_param,
  output [2:0] io_out_0_c_bits_size,
  output [6:0] io_out_0_c_bits_source,
  output [29:0] io_out_0_c_bits_address,
  output [7:0] io_out_0_c_bits_data,
  output  io_out_0_c_bits_error,
  output  io_out_0_d_ready,
  input   io_out_0_d_valid,
  input  [2:0] io_out_0_d_bits_opcode,
  input  [1:0] io_out_0_d_bits_param,
  input  [2:0] io_out_0_d_bits_size,
  input  [6:0] io_out_0_d_bits_source,
  input   io_out_0_d_bits_sink,
  input   io_out_0_d_bits_addr_lo,
  input  [7:0] io_out_0_d_bits_data,
  input   io_out_0_d_bits_error,
  input   io_out_0_e_ready,
  output  io_out_0_e_valid,
  output  io_out_0_e_bits_sink
);
  reg [4:0] acknum;
  reg [31:0] GEN_25;
  reg [2:0] dOrig;
  reg [31:0] GEN_26;
  wire [4:0] dFragnum;
  wire  dFirst;
  wire [7:0] T_1410;
  wire  T_1411;
  wire  dsizeOH1;
  wire  T_1414;
  wire [4:0] GEN_5;
  wire [4:0] T_1415;
  wire  T_1417;
  wire  T_1418;
  wire  T_1419;
  wire  T_1421;
  wire [4:0] dFirst_acknum;
  wire [5:0] GEN_8;
  wire [5:0] T_1428;
  wire [5:0] T_1430;
  wire [5:0] T_1432;
  wire [5:0] T_1433;
  wire [5:0] T_1434;
  wire [1:0] T_1435;
  wire [3:0] T_1436;
  wire  T_1438;
  wire [3:0] GEN_9;
  wire [3:0] T_1439;
  wire [1:0] T_1440;
  wire [1:0] T_1441;
  wire  T_1443;
  wire [1:0] T_1444;
  wire  T_1445;
  wire [1:0] T_1446;
  wire [2:0] dFirst_size;
  wire  T_1447;
  wire [5:0] T_1448;
  wire [4:0] T_1449;
  wire [4:0] T_1450;
  wire [2:0] GEN_0;
  wire [4:0] GEN_1;
  wire [2:0] GEN_2;
  wire  T_1459;
  wire  T_1460;
  wire [1:0] T_1461;
  reg  r_error;
  reg [31:0] GEN_27;
  wire  d_error;
  wire  GEN_3;
  wire  repeater_clock;
  wire  repeater_reset;
  wire  repeater_io_repeat;
  wire  repeater_io_full;
  wire  repeater_io_enq_ready;
  wire  repeater_io_enq_valid;
  wire [2:0] repeater_io_enq_bits_opcode;
  wire [2:0] repeater_io_enq_bits_param;
  wire [2:0] repeater_io_enq_bits_size;
  wire [1:0] repeater_io_enq_bits_source;
  wire [29:0] repeater_io_enq_bits_address;
  wire  repeater_io_enq_bits_mask;
  wire [7:0] repeater_io_enq_bits_data;
  wire  repeater_io_deq_ready;
  wire  repeater_io_deq_valid;
  wire [2:0] repeater_io_deq_bits_opcode;
  wire [2:0] repeater_io_deq_bits_param;
  wire [2:0] repeater_io_deq_bits_size;
  wire [1:0] repeater_io_deq_bits_source;
  wire [29:0] repeater_io_deq_bits_address;
  wire  repeater_io_deq_bits_mask;
  wire [7:0] repeater_io_deq_bits_data;
  wire  find_0;
  wire  T_1494;
  wire [2:0] aFrag;
  wire [11:0] T_1497;
  wire [4:0] T_1498;
  wire [4:0] aOrigOH1;
  wire [7:0] T_1501;
  wire  T_1502;
  wire  aFragOH1;
  reg [4:0] gennum;
  reg [31:0] GEN_28;
  wire  aFirst;
  wire [5:0] T_1511;
  wire [4:0] T_1512;
  wire [4:0] old_gennum1;
  wire [4:0] T_1513;
  wire [4:0] GEN_10;
  wire [4:0] T_1515;
  wire [4:0] new_gennum;
  wire  T_1520;
  wire [4:0] GEN_4;
  wire  T_1524;
  wire [4:0] T_1526;
  wire [4:0] T_1528;
  wire [29:0] GEN_12;
  wire [29:0] T_1529;
  wire [6:0] T_1530;
  wire  T_1532;
  wire  T_1541;
  wire  T_1542;
  wire  T_1543;
  wire  T_1545;
  wire  T_1546;
  wire [2:0] GEN_6 = 3'b0;
  reg [31:0] GEN_29;
  wire [1:0] GEN_7 = 2'b0;
  reg [31:0] GEN_30;
  wire [2:0] GEN_11 = 3'b0;
  reg [31:0] GEN_31;
  wire [1:0] GEN_13 = 2'b0;
  reg [31:0] GEN_32;
  wire [29:0] GEN_14 = 30'b0;
  reg [31:0] GEN_33;
  wire  GEN_15 = 1'b0;
  reg [31:0] GEN_34;
  wire [7:0] GEN_16 = 8'b0;
  reg [31:0] GEN_35;
  wire [2:0] GEN_17 = 3'b0;
  reg [31:0] GEN_36;
  wire [2:0] GEN_18 = 3'b0;
  reg [31:0] GEN_37;
  wire [2:0] GEN_19 = 3'b0;
  reg [31:0] GEN_38;
  wire [6:0] GEN_20 = 7'b0;
  reg [31:0] GEN_39;
  wire [29:0] GEN_21 = 30'b0;
  reg [31:0] GEN_40;
  wire [7:0] GEN_22 = 8'b0;
  reg [31:0] GEN_41;
  wire  GEN_23 = 1'b0;
  reg [31:0] GEN_42;
  wire  GEN_24 = 1'b0;
  reg [31:0] GEN_43;
  sirv_repeater_6 u_repeater (
    .clock(repeater_clock),
    .reset(repeater_reset),
    .io_repeat(repeater_io_repeat),
    .io_full(repeater_io_full),
    .io_enq_ready(repeater_io_enq_ready),
    .io_enq_valid(repeater_io_enq_valid),
    .io_enq_bits_opcode(repeater_io_enq_bits_opcode),
    .io_enq_bits_param(repeater_io_enq_bits_param),
    .io_enq_bits_size(repeater_io_enq_bits_size),
    .io_enq_bits_source(repeater_io_enq_bits_source),
    .io_enq_bits_address(repeater_io_enq_bits_address),
    .io_enq_bits_mask(repeater_io_enq_bits_mask),
    .io_enq_bits_data(repeater_io_enq_bits_data),
    .io_deq_ready(repeater_io_deq_ready),
    .io_deq_valid(repeater_io_deq_valid),
    .io_deq_bits_opcode(repeater_io_deq_bits_opcode),
    .io_deq_bits_param(repeater_io_deq_bits_param),
    .io_deq_bits_size(repeater_io_deq_bits_size),
    .io_deq_bits_source(repeater_io_deq_bits_source),
    .io_deq_bits_address(repeater_io_deq_bits_address),
    .io_deq_bits_mask(repeater_io_deq_bits_mask),
    .io_deq_bits_data(repeater_io_deq_bits_data)
  );
  assign io_in_0_a_ready = repeater_io_enq_ready;
  assign io_in_0_b_valid = 1'h0;
  assign io_in_0_b_bits_opcode = GEN_6;
  assign io_in_0_b_bits_param = GEN_7;
  assign io_in_0_b_bits_size = GEN_11;
  assign io_in_0_b_bits_source = GEN_13;
  assign io_in_0_b_bits_address = GEN_14;
  assign io_in_0_b_bits_mask = GEN_15;
  assign io_in_0_b_bits_data = GEN_16;
  assign io_in_0_c_ready = 1'h1;
  assign io_in_0_d_valid = io_out_0_d_valid;
  assign io_in_0_d_bits_opcode = io_out_0_d_bits_opcode;
  assign io_in_0_d_bits_param = io_out_0_d_bits_param;
  assign io_in_0_d_bits_size = GEN_0;
  assign io_in_0_d_bits_source = T_1461;
  assign io_in_0_d_bits_sink = io_out_0_d_bits_sink;
  assign io_in_0_d_bits_addr_lo = T_1460;
  assign io_in_0_d_bits_data = io_out_0_d_bits_data;
  assign io_in_0_d_bits_error = d_error;
  assign io_in_0_e_ready = 1'h1;
  assign io_out_0_a_valid = repeater_io_deq_valid;
  assign io_out_0_a_bits_opcode = repeater_io_deq_bits_opcode;
  assign io_out_0_a_bits_param = repeater_io_deq_bits_param;
  assign io_out_0_a_bits_size = aFrag;
  assign io_out_0_a_bits_source = T_1530;
  assign io_out_0_a_bits_address = T_1529;
  assign io_out_0_a_bits_mask = T_1546;
  assign io_out_0_a_bits_data = io_in_0_a_bits_data;
  assign io_out_0_b_ready = 1'h1;
  assign io_out_0_c_valid = 1'h0;
  assign io_out_0_c_bits_opcode = GEN_17;
  assign io_out_0_c_bits_param = GEN_18;
  assign io_out_0_c_bits_size = GEN_19;
  assign io_out_0_c_bits_source = GEN_20;
  assign io_out_0_c_bits_address = GEN_21;
  assign io_out_0_c_bits_data = GEN_22;
  assign io_out_0_c_bits_error = GEN_23;
  assign io_out_0_d_ready = io_in_0_d_ready;
  assign io_out_0_e_valid = 1'h0;
  assign io_out_0_e_bits_sink = GEN_24;
  assign dFragnum = io_out_0_d_bits_source[4:0];
  assign dFirst = acknum == 5'h0;
  assign T_1410 = 8'h1 << io_out_0_d_bits_size;
  assign T_1411 = T_1410[0];
  assign dsizeOH1 = ~ T_1411;
  assign T_1414 = io_out_0_d_valid == 1'h0;
  assign GEN_5 = {{4'd0}, dsizeOH1};
  assign T_1415 = dFragnum & GEN_5;
  assign T_1417 = T_1415 == 5'h0;
  assign T_1418 = T_1414 | T_1417;
  assign T_1419 = T_1418 | reset;
  assign T_1421 = T_1419 == 1'h0;
  assign dFirst_acknum = dFragnum | GEN_5;
  assign GEN_8 = {{1'd0}, dFirst_acknum};
  assign T_1428 = GEN_8 << 1;
  assign T_1430 = T_1428 | 6'h1;
  assign T_1432 = {1'h0,dFirst_acknum};
  assign T_1433 = ~ T_1432;
  assign T_1434 = T_1430 & T_1433;
  assign T_1435 = T_1434[5:4];
  assign T_1436 = T_1434[3:0];
  assign T_1438 = T_1435 != 2'h0;
  assign GEN_9 = {{2'd0}, T_1435};
  assign T_1439 = GEN_9 | T_1436;
  assign T_1440 = T_1439[3:2];
  assign T_1441 = T_1439[1:0];
  assign T_1443 = T_1440 != 2'h0;
  assign T_1444 = T_1440 | T_1441;
  assign T_1445 = T_1444[1];
  assign T_1446 = {T_1443,T_1445};
  assign dFirst_size = {T_1438,T_1446};
  assign T_1447 = io_out_0_d_ready & io_out_0_d_valid;
  assign T_1448 = acknum - 5'h1;
  assign T_1449 = T_1448[4:0];
  assign T_1450 = dFirst ? dFirst_acknum : T_1449;
  assign GEN_0 = dFirst ? dFirst_size : dOrig;
  assign GEN_1 = T_1447 ? T_1450 : acknum;
  assign GEN_2 = T_1447 ? GEN_0 : dOrig;
  assign T_1459 = ~ dsizeOH1;
  assign T_1460 = io_out_0_d_bits_addr_lo & T_1459;
  assign T_1461 = io_out_0_d_bits_source[6:5];
  assign d_error = r_error | io_out_0_d_bits_error;
  assign GEN_3 = T_1447 ? 1'h0 : r_error;
  assign repeater_clock = clock;
  assign repeater_reset = reset;
  assign repeater_io_repeat = T_1524;
  assign repeater_io_enq_valid = io_in_0_a_valid;
  assign repeater_io_enq_bits_opcode = io_in_0_a_bits_opcode;
  assign repeater_io_enq_bits_param = io_in_0_a_bits_param;
  assign repeater_io_enq_bits_size = io_in_0_a_bits_size;
  assign repeater_io_enq_bits_source = io_in_0_a_bits_source;
  assign repeater_io_enq_bits_address = io_in_0_a_bits_address;
  assign repeater_io_enq_bits_mask = io_in_0_a_bits_mask;
  assign repeater_io_enq_bits_data = io_in_0_a_bits_data;
  assign repeater_io_deq_ready = io_out_0_a_ready;
  assign find_0 = 1'h1;
  assign T_1494 = repeater_io_deq_bits_size > 3'h0;
  assign aFrag = T_1494 ? 3'h0 : repeater_io_deq_bits_size;
  assign T_1497 = 12'h1f << repeater_io_deq_bits_size;
  assign T_1498 = T_1497[4:0];
  assign aOrigOH1 = ~ T_1498;
  assign T_1501 = 8'h1 << aFrag;
  assign T_1502 = T_1501[0];
  assign aFragOH1 = ~ T_1502;
  assign aFirst = gennum == 5'h0;
  assign T_1511 = gennum - 5'h1;
  assign T_1512 = T_1511[4:0];
  assign old_gennum1 = aFirst ? aOrigOH1 : T_1512;
  assign T_1513 = ~ old_gennum1;
  assign GEN_10 = {{4'd0}, aFragOH1};
  assign T_1515 = T_1513 | GEN_10;
  assign new_gennum = ~ T_1515;
  assign T_1520 = io_out_0_a_ready & io_out_0_a_valid;
  assign GEN_4 = T_1520 ? new_gennum : gennum;
  assign T_1524 = new_gennum != 5'h0;
  assign T_1526 = ~ new_gennum;
  assign T_1528 = T_1526 & aOrigOH1;
  assign GEN_12 = {{25'd0}, T_1528};
  assign T_1529 = repeater_io_deq_bits_address | GEN_12;
  assign T_1530 = {repeater_io_deq_bits_source,new_gennum};
  assign T_1532 = repeater_io_full == 1'h0;
  assign T_1541 = repeater_io_deq_bits_mask;
  assign T_1542 = T_1532 | T_1541;
  assign T_1543 = T_1542 | reset;
  assign T_1545 = T_1543 == 1'h0;
  assign T_1546 = repeater_io_full ? 1'h1 : io_in_0_a_bits_mask;

  always @(posedge clock or posedge reset) 
    if (reset) begin
      acknum <= 5'h0;
    end else begin
      if (T_1447) begin
        if (dFirst) begin
          acknum <= dFirst_acknum;
        end else begin
          acknum <= T_1449;
        end
      end
    end


  always @(posedge clock or posedge reset) 
  if (reset) begin
        dOrig <= 3'b0;
  end
  else begin
    if (T_1447) begin
      if (dFirst) begin
        dOrig <= dFirst_size;
      end
    end
  end


  always @(posedge clock or posedge reset) 
    if (reset) begin
      r_error <= 1'h0;
    end else begin
      if (T_1447) begin
        r_error <= 1'h0;
      end
    end

  always @(posedge clock or posedge reset) 
    if (reset) begin
      gennum <= 5'h0;
    end else begin
      if (T_1520) begin
        gennum <= new_gennum;
      end
    end

   // `ifndef SYNTHESIS
   // `ifdef PRINTF_COND
   //   if (`PRINTF_COND) begin
   // `endif
   //     if (T_1421) begin
   //       $fwrite(32'h80000002,"Assertion failed\n    at Fragmenter.scala:149 assert (!out.d.valid || (acknum_fragment & acknum_size) === UInt(0))\n");
   //     end
   // `ifdef PRINTF_COND
   //   end
   // `endif
   // `endif
   // `ifndef SYNTHESIS
   // `ifdef STOP_COND
   //   if (`STOP_COND) begin
   // `endif
   //     if (T_1421) begin
   //       $fatal;
   //     end
   // `ifdef STOP_COND
   //   end
   // `endif
   // `endif
   // `ifndef SYNTHESIS
   // `ifdef PRINTF_COND
   //   if (`PRINTF_COND) begin
   // `endif
   //     if (1'h0) begin
   //       $fwrite(32'h80000002,"Assertion failed\n    at Fragmenter.scala:237 assert (!repeater.io.full || !aHasData)\n");
   //     end
   // `ifdef PRINTF_COND
   //   end
   // `endif
   // `endif
   // `ifndef SYNTHESIS
   // `ifdef STOP_COND
   //   if (`STOP_COND) begin
   // `endif
   //     if (1'h0) begin
   //       $fatal;
   //     end
   // `ifdef STOP_COND
   //   end
   // `endif
   // `endif
   // `ifndef SYNTHESIS
   // `ifdef PRINTF_COND
   //   if (`PRINTF_COND) begin
   // `endif
   //     if (T_1545) begin
   //       $fwrite(32'h80000002,"Assertion failed\n    at Fragmenter.scala:240 assert (!repeater.io.full || in_a.bits.mask === fullMask)\n");
   //     end
   // `ifdef PRINTF_COND
   //   end
   // `endif
   // `endif
   // `ifndef SYNTHESIS
   // `ifdef STOP_COND
   //   if (`STOP_COND) begin
   // `endif
   //     if (T_1545) begin
   //       $fatal;
   //     end
   // `ifdef STOP_COND
   //   end
   // `endif
   // `endif
    //synopsys translate_off
  always @(posedge clock or posedge reset) begin
        if (T_1421) begin
          $fwrite(32'h80000002,"Assertion failed\n    at Fragmenter.scala:149 assert (!out.d.valid || (acknum_fragment & acknum_size) === UInt(0))\n");
        end
        if (T_1545) begin
          $fwrite(32'h80000002,"Assertion failed\n    at Fragmenter.scala:240 assert (!repeater.io.full || in_a.bits.mask === fullMask)\n");
        end
        if (1'h0) begin
          $fwrite(32'h80000002,"Assertion failed\n    at Fragmenter.scala:237 assert (!repeater.io.full || !aHasData)\n");
        end
  end
    //synopsys translate_on
endmodule
