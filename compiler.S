# compiler.S

# ( -- addr )
# system SMUDGE. Get program address of latest word being compiled.
Forthword_ SMUDGE, 0, "smudge"
  user_ COLON_SMUDGE
  mw_
  ret
  
# ( addr -- )
# system SMUDGE. Set program address of latest word being compiled.
Forthword_ SMUDGE_STR, 0, "smudge="
  y_w_
  user_ COLON_SMUDGE
  mw_y_
  ret

# ( -- f-addr )
# get address of the dictionary cell
Forthword_ DPSHARP, 0, "dp#"
  user_ ram_dp
  ret

# ( -- f-addr )
# address of the next free dictionary cell
Forthword_ DP, 0, "dp"
  user_ ram_dp
  mw_
  ret

# ( offset -- )
# add offset to (dictionary pointer) DP
Forthword_ DPPLUS, 0, "dp+"
  y_w_
  call DPSHARP
  x_mw_
  x_plus_y_
  mw_x_
  ret

# ( -- f-addr )
# get address of the code cell
Forthword_ CPSHARP, 0, "cp#"
  user_ ram_cp
  ret

# ( -- f-addr )
# address of the next free code cell
Forthword_ CP, 0, "cp"
  user_ ram_cp
  mw_
  ret

# ( offset -- cp#)
# add offset to (code pointer) CP
Forthword_ CPPLUS, 0, "cp+"
  y_w_
  call CPSHARP
  x_mw_
  x_plus_y_
  mw_x_
  ret

# ( -- )
# turn last is call off
Forthword_ CALLOFF, 0, "calloff"
  # clear last is call flag
  andw $~(1<<LAST_IS_CALL_FB), fflags
  ret

# ( -- )
# turn optimization off
Forthword_ TAILOPTOFF, 0, "optoff"
  # set disable tail call optimize flag
  orw $(1<<DIS_CALL_OPT_FB), fflags
  ret

# ( -- )
# tail call optimize: change last call into jmp
Forthword_ TAILOPT, 0, ";opt"
  # optimize only if smudge is not zero
  call SMUDGE
  iszero_
  jne CHECK_DIS_CALL_OPT
  ret

CHECK_DIS_CALL_OPT:
  # check fflags to see if tail call optimization can be done
  testw $(1 << DIS_CALL_OPT_FB), fflags
  jz CHECK_LAST_IS_CALL
  # don't optimize tail call, just compile a ret.
    jmp RET_C          # ( )

CHECK_LAST_IS_CALL:
  testw $(1 << LAST_IS_CALL_FB), fflags
  jnz TAIL_CALL_OPTIMIZE
    jmp RET_C

TAIL_CALL_OPTIMIZE:
  # replace CP - 5 call instruction with 0xe9
  lit_ 0xe9          # ( 0xe9 )
  push_              # ( 0xe9 0xe9 )
  call CP            # ( 0xe9 CP )
  sub $5, %eax       # ( 0xe9 CP-5 )
  push_              # ( 0xe9 CP-5 CP-5 )
  # make sure current instruction is a call otherwise compile a return
  cmw_               # ( 0xe9 CP-5 inst )
  and $0xff, %eax
  cmp $0xe8, %eax
  je DO_JMPOPT
    nip2_
    jmp RET_C
DO_JMPOPT:
  d0_                # ( 0xe9 CP-5 CP-5 )
  y_d1_              # ( 0xe9 CP-5 CP-5 ) Y: 0xe9
  nip2_              # ( CP-5 )
  cmw_y_             # ( CP-5 )
  # clear last is call flag in fflags
  andw $~(1 << LAST_IS_CALL_FB), fflags
  ret

# ( -- )
# update wid from smudge if valid
Forthword_ UWID, 0, "uwid"
  call SMUDGE    # ( xt )
  iszero_        # ( xt )
  je UWID_end

  # wid.word = smudge
  y_w_         # ( xt ) Y:xt
  call CURRENT # ( CURRENT )
  mw_          # ( wid )
  mw_y_        # ( wid )
  #call CLRCACHE
  # set smudge to zero indicating no longer compiling a word
  zero_
  call SMUDGE_STR # ( SMUDGE )
UWID_end:
  ret

# ( n -- )
# store 8 bit value in WR into code section ram at (code pointer) CP
Forthword_ COMMA, 0, ","
  y_w_             # ( n )
  call CP          # ( CP )
  cmw_y_           # ( CP )
  one_
  jmp CPPLUS       # 

# ( n -- )
# store double word 32 bit value in WR into code section ram at (code pointer) CP
Forthword_ DWCOMMA, 0, "dw,"
  y_w_
  call CP
  mw_y_
  four_
  jmp CPPLUS

# ( n -- )
# store 32 bit value in WR into dictionary section ram at (dictionary pointer) DP
# automaticaly increment dp position by 4 bytes
Forthword_ DPSTORE, 0, "@dp="
  y_w_
  call DP
  mw_y_
  four_
  jmp DPPLUS

# ( s-addr len len' d-addr -- d-addr+len)
# copies a counted string with flags from s-addr to d-addr
# returns destination address + len
Forthword_ COPYSTRING, 0, "copy$"
  rpusha_
  rpushb_
  b_w_               # ( s-addr len len' d-addr ) B: d-addr
  d0_                # ( s-addr len len' len')
  hmb_w_
  b_plus2_
  x_d1_
  a_d2_              # ( s-addr ) A: addr
  cld
  rep movsb
  b_                 # ( s-addr+len )
  nip3_
  rpopb_
  rpopa_
  ret

# ( addr len len' -- )
# copies a counted string with flags to program ram
Forthword_ STRINGPROGSTORE, 0, "@cp=$"
  push_
  call CP
  call COPYSTRING
  y_w_
  call CPSHARP
  mw_y_
  ret

# ( addr len len' -- )
# copies a counted string with flags to dictionary ram
Forthword_ STRINGDICTSTORE, 0, "@dp=$"
  push_
  call DP
  call COPYSTRING
  y_w_
  call DPSHARP
  mw_y_
  ret

# ( source destination term -- count )
# copy bytes from source to destination until match is made
# term is the 8 bit value that terminates copy operation
# source is the start address of the source in ram
# destination is the start address of where memory is copied to
# the copy/search goes up in ram address space
# count is the number of bytes copied
Forthword_ COPY_BYTE_UNTIL, 0, "copy.byte.until"
  # fetch from ram and check if equal to match byte
  rpusha_
  rpushb_
  x_w_               # ( source destination term ) X: term
  b_d0_              # ( source destination match ) B: destination
  a_d1_              # ( source destination match ) A: source
  # begin
CBU_BEGIN:
    cma_             # ( source destination byte )
    a_plus1_
    and $0xFF, %eax
    cmp %eax, %ecx    
    # until
    je CBU_DONE
    cmb_w_           # ( source destination byte ) [B]: byte
    b_plus1_         # ( source destination byte ) B+1
    jmp CBU_BEGIN

CBU_DONE:
  y_d0_              # ( source destination byte ) Y: destination
  nip2_              # ( byte )
  b_                 # ( destination+count )
  w_minus_y_         # ( count )
  rpopb_
  rpopa_
  ret

# ( start -- )
# copy code to current dictionary entry
Forthword_ INLINE, 0, "inline"
  # find the ret instruction, want count to ret
  # count will be number of bytes to inline
  push_                    # ( start start )
  call CP                  # ( start cp )
  push_                    # ( start cp cp )
  lit_ 0xc3                # ( start cp 0xc3 )
  call COPY_BYTE_UNTIL     # ( count )
  jmp CPPLUS
