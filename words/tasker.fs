\ tasker.fs : words for managing tasks

only 
vocabulary Tasker
Tasker definitions

\ maximum number of tasks
62 con maxtask
\ the active index into the task list
cvar tidx

\ count register for each task
\ is an array 
var tcnt
maxtask dcell* allot

( n -- tidx Y:n )
\ store current task index
: tidx=
  y=w tidx c@w=y
;

( -- n )
\ fetch task index: verifies index is valid
\ adjusts index if count is odd ?
: tidx@
  tidx c@   ( idx )
  \ verify index is below 63
  push push ( idx idx idx ) 
  maxtask > ( idx flag )
  if
    \ greater than 62 so 0
    0 tidx=
    y
  then
;

: cnt& ( idx -- cntaddr Y:offset)
  dcell* y=w tcnt w+=y
;

( idx -- cnt )
\ get count for a slot
\ idx: index of slot
: cnt@
  cnt& @
;

\ get the count for current task executing
( -- n )
: count
  tidx@ cnt@
;

\ increment tcnt array element using idx as index
( idx -- cnt& Y:count )
: cnt++
  cnt& y=@w y+=1 @w=y
;

( n idx -- )
\ set tcnt array element using idx as index
: cnt=
  popx cnt& @w=x
;

\ array of task slots in ram : max 31 tasks 62 bytes
\ array is a binary process tree
\                        0                          62.5 ms
\             1                      2              125 ms
\      3           4           5           6        250 ms
\   7     8     9    10     11   12     13   14     500 ms
\ 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30   1 s
\ 31 -                                          62  2 s
var tasks
maxtask dcell* allot

( -- )
\ increment task index to next task idx
\ assume array flat layout and next idx = idx*2 + 1
: tidx++
  tidx@ 2* 1+ 
  \ if slot count is odd then 1+
  x=w count 
  y= 1 w&=y w+=x 
  tidx= 
;

( idx -- taskaddr Y:offset )
\ get task address based on idx
: task&
  dcell* y=w tasks w+=y
;

( idx -- task )
\ get a task at idx slot
: task@
   task& @ 
;

( idx addr -- ) 
\ store a task in a slot
\ idx is the slot index range: 0 to 62
\ addr is xt of word to be executed
: task=
  x=w pop task& @w=x
;

\ store a task in a slot
\ example: 12 task mytask
\ places xt of mytask in slot 12
: task ( idx C: name -- )
  push ' task=
;

( idx -- )
\ clear task at idx slot
\ replaces task with noop
: taskclr 
  push ['] noop task=
;


( -- )
\ execute active task and step to next task
: taskex
  \ increment count for task slot
  tidx@ push cnt++
  d0 task@ exec
  tidx++
;

var lastms
\ how often in microseconds to execute a task
\ default to 62.5/6 ms 
var exms

( n -- lastms Y:n )
\ add offset to lastms
: lastms+=
  y=w            ( timediff Y:timediff ) 
  lastms x=@w
  x+=y @w=x      ( lastms )
;

( -- )
\ execute tasks.ex if tick time expired
: tick
  time lastms @    ( time lastms )
  y=w d0 w-=y d1=w ( timediff timediff Y:lastms )
  push exms @ u>   ( timediff flag )
  if
    lastms+=       ( lastms Y:timediff ) 
    taskex
  else
    y= 255 w&=y usleep
  then
;

( -- )
\ clear all tasks
: allclr
  \ iterate 0 to maxtask and clear tcnt[] and set tasks[] to noop
  0 tidx=          ( idx )
  pushy            ( 0 ? )
  begin
    0 push d1      ( idx 0 idx )
    cnt=           ( idx ? )
    d0 taskclr     ( idx ? )
    d0 1+ d0=w     ( idx+1 idx+1 )
    push maxtask > ( idx+1 flag ) 
  ?until
  nip
;

( -- )
\ start tasking
: run
  y= 10417 exms @w=y
  lastms y=0 @w=y
  ['] tick pause=
;

( -- )
\ reset tasker
\ all tasks are reset to noop
: reset
  allclr
  run
;

( -- )
\ stop tasks from running
: stop
  pause.clr
;
