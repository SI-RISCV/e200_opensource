

module fpga_tb_top();
  
  reg CLK100MHZ;
  reg ck_rst;

  initial begin
    CLK100MHZ   <=0;
    ck_rst      <=0;
    #15000 ck_rst <=1;
  end

  always
  begin 
     #10 CLK100MHZ <= ~CLK100MHZ;
  end


system u_system
(
  .CLK100MHZ(CLK100MHZ),
  .ck_rst(ck_rst),

  .led_0(),
  .led_1(),
  .led_2(),
  .led_3(),

  .led0_r(),
  .led0_g(),
  .led0_b(),
  .led1_r(),
  .led1_g(),
  .led1_b(),
  .led2_r(),
  .led2_g(),
  .led2_b(),

  .sw_0(),
  .sw_1(),
  .sw_2(),
  .sw_3(),

  .btn_0(),
  .btn_1(),
  .btn_2(),
  .btn_3(),

  .qspi_cs (),
  .qspi_sck(),
  .qspi_dq (),

  .uart_rxd_out(),
  .uart_txd_in (),

  .ja_0(),
  .ja_1(),

  .ck_io(),

  .ck_miso(),
  .ck_mosi(),
  .ck_ss  (),
  .ck_sck (),

  .jd_0(), // TDO
  .jd_1(), // TRST_n
  .jd_2(), // TCK
  .jd_4(), // TDI
  .jd_5(), // TMS
  .jd_6() // SRST_n
);


endmodule
