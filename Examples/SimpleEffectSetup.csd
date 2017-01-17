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

#include "../DSP-Library/Includes/cosmo_utilities.inc"

#include "../DSP-Library/Effects/Reverb.csd"
#include "../DSP-Library/Effects/Lowpass.csd"

instr 1 
	#include "../DSP-Library/Includes/adc_channels.inc"
	#include "../DSP-Library/Includes/gpio_channels.inc"

	aL, aR ins

	; Name of pots: gkpotX
	; Name of switches: gkswitchX or gktoggleX
	; Name of LEDs: gkledX

	; Lowpass arguments: cutoff, resonance, distortion
	aL, aR Lowpass aL, aR, 0.6, 0.7, 0.5 


	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, 0.9, 0.5, 0.2 
	

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


