<Cabbage>
form caption("COSMO DSP: TapeDelay") size(540, 140), colour("white"), pluginID("crep")

rslider bounds(20, 20, 100, 100), channel("time"), range(0, 1, 0.2), text("Delay time"), trackercolour("navy"), textcolour("black")
rslider bounds(120, 20, 100, 100), channel("feed"), range(0, 1, 0.4), text("Feedback"), trackercolour("navy"), textcolour("black")
rslider bounds(220, 20, 100, 100), channel("filter"), range(0, 1, 0.5), text("Filter"), trackercolour("navy"), textcolour("black")
rslider bounds(320, 20, 100, 100), channel("mix"), range(0, 1, 0.4), text("Dry/wet mix"), trackercolour("navy"), textcolour("black")
rslider bounds(420, 20, 100, 100), channel("mode"), range(0, 1, 0), text("Stereo Mode"), trackercolour("navy"), textcolour("black")


</Cabbage>

<CabbageIncludes>
../Effects/TapeDelay.udo
</CabbageIncludes>

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

#include "../Effects/TapeDelay.udo"

instr 1

	kTime chnget "time"
    kFeed chnget "feed"
	kFilter chnget "filter"
	kMix chnget "mix"
    kMode chnget "mode"

	aL,aR ins

	; TapeDelay arguments: DelayTime, Feedback, Filter, Mix [, StereoMode]
	aL, aR TapeDelay aL, aR, kTime, kFeed, kFilter, kMix, kMode

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

