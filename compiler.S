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
