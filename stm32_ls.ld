ENTRY(Reset_Handler)


MEMORY
{
	FLASH(rx) : ORIGIN = 0x08000000, LENGTH = 512K
	SRAM(rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS
{
	.text :
	{
		*(.isr_vector)
		*(.text)
		*(.text.*)
		*(.init)
		*(.fini)
		*(.rodata)
		*(.rodata.*)
		. = ALIGN(4); /* align to 4 bytes before assigning location counter, to get the aligned address*/
		_etext = .;
	} > FLASH 

	_la_data = LOADADDR(.data); /* store the loaded address of data section */

	.data :
	{
		_sdata = .;
		*(.data)
		*(.data.*)
		. = ALIGN(4);
		_edata = .;
	} > SRAM AT> FLASH

	.bss :
	{
		_sbss = .;
		__bss_start__ = _sbss;
		*(.bss)
		*(.bss.*)
		*(COMMON)
		. = ALIGN(4);
		_ebss = .;
		__bss_end__ = _ebss;
		. = ALIGN(4);
		end = .;
		__end__ = .;
	} > SRAM
	
}