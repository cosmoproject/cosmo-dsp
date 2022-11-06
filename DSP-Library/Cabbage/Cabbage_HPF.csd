<Cabbage>
form caption("COSMO DSP: HPF") size(440, 140), colour("white"), pluginID("clpf")

rslider bounds(20, 20, 100, 100), channel("cutoff"), range(0, 1, 0.2), text("Cutoff"), trackercolour("navy"), textcolour("black")
rslider bounds(120, 20,  100, 100), channel("res"), range(0, 1, 0.2), text("Resonance"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(220, 20,  100, 100), channel("drive"), range(0, 1, 0), text("Drive"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(320, 20,  100, 100), channel("mode"), range(0, 1, 0), text("Mode"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")

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


#include "../Effects/Highpass.udo"

instr 1

    kCutoff chnget "cutoff"
    kRes chnget "res"
    kDrive chnget "drive"
    kMode chnget "mode"

	aL,aR ins

	; LPF arguments: Cutoff frequency, Resonance, Distortion [, Mode]
	aL, aR Highpass aL, aR, kCutoff, kRes, kDrive, kMode

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
