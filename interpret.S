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
