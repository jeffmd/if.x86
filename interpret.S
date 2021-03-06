# interpret.S

# ( -- )
# ignore remaining text to end of line
Forthword_ COMMENT, IMMEDIATE_EN, "\\"
  push_      # preserve WR
  do_ STIB
  y_w_
  nip_
  do_ G_IN  # skip to end of input buffer
  hmw_y_
  pop_      
  end_

# ( r-addr r-len f-addr f-len --  f)
# compares two counted strings in RAM
# flag is true if strings match
Forthword_ MCMP, 0, "mcmp"
  y_w_                     # ( r-addr r-len f-addr f-len)  Y: f-len
  d1_                      # ( r-addr r-len f-addr r-len)
  # check if strings are same length
  w_xor_y_                 # ( r-addr r-len f-addr flag )
  # if
  pop_                     # ( r-addr r-len f-addr )
  if_0_ CMPSB

  # strings are not the same length
  nip2_                    # ( f-addr )
  zero_                    # ( 0 )
  end_
  # then

# ( r-addr r-len f-addr -- flag)
# compare two strings of same length
# flag is true if strings match
Forthword_ CMPSB, 0, "cmpsb"
  rpusha_
  rpushb_
  a_w_                     # ( r-addr len f-addr ) A: f-addr
  x_d0_                    # ( r-addr len f-addr ) C: len
  b_d1_                    # ( r-addr len f-addr ) B: r-addr
  nip2_                    # ( f-addr )
  cld
  repe cmpsb
  # while
  rpopb_
  rpopa_
  if_0_ MCMP_DONE

  # strings don't match
  zero_                    # ( 0 )
  exit_

MCMP_DONE:
  # strings are the same
  true_                    # ( true )
  end_


# ( addr1 n1 c -- n2 )
# skips leading occurances in string at addr1 leaving n2 as an index
# pointing to the 1st non-c character
# n1 is max number of characters to search
Forthword_ CSKIP, 0, "cskip"
  rpusha_
  rpushb_
  b_w_                 # ( addr1 n1 c ) B: c
  a_d1_                # ( addr1 n1 c ) A: addr1
  d0_                  # ( addr1 n1 n1 )
  y_w_                 # ( addr1 n1 n1 ) Y: n1
  x_w_                 # ( addr1 n1 n1 ) X: n1
  nip2_                # ( n1 )
  goto_ PFA_CSKIP2
  
PFA_CSKIP1:
  cma_                 # ( c' )
  a_plus1_
  cmp %edi, %eax       # ( c' )
  if_not_0_ PFA_CSKIP3
  y_minus1_            # ( c' ) Y-1
PFA_CSKIP2:
  y_iszero_            # ( c' )
  if_not_0_ PFA_CSKIP1

PFA_CSKIP3:
  rpopb_
  rpopa_
  x_                   # ( n1 )
  w_minus_y_           # ( n1-n' )
  end_

# ( addr1 n1 c -- addr1 n2 )
# Scan string at addr1 for the first occurance of c, leaving addr1 n2,
# n1 is max number of characters to search
# char at n2 is first c character
Forthword_ CSCAN, 0, "cscan"
  rpusha_
  rpushb_
  b_w_                 # ( addr1 n1 c ) B: c
  a_d1_                # ( addr1 n1 c ) A: addr1
  d0_                  # ( addr1 n1 n1 )
  y_w_                 # ( addr1 n1 n1 ) Y: n1 
  x_w_                 # ( addr1 n1 n1 ) X: n1
  nip_                 # ( addr1 n1 )
  goto_ PFA_CSCAN2
  
PFA_CSCAN1:
  cma_                 # ( addr1 c' )
  a_plus1_
  cmp %edi, %eax       # ( addr1 c' )
  if_0_ PFA_CSCAN3
  y_minus1_            # ( addr1 c' ) Y-1
PFA_CSCAN2:
  y_iszero_            # ( addr1 c' )
  if_not_0_ PFA_CSCAN1

PFA_CSCAN3:
  rpopb_
  rpopa_
  x_                   # ( addr1 n1 )
  w_minus_y_           # ( addr1 n1-n' )
  end_

# ( -- srcaddr len  )
# Adjust the source addr using >in.
Forthword_ SRCIN, 0, "srcin"
  do_ STIB            # ( srcaddr len )
  push_               # ( srcaddr len len )
  do_ G_IN            # ( srcaddr len ginaddr )
  hmw_                # ( srcaddr len gin)
  end_do_ SLASHSTRING # ( srcaddr' len' )

# ( n -- ginaddr Y:n )
# update position in input source.
Forthword_ UPDIN, 0, "updin"
  y_w_                # ( n2 Y:n2 )
  do_ G_IN            # ( ginaddr )
  x_hmw_              # ( ginaddr X:inidx)
  x_plus_y_           # ( ginaddr X:X+Y)
  hmw_x_
  end_

