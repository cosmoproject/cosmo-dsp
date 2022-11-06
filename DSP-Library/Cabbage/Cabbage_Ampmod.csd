<Cabbage>
form caption("COSMO DSP: AmpMod") size(460, 240), colour("white"), pluginID("camp")


rslider bounds(20, 	20,  100, 100), channel("modfreq"), range(0, 1, 0.6, 1, .01), text("ModFreq"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(120, 20, 100, 100), channel("modoffset"), range(0, 1, 1), text("ModOffset"), trackercolour("navy"), textcolour("black")
rslider bounds(240, 20, 100, 100), channel("freqmulti"), range(0, 1, 0.5), text("FreqMulti"), trackercolour("navy"), textcolour("black")
rslider bounds(340, 20, 100, 100), channel("mix"), range(0, 1, 0.5), text("Mix"), trackercolour("navy"), textcolour("black")

rslider bounds(20, 	120,  100, 100), channel("mode"), range(0, 1, 0), text("Mode"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(120, 120, 100, 100), channel("modidx"), range(0, 1, 0), text("ModIdx"), trackercolour("navy"), textcolour("black")
rslider bounds(240, 120, 100, 100), channel("feed"), range(0, 1, 0), text("Feed"), trackercolour("navy"), textcolour("black")
rslider bounds(340, 120, 100, 100), channel("wave"), range(0, 1, 0), text("ModWave"), trackercolour("navy"), textcolour("black")


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

#include "../Effects/Ampmod.udo"

instr 1

	kModFreq chnget "modfreq"
	kModOffset chnget "modoffset"
    kFreqMulti chnget "freqmulti"
	kMix chnget "mix"

    kMode chnget "mode"
    kModIdx chnget "modidx"
    kFeed chnget "feed"
    kWave chnget "wave"

	aL,aR ins

	; AmpMod arguments: ModOffset, ModFreq, ModFreqMulti, Mix [, mode, ModIndex, Feed, ModWave]
	aL, aR Ampmod aL, aR, kModOffset, kModFreq, kFreqMulti, kMix, kMode, kModIdx, kFeed, kWave

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
