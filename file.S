# file.S - words used to work with files and shared libraries

# ( path flags -- filedes )
# open a file
# path - address of path string null terminated
# option flags 
#Forthword_ OPENF, 0, "open"
#  rpush_        # flags
#  rpushd0_      # path
#  call open
#  rnip2_
#  nip_
#  ret

# ( filedes -- )
# open a file
# filedes - file descriptor
#Forthword_ CLOSEF, 0, "close"
#  rpush_        # filedes
#  call close
#  rnip_
#  ret

# (  filedes buffer length -- bytesread )
# fetch bytes from an open file using filedes
# number of bytes read left in WR
#Forthword_ READF, 0, "read"
#  rpush_        # length
#  rpushd0_      # buffer
#  rpushd1_      # filedes
#  call read 
#  rnip3_
#  nip2_
#  ret

# (  filedes buffer length -- bytesread )
# write bytes to an open file using filedes
# number of bytes written left in WR
#Forthword_ WRITEF, 0, "write"
#  rpush_        # length
#  rpushd0_      # buffer
#  rpushd1_      # filedes
#  call write 
#  rnip3_
#  nip2_
#  ret
