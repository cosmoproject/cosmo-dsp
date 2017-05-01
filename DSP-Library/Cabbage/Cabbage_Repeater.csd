/********************************************************

	Repeater.csd
	Author: Alex Hofmann
	COSMO UDO adaptation: Bernt Isak Wærstad

	Arguments: Range, Repeat time, On/off
    Defaults:  0, 0.8, 0

	Range: 0 - 1 (short or long repeat time)
	Repeat time: 0.1s - 0.5s (short) or 0.1s - 6s
	On/off: 0 - 1 (on above 0.5, off below)

	Description:
	Repeater effect with short and long range

********************************************************/

<Cabbage>
form caption("COSMO DSP: Repeater") size(340, 140), colour("white"), pluginID("crep")

rslider bounds(20, 20, 100, 100), channel("time"), range(0, 1, 0.1), text("Repeat time"), trackercolour("navy"), textcolour("black")
button bounds(120, 20,  100, 100), channel("range"), text("Range"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")
button bounds(220, 20,  100, 100), channel("onoff"), text("On/Off"), trackercolour("navy"), outlinecolour(0, 0, 0, 50), textcolour("black")

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

#include "../Includes/cosmo_utilities.inc"
#include "../Effects/Repeater.csd"

instr 1

	kRange chnget "range"
	kTime chnget "time"
	kOnOff chnget "onoff"


	aL,aR ins

	; Reverse arguments: reverse time, mix
	aL, aR Repeater aL, aR, kRange, kTime, kOnOff 


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

