# interpret.S

# ( -- addr )
# flags address
Forthword_ FFLAGS, 0, "fflags"
  user_ fflags
  ret

# ( -- addr )
# terminal input buffer address
Forthword_ TIB, 0, "tib"
  user_ ram_tib
  ret

# ( -- addr-half )
# variable holding the number of characters in TIB
# is half cell size
Forthword_ SHARPTIB, 0, "#tib"
  user_ ram_sharptib
  ret

# ( -- addr len )
# address and current length of the input buffer
Forthword_ STIB, 0, "stib"
  user_ ram_tib
  push_
  user_ ram_sharptib
  hfetch_
  ret

# ( -- a-addr )
# index to current read position in input buffer
# is half cell size
Forthword_ G_IN, 0, ">in"
  user_ user_g_in
  ret

# ( -- pauseaddr )
# get ram address of pause defer
Forthword_ PAUSEADDR, 0, "pause#"
  user_ USER_PAUSE
  ret
  
# ( -- keyaddr )
# get ram address of key defer
Forthword_ KEYADDR, 0, "key#"
  user_ USER_KEY
  ret
  
# ( -- emitaddr )
# get ram address of emit defer
Forthword_ EMITADDR, 0, "emit#"
  user_ USER_EMIT
  ret
  
# ( -- keyfileaddr )
# get ram address of key file descriptor
Forthword_ KEYFILEADDR, 0, "keyf#"
  user_ USER_KEYFILE
  ret
  
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
  
# ( c -- )
# fetch the emit vector and EXEC it. Will emit a character from WR
Forthword_ PUTCHAR, 0, "putchar"
  rpush_
  call putchar
  rnip_
  ret

# ( c -- )
# fetch the emit vector and EXEC it. Will emit a character from WR
Forthword_ EMIT, 0, "emit"
  push_
  call EMITADDR
  fetch_
  jmp EXEC


# ( -- )
# cause subsequent output appear at the beginning of the next line
Forthword_ CR, 0, "cr"
  ten_
  call EMIT
  lit_ 13
  jmp EMIT

# ( -- 32 )
# put ascii code of the blank/space character to the stack
Forthword_ BL, INLINE_OPT, "bl"
  bl_
  ret

# ( -- )
# ignore remaining text to end of line
Forthword_ COMMENt, IMMEDIATE_EN, "\\"
  push_      # preserve WR
  call STIB
  str_d0_
  call G_IN  # skip to end of input buffer
  hstore_
  pop_      
  ret

# ( -- key )
# fetch key from standard input, should leave a single character in WR
# if a key was pressed. If no key pressed then -1 is in WR.
Forthword_ STDIN, 0, "stdin"
  call getchar
  ret

# ( -- key )
# fetch key from an open file using filedes, should leave
# a single character in WR or -1 if no more to read in file.
Forthword_ KEYFILE, 0, "keyfile"
  zero_                    # ( 0 )
  push_                    # ( 0 0 )
  call KEYFILEADDR         # ( 0 keyfile# )
  fetch_                   # ( 0 filedes )
  push_                    # ( 0 filedes ? )
  leal 4(%ebx), %eax       # ( 0 filedes ebx+4 )
  push_                    # ( 0 filedes ebx+4 ebx+4 )
  one_                     # ( 0 filedes ebx+4 1 )
  call READF               # ( key count )
  # was one key read from the file?
  push_                    # ( key count count )
  one_                     # ( key count 1 )
  call EQUAL               # ( key flag )
  iszero_                  # ( key flag )
  pop_                     # ( key )
  jne KEYEND
    oneminus_
    jmp BYE
    
 KEYEND:
  ret

# ( -- key )
# fetch key from deffered routine, should leave a single character
# in WR if a key was pressed. If no key pressed then -1 is in WR.
Forthword_ KEY, 0, "key"
  push_
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
  rpusha_
  iszero_
  jz TYPE_END

  d0_str_a_           # Address of string
  str_d0_

TYPE1:
  a_cfetch_
  acplus_
  call EMIT
  d0_
  oneminus_
  str_d0_
  jnz TYPE1
