\ core.fs - core words


\ ( "ccc<paren>" -- )
\ Compiler
\ skip everything up to the closing bracket on the same line
: (
    d=            \ ( ?  ? )
    $29 parse     \ ( ?  addr u )
    d-1 d         \ ( ? )
; immediate


( -- )
\ make most current word compile only
: :c
    $F7FF widf
;

( -- )
\ make most current word inlinned
: inlined
    $FEFF widf
;

( -- )
\ make most current word immediate and compile only
: :ic
    $77FF widf
;

\ store address of the next free dictionary cell
: dp= ( addr -- )
    y= dp# @=y
;

\ store address of the next free code cell
: cp= ( addr -- )
    y= cp# @=y
;


( -- ) ( C: x "<spaces>name" -- )
\ create a dictionary entry and register in word list
: rword
    (create)      ( nfa )
    y= cur@       ( wid Y:nfa )
    @=y           ( wid )
;

( -- dcell )
\ push data stack cell size 
rword dcell inlined
    ] 4 [
    ret,

( n -- n+dcell )
\ add data stack cell size to n
rword +dcell inlined
    ] +4 [
    ret,

( n -- n-dcell )
\ subtract data stack cell size from n
rword -dcell inlined
    ] 4- [
    ret,

( n -- n*dcell )
\ multiply n by data stack cell size 
rword *dcell inlined
    ] *4 [
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
    'f d
;

( -- ) ( C: "<space>name" -- )
\ Compiler
\ what ' does in the interpreter mode, do in colon definitions
\ compiles xt as literal
: [']
    ' #,
; :ic


( -- ) ( C: "<space>name" -- )
\ Compiler
\ what 'f does in the interpreter mode, do in colon definitions
\ and xt and flag are compiled as two literals
: ['f]
    'f
    d= d1
    #,
    \ compile literal of 'f push
    [ 'f d= d= d1 #, ]
    d=
    [ d0 #, d-1 d ]
    cxt
    d0 #, d-1 d
; :ic
