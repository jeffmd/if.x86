# minimum.S

# ( -- a-addr )
# location of the cell containing the address of the next free ram location
Forthword_ HEREADDR, 0, "here#"
  douser_ USER_HERE

# ( -- a-addr )
# the address of the next free ram location
Forthword_ HERE, 0, "here"
  call HEREADDR
  fetch_
  ret

# ( -- a-addr )
# address of idletime
Forthword_ IDLETIMEADDR, 0, "idletime#"
  douser_ USER_IDLETIME

# ( n -- )
# set idletime
Forthword_ IDLETIMESTORE, 0, "idletime!"
  dpush_
  call IDLETIMEADDR
  jmp STORE

# ( -- n )
# get idletime
Forthword_ IDLETIMEFETCH, 0, "idletime@"
  call IDLETIMEADDR
  fetch_
  ret

# ( -- a-addr )
# location of the cell containing the number conversion radix
Forthword_ BASE, 0, "base"
    douser_ USER_BASE

# ( n -- )
# save base
Forthword_ BASESTORE, 0, "base!"
    dpush_
    call BASE
    jmp HSTORE

# ( n -- )
# load base
Forthword_ BASEFETCH, 0, "base@"
    call BASE
    hfetch_
    ret

# ( -- )
# set base for number conversion to 2
Forthword_ BIN, 0, "bin"
  two_
  jmp BASESTORE


# ( -- )
# set base for numeric conversion to 10
Forthword_ DECIMAL, 0, "decimal"
  ten_
  jmp BASESTORE

# ( -- )
# set base for number conversion to 16
Forthword_ HEX, 0, "hex"
  dolit_ 16
  jmp BASESTORE

# ( n1 n2 -- n1|n2 )
# compare two values leave the smaller one
Forthword_ MIN, 0, "min"
  str_d_
  dpop_
  cmp %eax, %edx
  jge 1f
  d_
1:
  ret

# ( n1 n2 -- n1|n2 )
# compare two values, leave the bigger one
Forthword_ MAX, 0, "max"
  str_d_
  dpop_
  cmp %eax, %edx
  jl 1f
  d_
1:
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
  dpush_       # ( n n )
  dolit_ '$    # ( n $ )
  call EMIT    # ( n ? )
  dolit_ 28    # ( n 28 )
PHEX_BEGIN:
  call TWOOVER # ( n x n x )
  rshift_      # ( n x n' )
  call PNIB
  dpop_        # ( n x )
  fourminus_   # ( n x-4 )
  jne PHEX_BEGIN

  dpop_        # ( n )
  call PNIB
  dolit_ 32    # ( 32 )
  jmp EMIT

# ( u1 u2 -- flag )
# compare two unsigned numbers, returns true flag if u1 is less then or equal to u2
Forthword_ ULESSEQUAL, 0, "u<="
    call UGREATER
    not_
    ret

# ( u1 u2 -- flag )
# compare two unsigned numbers, returns true flag if u1 is greater then or equal to u2
Forthword_ UGREATEREQUAL, 0, "u>="
    call ULESS
    not_
    ret

# ( n1 -- u1 )
# get the absolute value
Forthword_ ABS, 0, "abs"
  iszero_
  jns 1f
  neg_
1:
  ret

# ( c -- (number|) flag )
# tries to convert a character to a number, set flag accordingly
Forthword_ DIGITQ, 0, "digit?"
    sub $0x30, %eax      # ( c' )
    cmp $10, %eax
    jb DIGITQ0
    sub $7, %eax         # ( c )
    cmp $10, %eax        # ( c )
    jge DIGITQ0

    zero_                # ( 0 )
    ret

DIGITQ0:
    dpush_               # ( n n )
    dpush_               # ( n n n )
    call BASEFETCH       # ( n n base )
    call UGREATEREQUAL   # ( n flag )
    iszero_
    je PFA_DIGITQ_DONE
    zero_                # ( n 0 )
    dnip_                # ( 0 )
    ret

PFA_DIGITQ_DONE:
    true_                # ( n true )
    ret

# ( c -- ) Numeric IO
# set the BASE value depending on the character
#forthword_ SETBASE, 0, "setbase"
SETBASE:        
  cmp $'$, %eax
  jne PFA_SETBASE0
  jmp HEX

PFA_SETBASE0:
  cmp $'%, %eax
  jne PFA_SETBASE1
  jmp BIN

PFA_SETBASE1:
  cmp $'&, %eax
  jne PFA_SETBASE2
  jmp DECIMAL

