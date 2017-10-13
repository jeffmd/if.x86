# interpret.S

# ( -- addr )
# terminal input buffer address
Forthword_ TIB, 0, "tib"
    douser_  ram_tib

# ( -- addr-half )
# variable holding the number of characters in TIB
# is half cell size
Forthword_ SHARPTIB, 0, "#tib"
    douser_ ram_sharptib

# ( -- addr len )
# address and current length of the input buffer
Forthword_ STIB, 0, "stib"
    call TIB
    call SHARPTIB
    hfetch_
    ret

# ( -- a-addr )
# index to current read position in input buffer
# is half cell size
Forthword_ G_IN, 0, ">in"
    douser_ user_g_in

# ( -- pauseaddr )
# get ram address of pause defer
Forthword_ PAUSEADDR, 0, "pause#"
    douser_ USER_PAUSE

# ( -- keyaddr )
# get ram address of key defer
Forthword_ KEYADDR, 0, "key#"
    douser_ USER_KEY

# ( -- keyfileaddr )
# get ram address of key file descriptor
Forthword_ KEYFILEADDR, 0, "keyf#"
    douser_ USER_KEYFILE

# ( -- argcaddr )
# get ram address of command line argument count
Forthword_ ARGCADDR, 0, "argc#"
    douser_ USER_ARGC

# ( -- cmd[]addr )
# get ram address of command line argument vector
Forthword_ ARGVADDR, 0, "argv#"
    douser_ USER_ARGV

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

# ( -- key )
# fetch key from deffered routine, should leave a single character
# on TOS if a key was pressed. If no key pressed then -1 is on TOS.
Forthword_ KEY, 0, "key"
  call KEYADDR
  fetch_
  jmp EXEC

# ( -- flag )
# receive a string of at most tibsize characters or cr/lf detected.
# flag will be true if input buffer needs to be processed ie interpreted
# flag will be false if more input needed
Forthword_ ACCEPT, 0, "accept"
    # <begin>
    call KEY        # ( k )
    dupzerosense_
    jg ACCEPT_haskey
    addl $1, %ebx
    ret

ACCEPT_haskey:
    # check for EOL
    cmp $10, %ebx
    # <if>
    jne ACCEPT_checkreturn
    ret

ACCEPT_checkreturn:
    cmp $13, %ebx     # ( k k 13 )
    # <if>
    jne ACCEPT_checkdelete
    ret

ACCEPT_checkdelete:
    # check delete
    cmp $127, %ebx     # ( k k 8 )
    # <if>
    jne ACCEPT_checkcontrol
    # delete previous character
    # check beginning of line
    # if cursor is 0 then at begining of input
    call SHARPTIB
    hfetch_           # ( k #tib )
    # <if>
    zerosense_        # ( k )
    jne ACCEPT_dodelete
    # at the beginning of the line, ignore this character
    drop_
    jmp ZERO

ACCEPT_dodelete:
    andl $8, %ebx
    dup_                # ( k k )
    call EMIT           # ( k )
    bl_                 # ( k bl )
    call EMIT           # ( k )
    call EMIT           # ( )
    # decrease cursor position by one
    call TRUE           # ( -1 )
    call SHARPTIB       # ( -1 #tibaddr )
    call PLUSHSTORE     # ( )
    jmp ACCEPT_checkmaxinput


ACCEPT_checkcontrol:
    # check for remaining control characters, replace them with blank
    cmp $32, %ebx          # ( k k bl )
    jge ACCEPT_echo
    drop_
    # replace control key with a space
    bl_

ACCEPT_echo:
    # emit the key
    dup_                   # ( k k)
    call EMIT              # ( k)
    # now store the key in the input buffer
    call STIB              # ( k tibaddr #tib)
    plus_                  # ( k tibaddr+#tib )
    call CSTORE            # ( )

    call SHARPTIB          # ( 1 #tibaddr )
    call ONEPLUSHSTORE     # ( )

ACCEPT_checkmaxinput:
    # check if max number of char input
    dolit_ TIBSIZE       # ( tibsize )
    call SHARPTIB        # ( tibsize #tibaddr )
    call HFETCH          # ( tibsize #tib)
    minus_               # ( tibsize-#tib)
    # <if>
    zerosense_           # ( )
    je ACCEPT_atmaxinput
    jmp ZERO

ACCEPT_atmaxinput:
    # max number of characters in input buffer so have it processed
    jmp TRUE
