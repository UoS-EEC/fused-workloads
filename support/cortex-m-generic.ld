/*
 * This file is part of the libopencm3 project.
 *
 * Copyright (C) 2009 Uwe Hermann <uwe@hermann-uwe.de>
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

/* Generic linker script for pretty much any cortex-m targets using libopencm3. */

/* Memory regions MUST be defined in the ld script which includes this one. */

/* Enforce emmition of the vector table. */
EXTERN (_vectors)

/* Define the entry point of the output file. */
ENTRY(_start)

__stack_size = 0x200;

MEMORY
{
	rom (rwx) : ORIGIN = 0x08000000, LENGTH = 16K
	ram (rwx) : ORIGIN = 0x20000000, LENGTH = 4K
}

/* Define sections. */
SECTIONS
{
  .vectors : {
    . = ALIGN(4);
    KEEP(*(.vectors)) /* Vector table */
    . = ALIGN(4);
  }
  .text : {
    . = ALIGN(4);
    *(.text*)	/* Program code */
    *(.text.*)
    *(.glue_7)
    *(.glue_7t)
    *(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))
    . = ALIGN(4);
    .etext = .;
  } >rom

  .rodata : {
    . = ALIGN(4);
    *(.rodata*)	 /* Read-only data */
    *(.rodata.*) /* Read-only data */
    . = ALIGN(4);
  } >rom

  .ftext : {
    . = ALIGN(4);
    *(.ftext)
    . = ALIGN(4);
  } >rom

  .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >rom
  .ARM : {
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
  } >rom

  .preinit_array : {
    __preinit_array_start = .;
    KEEP (*(.preinit_array*))
    __preinit_array_end = .;
  } >rom
  .init_array : {
    __init_array_start = .;
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array))
    __init_array_end = .;
  } >rom
  .fini_array : {
    __fini_array_start = .;
    KEEP (*(.fini_array))
    KEEP (*(SORT(.fini_array.*)))
    __fini_array_end = .;
  } >rom

  .data : {
    _data = .;
    _sidata = .;
    PROVIDE(__data_low = .);
    . = ALIGN(4);
    *(.data*)	/* Read-write initialized data */
    . = ALIGN(4);
    _edata = .;
    PROVIDE(__data_high = .);
  } >ram AT> rom

  _data_loadaddr = LOADADDR(.data);
  PROVIDE(__data_loadLow = LOADADDR(.data));
  PROVIDE(__data_loadHigh = LOADADDR(.data) + SIZEOF(.data));

  .bss (NOLOAD) : {
    . = ALIGN(4);
     __bss_start__ = .;
    PROVIDE(__bss_low = .);
    *(.bss)
    *(.bss*)	/* Read-write zero initialized data */
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
    __bss_end__ = .;
    PROVIDE(__bss_end = .);
  } >ram

.heap (NOLOAD) :
{
  . = ALIGN(2);
  __heap_start__ = .;
  KEEP (*(.heap))
  _end = .;
  PROVIDE (end = .);
  /* This word is here so that the section is not empty, and thus
     not discarded by the linker.  The actual value does not matter
     and is ignored.  */
  LONG(0);
  __heap_end__ = .;
  __HeapLimit = __heap_end__;
} > ram

/* WARNING: Do not place anything in ram here.
   The heap section must be the last section in ram and the stack
   section must be placed at the very end of the ram region.  */
.stack (ORIGIN (ram) + LENGTH(ram) - __stack_size) :
{
  . = ALIGN(4);
  PROVIDE (__stack = .);
  __stack_low = .;
  *(.stack)
  . += __stack_size;
  __stack_high = .;
  PROVIDE (__STACK_END = .);
}

  PROVIDE(_stack = ORIGIN(ram) + LENGTH(ram));
  PROVIDE(_stacktop = ORIGIN(ram) + LENGTH(ram));
  PROVIDE(heapCurrent = ORIGIN(ram));
  . = ALIGN(4);
  end = .;
  /* Remove information from standard libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes)}
}


