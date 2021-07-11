# cout.S

# ( -- emitaddr )
# get ram address of emit defer
Forthword_ EMITADDR, 0, "emit#"
  user_ USER_EMIT
  end_
  
# ( c -- )
# fetch the emit vector and EXEC it. Will emit a character from WR
Forthword_ PUTCHAR, 0, "putchar"
  r_w_
  do_ putchar
  r_sub_1_
  end_

# ( -- )
# turn emit off
Forthword_ EMIT_OFF, 0, "emit.off"
  # reset output source for emit
  lit_y_ NOOP
  do_ EMITADDR
  mw_y_
  end_

# ( -- )
# turn emit on for default output
Forthword_ EMIT_ON, 0, "emit.on"
  # reset output source for emit
  lit_y_ PUTCHAR
  do_ EMITADDR
  mw_y_
  end_

# ( c -- )
# fetch the emit vector and EXEC it. Will emit a character from WR
Forthword_ EMIT, 0, "emit"
  d_w_
  do_ EMITADDR
  mw_
  end_do_ EXEC

# ( -- )
# cause subsequent output appear at the beginning of the next line
Forthword_ CR, 0, "cr"
  lit_ 10
  do_ EMIT
  lit_ 13
  end_do_ EMIT

# ( -- 32 )
# put ascii code of the blank/space character to the stack
Forthword_ BL, INLINE_OPT, "bl"
  bl_
  end_

# ( addr n -- )
# print a counted string
Forthword_ TYPE, 0, "type"
  iszero_
  ifz_ TYPE_END

  r_a_
  r_b_
  a_d_            # Address of string
  b_w_            # number of char to emit

TYPE1:
  cma_
  a_add_1_
  do_ EMIT
  b_sub_1_
  ifnz_ TYPE1

  b_r_
  a_r_

TYPE_END:
  end_
