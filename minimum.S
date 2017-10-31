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
  datastack_
  two_
  datastack_
  jmp BASESTORE


# ( -- )
# set base for numeric conversion to 10
Forthword_ DECIMAL, 0, "decimal"
  datastack_
  ten_
  datastack_
  jmp BASESTORE

# ( -- )
# set base for number conversion to 16
Forthword_ HEX, 0, "hex"
  datastack_
  dolit_ 16
  datastack_
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
    jb NHEX_NEXT
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
  datastack_
	 dolit_ 28
	 dolit_ '$
  datastack_
	 call EMIT
PHEX_BEGIN:
	 call TWOOVER
	 rshift_
	 call PNIB
	 sub $4, %ebx
	 jne PHEX_BEGIN
	
  dropdup_
  call PNIB
  movl $32, %ebx
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

# ( c -- (number|) flag )
# tries to convert a character to a number, set flag accordingly
Forthword_ DIGITQ, 0, "digit?"
	sub $0x30, %ebx
	cmp $10, %ebx
	jb DIGITQ0
	sub $7, %ebx
	cmp $10, %ebx
	jge DIGITQ0

	zerotos_
	ret

DIGITQ0:
  datastack_
	dup_
  datastack_
	call BASEFETCH
	call UGREATEREQUAL
  datastack_
	zerosense_
  datastack_
	je PFA_DIGITQ2
	zerotos_
	ret

PFA_DIGITQ2:
  datastack_
	true_
  datastack_
	ret

# (c -- ) Numeric IO
# R( -- )
# set the BASE value depending on the character
#forthword_ SETBASE, 0, "setbase"
SETBASE:        # ( c -- )
	mov %ebx, %edx
  datastack_
	drop_
  datastack_
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
  datastack_
	dup_
  datastack_
	mov %edx, %ebx
	call EMIT
	$lit_ " Bad Base!"
	call THROW

# ( addr len -- addr' len' )
# skip a numeric prefix character
#forthword_ PRAEFIX, 0, "praefix"
PRAEFIX:        # ( adr1 len1 -- adr2 len2 )
  datastack_
	over_
  datastack_
	cfetch_
	cmp $0x30, %ebx
	jb PFA_PRAEFIX0
	# no praefix
  datastack_
	drop_
  datastack_
	ret

PFA_PRAEFIX0:
 	call SETBASE
  datastack_
 	one_
  datastack_
 	call SLASHSTRING
 	ret

# (addr len -- addr len flag) Numeric IO
# check for - sign
# forthword_ NUMBERSIGN, 0, "#-"
NUMBERSIGN:        # ( addr len -- )
  datastack_
	over_          # ( addr len addr )
  datastack_
	cfetch_        # ( addr len char )
	cmp $'-, %ebx
	je NUMBERSIGN_HASSIGN
		zerotos_
		ret

NUMBERSIGN_HASSIGN:
	to_r_
  datastack_
	one_
  datastack_
	call SLASHSTRING
	r_from_
	ret

# ( u1 c-addr1 len1 -- u2 c-addr2 len2 )
# convert a string to a number  c-addr2/u2 is the unconverted string
Forthword_ TO_NUMBER, 0, ">num"
TO_NUMBER_AGAIN:
  dupzerosense_
  je TO_NUMBER_END
    datastack_
		over_                # ( u adr len adr)
    datastack_
		cfetch_              # ( u adr len char)
		call DIGITQ          # ( u adr len digit flag)
    datastack_
	  zerosense_
    datastack_
		jne TO_NUMBER_CONV
			# character is not a recognized number
			ret

TO_NUMBER_CONV:
  datastack_
  tob_                 # ( u adr len) B: digit
  datastack_
  rot_                 # ( adr len u)
  call BASEFETCH       # ( adr len u base)
  #bl STAR             # ( adr len u*base)
  mov %ebx, %edx
  datastack_
  poptos_
  datastack_
  imul %edx, %ebx
  datastack_
  getb_                # ( adr len u' digit)
  plus_                # ( adr len u')
  datastack_
  rrot_                # ( u' adr len )
  datastack_
  one_
  datastack_
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
  datastack_
  or_                     # ( addr len flagsign' )
  datastack_
  to_r_                   # ( addr len ) (R: base flagsign')
  datastack_
  zero_                   # ( addr len 0 ) starting value
  datastack_
  rrot_                   # ( 0 addr len )
  call TO_NUMBER          # ( n addr' len' )
  # check length of the remaining string.
  # if zero: a single cell number is entered
  datastack_
  zerosense_
  datastack_
  je PFA_NUMBER1

  # error in string to number conversion
PFA_NUMBER2:
  nip_                    # ( addr' )  (R: base flagsign' )
  r_drop_                 # ( addr' ) (R: base )
  zerotos_                # ( 0 ) (R: base )
  jmp PFA_NUMBER5

