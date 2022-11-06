<Cabbage>
form caption("COSMO DSP: PitchShifter") size(460, 240), colour("white"), pluginID("camp")


rslider bounds(20, 	20,  100, 100), channel("semi"), range(0, 1, 0.5), text("Semitones"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(120, 20, 100, 100), channel("mix"), range(0, 1, 0.5), text("Dry/wet mix"), trackercolour("navy"), textcolour("black")

rslider bounds(20, 	120,  100, 100), channel("slide"), range(0, 1, 0), text("Slide"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(120, 120, 100, 100), channel("formant"), range(0, 1, 0), text("Formant"), trackercolour("navy"), textcolour("black")
rslider bounds(240, 120, 100, 100), channel("delay"), range(0, 1, 0), text("Delay"), trackercolour("navy"), textcolour("black")
rslider bounds(340, 120, 100, 100), channel("feed"), range(0, 1, 0), text("Feedback"), trackercolour("navy"), textcolour("black")


</Cabbage>

<CabbageIncludes>
../Effects/PitchShifter.udo
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

#include "../Effects/PitchShifter.udo"

instr 1

	kSemi chnget "semi"
	kMix chnget "mix"

    kSlide chnget "slide"
    kFormant chnget "formant"
    kDelay chnget "delay"
    kFeed chnget "feed"

	aL,aR ins

	; PitchShifter arguments: Semitones, Dry/wet mix [, Slide, Formant, Delay, Feedback]
	aL, aR PitchShifter aL, aR, kSemi, kMix, kSlide, kFormant, kDelay, kFeed

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
