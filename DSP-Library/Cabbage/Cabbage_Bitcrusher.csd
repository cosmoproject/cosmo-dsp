<Cabbage>
form caption("COSMO DSP: Bitcrusher") size(440, 140), colour("white"), pluginID("cbit")

rslider bounds(20, 20, 100, 100), channel("bits"), range(0, 1, 0.5), text("Bits"), trackercolour("navy"), textcolour("black")
rslider bounds(120, 20,  100, 100), channel("fold"), range(0, 1, 0), text("Fold"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(220, 20,  100, 100), channel("level"), range(0, 1, 0.75), text("Level"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(320, 20,  100, 100), channel("mix"), range(0, 1, 1), text("Dry/Wet Mix"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")

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


#include "../Effects/Bitcrusher.udo"

instr 1

	kBits chnget "bits"
	kFold chnget "fold"
	kLevel chnget "level"
	kMix chnget "mix"

	aL,aR ins

	; Bitcrusher arguments: Bits, Fold, Level, DryWet_Mix
	aL, aR Bitcrusher aL, aR, kBits, kFold, kLevel, kMix

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