PFA_NUMBER1:
  datastack_
  drop_                   # ( n )  (R: base flagsign' )
  datastack_
  # incorporate sign into number
  r_from_                 # ( n flagsign' ) (R: base )
  datastack_
  zerosense_
  datastack_
  je PFA_NUMBER4
  neg_

PFA_NUMBER4:
  datastack_
  true_                   # ( n true ) (R: base )
  datastack_

PFA_NUMBER5:
  r_from_                 # ( n true base ) (R: )
  jmp BASESTORE           # ( n true )



# ( -- addr)
# start address of return stack
Forthword_ RP0, 0, "rp0"
  douser_ rstack0

# ( -- n )
# number of single-cell (4 byte) values contained in the data stack before n was placed on the stack.
Forthword_ DEPTH, 0, "depth"
  call SP0
  spfetch_
  datastack_
  minus_
  datastack_
  fourslash_
  # acount for value push on data stack
  oneminus_
  ret

# ( --  )
# check stack underflow, throw exception -4
Forthword_ QSTACK, 0, "?sp"
  call DEPTH
  zeroless_
  datastack_
  zerosense_
  datastack_
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
    datastack_
    store_              # ( xt )
    datastack_
    call EXEC
    # restore handler
    # r> handler !
    r_from_             # ( hxt ) (R: callerret SP )
    call HANDLER        # ( hxt haddr )
    datastack_
    store_              # ( )
    datastack_
    r_drop_             # ( ) (R: callerret)
    datastack_
    zero_
    datastack_
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
  datastack_
  store_             # ( )
  datastack_
  r_from_            # ( SP ) (R: callerret )
  spstore_           # ( ... )
  datastack_
  one_               # ( ... 1 )
  datastack_
  ret

# ( n -- )
# sleep for n micro seconds
Forthword_ USLEEP, 0, "usleep"
  push %eax
  push %ebx
  call usleep
  pop %edx
  pop %eax
  datastack_
  poptos_
  datastack_
  ret

# ( -- )
# sleep for n micro seconds
Forthword_ SLEEP, 0, "sleep"
  call IDLETIMEFETCH
  dupzerosense_
  je NO_IDLESLEEP
  jmp USLEEP
NO_IDLESLEEP:
  datastack_
  drop_
  datastack_
  ret

# ( -- )
# turn sleep off
Forthword_ SLEEPOFF, 0, "sleepoff"
  datastack_
  zero_
  datastack_
  jmp IDLETIMESTORE
 
# ( -- )
# turn sleep on
Forthword_ SLEEPON, 0, "sleepon"
  datastack_
  dolit_ 5000
  datastack_
  jmp IDLETIMESTORE
 

# ( caddr -- ** )
# open a file that will be used for key input
# caddr points to null terminated file name
Forthword_ DOINCLUDE, 0, "doinclude"
	# set file open mode to reading
  datastack_
	zero_
  datastack_
	call OPENF     # ( filedes )
	# if file descriptor > 0 then open is success
  datastack_
	dup_
  datastack_
	call ZEROGREATER
  datastack_
	zerosense_
  datastack_
	
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
    datastack_
		store_
    datastack_
		# defer key to keyfile for input
    datastack_
    dolit_ KEYFILE
    datastack_
		call KEYADDR
    datastack_
		store_
    datastack_
		# run interpreter
		call DOTASKS
		# close keyfile
		call KEYFILEADDR
		fetch_
		call CLOSEF
		# pop tor into keyfile
		r_from_
		call KEYFILEADDR
    datastack_
		store_
    datastack_
		# pop top of return into defer key
		r_from_
		call KEYADDR
    datastack_
		store_
    datastack_
		# restore FFLAGS
		r_from_
		call FFLAGS
		call HSTORE
		r_from_
		jmp IDLETIMESTORE
		 
DOINCLUDE_EXIT:
  datastack_
	drop_
  datastack_
	type_ "File not found!"
	ret

# ( C:filepath -- ** )
# open a file that will be used for key input
Forthword_ INCLUDEF, 0, "include"
	# parse input for filename to include
	call PNAME     # ( addr len )
	# add null to end of string
  datastack_
	over_         
	plus_
  datastack_
	call ZEROCSTORE
	jmp DOINCLUDE

# ( -- )
# must be last word in core
Forthword_ WIPE, 0, "WIPE"
  datastack_
  dolit_ DPSTART
  datastack_
 	call DPSHARP
  datastack_
  store_
	
  dolit_ CPSTART
  datastack_
	call CPSHARP
  datastack_
  store_

  dolit_ EE_FORTHWORDLIST
	dup_
  zerostore_
	fourplus_
	zerostore_
	
	 # init pause to noop
  dolit_ NOOP
  datastack_
  call PAUSEADDR
  datastack_
  store_
	
  dolit_ HERESTART
  datastack_
	call HEREADDR
  datastack_
  store_
  datastack_
  jmp ONLY    
