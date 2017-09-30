/*
 * This file is part of muFORTH: http://muforth.nimblemachines.com/
 *
 * Copyright (c) 2002-2012 David Frech. All rights reserved, and all wrongs
 * reversed. (See the file COPYRIGHT for details.)
 */

#include <stdlib.h>     /* exit(3) */

#include "input.h"

int argc_l;
char **argv_l;


void if_bye()
{
  exit(0);
}

int main(int argc, char *argv[])
{
	argc_l = argc;
	argv_l = argv;
	
	set_input_mode();
	
	return 0;
}
