<Cabbage>
form caption("COSMO Cabbage Tester") size(400, 400), colour(58, 110, 182), pluginID("cos1")
image bounds(0, 0,400,400), colour(100,150,205), shape("rounded"), outlinecolour("white"), outlinethickness(4) 

rslider bounds(0, 0, 100, 100), channel("P0"), text("Pot 0"), range(0, 1, 0), colour(  0, 40, 50), trackercolour(200,240,250), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(98, 0, 100, 100), channel("P1"), text("Pot 1"), range(0, 1, 0), colour(  0, 40, 50), trackercolour(200,240,250), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(196, 0, 100, 100), channel("P2"), text("Pot 2"), range(0, 1, 0), colour(  0, 40, 50), trackercolour(200,240,250), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(294, 0, 100, 100), channel("P3"), text("Pot 3"), range(0, 1, 0), colour(  0, 40, 50), trackercolour(200,240,250), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(0, 98, 100, 100), channel("P4"), text("Pot 4"), range(0, 1, 0), colour(  0, 40, 50), trackercolour(200,240,250), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(98, 98, 100, 100), channel("P5"), text("Pot 5"), range(0, 1, 0), colour(  0, 40, 50), trackercolour(200,240,250), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(196, 98, 100, 100), channel("P6"), text("Pot 6"), range(0, 1, 0), colour(  0, 40, 50), trackercolour(200,240,250), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(294, 98, 100, 100), channel("P7"), text("Pot 7"), range(0, 1, 0), colour(  0, 40, 50), trackercolour(200,240,250), outlinecolour(0, 0, 0, 50), textcolour("black")

button bounds(10, 210, 80, 42), channel("M0"), text("Switch 0 off", "Switch 0 on")
button bounds(108, 210, 80, 42), channel("M1"), text("Switch 1 off", "Switch 1 on")
button bounds(206, 210, 80, 42), channel("M2"), text("Switch 2 off", "Switch 2 on")
button bounds(304, 210, 80, 42), channel("M3"), text("Switch 3 off", "Switch 3 on")
checkbox bounds(10, 252, 82, 42), channel("L0")
checkbox bounds(108, 252, 82, 42), channel("L1")
checkbox bounds(206, 252, 82, 42), channel("L2")
checkbox bounds(304, 252, 82, 42), channel("L3")


button bounds(10, 306, 80, 42), channel("M4"), text("Switch 4 off", "Switch 4 on")
button bounds(108, 306, 80, 42), channel("M5"), text("Switch 5 off", "Switch 5 on")
button bounds(206, 306, 80, 42), channel("M6"), text("Switch 6 off", "Switch 6 on")
button bounds(304, 306, 80, 42), channel("M7"), text("Switch 7 off", "Switch 7 on")
checkbox bounds(10, 348, 82, 42), channel("L4")
checkbox bounds(108, 348, 82, 42), channel("L5")
checkbox bounds(206, 348, 82, 42), channel("L6")
checkbox bounds(304, 348, 82, 42), channel("L7")
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


#include "UDOs/Reverb.csd"
#include "UDOs/Lowpass.csd"
#include "UDOs/SquareMod.csd"
#include "UDOs/MultiDelay.csd"
#include "UDOs/TriggerDelay.csd"
#include "UDOs/Resonator.csd"
#include "UDOs/LiveLooper.csd"
#include "UDOs/SimpleLooper.csd"
#include "UDOs/SolinaChorus.csd"


instr 1

	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"

	gaL, gaR ins
	gadlyL = 0
	gadlyR = 0
;										bf 		bw	  gain   num     ksep    ksep2 sepmode scalemode
	;gaL, gaR Resonator gaL, gaR, gkpot0, gkpot1, 1,   gkpot2, gkpot3, gkpot4,   0,      2 

;	gadlyL, gadlyR TriggerDelay gaL, gaR, gkpot0, gkpot1, gkpot2, gkpot3, gkpot4, 1, 0.5, 0.5, gkpot5, gkpot6, gkpot7



;	Solina Chorus parameters:
;	aLeft, aRight, klfo_freq1, klfo_amp1, klfo_freq2, klfo_amp2, kstereo_mode xin
;	gaL, gaR solina_chorus_stereo gaL, gaR, 0.18, 0.6, 6, 0.2, 1


	gaL solina_chorus gaL, 0.18, 0.6, 6, 0.2
	gaR solina_chorus gaR, 0.18, 0.6, 6, 0.2


	gaL, gaR Reverb gaL, gaR, 0.8, 0.5, 0.3

;  	SimpleLooper parameters: 
;	ainL, ainR, kRecPlay, kStop, kStart, kClear, kSpeed
	gaLoopL, gaLoopR SimpleLooper gaL, gaR, gkswitch0, gkswitch1, 0, gkpot0, 1
	gaL = gaL + gaLoopL
	gaR = gaR + gaLoopR


	;aOutL = (gaL + gadlyL + gaLoopL)
	;aOutR = (gaR + gadlyR + gaLoopR)

	aOutL = gaL 
	aOutR = gaR 
	
	aOutL, aOutR Lowpass_Stereo aOutL, aOutR, 0.5

	;aOutL limit aOutL, 0.8, 0.95
	;aOutR limit aOutR, 0.8, 0.95
	outs aOutL, aOutR
	

endin


</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 

</CsScore>
</CsoundSynthesizer>