# ( -- ginidx )
# skip space in input source.
Forthword_ SKIPBL, 0, "skipbl"
  do_ SRCIN           # ( srcaddr len )
  push_               # ( srcaddr len len )
  bl_                 # ( srcaddr len bl )
  do_ CSKIP           # ( n2 )

  # adjust >IN
  end_do_ UPDIN

# ( char "ccc<char>" -- c-addr u )
# in input buffer parse ccc delimited string by the delimiter char.
Forthword_ PARSE, 0, "parse"
  rpush_             # ( c ) (R: c )
  do_ SRCIN          # ( addr len )
  push_              # ( addr len len )
  rpop_              # ( addr len c ) (R: )
  do_ CSCAN          # ( addr' len'')
  oneplus_           # ( addr' len''+1 )
  # skip terminating delimeter
  do_ UPDIN
  y_                 # ( addr' len''+1)
  oneminus_          # ( addr' len'')
  end_

# ( "<name>" -- c-addr len )
# In the SOURCE buffer parse whitespace delimited string. Returns string address within SOURCE.
Forthword_ PNAME, 0, "pname"
  do_ SKIPBL
  bl_
  end_do_ PARSE

# load registers W, A, B, X, Y
# ( xt * -- WR xt )
forthword_ REGL, 0, "regl"
  d0_                # ( xt xt )
  movl WR, %edx 
  d0_y_              # ( WR xt )
  movl RA, %esi
  movl RB, %edi
  movl RX, %ecx
  movl RY, %edx
  end_

# save registers W, A, B, X, Y
forthword_ REGS, 0, "regs"
  movl %eax, WR
  movl %esi, RA
  movl %edi, RB
  movl %ecx, RX
  movl %edx, RY
  end_
    
# ( addr len -- ** [addr len] f )
# recognize a word in the dictionary
Forthword_ REC_WORD, 0, "recw"
  rpush_            # ( addr len ) (R: len )
  y_d0_             # ( addr len Y:addr )
  rpushy_           # ( addr len ) (R: len addr )
  do_ FINDW         # ( 0 | nfa )
  iszero_
  if_not_0_ REC_WORD_FOUND
    rpopy_          # ( 0 Y:addr ) (R: len ) 
    pushy_          # ( addr 0 ) (R: len ) 
    rpopy_          # ( addr 0 Y:len ) (R: ) 
    pushy_          # ( addr len 0 )
    exit_

REC_WORD_FOUND:
  rnip2_            # ( nfa ) (R: )
  do_ NFATOXTF      # ( xt flag )
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
  if_0_ REC_WORD_EXECUTE

REC_WORD_CHECKSTATE:
    # check state
    push_            # ( xt flag flag )
    do_ STATE        # ( xt flag state )
    iszero_
    pop_             # ( xt flag )
    if_0_ REC_WORD_EXECUTE
.if BUILD_LEVEL > 9
      # in compile mode so compile xt
      do_ COMPILEXT  # ( ? )
.endif
      true_
      exit_

REC_WORD_EXECUTE:
  # state is zero, EXEC xt
  do_ REGL
  do_ EXEC           # ( ?? )
  do_ REGS
  
  true_              # ( true )
  end_

# ( addr len -- )
# recognize and execute name of word in ram using recognizer list.
Forthword_ RECX, 0, "recx"
  # test if its a word
  do_ REC_WORD          # ( [addr len] flag )
  iszero_               # ( [addr len] flag )
  if_not_0_ RECX_DONE

.if BUILD_LEVEL > 3
  pop_                  # ( addr len )
  # test if its a number
  do_ REC_NUM           # ( [addr len] flag )
  iszero_               # ( [addr len] flag )
  if_not_0_ RECX_DONE
.endif

  # not recognized so throw
  do_ CR                # ( addr len ? )
  pop_                  # ( addr len )
  # print unrecognized word
  do_ TYPE

  slit_ " Unknown!"
  do_ THROW

RECX_DONE:
  end_

# ( -- ) (R: i*x - j*x )
# interpret input word by word.
Forthword_ INTERPRET, 0, "interp"
  # begin
  do_ PNAME            # ( addr len )
  # ?while
  iszero_              # ( addr len )
  if_0_ INTERPRET_END

  do_ RECX             # ( ? )
  do_ QSTACK           # ( ? )

  # repeat
  goto_ INTERPRET

INTERPRET_END:
  pop_
  end_

# ( -- )
# interpret what is in the input buffer
Forthword_ DOINTERPRET, 0, "(interp)"
  # input buffer has something so try to interpret it
  # setup exception handling in case of error
  push_
  lit_ INTERPRET
  do_ CATCH
  # check to make sure no throws
  # <if>
  iszero_
  if_0_ DOINTERPRET_ok
    do_ PROMPTERROR
    exit_do_ QUIT

  # <then>
DOINTERPRET_ok:
  # make sure in buf pointer is not at zero
  do_ G_IN           # ( >inaddr )
  y_hmw_
  y_plus1_
  hmw_y_             # (  )
  end_do_ PROMPTOK