TYPE_END:
  pop_
  rpopa_
  ret


# ( r-addr r-len f-addr f-len --  f)
# compares two counted strings in RAM
# flag is true if strings match
Forthword_ MCMP, 0, "mcmp"
  str_y_                   # ( r-addr r-len f-addr f-len)  Y: f-len
  d1_                      # ( r-addr r-len f-addr r-len)
  # check if strings are same length
  xor %edx, %eax           # ( r-addr r-len f-addr flag )
  # if
  iszero_                  # ( r-addr r-len f-addr flag )
  pop_                     # ( r-addr r-len f-addr )
  je CMPSB

  # strings are not the same length
  nip2_                    # ( f-addr )
  zero_                    # ( 0 )
  ret
  # then

# ( r-addr r-len f-addr -- flag)
# compare two strings of same length
# flag is true if strings match
Forthword_ CMPSB, 0, "cmpsb"
  rpusha_
  rpushb_
  str_a_                   # ( r-addr len f-addr ) A: f-addr
  d0_str_x_                # ( r-addr len f-addr ) C: len
  d1_str_b_                # ( r-addr len f-addr ) B: r-addr
  nip2_                    # ( f-addr )
  cld
  repe cmpsb
  # while
  rpopb_
  rpopa_
  je MCMP_DONE

  # strings don't match
  zero_                    # ( 0 )
  ret

MCMP_DONE:
  # strings are the same
  true_                    # ( true )
  ret


# ( addr1 u1 n -- addr2 u2 )
# adjust string from addr1 to addr1+n, reduce length from u1 to u2 by n
Forthword_ SLASHSTRING, 0, "/$"
  over_         # ( addr1 u1 n u1 )
  call MIN      # ( addr1 u1 n|u1 )
  push_         # ( addr1 u1 n n )
  d2_           # ( addr1 u1 n addr1 )
  over_         # ( addr1 u1 n addr1 n )
  plus_         # ( addr1 u1 n addr2 )
  str_d2_       # ( addr2 u1 n addr2 )
  pop_          # ( addr2 u1 n )
  minus_        # ( addr2 u2 )
  ret

# ( addr -- addr+2 len )
# get string address and length information out of a counted string
Forthword_ STRINGLEN, 0, "$l"
  str_x_        # ( addr ) X: addr
  twoplus_      # ( addr+2 )
  push_         # ( addr+2 addr+2 )
  x_hfetch_     # ( addr+2 len )
  ret

# ( addr1 n1 c -- n2 )
# skips leading occurances in string at addr1 leaving n2 as an index
# pointing to the 1st non-c character
# n1 is max number of characters to search
Forthword_ CSKIP, 0, "cskip"
  rpusha_
  rpushb_
  str_b_               # ( addr1 n1 c ) B: c
  d1_str_a_            # ( addr1 n1 c ) A: addr1
  d0_                  # ( addr1 n1 n1 )
  str_d1_              # ( n1 n1 n1 )
  jmp PFA_CSKIP2
  
PFA_CSKIP1:
  a_cfetch_            # ( n1 n' c' )
  acplus_
  cmp %edi, %eax       # ( n1 n' c' )
  d0_                  # ( n1 n' n' )
  jne PFA_CSKIP3
  oneminus_            # ( n1 n' n'-1 )
  str_d0_              # ( n1 n'-1 n'-1 )
PFA_CSKIP2:
  iszero_              # ( n1 n' n' )
  jne PFA_CSKIP1

PFA_CSKIP3:
  rpopb_
  rpopa_
  pop_                 # ( n1 n' )
  minus_               # ( n1-n' )
  ret

# ( addr1 n1 c -- addr1 n2 )
# Scan string at addr1 for the first occurance of c, leaving addr1 n2,
# n1 is max number of characters to search
# char at n2 is first c character
Forthword_ CSCAN, 0, "cscan"
  rpusha_
  rpushb_
  str_b_               # ( addr1 n1 c ) B: c
  d1_str_a_            # ( addr1 n1 c ) A: addr1
  d0_                  # ( addr1 n1 n1 )
  push_                # ( addr1 n1 n1 n1 )
  jmp PFA_CSCAN2
  
