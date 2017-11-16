/*
 * main.c - if c stub main entry 
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
