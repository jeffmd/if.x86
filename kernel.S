# kernel.S

# ( -- addr )
# flags address
Forthword_ FFLAGS, 0, "fflags"
  user_ fflags
  ret


# ( -- state )
# system state variable. 0 is interpret mode. Not 0 is compile mode
Forthword_ STATE, 0, "state"
  user_ state
  hfetch_
  ret

# ( val -- )
Forthword_ STATESTORE, 0, "state!"
  str_y_
  user_ state
  yw_hstr_
  ret

# ( -- )
# enter interpreter mode
Forthword_ LBRACKET, IMMEDIATE_EN, "["
  user_ state
  jmp ZERO_HSTR

# ( -- )
# enter compile mode
Forthword_ RBRACKET, 0, "]"
  one_
  jmp STATESTORE

# ( -- pauseaddr )
# get ram address of pause defer
Forthword_ PAUSEADDR, 0, "pause#"
  user_ USER_PAUSE
  ret

# ( -- argcaddr )
# get ram address of command line argument count
Forthword_ ARGCADDR, 0, "argc#"
  user_ USER_ARGC
  ret
  
# ( -- cmd[]addr )
# get ram address of command line argument vector
Forthword_ ARGVADDR, 0, "argv#"
  user_ USER_ARGV
  ret

# ( -- a-addr )
# location of the cell containing the address of the next free ram location
Forthword_ HEREADDR, 0, "here#"
  user_ USER_HERE
  ret

# ( -- a-addr )
# the address of the next free ram location
Forthword_ HERE, 0, "here"
  call HEREADDR
  fetch_
  ret

# ( -- a-addr )
# address of idletime
Forthword_ IDLETIMEADDR, 0, "idletime#"
  user_ USER_IDLETIME
  ret

# ( n -- )
# set idletime
Forthword_ IDLETIMESTORE, 0, "idletime!"
  str_y_
  user_ USER_IDLETIME
  yw_str_
  ret

# ( -- n )
# get idletime
Forthword_ IDLETIMEFETCH, 0, "idletime@"
  user_ USER_IDLETIME
  fetch_
  ret

# ( val -- char )
# convert low byte of val to a printable hex character
Forthword_ NHEX, 0, "#h"
  and $0x0f, %eax
  cmp $10, %eax
  jb NHEX_NEXT
  add $7, %eax

NHEX_NEXT:
  add $48, %eax
  ret

# ( n -- )
# simple 4 bit hex print
Forthword_ PNIB, 0, ".h"
  call NHEX
  jmp EMIT

# ( n -- )
# simple 32 bit hex print
Forthword_ PHEX, 0, ".$"
  push_        # ( n n )
  lit_ '$    # ( n $ )
  call EMIT    # ( n ? )
  lit_ 28    # ( n 28 )
PHEX_BEGIN:
  call TWOOVER # ( n x n x )
  rshift_      # ( n x n' )
  call PNIB
  pop_         # ( n x )
  fourminus_   # ( n x-4 )
  jne PHEX_BEGIN

  pop_         # ( n )
  call PNIB
  lit_ 32    # ( 32 )
  jmp EMIT
  
# ( -- )
# send the READY prompt to the command line
Forthword_ PROMPTRDY, 0, ".>"
  type_ "\n> "
  ret

# ( -- )
# send the READY prompt to the command line
Forthword_ PROMPTCOMPILE, 0, ".:"
  type_ "\n: "
  ret

# ( -- )
# send the OK prompt to the command line
Forthword_ PROMPTOK, 0, ".ok"
  type_ " ok"
  ret

# ( n -- )
# process the error prompt
Forthword_ PROMPTERROR, 0, ".??"
  type_ " ?? "
  ret

# ( -- )
# check if a ready prompt is required
Forthword_ QP_RD, 0, "?prd"
  call STATE
  # output ready prompt if in interpret mode
  # <-if>
  iszero_
  jne QP_RD_exit
    jmp PROMPTRDY

QP_RD_exit:
  # <then>
  jmp PROMPTCOMPILE

# ( -- flag)
# fill up the input buffer some more
# flag is true if input buffer is full or needs processing
Forthword_ DOREFILL, 0, "(refill)"
  # if just starting new input line then check prompt and reset input position
  call G_IN                # ( >inaddr )
  hfetch_                  # ( >in )
  iszero_                  # ( >in )
  je DOREFILL_do
    call INRESET

DOREFILL_do:
  # refill the input buffer
  jmp REFILL              # ( f )

# ( -- )
# Fetch pause vector and EXEC it. may make a context/task switch
Forthword_ DOPAUSE, 0, "(pause)"
  push_
  call SLEEP ## temp fix for cpu hogging
  call PAUSEADDR
  fetch_
  jmp EXEC

# ( -- )
# main loop - iterate through scheduled tasks
Forthword_ DOTASKS, 0, "(tasks)"
  # <begin>
  call DOREFILL     # ( flag )
  iszero_
  je DOTASKS_N1
    # there is something in the input buffer, try interpreting it
    call DOINTERPRET
DOTASKS_N1:
  call DOPAUSE

  # check to see if tasks should be terminated
  call FFLAGS
  hfetch_
  bittest_ TERMINATE_F
  # <again>
  je DOTASKS
  
  ret

