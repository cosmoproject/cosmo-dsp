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

opcode DetunedSines, a, kkk
    kfreq, kamp, kratio xin
    asig1     poscil kamp, kfreq
    asig2     poscil kamp, kfreq * (kratio) ; 1.05
    asig = asig1 + asig2
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

opcode Crackl, a, kkk
    kfreq, kamp, kmodFreq xin

    aSawMod Pulse 3, 0.5
    kFreq = (9+k(aSawMod))
    aSaw1 Saw kFreq, 0.5
    aSq Square 6, 0.3
    aFiltMod Saw 14.4, 1000
    kFiltFreq = (2000+k(aFiltMod))
    aFilt clfilt aSaw1+aSq, kFiltFreq, 1, 6, 1, 3
    xout aFilt
endop
