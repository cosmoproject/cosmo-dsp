<CsoundSynthesizer>
<CsOptions>
-odac 
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 16
nchnls = 2

#include "Reverb.csd"


instr 1

	aL, aR ins

	aOutL, aOutR subinstr "Reverb", "ReverbOne", 0.5, 0.9, 6000

	outs aOutL, aOutR


endin

</CsInstruments>

<CsScore>
i1 0 86400
;i "Reverb" 0 10 "ReverbOne" 0.5 0.9 6000
</CsScore>

</CsoundSynthesizer>
