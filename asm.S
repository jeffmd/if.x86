# asm.$ - words that generate inline assembly 

# ( -- )
# compile assembler ret
Forthword_ RET_C, 0, "ret,"
  lit_ 0xc3
  end_do_ COMMA

# ( -- )
# compile assembler data stack push
Forthword_ PUSH_C, 0, "push,"
  lit_ 0x89fc5b8d
  do_ DWCOMMA
  lit_ 0x03
  end_do_ COMMA

# calc relative distance
# ( dest start  -- distance )
Forthword_ RELDST, 0, "reldst"
  # calculate relative distance in bytes from start to dest
  # rel dist = dest - start
  y_w_                  # ( dest start ) Y: start
  d_                    # ( dest )
  sub_y_                # ( dest-start )
  end_

# build assembler instruction jmp - unconditional long jump
# ( reldist -- rellong jumpinst)
# reldist: relative distance as 2's compliment 32 bit
Forthword_ JUMP, 0, "jmpl"
  # 0xe9 XXXX XXXX XXXX
  sub $5, %eax
  d_w_
  lit_ 0xe9
  end_

# build assembler instruction jmp - unconditional short jump
# ( reldist -- jumprellong )
# reldist: relative distance as 2's compliment 32 bit
Forthword_ JUMPS, 0, "jmps"
  # 0xe9 XXXX XXXX XXXX 
  end_

# compile assembler instruction jmp - unconditional jump
# ( reldist -- )
# reldist: relative distance as 2's compliment
Forthword_ JMP_COMMA, 0, "jmp,"
  do_ JUMP             # ( rellong jumpinst )
  do_ COMMA            # ( rellong ? )
  d_                   # ( rellong )
  do_ DWCOMMA          # ( ? )
  end_do_ CALLOFF

# compile jump at start address
# ( start dest -- )
Forthword_ JMPC, 0, "jmpc"
  d_w_
  d1_                  # ( start dest start )
  do_ RELDST           # ( start reldst )
  do_ JUMP             # ( start rellong jumpinst )
  y_w_                 # ( start rellong jumpinst Y:jumpinst )
  d1_                  # ( start rellong start )
  cmw_y_               # ( start rellong start )
  y_d0_                # ( start rellong start Y:rellong )
  add_1_               # ( start rellong start+1 )
  mw_y_                # ( start rellong start+1 )
  d_sub_2_             # ( start+1 )
  end_do_ TAILOPTOFF

# conditional jump over a jmp if not zero
# ( -- )
Forthword_ JMPNZ1_COMPILE, 0, "jne1,"
    # compile jne $06 : 0x7505
  lit_ 0x75
  do_ COMMA
  lit_ 5
  end_do_ COMMA


# compile call to xt at the current code position (CP)
# If word flag indicates inlining then the word is inlined.
# ( xt flags -- )
Forthword_ COMPILEXT, 0, "cxt"
  # default to tail call optimization enabled
  andw $~(1<<DIS_CALL_OPT_FB), fflags 
  # check bit 2 of word high byte flags: if set then tail call optimization stays enabled
  #sbrs tosh, DIS_CALL_OPT_FB
  # bit 2 of high byte flag is clear so disable tail call optimization
  #sbr fflags, 1<<DIS_CALL_OPT_FB
  
  # should word be inlinned?
  test $(INLINE_OPT << 8), %eax
	# if bit 0 of high byte flag is 0 then word is to be inlinned
  ifnz_ DO_COMPILEXT
    # not a call so disable tail call optimization
    do_ CALLOFF        # ( xt ? )
    d_                 # ( xt )
    exit_do_ INLINE

DO_COMPILEXT:
  # calculate relative distance in words from start to dest
  do_ CP               # ( xt cp )
  do_ RELDST           # ( distance )
  # fall through into CALLC

# compile call at start address
# ( dist -- )
# dist: 2's compliment dword offset
Forthword_ CALLC, 0, "call,"
  orw $(1<<LAST_IS_CALL_FB), fflags
  # call is an 8 bit instruction with a 32 bit 2's compliment offset
  # bit pattern:
  #
  d_w_                 # ( dist dist )
  lit_ 0xe8            # ( dist 0xe8 )
  do_ COMMA            # ( dist ? )
  d_                   # ( dist )
  # adjust rel distance to account for instruction length of call
  sub $5, %eax         # ( dist-5 )
  # store offset
  end_do_ DWCOMMA

# compile inlinned immediate 32 bit constant
# ( n ins -- )
Forthword_ DOLIT, 0, "(lit,)"
  do_ COMMA
  d_
  # store 32 bit val from tos
  end_do_ DWCOMMA

# compile top of stack as inlinned immediate 32 bit constant
# ( n -- )
Forthword_ WLIT_C, 0, "#,"
  d_w_
  lit_ 0xb8
  end_do_ DOLIT

# compile Y register load inlinned immediate 32 bit constant
# ( n -- )
Forthword_ YLIT_C, 0, "y#,"
  d_w_
  lit_ 0xba
  end_do_ DOLIT

# compile X register load inlinned immediate 32 bit constant
# ( n -- )
Forthword_ XLIT_C, 0, "x#,"
  d_w_
  lit_ 0xb9
  end_do_ DOLIT

# compile A register load inlinned immediate 32 bit constant
# ( n -- )
Forthword_ ALIT_C, 0, "a#,"
  d_w_
  lit_ 0xbe
  end_do_ DOLIT

# compile B register load inlinned immediate 32 bit constant
# ( n -- )
Forthword_ BLIT_C, 0, "b#,"
  d_w_
  lit_ 0xbf
  end_do_ DOLIT