PFA_CSCAN1:
  a_cfetch_            # ( addr1 n1 n1 c' )
  acplus_
  cmp %edi, %eax       # ( addr1 n1 n1 c' )
  d0_                  # ( addr1 n1 n1 n' )
  je PFA_CSCAN3
  oneminus_            # ( addr1 n1 n1 n'-1 )
  str_d0_              # ( addr1 n1 n'-1 n'-1)
PFA_CSCAN2:
  iszero_              # ( addr1 n1 n' n' )
  jne PFA_CSCAN1

PFA_CSCAN3:
  rpopb_
  rpopa_
  pop_
  minus_               # ( addr1 n1-n' )
  ret

# ( -- srcaddr len  )
# Adjust the source addr using >in.
Forthword_ SRCIN, 0, "srcin"
  call STIB           # ( srcaddr len )
  push_               # ( srcaddr len len )
  call G_IN           # ( srcaddr len ginaddr )
  hfetch_             # ( srcaddr len gin)
  jmp SLASHSTRING     # ( srcaddr' len' )

# ( -- )
# skip space in input source.
Forthword_ SKIPBL, 0, "skipbl"
  call SRCIN          # ( srcaddr len )
  push_               # ( srcaddr len len )
  bl_                 # ( srcaddr len bl )
  call CSKIP          # ( n2 )

  # adjust >IN
  push_
  call G_IN           # ( n2 ginaddr )
  plus_hstr_          # ( n2 )
  ret

# ( char "ccc<char>" -- c-addr u )
# in input buffer parse ccc delimited string by the delimiter char.
Forthword_ PARSE, 0, "parse"
  rpush_             # ( c ) (R: c )
  call SRCIN         # ( addr len )
  push_              # ( addr len len )
  rpop_              # ( addr len c ) (R: )
  call CSCAN         # ( addr' len'')
  push_              # ( addr' len'' len'')
  # skip terminating delimeter
  oneplus_           # ( addr' len'' len''+1 )
  push_              # ( addr' len'' len''+1 len''+1 )
  call G_IN          # ( addr' len'' len''+1 >in )
  plus_hstr_         # ( addr' len'' >in )
  pop_               # ( addr' len'' )
  ret

# ( "<name>" -- c-addr len )
# In the SOURCE buffer parse whitespace delimited string. Returns string address within SOURCE.
Forthword_ PNAME, 0, "pname"
  call SKIPBL
  bl_
  jmp PARSE

# ( addr len idx -- 0 | nfa )
FINDWI:
  fourstar_          # ( addr len idx*4 )
  push_              # ( addr len idx*4 idx*4 )
  call CONTEXT       # ( addr len idx*4 context )
  plus_              # ( addr len context' )
  fetch_             # ( addr len wid )

# ( c-addr len wid -- [ 0 | nfa ] )
# find a word in the dictionary
# 0 if word not found in dictionary
# nfa if word is found
Forthword_ FINDNFA, 0, "findnfa"
  iszero_
  jne FINDNFA_BEGIN
    # terminating, wid is empty
    nip2_
    ret

  # <begin>
FINDNFA_BEGIN:
  fetch_                      # ( c-addr len nfa )
  # <while>
FINDNFA_BEGIN1:
  iszero_                     # ( c-addr len nfa )
  jne FINDNFA_CHECK
    # terminating, 0 found
    nip2_                     # ( 0 )
    ret

FINDNFA_CHECK:
  
  rpush_                      # ( c-addr len nfa) (R: nfa )
  d1_                         # ( c-addr len c-addr )
  push_                       # ( c-addr len c-addr c-addr )
  d1_                         # ( c-addr len c-addr len )
  push_                       # ( c-addr len c-addr len len )
  r0_                         # ( c-addr len c-addr len nfa )
  call STRINGLEN              # ( c-addr len c-addr len f-addr len )
  and $31, %eax               # ( c-addr len c-addr len f-addr 0:len )
  call MCMP                   # ( c-addr len flag )
  # <if>
  iszero_
  je FINDNFA_NEXT
    # we found the string
    pop2_                     # ( c-addr )
    rpop_                     # ( nfa )
    ret
    
  # <then>
