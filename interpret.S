# interpret.S

# ( -- addr )
# flags address
Forthword_ FFLAGS, 0, "fflags"
    douser_  fflags
    .set TERMINATE_F, 1
    # bit 0 - Terminate Tasks

# ( -- addr )
# terminal input buffer address
Forthword_ TIB, 0, "tib"
    douser_  ram_tib

# ( -- addr-half )
# variable holding the number of characters in TIB
# is half cell size
Forthword_ SHARPTIB, 0, "#tib"
    douser_ ram_sharptib

# ( -- addr len )
# address and current length of the input buffer
Forthword_ STIB, 0, "stib"
    call TIB
    call SHARPTIB
    hfetch_
    ret

# ( -- a-addr )
# index to current read position in input buffer
# is half cell size
Forthword_ G_IN, 0, ">in"
    douser_ user_g_in

# ( -- pauseaddr )
# get ram address of pause defer
Forthword_ PAUSEADDR, 0, "pause#"
    douser_ USER_PAUSE

# ( -- keyaddr )
# get ram address of key defer
Forthword_ KEYADDR, 0, "key#"
    douser_ USER_KEY

# ( -- emitaddr )
# get ram address of emit defer
Forthword_ EMITADDR, 0, "emit#"
    douser_ USER_EMIT

# ( -- keyfileaddr )
# get ram address of key file descriptor
Forthword_ KEYFILEADDR, 0, "keyf#"
    douser_ USER_KEYFILE

# ( -- argcaddr )
# get ram address of command line argument count
Forthword_ ARGCADDR, 0, "argc#"
    douser_ USER_ARGC

# ( -- cmd[]addr )
# get ram address of command line argument vector
Forthword_ ARGVADDR, 0, "argv#"
    douser_ USER_ARGV

# ( c -- )
# fetch the emit vector and EXEC it. Will emit a character from TOS
Forthword_ PUTCHAR, 0, "putchar"
  push %eax
  push %ebx
  call putchar
  pop %edx
  pop %eax
  poptos_
  ret

# ( c -- )
# fetch the emit vector and EXEC it. Will emit a character from TOS
Forthword_ EMIT, 0, "emit"
  call EMITADDR
  fetch_
  jmp EXEC


# ( -- )
# cause subsequent output appear at the beginning of the next line
Forthword_ CR, 0, "cr"
  ten_
  dolit_ 13
  call EMIT
  jmp EMIT

# ( -- 32 )
# put ascii code of the blank/space character to the stack
Forthword_ BL, 0, "bl"
  bl_
  ret

# ( -- key )
# fetch key from standard input, should leave a single character on TOS
# if a key was pressed. If no key pressed then -1 is on TOS.
Forthword_ STDIN, 0, "stdin"
  pushtos_
  push %eax
  call getchar
  movl %eax, %ebx
  pop %eax
  ret

# ( -- key )
# fetch key from an open file using filedes, should leave
# a single character on TOS or -1 if no more to read in file.
Forthword_ KEYFILE, 0, "keyfile"
  zero_                    # ( 0 )
  call KEYFILEADDR         # ( 0 keyfile# )
  fetch_                   # ( 0 filedes )
  pushtos_                 # ( 0 filedes ? )
  leal 4(%eax), %ebx       # ( 0 filedes eax+4 
  one_                     # ( 0 filedes eax+4 1 )
  call READF               # ( key count )
  # was one key read from the file?
  one_                     # ( key count 1 )
  call EQUAL               # ( key flag )
  zerosense_               # ( key )
  jne KEYEND
  sub $1, %ebx
  jmp BYE  
 KEYEND:
  ret

# ( -- key )
# fetch key from deffered routine, should leave a single character
# on TOS if a key was pressed. If no key pressed then -1 is on TOS.
Forthword_ KEY, 0, "key"
  call KEYADDR
  fetch_
  jmp EXEC

# ( -- f )
# refills the input buffer
Forthword_ REFILL, 0, "refill"
  jmp REFILLTIB
  
# ( addr n -- )
# print a counted string
Forthword_ TYPE, 0, "type"
	niptoa_           # Address of string
	dupzerosense_
	jz TYPE_END
	
TYPE1:
	acfetch_
	acplus_
	call EMIT
	oneminus_
	
TYPE2:
	jnz TYPE1

TYPE_END:	
	drop_
	ret


