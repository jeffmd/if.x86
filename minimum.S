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
  popnos_
  cmp %eax, %edx
  jge 1f
  mov %edx, %eax
1:
  ret

# ( n1 n2 -- n1|n2 )
# compare two values, leave the bigger one
Forthword_ MAX, 0, "max"
  popnos_
  cmp %eax, %edx
  jl 1f
  mov %edx, %eax
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
     dolit_ 28
     dolit_ '$
     call EMIT
PHEX_BEGIN:
     call TWOOVER
     rshift_
     call PNIB
     sub $4, %eax
     jne PHEX_BEGIN

  dropdup_
  call PNIB
  movl $32, %eax
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
  dupzerosense_
  jns 1f
  neg_
1:
  ret


# ( c -- (number|) flag )
# tries to convert a character to a number, set flag accordingly
Forthword_ DIGITQ, 0, "digit?"
    sub $0x30, %eax
    cmp $10, %eax
    jb DIGITQ0
    sub $7, %eax
    cmp $10, %eax
    jge DIGITQ0

    zerotos_
    ret

DIGITQ0:
    dup_
    call BASEFETCH
    call UGREATEREQUAL
    zerosense_
    je PFA_DIGITQ2
    zerotos_
    ret

PFA_DIGITQ2:
    true_
    ret

# (c -- ) Numeric IO
# R( -- )
# set the BASE value depending on the character
#forthword_ SETBASE, 0, "setbase"
SETBASE:        # ( c -- )
    mov %eax, %edx
    drop_
    cmp $'$, %edx
    jne PFA_SETBASE0
    jmp HEX

PFA_SETBASE0:
    cmp $'%, %edx
    jne PFA_SETBASE1
    jmp BIN

PFA_SETBASE1:
    cmp $'&, %edx
    jne PFA_SETBASE2
    jmp DECIMAL

PFA_SETBASE2:        # ( error)
    dup_
    mov %edx, %eax
    call EMIT
    $lit_ " Bad Base!"
    call THROW

# ( addr len -- addr' len' )
# skip a numeric prefix character
#forthword_ PRAEFIX, 0, "praefix"
PRAEFIX:        # ( adr1 len1 -- adr2 len2 )
    over_
    cfetch_
    cmp $0x30, %eax
    jb PFA_PRAEFIX0
    # no praefix
    drop_
    ret

PFA_PRAEFIX0:
    call SETBASE
    one_
    call SLASHSTRING
    ret

# (addr len -- addr len flag) Numeric IO
# check for - sign
# forthword_ NUMBERSIGN, 0, "#-"
NUMBERSIGN:        # ( addr len -- )
    over_          # ( addr len addr )
    cfetch_        # ( addr len char )
    cmp $'-, %eax
    je NUMBERSIGN_HASSIGN
        zerotos_
        ret

NUMBERSIGN_HASSIGN:
    to_r_
    one_
    call SLASHSTRING
    r_from_
    ret

# ( u1 c-addr1 len1 -- u2 c-addr2 len2 )
# convert a string to a number  c-addr2/u2 is the unconverted string
Forthword_ TO_NUMBER, 0, ">num"
TO_NUMBER_AGAIN:
  dupzerosense_
  je TO_NUMBER_END
        over_                # ( u adr len adr)
        cfetch_              # ( u adr len char)
        call DIGITQ          # ( u adr len digit flag)
      zerosense_
        jne TO_NUMBER_CONV
            # character is not a recognized number
            ret

TO_NUMBER_CONV:
  tob_                 # ( u adr len) B: digit
  rot_                 # ( adr len u)
  call BASEFETCH       # ( adr len u base)
  #bl STAR             # ( adr len u*base)
  mov %eax, %edx
  drop_
  imul %edx, %eax
  getb_                # ( adr len u' digit)
  plus_                # ( adr len u')
  rrot_                # ( u' adr len )
  one_
  call SLASHSTRING
  jmp TO_NUMBER_AGAIN

TO_NUMBER_END:
  ret

