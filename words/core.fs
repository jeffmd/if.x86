\ core.fs - core words


\ ( "ccc<paren>" -- )
\ Compiler
\ skip everything up to the closing bracket on the same line
: (
    push          \ ( ?  ? )
    $29 parse     \ ( ?  addr u )
    nip pop       \ ( ? )
; immediate


( -- )
\ make most current word compile only
: :c
    $F7FF widf
; immediate

( -- )
\ make most current word inlinned
: inlined
    $FEFF widf
; immediate

( -- )
\ make most current word immediate and compile only
: :ic
    $77FF widf
; immediate

\ store address of the next free dictionary cell
: dp= ( addr -- )
    y=w dp# @w=y
;

\ store address of the next free code cell
: cp= ( addr -- )
    y=w cp# @w=y
;


( -- ) ( C: x "<spaces>name" -- )
\ create a dictionary entry and register in word list
: rword
    (create)      ( nfa )
    y=w cur@       ( wid Y:nfa )
    @w=y           ( wid )
;

( -- dcell )
\ push data stack cell size 
rword dcell inlined
    ] 4 [
    ret,

( n -- n+dcell )
\ add data stack cell size to n
rword dcell+ inlined
    ] 4+ [
    ret,

( n -- n-dcell )
\ subtract data stack cell size from n
rword dcell- inlined
    ] 4- [
    ret,

( n -- n*dcell )
\ multiply n by data stack cell size 
rword dcell* inlined
    ] 4* [
    ret,

( C:"<spaces>name" -- 0 | nfa )
\ Dictionary
\ search dictionary for name, returns nfa if found or 0 if not found
: find
    pname findw
;

\ search dictionary for name, returns XT or 0
: 'f  ( "<spaces>name" -- XT XTflags )
    find
    nfa>xtf
;

\ search dictionary for name, returns XT
: '  ( "<spaces>name" -- XT )
    'f
    pop
;

( -- ) ( C: "<space>name" -- )
\ Compiler
\ what ' does in the interpreter mode, do in colon definitions
\ compiles xt as literal
: [']
    '
    w=,
; :ic


( -- ) ( C: "<space>name" -- )
\ Compiler
\ what 'f does in the interpreter mode, do in colon definitions
\ and xt and flag are compiled as two literals
: ['f]
    'f
    push d1
    w=,
    \ compile literal of 'f push
    [ 'f push push d1 w=, ]
    push
    [ d0 w=, pop ]
    cxt
    d0 w=, pop
; :ic
