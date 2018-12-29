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
  fetch_
  ret

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
