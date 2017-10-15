# compiler.S

# ( -- addr )
# system state variable. 0 is interpret mode. Not 0 is compile mode
# is half word
Forthword_ STATE, 0, "state"
	douser_ state

Forthword_ STATEFETCH, 0, "state@"
	call STATE
	hfetch_
	ret

# ( -- addr )
# current vocabulary for new words
Forthword_ CURRENT, 0, "current"
	douser_ ram_CURRENT

# ( -- addr )
# context vocabulary for searching
# array of wordlists
Forthword_ CONTEXT, 0, "context"
	douser_ ram_CONTEXT


# ( -- addr )
# system SMUDGE. Get flash program address of latest word being compiled.
Forthword_ SMUDGE, 0, "smudge"
	douser_ COLON_SMUDGE

# ( -- f-addr )
# get address of the dictionary cell
Forthword_ DPSHARP, 0, "dp#"
	pushtos_
	movl $(ram_dp-sysvar_base), %ebx 
	add %ebp, %ebx
	ret

# ( -- f-addr )
# address of the next free dictionary cell
Forthword_ DP, 0, "dp"
	call DPSHARP
	fetch_
	ret

# ( --  )
# enter interpreter mode
Forthword_ LBRACKET, IMMEDIATE_EN, "["
	call STATE
	jmp ZEROHSTORE

# ( nfa -- lfa )
# get the link field address from the name field address
Forthword_ NFA2LFA, 0, "nfa>lfa"
	call STRINGLEN               # ( nfa+2 len+flags )
	# mask out flags in len, allow up to 31 characters
	and $31, %ebx                # ( nfa+2 len )
	plus_
	ret

# ( nfa -- [ 0 ] | [ xt xtflags] )
# convert name field address to xt and xtflags
Forthword_ NFATOXTF, 0, "nfa>xtf"
	dupzerosense_               # ( n )
	je NFATOXTF_EXIT

	dup_                        # ( nfa nfa )
	hfetch_                     # ( nfa xtflags )
	to_r_                       # ( nfa ) (R: xtflags)
	call NFA2LFA                # ( lfa )
	fourplus_   # lfa>xtlink    # ( xtlink )
	fetch_                      # ( xt )
	r_from_                     # ( xt xtflags )

NFATOXTF_EXIT:
	ret

# ( -- )
# set the context and current to root forth vocabulary and remove
# other vocabularies
Forthword_ ONLY, IMMEDIATE_EN, "only"
	# forth vocab always takes slot 0
	dolit_ EE_FORTHWORDLIST
	dup_
	call CONTEXT
	call STORE
	# make current also forth vocab
	call CURRENT
	call STORE
	# move index to next slot
	one_
	call CONTEXT
	twominus_
	call HSTORE
	# make second slot have no vocab
	call CONTEXT
	fourplus_
	jmp ZEROSTORE