PFA_SETBASE2:        # ( error)
  call EMIT
  $lit_ " Bad Base!"
  call THROW

# ( addr len -- addr' len' )
# skip a numeric prefix character
#forthword_ PRAEFIX, 0, "praefix"
PRAEFIX:             # ( addr len -- addr' len' )
  over_            # ( addr len addr )
  cfetch_          # ( addr len c )
  cmp $0x30, %eax
  jb PFA_PRAEFIX0
  # no praefix
  dpop_            # ( addr len )
  ret

PFA_PRAEFIX0:
  call SETBASE     # ( addr len c )
  one_             # ( addr len 1 )
  call SLASHSTRING # ( addr' len' )
  ret

# (addr len -- addr len flag) Numeric IO
# check for - sign
# forthword_ NUMBERSIGN, 0, "#-"
NUMBERSIGN:        # ( addr len -- )
  over_          # ( addr len addr )
  cfetch_        # ( addr len char )
  cmp $'-, %eax
  je NUMBERSIGN_HASSIGN
    zero_      # ( addr len 0 )
    ret

NUMBERSIGN_HASSIGN:
  rpush_           # ( addr len char ) (R: char )
  one_             # ( addr len 1 )
  call SLASHSTRING # ( addr len )
  dpush_           # ( addr len len )
  rpop_            # ( addr len char ) (R: )
  ret

# ( u1 addr len -- u2 addr2 len2 )
# convert a string to a number  c-addr2/u2 is the unconverted string
Forthword_ TO_NUMBER, 0, ">num"
  iszero_
  je TO_NUMBER_END
    over_                # ( u addr len addr )
    cfetch_              # ( u addr len char )
    call DIGITQ          # ( u addr len [digit] flag )
    iszero_
    dpop_                # ( u adr len [digit] )
    jne TO_NUMBER_CONV
      # character is not a recognized number
      ret              # ( u adr len )

TO_NUMBER_CONV:
  str_b_               # ( u adr len digit ) B: digit
  d2_                  # ( u adr len u )
  dpush_               # ( u adr len u u )
  call BASEFETCH       # ( u adr len u base )
  d0_str_d_            # ( u adr len u base ) D: u
  imul %edx, %eax      # ( u adr len u u*base )
  b_str_d0_            # ( u adr len digit u*base )
  plus_                # ( u adr len u'' )
  str_d2_              # ( u'' adr len u'' )
  one_                 # ( u'' adr len 1 )
  call SLASHSTRING     # ( u'' adr' len' )
  jmp TO_NUMBER

TO_NUMBER_END:
  ret

# (addr len -- [n] f)
# convert a string at addr to a number
Forthword_ NUMBER, 0, "num"
  dpush_                  # ( addr len len )
  call BASEFETCH          # ( addr len base )
  rpush_                  # ( addr len base ) (R: base)
  dpop_                   # ( addr len )
  call NUMBERSIGN         # ( addr len flag )
  rpush_                  # ( addr len flag ) (R: base flagsign)
  dpop_                   # ( addr len )
  call PRAEFIX            # ( addr' len' )
  call NUMBERSIGN         # ( addr len flagsign2 )
  dpush_                  # ( addr len flagsign2 flagsign2 )
  rpop_                   # ( addr len flagsign2 flagsign ) (R: base )
  or_                     # ( addr len flagsign' )
  rpush_                  # ( addr len flagsign' ) (R: base flagsign')
  d0_str_c_               # ( addr len flagsign' ) C: len
  d1_str_d_               # ( addr len flagsign' ) D: addr
  zero_                   # ( addr len 0 )
  str_d1_                 # ( 0 len 0 )
  d_str_d0_               # ( 0 addr 0 )
  c_                      # ( 0 addr len )
  call TO_NUMBER          # ( n addr' len' )
  # check length of the remaining string.
  # if zero: a single cell number is entered
  iszero_
  dpop_                   # ( n addr' )
  je PFA_NUMBER_SIGN

  # error in string to number conversion
  dnip_                   # ( addr' ) (R: base flagsign' )
  rnip_                   # ( addr' ) (R: base )
  zero_                   # ( 0 ) (R: base )
  jmp PFA_NUMBER_DONE

PFA_NUMBER_SIGN:
  # incorporate sign into number
  rpop_                   # ( n flagsign' ) (R: base )
  iszero_
  je PFA_NUMBER_TRUE
  dpop_                   # ( n )
  neg_                    # ( -n )
  dpush_                  # ( -n -n )

