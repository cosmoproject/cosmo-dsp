<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B512 -+rtmidi=alsa -Ma -m0
-odac -iadc0 -Ma
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

	#include "Includes/cosmo_utilities.inc"	

	#include "Effects/Blur.csd"
	#include "Effects/Chorus.csd"
	#include "Effects/Distortion.csd"
	#include "Effects/FakeGrainer.csd"
	#include "Effects/Hack.csd"
	#include "Effects/Lowpass.csd"
	#include "Effects/MultiDelay.csd"
	#include "Effects/RandDelay.csd"
	#include "Effects/Resonator.csd"
	#include "Effects/Reverb.csd"
	#include "Effects/Reverse.csd"
	#include "Effects/SimpleLooper.csd"
	#include "Effects/SineDelay.csd"
	#include "Effects/SolinaChorus.csd"
	#include "Effects/SquareMod.csd"
	#include "Effects/TriggerDelay.csd"
	#include "Effects/Wobble.csd"

massign 1, 90
massign 1, 91

	#include "Instruments/SineSynths.csd"
	#include "Instruments/StringSynth.csd"
	/*
	#include "Instruments/Moogish.csd"
	#include "Instruments/CrazyPluck.csd"
	#include "Instruments/Scanned.csd"
	#include "Instruments/Simpler.csd"
*/



instr 90

	kmix ctrl7 7, 1, 0, 1

	iamp ampmidi 0.3
	icps cpsmidi

	aL = 0
	aR = 0
	a2L = 0
	a2R = 0

	irel = 1.5

	aL, aR StringSynth aL, aR, iamp, icps*1, irel
	aL, aR StringSynth aL, aR, iamp * 0.3, icps*2, irel
	aL, aR StringSynth aL, aR, iamp * 0.15, icps*3, irel

	xtratim irel 

	aL *= kmix
	aR *= kmix


	a2L, a2R SineSynth1 a2L, a2R, iamp, icps*1, irel
	a2L, a2R SineSynth1 a2L, a2R, iamp, icps*2.1, irel
	a2L, a2R SineSynth1 a2L, a2R, iamp, icps*3.3, irel

	a2L *= (1-kmix)
	a2R *= (1-kmix)

	chnmix aL+a2L, "MasterL"
	chnmix aR+a2R, "MasterR"

endin

instr 91

	kmix ctrl7 7, 1, 0, 1

	iamp ampmidi 0.3
	icps cpsmidi

	aL = 0
	aR = 0

	irel = 1.5



	xtratim irel 

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endin
instr 99
	#include "Includes/adc_channels.inc"
	#include "Includes/gpio_channels.inc"

	aL init 0
	aR init 0
	aL chnget "MasterL"
	aR chnget "MasterR"
	a0 = 0
	chnset a0, "MasterL"
	chnset a0, "MasterR"


	aL, aR Reverb aL, aR, 0.85, 0.5, 0.5

	aL SolinaChorus aL, 0.18, 0.6, 0.3, 0.2, 0.5
	aR SolinaChorus aR, 0.18, 0.6, 0.3, 0.2, 0.5

	; Reverb arguments: decay, cutoff, mix
	arvbL, arvbR Reverb aL, aR, gkpot0, gkpot1, gkpot7
	
	aL ntrpol aL, arvbL, 0.8
	aR ntrpol aR, arvbR, 0.8

	; Lowpass_Stereo arguments: cutoff, resonance
	;aL, aR Lowpass_Stereo aL, aR, gkpot2, gkpot3

	outs aL, aR

endin

; --------------------------------------------------------
; Status LED - set LEDs to ON for 2 seconds to 
; indicate that Csound is running 
; --------------------------------------------------------

instr 999

k1 poscil 1, 0.5

gkled0 = k1
gkled1 = k1


endin

</CsInstruments>
<CsScore>
i999 0 2
i99 0 86400
</CsScore>
</CsoundSynthesizer>


