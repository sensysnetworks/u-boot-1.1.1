/*
 * Copyright (C) 2003	Josef Baumgartner <josef.baumgartner@telex.de>
 * Based on code from Bernhard Kuhn <bkuhn@metrowerks.com>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <config.h>
#include "version.h"

#ifndef	 CONFIG_IDENT_STRING
#define	 CONFIG_IDENT_STRING ""
#endif


#define _START	_start
#define _FAULT	_fault


#define SAVE_ALL						\
	move.w	#0x2700,%sr;		/* disable intrs */	\
	subl	#60,%sp;		/* space for 15 regs */ \
	moveml	%d0-%d7/%a0-%a6,%sp@;				\

#define RESTORE_ALL						\
	moveml	%sp@,%d0-%d7/%a0-%a6;				\
	addl	#60,%sp;		/* space for 15 regs */ \
	rte

/* If we come from a pre-loader we don't need an initial exception
 * table.
 */
#if !defined(CONFIG_MONITOR_IS_IN_RAM) || defined(_UC5272_H)

.text
/*
 *	Vector table. This is used for initial platform startup.
 *	These vectors are to catch any un-intended traps.
 */
_vectors:

.long	0x00000000, _START
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT

.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT

.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT

.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT
.long	_FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT, _FAULT

#endif

	.text

	.globl	_start
_start:
	nop
	nop
	move.w #0x2700,%sr

	/* if we come from a pre-loader we have no exception table and
	 * therefore no VBR to set
	 */
#if !defined(CONFIG_MONITOR_IS_IN_RAM)
	move.l	#CFG_FLASH_BASE, %d0
	movec	%d0, %VBR
#endif

#ifdef CONFIG_M5272
	move.l	#(CFG_MBAR + 1), %d0		/* set MBAR address + valid flag */
	move.c	%d0, %MBAR

	move.l	#(CFG_INIT_RAM_ADDR + 1), %d0
	movec	%d0, %RAMBAR0
#endif

#ifdef CONFIG_M5282
	/* Initialize IPSBAR */
	move.l	#(CFG_MBAR + 1), %d0		/* set IPSBAR address + valid flag */
	move.l	%d0, 0x40000000

	/* Initialize FLASHBAR: locate internal Flash and validate it */
	move.l	#(CFG_INT_FLASH_BASE + 0x21), %d0
	movec	%d0, %RAMBAR0

	/* Initialize RAMBAR1: locate SRAM and validate it */
	move.l	#(CFG_INIT_RAM_ADDR + 0x21), %d0
	movec	%d0, %RAMBAR1
#endif

	/* invalidate and disable cache */
	move.l	#0x01000000, %d0		/* Invalidate cache cmd */
	movec	%d0, %CACR			/* Invalidate cache */
	move.l	#0, %d0
	movec	%d0, %ACR0
	movec	%d0, %ACR1

	/* set stackpointer to end of internal ram to get some stackspace for the first c-code */
	move.l	#(CFG_INIT_RAM_ADDR + CFG_INIT_SP_OFFSET), %sp
	clr.l %sp@-

	move.l #__got_start, %a5		/* put relocation table address to a5 */

	bsr cpu_init_f				/* run low-level CPU init code (from flash) */
	bsr board_init_f			/* run low-level board init code (from flash) */

	/* board_init_f() does not return

/*------------------------------------------------------------------------------*/

/*
 * void relocate_code (addr_sp, gd, addr_moni)
 *
 * This "function" does not return, instead it continues in RAM
 * after relocating the monitor code.
 *
 * r3 = dest
 * r4 = src
 * r5 = length in bytes
 * r6 = cachelinesize
 */
	.globl	relocate_code
relocate_code:
	link.w %a6,#0
	move.l 8(%a6), %sp		/* set new stack pointer */

	move.l 12(%a6), %d0		/* Save copy of Global Data pointer */
	move.l 16(%a6), %a0		/* Save copy of Destination Address */

	move.l #CFG_MONITOR_BASE, %a1
	move.l #__init_end, %a2
	move.l %a0, %a3

	/* copy the code to RAM */
1:
	move.l (%a1)+, (%a3)+
	cmp.l  %a1,%a2
	bgt.s	 1b

