# if.S

.include "macros.S"

# size of the Terminal Input Buffer
.set TIBSIZE, 100

.bss
.balign 4

datastack:
  .space 800
topdatastack:
  .space 8

.balign 2
sysvar_base:

COLON_SMUDGE: .space 4
user_g_in: .space 2
state: .space 2
USER_BASE: .space 2
USER_PAUSE: .space 4
USER_KEY: .space 4
USER_KEYFILE: .space 4
USER_ARGC: .space 4
USER_ARGV: .space 4
USER_HERE: .space 4
ram_CURRENT: .space 4
ram_CONTEXTidx: .space 2
ram_CONTEXT: .space 4 * 10 # 10 wordlists max
fflags: .space 2
ram_dp: .space 4
rstack0: .space 4
ram_LATEST: .space 4
ram_handler: .space 4
ram_sharptib: .space 2
ram_tib: .space TIBSIZE

EE_FORTHWORDLIST:
  .space 4 # head pointer
  .space 4 # name pointer

# start of user ram area
HERESTART:
   .space 64000

# start of user program area
DPSTART:
   .space 64000

# start of hard coded program area that can not be modified at runtime
.text

.set VE_HEAD, 0

.include "core.S"

	.globl	cold
	.type	cold, @function

# ( -- )
# start up asforth.
Forthword_ cold, 0, "cold"

  ret