# ( r-addr r-len f-addr f-len --  f)
# compares two counted strings in RAM
# flag is true if strings match
Forthword_ MCMP, 0, "mcmp"
  tob_                     # ( r-addr r-len f-addr)  B: f-len
  over_                    # ( r-addr r-len f-addr r-len)
  # check if strings are same length
  xor %edi, %ebx           # ( r-addr r-len f-addr flag )
  # if
  zerosense_               # ( r-addr r-len f-addr )
  je CMPSB

  # strings are not the same length
  dnip_
  zerotos_                 # ( 0 )
  ret
  # then

# ( r-addr r-len f-addr -- flag)
# compare two strings of same length
# flag is true if strings match
Forthword_ CMPSB, 0, "cmpsb"
  toa_                     # ( r-addr len ) A: f-addr
  movl %ebx, %ecx          # ( r-addr ) CX: len
  poptos_
  tob_                     # ( ) B: r-addr
  cld
  repe cmpsb
  # while
  je MCMP_DONE

  # strings don't match
  zero_                 # ( 0 )
  ret

MCMP_DONE:
  # strings are the same
  true_
  ret

  
# ( addr1 u1 n -- addr2 u2 )
# adjust string from addr1 to addr1+n, reduce length from u1 to u2 by n
Forthword_ SLASHSTRING, 0, "/$"
	over_         # ( -- addr1 u1 n u1 )
	call MIN      # ( -- addr1 u1 n|u1 )
	rot_          # ( -- u1 n addr1 )
	over_         # ( -- u1 n addr1 n )
	plus_         # ( -- u1 n addr2 )
	rrot_         # ( -- addr2 u1 n )
	minus_        # ( -- addr2 u2)
	ret

# ( addr -- addr+2 n )
# get string address and length information out of a counted string
Forthword_ STRINGLEN, 0, "$l"
	dup_
	twoplus_
	swap_
	hfetch_
	ret

# ( addr1 n1 c -- n2 )
# skips leading occurances in string at addr1 leaving n2 as an index
# pointing to the 1st non-c character
# n1 is max number of characters to search
Forthword_ CSKIP, 0, "cskip"
	tob_                 # ( addr1 n1 ) B: c
	niptoa_              # ( n1 ) A: addr1
	dup_                 # ( n1 n1 )
PFA_CSKIP1:
	dupzerosense_        # ( n1 n')
	je PFA_CSKIP2
	acfetch_             # ( n1 n' c' )
	acplus_
	cmp %edi, %ebx       # ( n1 n' c' )
	drop_                # ( n1 n' )
	jne PFA_CSKIP2
	oneminus_
	jmp PFA_CSKIP1

PFA_CSKIP2:
	minus_               # ( n1-n' )
	ret

# ( addr1 n1 c -- addr1 n2 )
# Scan string at addr1 for the first occurance of c, leaving addr1 n2,
# n1 is max number of characters to search
# char at n2 is first c character
Forthword_ CSCAN, 0, "cscan"
	tob_                 # ( addr1 n1 ) B: c
	over_                # ( addr1 n1 addr1 )
	toa_                 # ( addr1 n1 ) A: addr1
	dup_                 # ( addr1 n1 n1 )
PFA_CSCAN1:
	dupzerosense_        # ( addr1 n1 n')
	je PFA_CSCAN2
	acfetch_             # ( addr1 n1 n' c' )
	acplus_
	cmp %edi, %ebx       # ( addr1 n1 n' c' )
	drop_                # ( addr1 n1 n' )
	je PFA_CSCAN2
	oneminus_
	jmp PFA_CSCAN1

PFA_CSCAN2:
	minus_               # ( addr1 n1-n' )
	ret

# ( -- srcaddr len  )
# Adjust the source addr using >in.
Forthword_ SRCIN, 0, "srcin"
	call STIB           # ( srcaddr len )
	call G_IN           # ( srcaddr len ginaddr )
	hfetch_             # ( srcaddr len gin)
	jmp SLASHSTRING     # ( srcaddr' len' )

# ( -- )
# skip space in input source.
Forthword_ SKIPBL, 0, "skipbl"
	call SRCIN          # ( srcaddr len )
	bl_                 # ( srcaddr' len' c )
	call CSKIP          # ( n2 )

	# adjust >IN
	call G_IN           # ( n2 ginaddr )
	jmp PLUSHSTORE      # (  )

# ( char "ccc<char>" -- c-addr u )
# in input buffer parse ccc delimited string by the delimiter char.
Forthword_ PARSE, 0, "parse"
	call SRCIN         # ( -- c addr len)
	rot_               # ( -- addr' len' c)
	call CSCAN         # ( -- len'')
	dup_               # ( -- addr' len'' len'')
	oneplus_           # ( -- addr' len'' len''+1 )
	call G_IN          # ( -- addr' len'' len''+1 >in)
	jmp PLUSHSTORE     # ( -- addr' len'')

