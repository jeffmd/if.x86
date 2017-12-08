# compiler.S

# dictionary structure:
# length | flags : word: highbyte is flags, lowbyte is string length
# name : string
# previouse word: 32 bit pointer to previousely defined word
# code: 32 bit pointer to executable code

# ( -- state )
# system state variable. 0 is interpret mode. Not 0 is compile mode
Forthword_ STATE, 0, "state"
  user_ state
  hfetch_
  ret

# ( val -- )
Forthword_ STATESTORE, 0, "state!"
  push_
  user_ state
  hstore_
  ret

# ( -- )
# enter interpreter mode
Forthword_ LBRACKET, IMMEDIATE_EN, "["
  user_ state
  jmp ZERO_HSTR

# ( -- )
# enter compile mode
Forthword_ RBRACKET, 0, "]"
  one_
  jmp STATESTORE


# ( -- addr )
# current vocabulary for new words
Forthword_ CURRENT, 0, "current"
  user_ ram_CURRENT
  ret

# ( -- addr )
# context vocabulary for searching
# array of wordlists
Forthword_ CONTEXT, 0, "context"
  user_ ram_CONTEXT
  ret

# ( -- addr )
# system SMUDGE. Get flash program address of latest word being compiled.
Forthword_ SMUDGE, 0, "smudge"
  user_ COLON_SMUDGE
  fetch_
  ret
  
# ( addr -- )
# system SMUDGE. Get program address of latest word being compiled.
Forthword_ SMUDGE_STR, 0, "smudge!"
  push_
  user_ COLON_SMUDGE
  store_
  ret

# ( -- )
# system SMUDGE. Get program address of latest word being compiled.
Forthword_ ZERO_SMUDGE_STR, 0, "0smudge!"
  user_ COLON_SMUDGE
  zero_str_
  ret

# ( -- f-addr )
# get address of the dictionary cell
Forthword_ DPSHARP, 0, "dp#"
  user_ ram_dp
  ret

# ( -- f-addr )
# address of the next free dictionary cell
Forthword_ DP, 0, "dp"
  call DPSHARP
  fetch_
  ret

# ( offset -- )
# add offset to (dictionary pointer) DP
Forthword_ DPPLUS, 0, "dp+"
  push_
  call DPSHARP
  jmp PLUS_STR

# ( -- )
# increment 32 bit (dictionary pointer) DP by one cell
Forthword_ DPPLUSONE, 0, "dp+1"
  one_
  jmp DPPLUS

# ( -- f-addr )
# get address of the code cell
Forthword_ CPSHARP, 0, "cp#"
  user_ ram_cp
  ret

# ( -- f-addr )
# address of the next free code cell
Forthword_ CP, 0, "cp"
  call CPSHARP
  fetch_
  ret

# ( offset -- cp#)
# add offset to (code pointer) CP
Forthword_ CPPLUS, 0, "cp+"
  push_
  call CPSHARP
  jmp PLUS_STR

# ( -- )
# increment 32 bit (code pointer) CP by one cell
Forthword_ CPPLUSONE, 0, "cp+1"
  one_
  jmp CPPLUS

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
  cfetch_            # ( 0xe9 CP-5 inst )
  and $0xff, %eax
  cmp $0xe8, %eax
  je DO_JMPOPT
    nip2_
    jmp RET_C
DO_JMPOPT:
  pop_
  cstr_              # ( CP-5 )
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
  push_        # ( xt xt )
  call CURRENT # ( xt CURRENT )
  fetch_       # ( xt wid )
  store_       # ( wid )
  #call CLRCACHE
  # set smudge to zero indicating no longer compiling a word
  call ZERO_SMUDGE_STR # ( SMUDGE )
UWID_end:
  ret

# ( n -- )
# store 8 bit value in WR into code section ram at (code pointer) CP
Forthword_ COMMA, 0, ","
  push_            # ( n n )
  call CP          # ( n CP )
  cstr_            # ( CP )
  jmp CPPLUSONE    # 

# ( n -- )
# store double word 32 bit value in WR into code section ram at (code pointer) CP
Forthword_ DWCOMMA, 0, "dw,"
  push_
  call CP
  store_
  four_
  jmp CPPLUS

