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

# ( --  )
# enter interpreter mode
Forthword_ LBRACKET, IMMEDIATE_EN, "["
	call STATE
	jmp ZEROHSTORE
