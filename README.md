Note
================

This project will no longer be updated and maintained in this repository. 

About the new version, please refer to the [RISCV-MCU/e203_hbirdv2](https://github.com/riscv-mcu/e203_hbirdv2).







Hummingbird E203 Opensource Processor Core
================

About
-----------

This repository hosts the project for open-source hummingbird E203 RISC processor Core.

To boost the RISC-V popularity and to speed up the IoT development in China,
we are very proud to make hummingbird E203 core open-source. It is the first open-source processor core from
China mainland with state-of-art CPU design skills to support RISC-V instruction set.

The Hummingbird E203 core is a two-stages pipeline based ultra-low power/area implementation, makes the Hummingbird E203 as a perfect candidate for research and education of RISC-V implementation. 

Welcome to visit http://www.rvmcu.com/ to see the discussion of the Hummingbird E203.

Welcome to visit http://www.rvmcu.com/ for more comprehensive information of availiable RISC-V MCU chips and embedded development. 

Usages and Applications
-----------------------------

The open-source Hummingbird E203 core can be a perferct candidate for research and education of RISC-V implementation:
*   The Hummingbird E203 core as a simple ultra-low power core and SoC, which is "蜂鸟虽小、五脏俱全", with detailed Docs and Software/FPGA Demos, hence, it will be a perfect example for lab practice in university or entry-level studying. 

Many people asked if this core can be commercially used, the answer is as below:
   * According to the Apache 2.0 license, this open-sourced core can be used in commercial way.
   * But the feature is not full. 
   * The main purpose of this open-sourced core is to be used by students/university/research/
       and entry-level-beginners, hence, the commercial quality (bug-free) and
       service of this core is not not not warranted!!! 
   * Welcome to visit http://www.rvmcu.com/ for more comprehensive information of RISC-V core availiable for commercial usage. 

Detailed Introduction
-----------------------------

We have provided very detailed introduction and quick start-up documents to help you ramping it up. 

The detailed introduction and the quick start documentation can be seen 
from https://github.com/SI-RISCV/e200_opensource/tree/master/doc directory.

By following the guidences from the doc, you can very easily start to use Hummingbird E203 processor core and demo SoC.

Meanwhile, the Hummingbird E203 Core was deeply introduced in the published Book (蜂鸟E203处理器核在如下出版中文书籍中进行深入浅出的分析讲解):

    《手把手教你设计CPU：RISC-V处理器篇》（已经上市，请在京东、淘宝、当当上搜索 RISC-V关键字）

<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/bookpic.jpg" width="480">
        
    《RISC-V架构与嵌入式开发快速入门》（已经上市，请在京东、淘宝、当当上搜索 RISC-V关键字）

<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/book2pic.jpg" width="620">

What are you waiting for? Try it out now!

Dedicated FPGA-Board and JTAG-Debugger 
-----------------------------
In order to easy user to study RISC-V in a quick and easy way, we have made a dedicated FPGA-Board and JTAG-Debugger.  Diagram as below:

#### 蜂鸟E203专用的FPGA开发板

#### Nuclei EV Kit
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/nucleikit/pics/2-1.jpg" width="480">

#### Hummingbird EV Kit
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/hbirdkit/pics/p1.jpg" width="480">

#### 蜂鸟E203专用的JTAG调试器
<img src="https://github.com/SI-RISCV/e200_opensource/blob/master/boards/hbirdkit/pics/p4.jpg" width="400">

The detailed introduction and the relevant documentation can be seen from https://github.com/SI-RISCV/e200_opensource/tree/master/boards directory.


Release History
-----------------------------
#### Note at First:
    -- Many people asked if this core can be commercially used, the answer as below:
       * According to the Apache 2.0 license, this open-sourced core can be used in commercial way.
       * But the feature is not full (e.g., the debug functionalities is not full, which 
           cannot add breakpoint into the read-only region, .e.g, ROM/Flash)
       * The main purpose of this open-sourced core is to be used by students/university/research/
           and entry-level-beginners, hence, the commercial quality (bug-free) and
           service of this core is not not not warranted!!! 

#### Sep 27, 2018
    -- The 4th official release with some minor fixing.

#### May 15, 2018

    -- The 3rd official release, please clone this version if you want to use it
         or reclone it (if you already cloned the earlier-test version).
    -- Compared with earlier-test version, main updates includes:
       ---- Fixed a Typo in a source file (in rtl/e203/core/e203_exu_decocde.v) 
       ---- Fixed a Tied-to-zero issue in source files (in rtl/e203/perips/sirv_qspi_physical_*.v) 
              * This is original freedom-e310 chisel generated QSPI file, which have a bug in Quad-mode (the 4th data enable
                signal was tied to zero), fix it here

#### Jan 13, 2018

    -- The 2nd official release, please clone this version if you want to use it
         or reclone it (if you already cloned the earlier-test version).
    -- Compared with earlier-test version, main updates includes:
       ---- Change the default configuration (in rtl/e203/core/config.v) to 
              * Add two stage of syncer for IRQ lines to core, not for function, but for timing
              * Configure the ITCM and DTCM to 64KB by default
              * Configure the Regfile as DFF based rather than latch based
       ---- Update the SoC components and structure to make it in line with the latest SoC Spec
              * Please check `e200_opensource/doc/HBird_OpenSource_MCU_SoC_Spec.pdf` for the details of SoC spec
       ---- Update some internal core logics, mostly to enhance the timing and frequency, 
            which is not matter much, please check the git history if you really care to.
       ---- Note: This version still does not support the hardware-breakpoint yet, i.e.,
              you cannot set the breakpoint to read-only address space (e.g., ROM, Flash).
              But soft-break is okay, means you can use regular interactive debugger 
              functionalities (including set breakpoint to the regular R/W address space).


#### Oct 13, 2017

    -- The 1st official release, please clone this version if you want to use it
         or reclone it (if you already cloned the earlier-test version).
    -- Compared with earlier-test version, main updates includes:
       ---- Added the "A" extension for opensourced E203 core, to make it support 
              IMAC sub-set RISC-V ISA, which is more popularly supported by current
              toolchain.
       ---- Updated the RTL Codes accordingly.
       ---- Updated the Docs accordingly, please see the "revision history" in the
              Doc from `e200_opensource/doc` directory.
       ---- Updated verilog tb with random interrupt and bus-error insertion to make
              more intensive. To support this, updated all the self-check tests accordingly.
              Although the test become more intensive, the drawback is make the regression 
              simulation running very slower, so by default now it is turned off.
              If you want to turn on them without caring the the regression speed,
              you can hack the tb mannually (de-comment these `force` line from `tb/tb_top.v`)
              or add macro `ENABLE_TB_FORCE` in simulation (see the note 
              from `vsim/bin/run.makefile`).
       ---- Updated some other minor issues which is not matter much, please check the 
              git history if you really care to.
       ---- Note: This version does not support the hardware-breakpoint yet, i.e.,
              you cannot set the breakpoint to read-only address space (e.g., ROM, Flash).
              But soft-break is okay, means you can use regular interactive debugger 
              functionalities (including set breakpoint to the regular R/W address space).

#### Sep 30, 2017

    -- The earlier-test version uploaded to github to try.
    -- NOTE:
       ---- This is not the official release, please wait the official release which will coming
            soon and will be recorded at here. You will see the Release History updates.
    
