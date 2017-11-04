# asm.$ - words that generate inline assembly 

# ( -- )
# compile assembler pop {pc}
Forthword_ RET_C, 0, "ret,"
  datastack_
  dolit_ 0xc3
  datastack_
  jmp COMMA

# calc relative distance
# ( dest start  -- distance )
Forthword_ RELDST, 0, "reldst"
  # calculate relative distance in bytes from start to dest
  # rel dist = dest - start
  datastack_
  minus_               # ( dest-start )
  datastack_
  ret

# build assembler instruction jmp - unconditional long jump
# ( reldist -- rellong jumpinst)
# reldist: relative distance as 2's compliment 32 bit
Forthword_ JUMP, 0, "jmpl"
  # 0xe9 XXXX XXXX XXXX
  sub $4, %ebx
  datastack_
  dolit_ 0xe9
  datastack_
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
Forthword_ BC, 0, "jmp,"
    call JUMP            # ( rellong jumpinst )
    call COMMA           # ( rellong )
    jmp DWCOMMA          # ( )

# compile jump at start address
# ( start dest -- )
Forthword_ JMPC, 0, "jmpc"
  datastack_
  over_                # ( start dest start )
  datastack_
  call RELDST          # ( start reldst )
  call JUMP            # ( start rellong jumpinst )
  rot_                 # ( rellong jumpinst start )
  datastack_
  toa_                 # ( rellong jumpinst ) A: start
  acstore_             # ( rellong )
  acplus_
  astore_              # ( )
  datastack_
  ret

# conditional jump over a jmp if not zero
# ( -- )
Forthword_ JMPNZ1_COMPILE, 0, "jne1,"
    # compile jne $06 : 0x7506
    dolit_ 0x75
    call COMMA
    dolit_ 6
    jmp COMMA


# compile call to xt at the current code position (CP)
# If word flag indicates inlining then the word is inlined.
# ( xt flags -- )
Forthword_ COMPILEXT, 0, "cxt"
	movl $(INLINE_OPT << 8), %edx
	test %ebx, %edx
	# if bit 0 of high byte flag is 0 then word is to be inlinned
  datastack_
  drop_           # ( xt )
  datastack_
  je COMPILEXT_INLINE
  jmp DO_COMPILEXT

COMPILEXT_INLINE:
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
  # call is an 8 bit instruction with a 32 bit 2's compliment offset
  # bit pattern:
  #
  datastack_
  dolit_ 0xe8
  datastack_
  call COMMA           # ( dist )
  # adjust rel distance to account for instruction length of call
  datastack_
  dolit_ 5
  minus_
  datastack_
  # store offset
  jmp DWCOMMA

# compile top of stack as inlinned immediate 32 bit constant
# ( n -- )
Forthword_ LIT, 0, "lit"
  # compile pushtos_
  datastack_
  dolit_ 0xbb945394
  datastack_
  call DWCOMMA
  # store 32 bit val from tos
  jmp DWCOMMA
