\ core.fs - core words


\ ( "ccc<paren>" -- )
\ Compiler
\ skip everything up to the closing bracket on the same line
: (
    push          \ ( ?  ? )
    $29 parse     \ ( ?  addr u )
    pop2          \ ( ? )
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
: dp#! ( addr -- )
    push dp# !
;

\ store address of the next free code cell
: cp#! ( addr -- )
    push cp# !
;


( -- ) ( C: x "<spaces>name" -- )
\ create a dictionary entry and register in word list
: rword
    (create)      ( nfa )
    push cur@     ( nfa wid )
    !             ( )
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

\ search dictionary for name, returns XT or 0
: 'f  ( "<spaces>name" -- XT XTflags )
    pname
    findw
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
    lit,
; :ic


( -- ) ( C: "<space>name" -- )
\ Compiler
\ what 'f does in the interpreter mode, do in colon definitions
\ and xt and flag are compiled as two literals
: ['f]
    'f
    swap
    lit,
    \ compile literal of 'f push
    [ 'f push swap lit, ]
    push
    [ pop lit, ]
    cxt
    pop lit,
; :ic


( C:"<spaces>name" -- 0 | nfa )
\ Dictionary
\ search dictionary for name, returns nfa if found or 0 if not found
: find
    pname findw
;