FINDNFA_NEXT:
    # next try
    rpop_                     # ( c-addr len nfa )
    call NFA2LFA              # ( c-addr len lfa )
    # <repeat>
    jmp FINDNFA_BEGIN


# ( addr len idx * )
FINDLAST:
  pop2_                       # ( addr len )

# ( addr len --  0 | nfa )
# search root wordlists for the name from string addr/len
Forthword_ FINDROOT, 0, "froot"
  # put root wid on stack
  push_              # ( addr len len )
  lit_ VE_COLD     # ( addr len VE_COLD )
  jmp FINDNFA_BEGIN1

# ( addr len --  0 | nfa )
# search wordlists for the name from string addr/len
Forthword_ FINDW, 0, "findw"
  # loop through context slots to find a word
  # start with last slot
  push_               # ( addr len len )
  call CONTEXT        # ( addr len context )
  # get context index and use as counter
  twominus_           # ( addr len context-2 )
  hfetch_             # ( addr len idx )
  push_               # ( addr len idx idx )
  
FINDW_BEGIN:
  iszero_
  js FINDLAST         # ( addr len idx * )
    d2_               # ( addr len idx addr )
    push_             # ( addr len idx addr addr )
    d2_               # ( addr len idx addr len )
    # get next wordlist in array
    push_             # ( addr len idx addr len len )
    d2_               # ( addr len idx addr len idx )
    call FINDWI       # ( addr len idx nfa )
    iszero_
    # end loop if word found
    je FINDW_NEXT
      nip3_           # ( nfa )
      ret

FINDW_NEXT:
  d0_                 # ( addr len idx idx )
  # decrement index
  oneminus_           # ( addr len idx idx-1 )
  str_d0_             # ( addr len idx-1 idx-1 )
  jmp FINDW_BEGIN

# ( -- addr len )
# runtime portion of sliteral
# string literal is located starting at return cell
# return cell is string length
# string then occupies the following cells: c2c1 c4c3 ...
Forthword_ DOSLIT, 0, "(slit)"
  # get return address to get string length, calculate string address start,
  # and calculate return address
  r0_            # ( raddr )  (R: raddr)
  push_          # ( raddr raddr )
  # get the string length
  hfetch_        # ( raddr slength )
  push_          # ( raddr slength slength )
  # calculate string address
  d1_            # ( raddr slength raddr )
  twoplus_       # ( raddr slength straddr )
  # calculate the number of words to skip over for return address
  str_d1_        # ( straddr slength straddr )
  over_          # ( straddr slength straddr slength)
  plus_          # ( straddr slength straddr+slength )
  # also skip string length
  str_r0_        # ( straddr slength straddr+k ) (R: straddr+k )
  pop_           # ( straddr slength )
  ret

# ( addr len -- [n] | [addr len] f )
# recognizer for integer numbers
Forthword_ REC_NUM, 0, "rec#"
  rpush_            # ( addr len ) (R: len )
  rpushd0_          # ( addr len ) (R: len addr )
  # try converting to a number
  call NUMBER              # ( [n] f )
  iszero_
  je REC_NONUMBER
    rnip2_                 # ( n f )
    call STATE             # ( n state )
    iszero_
    je REC_NUMBER_OK
      pop_
      jmp LIT

REC_NUMBER_OK:
      popy_               # ( 0 ) Y: n
      movl %edx, WR
      true_               # ( n true ) (R: )
      ret

REC_NONUMBER:
  rpop_                    # ( addr ) (R: len )
  push_                    # ( addr addr ) (R: len )
  rpop_                    # ( addr len ) (R: )
  push_                    # ( addr len len )
  zero_                    # ( addr len 0 )
  ret

# ( addr len -- ** [addr len] f )
# recognize a word in the dictionary
Forthword_ REC_WORD, 0, "recw"
  rpush_            # ( addr len ) (R: len )
  rpushd0_          # ( addr len ) (R: len addr )
  call FINDW        # ( 0 | nfa )
  iszero_
  jne REC_WORD_FOUND
    rpop_           # ( addr ) (R: len ) 
    push_           # ( addr addr ) (R: len ) 
    rpop_           # ( addr len ) (R: ) 
    push_           # ( addr len len )
    zero_           # ( addr len 0 )
    ret

