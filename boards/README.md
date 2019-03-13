Hummingbird E203 FPGA-Board and JTAG-Debugger
================

注意：本文档复制于文档《蜂鸟FPGA开发板和JTAG调试器介绍》（位于本目录 https://github.com/SI-RISCV/e200_opensource/blob/master/boards 下），用户可以方便下载其文档。

有关如何烧写蜂鸟E203项目（包括SoC和处理器内核）至此FPGA开发板，和如何使用FPGA开发板进行软件开发与调试的具体操作步骤，请参见https://github.com/SI-RISCV/e200_opensource/blob/master/doc 目录下的文档：
*   《蜂鸟E203快速上手介绍》。

*   FPGA开发板和JTAG调试器的淘宝购买链接：https://item.taobao.com/item.htm?id=580813056318

*   如您有关于此开发板的任何信息咨询，请致信summer@nucleisys.com

目录
-----------

<!--ts-->
   * 1 概述
   * 2 蜂鸟FPGA开发板
      * 2.1	 FPGA开发板总体说明
      * 2.2	 FPGA开发板的购买途径
      * 2.3	 FPGA开发板的硬件指标
      * 2.4	 FPGA开发板的电路原理图
      * 2.5	 FPGA开发板的MCU部分
      * 2.6	 FPGA开发板的常规功能部分
      * 2.7	 烧写蜂鸟E203项目至FPGA开发板  
      * 2.8	 使用FPGA开发板进行软件开发与调试
   * 3	 蜂鸟JTAG调试器
      * 3.1	 JTAG调试器总体说明
      * 3.2	 JTAG调试器的购买途径
      * 3.3	 JTAG调试器与FPGA开发板相连
      * 3.4	 使用JTAG调试器进行软件下载与调试
   * 4	 更多图片欣赏    
  
<!--te-->

1 概述
-----------

为了便于初学者能够快速地学习RISC-V CPU设计和RISC-V嵌入式开发，蜂鸟E203开源MCU原型SoC（在本文中将其简称为“MCU SoC”或者“SoC”）定制了基于Xilinx FPGA的专用开发板（在本文中将其简称为“FPGA开发板”）和专用JTAG调试器（在本文中将其简称为“JTAG调试器”）。

完整的FPGA开发板原型（包括FPGA开发板和调试器）如图1-1所示。
  
*   图1-1 蜂鸟FPGA开发板和JTAG调试器

<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p3.jpg" width="680">


后文将分别予以详述。


 
2 蜂鸟FPGA开发板
-----------

#### 2.1	 FPGA开发板总体说明

为了便于蜂鸟FPGA开发板的使用，FPGA开发板具备如下特点：

     ·一板两用，该开发板不仅可以用于一块FPGA开发板作为电路设计使用，同时由于其预烧了蜂鸟E203开
      源SoC（包括E203内核），因此其可以直接作为一块MCU SoC原型开发板进行嵌入式软件开发。即：
      
         * 对于不懂FPGA软件开发的用户完全无需做任何的操作，该开发板会预先烧写开源的蜂鸟E203 Core和
           配套SoC，上电后即可当做一块MCU嵌入式开发板来用。  
         * 对于了解FPGA使用的硬件用户而言，也可以将其当做普通的FPGA开发板来烧写普通的Verilog电路以
           进行FPGA开发。  
           
     ·由于其预先烧写的蜂鸟E203 Core和配套SoC源代码完全开源，可以对其任意进行修改或二次开发。
      
     ·并且由于开源的蜂鸟E203 MCU SoC的 “FPGA烧写文件（mcs格式）”会上传
      到https://github.com/SI-RISCV/e200_opensource/tree/master/fpga/nucleikit/prebuilt_mcs 目录下，
      用户可以随时重新烧写此FPGA板将其恢复成为预装的MCU嵌入式开发板。

#### 2.2	 FPGA开发板的购买途径

*   FPGA开发板的淘宝购买链接：https://item.taobao.com/item.htm?id=580813056318

#### 2.3	 FPGA开发板的硬件指标
 
蜂鸟E203专用FPGA开发板是一款入门级Xilinx FPGA开发板，如图2-1所示。

*   图2-1 蜂鸟FPGA开发板总体图

