# asm.$ - words that generate inline assembly 

# ( -- )
# compile assembler pop {pc}
Forthword_ RET_C, 0, "ret,"
  dolit_ 0xc3
  jmp COMMA

# calc relative distance
# ( dest start  -- distance )
Forthword_ RELDST, 0, "reldst"
  # calculate relative distance in bytes from start to dest
  # rel dist = dest - start
  minus_               # ( dest-start )
  ret

# build assembler instruction jmp - unconditional long jump
# ( reldist -- rellong jumpinst)
# reldist: relative distance as 2's compliment 32 bit
Forthword_ JUMP, 0, "jmpl"
  # 0xe9 XXXX XXXX XXXX
  sub $5, %eax
  dolit_ 0xe9
  ret

# build assembler instruction jmp - unconditional short jump
# ( reldist -- jumprellong )
# reldist: relative distance as 2's compliment 32 bit
Forthword_ JUMPS, 0, "jmps"
    # 0xe9 XXXX XXXX XXXX 
    ret

# compile assembler instruction jmp - unconditional jump
# ( reldist -- )
# reldist: relative distance as 2's compliment
Forthword_ JMP_COMMA, 0, "jmp,"
    call CALLOFF
    call JUMP            # ( rellong jumpinst )
    call COMMA           # ( rellong )
    jmp DWCOMMA          # ( )

# compile jump at start address
# ( start dest -- )
Forthword_ JMPC, 0, "jmpc"
  call TAILOPTOFF   
  over_                # ( start dest start )
  call RELDST          # ( start reldst )
  call JUMP            # ( start rellong jumpinst )
  rot_                 # ( rellong jumpinst start )
  toa_                 # ( rellong jumpinst ) A: start
  acstore_             # ( rellong )
  acplus_
  astore_              # ( )
  ret

# conditional jump over a jmp if not zero
# ( -- )
Forthword_ JMPNZ1_COMPILE, 0, "jne1,"
    # compile jne $06 : 0x7505
  dolit_ 0x75
  call COMMA
  dolit_ 5
  jmp COMMA


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
  drop_           # ( xt )
  jne DO_COMPILEXT
    # not a call so disable tail call optimization
    call CALLOFF
    jmp INLINE

DO_COMPILEXT:
  # calculate relative distance in words from start to dest
  call CP              # ( xt cp )
  call RELDST          # ( distance )
  # fall through into CALLC

# compile call at start address
# ( dist -- )
# dist: 2's compliment dword offset
Forthword_ CALLC, 0, "call,"
  orw $(1<<LAST_IS_CALL_FB), fflags
  # call is an 8 bit instruction with a 32 bit 2's compliment offset
  # bit pattern:
  #
  dolit_ 0xe8
  call COMMA           # ( dist )
  # adjust rel distance to account for instruction length of call
  dolit_ 5
  minus_
  # store offset
  jmp DWCOMMA

# compile top of stack as inlinned immediate 32 bit constant
# ( n -- )
Forthword_ LIT, 0, "lit"
  # compile dup_
  dolit_ 0x89fc5b8d
  call DWCOMMA
  dolit_ 0x03
  call COMMA
  dolit_ 0xb8
  call COMMA
  # store 32 bit val from tos
  jmp DWCOMMA