REC_WORD_FOUND:
  rnip2_            # ( nfa ) (R: )
  call NFATOXTF     # ( xt flag )
  # check if compile only word
  #sbrc tosh, COMPILE_ONLY_FB
  #    rjmp CHECK_IMMEDIATE

CHECK_COMPILE_ONLY:
#    bl STATE
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
  test %edx, %eax
  # flag is 0: always EXEC
  je REC_WORD_EXECUTE

REC_WORD_CHECKSTATE:
    # check state
    push_            # ( xt flag flag )
    call STATE       # ( xt flag state )
    iszero_
    pop_             # ( xt flag )
    je REC_WORD_EXECUTE
      # in compile mode so compile xt
      call COMPILEXT # ( ? )
      true_
      ret

REC_WORD_EXECUTE:
  # state is zero, EXEC xt
  d0_                # ( xt xt )
  movl WR, %edx 
  y_str_d0_          # ( WR xt )
  movl RA, %esi
  movl RB, %edi
  movl RC, %ecx
  movl RD, %edx

  call EXEC          # ( ?? )
  
  movl %eax, WR
  movl %esi, RA
  movl %edi, RB
  movl %ecx, RC
  movl %edx, RD
  true_              # ( true )
  ret

# ( addr len -- )
# recognize and execute name of word in ram using recognizer list.
Forthword_ RECX, 0, "recx"
  # test if its a word
  call REC_WORD         # ( [addr len] flag )
  iszero_               # ( [addr len] flag )
  jne RECX_DONE
  pop_                  # ( addr len )
  # test if its a number
  call REC_NUM          # ( [addr len] flag )
  iszero_               # ( [addr len] flag )
  jne RECX_DONE
  # not recognized so throw
  call CR               # ( addr len ? )
  pop_                  # ( addr len )
  # print unrecognized word
  call TYPE

  $lit_ " Unknown!"
  call THROW

RECX_DONE:
  ret

# ( -- ) (R: i*x - j*x )
# interpret input word by word.
Forthword_ INTERPRET, 0, "interp"
  # begin
  call PNAME            # ( addr len )
  # ?while
  iszero_               # ( addr len )
  je INTERPRET_END

  call RECX             # ( ? )
  call QSTACK           # ( ? )

  # repeat
  jmp INTERPRET

INTERPRET_END:
  pop_
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

# ( -- )
# Reset the input buffer
Forthword_ INRESET, 0, "in_"
  call G_IN                # ( >inaddr )
  zero_hstr_               # ( >inaddr )
  # reset input buffer cursor position
  call SHARPTIB            # ( #tibaddr )
  zero_hstr_               # ( #tibaddr )
  jmp QP_RD

# ( -- flag)
# fill up the input buffer some more
# flag is true if input buffer is full or needs processing
Forthword_ DOREFILL, 0, "(refill)"
  # if just starting new input line then check prompt and reset input position
  call G_IN                # ( >inaddr )
  hfetch_                  # ( >in )
  iszero_                  # ( >in )
  je DOREFILL_do
    call INRESET

DOREFILL_do:
  # refill the input buffer
  jmp REFILL              # ( f )

# ( -- )
# interpret what is in the input buffer
Forthword_ DOINTERPRET, 0, "(interp)"
  # input buffer has something so try to interpret it
  # setup exception handling in case of error
  push_
  lit_ INTERPRET
  call CATCH
  # check to make sure no throws
  # <if>
  iszero_
  je DOINTERPRET_ok
    call PROMPTERROR
    jmp QUIT

  # <then>
DOINTERPRET_ok:
  # make sure in buf pointer is not at zero
  call G_IN          # ( >inaddr )
  oneplus_hstr_      # (  )
  jmp PROMPTOK


# ( -- )
# set terminate flag which indicates request to exit forth interpreter
Forthword_ BYE, 0, "bye"
  one_
  push_
  call FFLAGS
  str_x_
  x_hfetch_
  or_
  x_hstr_
  ret