#### Nuclei EV Kit
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/2-1.jpg" width="480">

#### Hummingbird EV Kit
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/hbirdkit/pics/p6.jpg" width="480">


该FPGA开发板的硬件特性如下：

    ·使用的FPGA型号为Xilinx XC7A100T(XC7A75T) -2速度等级 FGG484封装 工业级。    
    ·板载双晶振设计：100MHz主时钟和32.768K RTC时钟。    
    ·配备单独直流5V供电，并设有电源开关，如图2-1中的“DC：5V供电及开关”标注。    
    ·配备独立的FPGA_RESET按键，用户可用此按键作为FPGA的复位按键。
    ·配备多达126个引出的FPGA GPIO，用于用户自定义使用。
    ·配备多个电源状态指示LED灯。
    ·配备板载的Xilinx Platform Cable USB JTAG下载器，用于对FPGA进行比特流的烧写，如图2-1中的“FPGA JTAG”标注。
    ·配备两颗MT41K128M16JT-125K DDR III 颗粒。
    
    ·配备独立的128M-bit FPGA SPI Flash，此Flash用于存储mcs格式的比特流文件：
    
        * 熟悉Vivado和Xilinx FPGA使用的用户应该了解，bitstream文件烧录到FPGA中去之后FPGA不能掉电，因为一旦掉电之后FPGA烧
        录的内容即丢失，需要重新使用Vivado的Hardware Manager进行烧录方能使用。为了方便用户使用，Xilinx的FPGA开发板可以将
        需要烧录的内容写入开发板上的Flash中（以mcs格式），然后在每次FPGA上电之后通过硬件电路自动将需要烧录的内容从外部的
        Flash中读出并烧录到FPGA之中（该过程非常的快，不影响用户使用）。由于Flash是非易失性的内存，具有掉电后仍可保存的特
        性，因此意味着将需要烧录的内容写入 Flash后，每次掉电后无需使用Hardware Manager人工重新烧录（而是硬件电路快速自动完
        成），即等效于，FPGA上电即可使用。    
        * 除了上电自动对FPGA重新进行烧录外，用户还可以通过强行按FPGA开发板上的“FPGA_PROG”按键触发硬件电路使用此Flash中的内
        容对FPGA重新进行烧录。FPGA开发板上的“FPGA_PROG”按键位置请参见图2-1中标注所示。
    
    ·为了便于此开发板直接作为MCU原型嵌入式开发板使用，将蜂鸟E203开源SoC的顶层引脚直接连到开发板上，并配有明显的丝印
    标注。请参见第2.5节了解详细介绍。
    
    ·为了便于此开发板作为常规FPGA开发板使用，配备分离的拨码开关和LED灯，请参见第2.6节了解详细介绍。

#### 2.4	 FPGA开发板的电路原理图

该开发板的电路原理图保存于https://github.com/SI-RISCV/e200_opensource/tree/master/boards 目录下，请用户自行查阅。

#### 2.5	 FPGA开发板的MCU部分

为了便于此开发板直接作为MCU原型嵌入式开发板使用，将“蜂鸟E203开源SoC”（简称SoC）的顶层引脚直接连到开发板上，并配有明显的丝印标注，详细描述如图2-2中所示，其要点如下：

    ·FPGA预先烧写成为“蜂鸟E203开源MCU SoC”（简称SoC）
    
    ·为了实现MCU的功能，在FPGA开发板上专门配备了一个Nor Flash用于存储MCU的软件程序。
    
    ·MCU SoC的两个输入时钟输入分别按照如下方式产生：
    
         * 低速的实时时钟直接由FPGA开发板上的32.768KHz时钟源输入。
         * 高速时钟由FPGA开发板上的100MHz时钟经过FPGA内部PLL降频而得（16MHz）。
       
    ·将SoC的相关输入输出管脚明确的做到FPGA开发板上，并且用印刷字体明确的表明端口号。
    
    ·有关此SoC的输入输出管脚列表的详细信息请参见https://github.com/SI-RISCV/e200_opensource/blob/master/doc 
    目录下的文档《蜂鸟E203开源SoC简介》。
    
    ·注意：所有的管脚都只是映射到FPGA内部的普通端口（双向IO）上，然后通过FPGA Project通过设置端口映射把FPGA端口映
    射到这些外部预定义的开发板引脚。有关FPGA Project的详细信息请
    参见https://github.com/SI-RISCV/e200_opensource/blob/master/doc 目录下的文档《蜂鸟E203快速上手介绍》。
    
    ·更多详细描述如图2-2中所示。 
 
 
