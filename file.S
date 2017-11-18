# file.S - words used to work with files and shared libraries

# ( path flags -- filedes )
# open a file
# path - address of path string null terminated
# option flags 
Forthword_ OPENF, 0, "open"
  push %eax     # flags
  push (%ebx)   # path
  call open
  add $8, %esp
  dnip_
  ret

# ( filedes -- )
# open a file
# filedes - file descriptor
Forthword_ CLOSEF, 0, "close"
  push %eax    # filedes
  call close
  rnip_
  ret

# (  filedes buffer length -- bytesread )
# fetch bytes from an open file using filedes
# number of bytes read left on TOS
Forthword_ READF, 0, "read"
  push %eax     # length
  push (%ebx)   # buffer
  push 4(%ebx)  # filedes
  call read 
  add $12, %esp
  d2nip_
  ret

# (  filedes buffer length -- bytesread )
# write bytes to an open file using filedes
# number of bytes written left on TOS
Forthword_ WRITEF, 0, "write"
  push %eax # length
  push (%ebx) # buffer
  push 4(%ebx) # filedes
  call write 
  add $12, %esp
  d2nip_
  ret
