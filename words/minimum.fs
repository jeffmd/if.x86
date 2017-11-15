\ minimum.fs Forth words that make up minimum forth vocabulary


( n min max -- f)
\ check if n is within min..max
: within
    over - >a - a u<
;

\ emits a space (bl)
: space ( -- )
    bl emit
;

\ emits n space(s) (bl)
\ only accepts positive values
: spaces ( n -- )
    \ make sure a positive number
    dup 0> and
    begin
    ?while
      space
      1- 
    repeat
    drop
;

\ pointer to current write position
\ in the Pictured Numeric Output buffer
var hld


\ prepend character to pictured numeric output buffer
: hold ( c -- )
    -1 hld +!   
    hld @ c!
;

\ Address of the temporary scratch buffer.
: pad ( -- a-addr )
    here 20 +
;

\ initialize the pictured numeric output conversion process
: <# ( -- )
    pad hld !
;

\ pictured numeric output: convert one digit
: # ( u1 -- u2 )
    base@      ( u1 base )
    u/mod      ( rem u2 )
    swap       ( u2 rem )
    #h hold    ( u2 )
;

\ pictured numeric output: convert all digits until 0 (zero) is reached
: #s ( u -- 0 )
    #
    begin
    ?while
      #
    repeat
;

\ Pictured Numeric Output: convert PNO buffer into an string
: #> ( u1 -- addr count )
    drop hld @ pad over -
;

\ place a - in HLD if n is negative
: sign ( n -- )
    0< if [char] - hold then
;

\ singed PNO with cell numbers, right aligned in width w
: .r ( wantsign n w -- )
    >r   ( wantsign n ) ( R: w )
    <#
    #s   ( wantsign 0 )
    swap ( 0 wantsign )
    sign ( 0 )
    #>   ( addr len )
    r>   ( addr len w )  ( R: )
    over ( addr len w len )
    -    ( addr len spaces )
    spaces ( addr len )
    type  ( )
    space
;

\ unsigned PNO with single cell numbers
: u. ( u -- )
    0      ( n 0 ) \ want unsigned
    tuck   ( 0 n 0 )
    .r 
;


\ singed PNO with single cell numbers
: .  ( n -- )
    dup      ( n n )
    abs      ( n n' )
    0        ( n n' 0 ) \ not right aligned
    .r
;

: .s  ( -- )
    sp@         ( limit ) \ setup limit
    dcell-
    sp0         ( limit counter )
    begin
      dcell-    ( limit counter-4 )
      2over     ( limit counter-4 limit counter-4 )
      <>        ( limit counter-4 flag )
      while
        dup     ( limit counter-4 counter-4 )
        @       ( limit counter-4 val )
        u.      ( limit counter-4 )
    repeat
    2drop
;
