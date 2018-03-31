# minimum.S

# ( -- )
Forthword_ WIPE, 0, "WIPE"
  lit_y_ DPSTART
  call DPSHARP
  yw_str_

  lit_y_ CPSTART
  call CPSHARP
  yw_str_

  lit_ EE_FORTHWORDLIST
  zero_str_
  fourplus_
  zero_str_

  # init pause to noop
  lit_y_ NOOP
  call PAUSEADDR
  yw_str_

  lit_y_ HERESTART
  call HEREADDR
  yw_str_
  
  jmp ONLY
