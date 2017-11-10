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
