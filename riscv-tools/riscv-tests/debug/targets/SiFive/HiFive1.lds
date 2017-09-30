OUTPUT_ARCH( "riscv" )

SECTIONS
{
  . = 0x80000000;
  .text : 
  {
    *(.text.entry)
    *(.text)
  }

  /* data segment */
  .data : { *(.data) }

  .sdata : {
    __global_pointer$ = . + 0x800;
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2)
    *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  }

  /* bss segment */
  .sbss : {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
  }
  .bss : { *(.bss) }

  __malloc_start = .;
  . = . + 512;

  /* End of uninitalized data segement */
  _end = .;
}