PFA_NUMBER_TRUE:
  true_                   # ( n true ) (R: base )

PFA_NUMBER_DONE:
  dpush_                  # ( n flag flag )
  rpop_                   # ( n flag base ) (R: )
  call BASESTORE          # ( n flag ? )
  dpop_                   # ( n flag )
  ret

# Multiply unsigned 32*32 = 64
# ( u u -- ud )
Forthword_ UMSTAR, 0, "um*"
  d0_str_c_
  mul %ecx
  d_str_d0_
  ret

# ( n n -- d)
# multiply 2 signed cells to a double cell
# signed 32*32 = 64
Forthword_ MSTAR, 0, "m*"
  d0_str_c_
  imul %ecx
  d_str_d0_
  ret

# ( ud u -- u u ) Dividend Divisor -- mod quotient
# 64/32 = 32 Rest 32
Forthword_ UM_DIVMOD, 0, "um/mod"
  str_c_
  d1_str_d_
  d0_
  dnip_
  div %ecx
  d_str_d0_
  ret

# ( u1 u2 -- rem quot )
# unsigned 32b division with modulus result
Forthword_ U_DIVMOD, 0, "u/mod"
  str_c_
  d0_
  cltd
  div %ecx
  d_str_d0_
  ret

Forthword_ M_DIVMOD, 0, "m/mod"
# Signed symmetric divide 64/32 = 32 remainder 32
# ( d n -- n n )
  str_c_
  d1_str_d_
  d0_
  dnip_
  idiv %ecx
  d_str_d1_
  ret

# ( n1 n2 -- rem quot )
# signed division with remainder
Forthword_ DIVMOD, 0, "/mod"
  str_c_
  d0_
  cltd
  idiv %ecx
  d_str_d0_
  ret

# ( n1 n2 -- n1/n2 )
# 32bit/32bit = 32bit
Forthword_ DIV, 0, "/"
  str_c_
  d0_
  cltd
  dnip_
  idiv %ecx
  ret

# ( -- addr)
# start address of return stack
Forthword_ RP0, 0, "rp0"
  douser_ rstack0

# ( -- n )
# number of single-cell (4 byte) values contained in the data stack before n was placed on the stack.
Forthword_ DEPTH, 0, "depth"
  call SP0      # ( sp0 )
  dpush_        # ( sp0 sp0 )
  sp_           # ( sp0 sp )
  minus_        # ( cnt )
  fourslash_    # ( cnt/4 )
  # acount for value push on data stack
  oneminus_     # ( cnt/4-1 )
  ret

# ( -- )
# check stack underflow, throw exception -4
Forthword_ QSTACK, 0, "?sp"
  call DEPTH       # ( depth )
  zeroless_        # ( flag )
  iszero_
  je QSTACKFIN
    $lit_ " Stack Underflow!"
    call THROW

QSTACKFIN:
  ret



# USER variable used by catch/throw
Forthword_ HANDLER, 0, "handler"
  douser_ ram_handler

# ( i*x xt -- j*x 0 | i*x n )
# setup handler to catch exceptions and then EXEC XT.
Forthword_ CATCH, 0, "catch"
  # sp@ >r
  rpushsp_            # ( xt sp ) (R: ret -- callerret SP )
  # handler @ >r
  dpush_              # ( xt xt )
  call HANDLER        # ( xt haddr )
  fetch_              # ( xt hxt )
  rpush_              # ( xt hxt ) (R: callerret SP hxt )
  # rp@ handler !
  rp_                 # ( xt RP ) (R: callerret SP hxt)
  dpush_              # ( xt RP RP )
  call HANDLER        # ( xt RP haddr )
  store_              # ( xt haddr )
  dpop_               # ( xt )
  call EXEC
  # restore handler
  # r> handler !
  rpop_               # ( hxt ) (R: callerret SP )
  dpush_              # ( hxt hxt )
  call HANDLER        # ( hxt haddr )
  store_              # ( haddr )
  rnip_               # ( haddr ) (R: callerret)
  zero_               # ( 0 )
  ret

# ( straddr len -- )
# throw an exception
# will type the string passed in
Forthword_ THROW, 0, "throw"
  call TYPE          # ( ? )
  call HANDLER       # ( haddr )
  fetch_             # ( RP_handler )
  str_rp_            # ( RP_handler ) (R: callerret SP hxt)
  rpop_              # ( hxt ) (R: callerret SP )
  dpush_
  call HANDLER       # ( hxt haddr )
  store_             # ( haddr )
  rpop_              # ( SP ) (R: callerret )
  str_sp_            # ( ... )
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
Forthword_ SLEEPOFF, 0, "sleepoff"
  zero_
  jmp IDLETIMESTORE

