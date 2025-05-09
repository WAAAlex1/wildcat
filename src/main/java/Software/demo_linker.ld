_stack_size = 4K;

MEMORY
{
  /* First 8MB for instructions but 0x100 space for ZSBL (.text) */
  INS_RAM (rwx) : ORIGIN = 0x00000100, LENGTH = 8M - 0x100

  /* Last 8MB for data (.data, .bss, stack, heap) */
  DATA_RAM (rwx) : ORIGIN = 0x00800000, LENGTH = 8M
}

SECTIONS
{
  /* Instructions go in INS_RAM */
  .text : {
    KEEP(*(.text.init))
    *(.text .text.*)
  } > INS_RAM

  .rodata : {
    . = ALIGN(4);
    *(.rodata .rodata.*) /* Constant data, strings (like ASCII art) */
  } > DATA_RAM

  /* Data goes in DATA_RAM */
  .data : {
    . = ALIGN(4);
    *(.data .data.*) /* Initialized data */
  } > DATA_RAM

  .bss : {
    . = ALIGN(4);
    __bss_start = .;
    *(.bss .bss.*)
    *(COMMON)
    __bss_end = .;
  } > DATA_RAM

  /* Stack and heap in DATA_RAM - Stack grows downwards */
  .stack (NOLOAD) : {
    . = ALIGN(16);
    __stack_bottom = .;
    . = . + _stack_size;  /* You define _stack_size */
    __stack_top = .;      /* ZSBL should set SP to __stack_top */
  } > DATA_RAM
}

ENTRY(_start)