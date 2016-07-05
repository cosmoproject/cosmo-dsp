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

#include "../Effects/UDOs/Reverb.csd"
#include "../Effects/UDOs/Lowpass.csd"
#include "../Effects/UDOs/SolinaChorus.csd"

; --------------------------------------------------------
; Status LED - set LEDs to ON for 3 seconds to 
; indicate that Csound is running 
; --------------------------------------------------------

instr 999

k1 poscil 1, 1

gkled0 = k1
gkled1 = k1


endin


opcode StringSynth, 0, ii

iamp, icps xin


	kampenv = madsr:k(1, 0.1, 0.95, 0.5)
	asig = vco2(0.5, icps)
	asig = moogladder2(asig, 6000, 0.1)

	asig *= kampenv * iamp 

	aL, aR pan2 asig, 0.5

	chnmix aL, "MasterL"
	chnmix aR, "MasterR"

endop


opcode SineSynth1, 0, ii

	iamp, icps xin

	ampenv = madsr:a(1, 0.1, 0.95, 0.5)
	a1 oscil 0.5, icps

	a1 *= ampenv * iamp 

	chnmix a1, "MasterL"
	chnmix a1, "MasterR"
endop


instr 1

	iamp ampmidi 0.8
	icps cpsmidi

	aL init 0
	aR init 0

	aL, aR SineSynth1 aL, aR, iamp, icps*1

	aL, aR SineSynth1 aL, aR, iamp, icps*2.1

	aL, aR SineSynth1 aL, aR, iamp, icps*3.3

	xtratim 2

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

	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, 0.9, 0.5, gkpot6

	; Lowpass arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, gkpot5, 0.7, 0.5 ;gkpot2, gkpot3

	; SimpleLooper arguments, rec/play/ovr, stop/start, clear, speed, reverse, through
	aL, aR SimpleLooper aL, aR, gktoggle1, 0, 0, gkpot4, gkswitch4, 1


	outs aL, aR

endin


</CsInstruments>
<CsScore>
i999 0 3
i99 0 86400
</CsScore>
</CsoundSynthesizer>


