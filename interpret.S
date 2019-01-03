# interpret.S

# ( c -- )
# fetch the lit vector and EXEC it. Will interpret a litteral for one of the registers
Forthword_ LIT_INTERP, 0, "lit.interp"
  push_
  user_  Lit_Interpret
  fetch_
  jmp EXEC

# ( c -- )
# fetch the lit vector and EXEC it. Will compile a litteral for one of the registers
Forthword_ LIT_COMP, 0, "lit.comp"
  push_
  user_  Lit_Compile
  fetch_
  jmp EXEC

# ( -- )
# ignore remaining text to end of line
Forthword_ COMMENT, IMMEDIATE_EN, "\\"
  push_      # preserve WR
  call STIB
  str_y_
  nip_
  call G_IN  # skip to end of input buffer
  yw_hstr_
  pop_      
  ret

# ( xtc xti -- )
# Select register for literal
Forthword_ REGSET, IMMEDIATE_EN, "regset"
  rpush_y_
  str_y_
  user_ Lit_Interpret
  yw_str_
  d0_str_y_
  user_ Lit_Compile
  yw_str_
  pop2_
  rpop_y_
  ret

# ( -- )
# Select W register for literal
Forthword_ WSET, IMMEDIATE_EN, "w="
  push_
  lit_ WLIT_C
  push_
  lit_ WLIT_INTERP
  jmp REGSET
  
# ( -- )
# Select A register for literal
Forthword_ ASET, IMMEDIATE_EN, "a="
  push_
  lit_ ALIT_C
  push_
  lit_ ALIT_INTERP
  jmp REGSET

# ( -- )
# Select B register for literal
Forthword_ BSET, IMMEDIATE_EN, "b="
  push_
  lit_ BLIT_C
  push_
  lit_ BLIT_INTERP
  jmp REGSET

# ( -- )
# Select X register for literal
Forthword_ XSET, IMMEDIATE_EN, "x="
  push_
  lit_ XLIT_C
  push_
  lit_ XLIT_INTERP
  jmp REGSET

# ( -- )
# Select Y register for literal
Forthword_ YSET, IMMEDIATE_EN, "y="
  push_
  lit_ YLIT_C
  push_
  lit_ YLIT_INTERP
  jmp REGSET

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
  rpush_a_
  rpush_b_
  str_a_                   # ( r-addr len f-addr ) A: f-addr
  d0_str_x_                # ( r-addr len f-addr ) C: len
  d1_str_b_                # ( r-addr len f-addr ) B: r-addr
  nip2_                    # ( f-addr )
  cld
  repe cmpsb
  # while
  rpop_b_
  rpop_a_
  je MCMP_DONE

  # strings don't match
  zero_                    # ( 0 )
  ret

MCMP_DONE:
  # strings are the same
  true_                    # ( true )
  ret


# ( addr1 n1 c -- n2 )
# skips leading occurances in string at addr1 leaving n2 as an index
# pointing to the 1st non-c character
# n1 is max number of characters to search
Forthword_ CSKIP, 0, "cskip"
  rpush_a_
  rpush_b_
  str_b_               # ( addr1 n1 c ) B: c
  d1_str_a_            # ( addr1 n1 c ) A: addr1
  d0_                  # ( addr1 n1 n1 )
  str_y_               # ( addr1 n1 n1 ) Y: n1
  str_x_               # ( addr1 n1 n1 ) X: n1
  nip2_                # ( n1 )
  jmp PFA_CSKIP2
  
PFA_CSKIP1:
  a_cfetch_            # ( c' )
  a_plus1_
  cmp %edi, %eax       # ( c' )
  jne PFA_CSKIP3
  y_minus1_            # ( c' ) Y-1
PFA_CSKIP2:
  y_iszero_            # ( c' )
  jne PFA_CSKIP1

PFA_CSKIP3:
  rpop_b_
  rpop_a_
  x_                   # ( n1 )
  minus_y_             # ( n1-n' )
  ret

# ( addr1 n1 c -- addr1 n2 )
# Scan string at addr1 for the first occurance of c, leaving addr1 n2,
# n1 is max number of characters to search
# char at n2 is first c character
Forthword_ CSCAN, 0, "cscan"
  rpush_a_
  rpush_b_
  str_b_               # ( addr1 n1 c ) B: c
  d1_str_a_            # ( addr1 n1 c ) A: addr1
  d0_                  # ( addr1 n1 n1 )
  str_y_               # ( addr1 n1 n1 ) Y: n1 
  str_x_               # ( addr1 n1 n1 ) X: n1
  nip_                 # ( addr1 n1 )
  jmp PFA_CSCAN2
  
