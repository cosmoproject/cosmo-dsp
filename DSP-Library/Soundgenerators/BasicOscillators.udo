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
    asig     vco2 kamp, kfreq, 12
    xout asig
endop

opcode Sine, a, kk
    kfreq, kamp xin
    asig     poscil kamp, kfreq
    xout asig
endop

opcode Pulse, a, kk 
    kfreq, kamp xin
    asig     vco2 kamp, kfreq, 6
    xout asig
endop

opcode WhiteNoise, a, k
    kamp xin
    awhite unirand 2.0
    ; Normalize to +/-1.0
    awhite = awhite - 1.0
    xout awhite*kamp
endop

opcode PinkNoise, a, k
    kamp xin
    apink pinker
    xout apink*kamp
endop


