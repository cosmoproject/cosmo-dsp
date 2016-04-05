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

button bounds(10, 210, 80, 42), channel("M0"), text("Switch 0 on", "Switch 0 off")
button bounds(108, 210, 80, 42), channel("M1"), text("Switch 1 on", "Switch 1 off")
button bounds(206, 210, 80, 42), channel("M2"), text("Switch 2 on", "Switch 2 off")
button bounds(304, 210, 80, 42), channel("M3"), text("Switch 3 on", "Switch 3 off")
checkbox bounds(10, 252, 82, 42), channel("L0")
checkbox bounds(108, 252, 82, 42), channel("L1")
checkbox bounds(206, 252, 82, 42), channel("L2")
checkbox bounds(304, 252, 82, 42), channel("L3")


button bounds(10, 306, 80, 42), channel("M4"), text("Switch 4 on", "Switch 4 off")
button bounds(108, 306, 80, 42), channel("M5"), text("Switch 5 on", "Switch 5 off")
button bounds(206, 306, 80, 42), channel("M6"), text("Switch 6 on", "Switch 6 off")
button bounds(304, 306, 80, 42), channel("M7"), text("Switch 7 on", "Switch 7 off")
checkbox bounds(10, 348, 82, 42), channel("L4")
checkbox bounds(108, 348, 82, 42), channel("L5")
checkbox bounds(206, 348, 82, 42), channel("L6")
checkbox bounds(304, 348, 82, 42), channel("L7")
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
;-n -d -+rtmidi=NULL -M0 -m0d
-d -n 
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
;#include "UDOs/Sine.csd"
#include "UDOs/Chorus.csd"
#include "UDOs/Reverse.csd"
#include "UDOs/SineDelay.csd"

instr 1 
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"
	#include "includes/switch2led.inc"

	gaL, gaR ins
	gadlyL = 0
	gadlyR = 0
;										bf 		bw	  gain   num     ksep    ksep2 sepmode scalemode
	;gaL, gaR Resonator gaL, gaR, gkpot0, gkpot1, 1,   gkpot2, gkpot3, gkpot4,   0,      2 


;  ainL, ainR, kRecord, kStop, kStart, kDryLevel, kLoopLevel, kLoopMode, kCFDuration, kShape xin

	; If rec, then stop playing
	if trigger(gkswitch0, 0.5, 1) == 1then 
		gkswitch2 = 1
	endif

	; if play then stop recording
	if trigger(gkswitch1, 0.5, 1) == 1 then
		gkswitch0 = 0
	endif

	; if stop then stop playing
	if trigger(gkswitch2, 0.5, 1) == 1 then
		gkswitch1 = 1
	endif



	;gaLoopL, gaLoopR LiveLooper_Stereo gaL, gaR, gkswitch0, gkswitch1, gkswitch2, 0, 1, 1, 1, 0.5

;	gadlyL, gadlyR TriggerDelay gaL, gaR, gkpot0, gkpot1, gkpot2, gkpot3, gkpot4, 1, 0.5, 0.5, gkpot5, gkpot6, gkpot7

	;gaL, gaR Reverb gaL, gaR, 0.8, 0.8, 0.3
/*
	gasin Sine 220
	gaL = gaL + gasin
*/
;	gaL = 0
;	gaR = 0



/*
		gadlyL, gadlyR MultiDelay_Stereo gaL, gaR, gkswitch3, gkpot5, gkpot6, 1, gkswitch2

		gaL, gaR Reverb gaL + gadlyL, gaR + gadlyR, gkpot1, gkswitch0
		gaL, gaR SquareMod gaL, gaR, gkpot0, gkswitch1
		gaL, gaR Lowpass_Stereo gaL, gaR, gkpot2, gkpot4
		gaL, gaR Reverb gaL, gaR, 0.8, 0.8, 0.3
*/		
;gaL, gaR Reverb gaL + gadlyL, gaR + gadlyR, gkpot1, gkswitch0
;gaL, gaR SquareMod gaL, gaR, gkpot0, gkswitch1
;gaL, gaR Chorus gaL, gaR, gkpot0
gaL SineDelay gaL, gkpot0
gaL Reverse gaL, 0.2
gaL SquareMod gaL, 0.2
;gaR SineDelay gaR, 0.4
	;aOutL = (gaL + gadlyL + gaLoopL)
	;aOutR = (gaR + gadlyR + gaLoopR)

	;aOutL = (gaL+ gaLoopL)
	;aOutR = (gaR+ gaLoopR)
	
	aOutL = gaL
	aOutR = gaR
	
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