# (addr len -- [n] f)
# convert a string at addr to a number
Forthword_ NUMBER, 0, "num"
  call BASEFETCH
  to_r_                   # ( addr len ) (R: base)
  call NUMBERSIGN
  to_r_                   # ( addr len ) (R: base flagsign)
  call PRAEFIX
  call NUMBERSIGN         # ( addr len flagsign2 )
  r_from_                 # ( addr len flagsign2 flagsign ) (R: base )
  or_                     # ( addr len flagsign' )
  to_r_                   # ( addr len ) (R: base flagsign')
  zero_                   # ( addr len 0 ) starting value
  rrot_                   # ( 0 addr len )
  call TO_NUMBER          # ( n addr' len' )
  # check length of the remaining string.
  # if zero: a single cell number is entered
  zerosense_
  je PFA_NUMBER1

  # error in string to number conversion
PFA_NUMBER2:
  nip_                    # ( addr' )  (R: base flagsign' )
  r_drop_                 # ( addr' ) (R: base )
  zerotos_                # ( 0 ) (R: base )
  jmp PFA_NUMBER5

PFA_NUMBER1:
  drop_                   # ( n )  (R: base flagsign' )
  # incorporate sign into number
  r_from_                 # ( n flagsign' ) (R: base )
  zerosense_
  je PFA_NUMBER4
  neg_

PFA_NUMBER4:
  true_                   # ( n true ) (R: base )

PFA_NUMBER5:
  r_from_                 # ( n true base ) (R: )
  jmp BASESTORE           # ( n true )

# Multiply unsigned 32*32 = 64
# ( u u -- ud )
Forthword_ UMSTAR, 0, "um*"
  mov (%ebx), %ecx
  mul %ecx
  movl %edx, (%ebx)
  ret

# ( n n -- d)
# multiply 2 signed cells to a double cell
# signed 32*32 = 64
Forthword_ MSTAR, 0, "m*"
  mov (%ebx), %ecx
  imul %ecx
  movl %edx, (%ebx)
  ret

# ( ud u -- u u ) Dividend Divisor -- mod quotient
# 64/32 = 32 Rest 32
Forthword_ UM_DIVMOD, 0, "um/mod"
  mov %eax, %ecx
  movl 4(%ebx), %edx
  movl (%ebx), %eax
  nip_
  div %ecx
  movl %edx, (%ebx)
  ret

# ( u1 u2 -- rem quot )
# unsigned 32b division with modulus result
Forthword_ U_DIVMOD, 0, "u/mod"
  movl %eax, %ecx
  movl (%eax), %eax
  cltd
  div %ecx
  movl %edx, (%ebx)
  ret

Forthword_ M_DIVMOD, 0, "m/mod"
# Signed symmetric divide 64/32 = 32 remainder 32
# ( d n -- n n )
  movl %eax, %ecx
  movl 4(%ebx), %edx
  movl (%ebx), %eax
  nip_
  idiv %ecx
  movl %edx, 4(%ebx)
  ret

# ( n1 n2 -- rem quot )
# signed division with remainder
Forthword_ DIVMOD, 0, "/mod"
  movl %eax, %ecx
  movl (%ebx), %eax
  cltd
  idiv %ecx
  movl %edx, (%ebx)
  ret

# ( n1 n2 -- n1/n2 )
# 32bit/32bit = 32bit
Forthword_ DIV, 0, "/"
  movl %eax, %ecx
  movl (%ebx), %eax
  cltd
  nip_
  idiv %ecx
  ret

# ( -- addr)
# start address of return stack
Forthword_ RP0, 0, "rp0"
  douser_ rstack0

# ( -- n )
# number of single-cell (4 byte) values contained in the data stack before n was placed on the stack.
Forthword_ DEPTH, 0, "depth"
  call SP0
  spfetch_
  minus_
  fourslash_
  # acount for value push on data stack
  oneminus_
  ret