# ( n -- )
# store 32 bit value in WR into dictionary section ram at (dictionary pointer) DP
# automaticaly increment dp position by 4 bytes
Forthword_ DPSTORE, 0, "dp!"
  push_
  call DP
  store_
  four_
  jmp DPPLUS

# ( s-addr len len' d-addr -- d-addr+len)
# copies a counted string with flags from s-addr to d-addr
# returns destination address + len
Forthword_ COPYSTRING, 0, "copy$"
  rpusha_
  rpushb_
  str_b_             # ( s-addr len len' d-addr ) B: d-addr
  d0_                # ( s-addr len len' len')
  b_hstr_
  bhplus_
  d1_str_x_
  d2_str_a_          # ( s-addr ) A: addr
  cld
  rep movsb
  b_                 # ( s-addr+len )
  nip3_
  rpopb_
  rpopa_
  ret

# ( addr len len' -- )
# copies a counted string with flags to program ram
Forthword_ STRINGPROGSTORE, 0, "$cp!"
  push_
  call CP
  call COPYSTRING
  push_
  call CPSHARP
  store_
  ret

# ( addr len len' -- )
# copies a counted string with flags to dictionary ram
Forthword_ STRINGDICTSTORE, 0, "$dp!"
  push_
  call DP
  call COPYSTRING
  push_
  call DPSHARP
  store_
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
  str_x_             # ( source destination term ) X: term
  d0_str_b_          # ( source destination match ) B: destination
  d1_str_a_          # ( source destination match ) A: source
  # begin
CBU_BEGIN:
    a_cfetch_        # ( source destination byte )
    acplus_
    and $0xFF, %eax
    cmp %eax, %ecx    
    # until
    je CBU_DONE
    b_cstr_          # ( source destination byte ) [B]: byte
    bcplus_          # ( source destination byte ) B+1
    jmp CBU_BEGIN

CBU_DONE:
  d0_                # ( source destination destination )
  b_str_d0_          # ( source destination+count destination )
  minus_             # ( source count )
  nip_               # ( count )
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

# ( nfa -- lfa )
# get the link field address from the name field address
Forthword_ NFA2LFA, 0, "nfa>lfa"
  call STRINGLEN               # ( nfa+2 len+flags )
  # mask out flags in len, allow up to 31 characters
  and $31, %eax                # ( nfa+2 len )
  d0_str_y_                    # ( nfa+2 len ) Y: nfa+2
  addy_                        # ( nfa+2 nfa+2+len )
  nip_                         # ( nfa+2+len )
  ret

# ( nfa -- [ 0 ] | [ xt xtflags] )
# convert name field address to xt and xtflags
Forthword_ NFATOXTF, 0, "nfa>xtf"
  iszero_                     # ( n )
  je NFATOXTF_EXIT

  push_                       # ( nfa nfa )
  hfetch_                     # ( nfa xtflags )
  rpush_                      # ( nfa xtflags) (R: xtflags)
  pop_                        # ( nfa )
  call NFA2LFA                # ( lfa )
  fourplus_   # lfa>xtlink    # ( xtlink )
  fetch_                      # ( xt )
  push_                       # ( xt xt )
  rpop_                       # ( xt xtflags )

NFATOXTF_EXIT:
  ret

# ( -- )
# set the context and current to root forth vocabulary and remove
# other vocabularies
Forthword_ ONLY, IMMEDIATE_EN, "only"
  # forth vocab always takes slot 0
  one_                        # ( 1 )
  push_                       # ( 1 1 )
  lit_ EE_FORTHWORDLIST       # ( 1 FLIST )
  push2_                      # ( 1 FLIST FLIST FLIST )
  call CURRENT                # ( 1 FLIST FLIST CURRENT )
  store_                      # ( 1 FLIST CURRENT )
  # make current also forth vocab
  call CONTEXT                # ( 1 FLIST CONTEXT )
  store_                      # ( 1 CONTEXT )
  # move index to next slot
  twominus_                   # ( 1 CONTEXT-2 )
  hstore_                     # ( CONTEXT-2 )
  # make second slot have no vocab
  twoplus_                    # ( CONTEXT )
  fourplus_                   # ( CONTEXT+4 )
  zero_str_
  ret
