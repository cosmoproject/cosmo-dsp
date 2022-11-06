<Cabbage>
form caption("COSMO DSP: Autopan") size(440, 140), colour("white"), pluginID("cpan")

rslider bounds(20, 20, 100, 100), channel("amount"), range(0, 1, 0.75), text("Amount"), trackercolour("navy"), textcolour("black")
rslider bounds(120, 20,  100, 100), channel("rate"), range(0, 1, 0.25), text("Rate"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(220, 20,  100, 100), channel("phase"), range(0, 1, 0.5), text("Phase"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(320, 20,  100, 100), channel("wave"), range(0, 1, 0), text("Wave"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")

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


#include "../Effects/Autopan.udo"

instr 1

    kAmount chnget "amount"
    kRate chnget "rate"
    kPhase chnget "phase"
    kWave chnget "wave"

	aL,aR ins

	; Autopan arguments: Amount, Rate, Phase [, Wave]
	aL, aR Autopan aL, aR, kAmount, kRate, kPhase, kWave 

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
