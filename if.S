# if.S

.set FULLBUILD, 0
# if FULLBUILD is 0 then a minimum kernel is built but with no interpreter
# minimum kernel build has minimum word set needed to be up and running without interpreter

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
RX: .space 4
RY: .space 4
# litteral word defer
Lit_Interpret: .space 4
Lit_Compile: .space 4
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

.include "core-base.S"
.include "cin.S"
.include "cout.S"
.include "math.S"
.include "string.S"
.include "kernel-base.S"

.if FULLBUILD
  .include "core.S"
  .include "kernel.S"
  .include "include.S"
  .include "mathadv.S"
  #.include "defer.S"
  .include "dictionary.S"
  .include "compiler.S"
  .include "number.S"
  .include "interpret.S"
  .include "asm.S"
  .include "file.S"
.endif

# ( nx* -- ) (R: ny* -- )
# initialize if further. EXECs turnkey operation and go to quit
Forthword_ WARM, 0, "warm"
  call RESET
.if FULLBUILD
	call ONLY
  call DECIMAL           # default to decimal base
.endif
  type_ "if 0.1\n"
  # check if command line args need to be loaded
.if FULLBUILD
	call DOCMDARG
.endif
	jmp QUIT

# ( -- addr)
# start address of the data stack
Forthword_ SP0, 0, "sp0"
  movl $topdatastack, %eax
  ret

.globl RECOVER
.type RECOVER, @function

# ( -- )
# start up if after sig alarm ie segv.
Forthword_ RECOVER, 0, "recover"
  push %ebp
  movl $topdatastack, %ebx
  movl $sysvar_base, %ebp
  call RESET
.if FULLBUILD
	call ONLY
  call DECIMAL           # default to decimal base
.endif
  type_ "recovering...\n"
	call QUIT
	pop %ebp
	ret

.globl COLD
.type COLD, @function

# ( -- )
# start up if.
Forthword_ COLD, 0, "cold"
  push %ebp
  movl $topdatastack, %ebx
  movl $sysvar_base, %ebp
	rp_
	str_y_
	call RP0
	yw_str_
.if FULLBUILD
  call WIPE
.endif
  call WARM
  pop %ebp
  ret

.if FULLBUILD
.include "minimum.S"
.endif
