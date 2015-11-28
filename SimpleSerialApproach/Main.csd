<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B512
;-odac -iadc0
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps  	= 32
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

	gaL, gaR ins

	gaL, gaR Reverb gaL, gaR, gkpot1
	gaL, gaR SquareMod gaL, gaR, gkpot0, 1

	gaL, gaR MultiDelay_Stereo gaL, gaR, gkswitch0, gkpot5, gkpot6, 0.6, 0.5

	if (gkswitch0 == 1) then
		gkled0 = 1
	elseif (gkswitch0 == 0) then
		gkled0 = 0
	endif

	gaL, gaR Lowpass_Stereo gaL, gaR, gkpot2, gkpot4

	gaL, gaR Reverb gaL, gaR, 0.8, 0.8, 0.3
	
	outs gaL*3, gaR*3  

endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>


