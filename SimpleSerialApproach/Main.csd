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

giSine ftgen 0, 0, 4096, 10, 1
#include "UDOs/Reverb.csd"
#include "UDOs/Lowpass.csd"
#include "UDOs/SquareMod.csd"
#include "UDOs/MultiDelay.csd"

instr 1 
	#include "includes/adc_channels.inc"
	#include "includes/gpio_channels.inc"
	#include "includes/switch2led.inc"

	gaL, gaR ins

	kPreGain = 1
	kPostGain = 2

	gaL compress gaL, gaL, -20, 40, 60, 30, 0.1, 0.5, 0.02
	gaR compress gaR, gaR, -20, 40, 60, 30, 0.1, 0.5, 0.02

	gaL pareq gaL, 1500, 6, 0.7, 2
	gaR pareq gaR, 1500, 6, 0.7, 2

	gaL = gaL * kPreGain
	gaR = gaR * kPreGain

	gaL tone gaL, 8000
	gaR tone gaR, 8000

		gadlyL, gadlyR MultiDelay_Stereo gaL, gaR, gkswitch3, gkpot5, gkpot6, 1, gkswitch2*0.75

		gaL, gaR Reverb gaL + gadlyL, gaR + gadlyR, gkpot1, gkswitch0
		gaL, gaR SquareMod gaL, gaR, gkpot0, gkswitch1
		gaL, gaR Lowpass_Stereo gaL, gaR, gkpot2, gkpot4
		gaL, gaR Reverb gaL, gaR, 0.8, 0.8, 0.3
		
	outs (gaL + gadlyL) * kPostGain, (gaR + gadlyR) * kPostGain

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


