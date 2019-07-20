# if.S

.set BUILD_LEVEL, 3
# if BUILD_LEVEL is 0 then a minimum kernel is built but with no interpreter
# BUILD_LEVEL 1: core and kernel are working
# BUILD_LEVEL 2: interpreter and dictionary working
# BUILD_LEVEL 3: compiler working
# minimum kernel build has minimum word set needed to be up and running without interpreter

.include "macros.S"


# size of the Terminal Input Buffer
.set TIBSIZE, 100
.set MAX_CONTEXTS, 10

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
ram_CONTEXT: .space 4 * MAX_CONTEXTS # 10 wordlists max
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

.if BUILD_LEVEL
  .include "core.S"
  .include "kernel.S"
  
  .if BUILD_LEVEL > 1
    .include "interpret.S"
    .include "dictionary.S"
    .if BUILD_LEVEL > 2
      .include "number.S"
      .include "compiler.S"
      .include "asm.S"
      .include "interpret_number.S"
      .include "include.S"
      .include "mathadv.S"
      #.include "defer.S"
      #.include "file.S"
    .endif
  .endif
  
.endif

# ( nx* -- ) (R: ny* -- )
# initialize if further. EXECs turnkey operation and go to quit
Forthword_ WARM, 0, "warm"
  call RESET
.if BUILD_LEVEL > 1
	call ONLY
.if BUILD_LEVEL > 2
  call DECIMAL           # default to decimal base
.endif
.endif
  type_ "if.x86 0.2\n"
  # check if command line args need to be loaded
.if BUILD_LEVEL > 1
	call DOCMDARG
.endif
	jmp QUIT

# ( -- addr)
# start address of the data stack
Forthword_ DSP0, 0, "dsp0"
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
  
.if BUILD_LEVEL > 1
	call ONLY
.if BUILD_LEVEL > 2
  call DECIMAL           # default to decimal base
.endif
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
  
	rsp_
	y_w_
	call RSP0
	mw_y_
  
.if BUILD_LEVEL > 1
  call WIPE
.endif
  call WARM
  
  pop %ebp
  ret

.if BUILD_LEVEL > 1
.include "minimum.S"
.endif