# ( -- )
# Fetch pause vector and EXEC it. may make a context/task switch
Forthword_ DOPAUSE, 0, "(pause)"
  push_
  call SLEEP ## temp fix for cpu hogging
  call PAUSEADDR
  fetch_
  jmp EXEC

# ( -- )
# main loop - iterate through scheduled tasks
Forthword_ DOTASKS, 0, "(tasks)"
  # <begin>
  call DOREFILL     # ( flag )
  iszero_
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
  je DOTASKS
  
  ret

# ( -- )
# reset input source
Forthword_ RESET, 0, "reset"
  call ZERO_SMUDGE_STR

  # reset input source for key
  lit_ STDIN
  push_
  call KEYADDR
  store_

  # reset output source for emit
  lit_ PUTCHAR
  push_
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
  str_sp_
  # reset return stack pointer
  call RP0
  fetch_
  str_rp_
  call RESET
  jmp DOTASKS


# ( -- flag )
# receive a string of at most tibsize characters or cr/lf detected.
# flag will be true if input buffer needs to be processed ie interpreted
# flag will be false if more input needed
Forthword_ ACCEPT, 0, "accept"
  # <begin>
  call KEY        # ( k )
  iszero_
  jg ACCEPT_checkeol
  oneplus_
  ret

ACCEPT_checkeol:
  # check for EOL
  cmp $10, %eax
  # <if>
  jne ACCEPT_checkreturn
  ret

ACCEPT_checkreturn:
  cmp $13, %eax     # ( k )
  # <if>
  jne ACCEPT_checkdelete
  ret

ACCEPT_checkdelete:
  # check delete
  cmp $127, %eax     # ( k )
  # <if>
  jne ACCEPT_checkcontrol
  # delete previous character
  # check beginning of line
  # if cursor is 0 then at begining of input
  push_             # ( k k )
  call SHARPTIB     # ( k #tib )
  hfetch_           # ( k tib )
  # <if>
  iszero_           # ( k tib )
  pop_              # ( k )
  jne ACCEPT_dodelete
  # at the beginning of the line, ignore this character
  zero_             # ( 0 )
  ret

ACCEPT_dodelete:
  andl $8, %eax
  push_               # ( k k )
  call EMIT           # ( k ? )
  bl_                 # ( k bl )
  call EMIT           # ( k ? )
  pop_                # ( k )
  call EMIT           # ( ? )
  # decrease cursor position by one
  call TRUE           # ( true )
  push_               # ( true true )
  call SHARPTIB       # ( true #tibaddr )
  plus_hstr_          # ( #tibaddr )
  jmp ACCEPT_checkmaxinput


ACCEPT_checkcontrol:
  # check for remaining control characters, replace them with blank
  cmp $32, %eax          # ( k )
  jge ACCEPT_echo
  # replace control key with a space
  bl_                    # ( bl )

ACCEPT_echo:
    # emit the key
  push_                  # ( k k )
  call EMIT              # ( k ? )
  # now store the key in the input buffer
  call STIB              # ( k tibaddr #tib)
  plus_                  # ( k tibaddr+#tib )
  cstr_                  # ( tibaddr+#tib )

  call SHARPTIB          # ( #tib )
  oneplus_hstr_          # ( ? )

ACCEPT_checkmaxinput:
  # check if max number of char input
  lit_ TIBSIZE         # ( tibsize )
  push_
  call SHARPTIB          # ( tibsize #tibaddr )
  hfetch_                # ( tibsize #tib )
  minus_                 # ( tibsize-#tib )
  # <if>
  iszero_                # ( tibsize-#tib )
  je ACCEPT_atmaxinput
  jmp ZERO

ACCEPT_atmaxinput:
  # max number of characters in input buffer so have it processed
  jmp TRUE

# ( -- f )
# refills the input buffer - flag is true if buffer has something
Forthword_ REFILLTIB, 0, "reftib"
  call ACCEPT                # ( f )
  iszero_                    # ( f )
  je REFILLTIB_exit
  push_
  call CR
  pop_

REFILLTIB_exit:
  ret
