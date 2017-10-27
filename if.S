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
rstack0: .space 4
ram_handler: .space 4
ram_sharptib: .space 2
ram_tib: .space TIBSIZE

EE_FORTHWORDLIST:
  .space 4 # head pointer
  .space 4 # name pointer
  .space 4 # sibling link pointer
  .space 4 # child pointer

# start of user ram area
HERESTART:
   .space 65000

# start of user dictionary area
DPSTART:
   .space 65000
   
# start of user code area
CPSTART:
   .space 65000
    
# start of hard coded program area that can not be modified at runtime
.data
.balign 1
DICTIONARY_START:
  .space 4
  
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
	pushtos_
	mov %esp, %ebx
	call RP0
	call STORE
	call ONLY
  call RESET
  call DECIMAL           # default to decimal base
  type_ "if 0.1\n"
  # check if command line args need to be loaded
	#call DOCMDARG
	jmp QUIT

# ( -- addr)
# start address of the data stack
Forthword_ SP0, 0, "sp0"
  pushtos_
  movl $topdatastack, %ebx
  ret

.globl COLD
.type COLD, @function

# ( -- )
# start up asforth.
Forthword_ COLD, 0, "cold"
  pushl %ebp
  movl $topdatastack, %eax
  movl $sysvar_base, %ebp
  call WIPE
  call WARM
  movl %ebx, %eax
  popl %ebp
  ret
