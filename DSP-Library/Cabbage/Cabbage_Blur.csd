<Cabbage>
form caption("COSMO DSP: Blur") size(440, 140), colour("white"), pluginID("cblu")

rslider bounds(20, 20, 100, 100), channel("time"), range(0, 1, 0.2), text("Blur time"), trackercolour("navy"), textcolour("black")
rslider bounds(120, 20,  100, 100), channel("gain"), range(0, 1, 0), text("Gain"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(220, 20,  100, 100), channel("mix"), range(0, 1, 0.8), text("Mix"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")

button bounds(325, 35,  100, 50), channel("stereo_mode"), range(0, 1, 1), text("Stereo Mode"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")

</Cabbage>

/********************************************************

	Arguments: Blur time, Gain, StereoMode, Dry/wet mix
    Defaults:  0.2, 0, 1, 0.8

	Blur time: 0.1s - 3s
	Gain: 1 - 5
	Stereo Mode: 0 - 1 (off below 0.5, on above)
	Dry/wet mix: 0% - 100%

********************************************************/

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

#include "../Effects/Blur.csd"

instr 1

	kTime chnget "time"
	kGain chnget "gain"
	kStereoMode chnget "stereo_mode"
	kMix chnget "mix"


	aL,aR ins

	; Blur arguments: blur time, mix
	aL, aR Blur aL, aR, kTime, kGain, kStereoMode, kMix 


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
