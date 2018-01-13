 /*                                                                      
 Copyright 2017 Silicon Integrated Microelectronics, Inc.                
                                                                         
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
                                                                         
                                                                         
                                                                         
//=====================================================================
//--        _______   ___
//--       (   ____/ /__/
//--        \ \     __
//--     ____\ \   / /
//--    /_______\ /_/   MICROELECTRONICS
//--
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  This module to implement the 17cycles MUL and 33 cycles DIV unit, which is mostly 
//  share the datapath with ALU_DPATH module to save gatecount to mininum
//
//
// ====================================================================
`include "e203_defines.v"

`ifdef E203_SUPPORT_MULDIV //{
module e203_exu_alu_muldiv(
  input  mdv_nob2b,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The Issue Handshake Interface to MULDIV 
  //
  input  muldiv_i_valid, // Handshake valid
  output muldiv_i_ready, // Handshake ready

  input  [`E203_XLEN-1:0] muldiv_i_rs1,
  input  [`E203_XLEN-1:0] muldiv_i_rs2,
  input  [`E203_XLEN-1:0] muldiv_i_imm,
  input  [`E203_DECINFO_MULDIV_WIDTH-1:0] muldiv_i_info,
  input  [`E203_ITAG_WIDTH-1:0] muldiv_i_itag,

  output muldiv_i_longpipe,

  input  flush_pulse,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The MULDIV Write-Back/Commit Interface
  output muldiv_o_valid, // Handshake valid
  input  muldiv_o_ready, // Handshake ready
  output [`E203_XLEN-1:0] muldiv_o_wbck_wdat,
  output muldiv_o_wbck_err,   
  //   There is no exception cases for MULDIV, so no addtional cmt signals

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // To share the ALU datapath, generate interface to ALU
  // 
     // The operands and info to ALU
  output [`E203_MULDIV_ADDER_WIDTH-1:0] muldiv_req_alu_op1,
  output [`E203_MULDIV_ADDER_WIDTH-1:0] muldiv_req_alu_op2,
  output                                muldiv_req_alu_add ,
  output                                muldiv_req_alu_sub ,
  input  [`E203_MULDIV_ADDER_WIDTH-1:0] muldiv_req_alu_res,

     // The Shared-Buffer interface to ALU-Shared-Buffer
  output          muldiv_sbf_0_ena,
  output [33-1:0] muldiv_sbf_0_nxt,
  input  [33-1:0] muldiv_sbf_0_r,

  output          muldiv_sbf_1_ena,
  output [33-1:0] muldiv_sbf_1_nxt,
  input  [33-1:0] muldiv_sbf_1_r,

  input  clk,
  input  rst_n
  );

  wire muldiv_i_hsked = muldiv_i_valid & muldiv_i_ready;
  wire muldiv_o_hsked = muldiv_o_valid & muldiv_o_ready;

  wire flushed_r;
  wire flushed_set = flush_pulse;
  wire flushed_clr = muldiv_o_hsked & (~flush_pulse);
  wire flushed_ena = flushed_set | flushed_clr;
  wire flushed_nxt = flushed_set | (~flushed_clr);
  sirv_gnrl_dfflr #(1) flushed_dfflr (flushed_ena, flushed_nxt, flushed_r, clk, rst_n);



  wire i_mul    = muldiv_i_info[`E203_DECINFO_MULDIV_MUL   ];// We treat this as signed X signed
  wire i_mulh   = muldiv_i_info[`E203_DECINFO_MULDIV_MULH  ];
  wire i_mulhsu = muldiv_i_info[`E203_DECINFO_MULDIV_MULHSU];
  wire i_mulhu  = muldiv_i_info[`E203_DECINFO_MULDIV_MULHU ];
  wire i_div    = muldiv_i_info[`E203_DECINFO_MULDIV_DIV   ];
  wire i_divu   = muldiv_i_info[`E203_DECINFO_MULDIV_DIVU  ];
  wire i_rem    = muldiv_i_info[`E203_DECINFO_MULDIV_REM   ];
  wire i_remu   = muldiv_i_info[`E203_DECINFO_MULDIV_REMU  ];
      // If it is flushed then it is not back2back real case
  wire i_b2b    = muldiv_i_info[`E203_DECINFO_MULDIV_B2B   ] & (~flushed_r) & (~mdv_nob2b);

  wire back2back_seq = i_b2b;

  wire mul_rs1_sign = (i_mulhu)            ? 1'b0 : muldiv_i_rs1[`E203_XLEN-1];
  wire mul_rs2_sign = (i_mulhsu | i_mulhu) ? 1'b0 : muldiv_i_rs2[`E203_XLEN-1];

  wire [32:0] mul_op1 = {mul_rs1_sign, muldiv_i_rs1};
  wire [32:0] mul_op2 = {mul_rs2_sign, muldiv_i_rs2};

  wire i_op_mul = i_mul | i_mulh | i_mulhsu | i_mulhu;
  wire i_op_div = i_div | i_divu | i_rem    | i_remu;


  /////////////////////////////////////////////////////////////////////////////////
  // Implement the state machine for 
  //    (1) The MUL instructions
  //    (2) The DIV instructions
  localparam MULDIV_STATE_WIDTH = 3;

  wire [MULDIV_STATE_WIDTH-1:0] muldiv_state_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] muldiv_state_r;
  wire muldiv_state_ena;

  // State 0: The 0th state, means this is the 1 cycle see the operand inputs
  localparam MULDIV_STATE_0TH = 3'd0;
  // State 1: Executing the instructions
  localparam MULDIV_STATE_EXEC = 3'd1;
  // State 2: Div check if need correction
  localparam MULDIV_STATE_REMD_CHCK = 3'd2;
  // State 3: Quotient correction
  localparam MULDIV_STATE_QUOT_CORR = 3'd3;
  // State 4: Reminder correction
  localparam MULDIV_STATE_REMD_CORR = 3'd4;
  
 
  wire [MULDIV_STATE_WIDTH-1:0] state_0th_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] state_exec_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] state_remd_chck_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] state_quot_corr_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] state_remd_corr_nxt;
  wire state_0th_exit_ena;
  wire state_exec_exit_ena;
  wire state_remd_chck_exit_ena;
  wire state_quot_corr_exit_ena;
  wire state_remd_corr_exit_ena;

  wire special_cases;
  wire muldiv_i_valid_nb2b = muldiv_i_valid & (~back2back_seq) & (~special_cases);

  // Define some common signals and reused later to save gatecounts
  wire   muldiv_sta_is_0th       = (muldiv_state_r == MULDIV_STATE_0TH   );
  wire   muldiv_sta_is_exec      = (muldiv_state_r == MULDIV_STATE_EXEC   );
  wire   muldiv_sta_is_remd_chck  = (muldiv_state_r == MULDIV_STATE_REMD_CHCK   );
  wire   muldiv_sta_is_quot_corr = (muldiv_state_r == MULDIV_STATE_QUOT_CORR   );
  wire   muldiv_sta_is_remd_corr = (muldiv_state_r == MULDIV_STATE_REMD_CORR   );

      // **** If the current state is 0th,
          // If a new instruction come (non back2back), next state is MULDIV_STATE_EXEC
  assign state_0th_exit_ena = muldiv_sta_is_0th & muldiv_i_valid_nb2b & (~flush_pulse);
  assign state_0th_nxt      = MULDIV_STATE_EXEC;

      // **** If the current state is exec,
  wire div_need_corrct; 
  wire mul_exec_last_cycle; 
  wire div_exec_last_cycle; 
  wire exec_last_cycle; 
  assign state_exec_exit_ena =  muldiv_sta_is_exec & ((
          // If it is the last cycle (16th or 32rd cycles), 
                           exec_last_cycle 
              // If it is div op, then jump to DIV_CHECK state
                         & (i_op_div ? 1'b1
              // If it is not div-need-correction, then jump to 0th 
                                            : muldiv_o_hsked))
            | flush_pulse);
  assign state_exec_nxt      = 
                (
                         flush_pulse ? MULDIV_STATE_0TH :
              // If it is div op, then jump to DIV_CHECK state
                         i_op_div ? MULDIV_STATE_REMD_CHCK
              // If it is not div-need-correction, then jump to 0th 
                                         : MULDIV_STATE_0TH
                );

      // **** If the current state is REMD_CHCK,
          // If it is div-need-correction, then jump to QUOT_CORR state
          //   otherwise jump to the 0th
  assign state_remd_chck_exit_ena = (muldiv_sta_is_remd_chck & ( 
              // If it is div op, then jump to DIV_CHECK state
                                              (div_need_corrct ? 1'b1
              // If it is not div-need-correction, then jump to 0th 
                                                         : muldiv_o_hsked) 
                                              | flush_pulse )) ;
  assign state_remd_chck_nxt      = flush_pulse ? MULDIV_STATE_0TH :
              // If it is div-need-correction, then jump to QUOT_CORR state
                         div_need_corrct ? MULDIV_STATE_QUOT_CORR
              // If it is not div-need-correction, then jump to 0th 
                                         : MULDIV_STATE_0TH;

      // **** If the current state is QUOT_CORR,
          // Always jump to REMD_CORR state
  assign state_quot_corr_exit_ena = (muldiv_sta_is_quot_corr & (flush_pulse | 1'b1));
  assign state_quot_corr_nxt      = flush_pulse ? MULDIV_STATE_0TH : MULDIV_STATE_REMD_CORR;

                
      // **** If the current state is REMD_CORR,
              // Then jump to 0th 
  assign state_remd_corr_exit_ena = (muldiv_sta_is_remd_corr & (flush_pulse | muldiv_o_hsked));
  assign state_remd_corr_nxt      = flush_pulse ? MULDIV_STATE_0TH : MULDIV_STATE_0TH;

  // The state will only toggle when each state is meeting the condition to exit 
  assign muldiv_state_ena = state_0th_exit_ena 
                          | state_exec_exit_ena  
                          | state_remd_chck_exit_ena  
                          | state_quot_corr_exit_ena  
                          | state_remd_corr_exit_ena;  

  // The next-state is onehot mux to select different entries
  assign muldiv_state_nxt = 
              ({MULDIV_STATE_WIDTH{state_0th_exit_ena      }} & state_0th_nxt      )
            | ({MULDIV_STATE_WIDTH{state_exec_exit_ena     }} & state_exec_nxt     )
            | ({MULDIV_STATE_WIDTH{state_remd_chck_exit_ena}} & state_remd_chck_nxt)
            | ({MULDIV_STATE_WIDTH{state_quot_corr_exit_ena}} & state_quot_corr_nxt)
            | ({MULDIV_STATE_WIDTH{state_remd_corr_exit_ena}} & state_remd_corr_nxt)
              ;

  sirv_gnrl_dfflr #(MULDIV_STATE_WIDTH) muldiv_state_dfflr (muldiv_state_ena, muldiv_state_nxt, muldiv_state_r, clk, rst_n);

  wire state_exec_enter_ena = muldiv_state_ena & (muldiv_state_nxt == MULDIV_STATE_EXEC);

  localparam EXEC_CNT_W  = 6;
  localparam EXEC_CNT_1  = 6'd1 ;
  localparam EXEC_CNT_16 = 6'd16;
  localparam EXEC_CNT_32 = 6'd32;

  wire[EXEC_CNT_W-1:0] exec_cnt_r;
  wire exec_cnt_set = state_exec_enter_ena;
  wire exec_cnt_inc = muldiv_sta_is_exec & (~exec_last_cycle); 
  wire exec_cnt_ena = exec_cnt_inc | exec_cnt_set; 
    // When set, the counter is set to 1, because the 0th state also counted as 0th cycle
  wire[EXEC_CNT_W-1:0] exec_cnt_nxt = exec_cnt_set ? EXEC_CNT_1 : (exec_cnt_r + 1'b1);
  sirv_gnrl_dfflr #(EXEC_CNT_W) exec_cnt_dfflr (exec_cnt_ena, exec_cnt_nxt, exec_cnt_r, clk, rst_n);
  // The exec state is the last cycle when the exec_cnt_r is reaching the last cycle (16 or 32cycles)

  wire cycle_0th  = muldiv_sta_is_0th;
  wire cycle_16th = (exec_cnt_r == EXEC_CNT_16);
  wire cycle_32nd = (exec_cnt_r == EXEC_CNT_32);
  assign mul_exec_last_cycle = cycle_16th;
  assign div_exec_last_cycle = cycle_32nd;
  assign exec_last_cycle = i_op_mul ? mul_exec_last_cycle : div_exec_last_cycle;



///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Use booth-4 algorithm to conduct the multiplication

  wire [32:0] part_prdt_hi_r;
  wire [32:0] part_prdt_lo_r;
  wire [32:0] part_prdt_hi_nxt;
  wire [32:0] part_prdt_lo_nxt;

  wire part_prdt_sft1_r;
  wire [2:0] booth_code = cycle_0th  ? {muldiv_i_rs1[1:0],1'b0}
                        : cycle_16th ? {mul_rs1_sign,part_prdt_lo_r[0],part_prdt_sft1_r}
                        : {part_prdt_lo_r[1:0],part_prdt_sft1_r};
      //booth_code == 3'b000 =  0
      //booth_code == 3'b001 =  1
      //booth_code == 3'b010 =  1
      //booth_code == 3'b011 =  2
      //booth_code == 3'b100 = -2
      //booth_code == 3'b101 = -1
      //booth_code == 3'b110 = -1
      //booth_code == 3'b111 = -0
  wire booth_sel_zero = (booth_code == 3'b000) | (booth_code == 3'b111);
  wire booth_sel_two  = (booth_code == 3'b011) | (booth_code == 3'b100);
  wire booth_sel_one  = (~booth_sel_zero) & (~booth_sel_two);
  wire booth_sel_sub  = booth_code[2];  

  // 35 bits adder needed
  wire [`E203_MULDIV_ADDER_WIDTH-1:0] mul_exe_alu_res = muldiv_req_alu_res;
  wire [`E203_MULDIV_ADDER_WIDTH-1:0] mul_exe_alu_op2 = 
      ({`E203_MULDIV_ADDER_WIDTH{booth_sel_zero}} & `E203_MULDIV_ADDER_WIDTH'b0) 
    | ({`E203_MULDIV_ADDER_WIDTH{booth_sel_one }} & {mul_rs2_sign,mul_rs2_sign,mul_rs2_sign,muldiv_i_rs2}) 
    | ({`E203_MULDIV_ADDER_WIDTH{booth_sel_two }} & {mul_rs2_sign,mul_rs2_sign,muldiv_i_rs2,1'b0}) 
      ;
  wire [`E203_MULDIV_ADDER_WIDTH-1:0] mul_exe_alu_op1 =
       cycle_0th ? `E203_MULDIV_ADDER_WIDTH'b0 : {part_prdt_hi_r[32],part_prdt_hi_r[32],part_prdt_hi_r};  
  wire mul_exe_alu_add = (~booth_sel_sub);
  wire mul_exe_alu_sub = booth_sel_sub;

  assign part_prdt_hi_nxt = mul_exe_alu_res[34:2];
  assign part_prdt_lo_nxt = {mul_exe_alu_res[1:0],
                         (cycle_0th ? {mul_rs1_sign,muldiv_i_rs1[31:2]} : part_prdt_lo_r[32:2])
                         };
  wire part_prdt_sft1_nxt = cycle_0th ? muldiv_i_rs1[1] : part_prdt_lo_r[1];

  wire mul_exe_cnt_set = exec_cnt_set & i_op_mul;
  wire mul_exe_cnt_inc = exec_cnt_inc & i_op_mul; 

  wire part_prdt_hi_ena = mul_exe_cnt_set | mul_exe_cnt_inc | state_exec_exit_ena;
  wire part_prdt_lo_ena = part_prdt_hi_ena;

  sirv_gnrl_dfflr #(1) part_prdt_sft1_dfflr (part_prdt_lo_ena, part_prdt_sft1_nxt, part_prdt_sft1_r, clk, rst_n);

    // This mul_res is not back2back case, so directly from the adder result
  wire[`E203_XLEN-1:0] mul_res = i_mul ? part_prdt_lo_r[32:1] : mul_exe_alu_res[31:0];




///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// The Divider Implementation, using the non-restoring signed division 
  wire [32:0] part_remd_r;
  wire [32:0] part_quot_r;

  wire div_rs1_sign = (i_divu | i_remu) ? 1'b0 : muldiv_i_rs1[`E203_XLEN-1];
  wire div_rs2_sign = (i_divu | i_remu) ? 1'b0 : muldiv_i_rs2[`E203_XLEN-1];

  wire [65:0] dividend = {{33{div_rs1_sign}}, div_rs1_sign, muldiv_i_rs1};
  wire [33:0] divisor  = {div_rs2_sign, div_rs2_sign, muldiv_i_rs2};

  wire quot_0cycl = (dividend[65] ^ divisor[33]) ? 1'b0 : 1'b1;// If the sign(s0)!=sign(d), then set q_1st = -1

  wire [66:0] dividend_lsft1 = {dividend[65:0],quot_0cycl};


  wire prev_quot = cycle_0th ? quot_0cycl : part_quot_r[0];

  wire part_remd_sft1_r;
  // 34 bits adder needed
  wire [33:0] div_exe_alu_res = muldiv_req_alu_res[33:0];
  wire [33:0] div_exe_alu_op1 = cycle_0th ? dividend_lsft1[66:33] : {part_remd_sft1_r, part_remd_r[32:0]};
  wire [33:0] div_exe_alu_op2 = divisor;
  wire div_exe_alu_add = (~prev_quot);
  wire div_exe_alu_sub =   prev_quot ;

  wire current_quot = (div_exe_alu_res[33] ^ divisor[33]) ? 1'b0 : 1'b1;

  wire [66:0] div_exe_part_remd;
  assign div_exe_part_remd[66:33] = div_exe_alu_res;
  assign div_exe_part_remd[32: 0] = cycle_0th ? dividend_lsft1[32:0] : part_quot_r[32:0];

  wire [67:0] div_exe_part_remd_lsft1 = {div_exe_part_remd[66:0],current_quot};

  wire part_remd_ena;
    // Since the part_remd_r is only save 33bits (after left shifted), so the adder result MSB bit we need to save
    //   it here, which will be used at next round
  sirv_gnrl_dfflr #(1) part_remd_sft1_dfflr (part_remd_ena, div_exe_alu_res[32], part_remd_sft1_r, clk, rst_n);
  
  wire div_exe_cnt_set = exec_cnt_set & i_op_div;
  wire div_exe_cnt_inc = exec_cnt_inc & i_op_div; 

  wire corrct_phase = muldiv_sta_is_remd_corr | muldiv_sta_is_quot_corr;
  wire check_phase  = muldiv_sta_is_remd_chck;

  wire [33:0] div_quot_corr_alu_res;
  wire [33:0] div_remd_corr_alu_res;
       // Note: in last cycle, the reminder value is the non-shifted value
       //   but the quotient value is the shifted value, and last bit of quotient value is shifted always by 1 
       // If need corrective, the correct quot first, and then reminder, so reminder output as comb logic directly to 
           // save a cycle
  wire [32:0] div_remd = check_phase  ? part_remd_r [32:0]:
                         corrct_phase ? div_remd_corr_alu_res[32:0] :
                                        div_exe_part_remd[65:33];
  wire [32:0] div_quot = check_phase  ? part_quot_r [32:0]:
                         corrct_phase ? part_quot_r [32:0]: 
                                        {div_exe_part_remd[31:0],1'b1};

  // The partial reminder and quotient   
  wire [32:0] part_remd_nxt = corrct_phase ? div_remd_corr_alu_res[32:0] :
                              (muldiv_sta_is_exec & div_exec_last_cycle) ? div_remd :
                                                          div_exe_part_remd_lsft1[65:33];
  wire [32:0] part_quot_nxt = corrct_phase ? div_quot_corr_alu_res[32:0] :
                              (muldiv_sta_is_exec & div_exec_last_cycle) ? div_quot :
                                                          div_exe_part_remd_lsft1[32: 0];

  wire [33:0] div_remd_chck_alu_res = muldiv_req_alu_res[33:0];
  wire [33:0] div_remd_chck_alu_op1 = {part_remd_r[32], part_remd_r};
  wire [33:0] div_remd_chck_alu_op2 = divisor;
  wire div_remd_chck_alu_add = 1'b1;
  wire div_remd_chck_alu_sub = 1'b0;

  wire remd_is_0 = ~(|part_remd_r);
  wire remd_is_neg_divs = ~(|div_remd_chck_alu_res); 
  wire remd_is_divs = (part_remd_r == divisor[32:0]);
  assign div_need_corrct = i_op_div & (
                                ((part_remd_r[32] ^ dividend[65]) & (~remd_is_0))
                              | remd_is_neg_divs
                              | remd_is_divs
                            );

  wire remd_inc_quot_dec = (part_remd_r[32] ^ divisor[33]);

  assign div_quot_corr_alu_res = muldiv_req_alu_res[33:0];
  wire [33:0] div_quot_corr_alu_op1 = {part_quot_r[32], part_quot_r};
  wire [33:0] div_quot_corr_alu_op2 = 34'b1;
  wire div_quot_corr_alu_add = (~remd_inc_quot_dec);
  wire div_quot_corr_alu_sub = remd_inc_quot_dec;

  assign div_remd_corr_alu_res = muldiv_req_alu_res[33:0];
  wire [33:0] div_remd_corr_alu_op1 = {part_remd_r[32], part_remd_r};
  wire [33:0] div_remd_corr_alu_op2 = divisor;
  wire div_remd_corr_alu_add = remd_inc_quot_dec;
  wire div_remd_corr_alu_sub = ~remd_inc_quot_dec;

  // The partial reminder register will be loaded in the exe state, and in reminder correction cycle
  assign part_remd_ena = div_exe_cnt_set | div_exe_cnt_inc | state_exec_exit_ena | state_remd_corr_exit_ena;
  // The partial quotient register will be loaded in the exe state, and in quotient correction cycle
  wire part_quot_ena = div_exe_cnt_set | div_exe_cnt_inc | state_exec_exit_ena | state_quot_corr_exit_ena;

  wire[`E203_XLEN-1:0] div_res = (i_div | i_divu) ? div_quot[`E203_XLEN-1:0] : div_remd[`E203_XLEN-1:0];



  wire div_by_0 = ~(|muldiv_i_rs2);// Divisor is all zeros
  wire div_ovf  = (i_div | i_rem) & (&muldiv_i_rs2)  // Divisor is all ones, means -1
                        //Dividend is 10000...000, means -(2^xlen -1)
                & muldiv_i_rs1[`E203_XLEN-1] & (~(|muldiv_i_rs1[`E203_XLEN-2:0]));

  wire[`E203_XLEN-1:0] div_by_0_res_quot = ~`E203_XLEN'b0;
  wire[`E203_XLEN-1:0] div_by_0_res_remd = dividend[`E203_XLEN-1:0];
  wire[`E203_XLEN-1:0] div_by_0_res = (i_div | i_divu) ? div_by_0_res_quot : div_by_0_res_remd;

  wire[`E203_XLEN-1:0] div_ovf_res_quot  = {1'b1,{`E203_XLEN-1{1'b0}}};
  wire[`E203_XLEN-1:0] div_ovf_res_remd  = `E203_XLEN'b0;
  wire[`E203_XLEN-1:0] div_ovf_res = (i_div | i_divu) ? div_ovf_res_quot : div_ovf_res_remd;

  wire div_special_cases = i_op_div & (div_by_0 | div_ovf);
  wire[`E203_XLEN-1:0] div_special_res = div_by_0 ? div_by_0_res : div_ovf_res;



///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Output generateion
  assign special_cases = div_special_cases;// Only divider have special cases
  wire[`E203_XLEN-1:0] special_res = div_special_res;// Only divider have special cases

  // To detect the sequence of MULH[[S]U] rdh, rs1, rs2;    MUL rdl, rs1, rs2
  // To detect the sequence of     DIV[U] rdq, rs1, rs2; REM[U] rdr, rs1, rs2  
  wire [`E203_XLEN-1:0] back2back_mul_res = {part_prdt_lo_r[`E203_XLEN-2:0],part_prdt_sft1_r};// Only the MUL will be treated as back2back
  wire [`E203_XLEN-1:0] back2back_mul_rem = part_remd_r[`E203_XLEN-1:0];
  wire [`E203_XLEN-1:0] back2back_mul_div = part_quot_r[`E203_XLEN-1:0];
  wire [`E203_XLEN-1:0] back2back_res = (
             ({`E203_XLEN{i_mul         }} & back2back_mul_res)
           | ({`E203_XLEN{i_rem | i_remu}} & back2back_mul_rem)
           | ({`E203_XLEN{i_div | i_divu}} & back2back_mul_div)
     );

    // The output will be valid:
    //   * If it is back2back and sepcial cases, just directly pass out from input
    //   * If it is not back2back sequence when it is the last cycle of exec state 
    //     (not div need correction) or last correct state;
  wire wbck_condi = (back2back_seq | special_cases) ? 1'b1 : 
                       (
                           (muldiv_sta_is_exec & exec_last_cycle & (~i_op_div))
                         | (muldiv_sta_is_remd_chck & (~div_need_corrct)) 
                         | muldiv_sta_is_remd_corr 
                       );
  assign muldiv_o_valid = wbck_condi & muldiv_i_valid;
  assign muldiv_i_ready = wbck_condi & muldiv_o_ready;
  wire res_sel_spl = special_cases;
  wire res_sel_b2b  = back2back_seq & (~special_cases);
  wire res_sel_div  = (~back2back_seq) & (~special_cases) & i_op_div;
  wire res_sel_mul  = (~back2back_seq) & (~special_cases) & i_op_mul;
  assign muldiv_o_wbck_wdat = 
               ({`E203_XLEN{res_sel_b2b}} & back2back_res)
             | ({`E203_XLEN{res_sel_spl}} & special_res)
             | ({`E203_XLEN{res_sel_div}} & div_res)
             | ({`E203_XLEN{res_sel_mul}} & mul_res);

  //   There is no exception cases for MULDIV, so no addtional cmt signals
  assign muldiv_o_wbck_err = 1'b0;

     // The operands and info to ALU
  wire req_alu_sel1 = i_op_mul;
  wire req_alu_sel2 = i_op_div & (muldiv_sta_is_0th | muldiv_sta_is_exec);
  wire req_alu_sel3 = i_op_div & muldiv_sta_is_quot_corr;
  wire req_alu_sel4 = i_op_div & muldiv_sta_is_remd_corr;
  wire req_alu_sel5 = i_op_div & muldiv_sta_is_remd_chck;

  assign muldiv_req_alu_op1 = 
             ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel1}} & mul_exe_alu_op1      )
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel2}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_exe_alu_op1      })
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel3}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_quot_corr_alu_op1})
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel4}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_remd_corr_alu_op1}) 
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel5}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_remd_chck_alu_op1});

  assign muldiv_req_alu_op2 = 
             ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel1}} & mul_exe_alu_op2      )
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel2}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_exe_alu_op2      })
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel3}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_quot_corr_alu_op2})
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel4}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_remd_corr_alu_op2}) 
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel5}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_remd_chck_alu_op2});

  assign muldiv_req_alu_add  = 
             (req_alu_sel1 & mul_exe_alu_add      )
           | (req_alu_sel2 & div_exe_alu_add      )
           | (req_alu_sel3 & div_quot_corr_alu_add)
           | (req_alu_sel4 & div_remd_corr_alu_add) 
           | (req_alu_sel5 & div_remd_chck_alu_add);

  assign muldiv_req_alu_sub  = 
             (req_alu_sel1 & mul_exe_alu_sub      )
           | (req_alu_sel2 & div_exe_alu_sub      )
           | (req_alu_sel3 & div_quot_corr_alu_sub)
           | (req_alu_sel4 & div_remd_corr_alu_sub) 
           | (req_alu_sel5 & div_remd_chck_alu_sub);

  assign muldiv_sbf_0_ena = part_remd_ena | part_prdt_hi_ena;
  assign muldiv_sbf_0_nxt = i_op_mul ? part_prdt_hi_nxt : part_remd_nxt;

  assign muldiv_sbf_1_ena = part_quot_ena | part_prdt_lo_ena;
  assign muldiv_sbf_1_nxt = i_op_mul ? part_prdt_lo_nxt : part_quot_nxt;

  assign part_remd_r = muldiv_sbf_0_r;
  assign part_quot_r = muldiv_sbf_1_r;
  assign part_prdt_hi_r = muldiv_sbf_0_r;
  assign part_prdt_lo_r = muldiv_sbf_1_r;

  assign muldiv_i_longpipe = 1'b0;





`ifndef FPGA_SOURCE//{
`ifndef DISABLE_SV_ASSERTION//{
//synopsys translate_off
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// These below code are used for reference check with assertion
  wire [31:0] golden0_mul_op1 = mul_op1[32] ? (~mul_op1[31:0]+1) : mul_op1[31:0];
  wire [31:0] golden0_mul_op2 = mul_op2[32] ? (~mul_op2[31:0]+1) : mul_op2[31:0];
  wire [63:0] golden0_mul_res_pre = golden0_mul_op1 * golden0_mul_op2;
  wire [63:0] golden0_mul_res = (mul_op1[32]^mul_op2[32]) ? (~golden0_mul_res_pre + 1) : golden0_mul_res_pre;
  wire [63:0] golden1_mul_res = $signed(mul_op1) * $signed(mul_op2); 
  
  // To check the signed * operation is really get what we wanted
    CHECK_SIGNED_OP_CORRECT:
      assert property (@(posedge clk) disable iff ((~rst_n) | (~muldiv_o_valid))  ((golden0_mul_res == golden1_mul_res)))
      else $fatal ("\n Error: Oops, This should never happen. \n");

  wire [31:0] golden1_res_mul    = golden1_mul_res[31:0];
  wire [31:0] golden1_res_mulh   = golden1_mul_res[63:32];                       
  wire [31:0] golden1_res_mulhsu = golden1_mul_res[63:32];                                              
  wire [31:0] golden1_res_mulhu  = golden1_mul_res[63:32];                                                

  wire [63:0] golden2_res_mul_SxS = $signed(muldiv_i_rs1)   * $signed(muldiv_i_rs2);
  wire [63:0] golden2_res_mul_SxU = $signed(muldiv_i_rs1)   * $unsigned(muldiv_i_rs2);
  wire [63:0] golden2_res_mul_UxS = $unsigned(muldiv_i_rs1) * $signed(muldiv_i_rs2);
  wire [63:0] golden2_res_mul_UxU = $unsigned(muldiv_i_rs1) * $unsigned(muldiv_i_rs2);
  
  wire [31:0] golden2_res_mul    = golden2_res_mul_SxS[31:0];
  wire [31:0] golden2_res_mulh   = golden2_res_mul_SxS[63:32];                       
  wire [31:0] golden2_res_mulhsu = golden2_res_mul_SxU[63:32];                                              
  wire [31:0] golden2_res_mulhu  = golden2_res_mul_UxU[63:32];                                                

  // To check four different combination will all generate same lower 32bits result
    CHECK_FOUR_COMB_SAME_RES:
      assert property (@(posedge clk) disable iff ((~rst_n) | (~muldiv_o_valid))
          (golden2_res_mul_SxS[31:0] == golden2_res_mul_SxU[31:0])
        & (golden2_res_mul_UxS[31:0] == golden2_res_mul_UxU[31:0])
        & (golden2_res_mul_SxU[31:0] == golden2_res_mul_UxS[31:0])
       )
      else $fatal ("\n Error: Oops, This should never happen. \n");

      // Seems the golden2 result is not correct in case of mulhsu, so have to comment it out
 // // To check golden1 and golden2 result are same
 //   CHECK_GOLD1_AND_GOLD2_SAME:
 //     assert property (@(posedge clk) disable iff ((~rst_n) | (~muldiv_o_valid))
 //         (i_mul    ? (golden1_res_mul    == golden2_res_mul   ) : 1'b1)
 //        &(i_mulh   ? (golden1_res_mulh   == golden2_res_mulh  ) : 1'b1)
 //        &(i_mulhsu ? (golden1_res_mulhsu == golden2_res_mulhsu) : 1'b1)
 //        &(i_mulhu  ? (golden1_res_mulhu  == golden2_res_mulhu ) : 1'b1)
 //      )
 //     else $fatal ("\n Error: Oops, This should never happen. \n");
      
     // The special case will need to be handled specially
  wire [32:0] golden_res_div  = div_special_cases ? div_special_res : 
     (  $signed({div_rs1_sign,muldiv_i_rs1})   / ((div_by_0 | div_ovf) ? 1 :   $signed({div_rs2_sign,muldiv_i_rs2})));
  wire [32:0] golden_res_divu  = div_special_cases ? div_special_res : 
     ($unsigned({div_rs1_sign,muldiv_i_rs1})   / ((div_by_0 | div_ovf) ? 1 : $unsigned({div_rs2_sign,muldiv_i_rs2})));
  wire [32:0] golden_res_rem  = div_special_cases ? div_special_res : 
     (  $signed({div_rs1_sign,muldiv_i_rs1})   % ((div_by_0 | div_ovf) ? 1 :   $signed({div_rs2_sign,muldiv_i_rs2})));
  wire [32:0] golden_res_remu  = div_special_cases ? div_special_res : 
     ($unsigned({div_rs1_sign,muldiv_i_rs1})   % ((div_by_0 | div_ovf) ? 1 : $unsigned({div_rs2_sign,muldiv_i_rs2})));
 
  // To check golden and actual result are same
  wire [`E203_XLEN-1:0] golden_res = 
         i_mul    ? golden1_res_mul    :
         i_mulh   ? golden1_res_mulh   :
         i_mulhsu ? golden1_res_mulhsu :
         i_mulhu  ? golden1_res_mulhu  :
         i_div    ? golden_res_div [31:0]    :
         i_divu   ? golden_res_divu[31:0]    :
         i_rem    ? golden_res_rem [31:0]    :
         i_remu   ? golden_res_remu[31:0]    :
                    `E203_XLEN'b0;

  CHECK_GOLD_AND_ACTUAL_SAME:
        // Since the printed value is not aligned with posedge clock, so change it to negetive
    assert property (@(negedge clk) disable iff ((~rst_n) | flush_pulse)
        (muldiv_o_valid ? (golden_res == muldiv_o_wbck_wdat   ) : 1'b1)
     )
    else begin
        $display("??????????????????????????????????????????");
        $display("??????????????????????????????????????????");
        $display("{i_mul,i_mulh,i_mulhsu,i_mulhu,i_div,i_divu,i_rem,i_remu}=%d%d%d%d%d%d%d%d",i_mul,i_mulh,i_mulhsu,i_mulhu,i_div,i_divu,i_rem,i_remu);
        $display("muldiv_i_rs1=%h\nmuldiv_i_rs2=%h\n",muldiv_i_rs1,muldiv_i_rs2);     
        $display("golden_res=%h\nmuldiv_o_wbck_wdat=%h",golden_res,muldiv_o_wbck_wdat);     
        $display("??????????????????????????????????????????");
        $fatal ("\n Error: Oops, This should never happen. \n");
      end

//synopsys translate_on
`endif//}
`endif//}


endmodule                                      
`endif//}
                                               
                                               
                                               
