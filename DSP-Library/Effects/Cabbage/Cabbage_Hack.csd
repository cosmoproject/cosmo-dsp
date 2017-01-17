<Cabbage>
form caption("COSMO DSP: Hack") size(240, 140), colour("white"), pluginID("chac")


rslider bounds(20, 	20,  100, 100), channel("mix"), range(0, 1, 0.5), text("Mix"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(120, 20, 100, 100), channel("freq"), range(0, 1, 0.5), text("Frequency"), trackercolour("navy"), textcolour("black")

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

#include "../Hack.csd"

instr 1

	kMix chnget "mix"
	kFreq chnget "freq"

	aL,aR ins

	; Hack arguments: mix, frequency
	aL, aR Hack aL, aR, kMix, kFreq 


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
