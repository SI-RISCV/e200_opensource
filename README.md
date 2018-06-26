Hummingbird E200 Opensource Processor Core
================

About
-----------

This repository hosts the project for open-source hummingbird E200 RISC processor Core.

The Hummingbird E200 core is a two-stages pipeline based ultra-low power/area implementation, 
which has both performance and areas benchmark better than ARM Cortex-M0+ core, makes the Hummingbird E200 as a perfect replacement for legacy 8051 core or ARM Cortex-M cores in the IoT or other ultra-low power applications. 

To boost the RISC-V popularity and to speed up the IoT development in China,
we are very proud to make it open-source. It is the first open-source processor core from
China mainland with industry level quality and state-of-art CPU design skills to support RISC-V instruction set.

Our ambition is to make "Hummingbird E200" become next 8051 in China, please go with us to make it happen.


Usages and Applications
-----------------------------

The open-source Hummingbird E200 core can be a perferct candidate for the following fields:
*   Replace legacy 8051 core for better performance.
*   Replace Cortex-M core for lower cost.
*   Also, the Hummingbird E200 core as a simple ultra-low power core and SoC, which is "蜂鸟虽小、五脏俱全", with detailed Docs and Software/FPGA Demos, hence, it will be a perfect example for lab practice in university or entry-level studying. 

Detailed Introduction
-----------------------------

We have provided very detailed introduction and quick start-up documents to help you ramping it up. 

The detailed introduction and the quick start documentation can be seen 
from `e200_opensource/doc` directory.

By following the guidences from the doc, you can very easily start to use Hummingbird E200 processor core and demo SoC.

Meanwhile, the Hummingbird E200 Core was deeply introduced in the published Book (蜂鸟E200处理器核在如下出版中文书籍中进行深入浅出的分析讲解):

    《手把手教你设计CPU：RISC-V处理器》（已经上市，请在京东、淘宝、当当上搜索 RISC-V关键字）

What are you waiting for? Try it out now!

Release History
-----------------------------
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
    
