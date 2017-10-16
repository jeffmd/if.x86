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
  cmp %ebx, %edx 
  jge 1f
  mov %edx, %ebx
1:
  ret

# ( n1 n2 -- n1|n2 )
# compare two values, leave the bigger one
Forthword_ MAX, 0, "max"
  popnos_
  cmp %ebx, %edx
  jl 1f
  mov %edx, %ebx
1:
  ret

# ( val -- char )
# convert low byte of val to a printable hex character
Forthword_ NHEX, 0, "#h"
    and $0x0f, %ebx
    cmp $10, %ebx
    jl NHEX_NEXT
    add $7, %ebx

NHEX_NEXT:
    add $48, %ebx
    ret

# ( n -- )
# simple 4 bit hex print
Forthword_ PNIB, 0, ".h"
    call NHEX
    jmp EMIT

# ( n -- )
# simple 32 bit hex print
Forthword_ PHEX, 0, ".$"
    dolit_ '$
    call EMIT
    dolit_ 28
PHEX_BEGIN:
    call TWOOVER
    rshift_
    call PNIB
    sub $4, %ebx
    jne PHEX_BEGIN

    drop_
    dup_
    call PNIB
    movl $32, %ebx
    jmp EMIT


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
    call STORE          # ( xt )
    call EXEC
    # restore handler
    # r> handler !
    r_from_             # ( hxt ) (R: callerret SP )
    call HANDLER        # ( hxt haddr )
    call STORE          # ( )
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
    call STORE         # ( )
    r_from_            # ( SP ) (R: callerret )
    spstore_           # ( ... )
    one_               # ( ... 1 )
    ret


# ( -- )
# must be last word in core
Forthword_ WIPE, 0, "WIPE"
	dolit_ DPSTART
	call DPSHARP
	call STORE
	
	dolit_ EE_FORTHWORDLIST
	dup_
	call ZEROSTORE
	fourplus_
	call ZEROSTORE
	
	# init pause to noop
	dolit_ NOOP
	call PAUSEADDR
	call STORE
	
	dolit_ HERESTART
	call HEREADDR
	call STORE
	jmp ONLY    