/*
 * We are done. Do not return, instead branch to second part of board
 * initialization, now running from RAM.
 */
	move.l	%a0, %a1
	add.l	#(in_ram - CFG_MONITOR_BASE), %a1
	jmp	(%a1)

in_ram:

clear_bss:
	/*
	 * Now clear BSS segment
	 */
	move.l	%a0, %a1
	add.l	#(_sbss - CFG_MONITOR_BASE),%a1
	move.l	%a0, %d1
	add.l	#(_ebss - CFG_MONITOR_BASE),%d1
6:
	clr.l	(%a1)+
	cmp.l	%a1,%d1
	bgt.s	6b

	/*
	 * fix got table in RAM
	 */
	move.l	%a0, %a1
	add.l	#(__got_start - CFG_MONITOR_BASE),%a1
	move.l	%a1,%a5		/* * fix got pointer register a5 */

	move.l	%a0, %a2
	add.l	#(__got_end - CFG_MONITOR_BASE),%a2

7:
	move.l	(%a1),%d1
	sub.l	#_start,%d1
	add.l	%a0,%d1
	move.l	%d1,(%a1)+
	cmp.l	%a2, %a1
	bne	7b

	/* calculate relative jump to board_init_r in ram */
	move.l %a0, %a1
	add.l #(board_init_r - CFG_MONITOR_BASE), %a1

	/* set parameters for board_init_r */
	move.l %a0,-(%sp)		/* dest_addr */
	move.l %d0,-(%sp)		/* gd */
	jsr	(%a1)

/*------------------------------------------------------------------------------*/
/* exception code */
	.globl _fault
_fault:
	jmp _fault

	.globl	_exc_handler
_exc_handler:
	SAVE_ALL
	movel	%sp,%sp@-
	bsr exc_handler
	addql	#4,%sp
	RESTORE_ALL

	.globl	_int_handler
_int_handler:
	SAVE_ALL
	movel	%sp,%sp@-
	bsr int_handler
	addql	#4,%sp
	RESTORE_ALL

/*------------------------------------------------------------------------------*/
/* cache functions */
#ifdef	CONFIG_M5272
	.globl	icache_enable
icache_enable:
	move.l	#0x01000000, %d0		/* Invalidate cache cmd */
	movec	%d0, %CACR			/* Invalidate cache */
	move.l	#0x0000c000, %d0		/* Setup cache mask */
	movec	%d0, %ACR0			/* Enable cache */
	move.l	#0xff00c000, %d0		/* Setup cache mask */
	movec	%d0, %ACR1			/* Enable cache */
	move.l	#0x80000100, %d0		/* Setup cache mask */
	movec	%d0, %CACR			/* Enable cache */
	moveq	#1, %d0
	move.l	%d0, icache_state
	rts
#endif

#ifdef CONFIG_M5282
	.globl	icache_enable
icache_enable:
	move.l	#0x01000000, %d0		/* Invalidate cache cmd */
	movec	%d0, %CACR			/* Invalidate cache */
	move.l	#0x0000c000, %d0		/* Setup cache mask */
	movec	%d0, %ACR0			/* Enable cache */
	move.l	#0xff00c000, %d0		/* Setup cache mask */
	movec	%d0, %ACR1			/* Enable cache */
	move.l	#0x80400100, %d0		/* Setup cache mask, data cache disabel*/
	movec	%d0, %CACR			/* Enable cache */
	moveq	#1, %d0
	move.l	%d0, icache_state
	rts
#endif

	.globl	icache_disable
icache_disable:
	move.l	#0x00000100, %d0		/* Setup cache mask */
	movec	%d0, %CACR			/* Enable cache */
	clr.l	%d0				/* Setup cache mask */
	movec	%d0, %ACR0			/* Enable cache */
	movec	%d0, %ACR1			/* Enable cache */
	moveq	#0, %d0
	move.l	%d0, icache_state
	rts

	.globl	icache_status
icache_status:
	move.l	icache_state, %d0
	rts

	.data
icache_state:
	.long	1

/*------------------------------------------------------------------------------*/

	.globl	version_string
version_string:
	.ascii U_BOOT_VERSION
	.ascii " (", __DATE__, " - ", __TIME__, ")"
	.ascii CONFIG_IDENT_STRING, "\0"
