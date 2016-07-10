<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B256 -+rtmidi=alsa -Ma -m0
;-odac -iadc0 -Ma
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2


	#include "../Effects/UDOs/Blur.csd"
	#include "../Effects/UDOs/Chorus.csd"
	#include "../Effects/UDOs/Convolution.csd"
	#include "../Effects/UDOs/Distortion.csd"
	#include "../Effects/UDOs/FakeGrainer.csd"
	#include "../Effects/UDOs/Hack.csd"
	#include "../Effects/UDOs/Lowpass.csd"
	#include "../Effects/UDOs/MultiDelay.csd"
	#include "../Effects/UDOs/Octaver.csd"
	#include "../Effects/UDOs/RandDelay.csd"
	#include "../Effects/UDOs/Resonator.csd"
	#include "../Effects/UDOs/Reverb.csd"
	#include "../Effects/UDOs/Reverse.csd"
	#include "../Effects/UDOs/SimpleLooper.csd"
	#include "../Effects/UDOs/SineDelay.csd"
	#include "../Effects/UDOs/SolinaChorus.csd"
	#include "../Effects/UDOs/SquareMod.csd"
	#include "../Effects/UDOs/TriggerDelay.csd"
	#include "../Effects/UDOs/Wobble.csd"


opcode StringSynth, aa, aaii

ainL, ainR, iamp, icps xin


	kampenv = madsr:k(1, 0.1, 0.95, 0.5)
	asig = vco2(0.5, icps)
	asig = moogladder2(asig, 6000, 0.1)

	asig *= kampenv * iamp 

	aL, aR pan2 asig, 0.55

	xout aL + ainL, aR + ainR


endop



opcode SineSynth1, aa, aaii

ainL,ainR,iamp, icps xin

	ampenv = madsr:a(1, 0.1, 0.95, 0.5)
	a1 oscil 0.5, icps

	a1 *= ampenv * iamp 

	aL, aR pan2 a1, 0.55

	xout aL + ainL, aR + ainR
endop


opcode PolySineSynth1, aa, aaiikk

ainL,ainR,iamp, icps, iattack, irelease xin

	print iattack
	print irelease

	kampenv = madsr:k(iattack, 0.1, iamp, irelease)
	a1 oscil 0.5, icps
	a2 oscil 0.3, icps * 1.5
	a3 oscil 0.2, icps * 2

	asynth = a1+a2+a3

	asynth *= kampenv

	aL, aR pan2 asynth, 0.55

	xtratim irelease + 1/kr

	xout aL + ainL, aR + ainR
endop



instr 1
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"

	iamp ampmidi 0.5
	icps cpsmidi

	aL = 0
	aR = 0

	katck = (gkpot2 * 2)+0.01
	krel = (gkpot2) + 0.1
	aL, aR PolySineSynth1 aL, aR, iamp, icps, i(katck), i(krel)

	;aL, aR StringSynth aL, aR, iamp, icps

	;aL, aR SineSynth1 aL, aR, iamp, icps*2.1

	;aL, aR SineSynth1 aL, aR, iamp, icps*3.3

	xtratim 1/kr

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"
endin


instr 99
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"

	aL init 0
	aR init 0
	aL chnget "MasterL"
	aR chnget "MasterR"
	a0 = 0
	chnset a0, "MasterL"
	chnset a0, "MasterR"


	; Reverse arguments: time, drywet/bypass
	aL, aR Reverse aL, aR, 0.6, gkswitch2

	; Distortion arguments: level, drive, tone
	aL, aR Distortion aL, aR, 0.8, gkpot0, 0.5

	; Hack arguments: drywet, freq
	kHack = gkpot1 < 0.1 ? 0 : 1
	aL, aR Hack aL, aR, kHack, gkpot1

	; RandDelay arguments: range, feedback, mix
	kRandDly = gkpot3 > 0.5 ? 1 : gkpot3
	kRandDly = kRandDly < 0.1 ? 0 : kRandDly
	aL, aR RandDelay aL, aR, gkpot3, 0.4, kRandDly 


	aL solina_chorus aL, 0.18, 0.6, 6, 0.2
	aR solina_chorus aR, 0.18, 0.6, 6, 0.2

	aL, aR MultiDelay aL, aR, gkswitch3, gkpot7, gkpot7*0.5, 0.5, gkswitch5*0.5

	; Reverb arguments: decay, cutoff, mix
	kRevDecay scale gkpot5, 0.98, 0.8
	aL, aR Reverb aL, aR, kRevDecay, 0.5, gkpot5

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, gkpot6, 0.7, 0.5 ;gkpot2, gkpot3

	; SimpleLooper arguments, rec/play/ovr, stop/start, clear, speed, reverse, through
	aL, aR, kRec,kPlaying SimpleLooper aL, aR, gktoggle1, gktoggle0, 0, gkpot4, gkswitch4, 1
	gkled0 = kPlaying
	gkled1 = gktoggle1


	outs aL, aR

endin

; --------------------------------------------------------
; Status LED - set LEDs to ON for 2 seconds to 
; indicate that Csound is running 
; --------------------------------------------------------

instr 999

k1 poscil 1, 1

gkled0 = k1
gkled1 = k1


endin

</CsInstruments>
<CsScore>
i999 0 2
i99 0 86400
</CsScore>
</CsoundSynthesizer>


