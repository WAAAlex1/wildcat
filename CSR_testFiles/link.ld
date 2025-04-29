SECTIONS
{
  . = 0x0000;      /* Start address for the .text section */
  .text : { *(.text) }
  .data : { *(.data) }
  .bss : { *(.bss) }
}
