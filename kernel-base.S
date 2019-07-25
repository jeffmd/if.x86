# kernel-base.S

# ( -- addr )
# flags address
Forthword_ FFLAGS, 0, "fflags"
  user_ fflags
  ret

# ( -- state )
# system state variable. 0 is interpret mode. Not 0 is compile mode
Forthword_ STATE, 0, "state"
  user_ state
  hmw_
  ret

# ( val -- )
Forthword_ STATESTORE, 0, "state="
  y_w_
  user_ state
  hmw_y_
  ret

# ( -- )
# enter interpreter mode
Forthword_ LBRACKET, IMMEDIATE_EN, "["
  zero_
  jmp STATESTORE

# ( -- )
# enter compile mode
Forthword_ RBRACKET, 0, "]"
  one_
  jmp STATESTORE

# ( -- addr )
# get pause executable
Forthword_ PAUSE_FETCH, 0, "pause@"
  user_ USER_PAUSE
  mw_
  ret

# ( addr --  )
# set pause to addr
Forthword_ PAUSE_STR, 0, "pause="
  y_w_
  user_ USER_PAUSE
  mw_y_
  ret

Forthword_ PAUSE_CLR, 0, "pause.clr"
  # init pause to noop
  lit_ NOOP
  jmp PAUSE_STR

# ( -- addr)
# start address of return stack
Forthword_ RSP0, 0, "rsp0"
  user_ rstack0
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
  lit_ '$      # ( n $ )
  call EMIT    # ( n ? )
  lit_ 28      # ( n 28 )
PHEX_BEGIN:
  y_d0_
  push_
  pushy_       # ( n x n x )
  rshift_      # ( n x n' )
  call PNIB
  pop_         # ( n x )
  fourminus_   # ( n x-4 )
  jne PHEX_BEGIN

  pop_         # ( n )
  call PNIB
  lit_ 32      # ( 32 )
  jmp EMIT
  
# ( -- )
# set terminate flag which indicates request to exit forth interpreter
Forthword_ BYE, 0, "bye"
  call FFLAGS
  x_w_
  lit_y_ 1
  hmx_
  w_or_y_
  hmx_w_
  ret

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
  hmw_                     # ( >in )
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
  call PAUSE_FETCH
  jmp EXEC

# ( -- )
# main loop - iterate through scheduled tasks
Forthword_ DOTASKS, 0, "(tasks)"
  # <begin>
  call DOREFILL     # ( flag )
  iszero_
  je DOTASKS_N1
    # there is something in the input buffer, try interpreting it
.if BUILD_LEVEL > 1
    call DOINTERPRET
.endif
DOTASKS_N1:
  call DOPAUSE

  # check to see if tasks should be terminated
  call FFLAGS
  hmw_
  bittest_ TERMINATE_F
  # <again>
  je DOTASKS
  
  ret

# ( -- a-addr )
# address of idletime
Forthword_ IDLETIMEADDR, 0, "idletime#"
  user_ USER_IDLETIME
  ret

# ( n -- )
# set idletime
Forthword_ IDLETIMESTORE, 0, "idletime="
  y_w_
  user_ USER_IDLETIME
  mw_y_
  ret

# ( -- n )
# get idletime
Forthword_ IDLETIMEFETCH, 0, "idletime@"
  user_ USER_IDLETIME
  mw_
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

# ( -- )
# reset input source
Forthword_ RESET, 0, "reset"
  # reset input source for key
  lit_y_ STDIN
  call KEYADDR
  mw_y_

  call EMIT_ON
  # reset input buffer
  call INRESET
  call SLEEPON

.if BUILD_LEVEL > 9
  call WSET
  zero_
  call SMUDGE_STR
.endif
  call PAUSE_CLR
  # switch to interpret mode
  jmp LBRACKET

# ( -- )
# reset stacks and start over again
Forthword_ QUIT, 0, "quit"
  # reset data stack
  call DSP0
  dsp_w_
  # reset return stack pointer
  #call RP0
  #fetch_
  #str_rp_
  call RESET
  jmp DOTASKS
