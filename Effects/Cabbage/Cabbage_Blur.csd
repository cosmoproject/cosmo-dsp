<Cabbage>
form caption("COSMO DSP: Blur") size(240, 140), colour("white"), pluginID("cblu")

rslider bounds(20, 20, 100, 100), channel("time"), range(0, 1, 0.5), text("Blur time"), trackercolour("navy"), textcolour("black")
rslider bounds(120, 20,  100, 100), channel("mix"), range(0, 1, 0.5), text("Mix"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

#include "../UDOs/Blur.csd"

instr 1

	kTime chnget "time"
	kMix chnget "mix"


	aL,aR ins

	; Blur arguments: blur time, mix
	aL, aR Blur aL, aR, kTime, kMix 


outs aL, aR
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>
