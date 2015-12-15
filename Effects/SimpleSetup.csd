<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B512
;-odac -iadc0
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

#include "UDOs/Reverb.csd"
#include "UDOs/Lowpass.csd"

instr 1 
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"
	#include "includes/switch2led.inc"

	aL, aR ins

	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, gkpot0, gkpot1, gkswitch0
	; Lowpass_Stereo arguments: cutoff, resonance
	aL, aR Lowpass_Stereo aL, aR, gkpot2, gkpot3

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


