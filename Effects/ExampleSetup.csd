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
#include "UDOs/SquareMod.csd"
#include "UDOs/MultiDelay.csd"

instr 1 
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"
	#include "includes/switch2led.inc"

	gaL, gaR ins

		gadlyL, gadlyR MultiDelay_Stereo gaL, gaR, gkswitch3, gkpot5, gkpot6, 1, gkswitch2

		gaL, gaR Reverb gaL + gadlyL, gaR + gadlyR, gkpot1, gkswitch0
		gaL, gaR SquareMod gaL, gaR, gkpot0, gkswitch1
		gaL, gaR Lowpass_Stereo gaL, gaR, gkpot2, gkpot4
		gaL, gaR Reverb gaL, gaR, 0.8, 0.8, 0.3
		
	outs (gaL + gadlyL), (gaR + gadlyR)

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


