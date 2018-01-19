# See LICENSE for license details.

#*****************************************************************************
# bpu_wait.S
#-----------------------------------------------------------------------------
#
# Test soc
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  # Access the AXI registers
    # Write
  li a1, 0xff 
  li t0, 0x10040000
  sb a1, 0(t0)
  li t0, 0x10040001
  sb a1, 0(t0)
  li t0, 0x10040002
  sb a1, 0(t0)
  li t0, 0x10040003
  sb a1, 0(t0)
  li t0, 0x10040004
  sb a1, 0(t0)
  li t0, 0x10040005
  sb a1, 0(t0)
  li t0, 0x10040006
  sb a1, 0(t0)
  li t0, 0x10040007
  sb a1, 0(t0)
    # Read
  li t0, 0x10040000
  lb a1, 0(t0)
  li t0, 0x10040001
  lb a1, 0(t0)
  li t0, 0x10040002
  lb a1, 0(t0)
  li t0, 0x10040003
  lb a1, 0(t0)
  li t0, 0x10040004
  lb a1, 0(t0)
  li t0, 0x10040005
  lb a1, 0(t0)
  li t0, 0x10040006
  lb a1, 0(t0)
  li t0, 0x10040007
  lb a1, 0(t0)


  # Access the APB registers
    # Write
  li a1, 0xff 
  li t0, 0x10041000
  sb a1, 0(t0)
  li t0, 0x10041001
  sb a1, 0(t0)
  li t0, 0x10041002
  sb a1, 0(t0)
  li t0, 0x10041003
  sb a1, 0(t0)
  li t0, 0x10041004
  sb a1, 0(t0)
  li t0, 0x10041005
  sb a1, 0(t0)
  li t0, 0x10041006
  sb a1, 0(t0)
  li t0, 0x10041007
  sb a1, 0(t0)
    # Read
  li t0, 0x10041000
  lb a1, 0(t0)
  li t0, 0x10041001
  lb a1, 0(t0)
  li t0, 0x10041002
  lb a1, 0(t0)
  li t0, 0x10041003
  lb a1, 0(t0)
  li t0, 0x10041004
  lb a1, 0(t0)
  li t0, 0x10041005
  lb a1, 0(t0)
  li t0, 0x10041006
  lb a1, 0(t0)
  li t0, 0x10041007
  lb a1, 0(t0)

  # Access the I2C registers
    # Write
  li a1, 0xff 
  li t0, 0x10042000
  sb a1, 0(t0)
  li t0, 0x10042001
  sb a1, 0(t0)
  li t0, 0x10042002
  sb a1, 0(t0)
  li t0, 0x10042003
  sb a1, 0(t0)
  li t0, 0x10042004
  sb a1, 0(t0)
  li t0, 0x10042005
  sb a1, 0(t0)
  li t0, 0x10042006
  sb a1, 0(t0)
  li t0, 0x10042007
  sb a1, 0(t0)
    # Read
  li t0, 0x10042000
  lb a1, 0(t0)
  li t0, 0x10042001
  lb a1, 0(t0)
  li t0, 0x10042002
  lb a1, 0(t0)
  li t0, 0x10042003
  lb a1, 0(t0)
  li t0, 0x10042004
  lb a1, 0(t0)
  li t0, 0x10042005
  lb a1, 0(t0)
  li t0, 0x10042006
  lb a1, 0(t0)
  li t0, 0x10042007
  lb a1, 0(t0)

  lui	s1,0x10042
  li	s3,0xaa
  lbu	a1,2(s1) # 10042002 <__stack_size+0x10041802>
  lbu	a1,4(s1)

# Test I2C PRERlo
  li	a5,0x27
  sb	a5,0(s1)
  lbu	a1,0(s1)
  bne   a1,a5,2f

# Test I2C PRERlo
  li	a5,1
  sb	a5,1(s1)
  lbu	a1,1(s1)
  bne   a1,a5,2f

