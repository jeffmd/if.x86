# interpret.S

# ( c -- )
# fetch the emit vector and EXEC it. Will emit a character from TOS
Forthword_ EMIT, 0, "emit"
  push %eax
  push %ebx
  poptos_
  call putchar
  pop %edx
  pop %eax
  ret

# ( -- )
# cause subsequent output appear at the beginning of the next line
Forthword_ CR, 0, "cr"
  dolit_ 13
  call EMIT
  ten_
  jmp EMIT

# ( -- 32 )
# put ascii code of the blank/space character to the stack
Forthword_ BL, 0, "bl"
    bl_
    ret

# ( -- key )
# fetch key from standard input, should leave a single character on TOS
# if a key was pressed. If no key pressed then -1 is on TOS.
Forthword_ STDIN, 0, "stdin"
  pushtos_
  push %eax
  call getchar
  movl %eax, %ebx
  pop %eax
  ret
