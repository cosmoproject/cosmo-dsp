<Cabbage>
form caption("COSMO DSP: Reverb") size(360, 140), colour("white"), pluginID("crvb")


rslider bounds(20, 	20,  100, 100), channel("decay"), range(0, 1, 0.6, 1, .01), text("Decay"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(120, 20, 100, 100), channel("cutoff"), range(0, 1, 0.5), text("Cutoff"), trackercolour("navy"), textcolour("black")
rslider bounds(240, 20, 100, 100), channel("mix"), range(0, 1, 0.5), text("Mix"), trackercolour("navy"), textcolour("black")

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

#include "../Effects/Reverb.udo"

instr 1

	kDecay chnget "decay"
	kCutoff chnget "cutoff"
	kMix chnget "mix"

	aL,aR ins

	; Reverb arguments: decay, cutoff, mix, mode
	aL, aR Reverb aL, aR, kDecay, kCutoff, kMix, 0 


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