*   图2-2 蜂鸟FPGA开发板的MCU定制部分
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/2-2.jpg" width="680">

#### 2.6	 FPGA开发板的常规功能部分

为了便于此开发板作为常规FPGA开发板使用，配备分离的拨码开关和LED灯，如图2-3中所示。

注意：此组拨码开关和LED并没有被连接到FPGA的管脚上，用户可以自由的进行跳线使其控制开发板上的其他信号。如图2-3中所示，用户可以通过用杜邦线跳线将“拨码开关”与MCU SoC的GPIO接口连接，相当于通过拨码开关来产生GPIO的输入，从而可以编程构建形象化的简单Demo。
   
*   图2-3 蜂鸟FPGA开发板的拨码开关和LED灯以及跳线示例
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/2-3.jpg" width="680">

#### 2.7	 烧写蜂鸟E203项目至FPGA开发板

有关如何烧写蜂鸟E203项目（包括SoC和处理器内核）至此FPGA开发板的具体操作步骤，请参见https://github.com/SI-RISCV/e200_opensource/blob/master/doc 目录下的文档《蜂鸟E203快速上手介绍》。

#### 2.8	 使用FPGA开发板进行软件开发与调试

有关如何使用FPGA开发板进行软件开发与调试的具体操作步骤，请参见https://github.com/SI-RISCV/e200_opensource/blob/master/doc 目录下的文档《蜂鸟E203快速上手介绍》。


3	 蜂鸟JTAG调试器
-----------

#### 3.1	 JTAG调试器总体说明
 
*   图3-1 蜂鸟E203专用的JTAG调试器
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/3-1.jpg" width="400">

为了便于初学者能够快速地学习RISC-V嵌入式开发，“蜂鸟MCU SoC”定制了专用的JTAG调试器，该调试器具有如下特性：

    ·调试器的一端为普通U盘接口，便于直接将其插入主机PC的USB接口，另一端为标准的4线JTAG接口和2线UART接口。
    
    ·调试器具备USB转JTAG功能，通过标准的4线JTAG接口与蜂鸟E203 FPGA开发板连接。由于蜂鸟E203 内核支持标准
    的JTAG接口，通过此接口可以程序下载或进行交互式调试。
    
    ·调试器具备UART转USB功能，通过标准的2线UART接口与蜂鸟E203 FPGA开发板连接。由于嵌入式系统往往没有配备
    显示屏，因此常用UART口连接主机PC的COM口（或者将UART转换为USB后连接主机PC的USB口）进行调试，这样便可以
    将嵌入式系统中的printf函数重定向打印至主机的显示屏。参见中文书籍《RISC-V架构与嵌入式开发快速入门》第9章
    了解更多详情。

#### 3.2	 JTAG调试器的购买途径

*   JTAG调试器的淘宝购买链接：https://item.taobao.com/item.htm?id=580813056318

#### 3.3	 JTAG调试器与FPGA开发板相连

蜂鸟E203的JTAG调试器与FPGA开发板的连接方法如图3-2中所示。

*   图3-2 蜂鸟E203专用的JTAG调试器与PC和开发板连接
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/3-2.jpg" width="680">

#### 3.4	 使用JTAG调试器进行软件下载与调试

有关如何使用JTAG调试器进行软件下载与调试的具体操作步骤，请参见https://github.com/SI-RISCV/e200_opensource/blob/master/doc 目录下的文档《蜂鸟E203快速上手介绍》。


 
4 更多图片欣赏
-----------
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p1.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p2.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p3.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p4.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p5.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p6.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p7.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p8.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p9.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/p10.jpg" width="680">
-----------
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/hbirdkit/pics/p1.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/hbirdkit/pics/p2.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/hbirdkit/pics/p3.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/hbirdkit/pics/p4.jpg" width="680">
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/hbirdkit/pics/p5.jpg" width="680">








    
