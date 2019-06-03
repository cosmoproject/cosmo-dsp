
opcode Saw, a, kk
    kfreq, kamp xin
    asig     vco2 kamp, kfreq
    xout asig
endop

opcode Square, a, kk
    kfreq, kamp xin
    asig     vco2 kamp, kfreq, 10
    xout asig
endop

opcode Tri, a, kk
    kfreq, kamp xin
    asig     vco2 kamp, kfreq, 10
    xout asig
endop

opcode Sine, a, kk
    kfreq, kamp xin
    asig     poscil kamp, kfreq
    xout asig
endop

opcode WNoise, a, k
    kamp xin
    awhite unirand 2.0
    ; Normalize to +/-1.0
    awhite = awhite - 1.0
    xout awhite
endop


; TODO put this into an FX
opcode AtanLimit, a, a
  ain xin
  aout = 2 * taninv(ain) / 3.1415927
  xout aout
endop
