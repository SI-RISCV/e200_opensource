module JTAGGPIOPort(
  input   clock,
  input   reset,
  output  io_jtag_TCK,
  output  io_jtag_TMS,
  output  io_jtag_TDI,
  input   io_jtag_TDO,
  output  io_jtag_TRST,
  input   io_jtag_DRV_TDO,
  input   io_pins_TCK_i_ival,
  output  io_pins_TCK_o_oval,
  output  io_pins_TCK_o_oe,
  output  io_pins_TCK_o_ie,
  output  io_pins_TCK_o_pue,
  output  io_pins_TCK_o_ds,
  input   io_pins_TMS_i_ival,
  output  io_pins_TMS_o_oval,
  output  io_pins_TMS_o_oe,
  output  io_pins_TMS_o_ie,
  output  io_pins_TMS_o_pue,
  output  io_pins_TMS_o_ds,
  input   io_pins_TDI_i_ival,
  output  io_pins_TDI_o_oval,
  output  io_pins_TDI_o_oe,
  output  io_pins_TDI_o_ie,
  output  io_pins_TDI_o_pue,
  output  io_pins_TDI_o_ds,
  input   io_pins_TDO_i_ival,
  output  io_pins_TDO_o_oval,
  output  io_pins_TDO_o_oe,
  output  io_pins_TDO_o_ie,
  output  io_pins_TDO_o_pue,
  output  io_pins_TDO_o_ds,
  input   io_pins_TRST_n_i_ival,
  output  io_pins_TRST_n_o_oval,
  output  io_pins_TRST_n_o_oe,
  output  io_pins_TRST_n_o_ie,
  output  io_pins_TRST_n_o_pue,
  output  io_pins_TRST_n_o_ds
);
  wire  T_101;
  wire  T_117;
  assign io_jtag_TCK = T_101;
  assign io_jtag_TMS = io_pins_TMS_i_ival;
  assign io_jtag_TDI = io_pins_TDI_i_ival;
  assign io_jtag_TRST = T_117;
  assign io_pins_TCK_o_oval = 1'h0;
  assign io_pins_TCK_o_oe = 1'h0;
  assign io_pins_TCK_o_ie = 1'h1;
  assign io_pins_TCK_o_pue = 1'h1;
  assign io_pins_TCK_o_ds = 1'h0;
  assign io_pins_TMS_o_oval = 1'h0;
  assign io_pins_TMS_o_oe = 1'h0;
  assign io_pins_TMS_o_ie = 1'h1;
  assign io_pins_TMS_o_pue = 1'h1;
  assign io_pins_TMS_o_ds = 1'h0;
  assign io_pins_TDI_o_oval = 1'h0;
  assign io_pins_TDI_o_oe = 1'h0;
  assign io_pins_TDI_o_ie = 1'h1;
  assign io_pins_TDI_o_pue = 1'h1;
  assign io_pins_TDI_o_ds = 1'h0;
  assign io_pins_TDO_o_oval = io_jtag_TDO;
  assign io_pins_TDO_o_oe = io_jtag_DRV_TDO;
  assign io_pins_TDO_o_ie = 1'h0;
  assign io_pins_TDO_o_pue = 1'h0;
  assign io_pins_TDO_o_ds = 1'h0;
  assign io_pins_TRST_n_o_oval = 1'h0;
  assign io_pins_TRST_n_o_oe = 1'h0;
  assign io_pins_TRST_n_o_ie = 1'h1;
  assign io_pins_TRST_n_o_pue = 1'h1;
  assign io_pins_TRST_n_o_ds = 1'h0;
  assign T_101 = $unsigned(io_pins_TCK_i_ival);
  assign T_117 = ~ io_pins_TRST_n_i_ival;
endmodule

