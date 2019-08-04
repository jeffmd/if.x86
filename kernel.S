# kernel.S

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
  mw_
  ret

# ( nx* -- ) (R: ny* -- )
# initialize rf further. EXECs turnkey operation and go to quit
Forthword_ DOCMDARG, 0, "docmdarg"
  call ARGCADDR      # ( ARGCADDR )
  mw_                # ( ARGC )
  push_              # ( ARGC ARGC )
  lit_ 1             # ( ARGC 1 )
  call GREATER       # ( flag )
  iszero_
  if_0_ DOCMDARG_EXIT

  call ARGVADDR      # ( ARGVADDR )
  mw_                # ( ARGV )
  fourplus_          # ( ARGV+4 )
  mw_                # ( ptr )
.if BUILD_LEVEL > 9
  jmp DOINCLUDE
.endif

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
  rpushdsp_
  call gettimeofday
  rnip2_
  pop_
  ret

# ( -- n )
# number of single-cell (4 byte) values contained in the data stack before n was placed on the stack.
Forthword_ DEPTH, 0, "depth"
  call DSP0      # ( dp0 )
  sub %ebx, %eax
  fourslash_    # ( cnt/4 )
  # acount for value push on data stack
  ret

# ( -- )
# check stack underflow, throw exception -4
Forthword_ QSTACK, 0, "?dsp"
  call DEPTH       # ( depth )
  zeroless_        # ( flag )
  iszero_
  if_0_ QSTACKFIN
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
  rpushdsp_           # ( xt ) (R: ret -- callerret SP )
  # handler @ >r
  push_               # ( xt xt )
  call HANDLER        # ( xt haddr )
  y_w_
  mw_                 # ( xt hxt )
  rpush_              # ( xt hxt ) (R: callerret SP hxt )
  # rp@ handler !
  rsp_                # ( xt RP ) (R: callerret SP hxt)
  my_w_               # ( xt RP )
  pop_                # ( xt )
  call EXEC
  # restore handler
  # r> handler !
  rpopy_              # ( hxt ) (R: callerret SP )
  call HANDLER        # ( haddr )
  mw_y_               # ( haddr )
  rnip_               # ( haddr ) (R: callerret)
  zero_               # ( 0 )
  ret

# ( straddr len -- )
# throw an exception
# will type the string passed in
Forthword_ THROW, 0, "throw"
  call TYPE          # ( ? )
  call HANDLER       # ( haddr )
  x_w_               # ( haddr X:haddr )
  mw_                # ( RP_handler )
  rsp_w_             # ( RP_handler ) (R: callerret SP hxt)
  rpop_              # ( hxt ) (R: callerret SP )
  mx_w_              # ( hxt )
  rpopdsp_           # ( SP ) (R: callerret )
  lit_ 1             # ( 1 )
  ret
