<Cabbage>
form caption("COSMO DSP: Repeater") size(440, 140), colour("white"), pluginID("crep")

rslider bounds(20, 20, 100, 100), channel("time"), range(0, 1, 0.1), text("Repeat time"), trackercolour("navy"), textcolour("black")
button bounds(120, 20,  100, 100), channel("range"), text("Short/Long"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
button bounds(220, 20,  100, 100), channel("onoff"), text("On/Off"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
button bounds(320, 20,  100, 100), channel("mixmode"), text("Insert/Mix"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")

</Cabbage>

<CabbageIncludes>
../Includes/cosmo_utilities.inc
../Effects/Repeater.csd
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

#include "../Effects/Repeater.udo"

instr 1

	kRange chnget "range"
	kTime = 0;chnget "time"
	kOnOff = 0;chnget "onoff"
	kMixMode = 0;chnget "mixmode"

	aL,aR ins

	; Reverse arguments: reverse time, mix
	aL, aR Repeater aL, aR, kRange, kTime, kOnOff, kMixMode

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

