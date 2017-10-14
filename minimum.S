# minimum.S

# ( -- a-addr )
# location of the cell containing the address of the next free ram location
Forthword_ HEREADDR, 0, "here#"
  douser_ USER_HERE

# ( -- a-addr )
# the address of the next free ram location
Forthword_ HERE, 0, "here"
  call HEREADDR
  fetch_
  ret

# ( -- a-addr )
# location of the cell containing the number conversion radix
Forthword_ BASE, 0, "base"
	douser_ USER_BASE

# ( n -- )
# save base
Forthword_ BASESTORE, 0, "base!"
	call BASE
	jmp HSTORE

# ( n -- )
# load base
Forthword_ BASEFETCH, 0, "base@"
	call BASE
	hfetch_
	ret

# ( -- )
# set base for number conversion to 2
Forthword_ BIN, 0, "bin"
    two_
    jmp BASESTORE


# ( -- )
# set base for numeric conversion to 10
Forthword_ DECIMAL, 0, "decimal"
    ten_
    jmp BASESTORE

# ( -- )
# set base for number conversion to 16
Forthword_ HEX, 0, "hex"
    dolit_ 16
    jmp BASESTORE

# ( -- addr)
# start address of return stack
Forthword_ RP0, 0, "rp0"
  douser_ rstack0

# ( -- )
# must be last word in core
Forthword_ WIPE, 0, "WIPE"
	dolit_ DPSTART
	call DPSHARP
	call STORE
	
	dolit_ EE_FORTHWORDLIST
	dup_
	call ZEROSTORE
	fourplus_
	call ZEROSTORE
	
	# init pause to noop
	dolit_ NOOP
	call PAUSEADDR
	call STORE
	
	dolit_ HERESTART
	call HEREADDR
	call STORE
	jmp ONLY    