# ( "<name>" -- c-addr len )
# In the SOURCE buffer parse whitespace delimited string. Returns string address within SOURCE.
Forthword_ PNAME, 0, "pname"
	call SKIPBL
	bl_
	jmp PARSE

# ( c-addr len wid -- [ 0 | nfa ] )
# find a word in the dictionary
# 0 if word not found in dictionary
# nfa if word is found
Forthword_ FINDNFA, 0, "findnfa"
	dupzerosense_
	jne FINDNFA_
		# terminating, wid is empty
		dnip_
		ret
		
FINDNFA_:
	fetch_                      # ( c-addr len nfa )

	# <begin>
FINDNFA_BEGIN:
	# <while>
	dupzerosense_               # ( c-addr len nfa )
	jne FINDNFA_CHECK
		# terminating, 0 found
		dnip_                     # ( 0 )
		ret

FINDNFA_CHECK:
	to_r_                       # ( c-addr len ) (R: nfa )
	call TWOOVER                # ( c-addr len c-addr len )
	r_fetch_                    # ( c-addr len c-addr len nfa )
	call STRINGLEN              # ( c-addr len c-addr len f-addr len )
	and $31, %ebx               # ( c-addr len c-addr len f-addr 0:len )
	call MCMP                   # ( c-addr len flag )
	# <if>
	zerosense_
	je FINDNFA_NEXT
		# we found the string
		ddrop_                    # ( )
		r_from_                   # ( nfa )
		ret
	# <then>
FINDNFA_NEXT:
		# next try
		r_from_
		call NFA2LFA
		fetch_
		# <repeat>
		jmp FINDNFA_BEGIN

# ( addr len --  0 | nfa )
# search root wordlists for the name from string addr/len
Forthword_ FINDROOT, 0, "froot"
	# put root wid on stack
	dolit_ VE_COLD
	jmp FINDNFA_BEGIN

# ( addr len idx -- 0 | nfa )
FINDWI:
  fourstar_          # ( addr len idx*4)
  call CONTEXT       # ( addr len idx*4 context )
  plus_              # ( addr len context' )
  fetch_             # ( addr len wid )
  jmp FINDNFA        # ( nfa)

FINDLAST:
  drop_
  jmp FINDROOT

# ( addr len --  0 | nfa )
# search wordlists for the name from string addr/len
Forthword_ FINDW, 0, "findw"
	# loop through context slots to find a word
	# start with last slot
	call CONTEXT        # ( addr len context )
	# get context index and use as counter
	twominus_           # ( addr len context-2 )
	hfetch_             # ( addr len idx )
FINDW_BEGIN:
	dupzerosense_
	js FINDLAST         # ( addr len idx )
		to_r_             # ( addr len ) ( R: idx )
		call TWOOVER      # ( addr len addr len ) ( R: idx )
		# get next wordlist in array
		r_fetch_          # ( addr len addr len idx ) ( R: idx)
		call FINDWI
		r_from_           # ( addr len nfa idx ) ( R: )
		swap_             # ( addr len idx nfa )
		dupzerosense_
		# end loop if word found
		je FINDW_NEXT
			dnip_           # ( addr nfa )
			nip_            # ( nfa )
			ret

FINDW_NEXT:
  drop_             # ( addr len idx )
  # decrement index
	oneminus_         # ( addr len idx-1 )
	jmp FINDW_BEGIN

# ( -- addr len )
# runtime portion of sliteral
# string literal is located starting at return cell
# return cell is string length
# string then occupies the following cells: c2c1 c4c3 ...
Forthword_ DOSLIT, 0, "(slit)"
  # get return address to get string length, calculate string address start,
  # and calculate return address
  pushtos_
  pop %ebx       # ( raddr )  (R: raddr -- )
  dup_           # ( raddr raddr )
  # get the string length
  hfetch_        # ( raddr slength )
  over_          # ( raddr slength raddr )
  # calculate string address
  twoplus_       # ( raddr slength straddr )
  # calculate the number of words to skip over for return address
  flip_          # ( straddr slength raddr )
  over_          # ( straddr slength raddr slength)
  plus_          # ( straddr slength raddr+slength )
  # also skip string length
  twoplus_       # ( straddr slength raddr+k+2 )
  push %ebx      
  poptos_
  ret

# ( addr len -- [n] [addr len] f )
# recognizer for integer numbers
Forthword_ REC_NUM, 0, "rec#"
	calll TWOOVER
	to_r_
	to_r_
	# try converting to a number
	call NUMBER              # ( [n] f )
	zerosense_
	je REC_NONUMBER

		call STATEFETCH        # ( n state )
  		zerosense_
  		je REC_NUMBER_OK
			call LIT