# ( -- )
# set terminate flag which indicates request to exit forth interpreter
Forthword_ BYE, 0, "bye"
  call FFLAGS
  str_x_
  one_
  str_y_
  x_hfetch_
  ory_
  x_hstr_
  ret

# ( -- )
# turn emit off
Forthword_ EMIT_OFF, 0, "emit.off"
  # reset output source for emit
  lit_y_ NOOP
  call EMITADDR
  yw_str_
  ret

# ( -- )
# turn emit on for default output
Forthword_ EMIT_ON, 0, "emit.on"
  # reset output source for emit
  lit_y_ PUTCHAR
  call EMITADDR
  yw_str_
  ret

# ( -- )
# reset input source
Forthword_ RESET, 0, "reset"
  call ZERO_SMUDGE_STR

  # reset input source for key
  lit_y_ STDIN
  call KEYADDR
  yw_str_

  call EMIT_ON
  # reset input buffer
  call INRESET
  call SLEEPON
  call WSET
  # switch to interpret mode
  jmp LBRACKET

# ( -- )
# reset stacks and start over again
Forthword_ QUIT, 0, "quit"
  # reset data stack
  call SP0
  str_sp_
  # reset return stack pointer
  #call RP0
  #fetch_
  #str_rp_
  call RESET
  jmp DOTASKS

# ( nx* -- ) (R: ny* -- )
# initialize rf further. EXECs turnkey operation and go to quit
Forthword_ DOCMDARG, 0, "docmdarg"
  call ARGCADDR      # ( ARGCADDR )
  fetch_             # ( ARGC )
  push_              # ( ARGC ARGC )
  one_               # ( ARGC 1 )
  call GREATER       # ( flag )
  iszero_
  je DOCMDARG_EXIT

  call ARGVADDR      # ( ARGVADDR )
  fetch_             # ( ARGV )
  fourplus_          # ( ARGV+4 )
  fetch_             # ( ptr )
  jmp DOINCLUDE

DOCMDARG_EXIT:
  ret

# ( -- usecs seconds ) 
# get time of day
# gives the number of seconds and microseconds since the Epoch
Forthword_ TIME, 0, "time"
    zero_
    push_
    push_
    rpush_
    rpush_sp_
    call gettimeofday
    rnip2_
    pop_
    ret

# ( -- addr)
# start address of return stack
Forthword_ RP0, 0, "rp0"
  user_ rstack0
  ret

# ( -- n )
# number of single-cell (4 byte) values contained in the data stack before n was placed on the stack.
Forthword_ DEPTH, 0, "depth"
  call SP0      # ( sp0 )
  sub %ebx, %eax
  fourslash_    # ( cnt/4 )
  # acount for value push on data stack
  ret

# ( -- )
# check stack underflow, throw exception -4
Forthword_ QSTACK, 0, "?sp"
  call DEPTH       # ( depth )
  zeroless_        # ( flag )
  iszero_
  je QSTACKFIN
    slit_ " Stack Underflow!"
    call THROW

QSTACKFIN:
  ret
    
# USER variable used by catch/throw
Forthword_ HANDLER, 0, "handler"
  user_ ram_handler
  ret

# ( i*x xt -- j*x 0 | i*x n )
# setup handler to catch exceptions and then EXEC XT.
Forthword_ CATCH, 0, "catch"
  # sp@ >r
  rpush_sp_           # ( xt ) (R: ret -- callerret SP )
  # handler @ >r
  push_               # ( xt xt )
  call HANDLER        # ( xt haddr )
  fetch_              # ( xt hxt )
  rpush_              # ( xt hxt ) (R: callerret SP hxt )
  # rp@ handler !
  rp_str_y_           # ( xt Y:RP ) (R: callerret SP hxt)
  call HANDLER        # ( xt haddr )
  yw_str_             # ( xt haddr )
  pop_                # ( xt )
  call EXEC
  # restore handler
  # r> handler !
  rpop_y_             # ( hxt ) (R: callerret SP )
  call HANDLER        # ( haddr )
  yw_str_             # ( haddr )
  rnip_               # ( haddr ) (R: callerret)
  zero_               # ( 0 )
  ret

# ( straddr len -- )
# throw an exception
# will type the string passed in
Forthword_ THROW, 0, "throw"
  call TYPE          # ( ? )
  call HANDLER       # ( haddr )
  str_x_             # ( haddr X:haddr )
  fetch_             # ( RP_handler )
  str_rp_            # ( RP_handler ) (R: callerret SP hxt)
  rpop_              # ( hxt ) (R: callerret SP )
  x_str_             # ( hxt )
  rpop_sp_           # ( SP ) (R: callerret )
  one_               # ( ... 1 )
  ret

# ( n -- )
# sleep for n micro seconds
Forthword_ USLEEP, 0, "usleep"
  rpush_
  call usleep
  rnip_
  ret

# ( -- )
# sleep for n micro seconds
Forthword_ SLEEP, 0, "sleep"
  call IDLETIMEFETCH
  iszero_
  je NO_IDLESLEEP
  jmp USLEEP
NO_IDLESLEEP:
  ret

# ( -- )
# turn sleep off
Forthword_ SLEEPOFF, 0, "sleep.off"
  zero_
  jmp IDLETIMESTORE

# ( -- )
# turn sleep on
Forthword_ SLEEPON, 0, "sleep.on"
  lit_ 5000
  jmp IDLETIMESTORE
