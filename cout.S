# cout.S

# ( -- emitaddr )
# get ram address of emit defer
Forthword_ EMITADDR, 0, "emit#"
  user_ USER_EMIT
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

# ( addr n -- )
# print a counted string
Forthword_ TYPE, 0, "type"
  iszero_
  jz TYPE_END

  rpush_a_
  rpush_b_
  pop_a_           # Address of string
  str_b_

TYPE1:
  a_cfetch_
  aplus1_
  call EMIT
  bminus1_
  jnz TYPE1

  rpop_b_
  rpop_a_

TYPE_END:
  ret
