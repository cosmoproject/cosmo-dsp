<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B512 -+rtmidi=alsa -Ma -m0
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

#include "Instruments/StringSynth.csd"
#include "Instruments/SineSynths.csd"
#include "Instruments/Moogish.csd"
#include "Instruments/CrazyPluck.csd"
#include "Instruments/Scanned.csd"
#include "Instruments/Simpler.csd"


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

	xout a1 + ainL, a1 + ainR
endop


instr 1

	iamp ampmidi 0.3
	icps cpsmidi

	aL = 0
	aR = 0

	aL, aR SineSynth1 aL, aR, iamp, icps*1

	;aL, aR Reverb aL, aR, 0.85, 0.5, 0.5

	aL, aR SineSynth1 aL, aR, iamp, icps*2.1

	aL, aR SineSynth1 aL, aR, iamp, icps*3.3

	xtratim 1/kr

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endin


instr 99
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"
	#include "includes/switch2led.inc"

	aL init 0
	aR init 0
	aL chnget "MasterL"
	aR chnget "MasterR"
	a0 = 0
	chnset a0, "MasterL"
	chnset a0, "MasterR"


	aL solina_chorus aL, 0.18, 0.6, 6, 0.2
	aR solina_chorus aR, 0.18, 0.6, 6, 0.2

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


