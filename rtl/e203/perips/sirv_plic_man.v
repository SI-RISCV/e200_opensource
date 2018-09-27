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
                                                                         
                                                                         
                                                                         
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  This is the hand-coded version of PLIC to replace the chisel generated one
//
// ====================================================================

module sirv_plic_man # (
    parameter PLIC_PRIO_WIDTH = 3,
    parameter PLIC_IRQ_NUM = 8,// Must larger than 1, if just 1 interrupt, please go without PLIC
    parameter PLIC_IRQ_NUM_LOG2 = 3,//  If the irq is 1<N<=2, then log2 value is 1;
                                    //  If the irq is 2<N<=4, then log2 value is 2;
                                    //  If the irq is 4<N<=8, then log2 value is 3;
                                    //  ....etc
                                    //  We at most support 10 levels, then 1024 interrupt sources
                                    //  But the source 0 is just always tied to zero
                                    
    parameter PLIC_ICB_RSP_FLOP = 0, // Do we flop the ICB response channel to easy timing
    parameter PLIC_IRQ_I_FLOP = 0, // Do we flop the input interrupts from sources
    parameter PLIC_IRQ_O_FLOP = 0  // Do we flop the output interrupt to the Core target
)(
  input   clk,
  input   rst_n,

  input                      icb_cmd_valid,
  output                     icb_cmd_ready,
  input  [24-1:0]            icb_cmd_addr, 
  input                      icb_cmd_read, 
  input  [32-1:0]            icb_cmd_wdata,
  
  output                     icb_rsp_valid,
  input                      icb_rsp_ready,
  output [32-1:0]            icb_rsp_rdata,

  input  [PLIC_IRQ_NUM-1:0]      plic_irq_i,
  output plic_irq_o
);

