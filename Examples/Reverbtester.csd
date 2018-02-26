<CsoundSynthesizer>
<CsOptions>
;-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b512 -B2048 -j4 --realtime
-odac -iadc0 -b128 -B512 
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 128
0dbfs	= 1
nchnls 	= 2

#include "../DSP-Library/Includes/cosmo_utilities.inc"

#include "../DSP-Library/Effects/Reverb.udo"
#include "../DSP-Library/Effects/Lowpass.udo"
#include "../DSP-Library/Effects/Distortion.udo"

instr 100 
	#include "../DSP-Library/Includes/adc_channels.inc"
	#include "../DSP-Library/Includes/gpio_channels.inc"

	aL, aR ins

	; Name of pots: gkpotX
	; Name of switches: gkswitchX or gktoggleX
	; Name of LEDs: gkledX
	kPreset = 1
	kLP_mode = 0

	if kPreset == 1 then

		; Lowpass arguments: cutoff, resonance, distortion, mode
		aL, aR Lowpass aL, aR, 0.6, 0.7, 0.5, kLP_mode 

		krev_mode = oscil:k(1,0.2) > 0 ? 1 : 0
		printk2 krev_mode

		; Reverb arguments: decay, cutoff, mix
		aL, aR Reverb aL, aR, 0.9, 0.5, 0.2, krev_mode

	elseif kPreset == 2 then

			; Lowpass arguments: cutoff, resonance, distortion, mode
		aL, aR Lowpass aL, aR, 0.6, 0.7, 0.5 , kLP_mode

	endif


	outs aL, aR

endin


</CsInstruments>
<CsScore>
i100 0 86400
</CsScore>
</CsoundSynthesizer>