# Test I2C CTR
  li	a5,0x80
  sb	a5,2(s1)
  lbu	a1,2(s1)
  bne   a1,a5,2f

# Test I2C RXR
  sb	s3,3(s1)
  lbu	a1,3(s1)
  li	a5,0xff
  bne   a1,a5,2f

# Test I2C SR
  lbu	a1,4(s1)
  li	a5,-112
  sb	a5,4(s1)
  lbu	a1,4(s1)
  li	a5,0x2
  bne   a1,a5,2f

  sb	s3,3(s1)
  lbu	a1,3(s1)
  li	a5,80
  sb	a5,4(s1)
  lbu	a1,4(s1)

# Test Always on

 # 0x1000 0000 wdogcfg
 # 0x1000 0008 wdogcount
 # 0x1000 0010 wdogs
 # 0x1000 0018 wdogfeed
 # 0x1000 001C wdogkey
 # 0x1000 0020 wdogcmp
    # Write
  li t0, 0x1000001C # unlock the aon
  sw a1, 0(t0)
  lw a2, 0(t0)
  li a1, 0xffffffff 
  li t0, 0x10000000
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000008
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000010
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000018
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000020
  sw a1, 0(t0)
  lw a2, 0(t0)

 # 0x1000 0040 rtccfg
 # 0x1000 0048 rtclo
 # 0x1000 004C rtchi
 # 0x1000 0050 rtcs
 # 0x1000 0060 rtccmp
  li t0, 0x10000040
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000048
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x1000004C
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000050
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000060
  sw a1, 0(t0)
  lw a2, 0(t0)

 # 0x1000 0080 backup0
 # 0x1000 0084 backup1 
 # 0x1000 0088 backup1 
 # 0x1000 008C backup1 
 # 0x1000 0090 backup0
 # 0x1000 0094 backup1 
 # 0x1000 0098 backup1 
 # 0x1000 009C backup1 
 # 0x1000 00a0 backup0
 # 0x1000 00a4 backup1 
 # 0x1000 00a8 backup1 
 # 0x1000 00aC backup1 
 # 0x1000 00b0 backup0
 # 0x1000 00b4 backup1 
 # 0x1000 00b8 backup1 
 # 0x1000 00bC backup1 
  li t0, 0x10000080
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000084
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000088
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x1000008C
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000090
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000094
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000098
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x1000009C
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x100000a0
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x100000a4
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x100000a8
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x100000aC
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x100000b0
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x100000b4
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x100000b8
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x100000bC
  sw a1, 0(t0)
  lw a2, 0(t0)


  #0x1000 0100 pmuwakeupi0 Wakeup program instruction 0
  #0x1000 0104 pmuwakeupi1 Wakeup program instruction 1
  #0x1000 0108 pmuwakeupi2 Wakeup program instruction 2
  #0x1000 010c pmuwakeupi3 Wakeup program instruction 3
  #0x1000 0110 pmuwakeupi4 Wakeup program instruction 4
  #0x1000 0114 pmuwakeupi5 Wakeup program instruction 5
  #0x1000 0118 pmuwakeupi6 Wakeup program instruction 6
  #0x1000 011c pmuwakeupi7 Wakeup program instruction 7
  #0x1000 0120 pmusleepi0 Sleep program instruction 0
  #0x1000 0124 pmusleepi1 Sleep program instruction 1
  #0x1000 0128 pmusleepi2 Sleep program instruction 2
  #0x1000 012c pmusleepi3 Sleep program instruction 3
  #0x1000 0130 pmusleepi4 Sleep program instruction 4
  #0x1000 0134 pmusleepi5 Sleep program instruction 5
  #0x1000 0138 pmusleepi6 Sleep program instruction 6
  #0x1000 013c pmusleepi7 Sleep program instruction 7
  #0x1000 0140 pmuie PMU interrupt enables
  #0x1000 0144 pmucause PMU wakeup cause
  #0x1000 0148 pmusleep Initiate sleep sequence
  #0x1000 014c pmukey PMU key register

  li t0, 0x10000100
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000104
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000108
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x1000010c
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000110
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000114
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000118
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x1000011c
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000120
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000124
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000128
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x1000012c
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000130
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000134
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000138
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x1000013c
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000140
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000144
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10000148
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x1000014c
  sw a1, 0(t0)
  lw a2, 0(t0)

  #0x1000_0200	lfxosccfg
  li t0, 0x10000200
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test HCLKGEN
  #0x1000_8004	hfxosccfg
  #0x1000_8008	pllcfg
  #0x1000_800C	plloutdiv
  li t0, 0x10008004
  sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x10008008
  //sw a1, 0(t0)
  lw a2, 0(t0)
  li t0, 0x1000800C
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test GPIO
 #0x10012000 value pin value
 #0x10012004 input en  pin input enable
 #0x10012008 output en  pin output enable
 #0x1001200C port output port value
 #0x10012010 pue  internal pull-up enable
 #0x10012014 ds Pin Drive Strength
 #0x10012018 rise ie rise interrupt enable
 #0x1001201C rise ip rise interrupt pending
 #0x10012020 fall ie fall interrupt enable
 #0x10012024 fall ip fall interrupt pending
 #0x10012028 high ie high interrupt enable
 #0x1001202C high ip high interrupt pending
 #0x10012030 low ie low interrupt enable
 #0x10012034 low ip low interrupt pending
 #0x10012038 iof en  HW I/O Function enable
 #0x1001203C iof sel HW I/O Function select
 #0x10012040 out xor Output XOR (invert)

 li t0,0x10012000 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012004 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012008 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1001200C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012010 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012014 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012018 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1001201C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012020 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012024 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012028 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1001202C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012030 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012034 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012038 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1001203C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10012040 
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test UART0
 #0x10013000 txdata Transmit data register
 #0x10013004 rxdata Receive data register
 #0x10013008 txctrl Transmit control register
 #0x1001300C rxctrl Receive control register
 #0x10013010 ie UART interrupt enable
 #0x10013014 ip UART Interrupt pending
 #0x10013018 div
 li t0,0x10013000
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10013004
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10013008
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1001300C
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10013010
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10013014
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10013018
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test the QSPI0
 # 0x10014000 sckdiv Serial clock divisor
 # 0x10014004 sckmode Serial clock mode
 # 0x10014010 csid Chip select ID
 # 0x10014014 csdef Chip select default
 # 0x10014018 csmode Chip select mode
 # 0x10014028 delay0 Delay control 0
 # 0x1001402C delay1 Delay control 1
 # 0x10014040 fmt Frame format
 # 0x10014048 txdata Tx FIFO data
 # 0x1001404C rxdata Rx FIFO data
 # 0x10014050 txmark Tx FIFO watermark
 # 0x10014054 rxmark Rx FIFO watermark
 # 0x10014060 fctrl* SPI flash interface control
 # 0x10014064 ffmt* SPI flash instruction format
 # 0x10014070 ie SPI interrupt enable
 # 0x10014074 ip SPI interrupt pending

 li t0, 0x10014000 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014004 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014010 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014014 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014018 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014028 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x1001402C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014040 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014048 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x1001404C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014050 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014054 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014060 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014064 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014070 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10014074 
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test the PWM0
 #0x10015000 pwmcfg
 #0x10015004 Reserved
 #0x10015008 pwmcount
 #0x1001500C Reserved
 #0x10015010 pwms
 #0x10015014 Reserved
 #0x10015018 Reserved
 #0x1001501C Reserved
 #0x10015020 pwmcmp0
 #0x10015024 pwmcmp1
 #0x10015028 pwmcmp2
 #0x1001502C pwmcmp3

 li t0,0x10015000 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10015004 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10015008 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1001500C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10015010 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10015014 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10015018 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1001501C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10015020 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10015024 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10015028 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1001502C 
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test UART1
 #0x10023000 txdata Transmit data register
 #0x10023004 rxdata Receive data register
 #0x10023008 txctrl Transmit control register
 #0x1002300C rxctrl Receive control register
 #0x10023010 ie UART interrupt enable
 #0x10023014 ip UART Interrupt pending
 #0x10023018 div
 li t0,0x10023000
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10023004
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10023008
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1002300C
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10023010
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10023014
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10023018
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test the QSPI1
 # 0x10024000 sckdiv Serial clock divisor
 # 0x10024004 sckmode Serial clock mode
 # 0x10024010 csid Chip select ID
 # 0x10024014 csdef Chip select default
 # 0x10024018 csmode Chip select mode
 # 0x10024028 delay0 Delay control 0
 # 0x1002402C delay1 Delay control 1
 # 0x10024040 fmt Frame format
 # 0x10024048 txdata Tx FIFO data
 # 0x1002404C rxdata Rx FIFO data
 # 0x10024050 txmark Tx FIFO watermark
 # 0x10024054 rxmark Rx FIFO watermark
 # 0x10024060 fctrl* SPI flash interface control
 # 0x10024064 ffmt* SPI flash instruction format
 # 0x10024070 ie SPI interrupt enable
 # 0x10024074 ip SPI interrupt pending

 li t0, 0x10024000 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024004 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024010 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024014 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024018 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024028 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x1002402C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024040 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024048 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x1002404C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024050 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024054 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024060 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024064 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024070 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10024074 
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test the PWM1
 #0x10025000 pwmcfg
 #0x10025004 Reserved
 #0x10025008 pwmcount
 #0x1002500C Reserved
 #0x10025010 pwms
 #0x10025014 Reserved
 #0x10025018 Reserved
 #0x1002501C Reserved
 #0x10025020 pwmcmp0
 #0x10025024 pwmcmp1
 #0x10025028 pwmcmp2
 #0x1002502C pwmcmp3

 li t0,0x10025000 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10025004 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10025008 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1002500C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10025010 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10025014 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10025018 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1002501C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10025020 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10025024 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10025028 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1002502C 
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test the QSPI2
 # 0x10034000 sckdiv Serial clock divisor
 # 0x10034004 sckmode Serial clock mode
 # 0x10034010 csid Chip select ID
 # 0x10034014 csdef Chip select default
 # 0x10034018 csmode Chip select mode
 # 0x10034028 delay0 Delay control 0
 # 0x1003402C delay1 Delay control 1
 # 0x10034040 fmt Frame format
 # 0x10034048 txdata Tx FIFO data
 # 0x1003404C rxdata Rx FIFO data
 # 0x10034050 txmark Tx FIFO watermark
 # 0x10034054 rxmark Rx FIFO watermark
 # 0x10034060 fctrl* SPI flash interface control
 # 0x10034064 ffmt* SPI flash instruction format
 # 0x10034070 ie SPI interrupt enable
 # 0x10034074 ip SPI interrupt pending

 li t0, 0x10034000 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034004 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034010 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034014 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034018 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034028 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x1003402C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034040 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034048 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x1003404C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034050 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034054 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034060 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034064 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034070 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0, 0x10034074 
  sw a1, 0(t0)
  lw a2, 0(t0)

# Test the PWM2
 #0x10035000 pwmcfg
 #0x10035004 Reserved
 #0x10035008 pwmcount
 #0x1003500C Reserved
 #0x10035010 pwms
 #0x10035014 Reserved
 #0x10035018 Reserved
 #0x1003501C Reserved
 #0x10035020 pwmcmp0
 #0x10035024 pwmcmp1
 #0x10035028 pwmcmp2
 #0x1003502C pwmcmp3

 li t0,0x10035000 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10035004 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10035008 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1003500C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10035010 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10035014 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10035018 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1003501C 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10035020 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10035024 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x10035028 
  sw a1, 0(t0)
  lw a2, 0(t0)
 li t0,0x1003502C 
  sw a1, 0(t0)
  lw a2, 0(t0)

  li TESTNUM, 1
2:
  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

data1: .word 0
data2: .word 0

RVTEST_DATA_END