REC_NUMBER_OK:
		r_drop_
		r_drop_
  		true_                # ( n true )
  		ret

REC_NONUMBER:
	r_from_
	r_from_
	zero_                  # ( 0 )
	ret

# ( addr len -- ** [addr len] f )
# recognize a word in the dictionary
Forthword_ REC_WORD, 0, "recw"
	call TWOOVER
	to_r_
	to_r_
	call FINDW
	dupzerosense_
	jne REC_WORD_FOUND
		r_from_
		r_from_
		rot_
		ret

REC_WORD_FOUND:
	r_drop_
	r_drop_
	call NFATOXTF
	# check if compile only word
	#sbrc tosh, COMPILE_ONLY_FB
	#    rjmp CHECK_IMMEDIATE

CHECK_COMPILE_ONLY:
#    bl STATEFETCH
#    zerosense_
#    bne.n CHECK_IMMEDIATE
        # word can only be used in compile state
        #jmp THROW


CHECK_IMMEDIATE:
  # either compile or EXEC the XT
    # check if word is immediate: bit 15 is clear if immediate
  #sbrs tosh, IMMEDIATE_EN_FB @ skip next instruction if bit 7 is set: not immediate word
  mov  $IMMEDIATE_EN, %edx
  rol $8, %edx
  test %edx, %ebx
  # flag is 0: always EXEC
  je REC_WORD_EXECUTE

REC_WORD_CHECKSTATE:
      # check state
    call STATEFETCH
      zerosense_
      je REC_WORD_EXECUTE
      # in compile mode so compile xt
    call COMPILEXT
      true_
      ret

REC_WORD_EXECUTE:
  drop_
  # state is zero, EXEC xt
  call EXEC
  true_
  ret

# ( addr len -- )
# recognize and execute name of word in ram using recognizer list.
Forthword_ RECX, 0, "recx"
	# test if its a word
	call REC_WORD         # ( addr len flag )
	#zero_# <if>
	zerosense_            # ( addr len )
	jne RECX_DONE
	# test if its a number
	call REC_NUM          # ( addr len flag )
	zerosense_            # ( addr len )
	jne RECX_DONE
	# not recognized so throw
	call CR
	# print unrecognized word
	call TYPE
	
	$lit_ " Unknown!"
	call THROW

RECX_DONE:
	ret

# ( -- ) (R: i*x - j*x )
# interpret input word by word.
Forthword_ INTERPRET, 0, "interp"
INTERPRET_DO:
	# begin
	call PNAME            # ( -- addr len )

	# ?while
	dupzerosense_         # ( -- addr len )
	je INTERPRET_END

	call RECX             # ( )
	call QSTACK           # ( )

	# repeat
	jmp INTERPRET_DO

INTERPRET_END:
	ddrop_
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
	drop_
	type_ " ?? "
	ret

# ( -- )
# check if a ready prompt is required
Forthword_ QP_RD, 0, "?prd"
  call STATEFETCH
  # output ready prompt if in interpret mode
  # <-if>
  zerosense_
  jne QP_RD_exit
    jmp PROMPTRDY

QP_RD_exit:
  # <then>
  jmp PROMPTCOMPILE

# ( -- )
# Reset the input buffer
Forthword_ INRESET, 0, "in_"
  call G_IN                # ( >inaddr )
  call ZEROHSTORE          # (  )
  # reset input buffer cursor position
  call SHARPTIB            # ( #tibaddr )
  call ZEROHSTORE          # ( )
  jmp QP_RD

# ( -- flag)
# fill up the input buffer some more
# flag is true if input buffer is full or needs processing
Forthword_ DOREFILL, 0, "(refill)"
  # if just starting new input line then check prompt and reset input position
  call G_IN                # ( >inaddr )
  hfetch_                  # ( >in )
  zerosense_               # ( )
  je DOREFILL_do
    call INRESET

DOREFILL_do:
  # refill the input buffer
  call REFILL              # ( f )
  ret

# ( -- )
# interpret what is in the input buffer
Forthword_ DOINTERPRET, 0, "(interp)"
  # input buffer has something so try to interpret it
  # setup exception handling in case of error
  dolit_ INTERPRET
  call CATCH
  # check to make sure no throws
  call QDUP
  # <if>
  zerosense_
  je DOINTERPRET_ok
    call PROMPTERROR
    call QUIT

  # <then>
