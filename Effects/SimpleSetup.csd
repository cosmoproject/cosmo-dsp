<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b512 -B2048 -j4 --realtime
;-odac -iadc0 -b128 -B512 -m0d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 128
0dbfs	= 1
nchnls 	= 2

#include "UDOs/Reverb.csd"
#include "UDOs/Lowpass.csd"

instr 1 
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"
	#include "includes/switch2led.inc"

	aL, aR ins

	; Lowpass_Stereo arguments: cutoff, resonance
	aL, aR Lowpass aL, aR, 0.6, 0.7, 0.5 ;gkpot2, gkpot3


	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, 0.9, 0.5, 0.2 ; gkpot0, gkpot1, gkswitch0

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


