<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024 -j4 --realtime
;-odac -iadc0 -b128 -B512 -m0d
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 64
0dbfs	= 1
nchnls 	= 2

#include "../DSP-Library/Includes/cosmo_utilities.inc"

#include "../DSP-Library/Effects/Reverb.udo"
#include "../DSP-Library/Effects/Lowpass.udo"

instr 1 
	#include "../DSP-Library/Includes/adc_channels.inc"
	#include "../DSP-Library/Includes/gpio_channels.inc"

	aL, aR ins

	; Name of pots: gkpotX
	; Name of switches: gkswitchX or gktoggleX
	; Name of LEDs: gkledX

	; Lowpass arguments: cutoff, resonance, distortion, mode
	aL, aR Lowpass aL, aR, 0.6, 0.7, 0.5, 0

	; Lowpass with optional, named arguments
	Sargs[] fillarray "cutoff", "resosnance"
	kvalues[] fillarray 0.5, 0.7
	aL, aR Lowpass aL, aR, Sargs, kvalues

	; Reverb arguments: decay, cutoff, mix
	aL, aR Reverb aL, aR, 0.9, 0.5, 0.2 
	

	outs aL, aR

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