DOINTERPRET_ok:
  # make sure in buf pointer is not at zero
  call G_IN               # ( 1 >inaddr )
  call ONEPLUSHSTORE        # ( )
  jmp PROMPTOK


# ( -- )
# set terminate flag which indicates request to exit forth interpreter
Forthword_ BYE, 0, "bye"
	one_
	call FFLAGS
	hfetch_
	or_
	call FFLAGS
	jmp HSTORE

# ( -- )
# Fetch pause vector and EXEC it. may make a context/task switch
Forthword_ DOPAUSE, 0, "(pause)"
    call SLEEP ## temp fix for cpu hogging
    call PAUSEADDR
    fetch_
    jmp EXEC

# ( -- )
# main loop - iterate through scheduled tasks
Forthword_ DOTASKS, 0, "(tasks)"
	# <begin>
DOTASKS1:
	call DOREFILL     # ( flag )
  zerosense_
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
	je DOTASKS1
	ret

# ( -- )
# reset input source
Forthword_ RESET, 0, "reset"
  call SMUDGE
  zerostore_

  # reset input source for key
  dolit_ STDIN
  call KEYADDR
  store_

  # reset output source for emit
  dolit_ PUTCHAR
  call EMITADDR
  store_

  # reset input buffer
  call INRESET
  
  call SLEEPON

  # switch to interpret mode
  jmp LBRACKET

# ( -- )
# reset stacks and start over again
Forthword_ QUIT, 0, "quit"
	# reset data stack
	call SP0
	spstore_
	# reset return stack pointers
	call RP0
	fetch_
	rpstore_
	call RESET
	jmp DOTASKS


# ( -- flag )
# receive a string of at most tibsize characters or cr/lf detected.
# flag will be true if input buffer needs to be processed ie interpreted
# flag will be false if more input needed
Forthword_ ACCEPT, 0, "accept"
  # <begin>
  call KEY        # ( k )
  dupzerosense_
  jg ACCEPT_checkeol
  addl $1, %ebx
  ret

ACCEPT_checkeol:
  # check for EOL
  cmp $10, %ebx
  # <if>
  jne ACCEPT_checkreturn
  ret

ACCEPT_checkreturn:
  cmp $13, %ebx     # ( k k 13 )
  # <if>
  jne ACCEPT_checkdelete
  ret

ACCEPT_checkdelete:
  # check delete
  cmp $127, %ebx     # ( k k 8 )
  # <if>
  jne ACCEPT_checkcontrol
  # delete previous character
  # check beginning of line
  # if cursor is 0 then at begining of input
  call SHARPTIB
  hfetch_           # ( k #tib )
  # <if>
  zerosense_        # ( k )
  jne ACCEPT_dodelete
  # at the beginning of the line, ignore this character
  drop_
  jmp ZERO

ACCEPT_dodelete:
  andl $8, %ebx
  dup_                # ( k k )
  call EMIT           # ( k )
  bl_                 # ( k bl )
  call EMIT           # ( k )
  call EMIT           # ( )
  # decrease cursor position by one
  call TRUE           # ( -1 )
  call SHARPTIB       # ( -1 #tibaddr )
  call PLUSHSTORE     # ( )
  jmp ACCEPT_checkmaxinput


ACCEPT_checkcontrol:
  # check for remaining control characters, replace them with blank
  cmp $32, %ebx          # ( k k bl )
  jge ACCEPT_echo
  drop_
  # replace control key with a space
  bl_

ACCEPT_echo:
    # emit the key
  dup_                   # ( k k)
  call EMIT              # ( k)
  # now store the key in the input buffer
  call STIB              # ( k tibaddr #tib)
  plus_                  # ( k tibaddr+#tib )
  call CSTORE            # ( )

  call SHARPTIB          # ( 1 #tibaddr )
  call ONEPLUSHSTORE     # ( )

ACCEPT_checkmaxinput:
  # check if max number of char input
  dolit_ TIBSIZE       # ( tibsize )
  call SHARPTIB        # ( tibsize #tibaddr )
  call HFETCH          # ( tibsize #tib)
  minus_               # ( tibsize-#tib)
  # <if>
  zerosense_           # ( )
  je ACCEPT_atmaxinput
  jmp ZERO

ACCEPT_atmaxinput:
  # max number of characters in input buffer so have it processed
  jmp TRUE

# ( -- f )
# refills the input buffer - flag is true if buffer has something
Forthword_ REFILLTIB, 0, "reftib"
	call ACCEPT                # ( f )
	dupzerosense_              # ( f )
	je REFILLTIB_exit
	call CR

REFILLTIB_exit:
	ret