PFA_CSCAN1:
  a_cfetch_            # ( addr1 c' )
  a_plus1_
  cmp %edi, %eax       # ( addr1 c' )
  je PFA_CSCAN3
  y_minus1_            # ( addr1 c' ) Y-1
PFA_CSCAN2:
  y_iszero_            # ( addr1 c' )
  jne PFA_CSCAN1

PFA_CSCAN3:
  rpop_b_
  rpop_a_
  x_                   # ( addr1 n1 )
  minus_y_             # ( addr1 n1-n' )
  ret

# ( -- srcaddr len  )
# Adjust the source addr using >in.
Forthword_ SRCIN, 0, "srcin"
  call STIB           # ( srcaddr len )
  push_               # ( srcaddr len len )
  call G_IN           # ( srcaddr len ginaddr )
  hfetch_             # ( srcaddr len gin)
  jmp SLASHSTRING     # ( srcaddr' len' )

# ( -- ginaddr )
# skip space in input source.
Forthword_ SKIPBL, 0, "skipbl"
  call SRCIN          # ( srcaddr len )
  push_               # ( srcaddr len len )
  bl_                 # ( srcaddr len bl )
  call CSKIP          # ( n2 )

  # adjust >IN
  str_y_              # ( n2 Y:n2 )
  call G_IN           # ( ginaddr )
  y_plus_hstr_        # ( ginaddr )
  ret

# ( char "ccc<char>" -- c-addr u )
# in input buffer parse ccc delimited string by the delimiter char.
Forthword_ PARSE, 0, "parse"
  rpush_             # ( c ) (R: c )
  call SRCIN         # ( addr len )
  push_              # ( addr len len )
  rpop_              # ( addr len c ) (R: )
  call CSCAN         # ( addr' len'')
  str_y_             # ( addr' len'' Y:len'')
  str_x_             # ( addr' len'' X:len'')
  # skip terminating delimeter
  y_plus1_           # ( addr' len'' Y:len''+1 )
  call G_IN          # ( addr' >in )
  y_plus_hstr_       # ( addr' >in )
  x_                 # ( addr' len'' )
  ret

# ( "<name>" -- c-addr len )
# In the SOURCE buffer parse whitespace delimited string. Returns string address within SOURCE.
Forthword_ PNAME, 0, "pname"
  call SKIPBL
  bl_
  jmp PARSE

# ( n -- )
# store n in WR
Forthword_ WLIT_INTERP, IMMEDIATE_EN, "[w=]"
      movl %eax, WR
      ret

# ( n -- )
# store n in RY
Forthword_ YLIT_INTERP, IMMEDIATE_EN, "[y=]"
      movl %eax, RY
      ret

# ( n -- )
# store n in RX
Forthword_ XLIT_INTERP, IMMEDIATE_EN, "[x=]"
      movl %eax, RX
      ret

# ( n -- )
# store n in RA
Forthword_ ALIT_INTERP, IMMEDIATE_EN, "[a=]"
      movl %eax, RA
      ret

# ( n -- )
# store n in RB
Forthword_ BLIT_INTERP, IMMEDIATE_EN, "[b=]"
      movl %eax, RB
      ret

# ( addr len -- [n] | [addr len] f )
# recognizer for integer numbers
Forthword_ REC_NUM, 0, "rec#"
  rpush_            # ( addr len ) (R: len )
  d0_str_y_         # ( addr len Y:addr )
  rpush_y_          # ( addr len ) (R: len addr )
  # try converting to a number
  call NUMBER              # ( [n] f )
  iszero_
  je REC_NONUMBER
    rnip2_                 # ( n f )
    call STATE             # ( n state )
    iszero_
    pop_
    je REC_NUMBER_OK
      call LIT_COMP
      jmp REC_NUMBER_DONE

REC_NUMBER_OK:
      call LIT_INTERP
      
REC_NUMBER_DONE:
      call WSET
      true_               # ( true ) (R: )
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
  d0_str_y_         # ( addr len Y:addr )
  rpush_y_          # ( addr len ) (R: len addr )
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
#    iszero_
#    pop_
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
  movl RX, %ecx
  movl RY, %edx

  call EXEC          # ( ?? )
  
  movl %eax, WR
  movl %esi, RA
  movl %edi, RB
  movl %ecx, RX
  movl %edx, RY
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

  slit_ " Unknown!"
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
