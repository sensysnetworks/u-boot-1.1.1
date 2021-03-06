/*
 * (C) Copyright 2000-2003
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <asm/m5272.h>
#include <asm/immap_5272.h>

struct ioport {
    unsigned long	cnt;
    unsigned short	ddr;
    unsigned short	dat;
};

int checkboard (void) {

  /* configure the led - turn on led 1 - 4 */

  volatile struct ioport * port = 
    (struct ioport *) (CFG_MBAR + MCFSIM_PACNT);
#define PORT_A	0
#define PORT_C	2

  /* turn on all leds */
  port[PORT_A].cnt &= ~(0xf);
  port[PORT_A].ddr |= (0xf);
  port[PORT_A].dat &= ~(0xf);

  /* configure gprs reset to input pin */
  port[PORT_C].cnt &= ~(1<<3);
  port[PORT_C].ddr |= (1<<3);

  /* hold the modem in reset */
  port[PORT_C].dat &= ~(1<<3);

	puts ("Board: ");
	puts("Arcturus UC5272\n");
	return 0;
	};

long int initdram (int board_type) {
#ifdef notdef
	volatile sdramctrl_t * sdp = (sdramctrl_t *)(CFG_MBAR + MCFSIM_SDCR);

	sdp->sdram_sdtr = 0xf539;
	sdp->sdram_sdcr = 0x4211;
#endif

	/* Dummy write to start SDRAM */
	*((volatile unsigned long *)0) = 0;

	return CFG_SDRAM_SIZE * 1024 * 1024;
	};

int testdram (void) {
	/* TODO: XXX XXX XXX */
	printf ("DRAM test not implemented!\n");

	return (0);
}