# ( --  )
# check stack underflow, throw exception -4
Forthword_ QSTACK, 0, "?sp"
  call DEPTH
  zeroless_
  zerosense_
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
    spfetch_            # ( xt SP )
    to_r_               # ( xt ) (R: ret -- callerret SP )
    # handler @ >r
    call HANDLER        # ( xt haddr )
    fetch_              # ( xt hxt )
    to_r_               # ( xt ) (R: callerret SP hxt )
    # rp@ handler !
    rpfetch_            # ( xt RP ) (R: callerret SP hxt)
    call HANDLER        # ( xt RP haddr )
      store_              # ( xt )
      call EXEC
    # restore handler
    # r> handler !
    r_from_             # ( hxt ) (R: callerret SP )
    call HANDLER        # ( hxt haddr )
      store_              # ( )
      r_drop_             # ( ) (R: callerret)
      zero_
      ret

# ( straddr len -- )
# throw an exception
# will type the string passed in
Forthword_ THROW, 0, "throw"
  call TYPE
  call HANDLER       # ( haddr )
  fetch_             # ( RP_handler )
  rpstore_           # ( ) (R: callerret SP hxt)
  r_from_            # ( hxt ) (R: callerret SP )
  call HANDLER       # ( hxt haddr )
  store_             # ( )
  r_from_            # ( SP ) (R: callerret )
  spstore_           # ( ... )
  one_               # ( ... 1 )
  ret

# ( n -- )
# sleep for n micro seconds
Forthword_ USLEEP, 0, "usleep"
  push %eax
  call usleep
  pop %edx
  drop_
  ret

# ( -- )
# sleep for n micro seconds
Forthword_ SLEEP, 0, "sleep"
  call IDLETIMEFETCH
  dupzerosense_
  je NO_IDLESLEEP
  jmp USLEEP
NO_IDLESLEEP:
  drop_
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
    zero_
    call OPENF     # ( filedes )
    # if file descriptor > 0 then open is success
    dup_
    call ZEROGREATER
    zerosense_

    je DOINCLUDE_EXIT
      call IDLETIMEFETCH
      to_r_
      call SLEEPOFF
        # push FFLAGS on tor
        call FFLAGS
        hfetch_
        to_r_
        # push on return stack the old defer key
        call KEYADDR
        fetch_
        to_r_
        # push old keyfile on return stack
        call KEYFILEADDR
        fetch_
        to_r_
        call KEYFILEADDR
        store_
        # defer key to keyfile for input
      dolit_ KEYFILE
        call KEYADDR
        store_
        # run interpreter
        call DOTASKS
        # close keyfile
        call KEYFILEADDR
        fetch_
        call CLOSEF
        # pop tor into keyfile
        r_from_
        call KEYFILEADDR
        store_
        # pop top of return into defer key
        r_from_
        call KEYADDR
        store_
        # restore FFLAGS
        r_from_
        call FFLAGS
        call HSTORE
        r_from_
        jmp IDLETIMESTORE

DOINCLUDE_EXIT:
    drop_
    type_ "File not found!"
    ret

# ( C:filepath -- ** )
# open a file that will be used for key input
Forthword_ INCLUDEF, 0, "include"
    # parse input for filename to include
    call PNAME     # ( addr len )
    # add null to end of string
    over_
    plus_
    call ZEROCSTORE
    jmp DOINCLUDE

# ( nx* -- ) (R: ny* -- )
# initialize rf further. EXECs turnkey operation and go to quit
Forthword_ DOCMDARG, 0, "docmdarg"
    call ARGCADDR
    fetch_
    one_
    call GREATER
    zerosense_
    je DOCMDARG_EXIT

    call ARGVADDR
    fetch_
    fourplus_
    fetch_
    jmp DOINCLUDE

DOCMDARG_EXIT:
    ret

# ( -- )
# must be last word in core
Forthword_ WIPE, 0, "WIPE"
  dolit_ DPSTART
  call DPSHARP
  store_

  dolit_ CPSTART
  call CPSHARP
  store_

  dolit_ EE_FORTHWORDLIST
  dup_
  zerostore_
    fourplus_
    zerostore_

     # init pause to noop
  dolit_ NOOP
  call PAUSEADDR
  store_

  dolit_ HERESTART
  call HEREADDR
  store_
  jmp ONLY
