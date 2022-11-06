<Cabbage>
form caption("COSMO DSP: SSB") size(460, 140), colour("white"), pluginID("cssb")


rslider bounds(20, 	20,  100, 100), channel("modfreq"), range(0, 1, 0.6, 1, .01), text("ModFreq"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(120, 20, 100, 100), channel("balance"), range(0, 1, 0.5), text("Balance"), trackercolour("navy"), textcolour("black")
rslider bounds(240, 20, 100, 100), channel("freqmulti"), range(0, 1, 0.5), text("FreqMulti"), trackercolour("navy"), textcolour("black")
rslider bounds(340, 20, 100, 100), channel("mix"), range(0, 1, 0.5), text("Mix"), trackercolour("navy"), textcolour("black")


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

#include "../Effects/SSB.udo"

instr 1

	kModFreq chnget "modfreq"
	kBalance chnget "balance"
    kFreqMulti chnget "freqmulti"
	kMix chnget "mix"

	aL,aR ins

	; SSB arguments: ModFreq, ModFreqMulti, Balance, Mix 
	aL, aR SSB aL, aR, kModFreq, kFreqMulti, kBalance, kMix

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
