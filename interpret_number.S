# interpret_numbers.S

# ( c -- )
# fetch the lit vector and EXEC it. Will interpret a litteral for one of the registers
Forthword_ LIT_INTERP, 0, "lit.interp"
  push_
  user_  Lit_Interpret
  mw_
  jmp EXEC

# ( c -- )
# fetch the lit vector and EXEC it. Will compile a litteral for one of the registers
Forthword_ LIT_COMP, 0, "lit.comp"
  push_
  user_  Lit_Compile
  mw_
  jmp EXEC

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
  y_d0_             # ( addr len Y:addr )
  rpushy_           # ( addr len ) (R: len addr )
  # try converting to a number
  call NUMBER              # ( [n] f )
  iszero_
  if_0_ REC_NONUMBER
    rnip2_                 # ( n f )
    call STATE             # ( n state )
    iszero_
    pop_
    if_0_ REC_NUMBER_OK
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
