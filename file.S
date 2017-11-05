# file.S - words used to work with files and shared libraries

# ( path flags -- filedes )
# open a file
# path - address of path string null terminated
# option flags 
Forthword_ OPENF, 0, "open"
  push %eax
  push %ebx     # flags
  push (%eax)   # path
  call open
  mov %eax, %ebx
  add $8, %esp
  pop %eax
  nip_
  ret

# ( filedes -- )
# open a file
# filedes - file descriptor
Forthword_ CLOSEF, 0, "close"
  push %eax
  push %ebx    # filedes
  call close
  pop %edx
  pop %eax
  poptos_
  ret

# (  filedes buffer length -- bytesread )
# fetch bytes from an open file using filedes
# number of bytes read left on TOS
Forthword_ READF, 0, "read"
  push %eax
  push %ebx     # length
  push (%eax)   # buffer
  push 4(%eax)  # filedes
  call read 
  mov %eax, %ebx
  add $12, %esp
  pop %eax
  dnip_
  ret

# (  filedes buffer length -- bytesread )
# write bytes to an open file using filedes
# number of bytes written left on TOS
Forthword_ WRITEF, 0, "write"
  push %eax
  push %ebx # length
  push (%eax) # buffer
  push 4(%eax) # filedes
  call write 
  mov %eax, %ebx
  add $12, %esp
  pop %eax
  dnip_
  ret
