# interpret_numbers.S

# ( c -- )
# fetch the lit vector and EXEC it. Will interpret a litteral for one of the registers
Forthword_ LIT_INTERP, 0, "lit.interp"
  push_
  user_  Lit_Interpret
  mw_
  end_do_ EXEC

# ( c -- )
# fetch the lit vector and EXEC it. Will compile a litteral for one of the registers
Forthword_ LIT_COMP, 0, "lit.comp"
  push_
  user_  Lit_Compile
  mw_
  end_do_ EXEC

# ( xtc xti -- )
# Select register for literal
Forthword_ REGSET, IMMEDIATE_EN, "regset"
  rpushy_
  y_w_
  user_ Lit_Interpret
  mw_y_
  y_d0_
  user_ Lit_Compile
  mw_y_
  d1_
  nip2_
  rpopy_
  end_

# ( -- )
# Select W register for literal
Forthword_ WSET, IMMEDIATE_EN, "w="
  push_
  lit_ WLIT_C
  push_
  lit_ WLIT_INTERP
  end_do_ REGSET
  
# ( -- )
# Select A register for literal
Forthword_ ASET, IMMEDIATE_EN, "a="
  push_
  lit_ ALIT_C
  push_
  lit_ ALIT_INTERP
  end_do_ REGSET

# ( -- )
# Select B register for literal
Forthword_ BSET, IMMEDIATE_EN, "b="
  push_
  lit_ BLIT_C
  push_
  lit_ BLIT_INTERP
  end_do_ REGSET

# ( -- )
# Select X register for literal
Forthword_ XSET, IMMEDIATE_EN, "x="
  push_
  lit_ XLIT_C
  push_
  lit_ XLIT_INTERP
  end_do_ REGSET

# ( -- )
# Select Y register for literal
Forthword_ YSET, IMMEDIATE_EN, "y="
  push_
  lit_ YLIT_C
  push_
  lit_ YLIT_INTERP
  end_do_ REGSET

# ( n -- )
# store n in WR
Forthword_ WLIT_INTERP, IMMEDIATE_EN, "[w=]"
  movl %eax, WR
  end_

# ( n -- )
# store n in RY
Forthword_ YLIT_INTERP, IMMEDIATE_EN, "[y=]"
  movl %eax, RY
  end_

# ( n -- )
# store n in RX
Forthword_ XLIT_INTERP, IMMEDIATE_EN, "[x=]"
  movl %eax, RX
  end_

# ( n -- )
# store n in RA
Forthword_ ALIT_INTERP, IMMEDIATE_EN, "[a=]"
  movl %eax, RA
  end_

# ( n -- )
# store n in RB
Forthword_ BLIT_INTERP, IMMEDIATE_EN, "[b=]"
  movl %eax, RB
  end_

# ( addr len -- [n] | [addr len] f )
# recognizer for integer numbers
Forthword_ REC_NUM, 0, "rec#"
  rpush_                 # ( addr len ) (R: len )
  y_d0_                  # ( addr len Y:addr )
  rpushy_                # ( addr len ) (R: len addr )
  # try converting to a number
  do_ NUMBER             # ( [n] f )
  iszero_
  if_0_ REC_NONUMBER
    rnip2_               # ( n f )
    do_ STATE            # ( n state )
    iszero_
    pop_
    if_0_ REC_NUMBER_OK
      do_ LIT_COMP
      goto_ REC_NUMBER_DONE

REC_NUMBER_OK:
      do_ LIT_INTERP
      
REC_NUMBER_DONE:
      do_ WSET
      true_               # ( true ) (R: )
      exit_

REC_NONUMBER:
  rpop_                    # ( addr ) (R: len )
  push_                    # ( addr addr ) (R: len )
  rpop_                    # ( addr len ) (R: )
  push_                    # ( addr len len )
  zero_                    # ( addr len 0 )
  end_
