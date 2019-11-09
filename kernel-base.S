# kernel-base.S

# ( -- addr )
# flags address
Forthword_ FFLAGS, 0, "fflags"
  user_ fflags
  end_

# ( -- state )
# system state variable. 0 is interpret mode. Not 0 is compile mode
Forthword_ STATE, 0, "state"
  user_ state
  hmw_
  end_

# ( val -- )
Forthword_ STATESTORE, 0, "state="
  y_w_
  user_ state
  hmw_y_
  end_

# ( -- )
# enter interpreter mode
Forthword_ LBRACKET, IMMEDIATE_EN, "["
  zero_
  end_do_ STATESTORE

# ( -- )
# enter compile mode
Forthword_ RBRACKET, 0, "]"
  lit_ 1
  end_do_ STATESTORE

# ( -- addr )
# get pause executable
Forthword_ PAUSE_FETCH, 0, "pause@"
  user_ USER_PAUSE
  mw_
  end_

# ( addr --  )
# set pause to addr
Forthword_ PAUSE_STR, 0, "pause="
  y_w_
  user_ USER_PAUSE
  mw_y_
  end_

Forthword_ PAUSE_CLR, 0, "pause.clr"
  # init pause to noop
  lit_ NOOP
  end_do_ PAUSE_STR

# ( -- addr)
# start address of return stack
Forthword_ RSP0, 0, "rsp0"
  user_ rstack0
  end_

# ( val -- char )
# convert low byte of val to a printable hex character
Forthword_ NHEX, 0, "#h"
  and $0x0f, %eax
  cmp $10, %eax
  jb NHEX_NEXT
  add $7, %eax

NHEX_NEXT:
  add $48, %eax
  end_

# ( n -- )
# simple 4 bit hex print
Forthword_ PNIB, 0, ".h"
  do_ NHEX
  end_do_ EMIT

# ( n -- )
# simple 32 bit hex print
Forthword_ PHEX, 0, ".$"
  push_        # ( n n )
  lit_ '$      # ( n $ )
  do_ EMIT    # ( n ? )
  lit_ 28      # ( n 28 )
PHEX_BEGIN:
  y_d0_
  push_
  pushy_       # ( n x n x )
  rshift_      # ( n x n' )
  do_ PNIB
  pop_         # ( n x )
  fourminus_   # ( n x-4 )
  if_not_0_ PHEX_BEGIN

  pop_         # ( n )
  do_ PNIB
  lit_ 32      # ( 32 )
  end_do_ EMIT
  
# ( -- )
# set terminate flag which indicates request to exit forth interpreter
Forthword_ BYE, 0, "bye"
  do_ FFLAGS
  x_w_
  lit_y_ 1
  hmx_
  w_or_y_
  hmx_w_
  end_

# ( -- )
# send the READY prompt to the command line
Forthword_ PROMPTRDY, 0, ".>"
  type_ "\n> "
  end_

# ( -- )
# send the READY prompt to the command line
Forthword_ PROMPTCOMPILE, 0, ".:"
  type_ "\n: "
  end_

# ( -- )
# send the OK prompt to the command line
Forthword_ PROMPTOK, 0, ".ok"
  type_ " ok"
  end_

# ( n -- )
# process the error prompt
Forthword_ PROMPTERROR, 0, ".??"
  type_ " ?? "
  end_

# ( -- )
# check if a ready prompt is required
Forthword_ QP_RD, 0, "?prd"
  do_ STATE
  # output ready prompt if in interpret mode
  # <-if>
  iszero_
  if_not_0_ QP_RD_exit
    exit_do_ PROMPTRDY

QP_RD_exit:
  # <then>
  end_do_ PROMPTCOMPILE

# ( -- flag)
# fill up the input buffer some more
# flag is true if input buffer is full or needs processing
Forthword_ DOREFILL, 0, "(refill)"
  # if just starting new input line then check prompt and reset input position
  do_ G_IN                # ( >inaddr )
  hmw_                     # ( >in )
  iszero_                  # ( >in )
  if_0_ DOREFILL_do
    do_ INRESET

DOREFILL_do:
  # refill the input buffer
  end_do_ REFILL           # ( f )

# ( -- )
# Fetch pause vector and EXEC it. may make a context/task switch
Forthword_ DOPAUSE, 0, "(pause)"
  push_
  do_ SLEEP ## temp fix for cpu hogging
  do_ PAUSE_FETCH
  end_do_ EXEC

# ( -- )
# main loop - iterate through scheduled tasks
Forthword_ DOTASKS, 0, "(tasks)"
  # <begin>
  do_ DOREFILL     # ( flag )
  iszero_
  if_0_ DOTASKS_N1
    # there is something in the input buffer, try interpreting it
.if BUILD_LEVEL > 1
    do_ DOINTERPRET
.endif
DOTASKS_N1:
  do_ DOPAUSE

  # check to see if tasks should be terminated
  do_ FFLAGS
  hmw_
  bittest_ TERMINATE_F
  # <again>
  if_0_ DOTASKS
  
  end_

# ( -- a-addr )
# address of idletime
Forthword_ IDLETIMEADDR, 0, "idletime#"
  user_ USER_IDLETIME
  end_

# ( n -- )
# set idletime
Forthword_ IDLETIMESTORE, 0, "idletime="
  y_w_
  user_ USER_IDLETIME
  mw_y_
  end_

# ( -- n )
# get idletime
Forthword_ IDLETIMEFETCH, 0, "idletime@"
  user_ USER_IDLETIME
  mw_
  end_

# ( n -- )
# sleep for n micro seconds
Forthword_ USLEEP, 0, "usleep"
  rpush_
  do_ usleep
  rnip_
  end_

# ( -- )
# sleep for n micro seconds
Forthword_ SLEEP, 0, "sleep"
  do_ IDLETIMEFETCH
  iszero_
  if_0_ NO_IDLESLEEP
  exit_do_ USLEEP
NO_IDLESLEEP:
  end_

# ( -- )
# turn sleep off
Forthword_ SLEEPOFF, 0, "sleep.off"
  zero_
  end_do_ IDLETIMESTORE

# ( -- )
# turn sleep on
Forthword_ SLEEPON, 0, "sleep.on"
  lit_ 5000
  end_do_ IDLETIMESTORE

# ( -- )
# reset input source
Forthword_ RESET, 0, "reset"
  # reset input source for key
  lit_y_ STDIN
  do_ KEYADDR
  mw_y_

  do_ EMIT_ON
  # reset input buffer
  do_ INRESET
  do_ SLEEPON

.if BUILD_LEVEL > 9
  do_ WSET
  zero_
  do_ SMUDGE_STR
.endif
  do_ PAUSE_CLR
  # switch to interpret mode
  end_do_ LBRACKET

# ( -- )
# reset stacks and start over again
Forthword_ QUIT, 0, "quit"
  # reset data stack
  do_ DSP0
  dsp_w_
  # reset return stack pointer
  #do_ RP0
  #fetch_
  #str_rp_
  do_ RESET
  end_do_ DOTASKS
