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
                                                                         
                                                                         
                                                                         

module sirv_pmu(
  input   clock,
  input   reset,

  input   io_wakeup_awakeup,
  input   io_wakeup_dwakeup,
  input   io_wakeup_rtc,
  input   io_wakeup_reset,
  output  io_control_hfclkrst,
  output  io_control_corerst,
  output  io_control_reserved1,
  output  io_control_vddpaden,
  output  io_control_reserved0,
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
  output [31:0] io_regs_sleepProgram_7_read,
  input   io_resetCauses_wdogrst,
  input   io_resetCauses_erst,
  input   io_resetCauses_porrst
);

  reg  T_355;
  reg [31:0] GEN_1;
  reg  T_356;
  reg [31:0] GEN_2;
  wire  core_clock;
  wire  core_reset;
  wire  core_io_wakeup_awakeup;
  wire  core_io_wakeup_dwakeup;
  wire  core_io_wakeup_rtc;
  wire  core_io_wakeup_reset;
  wire  core_io_control_valid;
  wire  core_io_control_bits_hfclkrst;
  wire  core_io_control_bits_corerst;
  wire  core_io_control_bits_reserved1;
  wire  core_io_control_bits_vddpaden;
  wire  core_io_control_bits_reserved0;
  wire [1:0] core_io_resetCause;
  wire  core_io_regs_ie_write_valid;
  wire [3:0] core_io_regs_ie_write_bits;
  wire [3:0] core_io_regs_ie_read;
  wire  core_io_regs_cause_write_valid;
  wire [31:0] core_io_regs_cause_write_bits;
  wire [31:0] core_io_regs_cause_read;
  wire  core_io_regs_sleep_write_valid;
  wire [31:0] core_io_regs_sleep_write_bits;
  wire [31:0] core_io_regs_sleep_read;
  wire  core_io_regs_key_write_valid;
  wire [31:0] core_io_regs_key_write_bits;
  wire [31:0] core_io_regs_key_read;
  wire  core_io_regs_wakeupProgram_0_write_valid;
  wire [31:0] core_io_regs_wakeupProgram_0_write_bits;
  wire [31:0] core_io_regs_wakeupProgram_0_read;
  wire  core_io_regs_wakeupProgram_1_write_valid;
  wire [31:0] core_io_regs_wakeupProgram_1_write_bits;
  wire [31:0] core_io_regs_wakeupProgram_1_read;
  wire  core_io_regs_wakeupProgram_2_write_valid;
  wire [31:0] core_io_regs_wakeupProgram_2_write_bits;
  wire [31:0] core_io_regs_wakeupProgram_2_read;
  wire  core_io_regs_wakeupProgram_3_write_valid;
  wire [31:0] core_io_regs_wakeupProgram_3_write_bits;
  wire [31:0] core_io_regs_wakeupProgram_3_read;
  wire  core_io_regs_wakeupProgram_4_write_valid;
  wire [31:0] core_io_regs_wakeupProgram_4_write_bits;
  wire [31:0] core_io_regs_wakeupProgram_4_read;
  wire  core_io_regs_wakeupProgram_5_write_valid;
  wire [31:0] core_io_regs_wakeupProgram_5_write_bits;
  wire [31:0] core_io_regs_wakeupProgram_5_read;
  wire  core_io_regs_wakeupProgram_6_write_valid;
  wire [31:0] core_io_regs_wakeupProgram_6_write_bits;
  wire [31:0] core_io_regs_wakeupProgram_6_read;
  wire  core_io_regs_wakeupProgram_7_write_valid;
  wire [31:0] core_io_regs_wakeupProgram_7_write_bits;
  wire [31:0] core_io_regs_wakeupProgram_7_read;
  wire  core_io_regs_sleepProgram_0_write_valid;
  wire [31:0] core_io_regs_sleepProgram_0_write_bits;
  wire [31:0] core_io_regs_sleepProgram_0_read;
  wire  core_io_regs_sleepProgram_1_write_valid;
  wire [31:0] core_io_regs_sleepProgram_1_write_bits;
  wire [31:0] core_io_regs_sleepProgram_1_read;
  wire  core_io_regs_sleepProgram_2_write_valid;
  wire [31:0] core_io_regs_sleepProgram_2_write_bits;
  wire [31:0] core_io_regs_sleepProgram_2_read;
  wire  core_io_regs_sleepProgram_3_write_valid;
  wire [31:0] core_io_regs_sleepProgram_3_write_bits;
  wire [31:0] core_io_regs_sleepProgram_3_read;
  wire  core_io_regs_sleepProgram_4_write_valid;
  wire [31:0] core_io_regs_sleepProgram_4_write_bits;
  wire [31:0] core_io_regs_sleepProgram_4_read;
  wire  core_io_regs_sleepProgram_5_write_valid;
  wire [31:0] core_io_regs_sleepProgram_5_write_bits;
  wire [31:0] core_io_regs_sleepProgram_5_read;
  wire  core_io_regs_sleepProgram_6_write_valid;
  wire [31:0] core_io_regs_sleepProgram_6_write_bits;
  wire [31:0] core_io_regs_sleepProgram_6_read;
  wire  core_io_regs_sleepProgram_7_write_valid;
  wire [31:0] core_io_regs_sleepProgram_7_write_bits;
  wire [31:0] core_io_regs_sleepProgram_7_read;
  wire [1:0] T_358;
  wire [1:0] T_359;
  wire [2:0] T_360;
  wire [4:0] T_361;
  wire [4:0] T_362;
  wire  AsyncResetRegVec_1_1_clock;
  wire  AsyncResetRegVec_1_1_reset;
  wire [4:0] AsyncResetRegVec_1_1_io_d;
  wire [4:0] AsyncResetRegVec_1_1_io_q;
  wire  AsyncResetRegVec_1_1_io_en;
  //wire [4:0] latch;
  //Bob: the naming as latch is not good, which will introduce some confusing, so we give it renames here
  wire [4:0] core_io_control_bits;
  wire  T_369_hfclkrst;
  wire  T_369_corerst;
  wire  T_369_reserved1;
  wire  T_369_vddpaden;
  wire  T_369_reserved0;
  wire  T_375;
  wire  T_376;
  wire  T_377;
  wire  T_378;
  wire  T_379;
  wire [1:0] T_380;
  wire [2:0] T_381;
  //Bob: Name as Latch is not good, give it new name here
  //wire  SRLatch_3_q;
  //wire  SRLatch_3_reset;
  //wire  SRLatch_3_set;
  wire  T_382;
  wire  T_383;
  wire  T_384;
  wire  T_385;
  //wire  SRLatch_1_1_q;
  //wire  SRLatch_1_1_reset;
  //wire  SRLatch_1_1_set;
  wire  T_389;
  //wire  SRLatch_2_1_q;
  //wire  SRLatch_2_1_reset;
  //wire  SRLatch_2_1_set;
  wire  T_393;
  wire [1:0] T_394;
  wire [2:0] T_395;
  wire  T_396;
  wire [1:0] T_397;
  wire [1:0] GEN_0;
  wire [1:0] T_400;
  wire  T_401;
  wire [1:0] T_402;
  sirv_pmu_core u_pmu_core (
    .clock(core_clock),
    .reset(core_reset),
    .io_wakeup_awakeup(core_io_wakeup_awakeup),
    .io_wakeup_dwakeup(core_io_wakeup_dwakeup),
    .io_wakeup_rtc(core_io_wakeup_rtc),
    .io_wakeup_reset(core_io_wakeup_reset),
    .io_control_valid(core_io_control_valid),
    .io_control_bits_hfclkrst(core_io_control_bits_hfclkrst),
    .io_control_bits_corerst(core_io_control_bits_corerst),
    .io_control_bits_reserved1(core_io_control_bits_reserved1),
    .io_control_bits_vddpaden(core_io_control_bits_vddpaden),
    .io_control_bits_reserved0(core_io_control_bits_reserved0),
    .io_resetCause(core_io_resetCause),
    .io_regs_ie_write_valid(core_io_regs_ie_write_valid),
    .io_regs_ie_write_bits(core_io_regs_ie_write_bits),
    .io_regs_ie_read(core_io_regs_ie_read),
    .io_regs_cause_write_valid(core_io_regs_cause_write_valid),
    .io_regs_cause_write_bits(core_io_regs_cause_write_bits),
    .io_regs_cause_read(core_io_regs_cause_read),
    .io_regs_sleep_write_valid(core_io_regs_sleep_write_valid),
    .io_regs_sleep_write_bits(core_io_regs_sleep_write_bits),
    .io_regs_sleep_read(core_io_regs_sleep_read),
    .io_regs_key_write_valid(core_io_regs_key_write_valid),
    .io_regs_key_write_bits(core_io_regs_key_write_bits),
    .io_regs_key_read(core_io_regs_key_read),
    .io_regs_wakeupProgram_0_write_valid(core_io_regs_wakeupProgram_0_write_valid),
    .io_regs_wakeupProgram_0_write_bits(core_io_regs_wakeupProgram_0_write_bits),
    .io_regs_wakeupProgram_0_read(core_io_regs_wakeupProgram_0_read),
    .io_regs_wakeupProgram_1_write_valid(core_io_regs_wakeupProgram_1_write_valid),
    .io_regs_wakeupProgram_1_write_bits(core_io_regs_wakeupProgram_1_write_bits),
    .io_regs_wakeupProgram_1_read(core_io_regs_wakeupProgram_1_read),
    .io_regs_wakeupProgram_2_write_valid(core_io_regs_wakeupProgram_2_write_valid),
    .io_regs_wakeupProgram_2_write_bits(core_io_regs_wakeupProgram_2_write_bits),
    .io_regs_wakeupProgram_2_read(core_io_regs_wakeupProgram_2_read),
    .io_regs_wakeupProgram_3_write_valid(core_io_regs_wakeupProgram_3_write_valid),
    .io_regs_wakeupProgram_3_write_bits(core_io_regs_wakeupProgram_3_write_bits),
    .io_regs_wakeupProgram_3_read(core_io_regs_wakeupProgram_3_read),
    .io_regs_wakeupProgram_4_write_valid(core_io_regs_wakeupProgram_4_write_valid),
    .io_regs_wakeupProgram_4_write_bits(core_io_regs_wakeupProgram_4_write_bits),
    .io_regs_wakeupProgram_4_read(core_io_regs_wakeupProgram_4_read),
    .io_regs_wakeupProgram_5_write_valid(core_io_regs_wakeupProgram_5_write_valid),
    .io_regs_wakeupProgram_5_write_bits(core_io_regs_wakeupProgram_5_write_bits),
    .io_regs_wakeupProgram_5_read(core_io_regs_wakeupProgram_5_read),
    .io_regs_wakeupProgram_6_write_valid(core_io_regs_wakeupProgram_6_write_valid),
    .io_regs_wakeupProgram_6_write_bits(core_io_regs_wakeupProgram_6_write_bits),
    .io_regs_wakeupProgram_6_read(core_io_regs_wakeupProgram_6_read),
    .io_regs_wakeupProgram_7_write_valid(core_io_regs_wakeupProgram_7_write_valid),
    .io_regs_wakeupProgram_7_write_bits(core_io_regs_wakeupProgram_7_write_bits),
    .io_regs_wakeupProgram_7_read(core_io_regs_wakeupProgram_7_read),
    .io_regs_sleepProgram_0_write_valid(core_io_regs_sleepProgram_0_write_valid),
    .io_regs_sleepProgram_0_write_bits(core_io_regs_sleepProgram_0_write_bits),
    .io_regs_sleepProgram_0_read(core_io_regs_sleepProgram_0_read),
    .io_regs_sleepProgram_1_write_valid(core_io_regs_sleepProgram_1_write_valid),
    .io_regs_sleepProgram_1_write_bits(core_io_regs_sleepProgram_1_write_bits),
    .io_regs_sleepProgram_1_read(core_io_regs_sleepProgram_1_read),
    .io_regs_sleepProgram_2_write_valid(core_io_regs_sleepProgram_2_write_valid),
    .io_regs_sleepProgram_2_write_bits(core_io_regs_sleepProgram_2_write_bits),
    .io_regs_sleepProgram_2_read(core_io_regs_sleepProgram_2_read),
    .io_regs_sleepProgram_3_write_valid(core_io_regs_sleepProgram_3_write_valid),
    .io_regs_sleepProgram_3_write_bits(core_io_regs_sleepProgram_3_write_bits),
    .io_regs_sleepProgram_3_read(core_io_regs_sleepProgram_3_read),
    .io_regs_sleepProgram_4_write_valid(core_io_regs_sleepProgram_4_write_valid),
    .io_regs_sleepProgram_4_write_bits(core_io_regs_sleepProgram_4_write_bits),
    .io_regs_sleepProgram_4_read(core_io_regs_sleepProgram_4_read),
    .io_regs_sleepProgram_5_write_valid(core_io_regs_sleepProgram_5_write_valid),
    .io_regs_sleepProgram_5_write_bits(core_io_regs_sleepProgram_5_write_bits),
    .io_regs_sleepProgram_5_read(core_io_regs_sleepProgram_5_read),
    .io_regs_sleepProgram_6_write_valid(core_io_regs_sleepProgram_6_write_valid),
    .io_regs_sleepProgram_6_write_bits(core_io_regs_sleepProgram_6_write_bits),
    .io_regs_sleepProgram_6_read(core_io_regs_sleepProgram_6_read),
    .io_regs_sleepProgram_7_write_valid(core_io_regs_sleepProgram_7_write_valid),
    .io_regs_sleepProgram_7_write_bits(core_io_regs_sleepProgram_7_write_bits),
    .io_regs_sleepProgram_7_read(core_io_regs_sleepProgram_7_read)
  );
  sirv_AsyncResetRegVec_1 AsyncResetRegVec_1_1 (
    .clock(AsyncResetRegVec_1_1_clock),
    .reset(AsyncResetRegVec_1_1_reset),
    .io_d(AsyncResetRegVec_1_1_io_d),
    .io_q(AsyncResetRegVec_1_1_io_q),
    .io_en(AsyncResetRegVec_1_1_io_en)
  );
  //Bob: Since the SR Latch is not friend to the ASIC flow, so I just replace it to the DFF
  // And the name as Latch is not good, so give it a new name here

  wire por_reset  = T_382;// POR
  wire erst_reset = T_383;// ERST
  wire wdog_reset = T_384;// WDOG

  // In case we lost the reset, we need to just use two-dff syncer to catch up the reset, and until the clock
  //   is there to clear it
  reg por_reset_r;
  reg por_reset_r_r;
  always @(posedge clock or posedge por_reset) begin
    if(por_reset) begin
      por_reset_r   <= 1'b1;
      por_reset_r_r <= 1'b1;
    end
    else begin
      por_reset_r   <= 1'b0;
      por_reset_r_r <= por_reset_r;
    end
  end

  reg erst_reset_r;
  reg erst_reset_r_r;
  always @(posedge clock or posedge erst_reset) begin
    if(erst_reset) begin
      erst_reset_r   <= 1'b1;
      erst_reset_r_r <= 1'b1;
    end
    else begin
      erst_reset_r   <= 1'b0;
      erst_reset_r_r <= erst_reset_r;
    end
  end

  reg wdog_reset_r;
  reg wdog_reset_r_r;
  always @(posedge clock or posedge wdog_reset) begin
    if(wdog_reset) begin
      wdog_reset_r   <= 1'b1;
      wdog_reset_r_r <= 1'b1;
    end
    else begin
      wdog_reset_r   <= 1'b0;
      wdog_reset_r_r <= wdog_reset_r;
    end
  end

  // Reset cause priority if they are coming at same time:
      // POR
      // Erst
      // Wdog
  wire rstcause_por_set  = por_reset_r_r; 
  wire rstcause_erst_set = erst_reset_r_r & (~por_reset_r_r); 
  wire rstcause_wdog_set = wdog_reset_r_r & (~erst_reset_r_r) & (~por_reset_r_r); 

    // The POR only clear if:
        // there is no POR reset,
        // And there are other two resets 
  wire rstcause_por_clr  = (~por_reset_r_r) & (erst_reset_r_r | wdog_reset_r_r); 
    // The Erst only clear if:
        // there is POR reset,
        // or, there is no erst reset and there is wdog reset
  wire rstcause_erst_clr = por_reset_r_r | ((~erst_reset_r_r) & wdog_reset_r_r); 
    // The Wdog only clear if:
        // there is POR or Erst reset,
  wire rstcause_wdog_clr = por_reset_r_r | erst_reset_r_r;

  wire rstcause_por_ena  = rstcause_por_set  | rstcause_por_clr ;   
  wire rstcause_erst_ena = rstcause_erst_set | rstcause_erst_clr; 
  wire rstcause_wdog_ena = rstcause_wdog_set | rstcause_wdog_clr; 

  wire rstcause_por_nxt  = rstcause_por_set  | (~rstcause_por_clr );   
  wire rstcause_erst_nxt = rstcause_erst_set | (~rstcause_erst_clr); 
  wire rstcause_wdog_nxt = rstcause_wdog_set | (~rstcause_wdog_clr); 

  reg rstcause_por_r;
  reg rstcause_wdog_r;
  reg rstcause_erst_r;

  // The reset cause itself cannot have reset signal
  always @(posedge clock) begin
    if(rstcause_por_ena) begin
      rstcause_por_r <= rstcause_por_nxt;
    end
  end

  always @(posedge clock) begin
    if(rstcause_erst_ena) begin
      rstcause_erst_r <= rstcause_erst_nxt;
    end
  end

  always @(posedge clock) begin
    if(rstcause_wdog_ena) begin
      rstcause_wdog_r <= rstcause_wdog_nxt;
    end
  end
  //sirv_SRLatch SRLatch_3 ( // POR
  //  .q(SRLatch_3_q),
  //  .reset(SRLatch_3_reset),
  //  .set(SRLatch_3_set)
  //);
  //sirv_SRLatch SRLatch_1_1 (// ERST
  //  .q(SRLatch_1_1_q),
  //  .reset(SRLatch_1_1_reset),
  //  .set(SRLatch_1_1_set)
  //);
  //sirv_SRLatch SRLatch_2_1 (//WDOG
  //  .q(SRLatch_2_1_q),
  //  .reset(SRLatch_2_1_reset),
  //  .set(SRLatch_2_1_set)
  //);
  assign io_control_hfclkrst = T_369_hfclkrst;
  assign io_control_corerst = T_369_corerst;
  assign io_control_reserved1 = T_369_reserved1;
  assign io_control_vddpaden = T_369_vddpaden;
  assign io_control_reserved0 = T_369_reserved0;
  assign io_regs_ie_read = core_io_regs_ie_read;
  assign io_regs_cause_read = core_io_regs_cause_read;
  assign io_regs_sleep_read = core_io_regs_sleep_read;
  assign io_regs_key_read = core_io_regs_key_read;
  assign io_regs_wakeupProgram_0_read = core_io_regs_wakeupProgram_0_read;
  assign io_regs_wakeupProgram_1_read = core_io_regs_wakeupProgram_1_read;
  assign io_regs_wakeupProgram_2_read = core_io_regs_wakeupProgram_2_read;
  assign io_regs_wakeupProgram_3_read = core_io_regs_wakeupProgram_3_read;
  assign io_regs_wakeupProgram_4_read = core_io_regs_wakeupProgram_4_read;
  assign io_regs_wakeupProgram_5_read = core_io_regs_wakeupProgram_5_read;
  assign io_regs_wakeupProgram_6_read = core_io_regs_wakeupProgram_6_read;
  assign io_regs_wakeupProgram_7_read = core_io_regs_wakeupProgram_7_read;
  assign io_regs_sleepProgram_0_read = core_io_regs_sleepProgram_0_read;
  assign io_regs_sleepProgram_1_read = core_io_regs_sleepProgram_1_read;
  assign io_regs_sleepProgram_2_read = core_io_regs_sleepProgram_2_read;
  assign io_regs_sleepProgram_3_read = core_io_regs_sleepProgram_3_read;
  assign io_regs_sleepProgram_4_read = core_io_regs_sleepProgram_4_read;
  assign io_regs_sleepProgram_5_read = core_io_regs_sleepProgram_5_read;
  assign io_regs_sleepProgram_6_read = core_io_regs_sleepProgram_6_read;
  assign io_regs_sleepProgram_7_read = core_io_regs_sleepProgram_7_read;
  assign core_clock = clock;
  assign core_reset = T_356;
  assign core_io_wakeup_awakeup = io_wakeup_awakeup;
  assign core_io_wakeup_dwakeup = io_wakeup_dwakeup;
  assign core_io_wakeup_rtc = io_wakeup_rtc;
  assign core_io_wakeup_reset = 1'h0;
  assign core_io_resetCause = T_402;
  assign core_io_regs_ie_write_valid = io_regs_ie_write_valid;
  assign core_io_regs_ie_write_bits = io_regs_ie_write_bits;
  assign core_io_regs_cause_write_valid = io_regs_cause_write_valid;
  assign core_io_regs_cause_write_bits = io_regs_cause_write_bits;
  assign core_io_regs_sleep_write_valid = io_regs_sleep_write_valid;
  assign core_io_regs_sleep_write_bits = io_regs_sleep_write_bits;
  assign core_io_regs_key_write_valid = io_regs_key_write_valid;
  assign core_io_regs_key_write_bits = io_regs_key_write_bits;
  assign core_io_regs_wakeupProgram_0_write_valid = io_regs_wakeupProgram_0_write_valid;
  assign core_io_regs_wakeupProgram_0_write_bits = io_regs_wakeupProgram_0_write_bits;
  assign core_io_regs_wakeupProgram_1_write_valid = io_regs_wakeupProgram_1_write_valid;
  assign core_io_regs_wakeupProgram_1_write_bits = io_regs_wakeupProgram_1_write_bits;
  assign core_io_regs_wakeupProgram_2_write_valid = io_regs_wakeupProgram_2_write_valid;
  assign core_io_regs_wakeupProgram_2_write_bits = io_regs_wakeupProgram_2_write_bits;
  assign core_io_regs_wakeupProgram_3_write_valid = io_regs_wakeupProgram_3_write_valid;
  assign core_io_regs_wakeupProgram_3_write_bits = io_regs_wakeupProgram_3_write_bits;
  assign core_io_regs_wakeupProgram_4_write_valid = io_regs_wakeupProgram_4_write_valid;
  assign core_io_regs_wakeupProgram_4_write_bits = io_regs_wakeupProgram_4_write_bits;
  assign core_io_regs_wakeupProgram_5_write_valid = io_regs_wakeupProgram_5_write_valid;
  assign core_io_regs_wakeupProgram_5_write_bits = io_regs_wakeupProgram_5_write_bits;
  assign core_io_regs_wakeupProgram_6_write_valid = io_regs_wakeupProgram_6_write_valid;
  assign core_io_regs_wakeupProgram_6_write_bits = io_regs_wakeupProgram_6_write_bits;
  assign core_io_regs_wakeupProgram_7_write_valid = io_regs_wakeupProgram_7_write_valid;
  assign core_io_regs_wakeupProgram_7_write_bits = io_regs_wakeupProgram_7_write_bits;
  assign core_io_regs_sleepProgram_0_write_valid = io_regs_sleepProgram_0_write_valid;
  assign core_io_regs_sleepProgram_0_write_bits = io_regs_sleepProgram_0_write_bits;
  assign core_io_regs_sleepProgram_1_write_valid = io_regs_sleepProgram_1_write_valid;
  assign core_io_regs_sleepProgram_1_write_bits = io_regs_sleepProgram_1_write_bits;
  assign core_io_regs_sleepProgram_2_write_valid = io_regs_sleepProgram_2_write_valid;
  assign core_io_regs_sleepProgram_2_write_bits = io_regs_sleepProgram_2_write_bits;
  assign core_io_regs_sleepProgram_3_write_valid = io_regs_sleepProgram_3_write_valid;
  assign core_io_regs_sleepProgram_3_write_bits = io_regs_sleepProgram_3_write_bits;
  assign core_io_regs_sleepProgram_4_write_valid = io_regs_sleepProgram_4_write_valid;
  assign core_io_regs_sleepProgram_4_write_bits = io_regs_sleepProgram_4_write_bits;
  assign core_io_regs_sleepProgram_5_write_valid = io_regs_sleepProgram_5_write_valid;
  assign core_io_regs_sleepProgram_5_write_bits = io_regs_sleepProgram_5_write_bits;
  assign core_io_regs_sleepProgram_6_write_valid = io_regs_sleepProgram_6_write_valid;
  assign core_io_regs_sleepProgram_6_write_bits = io_regs_sleepProgram_6_write_bits;
  assign core_io_regs_sleepProgram_7_write_valid = io_regs_sleepProgram_7_write_valid;
  assign core_io_regs_sleepProgram_7_write_bits = io_regs_sleepProgram_7_write_bits;
  assign T_358 = {core_io_control_bits_vddpaden,core_io_control_bits_reserved0};
  assign T_359 = {core_io_control_bits_hfclkrst,core_io_control_bits_corerst};
  assign T_360 = {T_359,core_io_control_bits_reserved1};
  assign T_361 = {T_360,T_358};
  assign T_362 = ~ T_361;
  assign AsyncResetRegVec_1_1_clock = clock;
  assign AsyncResetRegVec_1_1_reset = reset;
  assign AsyncResetRegVec_1_1_io_d = T_362;
  assign AsyncResetRegVec_1_1_io_en = core_io_control_valid;
  assign core_io_control_bits = ~ AsyncResetRegVec_1_1_io_q;
  assign T_369_hfclkrst = T_379;
  assign T_369_corerst = T_378;
  assign T_369_reserved1 = T_377;
  assign T_369_vddpaden = T_376;
  assign T_369_reserved0 = T_375;
  assign T_375 = core_io_control_bits[0];
  assign T_376 = core_io_control_bits[1];
  assign T_377 = core_io_control_bits[2];
  assign T_378 = core_io_control_bits[3];
  assign T_379 = core_io_control_bits[4];
  assign T_380 = {io_resetCauses_wdogrst,io_resetCauses_erst};
  assign T_381 = {T_380,io_resetCauses_porrst};
  //assign SRLatch_3_reset = T_385;
  //assign SRLatch_3_set = T_382;// POR
  assign T_382 = T_381[0];// The POR
  assign T_383 = T_381[1];// The ERST
  assign T_384 = T_381[2];// The WDOG
  assign T_385 = T_383 | T_384;
  //assign SRLatch_1_1_reset = T_389;
  //assign SRLatch_1_1_set = T_383;// ERST
  assign T_389 = T_382 | T_384;
  //assign SRLatch_2_1_reset = T_393;
  //assign SRLatch_2_1_set = T_384;// WDOG
  assign T_393 = T_382 | T_383;
  //assign T_394 = {SRLatch_2_1_q,SRLatch_1_1_q};
  //Bob assign T_395 = {T_394,SRLatch_3_q};
  assign T_394 = {rstcause_wdog_r,rstcause_erst_r};
  assign T_395 = {T_394,rstcause_por_r};
  assign T_396 = T_395[2];
  assign T_397 = T_395[1:0];
  assign GEN_0 = {{1'd0}, T_396};
  assign T_400 = GEN_0 | T_397;
  assign T_401 = T_400[1];
  assign T_402 = {T_396,T_401};
  //Bob: The original code is here 
  //always @(posedge clock) begin
  //  T_355 <= reset;
  //  T_356 <= T_355;
  //end
  //Bob: Why here need to flop the reset twice? this is not allowed in coding style so just comment it out
  always @(posedge clock or posedge reset) begin
    if(reset) begin
      T_355 <= 1'b1;
      T_356 <= 1'b1;
    end
    else begin
      T_355 <= 1'b0;
      T_356 <= T_355;
    end
  end

endmodule
