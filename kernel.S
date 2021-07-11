# kernel.S

# ( -- argcaddr )
# get ram address of command line argument count
Forthword_ ARGCADDR, 0, "argc#"
  user_ USER_ARGC
  end_
  
# ( -- cmd[]addr )
# get ram address of command line argument vector
Forthword_ ARGVADDR, 0, "argv#"
  user_ USER_ARGV
  end_

# ( -- a-addr )
# location of the cell containing the address of the next free ram location
Forthword_ HEREADDR, 0, "here#"
  user_ USER_HERE
  end_

# ( -- a-addr )
# the address of the next free ram location
Forthword_ HERE, 0, "here"
  do_ HEREADDR
  mw_
  end_

# ( nx* -- ) (R: ny* -- )
# initialize rf further. EXECs turnkey operation and go to quit
Forthword_ DOCMDARG, 0, "docmdarg"
  do_ ARGCADDR       # ( ARGCADDR )
  mw_                # ( ARGC )
  d_w_               # ( ARGC ARGC )
  lit_ 1             # ( ARGC 1 )
  do_ GREATER        # ( flag )
  iszero_
  ifz_ DOCMDARG_EXIT

  do_ ARGVADDR       # ( ARGVADDR )
  mw_                # ( ARGV )
  add_4_             # ( ARGV+4 )
  mw_                # ( ptr )
.if BUILD_LEVEL > 9
  exit_do_ DOINCLUDE
.endif

DOCMDARG_EXIT:
  end_

# ( -- usecs seconds ) 
# get time of day
# gives the number of seconds and microseconds since the Epoch
Forthword_ TIME, 0, "time"
  zero_
  d_w_
  d_w_
  r_w_
  r_dsp_
  do_ gettimeofday
  r_sub_2_
  d_
  end_

# ( -- n )
# number of single-cell (4 byte) values contained in the data stack before n was placed on the stack.
Forthword_ DEPTH, 0, "depth"
  do_ DSP0      # ( dp0 )
  sub %ebx, %eax
  div_4_        # ( cnt/4 )
  # acount for value push on data stack
  end_

# ( -- )
# check stack underflow, throw exception -4
Forthword_ QSTACK, 0, "?dsp"
  do_ DEPTH        # ( depth )
  zeroless_        # ( flag )
  iszero_
  ifz_ QSTACKFIN
    slit_ " Stack Underflow!"
    do_ THROW

QSTACKFIN:
  end_
    
# USER variable used by catch/throw
Forthword_ HANDLER, 0, "handler"
  user_ ram_handler
  end_

# ( i*x xt -- j*x 0 | i*x n )
# setup handler to catch exceptions and then EXEC XT.
Forthword_ CATCH, 0, "catch"
  r_dsp_              # ( xt ) (R: ret -- callerret SP )
  d_w_                # ( xt xt )
  do_ HANDLER         # ( xt haddr )
  y_w_
  mw_                 # ( xt hxt )
  r_w_                # ( xt hxt ) (R: callerret SP hxt )
  rsp_                # ( xt RSP ) (R: callerret SP hxt)
  # @handler=rsp
  my_w_               # ( xt RSP )
  d_                  # ( xt )
  do_ EXEC
  # restore handler
  # r> handler !
  y_r_                # ( hxt ) (R: callerret SP )
  do_ HANDLER         # ( haddr )
  mw_y_               # ( haddr )
  r_sub_1_            # ( haddr ) (R: callerret)
  zero_               # ( 0 )
  end_

# ( straddr len -- )
# throw an exception
# will type the string passed in
Forthword_ THROW, 0, "throw"
  do_ TYPE           # ( ? )
  do_ HANDLER        # ( haddr )
  x_w_               # ( haddr X:haddr )
  mw_                # ( RP_handler )
  rsp_w_             # ( RP_handler ) (R: callerret SP hxt)
  r_                 # ( hxt ) (R: callerret SP )
  mx_w_              # ( hxt )
  dsp_r_             # ( SP ) (R: callerret )
  lit_ 1             # ( 1 )
  end_
