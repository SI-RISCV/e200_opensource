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
                                                                         
                                                                         
                                                                         
module sirv_uarttx(
  input   clock,
  input   reset,
  input   io_en,
  output  io_in_ready,
  input   io_in_valid,
  input  [7:0] io_in_bits,
  output  io_out,
  input  [15:0] io_div,
  input   io_nstop
);
  reg [15:0] prescaler;
  reg [31:0] GEN_6;
  wire  pulse;
  reg [3:0] counter;
  reg [31:0] GEN_7;
  reg [8:0] shifter;
  reg [31:0] GEN_8;
  reg  out;
  reg [31:0] GEN_9;
  wire  busy;
  wire  T_32;
  wire  T_33;
  wire  T_34;
  wire  T_36;
  wire [8:0] T_38;
  wire  T_40;
  wire [3:0] T_46;
  wire [3:0] T_48;
  wire [3:0] T_50;
  wire [3:0] T_51;
  wire [8:0] GEN_0;
  wire [3:0] GEN_1;
  wire [16:0] T_53;
  wire [15:0] T_54;
  wire [15:0] T_55;
  wire [15:0] GEN_2;
  wire  T_56;
  wire [4:0] T_58;
  wire [3:0] T_59;
  wire [7:0] T_61;
  wire [8:0] T_62;
  wire  T_63;
  wire [3:0] GEN_3;
  wire [8:0] GEN_4;
  wire  GEN_5;
  assign io_in_ready = T_33;
  assign io_out = out;
  assign pulse = prescaler == 16'h0;
  assign busy = counter != 4'h0;
  assign T_32 = busy == 1'h0;
  assign T_33 = io_en & T_32;
  assign T_34 = io_in_ready & io_in_valid;
  assign T_36 = reset == 1'h0;
  assign T_38 = {io_in_bits,1'h0};
  assign T_40 = io_nstop == 1'h0;
  assign T_46 = T_40 ? 4'ha : 4'h0;
  assign T_48 = io_nstop ? 4'hb : 4'h0;
  assign T_50 = T_46 | T_48;
  assign T_51 = T_50;
  assign GEN_0 = T_34 ? T_38 : shifter;
  assign GEN_1 = T_34 ? T_51 : counter;
  assign T_53 = prescaler - 16'h1;
  assign T_54 = T_53[15:0];
  assign T_55 = pulse ? io_div : T_54;
  assign GEN_2 = busy ? T_55 : prescaler;
  assign T_56 = pulse & busy;
  assign T_58 = counter - 4'h1;
  assign T_59 = T_58[3:0];
  assign T_61 = shifter[8:1];
  assign T_62 = {1'h1,T_61};
  assign T_63 = shifter[0];
  assign GEN_3 = T_56 ? T_59 : GEN_1;
  assign GEN_4 = T_56 ? T_62 : GEN_0;
  assign GEN_5 = T_56 ? T_63 : out;

  always @(posedge clock or posedge reset)
    if (reset) begin
      prescaler <= 16'h0;
    end else begin
      if (busy) begin
        if (pulse) begin
          prescaler <= io_div;
        end else begin
          prescaler <= T_54;
        end
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      counter <= 4'h0;
    end else begin
      if (T_56) begin
        counter <= T_59;
      end else begin
        if (T_34) begin
          counter <= T_51;
        end
      end
    end



  always @(posedge clock or posedge reset)
  if (reset) begin
      shifter <= 9'b0;
  end
  else begin
    if (T_56) begin
      shifter <= T_62;
    end else begin
      if (T_34) begin
        shifter <= T_38;
      end
    end
  end


  always @(posedge clock or posedge reset)
    if (reset) begin
      out <= 1'h1;
    end else begin
      if (T_56) begin
        out <= T_63;
      end
    end

    //`ifndef SYNTHESIS
    //`ifdef PRINTF_COND
    //  if (`PRINTF_COND) begin
    //`endif
    //    if (T_34 & T_36) begin
    //      $fwrite(32'h80000002,"%c",io_in_bits);
    //    end
    //`ifdef PRINTF_COND
    //  end
    //`endif
    //`endif

    //synopsys translate_off
  always @(posedge clock or posedge reset) begin
        if (T_34 & T_36) begin
          $fwrite(32'h80000002,"%c",io_in_bits);
        end
  end
    //synopsys translate_on
endmodule

