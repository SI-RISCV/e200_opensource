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
                                                                         
                                                                         
                                                                         

module sirv_pmu_core(
  input   clock,
  input   reset,
  input   io_wakeup_awakeup,
  input   io_wakeup_dwakeup,
  input   io_wakeup_rtc,
  input   io_wakeup_reset,
  output  io_control_valid,
  output  io_control_bits_hfclkrst,
  output  io_control_bits_corerst,
  output  io_control_bits_reserved1,
  output  io_control_bits_vddpaden,
  output  io_control_bits_reserved0,
  input  [1:0] io_resetCause,
  input   io_regs_ie_write_valid,
  input  [3:0] io_regs_ie_write_bits,
  output [3:0] io_regs_ie_read,
  input   io_regs_cause_write_valid,
  input  [31:0] io_regs_cause_write_bits,
  output [31:0] io_regs_cause_read,
  input   io_regs_sleep_write_valid,
  input  [31:0] io_regs_sleep_write_bits,
  output [31:0] io_regs_sleep_read,
  input   io_regs_key_write_valid,
  input  [31:0] io_regs_key_write_bits,
  output [31:0] io_regs_key_read,
  input   io_regs_wakeupProgram_0_write_valid,
  input  [31:0] io_regs_wakeupProgram_0_write_bits,
  output [31:0] io_regs_wakeupProgram_0_read,
  input   io_regs_wakeupProgram_1_write_valid,
  input  [31:0] io_regs_wakeupProgram_1_write_bits,
  output [31:0] io_regs_wakeupProgram_1_read,
  input   io_regs_wakeupProgram_2_write_valid,
  input  [31:0] io_regs_wakeupProgram_2_write_bits,
  output [31:0] io_regs_wakeupProgram_2_read,
  input   io_regs_wakeupProgram_3_write_valid,
  input  [31:0] io_regs_wakeupProgram_3_write_bits,
  output [31:0] io_regs_wakeupProgram_3_read,
  input   io_regs_wakeupProgram_4_write_valid,
  input  [31:0] io_regs_wakeupProgram_4_write_bits,
  output [31:0] io_regs_wakeupProgram_4_read,
  input   io_regs_wakeupProgram_5_write_valid,
  input  [31:0] io_regs_wakeupProgram_5_write_bits,
  output [31:0] io_regs_wakeupProgram_5_read,
  input   io_regs_wakeupProgram_6_write_valid,
  input  [31:0] io_regs_wakeupProgram_6_write_bits,
  output [31:0] io_regs_wakeupProgram_6_read,
  input   io_regs_wakeupProgram_7_write_valid,
  input  [31:0] io_regs_wakeupProgram_7_write_bits,
  output [31:0] io_regs_wakeupProgram_7_read,
  input   io_regs_sleepProgram_0_write_valid,
  input  [31:0] io_regs_sleepProgram_0_write_bits,
  output [31:0] io_regs_sleepProgram_0_read,
  input   io_regs_sleepProgram_1_write_valid,
  input  [31:0] io_regs_sleepProgram_1_write_bits,
  output [31:0] io_regs_sleepProgram_1_read,
  input   io_regs_sleepProgram_2_write_valid,
  input  [31:0] io_regs_sleepProgram_2_write_bits,
  output [31:0] io_regs_sleepProgram_2_read,
  input   io_regs_sleepProgram_3_write_valid,
  input  [31:0] io_regs_sleepProgram_3_write_bits,
  output [31:0] io_regs_sleepProgram_3_read,
  input   io_regs_sleepProgram_4_write_valid,
  input  [31:0] io_regs_sleepProgram_4_write_bits,
  output [31:0] io_regs_sleepProgram_4_read,
  input   io_regs_sleepProgram_5_write_valid,
  input  [31:0] io_regs_sleepProgram_5_write_bits,
  output [31:0] io_regs_sleepProgram_5_read,
  input   io_regs_sleepProgram_6_write_valid,
  input  [31:0] io_regs_sleepProgram_6_write_bits,
  output [31:0] io_regs_sleepProgram_6_read,
  input   io_regs_sleepProgram_7_write_valid,
  input  [31:0] io_regs_sleepProgram_7_write_bits,
  output [31:0] io_regs_sleepProgram_7_read
);

  reg  wantSleep;
  reg  run;
  reg [31:0] GEN_37;
  reg  awake;
  reg [31:0] GEN_38;
  wire  T_364;
  wire  T_365;
  wire  T_366;
  wire  T_367;
  wire  T_368;
  wire  T_369;
  wire  T_370;
  wire  T_371;
  wire  T_372;
  wire  T_373;
  wire  T_374;
  wire  T_375;
  wire  T_376;
  wire  T_377;
  wire  T_378;
  wire  T_379;
  wire  T_380;
  wire  T_381;
  wire  T_383;
  wire  T_385;
  wire  T_386;
  wire  T_388;
  reg  unlocked;
  reg [31:0] GEN_39;
  wire  GEN_0;
  wire  T_391;
  reg [31:0] GEN_40;
  wire  GEN_1;
  reg [2:0] pc;
  reg [31:0] GEN_41;
  reg [1:0] wakeupCause;
  reg [31:0] GEN_42;
  wire  T_394;
  reg [3:0] T_396;
  reg [31:0] GEN_43;
  wire [3:0] GEN_2;
  wire [3:0] ie;
  reg [8:0] wakeupProgram_0;
  reg [31:0] GEN_44;
  reg [8:0] wakeupProgram_1;
  reg [31:0] GEN_45;
  reg [8:0] wakeupProgram_2;
  reg [31:0] GEN_46;
  reg [8:0] wakeupProgram_3;
  reg [31:0] GEN_47;
  reg [8:0] wakeupProgram_4;
  reg [31:0] GEN_48;
  reg [8:0] wakeupProgram_5;
  reg [31:0] GEN_49;
  reg [8:0] wakeupProgram_6;
  reg [31:0] GEN_50;
  reg [8:0] wakeupProgram_7;
  reg [31:0] GEN_51;
  reg [8:0] sleepProgram_0;
  reg [31:0] GEN_52;
  reg [8:0] sleepProgram_1;
  reg [31:0] GEN_53;
  reg [8:0] sleepProgram_2;
  reg [31:0] GEN_54;
  reg [8:0] sleepProgram_3;
  reg [31:0] GEN_55;
  reg [8:0] sleepProgram_4;
  reg [31:0] GEN_56;
  reg [8:0] sleepProgram_5;
  reg [31:0] GEN_57;
  reg [8:0] sleepProgram_6;
  reg [31:0] GEN_58;
  reg [8:0] sleepProgram_7;
  reg [31:0] GEN_59;
  wire [2:0] T_423;
  wire  T_425;
  wire [2:0] T_427;
  wire  T_429;
  wire  T_433;
  wire [8:0] T_434;
  wire [8:0] T_439;
  wire [8:0] T_440;
  wire [8:0] T_449;
  wire [8:0] T_454;
  wire [8:0] T_455;
  wire [8:0] T_456;
  wire [8:0] T_469;
  wire [8:0] T_474;
  wire [8:0] T_475;
  wire [8:0] T_484;
  wire [8:0] T_489;
  wire [8:0] T_490;
  wire [8:0] T_491;
  wire [8:0] insnBits;
  wire  insn_sigs_hfclkrst;
  wire  insn_sigs_corerst;
  wire  insn_sigs_reserved1;
  wire  insn_sigs_vddpaden;
  wire  insn_sigs_reserved0;
  wire [3:0] insn_dt;
  wire [3:0] T_515;
  wire  T_516;
  wire  T_517;
  wire  T_518;
  wire  T_519;
  wire  T_520;
  reg [15:0] count;
  reg [31:0] GEN_60;
  wire [16:0] T_523;
  wire [15:0] T_524;
  wire [15:0] T_525;
  wire [15:0] T_526;
  wire  tick;
  wire [3:0] npc;
  wire  last;
  wire  T_530;
  wire  T_531;
  wire  T_532;
  wire [15:0] GEN_3;
  wire  GEN_4;
  wire [3:0] GEN_5;
  wire [15:0] GEN_6;
  wire  GEN_7;
  wire [3:0] GEN_8;
  wire  T_540;
  wire [1:0] T_541;
  wire [1:0] T_542;
  wire [3:0] T_543;
  wire [3:0] T_544;
  wire  T_546;
  wire  T_548;
  wire  T_549;
  wire  T_552;
  wire  T_553;
  wire  T_554;
  wire [1:0] T_560;
  wire [1:0] T_561;
  wire [1:0] T_562;
  wire  GEN_9;
  wire  GEN_10;
  wire [1:0] GEN_11;
  wire  T_563;
  wire  GEN_12;
  wire  GEN_13;
  wire  GEN_14;
  wire  GEN_15;
  wire  GEN_16;
  wire [1:0] GEN_17;
  wire  GEN_18;
  wire [9:0] GEN_35;
  wire [9:0] T_567;
  wire [9:0] GEN_36;
  wire [9:0] T_568;
  wire  T_570;
  wire [31:0] GEN_19;
  wire  T_571;
  wire [31:0] GEN_20;
  wire  T_572;
  wire [31:0] GEN_21;
  wire  T_573;
  wire [31:0] GEN_22;
  wire  T_574;
  wire [31:0] GEN_23;
  wire  T_575;
  wire [31:0] GEN_24;
  wire  T_576;
  wire [31:0] GEN_25;
  wire  T_577;
  wire [31:0] GEN_26;
  wire  T_578;
  wire [31:0] GEN_27;
  wire  T_579;
  wire [31:0] GEN_28;
  wire  T_580;
  wire [31:0] GEN_29;
  wire  T_581;
  wire [31:0] GEN_30;
  wire  T_582;
  wire [31:0] GEN_31;
  wire  T_583;
  wire [31:0] GEN_32;
  wire  T_584;
  wire [31:0] GEN_33;
  wire  T_585;
  wire [31:0] GEN_34;
  assign io_control_valid = T_532;
  assign io_control_bits_hfclkrst = insn_sigs_hfclkrst;
  assign io_control_bits_corerst = insn_sigs_corerst;
  assign io_control_bits_reserved1 = insn_sigs_reserved1;
  assign io_control_bits_vddpaden = insn_sigs_vddpaden;
  assign io_control_bits_reserved0 = insn_sigs_reserved0;
  assign io_regs_ie_read = ie;
  assign io_regs_cause_read = {{22'd0}, T_568};
  assign io_regs_sleep_read = {31'h0,wantSleep};
  assign io_regs_key_read = {{31'd0}, unlocked};
  assign io_regs_wakeupProgram_0_read = {{23'd0}, wakeupProgram_0};
  assign io_regs_wakeupProgram_1_read = {{23'd0}, wakeupProgram_1};
  assign io_regs_wakeupProgram_2_read = {{23'd0}, wakeupProgram_2};
  assign io_regs_wakeupProgram_3_read = {{23'd0}, wakeupProgram_3};
  assign io_regs_wakeupProgram_4_read = {{23'd0}, wakeupProgram_4};
  assign io_regs_wakeupProgram_5_read = {{23'd0}, wakeupProgram_5};
  assign io_regs_wakeupProgram_6_read = {{23'd0}, wakeupProgram_6};
  assign io_regs_wakeupProgram_7_read = {{23'd0}, wakeupProgram_7};
  assign io_regs_sleepProgram_0_read = {{23'd0}, sleepProgram_0};
  assign io_regs_sleepProgram_1_read = {{23'd0}, sleepProgram_1};
  assign io_regs_sleepProgram_2_read = {{23'd0}, sleepProgram_2};
  assign io_regs_sleepProgram_3_read = {{23'd0}, sleepProgram_3};
  assign io_regs_sleepProgram_4_read = {{23'd0}, sleepProgram_4};
  assign io_regs_sleepProgram_5_read = {{23'd0}, sleepProgram_5};
  assign io_regs_sleepProgram_6_read = {{23'd0}, sleepProgram_6};
  assign io_regs_sleepProgram_7_read = {{23'd0}, sleepProgram_7};
  assign T_364 = io_regs_sleepProgram_0_write_valid | io_regs_sleepProgram_1_write_valid;
  assign T_365 = T_364 | io_regs_sleepProgram_2_write_valid;
  assign T_366 = T_365 | io_regs_sleepProgram_3_write_valid;
  assign T_367 = T_366 | io_regs_sleepProgram_4_write_valid;
  assign T_368 = T_367 | io_regs_sleepProgram_5_write_valid;
  assign T_369 = T_368 | io_regs_sleepProgram_6_write_valid;
  assign T_370 = T_369 | io_regs_sleepProgram_7_write_valid;
  assign T_371 = io_regs_wakeupProgram_0_write_valid | io_regs_wakeupProgram_1_write_valid;
  assign T_372 = T_371 | io_regs_wakeupProgram_2_write_valid;
  assign T_373 = T_372 | io_regs_wakeupProgram_3_write_valid;
  assign T_374 = T_373 | io_regs_wakeupProgram_4_write_valid;
  assign T_375 = T_374 | io_regs_wakeupProgram_5_write_valid;
  assign T_376 = T_375 | io_regs_wakeupProgram_6_write_valid;
  assign T_377 = T_376 | io_regs_wakeupProgram_7_write_valid;
  assign T_378 = T_370 | T_377;
  assign T_379 = T_378 | io_regs_sleep_write_valid;
  assign T_380 = T_379 | io_regs_cause_write_valid;
  assign T_381 = T_380 | io_regs_ie_write_valid;
  assign T_383 = io_regs_key_write_bits == 32'h51f15e;
  assign T_385 = T_381 == 1'h0;
  assign T_386 = T_383 & T_385;
  assign T_388 = io_regs_key_write_valid | T_381;
  assign GEN_0 = T_388 ? T_386 : unlocked;
  assign T_391 = io_regs_sleep_write_valid & unlocked;
  assign GEN_1 = T_391 ? 1'h1 : wantSleep;
  assign T_394 = io_regs_ie_write_valid & unlocked;
  assign GEN_2 = T_394 ? io_regs_ie_write_bits : T_396;
  assign ie = T_396 | 4'h1;
  assign T_423 = pc & 3'h3;
  assign T_425 = pc >= 3'h4;
  assign T_427 = T_423 & 3'h1;
  assign T_429 = T_423 >= 3'h2;
  assign T_433 = T_427 >= 3'h1;
  assign T_434 = T_433 ? wakeupProgram_7 : wakeupProgram_6;
  assign T_439 = T_433 ? wakeupProgram_5 : wakeupProgram_4;
  assign T_440 = T_429 ? T_434 : T_439;
  assign T_449 = T_433 ? wakeupProgram_3 : wakeupProgram_2;
  assign T_454 = T_433 ? wakeupProgram_1 : wakeupProgram_0;
  assign T_455 = T_429 ? T_449 : T_454;
  assign T_456 = T_425 ? T_440 : T_455;
  assign T_469 = T_433 ? sleepProgram_7 : sleepProgram_6;
  assign T_474 = T_433 ? sleepProgram_5 : sleepProgram_4;
  assign T_475 = T_429 ? T_469 : T_474;
  assign T_484 = T_433 ? sleepProgram_3 : sleepProgram_2;
  assign T_489 = T_433 ? sleepProgram_1 : sleepProgram_0;
  assign T_490 = T_429 ? T_484 : T_489;
  assign T_491 = T_425 ? T_475 : T_490;
  assign insnBits = awake ? T_456 : T_491;
  assign insn_sigs_hfclkrst = T_520;
  assign insn_sigs_corerst = T_519;
  assign insn_sigs_reserved1 = T_518;
  assign insn_sigs_vddpaden = T_517;
  assign insn_sigs_reserved0 = T_516;
  assign insn_dt = T_515;
  assign T_515 = insnBits[3:0];
  assign T_516 = insnBits[4];
  assign T_517 = insnBits[5];
  assign T_518 = insnBits[6];
  assign T_519 = insnBits[7];
  assign T_520 = insnBits[8];
  assign T_523 = count + 16'h1;
  assign T_524 = T_523[15:0];
  assign T_525 = count ^ T_524;
  assign T_526 = T_525 >> insn_dt;
  assign tick = T_526[0];
  assign npc = pc + 3'h1;
  assign last = npc >= 4'h8;
  assign T_530 = last == 1'h0;
  assign T_531 = run & T_530;
  assign T_532 = T_531 & tick;
  assign GEN_3 = tick ? 16'h0 : T_524;
  assign GEN_4 = tick ? T_530 : run;
  assign GEN_5 = tick ? npc : {{1'd0}, pc};
  assign GEN_6 = run ? GEN_3 : count;
  assign GEN_7 = run ? GEN_4 : run;
  assign GEN_8 = run ? GEN_5 : {{1'd0}, pc};
  assign T_540 = run == 1'h0;
  assign T_541 = {io_wakeup_rtc,io_wakeup_reset};
  assign T_542 = {io_wakeup_awakeup,io_wakeup_dwakeup};
  assign T_543 = {T_542,T_541};
  assign T_544 = ie & T_543;
  assign T_546 = awake == 1'h0;
  assign T_548 = T_544 != 4'h0;
  assign T_549 = T_546 & T_548;
  assign T_552 = T_544[0];
  assign T_553 = T_544[1];
  assign T_554 = T_544[2];
  assign T_560 = T_554 ? 2'h2 : 2'h3;
  assign T_561 = T_553 ? 2'h1 : T_560;
  assign T_562 = T_552 ? 2'h0 : T_561;
  assign GEN_9 = T_549 ? 1'h1 : GEN_7;
  assign GEN_10 = T_549 ? 1'h1 : awake;
  assign GEN_11 = T_549 ? T_562 : wakeupCause;
  //Bob: here we introduce a core_wfi signal to make sure when the PMU is
  //     going to power down MOFF, the core is really idle (executed wfi)
  //assign T_563 = awake & wantSleep & core_wfi;
  assign T_563 = awake & wantSleep;// Current we dont add it
  assign GEN_12 = T_563 ? 1'h1 : GEN_9;
  assign GEN_13 = T_563 ? 1'h0 : GEN_10;
  assign GEN_14 = T_563 ? 1'h0 : GEN_1;
  assign GEN_15 = T_540 ? GEN_12 : GEN_7;
  assign GEN_16 = T_540 ? GEN_13 : awake;
  assign GEN_17 = T_540 ? GEN_11 : wakeupCause;
  assign GEN_18 = T_540 ? GEN_14 : GEN_1;
  assign GEN_35 = {{8'd0}, io_resetCause};
  assign T_567 = GEN_35 << 8;
  assign GEN_36 = {{8'd0}, wakeupCause};
  assign T_568 = GEN_36 | T_567;
  assign T_570 = io_regs_wakeupProgram_0_write_valid & unlocked;
  assign GEN_19 = T_570 ? io_regs_wakeupProgram_0_write_bits : {{23'd0}, wakeupProgram_0};
  assign T_571 = io_regs_wakeupProgram_1_write_valid & unlocked;
  assign GEN_20 = T_571 ? io_regs_wakeupProgram_1_write_bits : {{23'd0}, wakeupProgram_1};
  assign T_572 = io_regs_wakeupProgram_2_write_valid & unlocked;
  assign GEN_21 = T_572 ? io_regs_wakeupProgram_2_write_bits : {{23'd0}, wakeupProgram_2};
  assign T_573 = io_regs_wakeupProgram_3_write_valid & unlocked;
  assign GEN_22 = T_573 ? io_regs_wakeupProgram_3_write_bits : {{23'd0}, wakeupProgram_3};
  assign T_574 = io_regs_wakeupProgram_4_write_valid & unlocked;
  assign GEN_23 = T_574 ? io_regs_wakeupProgram_4_write_bits : {{23'd0}, wakeupProgram_4};
  assign T_575 = io_regs_wakeupProgram_5_write_valid & unlocked;
  assign GEN_24 = T_575 ? io_regs_wakeupProgram_5_write_bits : {{23'd0}, wakeupProgram_5};
  assign T_576 = io_regs_wakeupProgram_6_write_valid & unlocked;
  assign GEN_25 = T_576 ? io_regs_wakeupProgram_6_write_bits : {{23'd0}, wakeupProgram_6};
  assign T_577 = io_regs_wakeupProgram_7_write_valid & unlocked;
  assign GEN_26 = T_577 ? io_regs_wakeupProgram_7_write_bits : {{23'd0}, wakeupProgram_7};
  assign T_578 = io_regs_sleepProgram_0_write_valid & unlocked;
  assign GEN_27 = T_578 ? io_regs_sleepProgram_0_write_bits : {{23'd0}, sleepProgram_0};
  assign T_579 = io_regs_sleepProgram_1_write_valid & unlocked;
  assign GEN_28 = T_579 ? io_regs_sleepProgram_1_write_bits : {{23'd0}, sleepProgram_1};
  assign T_580 = io_regs_sleepProgram_2_write_valid & unlocked;
  assign GEN_29 = T_580 ? io_regs_sleepProgram_2_write_bits : {{23'd0}, sleepProgram_2};
  assign T_581 = io_regs_sleepProgram_3_write_valid & unlocked;
  assign GEN_30 = T_581 ? io_regs_sleepProgram_3_write_bits : {{23'd0}, sleepProgram_3};
  assign T_582 = io_regs_sleepProgram_4_write_valid & unlocked;
  assign GEN_31 = T_582 ? io_regs_sleepProgram_4_write_bits : {{23'd0}, sleepProgram_4};
  assign T_583 = io_regs_sleepProgram_5_write_valid & unlocked;
  assign GEN_32 = T_583 ? io_regs_sleepProgram_5_write_bits : {{23'd0}, sleepProgram_5};
  assign T_584 = io_regs_sleepProgram_6_write_valid & unlocked;
  assign GEN_33 = T_584 ? io_regs_sleepProgram_6_write_bits : {{23'd0}, sleepProgram_6};
  assign T_585 = io_regs_sleepProgram_7_write_valid & unlocked;
  assign GEN_34 = T_585 ? io_regs_sleepProgram_7_write_bits : {{23'd0}, sleepProgram_7};

  always @(posedge clock or posedge reset)
    if (reset) begin
      run <= 1'h1;
    end else begin
      if (T_540) begin
        if (T_563) begin
          run <= 1'h1;
        end else begin
          if (T_549) begin
            run <= 1'h1;
          end else begin
            if (run) begin
              if (tick) begin
                run <= T_530;
              end
            end
          end
        end
      end else begin
        if (run) begin
          if (tick) begin
            run <= T_530;
          end
        end
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      awake <= 1'h1;
    end else begin
      if (T_540) begin
        if (T_563) begin
          awake <= 1'h0;
        end else begin
          if (T_549) begin
            awake <= 1'h1;
          end
        end
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      unlocked <= 1'h0;
    end else begin
      if (T_388) begin
        unlocked <= T_386;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wantSleep <= 1'h0;
    end else begin
      if (T_540) begin
        if (T_563) begin
          wantSleep <= 1'h0;
        end else begin
          if (T_391) begin
            wantSleep <= io_regs_sleep_write_bits[0];
          end
        end
      end else begin
        if (T_391) begin
          wantSleep <= io_regs_sleep_write_bits[0];
        end
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      pc <= 3'h0;
    end else begin
      pc <= GEN_8[2:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wakeupCause <= 2'h0;
    end else begin
      if (T_540) begin
        if (T_549) begin
          if (T_552) begin
            wakeupCause <= 2'h0;
          end else begin
            if (T_553) begin
              wakeupCause <= 2'h1;
            end else begin
              if (T_554) begin
                wakeupCause <= 2'h2;
              end else begin
                wakeupCause <= 2'h3;
              end
            end
          end
        end
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      T_396 <= 4'b0;
    end
    else if (T_394) begin
      T_396 <= io_regs_ie_write_bits;
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wakeupProgram_0 <= 9'h1f0;
    end else begin
      wakeupProgram_0 <= GEN_19[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wakeupProgram_1 <= 9'hf8;
    end else begin
      wakeupProgram_1 <= GEN_20[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wakeupProgram_2 <= 9'h30;
    end else begin
      wakeupProgram_2 <= GEN_21[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wakeupProgram_3 <= 9'h30;
    end else begin
      wakeupProgram_3 <= GEN_22[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wakeupProgram_4 <= 9'h30;
    end else begin
      wakeupProgram_4 <= GEN_23[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wakeupProgram_5 <= 9'h30;
    end else begin
      wakeupProgram_5 <= GEN_24[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wakeupProgram_6 <= 9'h30;
    end else begin
      wakeupProgram_6 <= GEN_25[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      wakeupProgram_7 <= 9'h30;
    end else begin
      wakeupProgram_7 <= GEN_26[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sleepProgram_0 <= 9'hf0;
    end else begin
      sleepProgram_0 <= GEN_27[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sleepProgram_1 <= 9'h1f0;
    end else begin
      sleepProgram_1 <= GEN_28[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sleepProgram_2 <= 9'h1d0;
    end else begin
      sleepProgram_2 <= GEN_29[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sleepProgram_3 <= 9'h1c0;
    end else begin
      sleepProgram_3 <= GEN_30[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sleepProgram_4 <= 9'h1c0;
    end else begin
      sleepProgram_4 <= GEN_31[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sleepProgram_5 <= 9'h1c0;
    end else begin
      sleepProgram_5 <= GEN_32[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sleepProgram_6 <= 9'h1c0;
    end else begin
      sleepProgram_6 <= GEN_33[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      sleepProgram_7 <= 9'h1c0;
    end else begin
      sleepProgram_7 <= GEN_34[8:0];
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      count <= 16'h0;
    end else begin
      if (run) begin
        if (tick) begin
          count <= 16'h0;
        end else begin
          count <= T_524;
        end
      end
    end

endmodule
