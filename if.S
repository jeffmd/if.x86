# if.S

.include "macros.S"


# size of the Terminal Input Buffer
.set TIBSIZE, 100

.bss
.balign 4

datastack:
  .space 200
topdatastack:
  .space 8

.balign 2
sysvar_base:

.globl USER_ARGC
.globl  USER_ARGV

COLON_SMUDGE: .space 4
user_g_in: .space 2
state: .space 2
USER_BASE: .space 2
USER_PAUSE: .space 4
USER_KEY: .space 4
USER_KEYFILE: .space 4
USER_EMIT: .space 4
USER_ARGC: .space 4
USER_ARGV: .space 4
USER_HERE: .space 4
USER_IDLETIME: .space 4
ram_CURRENT: .space 4
ram_CONTEXTidx: .space 2
ram_CONTEXT: .space 4 * 10 # 10 wordlists max
fflags: .space 2
ram_dp: .space 4
ram_cp: .space 4
# interpreter register copy
WR: .space 4
RA: .space 4
RB: .space 4
RC: .space 4
RD: .space 4
rstack0: .space 4
ram_handler: .space 4
ram_sharptib: .space 2
ram_tib: .space TIBSIZE

EE_FORTHWORDLIST:
  .space 4 # head pointer
  .space 4 # name pointer
  .space 4 # sibling link pointer
  .space 4 # child pointer


DICTIONARY_START:
  .space 4
# start of user dictionary area
DPSTART:
  .space  0xffff
  
# start of user ram area
HERESTART:
   .space 0xffff

# start of user code area
CPSTART:
   .space 0xffff
    

# start of hard coded program area that can not be modified at runtime
.text

.set VE_HEAD, 0

.include "core.S"
#.include "defer.S"
.include "compiler.S"
.include "interpret.S"
.include "asm.S"
.include "file.S"
.include "minimum.S"

# ( nx* -- ) (R: ny* -- )
# initialize if further. EXECs turnkey operation and go to quit
Forthword_ WARM, 0, "warm"
	call ONLY
  call RESET
  call DECIMAL           # default to decimal base
  type_ "if 0.1\n"
  # check if command line args need to be loaded
	call DOCMDARG
	jmp QUIT

# ( -- addr)
# start address of the data stack
Forthword_ SP0, 0, "sp0"
  movl $topdatastack, %eax
  ret

.globl COLD
.type COLD, @function

# ( -- )
# start up asforth.
Forthword_ COLD, 0, "cold"
  pushl %ebp
  movl $topdatastack, %ebx
  movl $sysvar_base, %ebp
  call WIPE
	rp_
	call RP0
	store_
  call WARM
  popl %ebp
  ret