# ( -- )
# turn sleep on
Forthword_ SLEEPON, 0, "sleepon"
  dolit_ 5000
  jmp IDLETIMESTORE


# ( caddr -- ** )
# open a file that will be used for key input
# caddr points to null terminated file name
Forthword_ DOINCLUDE, 0, "doinclude"
  # set file open mode to reading
  dpush_                # ( caddr caddr )
  zero_                 # ( caddr 0 )
  call OPENF            # ( filedes )
  # if file descriptor > 0 then open is success
  dpush_                # ( filedes filedes )
  call ZEROGREATER      # ( filedes flag )
  iszero_
  je DOINCLUDE_EXIT

  call IDLETIMEFETCH    # ( filedes itime )
  rpush_                # ( filedes itime ) (R: itime )
  call SLEEPOFF         # ( filedes ? )
  # push FFLAGS on tor
  call FFLAGS           # ( filedes fflags# )
  hfetch_               # ( filedes fflags )
  rpush_                # ( filedes fflags ) (R: itime fflags )
  # push on return stack the old defer key
  call KEYADDR          # ( filedes KEYADDR )
  fetch_                # ( filedes KEY )
  rpush_                # ( filedes KEY ) (R: itime fflags KEY)
  # push old keyfile on return stack
  call KEYFILEADDR      # ( filedes KEYFILEADDR ) (R: itime fflags KEY)
  fetch_                # ( filedes KEYFILE ) (R: itime fflags KEY)
  rpush_                # ( filedes KEYFILE ) (R: itime fflags KEY KEYFILE)
  call KEYFILEADDR      # ( filedes KEYFILEADDR )
  store_                # ( KEYFILEADDR )
  # defer key to keyfile for input
  dolit_ KEYFILE        # ( KEYFILE )
  dpush_                # ( KEYFILE KEYFILE )
  call KEYADDR          # ( KEYFILE KEYFILEADDR )
  store_                # ( KEYFILEADDR )
  # run interpreter
  call DOTASKS          # ( ? )
  # close keyfile
  call KEYFILEADDR      # ( KEYFILEADDR )
  fetch_                # ( KEYFILE )
  call CLOSEF           # ( ? )
  # pop tor into keyfile
  rpop_                 # ( KEYFILE ) ( R: itime fflags KEY )
  call KEYFILEADDR      # ( KEYFILE KEYFILEADDR )
  store_                # ( KEYFILEADDR )
  # pop top of return into defer key
  rpop_                 # ( KEY ) ( R: itime fflags )
  call KEYADDR          # ( KEY KEYADDR )
  store_                # ( KEYADDR )
  # restore FFLAGS
  rpop_                 # ( fflags ) ( R: itime )
  call FFLAGS           # ( fflags FFLAGS )
  call HSTORE           # ( FFLAGS )
  rpop_                 # ( itime ) ( R: )
  jmp IDLETIMESTORE

DOINCLUDE_EXIT:
  dpop_                 # ( filedes )
  type_ "File not found!"
  ret

# ( C:filepath -- ** )
# open a file that will be used for key input
Forthword_ INCLUDEF, 0, "include"
  # parse input for filename to include
  call PNAME     # ( addr len )
  # add null to end of string
  over_          # ( addr len addr )
  plus_          # ( addr addr' )
  zero_cstr_     # ( addr addr' )
  dpop_          # ( addr )
  jmp DOINCLUDE

# ( nx* -- ) (R: ny* -- )
# initialize rf further. EXECs turnkey operation and go to quit
Forthword_ DOCMDARG, 0, "docmdarg"
  call ARGCADDR      # ( ARGCADDR )
  fetch_             # ( ARGC )
  dpush_             
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

# ( -- )
# must be last word in core
Forthword_ WIPE, 0, "WIPE"
  dolit_ DPSTART
  dpush_
  call DPSHARP
  store_

  dolit_ CPSTART
  dpush_
  call CPSHARP
  store_

  dolit_ EE_FORTHWORDLIST
  zero_str_
  fourplus_
  zero_str_

  # init pause to noop
  dolit_ NOOP
  dpush_
  call PAUSEADDR
  store_

  dolit_ HERESTART
  dpush_
  call HEREADDR
  store_
  jmp ONLY
