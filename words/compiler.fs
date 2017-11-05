\ compiler.fs 

\ force compile any word including immediate words
: [compile]
  'f cxt
; :ic


\ read the following cell from the executing word and append it
\ to the current dictionary position.
: (compile)  ( -- )
    r>r+     ( raddr ) ( R: raddr+1 )
    @        ( nfa )
    nfa>xtf  ( xt xtflags )
    cxt
;

\ compile into pending new word
: compile ( C: x "<spaces>name" -- )
  ['f] (compile) cxt
  find dw,
; :ic

( -- ) ( C: "<spaces>name" -- )
\ Dictionary
\ create a dictionary header that will push the address of the
\ data field of name.
\ is used in conjunction with does>
: create
    rword
    \ leave address after call on tos
    compile popret
;


\ copy the first character of the next word onto the stack
: char  ( "<spaces>name" -- c )
    pname
    drop
    c@
;

( -- c ) ( C: "<space>name" -- )
\ skip leading space delimites, place the first character
\ of the word on the stack
: [char]
    char
    lit
; immediate


( -- )
\ replace the instruction written by CREATE to call
\ the code that follows does>
\ does not return to caller
\ this is the runtime portion of does>
: (does>)
    \ change call at XT to code after (does>)
    \ code at XT is 'bl POPRET'
    \ want to change POPRET address to return address
    r>                        ( retaddr )
    \ get address of call POPRET
    \ get current word and then get its XT being compiled
    cur@ @                    ( retaddr nfa )
    nfa>lfa                   ( retaddr lfa )
    \ skip over lfa to get to xt field and load xt
    4 +  @                     ( retaddr xt )
    \ temp save cp on return stack
    cp >r
    \ set cp to xt
    dup cp#!                   ( retaddr xt )
    \ modify the call
    \ calc displacement
    reldst                    ( dst )
    \ compile a call instruction
    call,                       ( )
    \ restore cp
    r> cp#!                    ( )
;

( -- )
\ Compiler
\ organize the XT replacement to call other colon code
\ used in conjunction with create
\ ie: : name create .... does> .... ;
: does>
    compile (does>)
    \ compile pop return to tos which is used as 'THIS' pointer
    compile r>
; :ic

( -- xt )
\ Compiler
\ create an unnamed entry in the dictionary
: :noname
    cp ]
;

( -- start )
\ Compiler
\ places current dictionary position for forward
\ branch resolve on TOS and advances CP
: >mark
    cp
    5 cp+           \ advance CP to allow jmp
;

( start -- )
\ Compiler
\ do forward jump
: >jmp
    ?sp              ( start ) \ check stack integrety
    cp               ( start dest )
    jmpc             ( )
;

( -- dest )
\ Compiler
\ place destination for backward branch
: <mark
    cp            ( dest )
;

( dest -- )
\ Compiler
\ do backward jump
: <jmp
    ?sp            \ make sure there is something on the stack
    \ compile a jmp at current DP that jumps back to mark
    cp             \ ( dest start )
    swap           \ ( start dest )
    jmpc
    5 cp+           \ advance CP
;

\ Compiler
\ compile zerosense and conditional jump forward
: ?jmpc

    compile 0?       \ inline zerosense
    jne1,
;

\ compile dupzerosense and conditional jump forward
: ??jmpc
    compile ?0?
    jne1,
;


( f -- ) ( C: -- orig )
\ Compiler
\ start conditional branch
\ part of: if...[else]...then
: if
   ?jmpc
   >mark
; :ic

( f -- f ) ( C: -- orig )
\ Compiler
\ start conditional branch, don't consume flag
: ?if
    ??jmpc
    >mark
; :ic


( C: orig1 -- orig2 )
\ Compiler
\ resolve the forward reference and place
\ a new unresolved forward reference
\ part of: if...else...then
: else
    >mark         \ mark forward rjmp at end of true code
    swap          \ swap new mark with previouse mark
    >jmp          \ rjmp from previous mark to false code starting here
; :ic

( -- ) ( C: orig -- )
\ Compiler
\ finish if
\ part of: if...[else]...then
: then
    >jmp
; :ic


( -- ) ( C: -- dest )
\ Compiler
\ put the destination address for the backward branch:
\ part of: begin...while...repeat, begin...until, begin...again
: begin
    <mark
; :ic


( -- ) ( C: dest -- )
\ Compiler
\ compile a jump back to dest
\ part of: begin...again

: again
    <jmp
; :ic

( f -- ) ( C: dest -- orig dest )
\ Compiler
\ at runtime skip until repeat if non-true
\ part of: begin...while...repeat
: while
    [compile] if
    swap
; :ic

( f -- f) ( C: dest -- orig dest )
\ Compiler
\ at runtime skip until repeat if non-true, does not consume flag
\ part of: begin...?while...repeat
: ?while
    [compile] ?if
    swap
; :ic

( --  ) ( C: orig dest -- )
\ Compiler
\ continue execution at dest, resolve orig
\ part of: begin...while...repeat
: repeat
  [compile] again
  >jmp
; :ic


( f -- ) ( C: dest -- )
\ Compiler
\ finish begin with conditional branch,
\ leaves the loop if true flag at runtime
\ part of: begin...until
: until
    ?jmpc
    <jmp
; :ic

( f -- ) ( C: dest -- )
\ Compiler
\ finish begin with conditional branch,
\ leaves the loop if true flag at runtime
\ part of: begin...?until
: ?until
    ??jmpc
    <jmp
; :ic

( -- )
\ Compiler
\ perform a recursive call to the word currently being defined
\ compile the XT of the word currently
\ being defined into the dictionary
: recurse
  smudge @ nfa>xtf cxt  
; :ic

\ allocate or release n bytes of memory in RAM
: allot ( n -- )
    here + here# !
;

( x -- ) ( C: x "<spaces>name" -- )
\ create a constant in the dictionary
: con
    rword
    lit
    ret,
;


\ create a dictionary entry for a variable
\ and allocate 32 bit RAM
: var ( cchar -- )
    here
    con
    4 \ dcell
    allot
;

( cchar -- )
\ create a dictionary entry for a character variable
\ and allocate 1 byte RAM
: cvar
    here
    con
    1
    allot
;
