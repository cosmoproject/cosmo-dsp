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

#include "../Includes/cosmo_utilities.inc"

#include "../Effects/AnalogDelay.csd"
#include "../Effects/Blur.csd"
#include "../Effects/Chorus.csd"
#include "../Effects/Distortion.csd"
#include "../Effects/FakeGrainer.csd"
#include "../Effects/Hack.csd"
#include "../Effects/Lowpass.csd"
#include "../Effects/MultiDelay.csd"
#include "../Effects/PitchShifter.csd"
#include "../Effects/RandDelay.csd"
#include "../Effects/Repeater.csd"
#include "../Effects/Reverb.csd"
#include "../Effects/Reverse.csd"
#include "../Effects/SimpleLooper.csd"
#include "../Effects/SineDelay.csd"
#include "../Effects/SolinaChorus.csd"
#include "../Effects/Tremolo.csd"
#include "../Effects/TriggerDelay.csd"
#include "../Effects/Volume.csd"
#include "../Effects/Wobble.csd"




instr 1

	#include "../Includes/adc_channels.inc"
	#include "../Includes/gpio_channels.inc"

	aL, aR ins
	adlyL = 0
	adlyR = 0
;										bf 		bw	  gain   num     ksep    ksep2 sepmode scalemode
	;gaL, gaR Resonator gaL, gaR, gkpot0, gkpot1, 1,   gkpot2, gkpot3, gkpot4,   0,      2 

;	gadlyL, gadlyR TriggerDelay gaL, gaR, gkpot0, gkpot1, gkpot2, gkpot3, gkpot4, 1, 0.5, 0.5, gkpot5, gkpot6, gkpot7


;	Solina Chorus parameters:
;	Arguments: LFO1 Frequency, LFO1 Amp, LFO2 Frequency, LFO2 Amp, Dry/wet mix, [, Stereo mode on/off]
 	aL, aR SolinaChorus aL, aR, 0.18, 0.6, 6, 0.2, 1, 1


	aL, aR Reverb aL, aR, 0.8, 0.5, 0.3

;  	SimpleLooper  
;	Arguments: Record/Play, Stop/start, Speed, Reverse, Audio Through
	aLoopL, aLoopR, kPlaying, kRecing SimpleLooper aL, aR, gkswitch0, gkswitch1, 1, 0, 1
	aL = aL + aLoopL
	aR = aR + aLoopR


	;aOutL = (gaL + gadlyL + gaLoopL)
	;aOutR = (gaR + gadlyR + gaLoopR)

	aOutL = aL 
	aOutR = aR 
	
	aOutL, aOutR Lowpass aOutL, aOutR, 0.5


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