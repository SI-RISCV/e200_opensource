module SPIGPIOPort_2(
  input   clock,
  input   reset,
  input   io_spi_sck,
  output  io_spi_dq_0_i,
  input   io_spi_dq_0_o,
  input   io_spi_dq_0_oe,
  output  io_spi_dq_1_i,
  input   io_spi_dq_1_o,
  input   io_spi_dq_1_oe,
  output  io_spi_dq_2_i,
  input   io_spi_dq_2_o,
  input   io_spi_dq_2_oe,
  output  io_spi_dq_3_i,
  input   io_spi_dq_3_o,
  input   io_spi_dq_3_oe,
  input   io_spi_cs_0,
  input   io_pins_sck_i_ival,
  output  io_pins_sck_o_oval,
  output  io_pins_sck_o_oe,
  output  io_pins_sck_o_ie,
  output  io_pins_sck_o_pue,
  output  io_pins_sck_o_ds,
  input   io_pins_dq_0_i_ival,
  output  io_pins_dq_0_o_oval,
  output  io_pins_dq_0_o_oe,
  output  io_pins_dq_0_o_ie,
  output  io_pins_dq_0_o_pue,
  output  io_pins_dq_0_o_ds,
  input   io_pins_dq_1_i_ival,
  output  io_pins_dq_1_o_oval,
  output  io_pins_dq_1_o_oe,
  output  io_pins_dq_1_o_ie,
  output  io_pins_dq_1_o_pue,
  output  io_pins_dq_1_o_ds,
  input   io_pins_dq_2_i_ival,
  output  io_pins_dq_2_o_oval,
  output  io_pins_dq_2_o_oe,
  output  io_pins_dq_2_o_ie,
  output  io_pins_dq_2_o_pue,
  output  io_pins_dq_2_o_ds,
  input   io_pins_dq_3_i_ival,
  output  io_pins_dq_3_o_oval,
  output  io_pins_dq_3_o_oe,
  output  io_pins_dq_3_o_ie,
  output  io_pins_dq_3_o_pue,
  output  io_pins_dq_3_o_ds,
  input   io_pins_cs_0_i_ival,
  output  io_pins_cs_0_o_oval,
  output  io_pins_cs_0_o_oe,
  output  io_pins_cs_0_o_ie,
  output  io_pins_cs_0_o_pue,
  output  io_pins_cs_0_o_ds
);
  wire  T_267;
  reg  T_271;
  reg [31:0] GEN_0;
  reg  T_272;
  reg [31:0] GEN_1;
  reg  T_273;
  reg [31:0] GEN_2;
  wire  T_274;
  reg  T_278;
  reg [31:0] GEN_3;
  reg  T_279;
  reg [31:0] GEN_4;
  reg  T_280;
  reg [31:0] GEN_5;
  wire  T_281;
  reg  T_285;
  reg [31:0] GEN_6;
  reg  T_286;
  reg [31:0] GEN_7;
  reg  T_287;
  reg [31:0] GEN_8;
  wire  T_288;
  reg  T_292;
  reg [31:0] GEN_9;
  reg  T_293;
  reg [31:0] GEN_10;
  reg  T_294;
  reg [31:0] GEN_11;
  assign io_spi_dq_0_i = T_273;
  assign io_spi_dq_1_i = T_280;
  assign io_spi_dq_2_i = T_287;
  assign io_spi_dq_3_i = T_294;
  assign io_pins_sck_o_oval = io_spi_sck;
  assign io_pins_sck_o_oe = 1'h1;
  assign io_pins_sck_o_ie = 1'h0;
  assign io_pins_sck_o_pue = 1'h0;
  assign io_pins_sck_o_ds = 1'h1;
  assign io_pins_dq_0_o_oval = io_spi_dq_0_o;
  assign io_pins_dq_0_o_oe = io_spi_dq_0_oe;
  assign io_pins_dq_0_o_ie = T_267;
  assign io_pins_dq_0_o_pue = 1'h1;
  assign io_pins_dq_0_o_ds = 1'h1;
  assign io_pins_dq_1_o_oval = io_spi_dq_1_o;
  assign io_pins_dq_1_o_oe = io_spi_dq_1_oe;
  assign io_pins_dq_1_o_ie = T_274;
  assign io_pins_dq_1_o_pue = 1'h1;
  assign io_pins_dq_1_o_ds = 1'h1;
  assign io_pins_dq_2_o_oval = io_spi_dq_2_o;
  assign io_pins_dq_2_o_oe = io_spi_dq_2_oe;
  assign io_pins_dq_2_o_ie = T_281;
  assign io_pins_dq_2_o_pue = 1'h1;
  assign io_pins_dq_2_o_ds = 1'h1;
  assign io_pins_dq_3_o_oval = io_spi_dq_3_o;
  assign io_pins_dq_3_o_oe = io_spi_dq_3_oe;
  assign io_pins_dq_3_o_ie = T_288;
  assign io_pins_dq_3_o_pue = 1'h1;
  assign io_pins_dq_3_o_ds = 1'h1;
  assign io_pins_cs_0_o_oval = io_spi_cs_0;
  assign io_pins_cs_0_o_oe = 1'h1;
  assign io_pins_cs_0_o_ie = 1'h0;
  assign io_pins_cs_0_o_pue = 1'h0;
  assign io_pins_cs_0_o_ds = 1'h1;
  assign T_267 = ~ io_spi_dq_0_oe;
  assign T_274 = ~ io_spi_dq_1_oe;
  assign T_281 = ~ io_spi_dq_2_oe;
  assign T_288 = ~ io_spi_dq_3_oe;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_0 = {1{$random}};
  T_271 = GEN_0[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_1 = {1{$random}};
  T_272 = GEN_1[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_2 = {1{$random}};
  T_273 = GEN_2[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_3 = {1{$random}};
  T_278 = GEN_3[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_4 = {1{$random}};
  T_279 = GEN_4[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_5 = {1{$random}};
  T_280 = GEN_5[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_6 = {1{$random}};
  T_285 = GEN_6[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_7 = {1{$random}};
  T_286 = GEN_7[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_8 = {1{$random}};
  T_287 = GEN_8[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_9 = {1{$random}};
  T_292 = GEN_9[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_10 = {1{$random}};
  T_293 = GEN_10[0:0];
  `endif
  `ifdef RANDOMIZE_REG_INIT
  GEN_11 = {1{$random}};
  T_294 = GEN_11[0:0];
  `endif
  end
`endif
  always @(posedge clock) begin
    T_271 <= io_pins_dq_0_i_ival;
    T_272 <= T_271;
    T_273 <= T_272;
    T_278 <= io_pins_dq_1_i_ival;
    T_279 <= T_278;
    T_280 <= T_279;
    T_285 <= io_pins_dq_2_i_ival;
    T_286 <= T_285;
    T_287 <= T_286;
    T_292 <= io_pins_dq_3_i_ival;
    T_293 <= T_292;
    T_294 <= T_293;
  end
endmodule

