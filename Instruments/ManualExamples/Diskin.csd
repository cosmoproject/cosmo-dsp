<CsoundSynthesizer>

<CsOptions>
-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B1024 --sched=99 
</CsOptions>

<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs=1

instr 1

ktrans linseg 1, 5, 2, 10, -2
a1, a2    diskin2 "SoundFiles/Cello Solo Legato - Short.aif", ktrans, 0, 1, 0, 32
       outs a1, a2

endin

</CsInstruments>
<CsScore>

i 1 0 15
e

</CsScore>
</CsoundSynthesizer>