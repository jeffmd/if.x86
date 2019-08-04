# core.S

# ( -- retaddr )
# pop second return onto data stack and exit caller
# used if data in program mem and need an address to it
# must be called
Forthword_ POPRET, 0, "popret"
  rpop_
  ret
    
# ( n1 n2 -- flag )
# flag is true if WR and NOS are equal
Forthword_ EQUAL, 0, "=="
  sub (%ebx), %eax
  nip_
  sub $1, %eax
  sbb %eax, %eax
  ret

# ( n1 n2 -- flag)
# flag is true if n1 is less than n2
Forthword_ LESS, 0, "<"
  cmp %eax, (%ebx)
  nip_
  jge 1f
  zero_
  not_
  ret
1:
  zero_
  ret

# ( n1 n2 -- flag )
# flag is true if n1 is greater than n2
Forthword_ GREATER, 0, ">"
           # Get x1 into a register.
  cmp %eax, (%ebx)  # Is x2 greater?
  nip_
GREATER_CHK:
  jle 1f
  zero_
  not_
  ret
1:
  zero_
  ret

# ( n1 -- flag )
# flag is true if n1 is greater than 0
Forthword_ ZEROGREATER, 0, "0>"
  sub $0, %eax
  jmp GREATER_CHK

# ( n1 -- flag)
# flag is true if WR is less than zero
forthword_ ZEROLESS, INLINE_OPT, "0<"
  zeroless_
  ret

# (start dest count -- )
# count is the number of bytes to copy
# copy ram using bytes.  Assumes no overlap.
Forthword_ MCPY, 0, "mcpy"
	iszero_         # ( start dest count )
	if_0_ MCPY_END

  rpusha_
  rpushb_
	b_d0_              # ( start dest count ) B: dest
	mov %eax, %ecx
	a_d1_              # (  start dest count ) A: start
	cld
	rep movsb
  rpopb_
  rpopa_
MCPY_END:
  nip2_
  ret