// If there are 32 irq, then we need 1 pend-array ([31:0])
// If there are 40 irq, then we need 2 pend-array ([39:32],[31:0])
// If there are 64 irq, then we need 2 pend-array ([63:32],[31:0])
localparam PLIC_PEND_ARRAY = (((PLIC_IRQ_NUM-1)/32) + 1);

 wire icb_cmd_hsked    = icb_cmd_valid & icb_cmd_ready;
 wire icb_cmd_wr_hsked = icb_cmd_hsked & (~icb_cmd_read); 
 wire icb_cmd_rd_hsked = icb_cmd_hsked & icb_cmd_read; 


 wire [PLIC_IRQ_NUM-1:0]  plic_irq_i_r;
 wire [PLIC_IRQ_NUM-1:0]  irq_i_gated_valid;
 wire [PLIC_IRQ_NUM-1:0]  irq_i_gated_ready;
 wire [PLIC_IRQ_NUM-1:0]  irq_i_gated_hsked;

 reg [PLIC_IRQ_NUM-1:0]  icb_claim_irq;
 reg [PLIC_IRQ_NUM-1:0]  icb_complete_irq;

 wire irq_o;

 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id ;
 wire [PLIC_IRQ_NUM_LOG2-1:0] plic_irq_id ;
 wire [PLIC_PRIO_WIDTH-1:0] plic_irq_prio ;

 wire [PLIC_IRQ_NUM-1:0]  irq_pend_set;
 wire [PLIC_IRQ_NUM-1:0]  irq_pend_clr;
 wire [PLIC_IRQ_NUM-1:0]  irq_pend_ena;
 wire [PLIC_IRQ_NUM-1:0]  irq_pend_nxt;
 wire [PLIC_PEND_ARRAY*32-1:0] irq_pend_r;  // The IP bit per interrupt source

 
 wire [PLIC_PEND_ARRAY-1:0] icb_cmd_sel_pend;
 wire icb_cmd_sel_clam;

 wire icb_cmd_sel_thod;
 wire irq_thod_ena;
 wire [PLIC_PRIO_WIDTH-1:0] irq_thod_nxt; 
 wire [PLIC_PRIO_WIDTH-1:0] irq_thod_r  ; // The  priority per interrupt source

 wire [PLIC_IRQ_NUM-1:0]  icb_cmd_sel_prio;
 wire [PLIC_IRQ_NUM-1:0]  irq_prio_ena;
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_nxt [PLIC_IRQ_NUM-1:0];
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_r [PLIC_IRQ_NUM-1:0];  // The  priority per interrupt source
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_masked [PLIC_IRQ_NUM-1:0];  // The masked priority per interrupt source

 wire irq_prio_lvl_10_lt [1024-1:0]; // The level-10 max priority array
 wire irq_prio_lvl_9_lt  [512-1:0] ; // The level-9  max priority array
 wire irq_prio_lvl_8_lt  [256-1:0] ; // The level-8  max priority array
 wire irq_prio_lvl_7_lt  [128-1:0] ; // The level-7  max priority array
 wire irq_prio_lvl_6_lt  [64-1:0]  ; // The level-6  max priority array
 wire irq_prio_lvl_5_lt  [32-1:0]  ; // The level-5  max priority array
 wire irq_prio_lvl_4_lt  [16-1:0]  ; // The level-4  max priority array
 wire irq_prio_lvl_3_lt  [8-1:0]   ; // The level-3  max priority array
 wire irq_prio_lvl_2_lt  [4-1:0]   ; // The level-2  max priority array
 wire irq_prio_lvl_1_lt  [2-1:0]   ; // The level-1  max priority array
 wire irq_prio_top_lt              ; // The level-0  max priority 

 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_10 [1024-1:0] ; // The level-10 max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_9  [512-1:0]  ; // The level-9  max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_8  [256-1:0]  ; // The level-8  max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_7  [128-1:0]  ; // The level-7  max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_6  [64-1:0]   ; // The level-6  max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_5  [32-1:0]   ; // The level-5  max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_4  [16-1:0]   ; // The level-4  max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_3  [8-1:0]    ; // The level-3  max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_2  [4-1:0]    ; // The level-2  max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_lvl_1  [2-1:0]    ; // The level-1  max priority array
 wire [PLIC_PRIO_WIDTH-1:0] irq_prio_top               ; // The level-0  max priority 
                                                                         
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_10 [1024-1:0] ; // The level-10 max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_9  [512-1:0]  ; // The level-9  max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_8  [256-1:0]  ; // The level-8  max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_7  [128-1:0]  ; // The level-7  max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_6  [64-1:0]   ; // The level-6  max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_5  [32-1:0]   ; // The level-5  max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_4  [16-1:0]   ; // The level-4  max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_3  [8-1:0]    ; // The level-3  max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_2  [4-1:0]    ; // The level-2  max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_lvl_1  [2-1:0]    ; // The level-1  max id array
 wire [PLIC_IRQ_NUM_LOG2-1:0] irq_id_top               ; // The level-0  max id 

 wire irq_ip_lvl_10 [1024-1:0] ; // The level-10 IP array
 wire irq_ip_lvl_9  [512-1:0]  ; // The level-9  IP array
 wire irq_ip_lvl_8  [256-1:0]  ; // The level-8  IP array
 wire irq_ip_lvl_7  [128-1:0]  ; // The level-7  IP array
 wire irq_ip_lvl_6  [64-1:0]   ; // The level-6  IP array
 wire irq_ip_lvl_5  [32-1:0]   ; // The level-5  IP array
 wire irq_ip_lvl_4  [16-1:0]   ; // The level-4  IP array
 wire irq_ip_lvl_3  [8-1:0]    ; // The level-3  IP array
 wire irq_ip_lvl_2  [4-1:0]    ; // The level-2  IP array
 wire irq_ip_lvl_1  [2-1:0]    ; // The level-1  IP array
 wire irq_ip_top               ; // The level-0  IP 

 wire          icb_cmd_sel_enab [PLIC_PEND_ARRAY-1:0];
 wire          irq_enab_ena     [PLIC_PEND_ARRAY-1:0];
 wire [32-1:0] irq_enab_nxt     [PLIC_PEND_ARRAY-1:0];
 wire [32-1:0] irq_enab_r       [PLIC_PEND_ARRAY-1:0];

 wire plic_irq_o_pre;

 genvar i;
 integer ii;

 generate 
   if(PLIC_IRQ_I_FLOP == 1) begin: flop_i_irq
      sirv_gnrl_dffr #(PLIC_IRQ_NUM) plic_irq_i_dffr(plic_irq_i , plic_irq_i_r, clk, rst_n);
   end
   else begin: no_flop_i_irq
      assign plic_irq_i_r = plic_irq_i;
   end

   if(PLIC_IRQ_O_FLOP == 1) begin: flop_o_irq
        sirv_gnrl_dffr #(1) plic_irq_o_dffr(irq_o , plic_irq_o_pre, clk, rst_n);
        sirv_gnrl_dffr #(PLIC_IRQ_NUM_LOG2) plic_irq_id_dffr(irq_id , plic_irq_id, clk, rst_n);
        sirv_gnrl_dffr #(PLIC_PRIO_WIDTH) plic_irq_prio_dffr(irq_prio_top , plic_irq_prio, clk, rst_n);
   end
   else begin: no_flop_o_irq
        assign plic_irq_o_pre  = irq_o ;
        assign plic_irq_id = irq_id;
        assign plic_irq_prio = irq_prio_top;
   end

     assign plic_irq_o = plic_irq_o_pre;// & (plic_irq_prio > irq_thod_r);

     assign irq_i_gated_hsked[0] = 1'b0;
     assign irq_i_gated_valid[0] = 1'b0;
     assign irq_i_gated_ready[0] = 1'b0;

     assign irq_pend_set[0] = 1'b0;
     assign irq_pend_clr[0] = 1'b0;
     assign irq_pend_ena[0] = 1'b0;
     assign irq_pend_nxt[0] = 1'b0;
     assign irq_pend_r  [0] = 1'b0;

     assign irq_prio_ena[0] = 1'b0;
     assign irq_prio_nxt[0] = {PLIC_PRIO_WIDTH{1'b0}};
     assign irq_prio_r[0]   = {PLIC_PRIO_WIDTH{1'b0}};
 
     assign irq_prio_masked[0] = {PLIC_PRIO_WIDTH{1'b0}};

   for(i=1; i<PLIC_IRQ_NUM;i=i+1) begin: source_gen//{
       ///////////////////////////////////////////////////////////////////
       // Implment the gateway for each interrupt source
       //
     sirv_LevelGateway u_LevelGateway_1_1 (
       .clock           (clk   ),
       .reset           (~rst_n),
       .io_interrupt    (plic_irq_i_r[i]),
       .io_plic_valid   (irq_i_gated_valid[i]),
       .io_plic_ready   (irq_i_gated_ready[i]),
       .io_plic_complete(icb_complete_irq[i])
     );

     assign irq_i_gated_hsked[i] = irq_i_gated_valid[i] & irq_i_gated_ready[i];

       ///////////////////////////////////////////////////////////////////
       // Implment the IP bit for each interrupt source
       //
     // If the pending irq is cleared, then it is ready to accept new interrupt from gateway
     assign irq_i_gated_ready[i] = (~irq_pend_r[i]);

        // The IRQ pend is set when the gateway output handshaked
     assign irq_pend_set[i] = irq_i_gated_hsked[i];
        // The IRQ pend is cleared when the interrupt is claimed, according to the spec:
        //   After the highest-priority pending interrupt is claimed by a target and the
        //   corresponding IP bit is cleared.
     assign irq_pend_clr[i] = icb_claim_irq[i];
     assign irq_pend_ena[i] = (irq_pend_set[i] | irq_pend_clr[i]);
     assign irq_pend_nxt[i] = (irq_pend_set[i] | (~irq_pend_clr[i]));

     sirv_gnrl_dfflr #(1) irq_pend_dfflr(irq_pend_ena[i] , irq_pend_nxt[i], irq_pend_r[i], clk, rst_n);

       ///////////////////////////////////////////////////////////////////
       // Implment the Priority for each interrupt source
       //
       // The priority will be set by bus writting
     assign irq_prio_ena[i] = icb_cmd_wr_hsked & icb_cmd_sel_prio[i];
     assign irq_prio_nxt[i] = icb_cmd_wdata[PLIC_PRIO_WIDTH-1:0];
     sirv_gnrl_dfflr #(PLIC_PRIO_WIDTH) irq_prio_dfflr(irq_prio_ena[i] , irq_prio_nxt[i], irq_prio_r[i], clk, rst_n);
 
       ///////////////////////////////////////////////////////////////////
       // The priority will be masked to zero, if the IP is not set
       //
     assign irq_prio_masked[i] = irq_prio_r[i] & {PLIC_PRIO_WIDTH{irq_pend_r[i]}};
   end//}

   for(i=PLIC_IRQ_NUM; i<(PLIC_PEND_ARRAY*32);i=i+1) begin: pend_gen//{
       assign irq_pend_r[i] = 1'b0;
   end//}

       ///////////////////////////////////////////////////////////////////
       // Implment the IE for each interrupt source and target
       //
   for(i=0; i<(PLIC_PEND_ARRAY);i=i+1) begin: enab_r_i//{
     // The IE will be set by bus writting
     assign irq_enab_ena[i] = icb_cmd_sel_enab[i] & icb_cmd_wr_hsked;
     sirv_gnrl_dfflr #(32) irq_enab_dfflr(irq_enab_ena[i], irq_enab_nxt[i], irq_enab_r[i], clk, rst_n);

     if(i == 0)begin: i0_ena
       assign irq_enab_nxt[i] = {icb_cmd_wdata[31:1],1'b0};// The 0-interrupt is always 0
     end
     else if((PLIC_PEND_ARRAY-1) == i) begin:last_one
         if((PLIC_IRQ_NUM%32) == 0) begin:irq_num_div_32
           assign irq_enab_nxt[i] = icb_cmd_wdata[31:0];
         end
         else begin:irq_num_not_div_32
           assign irq_enab_nxt[i] = icb_cmd_wdata[(PLIC_IRQ_NUM%32)-1:0];
         end
     end
     else begin:no_last_one
       assign irq_enab_nxt[i] = icb_cmd_wdata[31:0];
     end

   end//}

   
       ///////////////////////////////////////////////////////////////////
       // Implment the Threshold for each interrupt target
       //
       //
       // The Threshold will be set by bus writting
   assign irq_thod_ena = icb_cmd_wr_hsked & icb_cmd_sel_thod;
   assign irq_thod_nxt = icb_cmd_wdata[PLIC_PRIO_WIDTH-1:0];
   sirv_gnrl_dfflr #(PLIC_PRIO_WIDTH) irq_thod_dfflr(irq_thod_ena , irq_thod_nxt, irq_thod_r, clk, rst_n);



     ///////////////////////////////////////////////////////////////////
     ///////////////////////////////////////////////////////////////////
     // Use the binary-tree structure to compare and select the pending interrupt
     //   source with the max priority and its ID
     //
         // Generate the level-10 signals
             // We need to tie the unused signals to zeros
             //  and the synthesis tools will automatically 
             //  optimize unused logics to zeros
             //
             // Tie the irq0 relevant logics to 0
         assign irq_prio_lvl_10[0] = {PLIC_PRIO_WIDTH{1'b0}};  
         assign irq_id_lvl_10  [0] = {PLIC_IRQ_NUM_LOG2{1'b0}};
         assign irq_ip_lvl_10  [0] = 1'b0;
     for(i=1; i<PLIC_IRQ_NUM;i=i+1) begin: tie_input//{
            // The priority will be masked to zero, if the IE is not set
         assign irq_prio_lvl_10[i] = irq_prio_masked[i] & {PLIC_PRIO_WIDTH{irq_enab_r[i/32][i%32]}};
         assign irq_id_lvl_10  [i] = i[PLIC_IRQ_NUM_LOG2-1:0];
         assign irq_ip_lvl_10  [i] = irq_pend_r[i] & irq_enab_r[i/32][i%32];
     end//}

     for(i=PLIC_IRQ_NUM; i<1024;i=i+1) begin: tie_unused_tozero//{
         assign irq_prio_lvl_10[i] = {PLIC_PRIO_WIDTH{1'b0}};  
         assign irq_id_lvl_10  [i] = i[PLIC_IRQ_NUM_LOG2-1:0];
         assign irq_ip_lvl_10  [i] = 1'b0;
     end//}


         // Generate the level-9 comp
     for(i=0; i<512;i=i+1) begin: lvl_9_comp_gen//{
         assign irq_prio_lvl_9_lt[i] = (irq_prio_lvl_10[2*i] < irq_prio_lvl_10[(2*i)+1]); 
         assign irq_prio_lvl_9[i] = irq_prio_lvl_9_lt[i] ? irq_prio_lvl_10[(2*i)+1] : irq_prio_lvl_10[2*i];
         assign irq_id_lvl_9  [i] = irq_prio_lvl_9_lt[i] ? irq_id_lvl_10  [(2*i)+1] : irq_id_lvl_10  [2*i];
         assign irq_ip_lvl_9  [i] = irq_prio_lvl_9_lt[i] ? irq_ip_lvl_10  [(2*i)+1] : irq_ip_lvl_10  [2*i];
     end//}
         // Generate the level-8 comp
     for(i=0; i<256;i=i+1) begin: lvl_8_comp_gen//{
         assign irq_prio_lvl_8_lt[i] = (irq_prio_lvl_9[2*i] < irq_prio_lvl_9[(2*i)+1]); 
         assign irq_prio_lvl_8[i] = irq_prio_lvl_8_lt[i] ? irq_prio_lvl_9[(2*i)+1] : irq_prio_lvl_9[2*i];
         assign irq_id_lvl_8  [i] = irq_prio_lvl_8_lt[i] ? irq_id_lvl_9  [(2*i)+1] : irq_id_lvl_9  [2*i];
         assign irq_ip_lvl_8  [i] = irq_prio_lvl_8_lt[i] ? irq_ip_lvl_9  [(2*i)+1] : irq_ip_lvl_9  [2*i];
     end//}
         // Generate the level-7 comp
     for(i=0; i<128;i=i+1) begin: lvl_7_comp_gen//{
         assign irq_prio_lvl_7_lt[i] = (irq_prio_lvl_8[2*i] < irq_prio_lvl_8[(2*i)+1]); 
         assign irq_prio_lvl_7[i] = irq_prio_lvl_7_lt[i] ? irq_prio_lvl_8[(2*i)+1] : irq_prio_lvl_8[2*i];
         assign irq_id_lvl_7  [i] = irq_prio_lvl_7_lt[i] ? irq_id_lvl_8  [(2*i)+1] : irq_id_lvl_8  [2*i];
         assign irq_ip_lvl_7  [i] = irq_prio_lvl_7_lt[i] ? irq_ip_lvl_8  [(2*i)+1] : irq_ip_lvl_8  [2*i];
     end//}
         // Generate the level-6 comp
     for(i=0; i<64;i=i+1) begin: lvl_6_comp_gen//{
         assign irq_prio_lvl_6_lt[i] = (irq_prio_lvl_7[2*i] < irq_prio_lvl_7[(2*i)+1]); 
         assign irq_prio_lvl_6[i] = irq_prio_lvl_6_lt[i] ? irq_prio_lvl_7[(2*i)+1] : irq_prio_lvl_7[2*i];
         assign irq_id_lvl_6  [i] = irq_prio_lvl_6_lt[i] ? irq_id_lvl_7  [(2*i)+1] : irq_id_lvl_7  [2*i];
         assign irq_ip_lvl_6  [i] = irq_prio_lvl_6_lt[i] ? irq_ip_lvl_7  [(2*i)+1] : irq_ip_lvl_7  [2*i];
     end//}
         // Generate the level-5 comp
     for(i=0; i<32;i=i+1) begin: lvl_5_comp_gen//{
         assign irq_prio_lvl_5_lt[i] = (irq_prio_lvl_6[2*i] < irq_prio_lvl_6[(2*i)+1]); 
         assign irq_prio_lvl_5[i] = irq_prio_lvl_5_lt[i] ? irq_prio_lvl_6[(2*i)+1] : irq_prio_lvl_6[2*i];
         assign irq_id_lvl_5  [i] = irq_prio_lvl_5_lt[i] ? irq_id_lvl_6  [(2*i)+1] : irq_id_lvl_6  [2*i];
         assign irq_ip_lvl_5  [i] = irq_prio_lvl_5_lt[i] ? irq_ip_lvl_6  [(2*i)+1] : irq_ip_lvl_6  [2*i];
     end//}
         // Generate the level-4 comp
     for(i=0; i<16;i=i+1) begin: lvl_4_comp_gen//{
         assign irq_prio_lvl_4_lt[i] = (irq_prio_lvl_5[2*i] < irq_prio_lvl_5[(2*i)+1]); 
         assign irq_prio_lvl_4[i] = irq_prio_lvl_4_lt[i] ? irq_prio_lvl_5[(2*i)+1] : irq_prio_lvl_5[2*i];
         assign irq_id_lvl_4  [i] = irq_prio_lvl_4_lt[i] ? irq_id_lvl_5  [(2*i)+1] : irq_id_lvl_5  [2*i];
         assign irq_ip_lvl_4  [i] = irq_prio_lvl_4_lt[i] ? irq_ip_lvl_5  [(2*i)+1] : irq_ip_lvl_5  [2*i];
     end//}
         // Generate the level-3 comp
     for(i=0; i<8;i=i+1) begin: lvl_3_comp_gen//{
         assign irq_prio_lvl_3_lt[i] = (irq_prio_lvl_4[2*i] < irq_prio_lvl_4[(2*i)+1]); 
         assign irq_prio_lvl_3[i] = irq_prio_lvl_3_lt[i] ? irq_prio_lvl_4[(2*i)+1] : irq_prio_lvl_4[2*i];
         assign irq_id_lvl_3  [i] = irq_prio_lvl_3_lt[i] ? irq_id_lvl_4  [(2*i)+1] : irq_id_lvl_4  [2*i];
         assign irq_ip_lvl_3  [i] = irq_prio_lvl_3_lt[i] ? irq_ip_lvl_4  [(2*i)+1] : irq_ip_lvl_4  [2*i];
     end//}
         // Generate the level-2 comp
     for(i=0; i<4;i=i+1) begin: lvl_2_comp_gen//{
         assign irq_prio_lvl_2_lt[i] = (irq_prio_lvl_3[2*i] < irq_prio_lvl_3[(2*i)+1]); 
         assign irq_prio_lvl_2[i] = irq_prio_lvl_2_lt[i] ? irq_prio_lvl_3[(2*i)+1] : irq_prio_lvl_3[2*i];
         assign irq_id_lvl_2  [i] = irq_prio_lvl_2_lt[i] ? irq_id_lvl_3  [(2*i)+1] : irq_id_lvl_3  [2*i];
         assign irq_ip_lvl_2  [i] = irq_prio_lvl_2_lt[i] ? irq_ip_lvl_3  [(2*i)+1] : irq_ip_lvl_3  [2*i];
     end//}
         // Generate the level-1 comp
     for(i=0; i<2;i=i+1) begin: lvl_1_comp_gen//{
         assign irq_prio_lvl_1_lt[i] = (irq_prio_lvl_2[2*i] < irq_prio_lvl_2[(2*i)+1]); 
         assign irq_prio_lvl_1[i] = irq_prio_lvl_1_lt[i] ? irq_prio_lvl_2[(2*i)+1] : irq_prio_lvl_2[2*i];
         assign irq_id_lvl_1  [i] = irq_prio_lvl_1_lt[i] ? irq_id_lvl_2  [(2*i)+1] : irq_id_lvl_2  [2*i];
         assign irq_ip_lvl_1  [i] = irq_prio_lvl_1_lt[i] ? irq_ip_lvl_2  [(2*i)+1] : irq_ip_lvl_2  [2*i];
     end//}

     assign irq_prio_top_lt = (irq_prio_lvl_1[0] < irq_prio_lvl_1[1]); 
     assign irq_prio_top    = irq_prio_top_lt ? irq_prio_lvl_1[1] : irq_prio_lvl_1[0];
     assign irq_id_top      = irq_prio_top_lt ? irq_id_lvl_1  [1] : irq_id_lvl_1  [0];
     assign irq_ip_top      = irq_prio_top_lt ? irq_ip_lvl_1  [1] : irq_ip_lvl_1  [0];
     assign irq_o           = irq_ip_top & (irq_prio_top > irq_thod_r);
     assign irq_id          = irq_id_top;

 endgenerate




   ///////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////
   // Implement the ICB bus
   //   


 
   // The address map
 generate 
   //
         //   0x0C00_0004 source 1 priority
         //   0x0C00_0008 source 2 priority
         //   ...
         //   0x0C00_0FFC source 1023 priority
   for(i=0; i<PLIC_IRQ_NUM;i=i+1) begin: sel_prio//{
     assign icb_cmd_sel_prio[i] = (icb_cmd_addr == ($unsigned(i) * 4)); 
   end//}
   //
         //0x0C00 1000 Start of pending array
         //... (read-only)
         //0x0C00 107C End of pending array
   for(i=0; i<(PLIC_PEND_ARRAY);i=i+1) begin: sel_pend//{
     assign icb_cmd_sel_pend[i] = (icb_cmd_addr == (($unsigned(i) * 4) + 24'h1000)); 
   end//}

   //
         //0x0C00 1000 Start of target 0 enable array
         //0x0C00 107C End   of target 0 enable array
         //.... target 1
         //.... target 2
     for(i=0; i<(PLIC_PEND_ARRAY);i=i+1) begin: sel_enab_i//{
       assign icb_cmd_sel_enab[i] = (icb_cmd_addr == (($unsigned(i) * 4) + 24'h2000)); 
     end//}
   //
         // 0x0C20 0000 target 0 priority threshold
         // 0x0C20 0004 target 0 claim/complete
         // 0x0C20 1000 target 1 priority threshold
         // 0x0C20 1004 target 1 claim/complete
       assign icb_cmd_sel_thod = (icb_cmd_addr ==  (24'h20_0000)); 
       assign icb_cmd_sel_clam = (icb_cmd_addr ==  (24'h20_0004)); 
        
 endgenerate

   ///////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////
   // Implement the rdata mux
   //   
   reg [32-1:0] rsp_rdata_prio;
   reg [32-1:0] rsp_rdata_pend;
   reg [32-1:0] rsp_rdata_targ;

   always @* begin:rdat_prio_mux//{ 
       rsp_rdata_prio = 32'b0;

       for(ii=0; ii<PLIC_IRQ_NUM;ii=ii+1) begin: sel_prio//{
         rsp_rdata_prio = rsp_rdata_prio | ({32{icb_cmd_sel_prio[ii]}} & irq_prio_r[ii] );
       end//}
   end//}

   always @* begin:rdat_pend_mux//{ 
       rsp_rdata_pend = 32'b0;

       for(ii=0; ii<(PLIC_PEND_ARRAY);ii=ii+1) begin: sel_pend//{
         rsp_rdata_pend = rsp_rdata_pend | ({32{icb_cmd_sel_pend[ii]}} &  
                             {
                                irq_pend_r[ii*32+31], irq_pend_r[ii*32+30], irq_pend_r[ii*32+29], irq_pend_r[ii*32+28], 
                                irq_pend_r[ii*32+27], irq_pend_r[ii*32+26], irq_pend_r[ii*32+25], irq_pend_r[ii*32+24], 
                                irq_pend_r[ii*32+23], irq_pend_r[ii*32+22], irq_pend_r[ii*32+21], irq_pend_r[ii*32+20], 
                                irq_pend_r[ii*32+19], irq_pend_r[ii*32+18], irq_pend_r[ii*32+17], irq_pend_r[ii*32+16], 
                                irq_pend_r[ii*32+15], irq_pend_r[ii*32+14], irq_pend_r[ii*32+13], irq_pend_r[ii*32+12], 
                                irq_pend_r[ii*32+11], irq_pend_r[ii*32+10], irq_pend_r[ii*32+09], irq_pend_r[ii*32+08], 
                                irq_pend_r[ii*32+07], irq_pend_r[ii*32+06], irq_pend_r[ii*32+05], irq_pend_r[ii*32+04], 
                                irq_pend_r[ii*32+03], irq_pend_r[ii*32+02], irq_pend_r[ii*32+01], irq_pend_r[ii*32+00]  
                             });
       end//}
   end//}

   always @* begin:rdat_targ_mux//{ 
       rsp_rdata_targ = 32'b0;

       rsp_rdata_targ = rsp_rdata_targ | ({32{icb_cmd_sel_thod}} & irq_thod_r ); 
       rsp_rdata_targ = rsp_rdata_targ | ({32{icb_cmd_sel_clam}} & plic_irq_id);
       for(ii=0; ii<(PLIC_PEND_ARRAY);ii=ii+1) begin: sel_enab_i//{
           rsp_rdata_targ = rsp_rdata_targ | ({32{icb_cmd_sel_enab[ii]}} & irq_enab_r[ii]);
       end//}
       //
   end//}

   wire [32-1:0] rsp_rdata = rsp_rdata_prio | rsp_rdata_pend | rsp_rdata_targ;

   generate 
     if(PLIC_ICB_RSP_FLOP == 1) begin: flop_icb_rsp
     sirv_gnrl_pipe_stage # (
      .CUT_READY(1),
      .DP(1),
      .DW(32)
     ) u_buf_icb_rsp_buf(
       .i_vld(icb_cmd_valid), 
       .i_rdy(icb_cmd_ready), 
       .i_dat(rsp_rdata),
       .o_vld(icb_rsp_valid), 
       .o_rdy(icb_rsp_ready), 
       .o_dat(icb_rsp_rdata),
     
       .clk  (clk  ),
       .rst_n(rst_n)  
      );
     end
     else begin: no_flop_icb_rsp
          // Directly connect the response channel with the command channel for handshake
       assign icb_rsp_valid = icb_cmd_valid;
       assign icb_cmd_ready = icb_rsp_ready;
       assign icb_rsp_rdata = rsp_rdata;
     end
   endgenerate



   generate 
   //
   for(i=0; i<PLIC_IRQ_NUM;i=i+1) begin: claim_complete_gen//{

     always @* begin:claim_complete//{ 
         icb_claim_irq   [i] = 1'b0;
         icb_complete_irq[i] = 1'b0;

                                       // The read data (claimed ID) is equal to the interrupt source ID
         icb_claim_irq   [i] = icb_claim_irq[i] | ((icb_rsp_rdata == i) & icb_cmd_sel_clam & icb_cmd_rd_hsked);
                                       // The write data (complete ID) is equal to the interrupt source ID
         icb_complete_irq[i] = icb_complete_irq[i] | ((icb_cmd_wdata[PLIC_IRQ_NUM_LOG2-1:0] == i) & icb_cmd_sel_clam & icb_cmd_wr_hsked);

     end//}

   end//}
   endgenerate


endmodule
