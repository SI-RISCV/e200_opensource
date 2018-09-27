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
                                                                         
                                                                         
                                                                         
module sirv_uartrx(
  input   clock,
  input   reset,
  input   io_en,
  input   io_in,
  output  io_out_valid,
  output [7:0] io_out_bits,
  input  [15:0] io_div
);
  reg [1:0] debounce;
  reg [31:0] GEN_7;
  wire  debounce_max;
  wire  debounce_min;
  reg [11:0] prescaler;
  reg [31:0] GEN_20;
  wire  start;
  wire  busy;
  wire  T_21;
  wire  pulse;
  wire [12:0] T_23;
  wire [11:0] T_24;
  wire [11:0] GEN_0;
  wire  T_25;
  wire [11:0] T_26;
  wire [11:0] GEN_1;
  reg [2:0] sample;
  reg [31:0] GEN_23;
  wire  T_28;
  wire  T_29;
  wire  T_30;
  wire  T_31;
  wire  T_32;
  wire  T_33;
  wire  T_34;
  wire  T_35;
  wire [3:0] T_36;
  wire [3:0] GEN_2;
  reg [4:0] timer;
  reg [31:0] GEN_28;
  reg [3:0] counter;
  reg [31:0] GEN_43;
  reg [7:0] shifter;
  reg [31:0] GEN_44;
  wire  T_41;
  wire  expire;
  wire  sched;
  wire [5:0] T_44;
  wire [4:0] T_45;
  wire [4:0] GEN_3;
  wire [4:0] GEN_4;
  reg  valid;
  reg [31:0] GEN_45;
  reg [1:0] state;
  reg [31:0] GEN_46;
  wire  T_50;
  wire  T_52;
  wire  T_54;
  wire  T_56;
  wire  T_57;
  wire [2:0] T_59;
  wire [1:0] T_60;
  wire [1:0] GEN_5;
  wire [2:0] T_64;
  wire [1:0] T_65;
  wire [1:0] GEN_6;
  wire [4:0] GEN_8;
  wire [1:0] GEN_9;
  wire [1:0] GEN_10;
  wire  GEN_11;
  wire [4:0] GEN_12;
  wire [1:0] GEN_13;
  wire [1:0] GEN_14;
  wire  GEN_15;
  wire [4:0] GEN_16;
  wire  T_68;
  wire [1:0] GEN_17;
  wire  T_72;
  wire [1:0] GEN_18;
  wire [3:0] GEN_19;
  wire [1:0] GEN_21;
  wire [3:0] GEN_22;
  wire  GEN_24;
  wire [1:0] GEN_25;
  wire [3:0] GEN_26;
  wire  T_74;
  wire [4:0] T_77;
  wire [3:0] T_78;
  wire  T_80;
  wire [1:0] GEN_27;
  wire  T_83;
  wire [6:0] T_84;
  wire [7:0] T_85;
  wire [7:0] GEN_29;
  wire  GEN_30;
  wire [3:0] GEN_31;
  wire [1:0] GEN_32;
  wire  GEN_33;
  wire [7:0] GEN_34;
  wire  GEN_35;
  wire  GEN_36;
  wire [3:0] GEN_37;
  wire [1:0] GEN_38;
  wire  GEN_39;
  wire [7:0] GEN_40;
  wire  GEN_41;
  wire  T_88;
  wire [1:0] GEN_42;
  assign io_out_valid = valid;
  assign io_out_bits = shifter;
  assign debounce_max = debounce == 2'h3;
  assign debounce_min = debounce == 2'h0;
  assign start = GEN_15;
  assign busy = GEN_36;
  assign T_21 = prescaler == 12'h0;
  assign pulse = T_21 & busy;
  assign T_23 = prescaler - 12'h1;
  assign T_24 = T_23[11:0];
  assign GEN_0 = busy ? T_24 : prescaler;
  assign T_25 = start | pulse;
  assign T_26 = io_div[15:4];
  assign GEN_1 = T_25 ? T_26 : GEN_0;
  assign T_28 = sample[0];
  assign T_29 = sample[1];
  assign T_30 = sample[2];
  assign T_31 = T_28 & T_29;
  assign T_32 = T_28 & T_30;
  assign T_33 = T_31 | T_32;
  assign T_34 = T_29 & T_30;
  assign T_35 = T_33 | T_34;
  assign T_36 = {sample,io_in};
  assign GEN_2 = pulse ? T_36 : {{1'd0}, sample};
  assign T_41 = timer == 5'h0;
  assign expire = T_41 & pulse;
  assign sched = GEN_41;
  assign T_44 = timer - 5'h1;
  assign T_45 = T_44[4:0];
  assign GEN_3 = pulse ? T_45 : timer;
  assign GEN_4 = sched ? 5'hf : GEN_3;
  assign T_50 = 2'h0 == state;
  assign T_52 = io_in == 1'h0;
  assign T_54 = T_52 == 1'h0;
  assign T_56 = debounce_min == 1'h0;
  assign T_57 = T_54 & T_56;
  assign T_59 = debounce - 2'h1;
  assign T_60 = T_59[1:0];
  assign GEN_5 = T_57 ? T_60 : debounce;
  assign T_64 = debounce + 2'h1;
  assign T_65 = T_64[1:0];
  assign GEN_6 = debounce_max ? 2'h1 : state;
  assign GEN_8 = debounce_max ? 5'h8 : GEN_4;
  assign GEN_9 = T_52 ? T_65 : GEN_5;
  assign GEN_10 = T_52 ? GEN_6 : state;
  assign GEN_11 = T_52 ? debounce_max : 1'h0;
  assign GEN_12 = T_52 ? GEN_8 : GEN_4;
  assign GEN_13 = T_50 ? GEN_9 : debounce;
  assign GEN_14 = T_50 ? GEN_10 : state;
  assign GEN_15 = T_50 ? GEN_11 : 1'h0;
  assign GEN_16 = T_50 ? GEN_12 : GEN_4;
  assign T_68 = 2'h1 == state;
  assign GEN_17 = T_35 ? 2'h0 : GEN_14;
  assign T_72 = T_35 == 1'h0;
  assign GEN_18 = T_72 ? 2'h2 : GEN_17;
  assign GEN_19 = T_72 ? 4'h8 : counter;
  assign GEN_21 = expire ? GEN_18 : GEN_14;
  assign GEN_22 = expire ? GEN_19 : counter;
  assign GEN_24 = T_68 ? expire : 1'h0;
  assign GEN_25 = T_68 ? GEN_21 : GEN_14;
  assign GEN_26 = T_68 ? GEN_22 : counter;
  assign T_74 = 2'h2 == state;
  assign T_77 = counter - 4'h1;
  assign T_78 = T_77[3:0];
  assign T_80 = counter == 4'h0;
  assign GEN_27 = T_80 ? 2'h0 : GEN_25;
  assign T_83 = T_80 == 1'h0;
  assign T_84 = shifter[7:1];
  assign T_85 = {T_35,T_84};
  assign GEN_29 = T_83 ? T_85 : shifter;
  assign GEN_30 = T_83 ? 1'h1 : GEN_24;
  assign GEN_31 = expire ? T_78 : GEN_26;
  assign GEN_32 = expire ? GEN_27 : GEN_25;
  assign GEN_33 = expire ? T_80 : 1'h0;
  assign GEN_34 = expire ? GEN_29 : shifter;
  assign GEN_35 = expire ? GEN_30 : GEN_24;
  assign GEN_36 = T_74 ? 1'h1 : T_68;
  assign GEN_37 = T_74 ? GEN_31 : GEN_26;
  assign GEN_38 = T_74 ? GEN_32 : GEN_25;
  assign GEN_39 = T_74 ? GEN_33 : 1'h0;
  assign GEN_40 = T_74 ? GEN_34 : shifter;
  assign GEN_41 = T_74 ? GEN_35 : GEN_24;
  assign T_88 = io_en == 1'h0;
  assign GEN_42 = T_88 ? 2'h0 : GEN_13;

  always @(posedge clock or posedge reset)
    if (reset) begin
      debounce <= 2'h0;
    end else begin
      if (T_88) begin
        debounce <= 2'h0;
      end else begin
        if (T_50) begin
          if (T_52) begin
            debounce <= T_65;
          end else begin
            if (T_57) begin
              debounce <= T_60;
            end
          end
        end
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      prescaler <= 12'h0;
    end else begin
      if (T_25) begin
        prescaler <= T_26;
      end else begin
        if (busy) begin
          prescaler <= T_24;
        end
      end
    end


  always @(posedge clock or posedge reset)
  if (reset) begin

    sample <= 3'b0;
    timer <= 5'h0;
    counter <= 4'b0;
    shifter <= 8'b0;

  end
  else begin
    sample <= GEN_2[2:0];
    if (T_50) begin
      if (T_52) begin
        if (debounce_max) begin
          timer <= 5'h8;
        end else begin
          if (sched) begin
            timer <= 5'hf;
          end else begin
            if (pulse) begin
              timer <= T_45;
            end
          end
        end
      end else begin
        if (sched) begin
          timer <= 5'hf;
        end else begin
          if (pulse) begin
            timer <= T_45;
          end
        end
      end
    end else begin
      if (sched) begin
        timer <= 5'hf;
      end else begin
        if (pulse) begin
          timer <= T_45;
        end
      end
    end
    if (T_74) begin
      if (expire) begin
        counter <= T_78;
      end else begin
        if (T_68) begin
          if (expire) begin
            if (T_72) begin
              counter <= 4'h8;
            end
          end
        end
      end
    end else begin
      if (T_68) begin
        if (expire) begin
          if (T_72) begin
            counter <= 4'h8;
          end
        end
      end
    end
    if (T_74) begin
      if (expire) begin
        if (T_83) begin
          shifter <= T_85;
        end
      end
    end
  end


  always @(posedge clock or posedge reset)
    if (reset) begin
      valid <= 1'h0;
    end else begin
      if (T_74) begin
        if (expire) begin
          valid <= T_80;
        end else begin
          valid <= 1'h0;
        end
      end else begin
        valid <= 1'h0;
      end
    end

  always @(posedge clock or posedge reset)
    if (reset) begin
      state <= 2'h0;
    end else begin
      if (T_74) begin
        if (expire) begin
          if (T_80) begin
            state <= 2'h0;
          end else begin
            if (T_68) begin
              if (expire) begin
                if (T_72) begin
                  state <= 2'h2;
                end else begin
                  if (T_35) begin
                    state <= 2'h0;
                  end else begin
                    if (T_50) begin
                      if (T_52) begin
                        if (debounce_max) begin
                          state <= 2'h1;
                        end
                      end
                    end
                  end
                end
              end else begin
                if (T_50) begin
                  if (T_52) begin
                    if (debounce_max) begin
                      state <= 2'h1;
                    end
                  end
                end
              end
            end else begin
              if (T_50) begin
                if (T_52) begin
                  if (debounce_max) begin
                    state <= 2'h1;
                  end
                end
              end
            end
          end
        end else begin
          if (T_68) begin
            if (expire) begin
              if (T_72) begin
                state <= 2'h2;
              end else begin
                if (T_35) begin
                  state <= 2'h0;
                end else begin
                  if (T_50) begin
                    if (T_52) begin
                      if (debounce_max) begin
                        state <= 2'h1;
                      end
                    end
                  end
                end
              end
            end else begin
              state <= GEN_14;
            end
          end else begin
            state <= GEN_14;
          end
        end
      end else begin
        if (T_68) begin
          if (expire) begin
            if (T_72) begin
              state <= 2'h2;
            end else begin
              if (T_35) begin
                state <= 2'h0;
              end else begin
                state <= GEN_14;
              end
            end
          end else begin
            state <= GEN_14;
          end
        end else begin
          state <= GEN_14;
        end
      end
    end

endmodule

