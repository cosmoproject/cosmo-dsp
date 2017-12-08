<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -d -+rtaudio=ALSA -b128 -B512 -+rtmidi=alsa -Ma -m0
;-odac -iadc0 -Ma -b128 -B256
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

	#include "../DSP-Library/Includes/cosmo_utilities.inc"	

	#include "../DSP-Library/Effects/Reverb.udo"
	#include "../DSP-Library/Effects/SolinaChorus.udo"


massign 1, 90

	#include "../DSP-Library/Instruments/SineSynth.udo"
	#include "../DSP-Library/Instruments/StringSynth.udo"

instr 1 

	gkatt ctrl7 1, 28, 0, 1
	gkrel ctrl7 1, 29, 0, 1

endin

instr 90

	kmix ctrl7 1, 1, 0, 1

	iamp ampmidi 1
	icps cpsmidi

	aL = 0
	aR = 0
	a2L = 0
	a2R = 0

	aL, aR StringSynth aL, aR, iamp, icps*1, gkatt, gkrel
	aL, aR StringSynth aL, aR, iamp * 0.3, icps*2, gkatt, gkrel
	aL, aR StringSynth aL, aR, iamp * 0.15, icps*3, gkatt, gkrel

	xtratim i(gkrel) 

	aL *= kmix
	aR *= kmix

	a2L, a2R SineSynth a2L, a2R, iamp, icps*1, gkatt, gkrel
	a2L, a2R SineSynth a2L, a2R, iamp, icps*2.1, gkatt, gkrel
	a2L, a2R SineSynth a2L, a2R, iamp, icps*3.3, gkatt, gkrel

	a2L *= (1-kmix)
	a2R *= (1-kmix)

	chnmix aL+a2L, "MasterL"
	chnmix aR+a2R, "MasterR"

endin

instr 99
	#include "../DSP-Library/Includes/adc_channels.inc"
	#include "../DSP-Library/Includes/gpio_channels.inc"

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
	arvbL, arvbR Reverb aL, aR, gkpot0, gkpot1, 1
	
	; Lowpass_Stereo arguments: cutoff, resonance
	;aL, aR Lowpass_Stereo aL, aR, gkpot2, gkpot3

	outs aL + arvbL, aR + arvbR

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
i1 0 86400
i999 0 2
i99 0 86400
</CsScore>
</CsoundSynthesizer>


