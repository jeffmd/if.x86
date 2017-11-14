/*
 * This file is part of muFORTH: http://muforth.nimblemachines.com/
 *
 * Copyright (c) 2002-2012 David Frech. All rights reserved, and all wrongs
 * reversed. (See the file COPYRIGHT for details.)
 */

#include <stdlib.h>     /* exit(3) */
#include <stdio.h>

#include "input.h"

extern void COLD(void);
extern int USER_ARGC;
extern char **USER_ARGV;

int main(int argc, char *argv[])
{
	USER_ARGC = argc;
	USER_ARGV = argv;

	set_input_mode();
	COLD();
	return 0;
}
